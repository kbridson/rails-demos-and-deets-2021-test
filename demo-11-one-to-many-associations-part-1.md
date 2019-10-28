---
layout: page
title: 'Demo 11: One to Many Associations (part 1)'
permalink: /demo-11-one-to-many-associations-part-1/
---

# Demo 11: One to Many Associations (part 1)

In this demonstration, I will show how to setup a one-to-many model association by creating the appropriate migrations and model statements. I will also update the seeds, fixtures and tests to reflect the new association. I will continue to work on the _QuizMe_ project from the previous demos.

TODO: What are we doing. Class diagram. (Quiz has title and description)
TODO: How are we doing it. 
  - Changing db: We need to change the db schema by adding a new migration that will create the quizzes table for the new Quiz model. We also need to add a column to the mc_questions table to hold the quizzes FK.
  - Changing model classes: After the Quiz model has been created, we need to add a belongs_to statement to the McQuestion model class and a has_many statement to the Quiz model class.

## 1. Changing the Database

TODO: In this section...

1. Generate the migration for the Quiz model.

    ```sh
    rails g model Quiz title description:text (string datatype is default and can be omitted)
    ```

    TODO: Look at the file that was created.

1. After the `create_table` block in the CreateQuizzes migration, add a statement that will add a quiz reference (FK) to the mc_questions table with:

    ```ruby
    add_reference :mc_questions, :quiz, foreign_key: true
    ```

    Scott: I think that auto-generating that statement in its own migration file based on the name of the file is more confusing. For debugging if they get the name slightly wrong, they would need to look at this statement in the file and make sure it makes sense anyways.

1. Run db:migrate and look at the updated schema file.

## 2. Changing Model Classes

TODO: In this section...

1. Add the following belongs_to statement to `mc_questions.rb`:

    ```ruby
    belongs_to :quiz, # McQuestion attribute of with datatype Quiz
      class_name: 'Quiz', # datatype of attribute
      foreign_key: 'quiz_id', # name of column containing FK
      inverse_of: :mc_questions # attribute on other side of association (array containing all McQuestion objects belonging to a quiz)
    ```

    If the attribute name is the lowercase form of the class name and the column name is the lowercase form of the class name with "_id", then the class_name, foreign_key and inverse_of options do not need to be explicitly declared. In this case, the statement `belongs_to :quiz` is equivalent.

1. Add the following has_many statement to `quiz.rb`:

    ```ruby
    has_many :mc_questions, # Quiz attribute containing an array of McQuestion objects
      class_name: 'McQuestion', # datatype of attribute
      foreign_key: 'quiz_id', # name of column containing FK in other table
      inverse_of: :quiz # attribute on other side of association (parent Quiz object)
    ```

    Similar to the belongs_to statement, class_name, foreign_key, and inverse_of are redundant in this case.

## 3. Updating Seeds

TODO: In this section...

1. Add a couple Quiz seeds at the top of the seeds file:

    ```ruby
    q1 = Quiz.create(title: 'MVC Concepts')
    q2 = Quiz.create(title: 'Rails Concepts')
    ```

1. Add a few more McQuestion objects to match:

    ```ruby
    McQuestion.create!(question: 'What does the M in MVC stand for?', 
      answer: 'Model', distractor_1: 'Media', distractor_2: 'Mode')
    McQuestion.create!(question: 'What does the V in MVC stand for?', 
      answer: 'View', distractor_1: 'Verify', distractor_2: 'Validate')
    McQuestion.create!(question: 'What does the C in MVC stand for?', 
      answer: 'Controller', distractor_1: 'Create', distractor_2: 'Code')

    McQuestion.create!(question: 'Which hash is primarily used for one way message passing from the controller to the view?', 
      answer: 'flash', distractor_1: 'session', distractor_2: 'params')
    McQuestion.create!(question: 'In which folder are image assets for the QuizMe app stored?', 
      answer: 'quiz-me/app/assets/images', distractor_1: 'quiz-me', distractor_2: 'quiz-me/images')
    McQuestion.create!(question: 'Which standard RESTful controller action is used to remove records?',
      answer: 'destroy', distractor_1: 'delete', distractor_2: 'remove')
    ```

1. Add a one of the Quiz seed objects as an attribute to each of the McQuestion seeds:

    ```ruby
    McQuestion.create!(quiz: q1, question: 'What does the M in MVC stand for?', 
      answer: 'Model', distractor_1: 'Media', distractor_2: 'Mode')
    McQuestion.create!(quiz: q1, question: 'What does the V in MVC stand for?', 
      answer: 'View', distractor_1: 'Verify', distractor_2: 'Validate')
    McQuestion.create!(quiz: q1, question: 'What does the C in MVC stand for?', 
      answer: 'Controller', distractor_1: 'Create', distractor_2: 'Code')

    McQuestion.create!(quiz: q2, question: 'Which hash is primarily used for one way message passing from the controller to the view?', 
      answer: 'flash', distractor_1: 'session', distractor_2: 'params')
    McQuestion.create!(quiz: q2, question: 'In which folder are image assets for the QuizMe app stored?', 
      answer: 'quiz-me/app/assets/images', distractor_1: 'quiz-me', distractor_2: 'quiz-me/images')
    McQuestion.create!(quiz: q2, question: 'Which standard RESTful controller action is used to remove records?',
      answer: 'destroy', distractor_1: 'delete', distractor_2: 'remove')
    ```

1. Seed the database (`rails db:seed:replant` or `rails db:migrate:reset db:seed`) and use pgAdmin or the console to confirm the data has been correctly added. In a later demo, we will add pages to view the associated records in the app.


## 4. Updating Fixtures and Tests

TODO: In this section...

1. Run `rails db:migrate:reset RAILS_ENV=test` and `rails test`.

    The test checking that the fixtures are valid should fail. The association we created requires that each McQuestion object should belong to a Quiz object, and it creates an invisible validation that the quiz attribute must exist. This explains why we get the following failure message stating "Quiz must exist":

    ```sh
    Failure:                                                                              McQuestionTest#test_fixtures_are_valid [/home/kbridson/workspace/quiz-me/test/models/mc_question_test.rb:38]:
    ["Quiz must exist"]
    ```

1. Create a Quiz fixture object:

    ```yml
    one:
      title: Rails Concepts
      description: This quiz covers basic Rails programming concepts.
    ```

1. Add a quiz attribute to each McQuestion fixture that points to the Quiz fixture we just made:

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

    Note that `quiz: one` refers to the Quiz fixture named `one`.

1. Run `rails test` again to see the tests pass.

## 5. Bonus: Adding Validations and Tests to the Quiz Model

This section will not introduce any new material but for completeness I will add the appropriate validations and tests to the Quiz model we created in this demo. The attributes title and descriptions should not be allowed to be blank.

1. Add presence validations for title and description:

    ```ruby
    validates :title, :description, presence: true
    ```

1. Add a test for valid fixtures:

    ```ruby
    test "fixtures are valid" do
      quizzes.each do |q|
        assert q.valid?, q.errors.full_messages.inspect
      end
    end
    ```

1. Add tests for title and description invalid presence:

    ```ruby
    test "title presence not valid" do
      q = quizzes(:one)
      q.title = nil
      assert_not q.valid?
      q.title = ""
      assert_not q.valid?
      q.title = "\t"
      assert_not q.valid?
    end

    test "description presence not valid" do
      q = quizzes(:one)
      q.description = nil
      assert_not q.valid?
      q.description = ""
      assert_not q.valid?
      q.description = "\t"
      assert_not q.valid?
    end
    ```

1. Run `rails test` to confirm tests are passing.