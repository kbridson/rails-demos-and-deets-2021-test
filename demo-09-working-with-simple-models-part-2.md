---
layout: page
title: 'Demo 9: Forms for Creating New Model Records'
permalink: /demo-09-new-create-forms/
---

# Demo 9: Forms for Creating New Model Records

In this demonstration, I will show how to add controller actions and views that allow users to create new model records and save them to the database. We will continue to build upon the _QuizMe_ project from the previous demos.

In particular, we will create a form for creating new multiple-choice questions, as shown in Figure 1.

<div class="figure-container mx-auto my-4" style="max-width: 960px;">
<figure class="figure">
<img src="{{ site.baseurl }}/resources/new_mc_question_page.png" class="figure-img img-fluid rounded border" alt="Screenshot of browser page with form for creating new multiple-choice questions">
<figcaption class="figure-caption">Figure 1. Form page for creating new multiple-choice questions.</figcaption>
</figure>
</div>

Successful submissions of the form will result in saving the specified question to the database, redirecting the browser to the `index` page for multiple-choice questions, and displaying a success notification at the top of the `index` page. For example, Figure 2 illustrates the results of submitting a new "Who shot Mr Burns?" question. Note the "Question saved successfully" notification at the top of the page and the new multiple-choice question that has been added to the set of three seed-data questions.

<div class="figure-container mx-auto my-4" style="max-width: 960px;">
<figure class="figure">
<img src="{{ site.baseurl }}/resources/create_mc_question_result.png" class="figure-img img-fluid rounded border" alt="Screenshot of browser page with index page of multiple-choice questions and success notification message at the top">
<figcaption class="figure-caption">Figure 2. The result of successfully submitting the form in Figure 1. In particular, (1) the new question will be saved to the database (see the "Who shot Mr Burns?" question); (2) the browser will be redirected to the <code>index</code> page for multiple-choice questions; and (3) a success notification will be displayed at the top of the <code>index</code> page (see the "Question saved successfully" message).</figcaption>
</figure>
</div>

There will be two main parts to this demo. In the first part, we will refactor our code for displaying notification messages, so that it works better with the forms we will be creating in this and future demos. In the second part, we will implement the form page and the logic for processing form submissions.

## 1. Passing Notification Messages to the View with the Flash

In this part, we will refactor our existing notification-message code to work better with the new forms we will be implementing. It is common for modern web apps to display notification messages after the user performs certain operations. For example, if the user submits a form, a success notification might appear to let them know that the submission was successful. Similarly, if the form submission failed, an error notification might appear.

To implement such messages, Rails provides _the flash_. The flash is basically a hash that controllers and ERBs can read and write. The flash is part of the session, so the data stored in the flash is specific to a particular user session. What makes the flash special is that the saved data is available only for the next HTTP request of the session. When that request completes, the data is automatically deleted. (For more info on sessions and the flash, see [this deets page]({{ site.baseurl }}/deets-sessions/).)

To demonstrate using the flash, let's refactor the code we wrote for the feedback form's status message. Instead of passing the status message to the view as a local variable, we can put the message in the `flash` hash under the key `:status_msg`, like this:

1. In the `leave_feedback` method of `StaticPagesController`, remove the status message from the `locals` hash, and add the status message to the `flash` hash, like this:

    ```ruby
    respond_to do |format|
      format.html {
        flash.now[:status_msg] = form_status_msg
        render :contact, locals: { feedback: params }
      }
    end
    ```

    Note that in this example we use `flash.now`, because we want the flash notification to be available during the current request (and not the next one).

1. In the `contact.html.erb` view, replace the current code for displaying the status message with the following code that displays the status message using the flask:

    ```erb
    <% if flash.key? :status_msg %>
      <p><%= flash[:status_msg] %></p>
    <% end %>
    ```

    Submit the feedback form to see the flash message working.

    Since it is common to display flash messages in a variety of different views, it makes the the most sense to put the above view code in a single place—namely, the `application.html.erb` layout. In Rails, when a controller action renders a view, that view is implicitly wrapped in the default layout, `application.html.erb`, found in `app/views/layouts`. This layout contains the `<html>`, `<head>`, `<body>`, etc. tags required for all HTML pages. View code we write, such as `show.html.erb`, is actually rendered inside the `application.html.erb` layout. A `<%= yield %>` statement within `application.html.erb` specifies where the view code is inserted. To move the code for displaying flash messages to the `application.html.erb` layout, we do as follows.

1. Display all flash messages (if there are any) on any given page by inserting the following code above the `<%= yield %>` in `application.html.erb`, like this:

    ```erb
    <% flash.each do |key, message| %>
      <p><%= message %></p>
    <% end %>
    ```

1. Remove the now redundant flash message displaying code in the `contact.html.erb` view.

    You should be able to run the app and see that the notification messages are still working.

## 2. Creating New Model Records with a Form

Previously, we have seen only how to save new the records to the database by using the `seeds.rb` file; however, we also want users to be able to create, update, and delete records. In this part, we will implement a form that enables users to create new multiple-choice questions.

Recall that the most straightforward way to enable a user to pass data to the server is via a form. Also, remember that a form page requires two controller actions: one to display the form and one to process the form submission. Following the [RESTful](https://en.wikipedia.org/wiki/Representational_state_transfer) architectural style (widely considered a best practice), the two (semi-standard) actions for creating new model records are `new` and `create`. The `new` action renders the page containing the form, and the `create` action processes the form submission, attempts to save the new object in the database, and performs error handling if the object cannot be saved.

## 2.1. Rendering the Form with the `new` Action

First, let's create the `new` action to render the form page depicted in Figure 1:

1. In the `McQuestionsController`, add a `new` action that will render the standard corresponding view and pass an empty `McQuestion` object to use in the form, like this:

    ```ruby
    def new
      question = McQuestion.new
      respond_to do |format|
        format.html { render :new, locals: { question: question } }
      end
    end
    ```

1. Also add an empty placeholder `create` action, like this:

    ```ruby
    def create
      # TODO
    end
    ```

1. Add to `routes.rb` the standard resource routes for these `new` and `create` actions. Insert them in between the `index` and `show` routes, like this:

    ```ruby
    # index route
    get 'mc_questions/new', to: 'mc_questions#new', as: 'new_mc_question' # new
    post 'mc_questions', to: 'mc_questions#create'                        # create
    # show route
    ```

    Pay attention to the order of the routes! If the new route were to be inserted _after_ the `show` route, requests to <http://localhost:3000/mc_questions/new> would incorrectly match with the `show` route, because the `show` route would think the `new` part of the path is an `id`, which is wrong, of course, and would lead to lots of potentially confusing downstream errors.

1. Create the `new.html.erb` file under `app/views/mc_questions`, like this:

    ```erb
    <h1>New Question</h1>

    <%= form_with url: mc_questions_path, method: :post, local: true do %>

    <% end %>
    ```

    Using the above options for the `form_with` helper should be familiar to you from the feedback form we added previously. However, unlike the feedback form, this form will use a model object, so we need to add a `model` option that specifies the object and a `scope` option that groups all the model form data under a single key in the `params` hash.

1. Add the `model` and `scope` options, like this:

    ```erb
    <%= form_with model: question, url: mc_questions_path, method: :post, local: true, scope: :mc_question do %>
    ```

1. Another change from the feedback form is that we will use the model form field helpers instead of the form tag helpers. To use the new helpers, we need to add a local variable to the form block called `form`, like this:

    ```erb
    <%= form_with model: question, url: mc_questions_path, method: :post, local: true, scope: :mc_question do |form| %>
    ```

1. Add text fields to the form for each of the `McQuestion` attributes, like this:

    ```erb
    <div>
      <%= form.label :question %><br>
      <%= form.text_field :question %>
    </div>
    ```

    Note how the form labels and fields are now being created by calls to methods of the `form` object, instead of using, for example, the `label_tag` and `text_field_tag` helpers we had seen previously.

1. Add the submit button as follows:

    ```erb
    <%= form.submit "Add Question" %>
    ```

    You can now visit <http://localhost:3000/mc_questions/new> to see the form display, but submitting it won't do anything yet.

1. As a final step for this part, add a link to the `new` question page under the `index` page heading, so users have a way of getting to the form, like this:

    ```erb
    <%= link_to 'New Question', new_mc_question_path %>
    ```

## 2.2. Processing Form Data with the `create` Action

Now let's add the logic to the `create` action. The action will need to retrieve the form data for a question from the `params` hash, create a new `McQuestion` object based on the form data, and save the object to the database. We will perform a redirect action if it saves correctly, or render the form again with an error message if the save fails. 

1. First, rough in some psuedocode to clarify what's needed, like this:

    ```ruby
    def create
      # new object from params
      # respond_to block
        # if question saves
          # redirect to index
        # else
          # render new
    end
    ```

1. Create the new `McQuestion` object based the `params` hash, like this:

    ```ruby
    # new object from params
    question = McQuestion.new(params.require(:mc_question).permit(:question, :answer, :distractor_1, :distractor_2))
    ```

    Data from the `params` hash isn't necessarily safe. Any data received from a POST request could have been tampered with or fabricated, and new keys could have been added that were not on the original form, all in an attempt to exploit latent bugs in the app. Since we know that the form should contain only `McQuestion` attribute data (i.e., `question`, `answer`, etc.) and that those data are scoped under the top-level `:mc_question` key, we can require that the `:mc_question` key must exist in the `params` hash and that only the specified attributes are allowed. (We will still have to be careful, though, because malicious data may have been submitted for those attributes.)

1. Begin to respond to the request and attempt to save the new model object by beginning to flesh out the `respond_to` block, like this:

    ```ruby
    # respond_to block
    respond_to do |format|
      # html format block
      format.html {
        if question.save
          # success message
          # redirect to index
        else
          # error message
          # render new
        end
      }
    end
    ```

    Note that this code embeds the call to `save` in an `if` statement that will behave differently (see the `if` versus `else` logic), depending on whether or not the save is successful.

1. On a successful save, insert a success message in the `flash` hash and preform an HTTP redirect to the `index` page, like this:

    ```ruby
    # success message
    flash[:success] = "Question saved successfully"
    # redirect to index
    redirect_to mc_questions_url, notice: "Question saved successfully"
    ```

1. On a failed save, add an error message to the flash using `flash.now`, and render the `new` form, so the user can try again, like this:

    ```ruby
    # error message
    flash.now[:error] = "Error: Question could not be saved"
    # render new
    render :new, locals: { question: question }
    ```

Users should be able to create new questions using the form!
