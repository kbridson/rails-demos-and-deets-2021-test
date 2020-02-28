---
title: 'Creating and Testing Uniqueness Validations'
---

# {{ page.title }}

In this demonstration, I will show how to use the Rails model validation helper, `uniqueness`, to enforce that the value of a specified model attribute must be unique (i.e., not already assigned to some other record in the database) in order to be saved in the database. We will continue to build upon the [QuizMe project](https://github.com/human-se/quiz-me-2020){:target="_blank"} from the previous demos.

In particular, we will use the [`uniqueness` validation helper](https://guides.rubyonrails.org/v6.0.2.1/active_record_validations.html#uniqueness){:target="_blank"} to ensure that the `question` attribute for each `McQuestion` object stored in the database is unique. The idea here is that we do not want the same question to appear twice in the database.

## 1. Adding a `uniqueness` Validation to the `McQuestion` Model Class

In the the `McQuestion` model class, update the validation for the `question` attribute by inserting a `uniqueness` validation, like this:

```ruby
validates :question,
  presence: true,
  uniqueness: true
```

Note that we also inserted line breaks and indentation into the `validates :question` declaration above to enhance its readability.

Verify that we didn't accidentally introduce a syntax error into the model class by running the valid `McQuestion` fixture tests, like this:

```bash
rails test
```

If no syntax errors were made, the tests should run with no failures and no errors.

**[{% octicon git-commit height:24 class:"right left" aria-label:hi %} Code changeset for this part](https://github.com/human-se/quiz-me-2020/commit/84bfc049d89a765ae3044bf00b8a57d1165bba29){:target="_blank"}**

## 2. Testing the `uniqueness` Validation in the `McQuestion` Model Class

Verify that we declared the `uniqueness` validation correctly by adding a model test to `McQuestionTest`, like this:

```ruby
test "question uniqueness not valid" do
  one = mc_questions(:one)
  two = mc_questions(:two)
  one.question = two.question
  assert_not one.valid?
end
```

Note the strategy we used in the above test. We retrieve both fixtures, `one` and `two`, from the test database. Then, we assign the `question` attribute for `one` to be the same as for `two`. Because `two` is already saved in the database, our `uniqueness` validation should cause `one` to evaluate as invalid.

Check that the test runs as expected by entering the following command:

```bash
rails test
```

If the `uniqueness` validation works correctly, the tests should run with no failures and no errors.

**[{% octicon git-commit height:24 class:"right left" aria-label:hi %} Code changeset for this part](https://github.com/human-se/quiz-me-2020/commit/ac2fb6db1edf0454011d9e4ab408ab94f505cc33){:target="_blank"}**

{% include pagination.html prev_page='demo-presence-validations.md' next_page='demo-custom-validations.md' %}
