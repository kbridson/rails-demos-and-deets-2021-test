---
title: 'Creating and Testing Presence Validations'
---

{% include under-construction.html %}

# {{ page.title }}

In this demonstration, I will show how to XXX. We will continue to build upon the [QuizMe project](https://github.com/human-se/quiz-me-2020){:target="_blank"} from the previous demos.

[Rails model validations](https://guides.rubyonrails.org/active_record_validations.html) aim to prevent invalid data from being saved to the database. For example, recall the model class we created for multiple-choice questions (Fig. 1). There are a number of possible ways that the attributes could be set to make an invalid `McQuestion` object. For example, the `question`, `answer`, and `distractor_1` attributes should all have a value (note that only one distractor is required). If any of those attributes were set to `nil` or to an empty string (`""` or one composed only of whitespace characters), we would consider that an invalid `McQuestion` object. Furthermore, the `question` for each `McQuestion` object stored in the database should be unique (i.e., no duplicate questions), and all the possible-answer values for a `McQuestion` object (i.e., `answer`, `distractor_1`, and `distractor_2`) should be different from each other. To prevent such invalid records from being saved to the database, we will customize our model class with appropriate validations.

{% include image.html file="mc-question-model-class.svg" alt="A UML class diagram depicting the McQuestion model class" caption="Figure 1. The `McQuestion` model class." %}

You can find a complete list of all validations Rails includes [here](<https://guides.rubyonrails.org/active_record_validations.html>).

## Creating Presence Validations

Now that we have some valid fixtures, we can add some validations to the model. In the case of multiple-choice questions, it would be wrong to have a question without any question text, answer options, or a correct answer. We can use Rails `presence` validations on attributes to ensure that the attributes are not `nil` or a blank string before the model object is saved to the database.

In `mc_question.rb`, add `presence` validations, like this:

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

Now, we need to add tests to verify that we declared the `presence` validations correctly. It is considered a best practice that each test cover at most one validation for a single attribute. Thus, we will next write a test to verify the `presence` validation for the `question` attribute. Since the `presence` validation catches both `nil` and empty string values, we can check both in the same test, like this:

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

Check that the test runs as expected by entering the following command:

```bash
rails test
```

If everything was correct, the test should produce output like this:

```text
Finished in 0.211335s, 7.0493 runs/s, 14.3192 assertions/s.
2 runs, 4 assertions, 0 failures, 0 errors, 0 skips
```

If the test fails, then there is a bug, most likely in either the model validation code, the fixture code, or the test code.

Similar to the above, add two more tests for the `presence` validations, one for the `answer` attribute and one for the `distractor_1` attribute. Run `rails test` after you add each test to confirm that it works.

**[➥ Code changeset for this part](xxx){:target="_blank"}**

{% include pagination.html prev_page='demo-text-fixtures.md' next_page='demo-uniqueness-validations.md' %}
