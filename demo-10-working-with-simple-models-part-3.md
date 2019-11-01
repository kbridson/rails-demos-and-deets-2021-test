---
layout: page
title: 'Demo 10: Working with Simple Models (part 3)'
permalink: /demo-10-working-with-simple-models-part-3/
---

# {{ page.title }}

In this demonstration, I will show how to add controller actions and views that allow users to update and delete database records. I will continue to work on the _QuizMe_ project from the previous demos.

## 1. Updating Records

In the previous demo, we added the ability for users to create new questions; however, once a question is saved they have no way to edit the attributes. In this section, we will work on adding the ability to update records.

The update functionality will be similar to the create functionality in that users will edit the attributes in a form. However, this form will use an existing object, so we need to use the `find` query method to get the correct object in both controller actions. The actions we will use will be `edit` and `update`. Based on the `new` and `update` actions, you might guess that the `edit` action will be responsible for displaying the form, the form will submit to the `update` action, and the `update` action will be responsible for saving the changes or returning errors. Unlike `new` and `create`, both the `edit` and `update` actions will need to be supplied an existing record's id, so their routes will contain a URL parameter `:id` which is the id of the record to modify.

Let's start by setting up the `edit` and `update` boilerplate:

1. Add the standard resource routes for the `McQuestionsController`'s `edit` and `update` actions:

    ```ruby
    # index route
    # new route
    # create route
    get 'mc_questions/:id/edit', to: 'mc_questions#edit', as: 'edit_mc_question' # edit
    patch 'mc_questions/:id', to: 'mc_questions#update'                          # update (as needed)
    put 'mc_questions/:id', to: 'mc_questions#update'                            # update (full replacement)
    # show route
    ```

    Pay attention to the order of the routes. Also, notice that instead of using a POST request for update, we have two new request types: PATCH and PUT. 
    TODO: Patch vs put "Use PUT when you want to modify a singular resource which is already a part of resources collection. PUT replaces the resource in its entirety. Use PATCH if request updates part of the resource."

    > You can also combine the patch and put routes into one line with:

        ```ruby
        match 'mc_questions/:id', to: 'mc_questions#update', via: [:put, :patch]
        ```

        This only works because the path and controller method are the same for different request types.

1. In the `McQuestionsController`, add a `edit` action that will render the standard corresponding view and pass an empty McQuestion object to use in the form. The code should be:

    ```ruby
    def edit
      # object to use in form
      question = McQuestion.find(params[:id])
      respond_to do |format|
        format.html { render :edit, locals: { question: question } }
      end
    end
    ```

1. Add an empty `update` action.

1. Create the `edit.html.erb` file under `app/views/mc_questions` containing the following code:

    ```erb
    <h1>Edit Question</h1>

    <%= form_with model: question, url: mc_question_path, method: :patch, local: true, scope: :mc_question do |form| %>

      <!-- attribute fields -->
      <div>
        <%= form.label :question %><br>
        <%= form.text_field :question %>
      </div>

      <div>
        <%= form.label :answer %><br>
        <%= form.text_field :answer %>
      </div>

      <div>
        <%= form.label :distractor_1 %><br>
        <%= form.text_field :distractor_1 %>
      </div>

      <div>
        <%= form.label :distractor_2 %><br>
        <%= form.text_field :distractor_2 %>
      </div>

      <%= form.submit 'Update Question' %>

    <% end %>
    ```

    This code is largely the same as `new.html.erb`. The heading has changed to "Edit". The `url` and `method` options on the `form_with` helper have been changed to match the update route. The submit button text has been changed to "Update".

At this point, you can try visiting <http://localhost:3000/mc_questions/1/edit> to see the data load and the form display. Depending on how you recently you have reset the database, it might be difficult to guess an id of an existing object in your database so you may get `RecordNotFound` errors. It would be better to add links to the edit pages for each object instead of trying to guess the URL ourselves.

1. Add an show (🛈 symbol) and edit (✎ symbol) link to the display of each question on the index page by changing the question display to:

    ```erb
    <p>
      <%= question.question %>
      <%= link_to '🛈', mc_question_path(question) %>
      <%= link_to '✎', edit_mc_question_path(question) %>
    </p>
    ```

    You might also want to add the edit symbol after the question text on the show page as well.

You should now be able to go to the edit page for any question by clicking the `✎` link for that question on the index page.

Now let's add the logic to the `update` action. We need to load the existing object from the database again using the id passed through the update path and attempt to update it using the permitted parameters from mc_question in the params hash. We will perform a redirect action if it updates correctly, or render the form again with an error message if not. Psuedocode for the logic would look like:

    ```ruby
    def update
      # load existing object again from URL param
      # respond_to block
        # html format block
          # if question updates with permitted params
            # success message
            # redirect to index
          # else
            # error message
            # render edit
    end
    ```

1. Add code to load the existing object using the id from the path in params hash like this:

    ```ruby
    # load existing object again from URL param
    question = McQuestion.find(params[:id])
    ```

1. Add the respond to block and if logic using the `update` method which takes permitted params:

    ```ruby
    # respond_to block
    respond_to do |format|
      # html format block
      format.html {
        # if question updates with permitted params
        if question.update(params.require(:mc_question).permit(:question, :answer, :distractor_1, :distractor_2))
          # success message
          # redirect to index
        else
          # error message
          # render edit
        end
      }
    end
    ```

1. Complete the logic for no errors on question.save by adding a success message to the flash and a redirect to the index page using the named url helper:

    ```ruby
    # success message
    flash[:success] = 'Question updated successfully'
    # redirect to index
    redirect_to mc_questions_url
    ```

1. Complete the logic for errors on question.update by adding an error message to the flash using `flash.now` and re-rendering the edit page:

    ```ruby
    # error message
    flash.now[:error] = 'Error: Question could not be updated'
    # render edit
    render :edit, locals: { question: question }
    ```

Users can now update existing questions.

## 2. Deleting Records

TODO: What are we doing? Although we are "deleting" records, the controller action we create is called "destroy" and we will use the ActiveRecord `McQuestion#destroy` method to remove the object. However, the HTTP request verb is still "delete". Also, although destroy has a controller action and route, there is usually no html page for deleting a record, only a confirmation dialog box.

1. Add the standard resource routes for the `McQuestionsController`'s `destroy` action:

    ```ruby
    # show route
    delete 'mc_questions/:id', to: 'mc_questions#destroy' # destroy route
    ```

1. Add an empty destroy controller action.

Since `destroy` has no html page, the logic for the controller action will only find the object to delete based on the id from the URL, delete it, and redirect to the index page. The psuedocode for this logic looks like:

    ```ruby
    def destroy
      # load existing object again from URL param
      # destroy object
      # respond_to block
        # html format block
          # success message
          # redirect to index
    end
    ```

1. Add code to load the existing object using the id from the path in params hash and delete it like this:

    ```ruby
    # load existing object again from URL param
    question = McQuestion.find(params[:id])
    # destroy object
    question.destroy
    ```

1. Complete the logic for the respond_to block by adding a success message to the flash and a redirect to the index page using the named url helper:

    ```ruby
    # respond_to block
    respond_to do |format|
      # html format block
      format.html {
        # success message
        flash[:success] = 'Question removed successfully'
        # redirect to index
        redirect_to mc_questions_url
      }
    end
    ```

1. Add a delete (🗑 symbol) link after the edit link in the display of each question on the index page and show page:

    ```erb
    <!-- edit link -->
    <!-- delete link -->
    <%= link_to '🗑', mc_question_path(question), method: :delete %>
    ```

You should now be able to delete any question by clicking the `🗑` link for that question on the index page.
