---
title: 'Displaying Detailed Form Error Messages'
---

{% include under-construction.html %}

# {{ page.title }}

TODO

## 7. Styling Forms That Display Errors

In this final task, we will use the [Bootstrap form classes](https://getbootstrap.com/docs/4.3/components/forms/) to make the app's form fields look nicer. Then, we will add attribute-specific error messages and coloring to the form fields to make it clearer to the user what errors they need to fix in their input (as depicted in Figure 3).

### 7.1. Applying Bootstrap Form Classes

Styling forms using the Bootstrap form classes can be accomplished as follows. Each `div` that contains a `label` and a field element should have the `form-group` class. Each field element should have the `form-control` class. The `submit` button should have the `btn` class, and probably one or more of the special button-styling classes, such as `btn-primary` for color or `btn-block` for a full-width button.

1. Add the appropriate Bootstrap form classes to the `account_quizzes/new.html.erb` view, like this:

    ```erb
    <div class="form-group">
      <%= form.label :title %>
      <%= form.text_field :title, class: "form-control" %>
    </div>

    <div class="form-group">
      <%= form.label :description %>
      <%= form.text_area :description, size: "27x7", class: "form-control" %>
    </div>

    <%= form.submit "Add Quiz", class: "btn btn-block btn-primary" %>
    ```

    Notice that we no longer need the `br` elements between the labels and fields.

### 7.2. Adding Field-Specific Error Messages

When a Rails model validation fails, Rails adds a description of the error to an `errors` hash that is part of the model object. We can determine if an object is invalid (i.e., has any validation errors) by checking if the `errors` hash is empty. We can also get the errors for a particular attribute using a key-based lookup in the `errors` hash.

1. Before each `form-group` `div`, add a `boolean` variable that holds whether there are errors for the corresponding attribute, like this code for the `title` attribute:

    ```erb
    <% invalid = quiz.errors.include?(:title) %>
    ```

1. Use the `invalid` variable to conditionally add the `is-invalid` class to the field element if there are any errors for the attribute, like this code for the `title` attribute:

    ```erb
    <%= form.text_field :title, class: "form-control #{'is-invalid' if invalid}" %>
    ```

1. Display the error messages for the attribute (if there are any) by conditionally inserting a `div` with the error message after the field element, like this code for the `title` attribute:

    ```erb
    <% if invalid %>
      <div class="invalid-feedback d-block">
        <% quiz.errors.full_messages_for(:title).each do |error_message| %>
          <%= error_message %>.
        <% end %>
      </div>
    <% end %>
    ```

The preceding steps should be followed for each form field such that each on looks similar to this:

```erb
<% invalid = quiz.errors.include?(:title) %>
<div class="form-group">
  <%= form.label :title %>
  <%= form.text_field :title, class: "form-control #{'is-invalid' if invalid}" %>
  <% if invalid %>
    <div class="invalid-feedback d-block">
      <% quiz.errors.full_messages_for(:title).each do |error_message| %>
        <%= error_message %>.
      <% end %>
    </div>
  <% end %>
</div>
```

We should now be able to submit invalid quiz data and to see the field-specific error messages.


**[{% octicon git-commit height:24 class:"right left" aria-label:hi %} Code changeset for this part](xxx){:target="_blank"}**

{% include pagination.html prev_page='demo-bootstrap-alerts.md' %}
