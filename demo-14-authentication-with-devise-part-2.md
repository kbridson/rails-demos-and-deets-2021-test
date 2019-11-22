---
layout: page
title: 'Demo 14: Authentication with Devise (Part 2)'
permalink: /demo-14-authentication-with-devise-part-2/
---

# {{ page.title }}

In this demonstration, I will build upon the user-login functionality from the last demo by making it so that users have ownership of the quizzes they create (as well as the associated questions). Although one user may view the quizzes owned by another user, only the owner of a quiz will be allowed to edit or delete that quiz (or its associated questions).

To accomplish to implement such ownership, we will perform three high-level tasks:

1. Create an ownership association between `User` and `Quiz`, as depicted in Figure 1.
1. Update the existing pages and actions to use this new association.
1. Restrict permissions to the `new`/`create`/`edit`/`update`/`delete` controller actions for quizzes and for questions such that only the user who owns a quiz/question is permitted to execute those actions on the quiz/question.

<div class="figure-container mx-auto my-4" style="max-width: 960px;">
<figure class="figure">
<img src="{{ site.baseurl }}/resources/demo14_fig01.svg" class="figure-img img-fluid rounded border" alt="Class diagram">
<figcaption class="figure-caption">Figure 1. Model class design diagram showing the new ownership association between <code>User</code> and <code>Quiz</code>.</figcaption>
</figure>
</div>

## 1. Creating an Ownership Association between `User` and `Quiz`

1. Create a new database migration to add the `User` FK column to `Quiz`. This involves several sub-steps.

    Generate a new (empty) database migration by running the following command:

    ```bash
    rails g migration AddUserFkColToQuizzes
    ```

    Set up the migration to add a `user_id` FK column to the `quizzes` table by inserting the following line in the `change` method:

    ```ruby
    add_reference :quizzes, :user, foreign_key: true
    ```

1. Update the database schema by running the migration with the following now-familiar command:

    ```bash
    rails db:migrate
    ```

1. Set up the one-to-many association by adding `has_many` and `belongs_to` declarations to `User` and `Quiz`, respectively.

    The `User` declaration should look like this:

    ```ruby
    has_many :quizzes,
      class_name: 'Quiz',
      foreign_key: 'user_id',
      inverse_of: :creator
    ```

    The `Quiz` declaration should look like this:

    ```ruby
    belongs_to :creator,
      class_name: 'User',
      foreign_key: 'user_id',
      inverse_of: :quizzes
    ```

    In the above declarations, note that a `Quiz` object will refer to its owner as `creator`, which is different from the Rails default name (`user`). For example, to retrieve the `User` that owns a `Quiz` referenced by a variable `quiz`, the method invocation would be `quiz.creator`. Also note that in Figure 1, the association end is labeled `creator` to capture this custom name.

1. Add some new `User` seed data, setting each user's password to "`password`" (which would be too insecure to deploy, but is easy to remember for purposes of testing/development), like this:

    ```ruby
    u1 = User.create!(email: 'alice@gmail.com', password: 'password')
    u2 = User.create!(email: 'bob@gmail.com', password: 'password')
    ```

    Note that although the Devise `User` constructor has a `password` parameter that takes a clear-text password string, the password will actually be encrypted and saved in an `encrypted_password` attribute. It would be insecure for `User` objects to store clear-text passwords as attributes.

1. Update each `Quiz` in the seed data to be owned by a particular `User`, like this:

    ```ruby
    q1 = Quiz.create!(creator: u1, title: 'MVC Concepts', description: 'This quiz contains questions related to the Model-View-Controller web application architecture.')
    q2 = Quiz.create!(creator: u2, title: 'Rails Concepts', description: 'This quiz contains questions related to web application development using the Ruby on Rails platform.')
    ```

1. Remove all existing data from the database and re-seed it by entering this command:

    ```bash
    rails db:seed:replant
    ```

To confirm that the data was seeded correctly, use pgAdmin to inspect the database, or use the Rails console, for example, to run `Quiz.all` and inspect the output.

## 2. Updating Existing Pages and Actions to Use the Association

### 2.1. Updating the `index` and `show` Pages for `Quiz`

1. Display the email address of each quiz's creator on the `index` and `show` pages for `Quiz`, like this:

    ```erb
    <p>
      Created by: <%= quiz.creator.email %>
    </p>
    ```

1. Fix the [N + 1 Queries Problem](https://edgeguides.rubyonrails.org/active_record_querying.html#eager-loading-associations) (discussed in [this previous demo]({{ site.baseurl }}/demo-12-one-to-many-associations-part-2/)) that we now have by modifying the query in the `index` controller action, like this:

    ```ruby
    quizzes = Quiz.includes(:creator).all
    ```

### 2.2. Adding a new `index` Page That Shows Only the Current User's Quizzes

The current `index` page for `Quiz` records displays all quizzes for all users; however, we would also like to have an `index`-style page that displays only the `Quiz` records owned by the currently signed-in user. To add this new `index` page, perform the following steps.

1. Generate a new `AccountQuizzesController` class by entering this now-familiar command:

    ```bash
    rails g controller AccountQuizzesController
    ```

    This controller will service requests for actions on `Quiz` records that are `User` specific. The rationale for having this separate controller is twofold. Firstly, it has more knowledge about the `User` model class than the plain old `QuizzesController` class; thus, the new controller helps to separate concerns. Secondly, adding this controller enables us to use only standard RESTful routes/actions (i.e., `index`, `show`, `new`/`create`, `edit`/`update`, and `destroy`). For example, if we were to instead add the new `index`-style action to the existing `QuizzesController` class, we would have to use a non-standard route, because the standard `index` route is already in use.

1. Add a route for the new user-specific `index` page, like this:

    ```ruby
    resources :quizzes

    get 'account/quizzes', to: 'account_quizzes#index', as: 'account_quizzes' # my quizzes page
    ```

    Note that the above code assumes that the `QuizzesController` routes were previously declared using only the `resources` method. If all those routes were declared individually, then they should now be refactored to use the `resources` method.

1. Add to the `AccountQuizzesController` class the new `index` action that will handle requests that match the new route, like this:

    ```ruby
    def index
      # get all quiz objects belonging to current user
      quizzes = current_user.quizzes
      # display index view
      respond_to do |format|
        format.html { render :index, locals: { quizzes: quizzes } }
      end
    end
    ```

1. Add the `account_quizzes/index.html.erb` view that will be rendered by the new `index` action, like this:

    ```erb
    <h1>My Quizzes</h1>

    <%= link_to 'New Quiz', new_account_quiz_path %>

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

1. Make it easier for users to navigate to the `index` pages for `Quiz` records (i.e., `QuizzesController#index` and `AccountQuizzesController#index`) by adding a hyperlink to each of those `index` pages to the `ul` list of links in `application.html.erb` that display at the top of each page, like this:

    ```erb
      <li>
        <%= link_to "Hi, #{current_user.email}", edit_user_registration_path %>
      </li>
      <li>
        <%= link_to 'Quizzes', quizzes_path %>
      </li>
      <li>
        <%= link_to 'My Quizzes', account_quizzes_path %>
      </li>
      <li>
        <%= link_to 'Sign Out', destroy_user_session_path, method: :delete %>
      </li>
    ```

### 2.3. Updating the `new`/`create` Page/Actions for `Quiz`

At this point, all the pages and actions for `Quiz` should still be functional, except the `new` and `create` actions. The reason that these actions are broken is because `Quiz` must now have a `user_id` in order for `save` to execute without a validation error. To solve this problem, we will update the `new` and `create` actions, and in the process, we will move those actions out of the `QuizzesController` class and into the `AccountQuizzesController` class.

1. Update the routes for the `new` and `create` actions, like this:

    ```ruby
    # includes quizzes#index, quizzes#show, quizzes#edit, quizzes#update, quizzes#destroy
    resources :quizzes, except: [:new, :create]

    get 'account/quizzes', to: 'account_quizzes#index', as: 'account_quizzes' # my quizzes page
    post 'account/quizzes', to: 'account_quizzes#create'
    get 'account/quizzes/new', to: 'account_quizzes#new', as: 'new_account_quiz'
    ```

    Note that the above code removes the old `QuizzesController` routes for `new` and `create` by using the `except` parameter of the `resources` method. It then inserts the new `create` and `new` routes for `AccountQuizzesController` after the `index` route we created earlier in this demo.

1. Move the existing `quizzes/new.html.erb` file to the `account_quizzes` directory, and change the form url to the new route, like this:

    ```erb
    <%= form_with model: quiz, url: account_quizzes_path, method: :post, local: true, scope: :quiz do |form| %>
    ```

1. Comment out the existing `new` and `create` actions in the `QuizzesController` class, and add new ones to the `AccountQuizzesController` class, like this:

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
      quiz = current_user.quizzes.build(params.require(:quiz).permit(:title, :description))
      # respond_to block
      respond_to do |format|
        # html format block
        format.html {
          if quiz.save
            # success message
            flash[:success] = "Quiz saved successfully"
            # redirect to index
            redirect_to account_quizzes_url
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

1. Remove the "`New Quiz`" link from the `quizzes_controller/index.html.erb` view. The rationale for this change is that creating a new quiz from a page where the user is viewing all the quizzes in the system (both theirs and everyone else's) might not make sense, and it's better to have the create-quiz link on the page that lists only the user's quizzes.

## 3. Restricting Permissions on Controller Actions to Owners

Currently, it is possible for a signed-in user to edit and delete quizzes/questions that they don't own (e.g., by directly entering an `edit`-page URL into their browser's location/address bar with the ID of an arbitrary quiz/question). To fix this, we are going to (1) Add a new `before_action` to the `QuizzesController`, the `McQuestionsController`, and the `QuizMcQuestionsController`, and (2) we will display the edit and delete links on the `index` pages only when the current user owns the corresponding quiz/question.

1. Create a new function `require_permission` in the `QuizzesController` that will check that the current user owns a specified quiz, like this:

    ```ruby
    def require_permission
      if Quiz.find(params[:id]).creator != current_user
        redirect_to quizzes_path, flash: { error: "You do not have permission to do that." }
      end
    end
    ```

    Note that if the current user is not the owner, then browser is redirected to to the `index` page for all `Quiz` records.

1. Add a `before_action` declaration at the top of the `QuizzesController` class definition that calls `require_permission` whenever any of the `edit`/`update`/`destroy` actions are invoked, like this:

    ```ruby
    before_action :require_permission, only: [:edit, :update, :destroy]
    ```

    Run the app to verify that the `🖋` and `🗑` links on <http://localhost:3000/quizzes> only work for quizzes the current user created.

1. Add the same `require_permission` method to the `QuizMcQuestionsController`. Also add the same `before_action`, except set it for only the `new` and `create` actions. Run the app to verify that a user cannot add a new question on the `show` page for a quiz they did not create.

1. Similar to above, create a new method `require_permission` in the `McQuestionsController` that will check that the current user owns a specified question, like this::

    ```ruby
    def require_permission
      quiz = McQuestion.find(params[:id]).quiz
      if quiz.creator != current_user
        redirect_to quiz_path(quiz), flash: { error: "You do not have permission to do that." }
      end
    end
    ```

1. Similar to above, add a `before_action` to the `McQuestionsController`, setting it for only the `edit`, `update` and `destroy` actions, like this:

    ```ruby
    before_action :require_permission, only: [:edit, :update, :destroy]
    ```

    Run the app to verify that the `🖋` and `🗑` links for the questions on the `show` page for `Quiz` objects only work for quizzes that are owned by the current user.

1. In the `quizzes/show.html.erb` and the `quizzes/index.html.erb` view, display the "`New Question`", `🖋`, and `🗑` hyperlinks only for the quiz owner by wrapping the links in `if` statements, like this:

    ```erb
    <% if quiz.creator == current_user %>
      <%= link_to 'New Question', new_quiz_mc_question_path(quiz) %>
    <% end %>
    ```

    ```erb
    <% if quiz.creator == current_user %>
      <%= link_to '🖋', edit_mc_question_path(question) %>
      <%= link_to '🗑', mc_question_path(question), method: :delete %>
    <% end %>
    ```

1. Similarly, in the `mc_questions/show.html.erb` view, display the `🖋` and `🗑` hyperlinks only for the owner of the parent `Quiz`, like this:

    ```erb
    <% if question.quiz.creator == current_user %>
      <%= link_to '🖋', edit_mc_question_path(question) %>
      <%= link_to '🗑', mc_question_path(question), method: :delete %>
    <% end %>
    ```

With those steps completed, the QuizMe app should now be fully secured such that users are required to be authenticated in order to view most pages and the data that users create are protected against manipulation by other users.
