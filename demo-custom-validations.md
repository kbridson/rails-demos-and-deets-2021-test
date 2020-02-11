---
title: 'Creating and Testing Custom Validations'
---

# {{ page.title }}

In this demonstration, I will show how to create a custom model validation to cover conditions that are beyond what the Rails validation helpers can handle. We will continue to build upon the [QuizMe project](https://github.com/human-se/quiz-me-2020){:target="_blank"} from the previous demos.

In particular, we will create a [custom validation](https://guides.rubyonrails.org/v6.0.2.1/active_record_validations.html#custom-methods){:target="_blank"} to enforce the condition that all the possible answer values for a `McQuestion` object (i.e., `answer`, `distractor_1`, and `distractor_2`) should be different from each other. In the case of multiple choice questions, all the choices should be unique for a single question. The `uniqueness` validation won't help here, because it checks that an attribute's value is unique over all the records in the database, not uniqueness of attribute values within an individual model object. Thus, we will create a custom validation that checks for three possible cases (`answer == distractor_1`, `distractor_1 == distractor_2` and `answer == distractor_2`) and adds appropriate validation-error messages if they any of the cases are true.

## 1. Creating a Custom Validation for the `McQuestion` Model Class

As a first step, add a `validate` (singular) declaration for a new custom validation method, `choices_cannot_be_duplicate`, to the `McQuestion` model class, like this:

```ruby
validate :choices_cannot_be_duplicate
```

We will now need to implement the `choices_cannot_be_duplicate` method, which provides our custom validation logic.

Add a new `choices_cannot_be_duplicate` method to the `McQuestion` class, like this:

```ruby
def choices_cannot_be_duplicate
  # TODO: check cases
end
```

There are three cases that this method must check for.

First, check that the `answer` is not the same as `distractor_1`, like this:

```ruby
if answer == distractor_1
  errors.add(:distractor_1, "can't be the same as any other choice")
end
```

Note that if the `answer` and `distractor_1` attributes have the same value, then the `choices_cannot_be_duplicate` should set the `McQuestion` model object as invalid. To accomplish this, the method adds an error message to the model object's `errors` hash. In particular, the error message specifies the attribute that it the subject of the error (`distractor_1`) and the human-readable description of the error (`"can't be the same as any other choice"`).

Second, similarly to how we handled `distractor_1`, check that the `answer` is not the same as `distractor_2`, like this:

```ruby
if answer == distractor_2
  errors.add(:distractor_2, "can't be the same as any other choice")
end
```

Third, check that the distractors are not the same, like this:

```ruby
if distractor_1 == distractor_2
  errors.add(:distractor_2, "can't be the same as any other choice")
end
```

Verify that we didn't accidentally introduce a syntax error into the model class by running the valid `McQuestion` fixture tests, like this:

```bash
rails test
```

If no syntax errors were made, the tests should run with no failures and no errors.

**[➥ Code changeset for this part](https://github.com/human-se/quiz-me-2020/commit/180e3edd7ad9ebc887209ce9df7a4fe31e3ae7b6){:target="_blank"}**

## 2. Testing the Custom Validation in the `McQuestion` Model Class

Add a test to verify that we implemented the custom validation correctly. In particular, for each duplication case, the test will retrieve a fixture object, set the object's attributes to create the duplication, and assert that the object is not valid, like this:

```ruby
test "choices cannot be duplicate not valid" do
  q = mc_questions(:one)
  q.distractor_1 = q.answer
  assert_not q.valid?

  q = mc_questions(:one)
  q.distractor_2 = q.answer
  assert_not q.valid?

  q = mc_questions(:one)
  q.distractor_1 = q.distractor_2
  assert_not q.valid?
end
```

Note that the fixture needs to be retrieved anew for each case to reset its attributes.

Check that the test runs as expected by entering the following command:

```bash
rails test
```

If the custom validation works correctly, the tests should run with no failures and no errors.

In the last few demos, we have introduced a few common validation scenarios. For a complete list of validation helpers and more, see the [Rails Guide on Active Record Validations](https://guides.rubyonrails.org/active_record_validations.html){:target="_blank"}.

**[➥ Code changeset for this part](https://github.com/human-se/quiz-me-2020/commit/c51903dbe2216b1b8b0dd9946127543b243ee055){:target="_blank"}**

{% include pagination.html prev_page='demo-uniqueness-validations.md' next_page='demo-flash.md' %}
