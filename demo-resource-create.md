---
title: 'Forms for Creating New Model Records'
---

# {{ page.title }}

In this demonstration, I will show how to add controller actions and views that allow users to create new model records and save them to the database. We will continue to build upon the [QuizMe project](https://github.com/human-se/quiz-me-2020){:target="_blank"} from the previous demos.

Previously, we have created new `McQuestion` records in the database only by using the `seeds.rb` file; however, we also want users to be able to use the app to create, update, and delete records. In this demo, we will build a form for creating new multiple-choice questions, as shown in Figure 1.

{% include image.html file="new_mc_question_page.png" alt="Screenshot of browser page with form for creating new multiple-choice questions" caption="Figure 1. A `new` form page for creating new multiple-choice questions." %}

[Recall]({% include page_url.html page_name='demo-simple-forms.md' %}){:target="_blank"} that a form page requires two controller actions: one to display the form and one to process the form submission. Following the [RESTful](https://en.wikipedia.org/wiki/Representational_state_transfer){:target="_blank"} architectural style (considered a best practice), the two standard resource actions for creating new model records are `new` and `create`. The `new` action renders the page containing the form, and the `create` action processes the form submission, attempts to save the new object in the database, and performs error handling if the object cannot be saved.

For the `new` form in Figure 1, a successful submission will result in saving the specified question to the database, redirecting the browser to the `index` page for multiple-choice questions, and displaying a success notification at the top of the `index` page. For example, Figure 2 illustrates the results of submitting a new "Who shot Mr Burns?" question. Note the "Question saved successfully" notification at the top of the page and the new multiple-choice question that has been added to the three seed-data questions. Additionally, note that the `index` page now has a "`New Question`" link to the `new` form page.

{% include image.html file="create_mc_question_result.png" alt="Screenshot of browser page with index page of multiple-choice questions and success notification message at the top" caption='Figure 2. The result of successfully submitting the form from Figure 1. In particular, (1) the new question will be saved to the database (see the "Who shot Mr Burns?" question); (2) the browser will be redirected to the `index` page for multiple-choice questions; and (3) a success notification will be displayed at the top of the `index` page (see the "Question saved successfully" message).' %}

There will be three main parts to this demo:

1. We will first implement the `new` controller action and `new.html.erb` view for displaying the form page from Figure 1 (however, the form will not yet be functional).
1. Next, we will implement the `create` controller action for processing submissions of the form, and thus, make the form functional.
1. Finally, we will add to the `index` page the hyperlink to the `new` form page.

## 1. Rendering the `new` Form Page for `McQuestion` Records

To display the `new` form from Figure 1, we must (1) add a route to handle HTTP requests for the `new` form page, (2) add a `new` controller action to render the appropriate view for the form page, and (3) add a `new.html.erb` to define how the form page should appear.

As a first step, add to `routes.rb` the standard resource route for the `new` action, inserting it in between the `index` and `show` routes, like this:

```ruby
get 'mc_questions/new', to: 'mc_questions#new', as: 'new_mc_question' # new
```

**Caution!** You must pay close attention to the order of the routes. If the `new` route were to be inserted _after_ the `show` route, requests to <http://localhost:3000/mc_questions/new> would incorrectly match with the `show` route, because the `show` route would think that the "`new`" part of the path is an `id`, which is wrong, of course, and would lead to lots of potentially confusing downstream errors.

Next, add to the `McQuestionsController` a basic skeleton for the `new` action that will render the `new.html.erb` view, like this:

```ruby
def new
  respond_to do |format|
    format.html { render :new }
  end
end
```

Because this action will be rendering the form for creating a model record, we must additionally create an instance of the model class (using the `McQuestion.new` constructor) and pass the model object to the view, like this:

```ruby
def new
  question = McQuestion.new
  respond_to do |format|
    format.html { render :new, locals: { question: question } }
  end
end
```

Note that the `McQuestion.new` constructor creates a `McQuestion` object that is essentially empty (all attribute values set to `nil`). Furthermore, the object it creates is not yet saved to the database (and thus, has an `id` value of `nil` as well).

Lastly, we will build up the view for the `new` form page in stages.

First, create a `new.html.erb` file in the `app/views/mc_questions` directory, and give it a heading, like this:

```erb
<h1>New Question</h1>
```

Next, insert below the heading an invocation of the `form_with` Rails form helper for generating forms, like this:

```erb
<%= form_with url: mc_questions_path, method: :post, local: true do %>
  # TODO: Add fields
<% end %>
```

The above options for the `form_with` helper should be familiar to you from the feedback form we [added previously]({% include page_url.html page_name='demo-simple-forms.md' %}){:target="_blank"}; however, unlike the feedback form, this form will use a model object. Rails provides some special options for [forms that handle model objects](https://guides.rubyonrails.org/v6.0.2.1/form_helpers.html#dealing-with-model-objects){:target="_blank"}. In particular, we will also need to add a `model` option that specifies the object and a `scope` option that groups all the model form data under a single key in the `params` hash.

Insert the `model` and `scope` options into the `form_with` invocation, like this:

```erb
<%= form_with model: question, url: mc_questions_path, method: :post, local: true, scope: :mc_question do %>
  # TODO: Add fields
<% end %>
```

Note that the `model` option is set to the `question` variable we defined above in the `new` controller action and that the `scope` option is set to a symbol that is the [snake_case](https://en.wikipedia.org/wiki/Snake_case){:target="_blank"} version of the `McQuestion` class name.

Another change from the feedback form is that we will use the form field helpers differently. In particular, we will [bind the form field helpers to the model object](https://guides.rubyonrails.org/v6.0.2.1/form_helpers.html#binding-a-form-to-an-object){:target="_blank"}. To use the helpers in this way, we need to add a local variable to the form block called `f` (short for "form"), like this:

```erb
<%= form_with model: question, url: mc_questions_path, method: :post, local: true, scope: :mc_question do |f| %>
  # TODO: Add fields
<% end %>
```

Now that we have the `form_with` invocation completed, we can add the code for rendering the fields.

Insert into the body of the `form_with` block a text field for each of the `McQuestion` attributes, like this:

```erb
<div>
  <%= f.label :question %><br>
  <%= f.text_field :question %>
</div>

<div>
  <%= f.label :answer %><br>
  <%= f.text_field :answer %>
</div>

<div>
  <%= f.label :distractor_1 %><br>
  <%= f.text_field :distractor_1 %>
</div>

<div>
  <%= f.label :distractor_2 %><br>
  <%= f.text_field :distractor_2 %>
</div>
```

Note how the form labels and fields are now being created by calls to methods of the form object `f`, instead of using, for example, the `label_tag` and `text_field_tag` helpers we had [used previously]({% include page_url.html page_name='demo-simple-forms.md' %}){:target="_blank"}.

Finally, add a submit button to the:

```erb
<%= f.submit "Add Question" %>
```

Verify that the form is displaying correctly by running the app and opening the URL <http://localhost:3000/mc_questions/new> in the browser. The form will not yet be capable of handling submissions. We will tackle that functionality in the next part.

**[➥ Code changeset for this part](https://github.com/human-se/quiz-me-2020/commit/b9ad0320445eb91fbe0b3b53f9bfc776bffc1b22){:target="_blank"}**

## 2. Adding the `create` Action for `McQuestion` Records

Now that we can render the `new` form, we will implement the logic to process submissions of the form. This part will involve two main steps: (1) add a route to handle the HTTP POST requests that result from submissions of the form and (2) implement the `create` controller action that is responsible for processing the form data.

Add to `routes.rb` the standard resource route for the `create` action, inserting it in after the `new` route, like this:

```ruby
post 'mc_questions', to: 'mc_questions#create' # create
```

Note where the `post 'mc_questions'` part of this route comes from with respect to the `form_with` call above:

- The `form_with` option `method: :post` specifies that submitting the form will produce an HTTP POST request; thus, we use a `post` route here.
- The `form_with` option `url: mc_questions_path` specifies the resource path to be used in the HTTP request. In this case, the route helper `mc_questions_path` was defined in our `index` route. The `as: 'mc_questions'` part of the `index` route caused the `mc_questions_path` route helper to be generated. The URI pattern in the `index` route was `'mc_questions'`, so that is what the `mc_questions_path` route helper returns. Because the `form_with` option `url: mc_questions_path` uses this route helper, the `post` route for `create` route will need to use the corresponding URI pattern (`'mc_questions'`).

Also, note that no `as` option is needed for this `post` route, since the `index` route uses the same URI pattern and has already specified an `as` option.

Now that we have declared the `create` route, we can define the controller action `create`. This action will need (1) to retrieve the form data for a question from the `params` hash, (2) to create a new `McQuestion` object based on the form data, and (3) to save the `McQuestion` object to the database. The action will send an HTTP redirect response if it saves the object successfully, but if saving is unsuccessful, the action will render the form again with an error message. For more on the rationale for sending an HTTP redirect after a successful save, see [this deets page]({% include page_url.html page_name='deets-sessions.md' %}){:target="_blank"}.

In the body of the `McQuestionsController` class, insert a skeleton for the `create` action with psuedocode comments for the operations it will need to perform, like this:

```ruby
def create
  # new object from params
  # respond_to block
    # if question saves
      # success message
      # redirect to index
    # else
      # error message
      # render new
end
```

We will now fill in the body of the `create` action.

Create a new `McQuestion` object based the `params` hash by inserting a call to the `McQuestion.new` constructor, like this:

```ruby
# new object from params
question = McQuestion.new(params.require(:mc_question).permit(:question, :answer, :distractor_1, :distractor_2))
```

Data from the `params` hash isn't necessarily safe, so we have to use some special `params` methods to protect ourselves. Any data received from a POST request could have been tampered with or fabricated, and new keys could have been added that were not on the original form, all in an attempt to exploit latent bugs in the app. Since we know that the form should contain only `McQuestion` attribute data (i.e., `question`, `answer`, etc.) and that those data are scoped under the top-level `:mc_question` key (recall the `form_with` option `scope`), we use the [`require` method](https://api.rubyonrails.org/v6.0.2.1/classes/ActionController/Parameters.html#method-i-require){:target="_blank"} to require that the `:mc_question` key must exist in the `params` hash; otherwise, an exception will be thrown. We further use the [`permit` method](https://api.rubyonrails.org/v6.0.2.1/classes/ActionController/Parameters.html#method-i-require){:target="_blank"} to ensure that only the specified attributes are allowed and any others are filtered out. (Despite these precautions, we will still have to be careful, because malicious data may also have been inserted into the permitted attributes.)

Next, fill in a basic skeleton for the call to `respond_to`, like this:

```ruby
# respond_to block
respond_to do |format|
  format.html do
    # if question saves
      # success message
      # redirect to index
    # else
      # error message
      # render new
  end
end
```

Attempt to save the `McQuestion` object referenced by `question` by inserting into the body of the `format.html` block a call to the model [`save` method](https://api.rubyonrails.org/v6.0.2.1/classes/ActiveRecord/Persistence.html#method-i-save){:target="_blank"} embedded in an `if`/`else` statement, like this:

```ruby
if question.save
  # success message
  # redirect to index
else
  # error message
  # render new
end
```

The reason that we embed the call to `save` in an `if`/`else` is because saving may fail, for example, if a model validation fails. If saving is successful, the `save` method returns `true`, causing execution to enter the body of the `if` part; however, if saving is unsuccessful, the `save` method returns `false`, causing execution to enter the `else` part.

To handle a successful save, add a success message to the `flash` hash and preform an HTTP redirect to the `index` page by inserting the code into the body of the `if` part, like this:

```ruby
# success message
flash[:success] = "Question saved successfully"
# redirect to index
redirect_to mc_questions_url
```

Note that we use the [`redirect_to` method](https://api.rubyonrails.org/v6.0.2.1/classes/ActionController/Redirecting.html#method-i-redirect_to){:target="_blank"} to make the controller to reply to the browser with an HTTP redirect response. The call to `redirect_to` generally takes a URL as its argument, and in these demos, it will generally be a URL returned from a `url` route helper, like `mc_questions_url` above. Note that the `url` route helper `mc_questions_url` returns a full URL (<http://localhost:3000/mc_questions>) and is different from the `path` route helper `mc_questions_path`, which returns only a relative path (`/mc_questions`). In our Rails app code, it is most common to use the `path` route helper; however, occasionally, like in the case of HTTP redirects, the `url` route helper is expected.

To handle an unsuccessful save, add an error message to the `flash` hash using `flash.now`, and render the `new` form (so the user can correct their mistake and try again) by inserting code into the `else` part, like this:

```ruby
# error message
flash.now[:error] = "Error: Question could not be saved"
# render new
render :new, locals: { question: question }
```

In short, the reason that we use `flash.now` above is because the controller action is going to render a view in response to the current HTTP request. The usual flash behavior would be for the error message to become available for the next HTTP request; however, in this case, we need it to appear in the response to the current HTTP request. For more on this usage of the `flash` hash, see [this deets page]({% include page_url.html page_name='deets-sessions.md' %}){:target="_blank"}.

Verify that the form works now by running the app and testing out the `new` form page (<http://localhost:3000/mc_questions/new>).

**[➥ Code changeset for this part](https://github.com/human-se/quiz-me-2020/commit/60f657bf7d8e0ae1aa719155133ce044baec298f){:target="_blank"}**

## 3. Linking to the `new` Form from the `index` Page for `McQuestion` Records

As a final step for this demo, we will add a link to the `new` question page on the `index` page, so users will have a convenient way of getting to the form.

Insert a hyperlink to the `new` form page by inserting a `link_to` call under the heading in `index.html.erb`, like this:

```erb
<%= link_to 'New Question', new_mc_question_path %>
```

Verify that the hyperlink works now by running the app and testing out link on the `index` page (<http://localhost:3000/mc_questions).

The app now provides functionality for creating new multiple-choice questions! In upcoming demos, we will add functionality for updating and deleting existing questions as well.

**[➥ Code changeset for this part](https://github.com/human-se/quiz-me-2020/commit/2de3448c5951e7c2848c7d29a27a6bb0221280a7){:target="_blank"}**

{% include pagination.html prev_page='demo-flash.md' next_page='demo-resource-update.md' %}
