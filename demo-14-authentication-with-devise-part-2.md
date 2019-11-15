---
layout: page
title: 'Demo 14: Authentication with Devise (Part 2)'
permalink: /demo-14-authentication-with-devise-part-2/
---

# {{ page.title }}

In this demonstration, I will show how to integrate the Devise User into the project by stipulating that each quiz must belong to a user and a quiz and its associated questions should only be changeable by the user that created it.

To accomplish this, we need to:

    1. Create the association between User and Quiz given by diagram.
    2. Edit the existing pages to use the association.
    3. Restrict permission to the new/create/edit/update/delete actions for a quiz unless the current user is the quiz creator.
    
## 1. Create the association between User and Quiz

1. Generate a migration to add the User FK to Quiz. The change method should contain:

    ```ruby
    add_reference :quizzes, :user, foreign_key: true
    ```

1. Run `rails db:migrate`.

1. Add the `has_many` and `belongs_to` statements in User and Quiz:

    > user.rb
    ```ruby
    has_many :quizzes,
      class_name: 'Quiz',
      foreign_key: 'user_id',
      inverse_of: :creator
    ```

    > quiz.rb
    ```ruby
    belongs_to :creator,
      class_name: 'User',
      foreign_key: 'user_id',
      inverse_of: :quizzes
    ```

1. Add some User seeds, and assign each Quiz seed to a User:

    ```ruby
    u1 = User.create!(email: 'alice@gmail.com', password: 'password')
    u2 = User.create!(email: 'bob@gmail.com', password: 'password')

    q1 = Quiz.create!(creator: u1, title: 'MVC Concepts', description: 'This quiz contains questions related to the Model-View-Controller web application architecture.')
    q2 = Quiz.create!(creator: u2, title: 'Rails Concepts', description: 'This quiz contains questions related to web application development using the Ruby on Rails platform.')
    ```

1. Run `rails db:seed:replant`.

## 2. Update Existing Pages to Use the Association

1. Add code to display the email of the quiz's creator on the Quiz index and show pages:

    ```erb
    <p>
      Created by: <%= quiz.creator.email %>
    </p>
    ```
    Check that the email is displays correctly for the seeded quizzes.

1. Solve the N+1 Query Problem we just made on the Quiz index page by changing the query in the controller action to:

    ```ruby
    quizzes = Quiz.includes(:creator).all
    ```

At this point, all the other pages and action for Quiz should still be functional except the new and create actions. A Quiz must have a user_id to save. We will create a new controller and routes for the updated new and create actions and a new page for the logged in user to see only their quizzes.

1. Create a new AccountQuizzes controller.

1. Add routes for the new index ("My Quizzes"), new and create actions:

    ```ruby
    # includes quizzes#index, quizzes#show, quizzes#edit, quizzes#update, quizzes#destroy
    resources :quizzes, except: [:new, :create]
    
    get 'account/quizzes', to: 'account_quizzes#index', as: 'account_quizzes' # my quizzes page
    post 'account/quizzes', to: 'account_quizzes#create'
    get 'account/quizzes/new', to: 'account_quizzes#new', as: 'new_account_quiz'
    ```

1. Add the new quiz index page with:

    > account_quizzes/index.html.erb
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

    > account_quizzes_controller#index
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

1. Add a link to both the Quizzes#index and AccountQuizzes#index pages in the `<ul>` in application.html.erb:

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

1. Move the existing quizzes/new.html.erb file to the account_quizzes directory and change the form url to the new route:

    ```erb
    <%= form_with model: quiz, url: account_quizzes_path, method: :post, local: true, scope: :quiz do |form| %>
    ```

1. Comment out the existing new and create actions in QuizzesController and add new ones to AccountQuizzesController matching:

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

1. Remove the "New Quiz" link from the Quizzes#index page.

## 3. Restricting Functionality to Creator Only

We don't want any user other than the quiz creator to be able to change or delete a quiz or any of the quiz's questions. To fix this, we are going to:

    1. Add a new before_action in the controllers
    2. Hide the edit and delete links from the Quizzes#index page and McQuestion pages for non-creators

1. Create a new function `require_permission` in the QuizzesController:

    ```ruby
    def require_permission
      if Quiz.find(params[:id]).creator != current_user
        redirect_to quizzes_path, flash: { error: "You do not have permission to do that." }
      end
    end
    ```

1. Add the before_action statement to the top of the QuizzesController:

    ```ruby
    before_action :require_permission, only: [:edit, :update, :destroy]
    ```

    Check that the 🖋 and 🗑 links on http://localhost:3000/quizzes only work for quizzes the current user created.

1. Add the same `require_permission` function to the QuizMcQuestionsController. Set the `before_action` for only the new and create actions. Check that you cannot add a new question on the Quizzes#show page for a quiz you did not create.

1. Create a new function `require_permission` in the McQuestionsController:

    ```ruby
    def require_permission
      quiz = McQuestion.find(params[:id]).quiz
      if quiz.creator != current_user
        redirect_to quiz_path(quiz), flash: { error: "You do not have permission to do that." }
      end
    end
    ```

1. Set the `before_action` for the edit, update and destroy actions.

    ```ruby
    before_action :require_permission, only: [:edit, :update, :destroy]
    ```

    Check that the 🖋 and 🗑 links for the questions on the Quizzes#show page only work for quizzes the current user created.

1. On the Quizzes#show page, hide the "New Question", 🖋 and 🗑 links for non-creators by wrapping them in an if statement like:

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

1. Do the same on Quizzes#index.

1. Remove the 🖋 and 🗑 links for non-creators on the McQuestion#show page with:

    ```erb
    <% if question.quiz.creator == current_user %>
      <%= link_to '🖋', edit_mc_question_path(question) %>
      <%= link_to '🗑', mc_question_path(question), method: :delete %>
    <% end %>
    ```