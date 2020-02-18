---
title: 'Actions for Deleting Model Records'
---

{% include under-construction.html %}

# {{ page.title }}

In this demonstration, I will show how to add controller actions and views that allow users to delete database records. We will continue to build upon the [QuizMe project](https://github.com/human-se/quiz-me-2020){:target="_blank"} from the previous demos.

Finally, clicking the 🗑 link for a question on either the `index` or the `show` page will cause a `destroy` action to delete the question from the database and to redirect the browser to the `index` page, displaying a flash success notification. Figure 6 depicts the result of deleting a question.

## 1. Deleting Records with the `destroy` Action

Now that the QuizMe app has features to create, read (`index`/`show`), and update (CRU_) multiple-choice questions, the last thing to do is add the functionality for deleting questions. Unlike the `new`/`create` and `edit`/`update` features, deleting records will not involve a form. Thus, we will add only one new controller action (`destroy`), and we will add special hyperlinks to the `index` and `show` pages to invoke the `destroy` action.

Add a standard resource route to map HTTP DELETE requests to the `McQuestionsController` action `destroy`, like this:

```ruby
# show route
delete 'mc_questions/:id', to: 'mc_questions#destroy' # destroy route
```

Add an empty `destroy` controller action. When finished, the action will first retrieve the object to be deleted based on the `id` in the request URL, then delete the object, then set a flash notification, and finally respond with an HTTP redirect to the `index` page. The psuedocode for this logic looks like this:

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
  # html format block
  format.html {
    # success message
    flash[:success] = 'Question removed successfully'
    # redirect to index
    redirect_to mc_questions_url
  }
end
```

Lastly, update the `index` page and the `show` page by adding a delete (🗑) link after the `edit` link for each multiple-choice question, like this:

```erb
<!-- edit link -->
<!-- delete link -->
<%= link_to '🗑', mc_question_path(question), method: :delete %>
```

User of the app should now be able to delete any multiple-choice question by clicking the `🗑` link for that question on the `index` page.

**[➥ Code changeset for this part](xxx){:target="_blank"}**

{% include pagination.html prev_page='demo-resource-update.md' %}
