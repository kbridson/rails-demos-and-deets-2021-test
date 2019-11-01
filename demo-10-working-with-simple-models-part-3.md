---
layout: page
title: 'Demo 10: Forms and Actions for Updating and Deleting Model Records'
permalink: /demo-10-edit-update-destroy-forms/
---

# {{ page.title }}

In this demonstration, I will show how to add controller actions and views that allow users to update and delete database records. We will continue to work on the _QuizMe_ project from the previous demos.

In particular, we will update the `index` page for multiple-choice questions such that each question has three link icons:

- 🔎 links to the `show` page for the question;
- 🖋 links to a form for editing the question; and
- 🗑 deletes the question.

Figure 1 depicts an example of an `index` page with these link icons.

<div class="figure-container mx-auto my-4" style="max-width: 960px;">
<figure class="figure">
<img src="{{ site.baseurl }}/resources/demo10_fig01.png" class="figure-img img-fluid rounded border" alt="Screenshot of browser page with xxx">
<figcaption class="figure-caption">Figure 1. Updated <code>index</code> page for multiple-choice questions. Note the 🔎, 🖋,  and 🗑 link icons.</figcaption>
</figure>
</div>

We will also update the `show` page, adding the 🖋 (edit) and 🗑 (delete) link icons, as depicted in Figure 2.

<div class="figure-container mx-auto my-4" style="max-width: 960px;">
<figure class="figure">
<img src="{{ site.baseurl }}/resources/demo10_fig02.png" class="figure-img img-fluid rounded border" alt="Screenshot of browser page with xxx">
<figcaption class="figure-caption">Figure 2. Updated <code>show</code> page for multiple-choice questions. Note the 🖋 and 🗑 link icons.</figcaption>
</figure>
</div>

Clicking the 🖋 link for a question on either the `index` or the `show` page will take the user to an `edit` page with a form for updating the question, as depicted in Figure 3.

<div class="figure-container mx-auto my-4" style="max-width: 960px;">
<figure class="figure">
<img src="{{ site.baseurl }}/resources/demo10_fig03.png" class="figure-img img-fluid rounded border" alt="Screenshot of browser page with xxx">
<figcaption class="figure-caption">Figure 3. Example <code>edit</code> page for multiple-choice questions. Data submitted via this form will be processed by an <code>update</code> action.</figcaption>
</figure>
</div>

If a user submits the `edit` form, the submitted form data will be processed by an `update` action. If the `update` action successfully saves the data, the browser will be redirected to the `index` page for multiple-choice questions and a flash success notification will be displayed, as depicted in Figure 4.

<div class="figure-container mx-auto my-4" style="max-width: 960px;">
<figure class="figure">
<img src="{{ site.baseurl }}/resources/demo10_fig04.png" class="figure-img img-fluid rounded border" alt="Screenshot of browser page with xxx">
<figcaption class="figure-caption">Figure 4. Example <code>index</code> page resulting from the successful processing of an <code>edit</code>-form submission. Note the success notification near the top of the page.</figcaption>
</figure>
</div>

If the `update` action is unable to save the submitted data, for example, because a model validation fails, then the action will re-render the `edit` page, with the submitted data filled into the form and a flash error notification. (Note that this behavior is essentially the same as for the `new` form we built in the previous demo.) Figure 5 depicts the result of submitting an `edit` form with nothing filled in for the distractors.

<div class="figure-container mx-auto my-4" style="max-width: 960px;">
<figure class="figure">
<img src="{{ site.baseurl }}/resources/demo10_fig05.png" class="figure-img img-fluid rounded border" alt="Screenshot of browser page with xxx">
<figcaption class="figure-caption">Figure 5. Example <code>edit</code> page resulting from the unsuccessful processing of an <code>edit</code>-form submission. Note that the form has been filled in with the rejected form data, and an error notification appears near the top of the page.</figcaption>
</figure>
</div>

Finally, clicking the 🗑 link for a question on either the `index` or the `show` page will cause a `destroy` action to delete the question from the database and to redirect the browser to the `index` page, displaying a flash success notification. Figure 6 depicts the result of deleting a question.

<div class="figure-container mx-auto my-4" style="max-width: 960px;">
<figure class="figure">
<img src="{{ site.baseurl }}/resources/demo10_fig06.png" class="figure-img img-fluid rounded border" alt="Screenshot of browser page with xxx">
<figcaption class="figure-caption">Figure 6. Example <code>index</code> page resulting from the successful deletion of a question. Note that a success notification appears near the top of the page.</figcaption>
</figure>
</div>

To implement these new features, we will first get the `edit` page and `update` action working and then the `destroy` links.

## 1. Updating Records with a Form

The `edit`/`update` functionality will be similar to the `new`/`create` functionality from the previous demo in that users will edit the multiple-choice question attributes in a form. However, unlike the `new` form, the `edit` form will always use an existing object. For that reason, the route for `edit` (and for `update` as well) will contain a URL parameter `:id` which holds the `id` of the record to modify. Both the `edit` and `update` controller actions will need to use the `find` model method to retrieve the correct object based on the `id` in the URL.

### 1.1. Rendering the Form with the `edit` Action

Let's start by setting up the `edit` action along with some other boilerplate code:

1. Add the standard resource routes for the `McQuestionsController` actions `edit` and `update`:

    ```ruby
    # index route
    # new route
    # create route
    get 'mc_questions/:id/edit', to: 'mc_questions#edit', as: 'edit_mc_question' # edit
    patch 'mc_questions/:id', to: 'mc_questions#update'                          # update (as needed)
    put 'mc_questions/:id', to: 'mc_questions#update'                            # update (full replacement)
    # show route
    ```

    Notice that instead of using a POST request for `update`, we have two new HTTP request methods: PATCH and PUT. An `edit` form in Rails may use either of these two, so we list them both in the routes. The main difference between these two request methods is that PATCH is used when certain parts of a record are to be modified, whereas PUT is used when the whole record is to be replaced.

    As always, you must pay attention to the order of the routes. For example, the newly added PATCH/PUT routes with the URI pattern `'mc_questions/:id'` must come after the `new` route (`'mc_questions/new'`); otherwise, requests that are meant to go to `new` will instead be routed to another (incorrect) action.

1. In the `McQuestionsController` class, create an `edit` action that will retrieve (using the `find` method) the `McQuestion` record with the `id` given in the request URL (which is held in `params[:id]`), and  then, will render the `edit.html.erb` view, passing in the `McQuestion` object, like this:

    ```ruby
    def edit
      # object to use in form
      question = McQuestion.find(params[:id])
      respond_to do |format|
        format.html { render :edit, locals: { question: question } }
      end
    end
    ```

1. Add an empty `update` action to be filled in later, like this:

    ```ruby
    def update
      # TODO
    end
    ```

1. Create an `edit.html.erb` file in `app/views/mc_questions`, and give it the following code:

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

    This code is largely the same as in `new.html.erb` from the previous demo. The heading has changed to "Edit". The `form_with` helper's `url` and `method` options have been changed to match the UPDATE route. The submit button text has been changed to "Update".

    At this point, you can try reseting the database, launching the Rails development server, and visiting <http://localhost:3000/mc_questions/1/edit>. You should see the data load and the form for the `McQuestion` object with an `id` of 1 displayed.

1. Add to the `index` view a 🔎 link to the `show` page and a 🖋 link to the `edit` page for each question, like this:

    ```erb
    <p>
      <%= question.question %>
      <%= link_to '🔎', mc_question_path(question) %>
      <%= link_to '🖋', edit_mc_question_path(question) %>
    </p>
    ```

1. Add the `edit`-page link after the question text on the `show` page as well, like this:

    ```ruby
    <p>
      <%= question.question %>
      <%= link_to '🖋', edit_mc_question_path(question) %>
    </p>
    ```

    You should now be able to go to the `edit` page for any question by clicking the `🖋` link for that question on the `index` page or the `show` page.

### 1.2. Processing Form Data with the `update` Action

Now let's fill in the logic to the `update` action. The action must first retrieve the object to be updated from the database, using the `id` in the request URL. Next, the action must attempt to update the object using the `mc_question` data the `params` hash. If saving the object is successful, the action will respond with an HTTP redirect to the `index` page. If saving the object is unsuccessful, the action will render the `edit` form again with a flash error message. Psuedocode for the logic would look like this:

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

Perform the following steps to fill in the actual code:

1. Add code to retrieve the existing `McQuestion` object using `find` method and the `id` passed in via the `params` hash, like this:

    ```ruby
    # load existing object again from URL param
    question = McQuestion.find(params[:id])
    ```

1. Add the `respond_to` block and `if` logic using the `update` method, like this:

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

1. For `if` part where `question.update` is successful, add a success message to the `flash` hash and a redirect to the `index` page, like this:

    ```ruby
    # success message
    flash[:success] = 'Question updated successfully'
    # redirect to index
    redirect_to mc_questions_url
    ```

1. For `else` part where `question.update` fails, add an error message to the `flash` hash using `flash.now`, and re-render the `edit` page, like this:

    ```ruby
    # error message
    flash.now[:error] = 'Error: Question could not be updated'
    # render edit
    render :edit, locals: { question: question }
    ```

Users should now be able to use the app to update existing questions.

## 2. Deleting Records with the `destroy` Action

Now that the QuizMe app has features to create, read (`index`/`show`), and update (CRU_) multiple-choice questions, the last thing to do is add the functionality for deleting questions. Unlike the `new`/`create` and `edit`/`update` features, deleting records will not involve a form. Thus, we will add only one new controller action (`destroy`), and we will add special hyperlinks to the `index` and `show` pages to invoke the `destroy` action.

1. Add a standard resource route to map HTTP DELETE requests to the `McQuestionsController` action `destroy`, like this:

    ```ruby
    # show route
    delete 'mc_questions/:id', to: 'mc_questions#destroy' # destroy route
    ```

1. Add an empty `destroy` controller action. When finished, the action will first retrieve the object to be deleted based on the `id` in the request URL, then delete the object, then set a flash notification, and finally respond with an HTTP redirect to the `index` page. The psuedocode for this logic looks like this:

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

1. Add code to retrieve the object to be deleted using the `id` from the path in `params` hash, and then delete it using the model's `destroy` method, like this:

    ```ruby
    # load existing object again from URL param
    question = McQuestion.find(params[:id])
    # destroy object
    question.destroy
    ```

1. Complete the logic for the `respond_to` block by adding a success message to the `flash` has and an HTTP redirect to the `index` page, like this:

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

1. Lastly, update the `index` page and the `show` page by adding a delete (🗑) link after the `edit` link for each multiple-choice question, like this:

    ```erb
    <!-- edit link -->
    <!-- delete link -->
    <%= link_to '🗑', mc_question_path(question), method: :delete %>
    ```

User of the app should now be able to delete any multiple-choice question by clicking the `🗑` link for that question on the `index` page.
