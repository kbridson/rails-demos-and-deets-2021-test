---
title: 'Actions for Deleting Model Records'
---

# {{ page.title }}

In this demonstration, I will show how to add controller actions and views that allow users to delete database records. We will continue to build upon the [QuizMe project](https://github.com/human-se/quiz-me-2020){:target="_blank"} from the previous demos.

Now that the QuizMe app has features to create (`new`/`create`), read (`index`/`show`), and update (`edit`/`update`) multiple-choice questions—the C, the R, and the U in CRUD—the last thing to do is add the functionality for deleting questions. Unlike the `new`/`create` and `edit`/`update` features, deleting records will not involve a form. Instead, we will implement a `destroy` controller action that deletes a specified `McQuestion` record, and to access the action, we will add a 🗑 (trash can) link to each question on the `index` and the `show` pages, as depicted in Figure 1.

{% include image.html file="destroy_mc_question_index_page.png" alt="Screenshot of browser index page for multiple-choice questions, including destroy links" caption="Figure 1. The `index` page for multiple-choice questions, now with 🗑 links for deleting questions." %}

Once the `destroy` action has deleted the record, it will redirect the browser to the `index` page, displaying a flash success notification, as depicted in Figure 2.

{% include image.html file="destroy_mc_question_success.png" alt="Screenshot of browser page index page for multiple-choice questions, displaying a notification message that a record was successfully deleted" caption="Figure 2. The `index` page for multiple-choice questions after a question has been successfully deleted." %}

Implementing this `destroy` functionality will involve two main parts:

1. We will first implement the `destroy` route and `McQuestionsController` action, making the web app receptive to HTTP DELETE requests to delete `McQuestion` records.
1. We will add to the `McQuestion` model class' `index` and `show` pages special hyperlinks that send HTTP DELETE requests, so users can delete records by clicking the links.

## 1. Deleting `McQuestion` Records with a `destroy` Controller Action

As a first step, add to `routes.rb` the standard resource route for the `destroy` action, inserting it after the `update` routes, like this:

```ruby
delete 'mc_questions/:id', to: 'mc_questions#destroy' # destroy
```

Note that this `delete` route uses a URI pattern that contains an `id` (similar to the `show` and `update` routes). That `id` will indicate the question to be deleted from the database.

Next, add to the `McQuestionsController` class a code skeleton with pseudocode comments for the `destroy` controller action, like this:

```ruby
def destroy
  # load existing object again from URL param
  # destroy object
  # respond_to block
    # success message
    # redirect to index
end
```

We'll fill in the code for this method bit by bit. When finished, it will (1) first retrieve the object to be deleted based on the `id` in the request URL, (2) then delete the object, (3) then set a flash notification, and (4) finally respond with an HTTP redirect to the `index` page.

Add code to retrieve the object to be deleted using the `id` from the path in `params` hash, and then delete it using the model's `destroy` method, like this:

```ruby
# load existing object again from URL param
question = McQuestion.find(params[:id])
# destroy object
question.destroy
```

Complete the logic for the `respond_to` block by adding a success message to the `flash` has and an HTTP redirect to the `index` page, like this:

```ruby
# respond_to block
respond_to do |format|
  format.html do
    # success message
    flash[:success] = 'Question removed successfully'
    # redirect to index
    redirect_to mc_questions_url
  end
end
```

The web app should now be receptive to HTTP DELETE requests that delete specified multiple-choice questions from the database; however, we do not yet have a good way to test this functionality. For example, DELETE requests cannot be sent in the same way we send GET requests, by entering a URL into the browser's location bar. In the next part, we will add links to our existing pages to enable sending such HTTP DELETE requests.

**[{% octicon git-commit height:24 class:"right left" aria-label:hi %} Code changeset for this part](https://github.com/human-se/quiz-me-2020/commit/45555d6effd47d94f75d574b4f443b533c61b0d4){:target="_blank"}**

## 2. Linking to the `destroy` action from the `index` and `show` Pages for `McQuestion` Records

Add to the `index` view a 🗑 (trash can) link to the `destroy` action for each question, like this:

```erb
<p>
  <%= question.question %>
  <%= link_to '🔎', mc_question_path(question) %>
  <%= link_to '🖋', edit_mc_question_path(question) %>
  <%= link_to '🗑', mc_question_path(question), method: :delete %>
</p>
```

Note that in this call to the [`link_to` method](https://api.rubyonrails.org/v6.0.2.1/classes/ActionView/Helpers/UrlHelper.html#method-i-link_to){:target="_blank"} we use a `method` option with the value `:delete` to make it so that clicking the link produces an HTTP DELETE request (instead of the usual GET request).

Similar to the `index` view, add to the `show` view a 🗑 link ot the `destroy` action, like this:

```erb
<p>
  <%= question.question %>
  <%= link_to '🖋', edit_mc_question_path(question) %>
  <%= link_to '🗑', mc_question_path(question), method: :delete %>
</p>
```

Verify that the `destroy` hyperlinks work now by running the app and testing out the links on the `index` and `show` pages.

The QuizMe app now offers full CRUD functionality by providing the standard Rails resource routes, actions, and views. In the upcoming demos, we will see how to use RESTful resources when the database design becomes more complex (e.g., by adding model class associations/foreign keys).

**[{% octicon git-commit height:24 class:"right left" aria-label:hi %} Code changeset for this part](https://github.com/human-se/quiz-me-2020/commit/265b720f7e1ec496743660904b576bbe7a586cf2){:target="_blank"}**

{% include pagination.html prev_page='demo-resource-update.md' next_page='demo-quiz-model.md' %}
