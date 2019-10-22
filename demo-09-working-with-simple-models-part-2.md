---
layout: page
title: 'Demo 9: Working with Simple Models (part 2)'
permalink: /demo-09-working-with-simple-models-part-2/
---

# Demo 9: Working with Simple Models (part 2)

In this demonstration, I will show how to add controller actions and views that allow users to create, update, and delete database records. I will continue to work on the _QuizMe_ project from the previous demos.

## 1. Refactoring: Utilizing Flash for Message Passing to View

What is flash?
- special kind of session storage
- messages stored in a Ruby hash under a key (key can be anything although there are standard keys people use)
- once its contents are read, those contents disappear in contrast to normal session which is designed to persist data
- the flash is designed to be available on the next request (redirect_to)
- can use flash.now to access flash on current request (render)

To demonstrate using flash, let's refactor the code we wrote for the feedback form status message. Instead of passing it to the view as a local variable, we can put in the flash hash under the key `status_msg`.

1. Add the status message to the flash hash and remove it from the locals hash, like this:

    ```ruby
    respond_to do |format|
      format.html {
        flash.now[:status_msg] = form_status_msg
        render :contact, locals: { feedback: params }
      }
    end
    ```

2. Display the message from flash in the view.

    ```erb
    <% if flash.key? :status_msg %>
      <p><%= flash[:status_msg] %></p>
    <% end %>
    ```

Submit the feedback form to see the flash message working.

Flash messages are used for message passing to the view in many distinct controller actions which translates to many views, so it is better to move the display logic for flash messages to a universal layout file instead of duplicating it. By default the default HTML view for each controller action will be wrapped in the layout file `application.html.erb` found in `app/views/layouts`. This file contains the `<html>`, `<head>`, and `<body>` tags required for all HTML pages. The code in a view that we wrote, e.g. show.html.erb, will be rendered inside the application layout in place of the `<%= yield %>` statement.

1. Add code above the `<%= yield %>` to display all the the flash messages (if there are any) on each page like this:

    ```erb
    <% flash.each do |key, message| %>
      <p><%= message %></p>
    <% end %>
    ```

    With this statement, you can remove any flash message display code in the individual views.

## 2. Creating Records

Previously, we have been able to change the records in the database by altering the seeds file; however, in some cases, we really want users to be able to create, update or delete records. In this section, we will just work on creating records.

From making the feedback form, recall that the easiest way to allow the user to give a set of information to the server is by using a form. Also, remember that a form page requires two controller actions: one to display the form and one to process the form submission. By RESTful conventions, the actions used for creating new objects of a model are called `new` and `create`. The new action will render the page containing the form and the create action will process the form submission, attempt to save the new object in the database, and perform error handling if the object cannot be saved.

First, let's create the `new` page:

1. In the `McQuestionsController`, add a `new` action that will render the standard corresponding view and pass an empty McQuestion object to use in the form. The code should be:

    ```ruby
    def new
      question = McQuestion.new
      respond_to do |format|
        format.html { render :new, locals: { question: question } }
      end
    end
    ```

1. Add an empty `create` action.

1. Add the standard resource routes for the `McQuestionsController`'s `new` and `create` actions as follows:

    ```ruby
    # index route
    get 'mc_questions/new', to: 'mc_questions#new', as: 'new_mc_question' # new
    post 'mc_questions', to: 'mc_questions#create'                        # create
    # show route
    ```

    Pay attention to the order of the routes. If the new route comes after the show route, Rails will try to execute the show action for a question with `id=new` instead of using the new action.

1. Create the `new.html.erb` file under `app/views/mc_questions` containing the following code:

    ```erb
    <h1>New Question</h1>

    <%= form_with url: mc_questions_path, method: :post, local: true do %>

    <% end %>
    ```

Using these options for the `form_with` helper should be familiar to you from the feedback form we added in Demo 6. They match the `create` route we just made. Unlike the feedback form, this form will use a model object, so we need to add a model option that specifies the object and a scope option that groups all the model form data under a single key in the params hash.

1. Add the model and scope options as follows:

    ```erb
    <%= form_with model: question, url: mc_questions_path, method: :post, local: true, scope: :mc_question do %>
    ```

1. Another change from the feedback form is that we will use the model form field helpers instead of the form tag helpers. To use the new helpers, we need to add a local variable to the form block called `form` like this:

    ```erb
    <%= form_with model: question, url: mc_questions_path, method: :post, local: true, scope: :mc_question do |form| %>
    ```

1. Add text fields to the form for each of the McQuestion attributes. The fields should follow the following format: 

    ```erb
    <div>
      <%= form.label :question %><br>
      <%= form.text_field :question %>
    </div>
    ```

1. Add the submit button as follows:

    ```erb
    <%= form.submit "Add Question" %>
    ```

You can now visit <http://localhost:3000/mc_questions/new> to see the form display, but it doesn't do anything yet.

1. Add a link to the new question page under the index page heading.

Now let's add the logic to the `create` action. We need to get the data for the question from the params hash and try to save it. We will perform a redirect action if it saves correctly, or render the form again with an error message if not. Psuedocode for the logic would look like:

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

1. Add code to create the new object from the params hash like this:

    ```ruby
    # new object from params
    question = McQuestion.new(params.require(:mc_question).permit(:question, :answer, :distractor_1, :distractor_2))
    ```

    Data from the params hash isn't necessarily safe. The data on a post request can be altered and new keys could be added that were not on the original form. Since we know we only want the data from the keys for the `McQuestion` model attributes that are scoped under the top level `mc_question` key, we can require that that top-level key exist and only permit the attributes we want. This still does not stop bad data from being passed into those keys.

1. Add the respond to block and if logic using the `save` method:

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

1. Complete the logic for no errors on question.save by adding a success message to the flash and a redirect to the index page using the named url helper:

    ```ruby
    # success message
    flash[:success] = "Question saved successfully"
    # redirect to index
    redirect_to mc_questions_url, notice: "Question saved successfully"
    ```

1. Complete the logic for errors on question.save by adding an error message to the flash using `flash.now` and a redirect to the index page using the named url helper:

    ```ruby
    # error message
    flash.now[:error] = "Error: Question could not be saved"
    # render new
    render :new, locals: { question: question }
    ```

Users can now create new questions. TADA!