---
title: 'Creating and Testing Custom Validations'
---

{% include under-construction.html %}

# {{ page.title }}

In this demonstration, I will show how to XXX. We will continue to build upon the [QuizMe project](https://github.com/human-se/quiz-me-2020){:target="_blank"} from the previous demos.

## Creating Custom Validations

Sometimes you will need to validate a property for which Rails does not provide a validation helper. In that situation, you will need to write a custom validation.

In the case of multiple choice questions, all the choices should be unique for a single question. The `uniqueness` validation won't help here, because it checks that an attribute's value is unique over all the records in the database, not uniqueness of attribute values within an individual model object. Thus, we will create a custom validation that checks for three possible cases (`answer == distractor_1`, `distractor_1 == distractor_2` and `answer == distractor_2`) and adds appropriate validation-error messages if they any of the cases are true, like this:

Add to the `McQuestion` class the skeleton for a custom validation based on a new `choices_cannot_be_duplicate` method. This step involves two parts:

Add a `validate` (singular) declaration for the new validation method, like this:

```ruby
validate :choices_cannot_be_duplicate
```

Declare the new validation method, like this:

```ruby
def choices_cannot_be_duplicate
  # check cases
end
```

Add to the custom method the cases to check, like this:

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

Add a test to verify that we implemented the custom validation correctly. In particular, for each duplication case, the test will retrieve a fixture object, set the object's attributes to create the duplication, and assert that the object is not valid, like this:

```ruby
test "choices cannot be duplicate not valid" do
  q = mc_questions(:one)
  q.distractor_1 = q.answer
  assert_not q.valid?, q.errors.full_messages.inspect
  q = mc_questions(:one)
  q.distractor_1 = q.distractor_2
  assert_not q.valid?, q.errors.full_messages.inspect
  q = mc_questions(:one)
  q.distractor_2 = q.answer
  assert_not q.valid?, q.errors.full_messages.inspect
end
```

Note that the fixture needs to be retrieved anew for each case to reset its attributes.

Above, we introduced a few common validation scenarios to name a few. For a complete list of validation helpers, see the [Rails Guides Active Record Validations documentation](https://guides.rubyonrails.org/active_record_validations.html).

**[➥ Code changeset for this part](xxx){:target="_blank"}**

{% include pagination.html prev_page='demo-uniqueness-validations.md' %}
