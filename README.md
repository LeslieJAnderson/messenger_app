# README #

Versions:
```
$ ruby --version
ruby 2.5.1p57
$ sqlite3 --version
3.28.0
$ rails --version
Rails 6.0.3.6
```
Ruby 2.5.1 is unideal as it's nearing End Of Life, but my current company runs a bit behind on versions so that's what I was working in when I started this assigment. Ideally I'd update to a newer version, but I think I've tiptoed past the 4 hour mark so I'll punt that as a "nice to have."

## Useful Commands ##

Start rails app:

```
$ cd messenger_api
$ rails server
```
Run tests in `messenger_api/spec`:
```
$ cd messenger_api
$ rspec
```

Run tests and generate documentation from `messenger_api/spec/acceptance`:
```
$ cd messenger_api
$ rake docs:generate
# You can view the HTML output in messenger_api/doc/api/index.html
```
Documentation was precompiled and can be found in `api/doc/api/index.html`

List all routes (GET, POST, etc) in your rails application within Console from `messenger_api`:

```
$ rails routes
```

Run database migrations from `messenger_api/db/migrate`:
```
$ cd messenger_api
$ bin/rake db:migrate
```
Use the following to run queries directly against your database: https://github.com/pawelsalawa/sqlitestudio/releases


* After you install it, open it, click Database > Add a database, then for the file, select the following from this repo's folder: `messenger_api/db/development.sqlite3`

If you want to trash your database and start fresh, delete `api/db/development.sqlite3` and `api/db/test.sqlite3` then re-run rake `db:migrate`.

To seed your `development.sqlite3` database with records from `api/db/seeds.rb`, run:

```
$ rake db:seed
```

Start rails console:
```
$ rails c
```
Run ruby commands off of the models to create records (etc):
```
User.create!(username: "LindaBelcher")

Message.create!(from_user_id: "1", to_user_id: "3", created_at: Time.now - 16.days, content: "When I die I want you to cremate me and throw me in Tom Selleck's face.")
```