# Web Development with Ruby on Rails Tutorial 2019

- URL: <https://memphis-cs.github.io/rails-tutorial-2019/>

## TODO

### HOTFIX

- Annotate annotations are wrong in Demo 8
- Forms in Demo 15 should not have `<br>` after labels

### Dev Env Setup

- Switch to Z Shell and oh-my-zsh and Scott's custom theme
- See if Postgres setup can use login credentials that are not OS user name (use `dotenv` gem w/ `.env` file and `.gitignore`)
- Add `--skip-bundle` (and `--skip-webpack-install`?) when creating new Rails project
- Switch to `rails db:migrate:reset db:seed`

### Changes to App and Demos

- Should do a pages controller or should we do a home controller, about controller, etc.? (I've been seeing the latter mentioned)
- Should we use only `resource` for routes and then `rails routes` to see exactly what's there?
- Should we have a home page that has only a root route like this: `root to: 'home#index'`?
- Should we have only RESTful/resource routes/actions/etc.?
- Should we drop/redo the demo that prints an array (b/c it doesn't seem realistic)?
- Should we introduce styling earlier? For example, we might interleave, adding a new form/feature and then styling the feature.
- Should we actually do something useful with the feedback form? Or drop it?
- Should we do models earlier? (Might enable more interesting frontend features)
- Should we have functional tests earlier?
- We should add requirements/design artifacts.
- Should we use `locals` for all arg passing to views or is it too weird?
- May need to have CSS-to-fix-the-style/layout mini pieces within a demo. Might be a good way to explain all those wee little tweaks we do to the CSS.
- Should we quit using the useless RESTful pages (e.g., `show` often seems unnecessary)? Maybe we could just say everything is a RESTFUL route/action, so you just have to pick the controller and the RESTful action depending on what you need?
- Should we do Quizzes before Questions?

### Missing topics

- Add attributes to Devise user model (e.g., first and last names)
- Image uploads, active storage
- Many-to-many assoc., join table
- JQuery
- AJAX / remote forms
- Adding things to webpacker
- Searching (e.g., for a quiz)
- Pagination (e.g., for quizzes)
- Deploying to Heroku demo
- Bug deets-type pages?
- Deets on Ruby/Rails naming conventions

### Global

- No number unless somehow auto-numbered.
- Lead with goals in earlier demos.
- Shorter demos and more high-level structure
- Look to codify lists of steps for common tasks that can be named and referred back to when used over and over
- Need links to next and previous demos

### Other

- Manage static strings using Rails Internationalization (I18n) API

- Make creating `Quiz` model class and its basic CRUD pages to a separate prereq-type demo

- In general, need worked example general steps to be somehow clearer. Also, need to separate new topics from stuff that just needs built but uses only previously covered topics. Maybe what is needed is a list of tasks that are just what is needed to build the app and a mapping from topics to tasks that makes it easy to distinguish when a new topic is covered vs when the task involves only previously covered material.
