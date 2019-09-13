---
layout: page
title: 'Demo 7: Passing Data From View to Controller'
permalink: /demo-07-passing-data-from-view-to-controller/
---

# Demo 7: Passing Data From View to Controller

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

1. In the `form_with` block, add a text field for the users' name, an email field for the users' email, a radio button group for whether someone from _QuizMe_ is allowed to contact them at the provided email, a dropdown select for the kind of feedback they want to leave, and a textarea for their message. 

    ```erb
    <%= form_with url: leave_feedback_path, local: true, method: :post do %>

      <div>
        <%= label_tag "name" %>
        <%= text_field_tag "name", nil %>
      </div>

      <div>
        <%= label_tag "email" %>
        <%= email_field_tag "email", nil %>
      </div>

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

      <div>
        <%= label_tag "feedback_type" %>
        <%= select_tag "feedback_type", options_for_select([ "Review", "Bug Report" ]), prompt: 'Choose one...' %>
      </div>

      <div>
        <%= label_tag "message" %><br />
        <%= text_area_tag "message", nil, size: "27x7" %>
      </div>

      <%= submit_tag("Send Feedback") %>

    <% end %>
    ```
