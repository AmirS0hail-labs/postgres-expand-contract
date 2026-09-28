module ApplicationHelper
  TERMS = {
    "search_path" => "How Postgres resolves an unqualified name such as users. It chooses a schema. It is not a second database.",
    "view" => "A stored query, not a second copy of the rows. The client schemas hold views that select from the real tables in public.",
    "schema" => "A namespace inside this one database. public holds the real tables. The client schemas hold views.",
    "public" => "The schema that holds the real tables users and user_phones. The rows are stored once.",
    "public_01_create_users" => "The old client's schema. It has one view, users, defined as SELECT id, name, phone FROM users.",
    "public_02_extract_phones" => "The new client's schema. It has views users and user_phones.",
    "old client" => "Code that still stores one phone on the user. It uses public_01_create_users.",
    "new client" => "Code that stores each phone as its own row. It uses public_02_extract_phones.",
    "OldUser" => "The old client. It sets search_path to public_01_create_users, so users means that view.",
    "NewUser" => "The new client for users. It sets search_path to public_02_extract_phones.",
    "UserPhone" => "The new client for user_phones. It sets search_path to public_02_extract_phones.",
    "is_primary" => "Marks the user_phones row that users.phone means. A row with is_primary false is visible only on the new client.",
    "users.phone" => "The phone the old client sees. It is the user_phones row where is_primary is true.",
    "users_phone_to_user_phones" => "A trigger on public.users. After an old-client write, it copies that exact string, including a leading space, onto the primary user_phones row only.",
    "user_phones_to_users_phone" => "A trigger on public.user_phones. A non-primary row returns without updating users.phone. A primary row writes users.phone.",
    "pgroll_phone.sync" => "A transaction-local flag, not a column. Set to '1' when a primary write would bounce back. The other trigger sees '1' and runs no further SQL.",
    "user_phones_one_primary" => "A unique index on user_phones. It allows one primary row per user.",
    "pgroll complete" => "Would drop public_01_create_users. OldUser would then have no schema to use."
  }.freeze

  def term(key, code: true)
    name = key.to_s
    text = TERMS.fetch(name)
    tip_id = "term-#{name.parameterize}-#{SecureRandom.hex(2)}"

    tag.span(class: "term") do
      concat(tag.span(class: "term-label", tabindex: "0", aria: { describedby: tip_id }) do
        concat(code ? tag.code(name) : name)
      end)
      concat(tag.span(text, id: tip_id, class: "term-tip", role: "tooltip"))
    end
  end
end
