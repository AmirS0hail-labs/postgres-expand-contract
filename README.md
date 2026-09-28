# Postgres expand contract

I started from a schema change where one `users.phone` value has to become many rows in `user_phones`, while old and new code still read and write the same database.

This repo is where I ran that change with pgroll and a small Rails app, so I could see both clients instead of only reading about the tool.

The old client is `OldUser`. It uses search_path `public_01_create_users` and reads `users.phone`. The new client is `NewUser` and `UserPhone`. It uses `public_02_extract_phones` and reads `user_phones`. `users.phone` is the row where `is_primary` is true. The schema names live in `config/pgroll.yml`.

The pgroll files are `migrations/01_create_users.yaml` and `migrations/02_extract_phones.yaml`. `02` is started and not completed, so both versions stay up. `complete` would drop the old version schema.

Postgres is already running with the `pgroll_phone_rails` database. From this directory: `bundle install`, then `bin/rails server`, then open http://127.0.0.1:3000.

On the home page I can insert a user through the old client, update that primary phone, and add a second non-primary phone through the new client. A leading space stays in the string. The old client still shows only the primary phone. Play replays that one person.
