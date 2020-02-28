---
title: 'Automatically Annotating Model Code'
---

# {{ page.title }}

In this demonstration, I will show how to set up the [Annotate](https://github.com/ctran/annotate_models){:target="_blank"} gem to automatically add comments to Rails model classes and other related files. We will continue to build upon the [QuizMe project](https://github.com/human-se/quiz-me-2020){:target="_blank"} from the previous demos.

Something that is inconvenient about Rails model classes is that their class attributes are not defined (or otherwise visible) in their class definitions. For example, if you inspect the `McQuestion` model class in `app/models/mc_question.rb`, you will find only the following:

```ruby
class McQuestion < ApplicationRecord
end
```

This class definition makes no mention of the class attributes, because Rails automatically adds model class attributes based the database schema defined in the `db/schema.rb` file.

Fortunately, the Annotate gem can help! In particular, it can be set up to automatically add comments into your model files every time you migrate the database. For example, it would add the following comments to the `McQuestion` model class:

```ruby
# == Schema Information
#
# Table name: mc_questions
#
#  id           :bigint           not null, primary key
#  answer       :string
#  distractor_1 :string
#  distractor_2 :string
#  question     :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class McQuestion < ApplicationRecord
end
```

Notice how all of the model classes attributes and their types are now listed in a generated comment at the top of the file.

## 1. Setting Up the Annotate Gem

First, add the Annotate gem to your project by adding the following lines to the bottom of your `Gemfile`:

```ruby
# Adds model attributes/routes to top of model files/routes file
gem 'annotate', group: :development
```

Next, install the Annotate gem by running the following command:

```bash
bundle install
```

Finally, generate a [Rake](https://en.wikipedia.org/wiki/Rake_(software)){:target="_blank"} task (essentially a plugin to `rails`) that will automatically annotate your files every time you run `rails db:migrate` by running the following command:

```bash
rails g annotate:install
```

Note that the Rake task that was generated, `lib/tasks/auto_annotate_models.rake`, contains a number of settings that you can customize; however, for our purposes, the default settings will suffice.

**[{% octicon git-commit height:24 class:"right left" aria-label:hi %} Code changeset for this part](https://github.com/human-se/quiz-me-2020/commit/114d2c22216769f649596e53b30ec4090567ef0d){:target="_blank"}**

## 2. Annotating the Existing Model Class

Annotate the model class we already have by running the following command:

```bash
rails db:migrate:reset
```

The above attribute comments should now have been added to the `mc_questions.rb` file as well as to the `McQuestion`-related model testing files.

From now on, whenever we create new database migrations and run `rails db:migrate`, the Annotate gem will automatically insert comments into the relevant model class files—how convenient!

**[{% octicon git-commit height:24 class:"right left" aria-label:hi %} Code changeset for this part](https://github.com/human-se/quiz-me-2020/commit/90b224f4d6edfacb0bf6202d2e9e13cb1213e5c2){:target="_blank"}**

{% include pagination.html prev_page='demo-model-classes.md' next_page='demo-db-seeds.md' %}
