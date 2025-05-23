# Task 1 - Delta
this is a blog server built for Delta force induction tasks

### Containers
- blogs/app
    here every user (user, author, mod or admin) exists. all scripts are here
- blogs/mysql
    contains mysql db of users and blogs db. this is in same network as all other containers so app container can query the db
- blogs/phpmyadmin
    has exposed 8081:443 port. receives https traffic directly and provides gui for mysql db
- blogs/nginx
    has exposed 443:443 port. receives https traffic and reads blog files (based on header `Host: <authorname>.blog.in`)

### Setup
- clone the repo
- docker compose up --build
- app container starts only after db is healthy (healthcheck is `mysqladmin ping`)
- app container /home and /scripts is persisted. it calls scripts to populate users, setup all blogs, setup mods etc. it also calls populate db users which fills users table if mysql is running
- other containers are self-explainatory (checkout nginx conf and sql migration file)

### Workflow of App Container Scripts

- `populate` creates users admins mods and authors from users.yaml
- `genocide` deletes all users admins mods and authors
- `mods_setup` gives mods permission to specific authors based on users.yaml
- `all_blogs_setup` creates symlink from `/home/authors/*/public` to `/home/users/*/all_blogs/{author_name}`

- `cblog` used by users to view blogs. this adds read logs to `~/blog_reads.yaml`
- `blog` used by authors to manage blogs. -h for help. can create new blog file (new file at ~/blogs), publish (symlink to ~/public), toggle subscribers only feature, archive a blog or delete a blog
- `censor` used by mods to monitor blogs. replaces bad words (blacklist.txt) with asterisk and archives the blog with mod_comment incase of 5+ bad words
- `subscribe` used by users to subcribe to authors. adds log to `subscriptions.yaml` and symlinks to `author:~/subscribers_only` to `user:~/subscribed_blogs/{authorname}`

when authors toggle subscribe only for a blog, it sends notifs to all subscribed users and appends to `user:~/notifcations.log`

- `view_notifs` used by users to see notifications. moves the `new_notifs` to the end of the notifications.log

- `promote` used by users to request to become authors. adds their username in `requests.yaml`
- `promote_respond` used by admins to respond to promote requests. approve/reject requests. on approving, /home/users/uname is moved to /home/authors and relevant dirs are created for being an author

- `make_fyi` generates for you blogs for all users based on categories of all existent public blogs and puts them at `user:~/fyi.yaml`

- `gen_report` generates reports of existent public blogs, sorted by reads and category wise

- `notif_server` runs as a daemon (bg). infinite loop receiving author subscriber only blog creation. adds notifs to users' ~/notifications.log

- `notifs_checker` runs on shell creation (.bashrc and /etc/profile) and notifes for new unread notifications

- `schedule_reports_filter` exit 1 if curr day is not 1st or last friday of the month. used in cron job to gen_reports

