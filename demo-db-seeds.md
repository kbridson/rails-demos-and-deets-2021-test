---
title: 'Seeding the Database'
---

# {{ page.title }}

In this demonstration, I will show how to add seed data to the app's database. We will continue to build upon the [QuizMe project](https://github.com/human-se/quiz-me-2020){:target="_blank"} from the previous demos.

In particular, we will update the QuizMe app such that the database can be initially seeded with three sample multiple-choice questions. Having such seed data available is useful for manually testing the app during development.

## 1. Adding Seed Multiple-Choice Questions to the Database

First, declare a few sample questions in the `db/seeds.rb` file, like this:

```ruby
q1 = McQuestion.create!(
    question: 'What does the M in MVC stand for?',
    answer: 'Model',
    distractor_1: 'Media',
    distractor_2: 'Mode'
)

q2 = McQuestion.create!(
    question: 'What does the V in MVC stand for?',
    answer: 'View',
    distractor_1: 'Verify',
    distractor_2: 'Validate'
)

q3 = McQuestion.create!(
    question: 'What does the C in MVC stand for?',
    answer: 'Controller',
    distractor_1: 'Create',
    distractor_2: 'Code'
)
```

The `create!` method is part of the Rails model API, and when executed, it has the effect of creating the corresponding model object (in this case `McQuestion` objects) and saving the object to the database.

The Rails API actually offers both a [`create` (with no `!`)](https://api.rubyonrails.org/v6.0.0/classes/ActiveRecord/Persistence/ClassMethods.html#method-i-create){:target="_blank"} version and a [`create!` (with a `!`)](https://api.rubyonrails.org/v6.0.0/classes/ActiveRecord/Persistence/ClassMethods.html#method-i-create-21){:target="_blank"} version of the method. These two versions are essentially the same, except they behave differently when saving to the database fails. In particular, the `create!` version throws an exception if saving fails, whereas the `create` version does not.

**Caution!** The reason that we use the exception-throwing `create!` version in the `seeds.rb` script is so that we will see an error message if a record fails to save to the database. In contrast, if we were to use the `create` (with no `!`) version of the method, the script would fail silently, and that can create a lot of confusion for us regarding why certain records are mysteriously missing from the database.

Next, execute the `seeds.rb` script by running this command:

```bash
rails db:seed
```

Finally, verify that the records were added to the database by using pgAdmin to navigate as follows, starting from the sidebar:

`Servers` > `SoftwareEng` > `Databases` > `quiz_me_development` > `Schemas` > `public` > `Tables` > (right-click) `mc_questions` > `View/Edit Data` > `All Rows`

You should see the three seed records, as depicted in Figure 1.

{% include image.html file="pgadmin-seed-mc-questions.png" alt="A table of data from the database that contains the three seeded multiple-choice question records" caption="Figure 1. The seeded multiple-choice questions, as visualized in pgAdmin." %}

We have now set up our app such that we can add seed data whenever we reset the database. As we evolve our model in future demos, we will continue to add new seed data, so when we manually test the app, we won't have to manually enter in all our test data every time.

**[➥ Code changeset for this part](https://github.com/human-se/quiz-me-2020/commit/4094ae4b0e7278565430ac5fa8494e16676e1f7c){:target="_blank"}**

{% include pagination.html prev_page='demo-annotate.md' next_page='demo-model-index.md' %}
