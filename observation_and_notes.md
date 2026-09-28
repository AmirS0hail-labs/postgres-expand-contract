**while i am doing the step myself some notes and thoughts**

- Step 1:
  - Okay, now I'm doing this step 1, So what I understand is The term view is used for like tables like in when it say like the old schema has one view users it is like equivalent to saying like the old schema has one table a users table and the new view has users and user phones view or tables, right?
  - Okay, when I review the like YML file, the 02 extract from YML file basically. So compared to JSON, it is easier to read. Now I can see like there are create function and create triggers. Create functions are basically like function written in SQL, which do certain actions, certain manipulation on the view or the attributes and the triggers or like we can call sort of effect after any update or create happen on certain tables we identify, then the triggers or called afterward.
  - What I find interesting is like, okay, the like the normalization part, like phone number can have space in it. So after like going up and registering that phone as phone number and let's say the validation has trimmed this space in the phone number. Then after it goes back, how it's that persisted like in while going back the space is still there. How it's handled by this this tool.?
- Step 2:
  - when we say 'That connection's `search_path` is `public_01_create_users`' Like what does it mean? Like right now I'm like trying old user dot find to it shows me the user below and his detail but when we say like his search path is like the public zero one creator what does it mean is this related to pg role how it work?
    - i am seeing these `SET search_path TO public_01_create_users /*application='PgrollPhone'*/` and ``SET search_path TO public_02_extract_phones /*application='PgrollPhone'*/ But like what does this do when inside the real console we like use the command connection dot schema search path as these related to like Postgres and SQL or these are pg-ro-ro-ro related things
- Step 3:
  - ++we dont see second++ `INSERT` ++in the Rails console when execuiting created = *OldUser*.create!(name: "Nadia", phone: " 0300-444") without calling UserPhone.create, this is very intresting and important.++
- Step 4:
  - Using the isPrimary is sort of like check which keep this forward and backward compatibility At least that's what I'm thinking while doing step 4 Because we have ?this isPrimary true in the new phones table So the initial user.phones column the value pick from that is used as primary If that was not there I'm not sure it would have been possible to have this forward and backward compatibility
- Step 5:
  - `pgroll_phone.sync` to `'1'` is important in all these steps but one that i am yet to gasp
- 

