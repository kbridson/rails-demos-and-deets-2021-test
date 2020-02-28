---
title: 'Creating a New Model Class to Associate With'
---

# {{ page.title }}

In this demonstration, we will lay the groundwork for the upcoming association demos by creating a new class of model objects, `Quiz`, to which `McQuestion` model objects will belong. The tasks in this demo are for the most part repeats of the ones covered in the previous demos, so we will tend to be brief in our explanations of the tasks. We will continue to build upon the [QuizMe project](https://github.com/human-se/quiz-me-2020){:target="_blank"} from the previous demos.

In particular, we will be updating our model design by adding a new model class, `Quiz`, as depicted in Figure 1.

{% include image.html file="quiz_model_class.svg" alt="A UML class diagram depicting the Quiz and McQuestion model classes" caption="Figure 1. The updated database design, including the newly added `Quiz` model class." %}

To enable users to perform CRUD operations on `Quiz` records, we will add the standard Rails resource pages and actions (`index`, `show`, `new`/`create`, `edit`/`update`, and `destroy`), as depicted in Figures 2–5.

{% include image.html file="quiz_index_page.png" alt="Screenshot of browser page" caption='Figure 2. Example `index` page for `Quiz`. The "`New Quiz`" hyperlink goes to the `new` form for `Quiz`. The "`🔎`" hyperlink goes to the `show` page for the corresponding `Quiz` record. The "`🖋`" hyperlink goes to the `edit` page for the corresponding `Quiz` record. The "`🗑`" hyperlink deletes (via the `destroy` action) the corresponding `Quiz` record. Note that the description of each `Quiz` record is truncated such that only the first 75 characters are displayed.' %}

{% include image.html file="quiz_show_page.png" alt="Screenshot of browser page" caption="Figure 3. Example `show` page for `Quiz`." %}

{% include image.html file="quiz_new_form.png" alt="Screenshot of browser page" caption="Figure 4. Example `new` form page for `Quiz`. Like the previous demo on forms for creating model records, submissions of the form are processed by a `create` controller action." %}

{% include image.html file="quiz_edit_form.png" alt="Screenshot of browser page" caption="Figure 5. Example `edit` form page for `Quiz`. Like the previous demo on forms for updating model records, submissions of the form are processed by a `update` controller action." %}

## 1. Creating the `Quiz` Model Class

The tasks in this part were previously introduced in [this demo]({% include page_url.html page_name='demo-model-classes.md' %}){:target="_blank"}.

Generate the `Quiz` model class along with a corresponding database migration, like this:

```bash
rails g model Quiz title:string description:text
```

Run the newly generated migration to update the database schema by running the following command:

```bash
rails db:migrate
```

Verify that the database schema was updated correctly by using pgAdmin to inspect the `quizzes` database table. The table should have no rows of data, but the table should be present, and the columns should be correct.

**[{% octicon git-commit height:24 class:"right left" aria-label:hi %} Code changeset for this part](https://github.com/human-se/quiz-me-2020/commit/fac270c4e4bf681a26a283bb5eebf94bc84be34c){:target="_blank"}**

## 2. Adding and Testing Valid Fixtures for the `Quiz` Model Class

The tasks in this part were previously introduced in [this demo]({% include page_url.html page_name='demo-test-fixtures.md' %}){:target="_blank"}.

In `test/fixtures/quizzes.yml`, add a valid test fixture for the `Quiz` model, like this:

```yml
one:
  title: Rails Concepts
  description: This quiz covers basic Rails programming concepts.
```

Note that we forgo making a second fixture (`two`) this time, because we do not anticipate needing a second one for any of our tests.

In `test/models/quiz_test.rb`, add a test for all the `Quiz` fixtures to verify that they are all valid, like this:

```ruby
test "fixtures are valid" do
  quizzes.each do |q|
    assert q.valid?, q.errors.full_messages.inspect
  end
end
```

Confirm that the tests work and are passing by running the following command:

```bash
rails test
```

We should see `0 failures` and `0 errors`. If we do see failures or errors, then there is a bug in the code that needs fixing.

**[{% octicon git-commit height:24 class:"right left" aria-label:hi %} Code changeset for this part](https://github.com/human-se/quiz-me-2020/commit/c56f537386fcaf1b12b861c16f5cc93ba9d01d2c){:target="_blank"}**

## 3. Adding and Testing `presence` Validations for the `Quiz` Model Class

The tasks in this part were previously introduced in [this demo]({% include page_url.html page_name='demo-presence-validations.md' %}){:target="_blank"}.

In the `Quiz` model class, add `presence` validations for `title` and `description`, like this:

```ruby
validates :title, presence: true
validates :description, presence: true
```

In `test/models/quiz_test.rb`, add tests to verify that `title` and `description` must be present (not `nil` and not a blank string) in order for a `Quiz` object to be valid, like this:

```ruby
test "title presence not valid" do
  q = quizzes(:one)
  q.title = nil
  assert_not q.valid?
  q.title = ""
  assert_not q.valid?
end

test "description presence not valid" do
  q = quizzes(:one)
  q.description = nil
  assert_not q.valid?
  q.description = ""
  assert_not q.valid?
end
```

Confirm that the tests work and are passing by running the following command:

```bash
rails test
```

We should see `0 failures` and `0 errors`. If we do see failures or errors, then there is a bug in the code that needs fixing.

**[{% octicon git-commit height:24 class:"right left" aria-label:hi %} Code changeset for this part](https://github.com/human-se/quiz-me-2020/commit/5613f335b1ead8246b64bb683a1eb13a9d60de6d){:target="_blank"}**

## 4. Seeding the Database with `Quiz` Records

The tasks in this part were previously introduced in [this demo]({% include page_url.html page_name='demo-db-seeds.md' %}){:target="_blank"}.

Add a couple of `Quiz` seeds at the top of the `seeds.rb` file, like this:

```ruby
quiz1 = Quiz.create!(
    title: 'MVC Concepts',
    description: 'This quiz covers concepts related to the Model-View-Controller web application architecture.'
)

quiz2 = Quiz.create!(
    title: 'Rails Concepts',
    description: 'This quiz covers concepts related to web application development using the Ruby on Rails platform.'
)
```

Reset and seed the database using the following command:

```bash
rails db:migrate:reset db:seed
```

Verify that the data was seeded correctly by using pgAdmin to inspect the `quizzes` database table.

**[{% octicon git-commit height:24 class:"right left" aria-label:hi %} Code changeset for this part](https://github.com/human-se/quiz-me-2020/commit/72ba549cc6a44fc1308788d3ae72554ef4249d45){:target="_blank"}**

## 5. Creating a Controller for `Quiz` Records

The tasks in this part were previously introduced in [this demo]({% include page_url.html page_name='demo-model-index.md' %}){:target="_blank"}.

Create a `QuizzesController` by entering this command:

```sh
rails g controller Quizzes
```

**[{% octicon git-commit height:24 class:"right left" aria-label:hi %} Code changeset for this part](https://github.com/human-se/quiz-me-2020/commit/016acc3460a8b84ec2b424c973a6a05db315f701){:target="_blank"}**

## 6. Adding the `index` Resource Action for `Quiz` Records

The tasks in this part were previously introduced in [this demo]({% include page_url.html page_name='demo-model-index.md' %}){:target="_blank"}.

Create the standard RESTful route for `index` for the `Quiz` model class by adding the following code to the `routes.rb` file:

```ruby
get 'quizzes', to: 'quizzes#index', as: 'quizzes' # index
```

Add the `index` controller action by inserting a new `index` method in the `QuizzesController` class, like this:

```ruby
def index
  # get all quiz objects
  quizzes = Quiz.all
  # display index view
  respond_to do |format|
    format.html { render :index, locals: { quizzes: quizzes } }
  end
end
```

Create a new `index` view in `app/views/quizzes/index.html.erb`, like this:

```erb
<h1>Quizzes</h1>

<% quizzes.each do |quiz| %>
  <div id="<%= dom_id(quiz) %>">
    <br>
    <p>
      <%= quiz.title %>
    </p>
    <p>
      <%= truncate quiz.description, length: 75, separator: ' ' %>
    </p>
  </div>
<% end %>
```

Note that the `truncate` method is a handy way to shorten a long string when we want only a brief summary. In particular, the method will return the first `length` characters of a string followed by an ellipsis ("`...`").

Add a link to the `index` page for `Quiz` on the app's home page by inserting a call to the `link_to` helper above the "`About`" and "`Contact`" links in the `welcome.html.erb` view, like this:

```erb
<p><%= link_to "Quizzes", quizzes_path %></p>
```

Verify that the newly added code works by running the app, opening the app's home page, and using the new hyperlink to navigate to the `index` page for `Quiz` records.

**[{% octicon git-commit height:24 class:"right left" aria-label:hi %} Code changeset for this part](https://github.com/human-se/quiz-me-2020/commit/2f922c52a5ac26847a8529598056975b41feabd3){:target="_blank"}**

## 7. Adding the `show` Resource Action for `Quiz` Records

The tasks in this part were previously introduced in [this demo]({% include page_url.html page_name='demo-model-show.md' %}){:target="_blank"}.

Create the standard RESTful route for `show` for the `Quiz` model class by inserting the following code after the `index` route the `routes.rb` file:

```ruby
get 'quizzes/:id', to: 'quizzes#show', as: 'quiz' # show
```

Add the `show` controller action by inserting a new `show` method in the `QuizzesController` class, like this:

```ruby
def show
  # find a particular object
  quiz = Quiz.find(params[:id])
  # display the object
  respond_to do |format|
    format.html { render :show, locals: { quiz: quiz } }
  end
end
```

Create a new `show` view in `app/views/quizzes/show.html.erb`, like this:

```erb
<h1><%= quiz.title %></h1>

<p>
  <%= quiz.description %>
</p>
```

Add links to the `show` pages for `Quiz` records on the `index` page for `Quiz` records by inserting a call to the `link_to` helper after the quiz title in the `index.html.erb` view, like this:

```erb
<p>
  <%= quiz.title %>
  <%= link_to '🔎', quiz_path(quiz) %>
</p>
```

Verify that the newly added code works by running the app, opening the app's `index` page for `Quiz` records, and using the new hyperlinks to navigate to the `show` pages for `Quiz` records.

**[{% octicon git-commit height:24 class:"right left" aria-label:hi %} Code changeset for this part](https://github.com/human-se/quiz-me-2020/commit/a948581280f587b09b62c935dda98220799fb78b){:target="_blank"}**

## 8. Adding the `new`/`create` Resource Actions for `Quiz` Records

The tasks in this part were previously introduced in [this demo]({% include page_url.html page_name='demo-resource-create.md' %}){:target="_blank"}.

Create the standard RESTful routes for `new`/`create` for the `Quiz` model class by inserting the following code after the `index` route (but before the `show` route) for `Quiz` in the `routes.rb` file:

```ruby
get 'quizzes/new', to: 'quizzes#new', as: 'new_quiz' # new
post 'quizzes', to: 'quizzes#create' # create
```

Add the `new`/`create` controller actions by inserting a new `new` method and a new `create` method in the `QuizzesController` class, like this:

```ruby
def new
  # make empty quiz object
  quiz = Quiz.new
  # display new view
  respond_to do |format|
    format.html { render :new, locals: { quiz: quiz } }
  end
end

def create
  # new object from params
  quiz = Quiz.new(params.require(:quiz).permit(:title, :description))
  # respond_to block
  respond_to do |format|
    format.html do
      if quiz.save
        # success message
        flash[:success] = "Quiz saved successfully"
        # redirect to index
        redirect_to quizzes_url
      else
        # error message
        flash.now[:error] = "Error: Quiz could not be saved"
        # render new
        render :new, locals: { quiz: quiz }
      end
    end
  end
end
```

Create a new `new` view in `app/views/quizzes/new.html.erb`, like this:

```erb
<h1>New Quiz</h1>

<%= form_with model: quiz, url: quizzes_path, method: :post, local: true, scope: :quiz do |form| %>

  <div>
    <%= form.label :title %><br>
    <%= form.text_field :title %>
  </div>

  <div>
    <%= form.label :description %><br>
    <%= form.text_area :description, size: "27x7" %>
  </div>

  <%= form.submit "Add Quiz" %>

<% end %>
```

Add a link to the `new` form page for `Quiz` records on the `index` page for `Quiz` records by inserting a call to the `link_to` helper after the `h1` heading element in the `index.html.erb` view, like this:

```erb
<p>
  <%= link_to 'New Quiz', new_quiz_path %>
</p>
```

Verify that the newly added code works by running the app, opening the app's `index` page for `Quiz` records, using the new hyperlink to navigate to the `new` form pages for `Quiz` records, and using the form to create some new `Quiz` records.

**[{% octicon git-commit height:24 class:"right left" aria-label:hi %} Code changeset for this part](https://github.com/human-se/quiz-me-2020/commit/90f5f1549b8b8322bf829c5339f3839351112027){:target="_blank"}**

## 9. Adding the `edit`/`update` Resource Actions for `Quiz` Records

The tasks in this part were previously introduced in [this demo]({% include page_url.html page_name='demo-resource-update.md' %}){:target="_blank"}.

Create the standard RESTful routes for `edit`/`update` for the `Quiz` model class by inserting the following code after the `show` route for `Quiz` in the `routes.rb` file:

```ruby
get 'quizzes/:id/edit', to: 'quizzes#edit', as: 'edit_quiz' # edit
put 'quizzes/:id', to: 'quizzes#update' # update (put)
patch 'quizzes/:id', to: 'quizzes#update' # update (patch)
```

Add the `edit`/`update` controller actions by inserting a new `edit` method and a new `update` method in the `QuizzesController` class, like this:

```ruby
def edit
  # object to use in form
  quiz = Quiz.find(params[:id])
  respond_to do |format|
    format.html { render :edit, locals: { quiz: quiz } }
  end
end

def update
  # load existing object again from URL param
  quiz = Quiz.find(params[:id])
  # respond_to block
  respond_to do |format|
    format.html do
      if quiz.update(params.require(:quiz).permit(:title, :description))
        # success message
        flash[:success] = 'Quiz updated successfully'
        # redirect to index
        redirect_to quizzes_url
      else
        # error message
        flash.now[:error] = 'Error: Quiz could not be updated'
        # render edit
        render :edit, locals: { quiz: quiz }
      end
    end
  end
end
```

Create a new `edit` view in `app/views/quizzes/edit.html.erb`, like this:

```erb
<h1>Edit Quiz</h1>

<%= form_with model: quiz, url: quiz_path, method: :patch, local: true, scope: :quiz do |form| %>

  <div>
    <%= form.label :title %><br>
    <%= form.text_field :title %>
  </div>

  <div>
    <%= form.label :description %><br>
    <%= form.text_area :description, size: "27x7" %>
  </div>

  <%= form.submit "Update Quiz" %>

<% end %>
```

Add links to the `edit` form pages for `Quiz` records on the `index` page for `Quiz` records by inserting a call to the `link_to` helper after the quiz title in the `index.html.erb` view, like this:

```erb
<p>
  <%= quiz.title %>
  <%= link_to '🔎', quiz_path(quiz) %>
  <%= link_to '🖋', edit_quiz_path(quiz) %>
</p>
```

Verify that the newly added code works by running the app, opening the app's `index` page for `Quiz` records, using the new hyperlink to navigate to the `edit` form pages for `Quiz` records, and using the form to update some existing `Quiz` records.

**[{% octicon git-commit height:24 class:"right left" aria-label:hi %} Code changeset for this part](https://github.com/human-se/quiz-me-2020/commit/eeed1f7b10d5ab1374f8d6e170081ea5a1e588a1){:target="_blank"}**

## 10. Adding the `destroy` Resource Action for `Quiz` Records

The tasks in this part were previously introduced in [this demo]({% include page_url.html page_name='demo-resource-destroy.md' %}){:target="_blank"}.

Create the standard RESTful route for `destroy` for the `Quiz` model class by  inserting the following code after the `update` actions in the `routes.rb` file:

```ruby
delete 'quizzes/:id', to: 'quizzes#destroy' # destroy
```

Add the `destroy` controller action by inserting a new `destroy` method in the `QuizzesController` class, like this:

```ruby
def destroy
  # load existing object again from URL param
  quiz = Quiz.find(params[:id])
  # destroy object
  quiz.destroy
  # respond_to block
  respond_to do |format|
    format.html do
      # success message
      flash[:success] = 'Quiz removed successfully'
      # redirect to index
      redirect_to quizzes_url
    end
  end
end
```

Add links to the `destroy` actions for `Quiz` records on the `index` page for `Quiz` records by inserting a call to the `link_to` helper after the quiz title in the `index.html.erb` view, like this:

```erb
<p>
  <%= quiz.title %>
  <%= link_to '🔎', quiz_path(quiz) %>
  <%= link_to '🖋', edit_quiz_path(quiz) %>
  <%= link_to '🗑', quiz_path(quiz), method: :delete %>
</p>
```

Verify that the newly added code works by running the app, opening the app's `index` page for `Quiz` records, and using the new hyperlink to delete some existing `Quiz` records.

We now have a working `Quiz` model class and CRUD resource pages. In the next demo, we will make the application more interesting by giving each `Quiz` object an associated set of `McQuestion` model objects.

**[{% octicon git-commit height:24 class:"right left" aria-label:hi %} Code changeset for this part](https://github.com/human-se/quiz-me-2020/commit/305fb49adaafea4b83933393b04b3c2d8ca314dc){:target="_blank"}**

{% include pagination.html prev_page='demo-resource-destroy.md' next_page='demo-one-to-many.md' %}
