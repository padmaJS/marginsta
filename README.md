# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)
# Marginsta (Rails Instagram Clone)

This repository is a Rails 8 application scaffold for an Instagram-like app.

Quick overview
- **Ruby:** `ruby-3.4.5` (see `.ruby-version`)
- **Rails:** `~> 8.0.2`
- **DB:** PostgreSQL recommended (development/test currently configured for Postgres)
- **JS:** Importmap + Stimulus + Turbo (no Node bundler required)

Local development setup

1. Install system dependencies (Debian/Ubuntu example):

```bash
sudo apt update
sudo apt install -y build-essential libssl-dev libreadline-dev zlib1g-dev libvips-dev imagemagick
```

If you want to use PostgreSQL (recommended for production-like behavior), install Postgres:

```bash
sudo apt install -y postgresql postgresql-contrib libpq-dev
sudo -u postgres createuser --superuser $USER || true
sudo -u postgres createdb marginsta_development || true
```

2. Install Ruby 3.4.5 (use your preferred manager, e.g. `rbenv`, `rvm`, or `asdf`).
	 Example with `rbenv`:

```bash
# install rbenv (one-time); follow rbenv docs for shell setup
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
cd ~/.rbenv && src/configure && make -C src
# then install ruby-build
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
# install Ruby
RUBY_VERSION=3.4.5
rbenv install "$RUBY_VERSION"
rbenv local "$RUBY_VERSION"
```

3. Install Bundler and gems:

```bash
gem install bundler -v 2.6.9
bundle install --jobs 4
```

4. Prepare the database and storage directory:

```bash
mkdir -p storage
bin/rails db:migrate
# optionally load seeds if present
bin/rails db:seed
```

If using Postgres and you changed DB credentials, set the `DB_USERNAME`, `DB_PASSWORD`,
`DB_HOST`, and `DB_PORT` environment variables before running migrations. Example:

```bash
export DB_USERNAME=your_db_user
export DB_PASSWORD=your_db_password
export DB_HOST=localhost
bin/rails db:create db:migrate
```

5. Get Ollama3.2 from official site

6. Start the dev server:

```bash
bin/dev
# or
bin/rails server
```

Notes on features and next steps
- Authentication: not included yet — common choice is `devise`. We can add simple auth
	with `has_secure_password` or scaffold `devise` depending on your preference.
- File uploads: the app uses Active Storage for attachments. To enable image variants
	install the `image_processing` gem and a system image processor (`libvips` or
	ImageMagick).
- Real-time chats: use Action Cable (built-in) or third-party services if you prefer.
- Frontend: importmap + Stimulus controllers are present in `app/javascript`.

Common commands
- Run tests: `bin/rails test`
- Run console: `bin/rails console`
- Run RuboCop: `bin/rubocop`

If you want, I can:
- add authentication (Devise or has_secure_password) and a `User` model
- scaffold `Post` with Active Storage attachments and basic feed UI
- add `Comment` and `Like` models and controllers
- scaffold private chat (Action Cable) prototype

Tell me which feature you'd like to build first and I will start implementing it
or walk you through the steps interactively.
