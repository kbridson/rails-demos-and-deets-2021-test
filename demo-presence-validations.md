---
title: 'Creating and Testing Presence Validations'
---

# {{ page.title }}

In this demonstration, I will show how to use the Rails model validation helper, `presence`, to enforce that specified model attribute values are present before a record can be saved to the database. We will continue to build upon the [QuizMe project](https://github.com/human-se/quiz-me-2020){:target="_blank"} from the previous demos.

[Rails model validations](https://guides.rubyonrails.org/active_record_validations.html){:target="_blank"} aim to prevent invalid data from being saved to the database. For example, recall the `McQuestion` model class we created for multiple-choice questions, shown in Figure 1. There are a number of requirements that we would like to enforce regarding what attribute values are and are not valid. For instance, the `question`, `answer`, and `distractor_1` attributes should all have a value. If a `McQuestion` object was missing values for any of those attributes, we would consider that `McQuestion` object to be invalid.

{% include image.html file="mc-question-model-class.svg" alt="A UML class diagram depicting the McQuestion model class" caption="Figure 1. The `McQuestion` model class." %}

To prevent such invalid records from being saved to the database, we will customize our `McQuestion` model class by adding [`presence` model validations](https://guides.rubyonrails.org/v6.0.2.1/active_record_validations.html#presence){:target="_blank"}. The purpose of the `presence` validation helper is to make it so that a specified model class attribute must have a non-`nil`, non-blank value in order for the model `valid?` method to return `true`. If the specified attribute is assigned a value of `nil`, an empty string (`""`), or a blank string, comprised only of whitespace characters, then `valid?` will return `false`. This validation helps to prevent invalid records from being saved to the database, because Rails automatically rejects saving any model object whose `valid?` method returns `false`. Note that, in addition to `presence`, Rails provides a number of other useful [validation helpers](https://guides.rubyonrails.org/v6.0.2.1/active_record_validations.html#validation-helpers){:target="_blank"}.

## 1. Adding `presence` Validations to the `McQuestion` Model Class

In the body of the `McQuestion` class (in `app/models/mc_question.rb`), insert a `presence` validation for each of the attributes, `question`, `answer`, and `distractor_1`, like this:

```ruby
validates :question, presence: true
validates :answer, presence: true
validates :distractor_1, presence: true
```

Note that we did not add a `presence` validation to `distractor_2`. Such a validation would inadvertently flag all true/false questions as invalid, which is not what we want.

Verify that we didn't accidentally introduce a syntax error into the model class by running the valid `McQuestion` fixture tests from [last demo]({% include page_url.html page_name='demo-test-fixtures.md' %}){:target="_blank"}, like this:

```bash
rails test
```

If no syntax errors were made, the test should produce the same output as last time.

**[➥ Code changeset for this part](https://github.com/human-se/quiz-me-2020/commit/91e2a798c84ac976da6f238a5dcb66fba8619f95){:target="_blank"}**

## 2. Testing the `presence` Validations in the `McQuestion` Model Class

Although running our previously created valid fixture tests will catch syntax errors, we also need to add tests to verify that we didn't make any logic errors in writing our `presence` validations.

It is considered a best practice for each model test to cover at most one validation for a single attribute. Thus, we will next write a test to verify the `presence` validation for the `question` attribute. Since the `presence` validation catches both `nil` and empty string values, we can check both in the same test.

Test the `presence` validation on the `question` attribute by inserting a new test into the `McQuestionTest` class (in `test/models/mc_question_test.rb`), like this:

```ruby
test "question presence not valid" do
    q = mc_questions(:one)
    q.question = nil
    assert_not q.valid?
    q.question = ""
    assert_not q.valid?
end
```

Note that this test follows the three basic steps for writing model tests mentioned in the [previous demo]({% include page_url.html page_name='demo-test-fixtures.md' %}){:target="_blank"}: (1) it retrieves a valid fixture; (2) it does some setting of fixture attributes (in this case, to make the `question` attribute invalid); and (3) it makes some assertions about the state of the model object (in this case, it asserts that the model object is invalid).

Check that the test runs as expected by entering the following command:

```bash
rails test
```

If everything is correct, the test should produce output like this:

```text
Finished in 0.211335s, 7.0493 runs/s, 14.3192 assertions/s.
2 runs, 4 assertions, 0 failures, 0 errors, 0 skips
```

If the test fails, then there is a bug, most likely in either the model validation code, the fixture code, or the test code, and you must fix it.

Following the same approach that was used to write the above test for the `presence` validation on the `question` attribute, add two more tests to `McQuestionTest` for the remaining `presence` validations, one for the `answer` attribute and one for the `distractor_1` attribute. After you add each test, run `rails test` to confirm that the test works.

**[➥ Code changeset for this part](https://github.com/human-se/quiz-me-2020/commit/ee6b73ed20ab190ac6f291eccd3c0949360c60f7){:target="_blank"}**

{% include pagination.html prev_page='demo-text-fixtures.md' next_page='demo-uniqueness-validations.md' %}
