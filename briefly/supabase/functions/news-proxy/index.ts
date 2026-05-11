// @ts-nocheck
import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { GoogleGenerativeAI } from "https://esm.sh/@google/generative-ai@0.21.0";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.7";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const body = await req.json();
    const { action, category: targetCategoryParam, language = "en", id, content } = body;

    const GEMINI_API_KEY = Deno.env.get("GEMINI_API_KEY");
    const GNEWS_API_KEY = "2965ac7118edb35284e62a545c9faf56"; 
    const SUPABASE_URL = Deno.env.get("SUPABASE_URL");
    const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

    const supabase = createClient(SUPABASE_URL!, SUPABASE_SERVICE_ROLE_KEY!);

    // --- ACTION: Summarize ---
    if (action === "summarize") {
      try {
        const genAI = new GoogleGenerativeAI(GEMINI_API_KEY);
        const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash" });
        const result = await model.generateContent(`Summarize into 3 bullet points: ${content}`);
        return new Response(JSON.stringify({ summary: result.response.text().trim() }), {
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        });
      } catch (e) {
        return new Response(JSON.stringify({ summary: "⚡ Briefing offline." }), {
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        });
      }
    }

    // 1. HELPER: Fetch and Process News (V21 - Batch AI Categorization)
    const fetchAndProcessNews = async (targetCategory: string, isHot = false) => {
      let countryParam = "";
      let gCategoryParam = "general";

      const categoryMap = {
        "Business": "business", "Technology": "technology", "Entertainment": "entertainment",
        "Sports": "sports", "Science": "science", "Health": "health", "World": "world",
      };

      if (targetCategory === "Egypt") {
        countryParam = "&country=eg";
      } else if (categoryMap[targetCategory]) {
        gCategoryParam = categoryMap[targetCategory];
      }

      const fetchWithWindow = async (hours: number) => {
        const fromTime = new Date(Date.now() - hours * 60 * 60 * 1000).toISOString().split('.')[0] + 'Z';
        let gnewsUrl = "";
        if (isHot) {
          const query = targetCategory === "All" ? "world news today" : `${targetCategory} news`;
          gnewsUrl = `https://gnews.io/api/v4/search?q=${encodeURIComponent(query)}&token=${GNEWS_API_KEY}&lang=${language}&max=12&sortby=publishedAt&from=${fromTime}`;
        } else {
          gnewsUrl = `https://gnews.io/api/v4/top-headlines?token=${GNEWS_API_KEY}&lang=${language}${countryParam}&category=${gCategoryParam}&max=12`;
        }
        const response = await fetch(gnewsUrl);
        const data = await response.json();
        return { ok: response.ok, data };
      };

      let { ok, data } = await fetchWithWindow(isHot ? 24 : 48);
      if (ok && (!data.articles || data.articles.length === 0) && isHot) {
        const retry = await fetchWithWindow(72);
        ok = retry.ok;
        data = retry.data;
      }

      if (!ok || data.errors) throw new Error("GNews Load Error");

      const articles = data.articles || [];
      
      // BATCH AI CATEGORIZATION (Single Call)
      let categoryMapResults = {};
      if (targetCategory === "All" || targetCategory === "Egypt") {
        try {
          const genAI = new GoogleGenerativeAI(GEMINI_API_KEY);
          const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash" });
          const headlines = articles.map((a: any, i: number) => `${i}: ${a.title}`).join("\n");
          const prompt = `Categorize each of these headlines into EXACTLY ONE: POLITICS, BUSINESS, TECH, SPORTS, ENTERTAINMENT, SCIENCE, HEALTH, or CRIME. Output as a comma-separated list of category names only, matching the order. Headlines:\n${headlines}`;
          const result = await model.generateContent(prompt);
          const labels = result.response.text().split(',').map(s => s.trim().toUpperCase().replace(/[^\w]/g, ''));
          labels.forEach((label, i) => { categoryMapResults[i] = label; });
        } catch (e) { console.error("AI Batch Fail", e); }
      }

      const processed = articles.map((a: any, i: number) => {
        let finalType = categoryMapResults[i] || (targetCategory !== "All" && targetCategory !== "Egypt" ? targetCategory.toUpperCase() : "WORLD");

        // Keyword Fallback (Always active for precision)
        const t = a.title.toLowerCase();
        if (t.includes('soccer') || t.includes('football') || t.includes('goal') || t.includes('league')) finalType = "SPORTS";
        else if (t.includes('stock') || t.includes('market') || t.includes('bank') || t.includes('profit')) finalType = "BUSINESS";
        else if (t.includes('iphone') || t.includes('ai') || t.includes('tech') || t.includes('apple')) finalType = "TECH";
        else if (t.includes('movie') || t.includes('actor') || t.includes('singer')) finalType = "ENTERTAINMENT";

        return {
          id: `gnews_${isHot ? 'hot' : 'reg'}_${Date.now()}_${i}`,
          category: finalType,
          title: a.title.split(' - ')[0].split(' | ')[0].trim(),
          urlToImage: a.image || "",
          publishedAt: a.publishedAt,
          source: a.source?.name || "GNews",
          content: a.description || a.title || "No description provided.",
          url: a.url || "",
          trendingScore: isHot ? 9.8 - (i * 0.1) : 8.5 - (i * 0.2),
        };
      });

      // Cache V21
      const cacheKey = `news_v21_${targetCategory || "all"}_${isHot ? "hot" : "reg"}`;
      await supabase.from("news_cache").upsert({ id: cacheKey, category: targetCategory || "all", data: processed, updated_at: new Date().toISOString() });

      return processed;
    };

    // --- ACTION: Scrape full article content ---
    if (action === "scrapeArticle") {
      const { url } = body;
      if (!url) return new Response(JSON.stringify({ content: "" }), { headers: { ...corsHeaders, "Content-Type": "application/json" } });

      try {
        const res = await fetch(url, {
          headers: { "User-Agent": "Mozilla/5.0 (compatible; Briefly/1.0)" },
          signal: AbortSignal.timeout(8000),
        });
        const html = await res.text();

        // Extract text from <p> tags
        const paragraphs: string[] = [];
        const pRegex = /<p[^>]*>([\s\S]*?)<\/p>/gi;
        let match;
        while ((match = pRegex.exec(html)) !== null) {
          const text = match[1]
            .replace(/<[^>]+>/g, '')       // strip inner tags
            .replace(/&amp;/g, '&')
            .replace(/&lt;/g, '<')
            .replace(/&gt;/g, '>')
            .replace(/&quot;/g, '"')
            .replace(/&#39;/g, "'")
            .replace(/&nbsp;/g, ' ')
            .replace(/\s+/g, ' ')
            .trim();
          if (text.length > 40) paragraphs.push(text);  // skip nav/caption noise
        }

        const fullContent = paragraphs.join('\n\n');
        return new Response(
          JSON.stringify({ content: fullContent.length > 200 ? fullContent : "" }),
          { headers: { ...corsHeaders, "Content-Type": "application/json" } }
        );
      } catch (e) {
        return new Response(JSON.stringify({ content: "" }), { headers: { ...corsHeaders, "Content-Type": "application/json" } });
      }
    }

    // --- ACTION: Get article by ID (find in cache + scrape full content) ---
    if (action === "getArticleById" && id) {
      // Search all cache entries for the article
      const { data: allCaches } = await supabase.from("news_cache").select("data");
      let foundArticle: any = null;
      for (const cache of (allCaches || [])) {
        const articles = cache.data as any[];
        const match = articles?.find((a: any) => a.id === id);
        if (match) { foundArticle = match; break; }
      }

      if (!foundArticle) {
        return new Response(JSON.stringify([]), { headers: { ...corsHeaders, "Content-Type": "application/json" } });
      }

      // Scrape full content if URL available
      if (foundArticle.url) {
        try {
          const res = await fetch(foundArticle.url, {
            headers: { "User-Agent": "Mozilla/5.0 (compatible; Briefly/1.0)" },
            signal: AbortSignal.timeout(8000),
          });
          const html = await res.text();
          const paragraphs: string[] = [];
          const pRegex = /<p[^>]*>([\s\S]*?)<\/p>/gi;
          let match;
          while ((match = pRegex.exec(html)) !== null) {
            const text = match[1]
              .replace(/<[^>]+>/g, '')
              .replace(/&amp;/g, '&').replace(/&lt;/g, '<').replace(/&gt;/g, '>')
              .replace(/&quot;/g, '"').replace(/&#39;/g, "'").replace(/&nbsp;/g, ' ')
              .replace(/\s+/g, ' ').trim();
            if (text.length > 40) paragraphs.push(text);
          }
          const fullContent = paragraphs.join('\n\n');
          if (fullContent.length > 200) foundArticle = { ...foundArticle, content: fullContent };
        } catch (e) { /* use original content */ }
      }

      return new Response(JSON.stringify([foundArticle]), { headers: { ...corsHeaders, "Content-Type": "application/json" } });
    }

    const isHot = body.isHot === true;
    const category = targetCategoryParam || "All";
    const cacheKey = `news_v21_${category}_${isHot ? "hot" : "reg"}`;
    const { data: cacheEntry } = await supabase.from("news_cache").select("*").eq("id", cacheKey).single();
    if (cacheEntry && new Date(cacheEntry.updated_at) > new Date(Date.now() - 10 * 60 * 1000)) {
      return new Response(JSON.stringify(cacheEntry.data), { headers: { ...corsHeaders, "Content-Type": "application/json" } });
    }

    const news = await fetchAndProcessNews(category, isHot);
    return new Response(JSON.stringify(news), { headers: { ...corsHeaders, "Content-Type": "application/json" } });

  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } });
  }
});
