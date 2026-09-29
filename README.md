# Postgres expand contract

A user starts with one phone number, stored on `users.phone`. Later that has to become many phones, one row each in `user_phones`. Old code still reads and writes `users.phone`. New code reads and writes `user_phones`. Both have to keep working on the same database while the change is in progress.

I built this after that problem stopped being abstract. Designing Data-Intensive Applications describes it. pgroll is one tool that keeps both shapes available. This repo is a small Rails app on local Postgres so I could use the old client and the new client and see the same person.

## One database, two views of it

The tables `users` and `user_phones` live in `public`. Those are the rows.

pgroll also makes two schemas of views. A view is a saved query, not a second copy of the data. `search_path` decides which names a connection can see. Rails opens two connections to the same database URL. The only difference is that path. The names are in `config/pgroll.yml`.

- Old client: `OldUser`, path `public_01_create_users`. It only knows `users.phone`.
- New client: `NewUser` and `UserPhone`, path `public_02_extract_phones`. It uses `user_phones`.

The rule in `migrations/02_extract_phones.yaml` is the business decision: `users.phone` means the `user_phones` row where `is_primary` is true. A second phone is inserted with `is_primary` false, so the old client does not show it. A leading space stays in the string. The trigger copies that exact value. It does not clean it up.

That copy is inside Postgres. Creating a user through the old client does not send a second `INSERT` from Rails. The trigger `users_phone_to_user_phones` writes the primary row. `pgroll_phone.sync` is a flag on that transaction, not a column. It is set so the trigger on the way back does not write `users.phone` again.

## Why the second migration is still open

`migrations/01_create_users.yaml` created the old table. `migrations/02_extract_phones.yaml` is started and not completed. That is the expand step. Both clients still work.

`pgroll complete` would drop `public_01_create_users`. The old client would then have no schema. I left it unfinished on purpose.

## Run it

You need local Postgres with the `pgroll_phone_rails` database, pgroll installed, and migration `02` already started. From this directory:

    bundle install
    bin/rails server

Open http://127.0.0.1:3000. Insert someone through the old client, change that primary phone, then add a second phone through the new client. Play replays that one person.

pgroll created the version schemas. I do not maintain it. This is a local experiment, not a migration I ran for an employer.
