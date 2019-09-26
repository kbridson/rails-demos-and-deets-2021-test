---
layout: page
title: 'Demo 7: Working with Simple Models'
permalink: /demo-07-working-with-simple-models/
---

# Demo 7: Working with Simple Models

In this demonstration, I will show how to create a model class and some sample objects, persist those objects in the database, and then retrieve and view them on a web page. I will continue to work on the _QuizMe_ project from the previous demos.

## Adding a New Model Class

TODO: Review diagram thingy and what's a model... OOP version of a db record

Since we are building a quizzing application, we will need to store questions in the database. At first, the app will only allow multiple choice questions but in a later demo we will see it's pretty easy to add other kinds of questions too like fill in the blank. For multiple choice questions we need to store the question, answer, and a couple of incorrect options (distractors). 

### 1. Adding a Rails Model on the Command Line

In this part, I will create the new _Contact_ page that will later hold the form. Since this part involves only tasks that have already been covered in a [previous demo]({{ site.baseurl }}/demo-04-rails-static-pages/), I give only a brief description of the steps.

<div class="video-container">
<iframe width="560" height="315" src="https://www.youtube.com/embed/_vKGqS6BWK4" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

1. Add a new contact page to house form _QuizMe_ users can use to send feedback to the developers. The contact page should have the URL <http://localhost:3000/contact>. The contact view should start with the following base content:

    ```erb
    <h1>Contact Us</h1>

    <p>We welcome your feedback. Please submit the form below to let us know what you think or alert us to any problems you are having with QuizMe.</p>

    <h2>Feedback</h2>

    <!-- Feedback form will go here -->

    <p><%= link_to 'Welcome', welcome_path %></p>
    ```

1. Add a link to the _Contact_ page to the bottom of the _Welcome_ page.

**[➥ Code changeset for this part](https://github.com/sdflem/quiz-me/commit/44ac01bdb4f47c734bf14e9f0801376c1ada2a4b)**

## 2. Collecting Form Data from the User

In this part, I will be building the form depicted in Fig. 1. The form will collect a users' name, email, whether someone from _QuizMe_ is allowed to contact them at the provided email, the kind of feedback they want to leave, and their message. For now, users will be able to fill out and submit the form, but the app will not yet process the input data submitted. I will cover input processing in the next part of the demo.

<div class="video-container">
<iframe width="560" height="315" src="https://www.youtube.com/embed/pXVcP3F8uVU" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

1. Create a new POST route for the URL <http://localhost:3000/contact> that points to a new `leave_feedback` action in the `StaticPagesController` class, and name the new route `'leave_feedback'`. The new route should look like this:

    ```ruby
    post 'contact', to: 'static_pages#leave_feedback', as: 'leave_feedback'
    ```

1. Create the `leave_feedback` action in the `StaticPagesController` class. It should return an HTML response that renders the `contact.html.erb` view. The action should look like this:

    ```ruby
    def leave_feedback
      respond_to do |format|
        format.html { render :contact }
      end
    end
    ```

1. In the `contact.html.erb` view, replace the form placeholder comment with a form block using the `form_with` helper. Specify that the form should send a POST request to the `leave_feedback_path` URL by setting the `url` and `method` arguments of `form_with`. By default, `form_with` expects the action to return a JavaScript response in the `respond_to` block; however, in this case, we need an HTML response. To make the form expect an HTML response, we use the `local: true` argument. Thus, the form block should look like this:

    ```erb
    <%= form_with url: leave_feedback_path, local: true, method: :post do %>

    <% end %>
    ```

    Notice that `<%= ... %>` elements (with an `=`) are used for these form helper functions, because the form helpers return raw HTML that we want displayed in the browser.

1. Use the following form helper methods to add the form fields to the `form_with` block. API documentation for these helper methods can be found [here](https://api.rubyonrails.org/v6.0.0/classes/ActionView/Helpers/FormTagHelper.html).

    1. Add a text field for the users' name that looks like this:

        ```erb
        <div>
          <%= label_tag "name" %>
          <%= text_field_tag "name", nil %>
        </div>
        ```

        The `text_field_tag` options are the field id (`"name"`) and the value in the field (`nil` at first). The `label_tag` ID should always match its paired form field ID (`"name"`).

        Also, in case you are not familiar, a `div` HTML element is just a container for other HTML elements, so you can logically group them.

    1. Add an email field for the users' email that looks like this:

        ```erb
        <div>
          <%= label_tag "email" %>
          <%= email_field_tag "email", nil %>
        </div>
        ```

        The `email_field_tag` arguments are the field ID (`"email"`) and the value in the field (`nil` at first).

    1. Add a radio button group for whether or not someone from _QuizMe_ is allowed to contact the user at the provided email. The group should have yes/no options and look like this:

        ```erb
        <div>
          <span>Can we contact you by email?</span>
          <div>
            <%= radio_button_tag "reply", true, true %>
            <%= label_tag "reply_yes", 'Yes' %>
          </div>
          <div>
            <%= radio_button_tag "reply", false, false %>
            <%= label_tag "reply_no", 'No' %>
          </div>
        </div>
        ```

        Similar to a `div`, a `span` is an HTML container, usually used to wrap some subset of a block of text.

        Radio buttons are used as a group such that the response from the user can be only one of multiple preset options, and only the chosen value will be submitted when the form is submitted. The above radio button has two options, `'Yes'` and `'No'`, which I will represent with the boolean values `true` and `false`. Each option needs to have its own `radio_button_tag` that controls the value passed back when the form is submitted and a `label_tag` that specifies the string the user sees for each option.

        The `radio_button_tag` options are:
            - the field ID (`"reply"`) which must be the same for all buttons in the group.
            - the value to be returned if this button is checked when the form is submitted (the boolean `true` in this case, although radio buttons can be set up to return data of any type).
            - a boolean for whether the button is checked. In this case, we want `'Yes'` to be the default option so that button is initially set to be checked and the other is not.

        For a group of radio buttons, the `label_tag` options should include a unique ID and the display value. The display value in the `label_tag` does not need to be the same as the return value from the `radio_button_tag`. By custom, the ID should be the name of the group (`"reply"`) followed by an underscore (`_`), then a unique string for each option. I chose to use the display values (`yes` and `no`) as the unique string, but it could just as easily have been something else, like the return values (`true` and `false`).

    1. Add a dropdown list for the kind of feedback the user wants to leave, either a review or a bug report. The dropdown should show the default message "Choose one..." when nothing has been selected. The code for the dropdown should look like this:

        ```erb
        <div>
          <%= label_tag "feedback_type" %>
          <%= select_tag "feedback_type", options_for_select([ "Review", "Bug Report" ]), prompt: 'Choose one...' %>
        </div>
        ```

        Functionally, dropdown lists are similar to radio buttons in that they allow the user to select one item from a set of predetermined options. However, unlike the Rails helper for radio buttons, the `select_tag` helper includes all options for the dropdown by passing them as an array of values (`[ "Review", "Bug Report" ]`) into the `options_for_select` function. The default text in the dropdown is set using the `prompt` option (`'Choose one...'`). As with most tag helpers, the first option is the field ID (`"feedback_type"`).

    1. Add a text area for the user's message that matches:

        ```erb
        <div>
          <%= label_tag "message" %><br />
          <%= text_area_tag "message", nil, size: "27x7" %>
        </div>
        ```

        An HTML text area is similar to a text field, but it instead allows multi-line user input. The options for the `text_area_tag` helper are the field ID (`"message"`), the value in the field (`nil` at first), and the optional `size` option. By default, the text area can hold 2 rows of 21 characters but you can change those values by setting the `rows` (R) or `cols` (C) options individually or using the size option to specify both in the form `"CxR"`.

    1. Add a button to submit the feedback form. The button's code should look like this:

        ```erb
        <%= submit_tag "Send Feedback" %>
        ```

        The `submit_tag` actually creates an HTML input tag (`<input type="submit"></input>`) instead of a button, but visually it still looks like a button when rendered in the browser.

        The main `submit_tag` argument is the text that the button will display (`"Send Feedback"`).

**[➥ Code changeset for this part](https://github.com/sdflem/quiz-me/commit/1201588e156f74e9e730f7ef898bf5c136beb2f7)**

## 3. Processing User-Submitted Form Data in the Controller

In this part, I will make the `leave_feedback` controller action process the user data submitted via a form. All form fields will be required to accept a submission. Submitting the form will reload the _Contact_ page with a status message that tells the user if the submission was valid or if they missed any fields.

<div class="video-container">
<iframe width="560" height="315" src="https://www.youtube.com/embed/VeLVcfSAvYo" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

Form-input data is sent to the controller via the `params` hash. In Ruby, a _hash_ is a key-value data structure (similar to a dictionary in Python). You can set values for all the keys in the hash using code like `options = { font_size: 10, font_family: "Arial" }`, or you can set or access a single value using code like `options[:font_size]`. When a form is submitted the field ID (key) and value of each form field is added to the `params` hash. Also, the params hash only uses string values, so even if the field takes an integer or a boolean it will be converted to a string. You need to be aware of this if you are doing comparisons in the controller.

The controller action should check if all required fields have a value other than `nil` or a blank string (i.e., one that is `""` or contains only whitespace characters). If all fields have data, the user should be notified that their feedback has been accepted. If not, they should be told to fill out the remaining fields.

1. Check that all fields have been filled by setting a boolean variable `form_complete`. This can be achieved by iterating over each form key and checking that it exists in the params hash and that it has a non-blank value. The code to do the checking should look like this:

    ```ruby
    required = [:name, :email, :reply, :feedback_type, :message]
    form_complete = true
    required.each do |f|
      if params.has_key? f and not params[f].blank?
        # that's good news. do nothing
      else
        form_complete = false
      end
    end
    ```

    The `has_key?` method checks if the given key exists as a key in the hash. Then, you can check that the string value for that key is not nil or blank with the `blank?` method.

1. After the app determines whether the form is complete and accepted, it passes an appropriate status message to the view. To set this up, do the following.

    1. Set the status message in the controller based on the `form_complete` boolean. The code should match:

        ```ruby
        if form_complete
          form_status_msg = 'Thank you for your feedback!'
        else
          form_status_msg = 'Please fill in all the remaining form fields and resubmit.'
        end
        ```

    1. Pass the status message into the response by adding a new local variable to match:

        ```ruby
        format.html { render :contact, locals: { status_msg: form_status_msg } }
        ```

    1. Add code to `contact.html.erb` below the _Feedback_ heading to display the status message if it has been set. The code should look like this:

        ```erb
        <% if local_assigns.has_key? :status_msg %>
          <p><%= status_msg %></p>
        <% end %>
        ```

        Similar to the `params` hash, local variables available in the view are also stored in a hash called `local_assigns`. You can use the `has_key?` method to check that the status message has been set.

1. At this point, the user should be able to submit the form and see the response message. However, if the user is told the form was incomplete, the current version of the app requires them to re-enter their information for all the fields, not just the ones that were missing/invalid. We can fix this usability problem by passing the data from the `params` hash back into the view in a new hash local variable `feedback`. Then, in the view, we can set the value of each form field based on the `feedback` hash. If a field has no value in the `feedback` hash, it will be set to the original default value for the field. The following steps set this up:

    1. In the `leave_feedback` controller action, add the `feedback` variable to the response by changing the HTML response to look like this:

        ```ruby
        format.html { render :contact, locals: { status_msg: form_status_msg, feedback: params } }
        ```

    1. In the `contact` controller action, add the `feedback` variable to the response by changing the HTML response to look like this:

        ```ruby
        format.html { render :contact, locals: { feedback: {} } }
        ```

        This change is needed, because the `contact.html.erb` view code will assume that a `feedback` hash exists, so whenever the view is rendered, a hash must be passed in. However, the hash may be empty (as it is in this case).

    1. Change the fields' values to come from the `feedback` hash if set and to use the default if not. Previously, we used the `has_key?` method with an `if` statement to optionally set this. We might try doing the same here using the following [ternary operator](https://syntaxdb.com/ref/ruby/ternary):

        ```erb
        <%= text_field_tag "name", feedback.has_key?(:name) ? feedback[:name] : nil %>
        ```

        However, this change would need to be made for every field, and it could quickly become overly complicated. Instead, we will use the hash `fetch` operation to get the value for a key if the key exists, or to specify what value to return if the key is not found. Using `fetch`, the code for all the fields should be updated to look like the following.

        The text fields and text area are fairly straightforward:

        ```erb
        <%= text_field_tag "name", feedback.fetch(:name, nil) %>
        ```

        ```erb
        <%= email_field_tag "email", feedback.fetch(:email, nil) %>
        ```

        ```erb
        <%= text_area_tag "message", feedback.fetch(:message, nil), size: "27x7" %>
        ```

        With radio buttons, you need to make sure that the checked value is set based on the value for the `"reply"` key. You also need to convert the true/false values to strings using the `to_s` method before making the comparison, like this:

        ```erb
        <div>
          <%= radio_button_tag "reply", true, feedback.fetch(:reply, nil) == true.to_s %>
          <%= label_tag "reply_yes", 'Yes' %>
        </div>
        <div>
          <%= radio_button_tag "reply", false, feedback.fetch(:reply, nil) == false.to_s %>
          <%= label_tag "reply_no", 'No' %>
        </div>
        ```

        With dropdown selects, the selected option is the second parameter to the `options_for_select` method. If nothing is selected, it should be set to the empty string `""` (and not `nil`), like this:

        ```erb
        <%= select_tag "feedback_type", options_for_select([ "Review", "Bug Report" ], feedback.fetch(:feedback_type, "")), prompt: 'Choose one...' %>
        ```

We should now have a working form that users can use to easily enter their feedback and see if it has been accepted. We will see in the next few demos how to further improve this form by using remote form submission (to stop the page from reloading every time the form is submitted) and using so-called _flash_ messages (to display a more dynamic status message). Of course, at this point, a big omission to the feedback form feature is having it actually do something useful with the submitted data, like saving the data. Upcoming demos will also cover a variety of ways to save and process such form data.

**[➥ Code changeset for this part](https://github.com/sdflem/quiz-me/commit/cde8d654fef8dd34055cee1f47e2116bd5817d88)**
