## Quick context

- This is a Ruby on Rails 8 application (Ruby 3.4.5). See `.ruby-version` and `Gemfile`.
- DB: PostgreSQL is recommended (development/test configured for Postgres in this repo).
- JS: importmap + Stimulus + Turbo (no bundler required). See `config/importmap.rb` and `app/javascript/`.
- Assets: Propshaft + CSS built via `sass`/PostCSS scripts defined in `package.json`.
- Realtime: Action Cable channels live in `app/channels/` (example: `ChatsChannel` streams from `"chat_#{chat.id}"`).
- File uploads: Active Storage + `image_processing` (install `libvips` or ImageMagick for variants).

## How to run & common commands (concrete)

- Install gems: `gem install bundler -v 2.6.9 && bundle install --jobs 4`
- DB setup: `bin/rails db:create db:migrate db:seed` (set `DB_USERNAME`/`DB_PASSWORD`/`DB_HOST` if needed)
- Dev server: `bin/dev` (uses `foreman` and `Procfile.dev`) or `bin/rails server`
- Tests: `bin/rails test`
- Rails console: `bin/rails console`
- Lint: `bin/rubocop` (repo includes `rubocop-rails-omakase` and `standard` gems)
- Security scan (dev): `brakeman` is present in the Gemfile for security scanning.

CSS/JS specifics

- CSS build/watch commands are in `package.json`:
  - `yarn build:css` (compile + autoprefix)
  - `yarn watch:css` (used by `Procfile.dev` as `css` process)
- Importmap pins live in `config/importmap.rb`. Stimulus controllers live under `app/javascript/controllers` and are pinned via `pin_all_from`.

Project patterns to follow (concrete examples)

- Controllers: standard Rails controllers are under `app/controllers/`. Use strong params patterns already used by controllers in the repo.
- Pagination: `Pagy` is used (see `ApplicationController` includes `Pagy::Backend`). Use `pagy` helpers in controllers and views.
- Realtime channels: check `app/channels/chats_channel.rb` — the subscription expects `params[:chat_id]` and streams from `"chat_#{id}"`.
- Active Storage: files stored in `storage/` and configured via `config/storage.yml` — run migrations to create attachments.

Integration & deployment notes

- Docker: there is a `Dockerfile` and `kamal` is included in the Gemfile for containerized/declarative deploys.
- Foreman: `bin/dev` launches `foreman start -f Procfile.dev`; `Procfile.dev` defines `web` (Rails) and `css` (yarn watch:css).
- External services: PostgreSQL (DB), optional image processors (`libvips`/ImageMagick) for Active Storage variants.

Where to look first when editing or adding features

- Controllers & endpoints: `app/controllers/`
- Views & partials: `app/views/`
- JS behavior & Stimulus: `app/javascript/`, `config/importmap.rb`
- Realtime behavior: `app/channels/`
- Background jobs & queues: `lib/tasks/` and gems such as `solid_queue` in `Gemfile`

Small examples you can copy

- Add a Stimulus controller: place under `app/javascript/controllers/foo_controller.js`, importmap pins are handled by `pin_all_from` in `config/importmap.rb`.
- Chat subscribe example (from repo): channel param `chat_id` -> stream key `chat_#{chat.id}`.
- Build CSS locally: `yarn build:css`; watch while developing: `yarn watch:css` (or run `bin/dev`).

Editing guidelines for AI changes

- Preserve Rails conventions: routes in `config/routes.rb`, helpers in `app/helpers/`, concerns in `app/controllers/concerns/`.
- When modifying JS, prefer placing Stimulus controllers under `app/javascript/controllers` and update pins only if you add a new package (run `./bin/importmap` if new pins are added).
- For DB changes: add a migration in `db/migrate/` and run `bin/rails db:migrate` in instructions or CI.

If anything in this file is unclear or you'd like more examples (tests, common refactors, or PR checklist), tell me which area to expand and I will update this file.
