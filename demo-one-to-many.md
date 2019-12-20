---
title: 'One-to-Many Model Associations'
---

# {{ page.title }}

In this demonstration, I will show how to set up and use one-to-many model class associations. We will continue to build upon on the _QuizMe_ project from the previous demos

In particular, we will be updating our model design by adding a new one-to-many association between the `Quiz` and `McQuestion` model classes, as depicted in Figure 1.

<div class="figure-container mx-auto my-4" style="max-width: 960px;">
<figure class="figure">
<img src="{{ site.baseurl }}/resources/demo11_fig01.svg" class="figure-img img-fluid rounded border" alt="Class diagram.">
<figcaption class="figure-caption">Figure 1. Model class design diagram showing the one-to-many association between <code>Quiz</code> and <code>McQuestion</code>. As per the association, each <code>Quiz</code> object has many <code>McQuestion</code> objects, and each <code>McQuestion</code> object belongs to one <code>Quiz</code> object.</figcaption>
</figure>
</div>

In order to implement this association, there are a series of high-level tasks we will perform:

1. Add a foreign key (FK) column to our existing `mc_questions` table by creating a new database migration. The purpose of this FK column will be to reference `Quiz` records. The FK column is necessary to satisfy the [Rails ORM for one-to-many associations](https://guides.rubyonrails.org/association_basics.html#the-has-many-association).
1. Add declarations to the `Quiz` and `McQuestion` model classes to set up the one-to-many association. In particular, `Quiz` will get a `has_many` declaration, and `McQuestion` will get a `belongs_to` declaration.
1. Update the model test fixtures to incorporate association links.
1. Create new seed data that include association links.

We will work through each of these task in a section below.

## 1. Adding a Foreign Key Column to an Existing Table (`mc_questions`)

In preparation for creating the model class association, we will perform the following steps to add a new foreign key column to the database table `mc_questions`. This FK column will reference `Quiz` records and satisfy the Rails ORM for setting up a one-to-many association between `Quiz` and `McQuestion`.

1. Generate a new (empty) database migration by running the following command:

    ```bash
    rails g migration AddQuizFkColToMcQuestions
    ```

    This will generate a migration file `db/migrate/20191106225052_add_quiz_fk_col_to_mc_questions.rb` (with the timestamp being consistent with the time when you ran the command). Inspect this file, and note that it contains a class `AddQuizFkColToMcQuestions` with a single empty method `change`.

1. Set up the migration to add a `quiz_id` FK column to the `mc_questions` table by inserting the following line in the `change` method:

    ```ruby
    add_reference :mc_questions, :quiz, foreign_key: true
    ```

    Note that the first argument (`:mc_questions`) indicates the table to add the column to; the second argument (`:quiz`) indicates the column name, which Rails automatically translates into `quiz_id` because it's an FK, and the third argument (`foreign_key: true`) indicates that it's a FK column.

1. Update the database schema by running the migration with the following command:

    ```bash
    rails db:migrate
    ```

## 2. Creating a One-to-Many Association between Two Model Classes

Now that we have got the database tables set up, the other thing we need to do to set up the one-to-many association is to add `has_many` and `belongs_to` declarations to `Quiz` and `McQuestion`, respectively.

1. Add the following `belongs_to` declaration to the `McQuestion` model class, as follows:

    ```ruby
    belongs_to :quiz, # McQuestion attribute of with datatype Quiz
      class_name: 'Quiz', # datatype of attribute
      foreign_key: 'quiz_id', # name of column containing FK
      inverse_of: :mc_questions # attribute on other side of association (array containing all McQuestion objects belonging to a quiz)
    ```

    In the above `belongs_to` declaration, we explicitly set all the key options, `class_name`, `foreign_key`, and `inverse_of`, for purposes of instruction; however, it is worth mentioning that they weren't strictly necessary in this example. If the attribute name (`quiz`) is the lowercase form of the class name (`Quiz`) and the column name (`quiz_id`) is the lowercase form of the class name (`Quiz`) with an "`_id`" on the end, then the `class_name`, `foreign_key` and `inverse_of` options do not need to be explicitly declared. Thus, the following `belongs_to` declaration would be equivalent to the one above:

    ```ruby
    belongs_to :quiz
    ```

1. Add the following `has_many` declaration to the `Quiz` model class, as follows:

    ```ruby
    has_many :mc_questions, # Quiz attribute containing an array of McQuestion objects
      class_name: 'McQuestion', # datatype of attribute
      foreign_key: 'quiz_id', # name of column containing FK in other table
      inverse_of: :quiz # attribute on other side of association (parent Quiz object)
      dependent: :destroy # if a quiz is destroyed, also destroy all of its questions
    ```

    Similar to the `belongs_to` declaration above, the `class_name`, `foreign_key`, and `inverse_of` options are included here for instructional purposes and are not actually required in this case. Thus, the following declaration could suffice:

    ```ruby
    has_many :mc_questions, dependent: :destroy
    ```

## 3. Updating Model Test Fixtures to Use the Association

Now that the one-to-many association has been set up, we will use it to create some linked `Quiz` and `McQuestion` objects in the app's test fixtures. Adding the model association has left our test fixtures invalid. For example, try running these commands:

```bash
rails db:migrate:reset RAILS_ENV=test
rails test
```

The test checking that the fixtures are valid should fail. The association we created requires that each `McQuestion` object must belong to a `Quiz` object, and it creates an implicit validation that the `quiz` attribute must be present. This explains why we get a failure message like the following, stating "`Quiz must exist`":

```text
Failure:                                                                              McQuestionTest#test_fixtures_are_valid [/home/vagrant/workspace/quiz-me/test/models/mc_question_test.rb:38]:
["Quiz must exist"]
```

In the subsequent steps, we will correct this failure by updating the fixtures so that all association links are present.

1. Update `test/fixtures/quizzes.yml` such that it contains one `Quiz` fixture object, like this:

    ```yml
    one:
      title: Rails Concepts
      description: This quiz covers basic Rails programming concepts.
    ```

1. In `test/fixtures/mc_questions.yml`, add a `quiz` attribute to each `McQuestion` fixture that points to the `Quiz` fixture we just created in the previous step, like this:

    ```yml
    one:
      question: By default, every Rails model is a subclass of which superclass?
      answer: ApplicationRecord
      distractor_1: Object
      distractor_2: ActiveModel
      quiz: one

    two:
      question: The command rails db:migrate updates the schema.rb file.
      answer: true
      distractor_1: false
      distractor_2: # blank loads as nil
      quiz: one
    ```

    Note that `quiz: one` refers to the `Quiz` fixture in `test/fixtures/quizzes.yml` named `one`.

1. Run the following command to verify that the tests now pass:

    ```bash
    rails test
    ```

## 4. Creating Seed Data That Use the Association

As a final task, we will seed the database with example data using our newly created model class association, as per the steps below. In a later demo, we will add pages to view and manipulate this seed data in the app.

1. Add a three more `McQuestion` objects, like this:

    ```ruby
    q4 = McQuestion.create!(question: 'Which hash is primarily used for one way message passing from the controller to the view?', answer: 'flash', distractor_1: 'session', distractor_2: 'params')
    q5 = McQuestion.create!(question: 'In which folder are image assets for the QuizMe app stored?', answer: 'quiz-me/app/assets/images', distractor_1: 'quiz-me', distractor_2: 'quiz-me/images')
    q6 = McQuestion.create!(question: 'Which standard RESTful controller action is used to remove records?', answer: 'destroy', distractor_1: 'delete', distractor_2: 'remove')
    ```

1. Create association links between the `Quiz` and `McQuestion` objects by setting a `quiz` option in each call to `McQuestion.create!`, like this:

    ```ruby
    q1 = McQuestion.create!(quiz: quiz1, question: 'What does the M in MVC stand for?', answer: 'Model', distractor_1: 'Media', distractor_2: 'Mode')
    q2 = McQuestion.create!(quiz: quiz1, question: 'What does the V in MVC stand for?', answer: 'View', distractor_1: 'Verify', distractor_2: 'Validate')
    q3 = McQuestion.create!(quiz: quiz1, question: 'What does the C in MVC stand for?', answer: 'Controller', distractor_1: 'Create', distractor_2: 'Code')

    q4 = McQuestion.create!(quiz: quiz2, question: 'Which hash is primarily used for one way message passing from the controller to the view?', answer: 'flash', distractor_1: 'session', distractor_2: 'params')
    q5 = McQuestion.create!(quiz: quiz2, question: 'In which folder are image assets for the QuizMe app stored?', answer: 'quiz-me/app/assets/images', distractor_1: 'quiz-me', distractor_2: 'quiz-me/images')
    q6 = McQuestion.create!(quiz: quiz2, question: 'Which standard RESTful controller action is used to remove records?', answer: 'destroy', distractor_1: 'delete', distractor_2: 'remove')
    ```

1. Seed the database using the following command:

    ```bash
    rails db:seed:replant
    ```

To confirm that the data was seeded correctly, use pgAdmin to inspect the database, or use the Rails console, for example, to run `McQuestion.all` and inspect the output.