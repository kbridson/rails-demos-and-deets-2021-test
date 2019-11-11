---
layout: page
title: 'Demo 10½: Creating a New Model Class to Associate With'
permalink: /demo-10b-one-to-many-associations-part-0/
---

# {{ page.title }}

In this demonstration, I will lay the groundwork for the upcoming association demos by creating a new model class to association with. The tasks in this demo are similar to the ones covered in the previous demos, and we will continue to build upon on the _QuizMe_ project from the previous demos.

In particular, we will be updating our model design by adding a new model class, `Quiz`, as depicted in Figure 1.

<div class="figure-container mx-auto my-4" style="max-width: 960px;">
<figure class="figure">
<img src="{{ site.baseurl }}/resources/demo10b_fig01.svg" class="figure-img img-fluid rounded border" alt="Class diagram">
<figcaption class="figure-caption">Figure 1. Model class design diagram showing the new model class <code>Quiz</code>.</figcaption>
</figure>
</div>

Furthermore, we will be adding the standard CRUD resource pages for `Quiz`, depicted in Figures 2–5.

<div class="figure-container mx-auto my-4" style="max-width: 960px;">
<figure class="figure">
<img src="{{ site.baseurl }}/resources/demo10b_fig02.png" class="figure-img img-fluid rounded border" alt="Screenshot of browser page">
<figcaption class="figure-caption">Figure 2. Example <code>index</code> page for <code>Quiz</code>. The "New Quiz" hyperlink goes to the <code>new</code> form for <code>Quiz</code>. The "🔎" hyperlink goes to the <code>show</code> page for the corresponding <code>Quiz</code> record. The "🖋" hyperlink goes to the <code>edit</code> page for the corresponding <code>Quiz</code> record. The "🗑" hyperlink deletes (via the <code>destroy</code> action) the corresponding <code>Quiz</code> record. Note that the description of each <code>Quiz</code> record is truncated such that only the first 75 characters are displayed.</figcaption>
</figure>
</div>

<div class="figure-container mx-auto my-4" style="max-width: 960px;">
<figure class="figure">
<img src="{{ site.baseurl }}/resources/demo10b_fig03.png" class="figure-img img-fluid rounded border" alt="Screenshot of browser page">
<figcaption class="figure-caption">Figure 3. Example <code>show</code> page for <code>Quiz</code>.</figcaption>
</figure>
</div>

<div class="figure-container mx-auto my-4" style="max-width: 960px;">
<figure class="figure">
<img src="{{ site.baseurl }}/resources/demo10b_fig04.png" class="figure-img img-fluid rounded border" alt="Screenshot of browser page">
<figcaption class="figure-caption">Figure 4. Example <code>new</code> form page for <code>Quiz</code>. Like the previous demo on forms for creating model records, submissions of the form are processed by a <code>create</code> controller action.</figcaption>
</figure>
</div>

<div class="figure-container mx-auto my-4" style="max-width: 960px;">
<figure class="figure">
<img src="{{ site.baseurl }}/resources/demo10b_fig05.png" class="figure-img img-fluid rounded border" alt="Screenshot of browser page">
<figcaption class="figure-caption">Figure 5. Example <code>edit</code> form page for <code>Quiz</code>. Like the previous demo on forms for updating model records, submissions of the form are processed by a <code>update</code> controller action.</figcaption>
</figure>
</div>

We divide the implementation of these features into two tasks:

1. Creating the `Quiz` model class, including attribute validations.
1. Creating `Quiz` test fixtures and model tests.
1. Creating the CRUD resource pages and actions for `Quiz`.

## 1. Creating the `Quiz` Model Class

For this part, we will perform the following steps to create the new model class, `Quiz`, along with corresponding model validations and tests.

1. Generate the `Quiz` model class along with a corresponding database migration, like this:

    ```bash
    rails g model Quiz title description:text
    ```

    In the above command, we did not need to specify the datatype for `title` above, because `string` is the default datatype for model attributes (and that's what we wanted).

1. Run the newly generated migration to update the database schema by running the following command:

    ```bash
    rails db:migrate
    ```

1. In the `Quiz` model class, add `presence` validations for `title` and `description`, like this:

    ```ruby
    validates :title, :description, presence: true
    ```

## 2. Creating `Quiz` Test Fixtures and Model Tests

1. In `test/fixtures/quizzes.yml`, add a valid test fixture for the `Quiz` model, like this:

    ```yml
    one:
      title: Rails Concepts
      description: This quiz covers basic Rails programming concepts.
    ```

1. In `test/models/quiz_test.rb`, add a test for all fixtures to verify that they are valid, like this:

    ```ruby
    test "fixtures are valid" do
      quizzes.each do |q|
        assert q.valid?, q.errors.full_messages.inspect
      end
    end
    ```

1. Also, add tests to verify that `title` and `description` must be present (not `nil`, not an empty string, and not a string containing only whitespace characters) in order for a `Quiz` object to be valid, like this:

    ```ruby
    test "title presence not valid" do
      q = quizzes(:one)
      q.title = nil
      assert_not q.valid?
      q.title = ""
      assert_not q.valid?
      q.title = "\t"
      assert_not q.valid?
    end

    test "description presence not valid" do
      q = quizzes(:one)
      q.description = nil
      assert_not q.valid?
      q.description = ""
      assert_not q.valid?
      q.description = "\t"
      assert_not q.valid?
    end
    ```

1. Confirm that the tests work and are passing by running the following command:

    ```bash
    rails test
    ```

    You should see `0 failures` and `0 errors`. If you do see failures or errors, then there is a bug in the code that needs fixing.

## 3. Creating `Quiz` Seed Data

For this task, we will seed the database with example data using our newly created model class, as per the steps below.

1. Add a couple of `Quiz` seeds at the top of the `seeds.rb` file, like this:

    ```ruby
    quiz1 = Quiz.create!(title: 'MVC Concepts', description: 'This quiz covers concepts related to the Model-View-Controller web application architecture.')
    quiz2 = Quiz.create!(title: 'Rails Concepts', description: 'This quiz covers concepts related to web application development using the Ruby on Rails platform.')
    ```

1. Seed the database using the following command:

    ```bash
    rails db:seed:replant
    ```

    Alternatively, this command would also work:

    ```bash
    rails db:migrate:reset db:seed
    ```

To confirm that the data was seeded correctly, use pgAdmin to inspect the database, or use the Rails console, for example, to run `Quiz.all` and inspect the output.

## 4. Creating Basic CRUD Pages for `Quiz`

Now that we have seeded the database with `Quiz` records, we will now add the basic CRUD pages to enable users to view and manipulate `Quiz` records, as per the following steps.

Although the text below won't mention it, it is highly recommended that you test your code frequently as you're creating it. In particular, after you implement each page, running the web server to try out the page is a very good idea. That way, your code will "fail fast", helping you to catch bugs quickly and making it easier to correct them.

1. Create a `QuizzesController` by entering this command:

    ```sh
    rails g controller Quizzes
    ```

1. Create the standard RESTful routes (`index`, `show`, `new`/`create`, `edit`/`update`, and `destroy`) for the `Quiz` model class by adding the following code to the `routes.rb` file:

    ```ruby
    # Quiz resources
    get 'quizzes', to: 'quizzes#index', as: 'quizzes'               # index
    get 'quizzes/new', to: 'quizzes#new', as: 'new_quiz'            # new
    post 'quizzes', to: 'quizzes#create'                            # create
    get 'quizzes/:id/edit', to: 'quizzes#edit', as: 'edit_quiz'     # edit
    match 'quizzes/:id', to: 'quizzes#update', via: [:put, :patch]  # update
    get 'quizzes/:id', to: 'quizzes#show', as: 'quiz'               # show
    delete 'quizzes/:id', to: 'quizzes#destroy'                     # destroy
    ```

    Using standard RESTful routes is a very common practice, so Rails provides a shortcut to these resource routes for any model object. If you are comfortable with the form of these routes, especially the URL parameters and named path helpers, you can replace the above code with:

    ```ruby
    resources :quizzes
    ```

1. Create the `index` controller action and view to display all quizzes.

    The `index` controller action should look like this:

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

    The corresponding `index.html.erb` view should look like this:

    ```erb
    <h1>Quizzes</h1>

    <%= link_to 'New Quiz', new_quiz_path %>

    <% quizzes.each do |quiz| %>
      <div id="<%= dom_id(quiz) %>">
        <br>
        <p>
          <%= quiz.title %>
          <%= link_to '🔎', quiz_path(quiz) %>
          <%= link_to '🖋', edit_quiz_path(quiz) %>
          <%= link_to '🗑', quiz_path(quiz), method: :delete %>
        </p>
        <p>
          <%= truncate quiz.description, length: 75, separator: ' ' %>
        </p>
      </div>
    <% end %>
    ```

    Note that the `truncate` method is a handy way to shorten a long string when you want only a brief summary. In particular, the method will return the first `length` characters of a string followed by an ellipsis ("`...`").

1. Add a link to the `index` page for `Quiz` above the About and Contact links on the Home page, like this:

    ```erb
    <p><%= link_to "Quizzes", quizzes_path %></p>
    ```

1. Create the `show` controller action and view to display a single quiz.

    The `show` controller action should look like this:

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

    The `show.html.erb` view should look like this:

    ```erb
    <h2><%= quiz.title %></h3>

    <p><%= quiz.description %></p>
    ```

1. Create the `new`/`create` pages and actions for `Quiz`.

    The `new`/`create` controller actions should look like this:

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
        # html format block
        format.html {
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
        }
      end
    end
    ```

    The `new.html.erb` view should look like this:

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

1. Create the `edit`/`update` pages and actions for `Quiz`.

    The `edit`/`update` controller actions should look like this:

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
        # html format block
        format.html {
          # if quiz updates with permitted params
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
        }
      end
    end
    ```

    The `edit.html.erb` view should look like this:

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

1. Create the `destroy` controller action for `Quiz`, like this:

    ```ruby
    def destroy
      # load existing object again from URL param
      quiz = Quiz.find(params[:id])
      # destroy object
      quiz.destroy
      # respond_to block
      respond_to do |format|
        # html format block
        format.html {
          # success message
          flash[:success] = 'Quiz removed successfully'
          # redirect to index
          redirect_to quizzes_url
        }
      end
    end
    ```

We now have a working `Quiz` model class and CRUD resource pages. In the next demo, we will make the application more interesting by giving each `Quiz` object an associated set of `McQuestion` model objects.
