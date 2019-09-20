---
layout: page
title: 'Demo 6: Passing Data From View to Controller'
permalink: /demo-06-passing-data-from-view-to-controller/
---

# Demo 6: Passing Data From View to Controller

In this demonstration, I will show how to pass data collected with a form in the view to the controller action for processing. I will continue to work on the _QuizMe_ project from the previous demos.

This and all future demos will assume you are starting in the workspace folder on your virtual machine.

## Pre-demo Setup

1. Add a new contact page to house form _QuizMe_ users can use to send feedback to the developers. The contact page should have the URL <http://localhost:3000/contact>. The contact view should start with the following base content:

    ```erb
    <h1>Contact Us</h1>

    <p>We welcome your feedback. Please submit the form below to let us know what you think or alert us to any problems you are having with QuizMe.</p>

    <h2>Feedback</h2>

    <!-- Feedback form -->

    <p><%= link_to 'Welcome', welcome_path %></p>
    ```

1. Add a link to the contact page to the bottom of the welcome page.

## 1. Collecting Data from the User in the View

TODO: whats a form and request cycle things

I will be building this [feedback form](/resources/feedback-form.png) that collects users' name, email, whether someone from _QuizMe_ is allowed to contact them at the provided email, the kind of feedback they want to leave, and their message. All form fields will be required. Submitting the form will reload the contact page with a status message that tells the user if the submission was valid or if they missed any fields.

1. Create a POST route for the URL <http://localhost:3000/contact> that points to a new `leave_feedback` action in the StaticPagesController and name the new route "leave_feedback".  The new route should match:

    ```ruby
    post 'contact', to: 'static_pages#leave_feedback', as: 'leave_feedback'
    ```

1. Create the `leave_feedback` action in the controller. It should return an HTML response that renders the `contact.html.erb` view. The action should match:

    ```ruby
    def leave_feedback
      respond_to do |format|
        format.html { render :contact }
      end
    end
    ```

1. In the `contact.html.erb` view, create a form block using the `form_with` helper in the indicated location. Specify that the form should send a POST request to the `leave_feedback_path` URL by setting the `url` and `method` options on the `form_with`. By default, `form_with` expects the action to return a Javascript response in the `respond_to` block, but we need an HTML response so we can specify HTML with the `local: true` option. The form block should match:

    ```erb
    <%= form_with url: leave_feedback_path, local: true, method: :post do %>

    <% end %>
    ```

    Notice the <%= %> are used with these helper functions because they return raw HTML which we want displayed in the browser.

1. Use the methods from the Rails FormTagHelpers to add the following form fields to the `form_with` block:

    1. Add a text field for the users' name that matches:

        ```erb
        <div>
          <%= label_tag "name" %>
          <%= text_field_tag "name", nil %>
        </div>
        ```

        The `text_field_tag` options are the field id ("name") and the value in the field (`nil` at first). The `label_tag` id should always match its paired form field id ("name").

        Also, if you are not familiar with them, a `div` is just an container for other HTML elements so you can logically group them.

    1. Add an email field for the users' email that matches:

        ```erb
        <div>
          <%= label_tag "email" %>
          <%= email_field_tag "email", nil %>
        </div>
        ```

        The `email_field_tag` options are the field id ("email") and the value in the field (`nil` at first).

    1. Add radio button group for whether or not someone from _QuizMe_ is allowed to contact the user at the provided email. The group should have yes/no options that match:

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

        Similar to a `div`, a span is an HTML container usually used to wrap some subset of a block of text.

        Radio buttons are used as a group where the response from the user can be only one of multiple preset options and only that chosen value will be submitted when the form is submitted. This group has two options, 'Yes' and 'No', which I will represent with the boolean values `true` and `false`. Each option needs to have its own `radio_button_tag` that controls the value passed back when the form is submitted and a `label_tag` which determines what string the user sees for each option.

        The `radio_button_tag` options are:
            - the field id ("reply") which must be the same for all buttons in the group.
            - the value to be returned if this button is checked when the form is submitted (the boolean `true` in this case, although radio buttons can be set up to return data of any type).
            - a boolean for whether the button is checked. In this case, we want 'Yes' to be the default option so that button is set to be checked and the other is not.

        For a group of radio buttons, the `label_tag` options should include a unique id and the display value. The display value in the `label_tag` does not need to be the same as the return value from the `radio_button_tag`. By custom, the id should be the name of the group ("reply") followed by an underscore then a unique string for each option. I chose to use the display values (yes or no) as the unique string but it could just as easily be the return value (true or false).

    1. Add a dropdown select for the kind of feedback the user wants to leave, either a review or a bug report. The dropdown should show the default message "Choose one..." when nothing has been selected. The code for the dropdown should match:

        ```erb
        <div>
          <%= label_tag "feedback_type" %>
          <%= select_tag "feedback_type", options_for_select([ "Review", "Bug Report" ]), prompt: 'Choose one...' %>
        </div>
        ```

        Functionally, dropdown selects are similar to radio buttons in that they allow the user to select one from a set of predetermined options. However, unlike the Rails helper for radio buttons, the `select_tag` helper includes all options for the dropdown by passing them as an array of values ([ "Review", "Bug Report" ]) into the `options_for_select` function. The default text in the dropdown is set using the prompt option ('Choose one...'). As with most tag helpers, the first option is the field id ("feedback_type").

    1. Add a textarea for the user's message that matches:

        ```erb
        <div>
          <%= label_tag "message" %><br />
          <%= text_area_tag "message", nil, size: "27x7" %>
        </div>
        ```

        An HTML textarea is similar to a text field but allows multiline user input. The options for the text_area_tag helper are the field id ("message"), the value in the field ("nil" at first), and the optional size option. By default, the textarea can hold 2 rows of 21 characters but you can change those values by setting the `rows` (R) or `cols` (C) options individually or using the size option to specify both in the form "CxR".

    1. Add a button to submit the feedback form. The text on the button should be "Send Feedback". The button's code should match:

        ```erb
        <%= submit_tag "Send Feedback" %>
        ```

        The `submit_tag` actually creates an HTML input tag (`<input type="submit"></input>`) instead of a button but visually it still looks like a button when rendered in the browser.

        The main `submit_tag` option is the text that the button will display.

## 2. Processing Data from a Form in the Controller

Data the user inputs to the form is sent to the controller via the `params` hash. A hash is a key-value data structure similar to a dictionary. You can set values for all the keys in the hash using something like `options = { font_size: 10, font_family: "Arial" }` or you can set or access a single value using `options[:font_size]`. When a form is submitted the field id (key) and value of each form field is added to the `params` hash. Also, the params hash only uses string values, so even if the field takes an integer or a boolean it will be converted to a string. You need to be aware of this if you are doing comparisons in the controller.

The controller action should check if all required fields have a value other than `nil` or the empty string (`""`). If all fields have data, the user should be notified that their feedback has been accepted. If not, they should be told to fill out the remaining fields.

1. Check that all fields have been filled by setting a boolean variable `form_complete`. This can be achieved by iterating over each form key we created and checking that it exists in the params hash and has a non-blank value. The code for this should match:

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

    The `has_key?` method checks if the given key exists as a key in the hash. Then you can check that the string value for that key is not nil or the empty string with the `blank?` method.

1. After we know if the form is complete and accepted, we need to let the user know that by passing a status message to the view.

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

    1. Add code to `contact.html.erb` below the "Feedback" heading to display the status message if it has been set. The code should match:

        ```erb
        <% if local_assigns.has_key? :status_msg %>
          <p><%= status_msg %></p>
        <% end %>
        ```

        Similar to the params hash, local variables available in the view are also stored in a hash called `local_assigns`. You can use the `has_key?` method to check that the status message has been set.

1. At this point, the user should be able to submit the form and see the response message. However, if the user is told the form was incomplete, they must reenter their information into all the fields not just the ones that were missing. We can fix this by passing the data from the params hash back into the view in a new hash local variable `feedback` and then setting the value of the form fields in the view to come from the feedback hash if they are set or use the default value if not.

    1. Add the `feedback` variable to the response by changing the HTML response to match:

        ```ruby
        format.html { render :contact, locals: { status_msg: form_status_msg, feedback: params } }
        ```

    1. Change the fields' values to come from the `feedback` hash if set and to use the default if not. Previously, we used the `has_key?` method with an if statement to optionally set this. We could do the same here using the following (ternary)[<https://syntaxdb.com/ref/ruby/ternary>]:

        ```erb
        <%= text_field_tag "name", feedback.has_key?(:name) ? feedback[:name] : nil %>
        ```

        However, this needs to be done for every field and could be overly complicated. Instead, we can use the hash `fetch` function to get the value for a key if it exists or specify what value to return if the key is not found. Using `fetch`, the code for all the fields should be updated to match:

        ```erb
        <%= text_field_tag "name", feedback.fetch(:name, nil) %>
        ```

        ```erb
        <%= email_field_tag "email", feedback.fetch(:email, nil) %>
        ```

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

        With radio buttons, you need to make sure the checked value is set based on the value for the "reply" key. You also need to convert the true/false values to strings using the `to_s` method before making the comparison.

        ```erb
        <%= select_tag "feedback_type", options_for_select([ "Review", "Bug Report" ], feedback.fetch(:feedback_type, "")), prompt: 'Choose one...' %>
        ```

        With dropdown selects, the selected option is the second parameter to the `options_for_select` method. If nothing is selected, it should be the empty string instead of nil.

        ```erb
        <%= text_area_tag "message", feedback.fetch(:message, nil), size: "27x7" %>
        ```

We should now have a working form that users can use to easily enter their feedback and see if it has been accepted. Although the form appears to work very well, we will see in the next few demos that this can be significantly improved using remote form submission to stop the page from reloading every time the form is submitted and flash messages to display a more dynamic status message.
