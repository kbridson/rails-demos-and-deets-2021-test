# Ruby on Rails Demos 'n' Deets, Spring 2021 Edition

- URL: <https://human-se.github.io/rails-demos-n-deets-2021/>

## TODO

### About/Global

- Introduce functional testing early so that for every change made to the app it is possible to run tests to ensure no syntax errors (at the least).
- List design principles
- Principle of explicit args for learning
- Should we have only RESTful/resource routes/actions/etc.? If so, could possibly use only `resource` routes?
  - Should we quit using the useless RESTful pages (e.g., `show` often seems unnecessary)? Maybe we could just say everything is a RESTFUL route/action, so you just have to pick the controller and the RESTful action depending on what you need?
- We should add requirements/design artifacts.
- Principle: Lead with goals of demo.
- Principle: Shorter demos and more high-level structure
- Principle?: Codify lists of steps for common tasks that can be named and referred back to when used over and over
- In general, need worked example general steps to be somehow clearer. Also, need to separate new topics from stuff that just needs built but uses only previously covered topics. Maybe what is needed is a list of tasks that are just what is needed to build the app and a mapping from topics to tasks that makes it easy to distinguish when a new topic is covered vs when the task involves only previously covered material.
- Add [StimulusReflex](https://docs.stimulusreflex.com/) to the demos?

### Getting Started

- Windows terminal starts in non-home directory? Need instructions about running `cd` to get to home directory.
- Linux required reboot to make chsh take effect.
- Set tabs to 2 spaces in vscode.
- Add instructions about pgAdmin 127.0.0.1 thing? localhost doesn't work for some Windows users.
- Add `--skip-bundle` (and `--skip-webpack-install`?) when creating new Rails project

### Simple Web Pages and Forms

- Should do a pages controller or should we do a home controller, about controller, etc.? (I've been seeing the latter mentioned)
- Add some HTML tag specific demos, like `table`? Or maybe just have deets page on all the HTML we use in the demos?
- Add `title` demo in mostly static pages
- Should we have a home page that has only a root route like this: `root to: 'home#index'`?
- Drop/redo the demo that prints an array (b/c it doesn't seem realistic). Maybe instead make it pass something random?
- Drop/redo the simple forms demo because there is too much accidental complexity in it. Also, it doesn't actually do anything.
- Delay simple forms until after models?
- Should we introduce styling earlier? For example, we might interleave, adding a new form/feature and then styling the feature.
- Should we have functional tests earlier?

### Model Basics

- Link to index from home page
- Link from index to show page (current done in the resources part)
- Reduce form complexity in index and show demo

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
- Internationalization: Manage static strings using Rails Internationalization (I18n) API?
