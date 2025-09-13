# Shorty URL Shortener - AI Coding Agent Instructions

## Architecture Overview

This is a Rails 8 URL shortener app using modern tools: Hotwire/Turbo, TailwindCSS, SQLite with Solid adapters, and Kamal deployment.

**Core Flow:**

1. User submits URL → `LinksController#create` saves it → triggers `MetadataJob`
2. Short URLs use custom base-62 encoding via `ShortCode` class (see `/app/models/short_code.rb`)
3. Visits go through `/s/:id` route → `ViewsController#show` → tracks view then redirects
4. Metadata is fetched asynchronously and broadcast via Turbo streams

## Key Patterns & Conventions

### Short Code System

- Uses custom `ShortCode` class for base-62 encoding/decoding (0-9, A-Z, a-z)
- `Link.find(id)` overridden to decode short codes automatically
- `Link#to_param` encodes database IDs to short codes
- Pattern: Always use `Link.find(short_code)` not `Link.find_by(id: decoded_id)`

### Turbo Stream Architecture

- New links are prepended via Turbo Stream in `LinksController#create`
- Metadata updates broadcast to individual links via `MetadataJob`
- Pattern: Use `respond_to` blocks with both HTML and `turbo_stream` formats

### Background Job Pattern

- `MetadataJob` fetches page titles/descriptions after link creation
- Uses `Metadata.retrieve_from(url)` which handles errors gracefully
- Pattern: Jobs update models then broadcast changes via `broadcast_replace_to`

### URL Validation & Security

- Links have basic URL presence validation
- `ViewsController` validates URLs with regex before redirect
- Uses `allow_other_host: true` for external redirects
- Pattern: Always validate URLs before redirecting to prevent abuse

### View Tracking

- Each visit creates a `View` record with IP and user agent
- Views belong to links, deleted when link is destroyed
- Pattern: Track analytics data on actual redirects, not previews

## Development Workflows

### Local Development

```bash
bin/dev                    # Starts Rails server + TailwindCSS watcher
bin/rails console          # Rails console
bin/rails test            # Run test suite
```

### Code Quality

```bash
bin/rubocop               # Ruby style checking (Omakase config)
bin/brakeman              # Security analysis
```

### Deployment

- Uses Kamal for containerized deployment
- Config in `config/deploy.yml` with Docker + SSL via Let's Encrypt
- SQLite storage persisted via Docker volumes
- Pattern: Deploy with `bin/kamal deploy`

## File Organization

### Models

- `Link`: Core model with short code encoding, metadata association
- `View`: Analytics tracking for link visits
- `ShortCode`: Utility class for base-62 encoding/decoding
- `Metadata`: PORO for scraping page titles/descriptions

### Controllers

- `LinksController`: CRUD operations, uses Turbo streams for dynamic updates
- `ViewsController`: Handles short URL redirects and view tracking

### Jobs

- `MetadataJob`: Asynchronous metadata fetching after link creation

## Technology Stack Notes

### Rails 8 Features

- Uses Solid Queue for background jobs (in-Puma via `SOLID_QUEUE_IN_PUMA=true`)
- Solid Cache and Solid Cable for caching and WebSockets
- Propshaft for asset pipeline (not Sprockets)

### Frontend

- Hotwire/Turbo for SPA-like experience without JavaScript frameworks
- Stimulus controllers for interactive elements (clipboard copying)
- TailwindCSS with custom fonts (Fredoka, Young Serif)
- Tippy.js for tooltips

### Data Storage

- SQLite with proper foreign keys and constraints
- No complex migrations - simple schema with links, views, metadata fields

## Common Tasks

### Adding New Features

1. Generate Rails scaffolds as starting point
2. Add Turbo stream responses for dynamic updates
3. Consider background jobs for expensive operations
4. Add appropriate validations and security checks

### Debugging

- Check `log/development.log` for Rails logs
- Use `bin/rails console` for data inspection
- Debug jobs with `bin/rails jobs` status

### Testing

- System tests use Capybara + Selenium
- Model tests cover encoding/decoding and validations
- Test files in `/test/` directory follow Rails conventions
