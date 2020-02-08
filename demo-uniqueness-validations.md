---
title: 'Creating and Testing Uniqueness Validations'
---

{% include under-construction.html %}

# {{ page.title }}

In this demonstration, I will show how to XXX. We will continue to build upon the [QuizMe project](https://github.com/human-se/quiz-me-2020){:target="_blank"} from the previous demos.

## Creating Uniqueness Validations

We can also add other types of validations. For example, it's probably not acceptable to have two questions with exactly the same `question` text in the database. To ensure that such duplicates will not be saved to the database, we add a `uniqueness` validation to the `question` attribute, as follows:

Add the validation to the model file, like this:

```ruby
validates :question, uniqueness: true
```

Add a test to verify that we declared the `uniqueness` validation correctly. First, the test will invoke the `dup` method on a fixture object to create a new object with the same attribute values as the fixture object. Then, the test will assert that the duplicate object is not valid, like this:

```ruby
test "question uniqueness not valid" do
  q = mc_questions(:one).dup
  assert_not q.valid?
end
```

Check that the test runs as expected by entering the following command:

```bash
rails test
```

**[➥ Code changeset for this part](xxx){:target="_blank"}**

{% include pagination.html prev_page='demo-presence-validations.md' next_page='demo-custom-validations.md' %}
