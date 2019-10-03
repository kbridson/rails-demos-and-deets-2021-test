---
layout: page
title: 'Demo 8: Model Validations and Tests'
permalink: /demo-08-model-validations-and-tests/
---

# Demo 8: Model Validations and Tests

In this demonstration, I will show how to add model validations and check that the validations were set up correctly by creating unit tests. I will continue to work on the _QuizMe_ project from the previous demos.

Validations make it harder for bad data to get persisted in your database by adding constraints on the attributes of the model before it can be saved to the db. TODO: Difference between validations (model) and constraints set in the migration (db).

*Before continuing, go into the files in `test/controllers` and comment out any tests there you did not write. In a later demo, we will write controller tests for this project but for now assume any automatically generated tests will fail.*

## 1. Setup: Using Annotate gem to Automatically Add Model Comments

TODO: Introduce annotate gem

1. Add the annotate gem to your project by adding the following lines to the bottom of your Gemfile:

    ```ruby
    # Adds model attributes/routes to top of model files/routes file
    gem 'annotate', group: :development
    ```

1. Run the `bundle install` command.

1. Run the command `rails g annotate:install` to generate some code which will automatically annotate your files every time you run `rails db:migrate`. In the file that was created, make sure the following line is set correctly:

    ```ruby
    'models'                      => 'true',
    ```

    If it is set to `false`, the annotations will not be automatically generated.

1. Run the command `rails db:migrate:reset`. Observe the annotations in `mc_questions.rb`.

With these annotations we can easily see the names of the model's attributes and their data types without needing to look at the migration or schema files.

## 2. Creating Valid Fixtures

When creating new validations on a model, you should also write some simple tests to make sure the validations are covering the kinds of example cases you expect. In other words, the tests should confirm that if you expect an example case to be valid, your validations should also consider it valid. 

In Rails, the example cases for each model are stored in a `.yml` file in the `test/fixures` directory. TODO: maybe explain this yaml syntax. Looking at the `mc_questions.yml` file, we can see a couple of default fixtures have been made. We need to replace those with appropriate valid examples of multiple-choice questions.

1. Replace fixture one with the following:

    ```yaml
    one:
      question: By default, every Rails model is a subclass of which superclass?
      answer: ApplicationRecord
      distractor_1: Object
      distractor_2: ActiveModel
    ```

1. True/false questions are another kind of multiple-choice question. Replace fixture two with the following:

    ```yaml
    two:
      question: The command rails db:migrate updates the schema.rb file.
      answer: true
      distractor_1: false
      distractor_2: # blank loads as nil
    ```

## 3. Testing Valid Fixtures

Now that we have some fixtures, we should write a test that checks them against the current validations. When we generated the McQuestion model, a test file `test/models/mc_question_test.rb` was created, and that is where we should put any model validation tests we write for this class.

Rails model tests usually consist of importing a fixture and making one or more assertions that the result of some boolean check should be either true or false. They are a kind of unit test, so they should check only one thing. However, you can check multiple details about that one thing by adding multiple assertions to the same test. In this test, I am going to check that all the fixtures are valid using the `valid?` method.

1. Create a test with the name "fixures are valid" that asserts fixture one should be valid and prints the validation error messages if it isn't valid. The code should be as follows:

    ```ruby
    test "fixtures are valid" do
      q = mc_questions(:one)
      assert q.valid?, q.errors.full_messages.inspect
    end
    ```

1. We could copy that code to add a second assertion for fixture two, but we'd have to keep adding those two lines for every fixture. Right now there's only two fixtures, but we might add more later. It would be better to iterate through all fixtures and assert each one should be valid. Refactor the code as follows:

    ```ruby
    test "fixtures are valid" do
      mc_questions.each do |q|
        assert q.valid?, q.errors.full_messages.inspect
      end
    end
    ```

1. Run the command `rails test` to make sure the test passes. You should see a message like this:

    ```bash
    Finished in 0.194760s, 5.1345 runs/s, 10.2690 assertions/s.
    1 runs, 2 assertions, 0 failures, 0 errors, 0 skips
    ```


## 2. Presence Validations and Tests

 Now that we have some valid fixtures, we can add some validations to the model. In the case of multiple choice questions, it would be weird to have a question without any question text, answer options or a correct answer. We can use Rails presence validations on those attributes to make sure they are not nil or a blank string before the question is saved.

1. In `mc_question.rb`, add presence validations as follows:

    ```ruby
    validates :question, presence: true 
    validates :answer, presence: true 
    validates :distractor_1, presence: true 
    ```

    You can also combine validations of the same type on one line as follows:

    ```ruby
    validates :question, :answer, :distractor_1, presence: true 
    ```

    Note we did not add a presence validation to distractor_2. Such a validation would flag all true/false questions as invalid which we don't want.

1. Now we need to add tests that modify attributes of our fixtures such that we know the object should not be valid, then assert that the system also flags the resulting object as not valid. **Each test should cover at most one validation for a single attribute.** We can use the `assert_not` method for these test as follows:

    ```ruby
    test "question presence not valid" do
      q = mc_questions(:one)
      q.question = nil
      assert_not q.valid?
      q.question = ""
      assert_not q.valid?
    end
    ```

    Since the presence validation flags nil or empty string values, we can check both in the same test.

1. Add similar tests for the answer and distractor_1 presence validations then run `rails test`. You should see output similar to the following:

    ```bash
    Finished in 0.441115s, 9.0679 runs/s, 18.1359 assertions/s.
    4 runs, 8 assertions, 0 failures, 0 errors, 0 skips
    ```

## 3. Uniqueness Validations and Tests

We can also add other types of validations. For example, it's probably not acceptable to have two versions of the same question with exactly the same question text. We can add a uniqueness validation to the question attribute to ensure this can't happen. 

1. Add the validation to the model file as follows:

    ```ruby
    validates :question, uniqueness: true
    ```

1. Create the invalid uniqueness test using the `dup` function to create a new object with the same attributes as one of the fixtures. The test should be as follows:

    ```ruby
    test "question uniqueness not valid" do
      q = mc_questions(:one).dup
      assert_not q.valid?
    end
    ```

## 4. Custom Validations

You can find a complete list of all validations Rails includes [here](<https://guides.rubyonrails.org/active_record_validations.html>). Sometimes though you will need to validate something that does not fit into one of the standard categories. In that situation, you will need to write a custom validation.

In the case of multiple choice questions, all the choices should be unique for a single question. The uniqueness validation checks that an attribute's value is unique over all the records in the database which isn't what we want for this. We want something that checks the three possible cases (`answer == distractor_1`, `distractor_1 == distractor_2` and `answer == distractor_2`) and adds validation error messages if they are true.

1. Add a custom validation based on a new `choices_cannot_be_duplicate` method as follows:

    ```ruby
    validate :choices_cannot_be_duplicate
  
    def choices_cannot_be_duplicate
      # check cases
    end
    ```

1. Add the cases to the `choices_cannot_be_duplicate` method as follows:

    ```ruby
    def choices_cannot_be_duplicate
      if answer == distractor_1
        errors.add(:distractor_1, "can't be the same as any other choice")
      end
      if distractor_1 == distractor_2
        errors.add(:distractor_2, "can't be the same as any other choice")
      end
      if answer == distractor_2
        errors.add(:distractor_2, "can't be the same as any other choice")
      end
    end
    ```

1. Add the invalid duplicate choices test with separate assertions for each case as follows:

    ```ruby
    test "choices cannot be duplicate not valid" do
      q = mc_questions(:one)
      q.distractor_1 = q.answer
      assert q.valid?, q.errors.full_messages.inspect
      q = mc_questions(:one)
      q.distractor_1 = q.distractor_2
      assert q.valid?, q.errors.full_messages.inspect
      q = mc_questions(:one)
      q.distractor_2 = q.answer
      assert q.valid?, q.errors.full_messages.inspect
    end
    ```

    Note you will need to reset the attributes of the fixture for each assertion since we are overwriting them.
    
TODO: Maybe conclusion.