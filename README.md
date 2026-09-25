# pgroll phone

I started from a schema change where one `users.phone` value has to become many rows in `user_phones`, while old and new code still read and write the same database.

This repo is where I ran that change with pgroll and a small Rails app, so I could see both clients instead of only reading about the tool.

The old client uses search_path `public_01_create_users` and reads `users.phone`. The new client uses `public_02_extract_phones` and reads `user_phones`. `users.phone` is the row where `is_primary` is true.

The pgroll files are `migrations/01_create_users.yaml` and `migrations/02_extract_phones.yaml`. `02` is started and not completed, so both versions stay up. `complete` would drop the old version schema.

Postgres is already running with the `pgroll_phone_rails` database. From this directory: `bundle install`, then `bin/rails server`, then open http://127.0.0.1:3000.

On the home page I can insert a user through the old client, add a second non-primary phone through the new client, and see that the old client still shows only the primary phone.
