---
title: 'Displaying a Single Model Record'
---

# {{ page.title }}

In this demonstration, I will show how create a so-called `show` page that displays one specific model record on a webpage. We will continue to build upon the [QuizMe project](https://github.com/human-se/quiz-me-2020){:target="_blank"} from the previous demos.

In particular, we will add a `show` page to the QuizMe app that displays a `McQuestion` record stored in the database, as depicted in Figure 1.

{% include image.html file="mc-question-show-page.png" alt="A web page displaying one multiple-choice question records" caption="Figure 1. The `show` page for a `McQuestion` record." %}

Adding this `show` page will involve several key steps:

1. Adding a `show` route for `McQuestion` records that translates HTTP requests for the `show` page into invocations of the appropriate controller action.
1. Adding a `show` controller action to the `McQuestionsController` class created [last demo]({% include page_url.html page_name='demo-model-index.md' %}){:target="_blank"} that, when invoked, will retrieve the appropriate `McQuestion` record from the database and will render the appropriate view, passing in the retrieved record for the view to display.
1. Adding a `show` view for `McQuestion` records that will render a webpage containing whatever `McQuestion` record is passed to the view.

## 1. Adding a `show` Route for `McQuestion` Records

In `routes.rb`, insert after the `index` route a [standard resource route](https://guides.rubyonrails.org/v6.0.0/routing.html#crud-verbs-and-actions){:target="_blank"} for the `show` action of the `McQuestionsController` class, like this:

```ruby
get 'mc_questions/:id', to: 'mc_questions#show', as: 'mc_question' # show
```

In a [previous demo]({% include page_url.html page_name='demo-simple-forms.md' %}){:target="_blank"}, we passed user data (i.e., _parameters_) from a webpage to the Rails server via POST requests (recall the `params` hash); however, parameters can also be passed via GET requests. One such way is illustrated in the above `show` route. In particular, this `show` route's URI pattern includes an `:id` request parameter that becomes part of the URL (e.g., <http://localhost:3000/mc_questions/125>). When the Rails web server receives a GET request that matches that `show` route, the invoked controller action can retrieve the `:id` value (e.g., `125`) via the `params` hash—specifically, using `params[:id]`.

**[➥ Code changeset for this part](https://github.com/human-se/quiz-me-2020/commit/f1c9ca2ade1bda8f2da3c8130611ad9453202e94){:target="_blank"}**

## 2. Adding a `show` Controller Action for `McQuestion` Records

In this part, we will add a `show` action to the `McQuestionsController` class. This is the "`to:`" action specified in the above `show` route and will be called whenever an incoming HTTP request matches that route.

To begin with, add the `show` action, including a `respond_to` block, like we've seen in [previous demos]({% include page_url.html page_name='demo-static-pages.md' %}){:target="_blank"}:

```ruby
def show
    respond_to do |format|
        format.html { render :show }
    end
end
```

Similar to the `index` action, this one will also need to do some retrieving of model objects; however, in the case of the `show` action, we will just be retrieving one model object based on the `id` in the request URL.

Retrieve the appropriate `McQuestion` record by inserting this line before the `respond_to` block in the `show` action:

```ruby
question = McQuestion.find(params[:id])
```

The [`find` method](https://api.rubyonrails.org/v6.0.0/classes/ActiveRecord/FinderMethods.html#method-i-find){:target="_blank"} is yet another model method provided by Rails. In the above usage, it retrieves the saved `McQuestion` record with the specified `id`.

Once the `McQuestion` object have been retrieved, it will need to be passed to the view for rendering.

Similar to the [last demo]({% include page_url.html page_name='demo-model-index.md' %}){:target="_blank"}, we will add the `locals` hash as an argument to the call to `render` to pass the retrieved `McQuestion` object to the view, like this:

```ruby
format.html { render :show, locals: { question: question } }
```

**Note!** In the `index` action, we had multiple `McQuestion` records, so we used the variable name `questions` (plural); however, in the `show` action, we have only one `McQuestion` record, so we use the variable name `question` (singular).

**[➥ Code changeset for this part](https://github.com/human-se/quiz-me-2020/commit/547fa4dc0991b85710f5d47aea715cb573df6c9c){:target="_blank"}**

## 3. Adding a `show` View for `McQuestion` Records

The `show` action should display all the _important_ attributes of the `mc_question` object (i.e., not the timestamps and not the `id`, because that is shown in the URL). Similar to the `index` view, we will display the question text followed by a radio button with the answer choices, as depicted in Figure 1.

To start with, create a file `app/views/mc_questions/show.html.erb` for the view.

Display the question text by inserting a `<p>` block for the question text at the top of view, like this:

```erb
<p><%= question.question %></p>
```

Display answer choices as a radio button (using similar code to that which was used in the `index` view) by inserting this code after the question text:

```erb
<% choices = [question.answer, question.distractor_1, question.distractor_2] %>
<% choices.each do |c| %>
    <div>
        <%= radio_button_tag "guess", c, checked = c == question.answer, disabled: true %>
        <%= label_tag "guess_#{c}", c %>
    </div>
<% end %>
```

The QuizMe app now provides pages for displaying individual multiple-choice questions (`show` pages). For example, opening the URL <http://localhost:3000/mc_questions/1> should display a page like the on depicted in Figure 1. Similarly, the URLs <http://localhost:3000/mc_questions/2> and <http://localhost:3000/mc_questions/3> should display `show` pages for the other two questions in the database. Clearly, it isn't very convenient entering URLs manually to show these records, and in future demos, we will add hyperlinks to make navigating to these pages more convenient.

The QuizMe app now has `index` and `show` pages that cover the R ("Read") functionality in [CRUD](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete){:target="_blank"}. In upcoming demos, we will add C ("Create"), U ("Update"), and D ("Delete") functionality to complete the app's CRUD capabilities.

**[➥ Code changeset for this part](https://github.com/human-se/quiz-me-2020/commit/785e79a43a817269a4e0887184a6d1c1bd509674){:target="_blank"}**

{% include pagination.html prev_page='demo-model-index.md' %}
