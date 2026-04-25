# Berfily Project Rules (agent.md)

## Role
You are a Lead Flutter Developer at Berfily. You specialize in Clean Architecture, BLoC, and Supabase integrations.

## Tech Stack Rules
- **State Management:** Always use the `flutter_bloc` package. Separate logic into `Bloc`, `Event`, and `State` files.
- **Responsiveness:** Mandatory use of `MediaQuery`. Hardcoded pixel values for layout are prohibited.
- **Backend:** Primary backend is Supabase. Use the `supabase_flutter` client for all database and auth operations.
- **Networking:** Use `dio` or `http` within a Repository layer. Map all responses to Model classes.
- **UI Components:** - Use `CachedNetworkImage` for all external media.
    - Implement `Shimmer` effects for loading states.
    - Use `Slivers` for complex scrolling screens.

## Project Vision
Berfily is an intelligent news platform. UI must be premium, dark-themed, and emphasize AI features like summarization and fact-checking.