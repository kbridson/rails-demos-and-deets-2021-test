---
title: 'Creating a Model Class and Seeding the Database'
section: Model Basics
lesson: 1
---

# {{ page.title }}

In this demonstration, I will show how to create model classes to store and manage data in the database. We will continue to build upon the [QuizMe project](https://github.com/human-se/quiz-me-2020){:target="_blank"} from the previous demos.

Since we are building a quizzing application, we will need to store questions in the database. At first, the app will only allow multiple choice questions but in a later demo we will see that it's pretty easy to add other kinds of questions too (e.g., fill in the blank). For multiple choice questions, we need to store the question, answer, and a couple of incorrect options (_distractors_). Figure 1 shows the corresponding class diagram.

{% include image.html file="mc-question-model-class.svg" alt="A UML class diagram depicting the McQuestion model class" caption="Figure 1. The `McQuestion` model class." %}

## 1. Creating the `McQuestion` Model Class

First, generate the `McQuestion` model class shown in the above class diagram by running the following command:

```bash
rails generate model McQuestion question:string answer:string distractor_1:string distractor_2:string
```

This command generates several key files:

- `app/models/mc_question.rb`: The Rails model class.
- `db/migrate/20190926192541_create_mc_questions.rb`: The database migration that is used to set up the database schema (timestamp will vary based on creation time).
- `test/models/mc_question_test.rb`: [Unit test](https://en.wikipedia.org/wiki/Unit_testing){:target="_blank"} code skeleton where tests for the models can be defined.
- `test/fixtures/mc_questions.yml`: [Test fixtures](https://en.wikipedia.org/wiki/Test_fixture){:target="_blank"} skeleton where `McQuestion` objects for use in the tests can be defined.

Next, set up the `mc_questions` table in the database and regenerate the `db/schema.rb` file, which holds the Rails app's representation of the database, by running the following command:

```bash
rails db:migrate
```

Finally, confirm that the database was set up correctly by

- inspecting the `db/schema.rb` file to see that the `mc_questions` table is defined correctly, and
- inspecting the Postgres database `quiz_me_development` with pgAdmin to see that `mc_questions` table is present and that its columns are correct by navigating as follows, starting from the pgAdmin sidebar:

  `Servers` > `SoftwareEng` > `Databases` > `quiz_me_development` > `Schemas` > `public` > `Tables` > (right-click) `mc_questions` > `View/Edit Data` > `All Rows`

We have now created our first model class and corresponding database table; however, we have not yet saved any `McQuestion` records in the database—that will be coming soon!

**[{% octicon git-commit height:24 class:"right left" aria-label:hi %} Code changeset for this part](https://github.com/human-se/quiz-me-2020/commit/f7319c1698e42d78473183705998df679d831ff0){:target="_blank"}**

{% include pagination.html prev_page='demo-simple-forms.md' next_page='demo-annotate.md' %}
