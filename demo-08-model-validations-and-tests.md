---
layout: page
title: 'Demo 8: Model Validations and Tests'
permalink: /demo-08-model-validations-and-tests/
---

# Demo 8: Model Validations and Tests

In this demonstration, I will show how to add model validations and verify that the validations were set up correctly by creating automated unit tests. I will continue to work on the _QuizMe_ project from the previous demos.

[Rails model validations](https://guides.rubyonrails.org/active_record_validations.html) aim to prevent invalid data from being saved to the database. For example, recall the model class we created for multiple-choice questions (Fig. 1). There are a number of possible ways that the attributes could be set to make an invalid `McQuestion` object. For example, the `question`, `answer`, and `distractor_1` attributes should all have a value (note that only one distractor is required). If any of those attributes were set to `nil` or to an empty string (`""` or one composed only of whitespace characters), we would consider that an invalid `McQuestion` object. Furthermore, the `question` for each `McQuestion` object stored in the database should be unique (i.e., no duplicate questions), and all the possible-answer values for a `McQuestion` object (i.e., `answer`, `distractor_1`, and `distractor_2`) should be different from each other. To prevent such invalid records from being saved to the database, we will customize our model class with appropriate validations.

<div class="figure-container mx-auto my-4" style="max-width: 960px;">
<figure class="figure">
<img src="{{ site.baseurl }}/resources/class-diagram.png" class="figure-img img-fluid rounded" alt="Class diagram for McQuestion model.">
<figcaption class="figure-caption">Fig 1. Class diagram for McQuestion model. (Diagram created using <a href="https://www.genmymodel.com">GenMyModel</a>.)</figcaption>
</figure>
</div>

You can find a complete list of all validations Rails includes [here](<https://guides.rubyonrails.org/active_record_validations.html>). 

[Unit tests](https://en.wikipedia.org/wiki/Unit_testing) aim to verify that individual "units" of code (e.g., classes and methods) work correctly. Rails includes a [test harness](https://en.wikipedia.org/wiki/Test_harness) that provides automation to help developers to write tests for various units of Rails application code (e.g., model classes) and to run those test in batches. In this demo, we will use the Rails test harness to test the model validations we create to verify that we have written them correctly.

## 1. Prerequisite Setup

### 1.1. Installing the Annotate Gem to Automatically Add Model Comments

Something that is inconvenient about Rails model classes is that their class attributes are not defined (or otherwise visible) in their class definitions. (Recall that Rails automatically adds model class attributes based the database schema defined in the `db/schema.rb` file.) For example, the `McQuestion` model class currently looks like this (with no mention of its `question`, `answer`, etc. attributes):

```ruby
class McQuestion < ApplicationRecord
end
```

Fortunately, the [Annotate](https://github.com/ctran/annotate_models) gem can help! In particular, it can be set up to automatically add comments into your model files every time you migrate the database. For example, it would add the following comments to the `McQuestion` model class:

```ruby
# ## Schema Information
#
# Table name: `mc_questions`
#
# ### Columns
#
# Name                | Type               | Attributes
# ------------------- | ------------------ | ---------------------------
# **`id`**            | `bigint`           | `not null, primary key`
# **`answer`**        | `string`           |
# **`distractor_1`**  | `string`           |
# **`distractor_2`**  | `string`           |
# **`question`**      | `string`           |
# **`created_at`**    | `datetime`         | `not null`
# **`updated_at`**    | `datetime`         | `not null`
#

class McQuestion < ApplicationRecord
end
```

Notice how all of the model classes attributes and their types are not listed in a generated comment at the top of the file.

To set up the Annotate gem in the QuizMe project, perform the following steps:

1. Add the Annotate gem to your project by adding the following lines to the bottom of your `Gemfile`:

    ```ruby
    # Adds model attributes/routes to top of model files/routes file
    gem 'annotate', group: :development
    ```

1. Install the Annotate gem by running the following command:

    ```bash
    bundle install
    ```

1. Generate a [Rake](https://en.wikipedia.org/wiki/Rake_(software)) task (essentially a plugin to `rails`) that will automatically annotate your files every time you run `rails db:migrate` by running the following command:

    ```bash
    rails g annotate:install
    ```

1. In the Rake task that was generated, `lib/tasks/auto_annotate_models.rake`, make sure the following line is set correctly:

    ```ruby
    'models'                      => 'true',
    ```

    If it is set to `false`, the annotations will not be automatically generated.

1. Annotate the model classes you already have by running the following command:

    ```ruby
    rails db:migrate:reset
    ```

    The above annotations should now have been added to `mc_questions.rb`.

### 1.2. Removing Generated Controller Tests

When `rails` is used to generate a controller class (like we did in the previous demos), it also generates some default tests for the controller class, including some "controller tests"; however, the controller tests assume the default routes generated by `rails`. When we customize the routes (as we are apt to do), it breaks these controller tests. Thus, to solve this problem, we commonly just comment out the generated controller tests initially, and later update them to fit for our particular app.

To remove the generated controller tests, open the Ruby files in `test/controllers`, and comment out any tests there you did not write (all of them at this stage). In a later demo, we will write controller tests specifically designed for the QuizMe project.

## 2. Creating Valid Fixtures

Before I begin adding model validations, I will do some initial preparation of the test code that will eventually be used to test the validations. In particular, I will first create some valid model objects to be used in the tests. Such test objects are called _fixtures_. In Rails, the fixtures for each model are stored in a [YAML](https://en.wikipedia.org/wiki/YAML) (`.yml`) file in the `test/fixures` directory. Looking at the `mc_questions.yml` file, we can see a couple of default fixtures have been made, `one` and `two`. We will replace those fixtures with appropriate valid examples of multiple-choice questions.

1. Replace fixture `one` with the following:

    ```yaml
    one:
      question: By default, every Rails model is a subclass of which superclass?
      answer: ApplicationRecord
      distractor_1: Object
      distractor_2: ActiveModel
    ```

1. True/false questions are another kind of multiple-choice question. Replace fixture `two` with the following:

    ```yaml
    two:
      question: The command rails db:migrate updates the schema.rb file.
      answer: true
      distractor_1: false
      distractor_2: # blank loads as nil
    ```

Once the above changes are completed, every `McQuestion` model test will be able to retrieve these fixtures for use in their test code.

## 3. Testing Valid Fixtures

Now that we have some fixtures, which are all supposed to be valid with respect to our current validations, we will write a test that checks the fixtures to make sure the app also sees them as valid. If the test reports that any of them are invalid, then we either made a mistake in the fixture or in the validations, and we will have to locate and fix the bug.

When we used `rails` to generate the `McQuestion` model, `rails` also generated a test file `test/models/mc_question_test.rb`. That test file is where we should put any model validation tests we write for this class.

Rails model tests usually follow three basic steps:

1. First, the test retrieves one or more fixtures (i.e., valid model objects for testing).
1. Next, the test may (or may not, depending on what it's testing) set the attribute values of the fixture objects, commonly to make them invalid.
1. Finally, the test makes one or more _assertions_ about the fixtures. Each assertion aims to check that some condition is true. If all of a test's assertions are true, then the test passes; however, if an assertion is discovered to be false, then the test fails.

Rails model tests are considered a kind of unit test, so they should be small and focus on testing only one thing. However, you can check multiple details about that one thing by adding multiple assertions to the same test.

### 3.1. Creating a Test for a Single Valid Fixture

First, I will write a test that tests fixture `one` to verify that the system considers it valid.

1. Create a test with the name "`fixures are valid`" that first retrieves the test fixture `one` object and then asserts that the object is valid. If it's not valid, then the test will print validation error messages. Note that, for this test, we skip step 2 mentioned above (setting fixture attributes), because this test doesn't need to change any of the fixture's attribute values. The test code should be as follows:

    ```ruby
    test "fixtures are valid" do
      q = mc_questions(:one)
      assert q.valid?, q.errors.full_messages.inspect
    end
    ```

1. To run the test to make sure it passes, enter the following command:

    ```bash
    rails test
    ```

    You should see a message that looks like this:

    ```text
    Finished in 0.194760s, 5.1345 runs/s, 10.2690 assertions/s.
    1 runs, 2 assertions, 0 failures, 0 errors, 0 skips
    ```

### 3.2. Updating the Test to Cover All the Valid Fixtures

Now that I have a test to verify that fixture `one` is valid, what I would really like to do is to test that all of the fixtures are valid. To do so, we could copy/paste/modify the code we already have to add a second assertion for fixture `two`, but then we're setting ourselves up to do a copy/paste/modify for every fixture we want to test. Right now, there are only two fixtures, but we might add more later. To save us from tedious and error-prone copy/paste/modify edits, we will instead simply iterate through all the fixtures and assert that each one is valid. Thus, I will update the above test code as follows:

1. Have the test iterate through all the fixtures by updating the above test code as follows:

    ```ruby
    test "fixtures are valid" do
      mc_questions.each do |q|
        assert q.valid?, q.errors.full_messages.inspect
      end
    end
    ```

1. Verify that the test passes by running the following command:

    ```bash
    rails test
    ```

    You should see a message that looks like this:

    ```text
    Finished in 0.194760s, 5.1345 runs/s, 10.2690 assertions/s.
    1 runs, 2 assertions, 0 failures, 0 errors, 0 skips
    ```

## 2. Creating Presence Validations

 Now that we have some valid fixtures, we can add some validations to the model. In the case of multiple-choice questions, it would be wrong to have a question without any question text, answer options, or a correct answer. We can use Rails `presence` validations on attributes to ensure that the attributes are not `nil` or a blank string before the model object is saved to the database.

1. In `mc_question.rb`, add `presence` validations, like this:

    ```ruby
    validates :question, presence: true
    validates :answer, presence: true
    validates :distractor_1, presence: true
    ```

    You can also combine validations of the same type on one line, like this:

    ```ruby
    validates :question, :answer, :distractor_1, presence: true
    ```

    Note we did not add a presence validation to `distractor_2`. Such a validation would flag all true/false questions as invalid, which we don't want.

1. Now, we need to add tests to verify that we declared the `presence` validations correctly. It is considered a best practice that each test cover at most one validation for a single attribute. Thus, we will next write a test to verify the `presence` validation for the `question` attribute. Since the `presence` validation catches both `nil` and empty string values, we can check both in the same test, like this:

    ```ruby
    test "question presence not valid" do
      q = mc_questions(:one)
      q.question = nil
      assert_not q.valid?
      q.question = ""
      assert_not q.valid?
    end
    ```

    Note that this test follows the three basic steps mentioned above: (1) it retrieves a valid fixture; (2) it does some setting of fixture attributes (specifically, to make the `question` attribute invalid); and (3) it makes some assertions about the state of the model object (specifically, it asserts that the model object is not valid).

1. Check that the test runs as expected by entering the following command:

    ```bash
    rails test
    ```

    If everything was correct, the test should produce output like this:

    ```text
    Finished in 0.211335s, 7.0493 runs/s, 14.3192 assertions/s.
    2 runs, 4 assertions, 0 failures, 0 errors, 0 skips
    ```

    If the test fails, then there is a bug, most likely in either the model validation code, the fixture code, or the test code.

1. Similar to the above, add two more tests for the `presence` validations, one for the `answer` attribute and one for the `distractor_1` attribute. Run `rails test` after you add each test to confirm that it works.

## 3. Creating Uniqueness Validations

We can also add other types of validations. For example, it's probably not acceptable to have two questions with exactly the same `question` text in the database. To ensure that such duplicates will not be saved to the database, we add a `uniqueness` validation to the `question` attribute, as follows:

1. Add the validation to the model file, like this:

    ```ruby
    validates :question, uniqueness: true
    ```

1. Add a test to verify that we declared the `uniqueness` validation correctly. First, the test will invoke the `dup` method on a fixture object to create a new object with the same attribute values as the fixture object. Then, the test will assert that the duplicate object is not valid, like this:

    ```ruby
    test "question uniqueness not valid" do
      q = mc_questions(:one).dup
      assert_not q.valid?
    end
    ```

1. Check that the test runs as expected by entering the following command:

    ```bash
    rails test
    ```

## 4. Creating Custom Validations

Sometimes you will need to validate a property for which Rails does not provide a validation helper. In that situation, you will need to write a custom validation.

In the case of multiple choice questions, all the choices should be unique for a single question. The `uniqueness` validation won't help here, because it checks that an attribute's value is unique over all the records in the database, not uniqueness of attribute values within an individual model object. Thus, we will create a custom validation that checks for three possible cases (`answer == distractor_1`, `distractor_1 == distractor_2` and `answer == distractor_2`) and adds appropriate validation-error messages if they any of the cases are true, like this:

1. Add to the `McQuestion` class the skeleton for a custom validation based on a new `choices_cannot_be_duplicate` method. This step involves two parts:

    1. Add a `validate` (singular) declaration for the new validation method, like this:

        ```ruby
        validate :choices_cannot_be_duplicate
        ```

    1. Declare the new validation method, like this:

        ```ruby
        def choices_cannot_be_duplicate
          # check cases
        end
        ```

1. Add to the custom method the cases to check, like this:

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

    Note that the method reports validation errors using the `errors` object. In particular, it invokes `add` on the `errors` object, passing a symbol for the attribute and an error-message string.

1. Add a test to verify that we implemented the custom validation correctly. In particular, for each duplication case, the test will retrieve a fixture object, set the object's attributes to create the duplication, and assert that the object is not valid, like this:

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

    Note that the fixture needs to be retrieved anew for each case to reset its attributes.

Above, we introduced a few common validation scenarios to name a few. For a complete list of validation helpers, see the [Rails Guides Active Record Validations documentation](https://guides.rubyonrails.org/active_record_validations.html).
