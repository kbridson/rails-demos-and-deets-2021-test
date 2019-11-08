---
layout: page
title: 'Demo 12: One to Many Associations (part 2)'
permalink: /demo-12-one-to-many-associations-part-2/
---

# Demo 12: One to Many Associations (part 2)

In this demonstration, I will add Quiz CRUD pages and show how to refactor the existing McQuestion CRUD pages to include the Quiz association we added in the last demo. I will continue to work on the _QuizMe_ project from the previous demos.

## 1. Generating Quiz CRUD Pages

TODO: In this section...

1. Create the QuizzesController.

    ```sh
    rails g controller Quizzes
    ```

    TODO: Empty controller actions have been made.

1. Create the standard RESTful routes for Quizzes including index, show, new, create, edit, update, and delete routes.

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

1. Create the Quizzes index action and page to display all quizzes. The view should match THIS.

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

1. Add a link to the Quiz index page above the About and Contact links on the Home page:

    ```erb
    <p><%= link_to "Quizzes", quizzes_path %></p>
    ```

1. Create the Quizzes new/create and edit/update actions and pages. The views should contain form fields for title and description.

    > `new.html.erb`
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

    > `edit.html.erb`
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

1. Create the Quizzes delete action.

    If you attempt to test the destroy functionality now, you will get a `PG::ForeignKeyViolation` error that, in summary, says "you are trying to delete a parent object (quiz) without destroying the children (mc_questions) which would make the FK reference (quiz_id) invalid." To fix this, you need to add the `dependent: destroy` option on the `has_many` association in Quiz:

    ```ruby
    has_many :mc_questions, # Quiz attribute containing an array of McQuestion objects
      class_name: 'McQuestion', # datatype of attribute
      foreign_key: 'quiz_id', # name of column containing FK in other table
      inverse_of: :quiz # attribute on other side of association (parent Quiz object)
      dependent: :destroy
    ```

    With this option, destroying a parent will destroy all the child records as well.

1. Create the Quizzes show action and page to display a single quiz. For now, the view should match THIS.

<div class="figure-container mx-auto my-4" style="max-width: 960px;">
<figure class="figure">
<img src="{{ site.baseurl }}/resources/demo-12-quiz-show-1.png" class="figure-img img-fluid rounded" alt="Class diagram for McQuestion model.">
<figcaption class="figure-caption">Fig 1. Class diagram for McQuestion model. (Diagram created using <a href="https://www.genmymodel.com">GenMyModel</a>.)</figcaption>
</figure>
</div>

    ```erb
    <h2><%= quiz.title %></h3>

    <p><%= quiz.description %></p>
    ```

1. Add code to show page to render the questions associated with a certain quiz on the show page.

    ```erb
    <h2>Questions</h2>

    <%= link_to 'New Question', new_mc_question_path %>

    <% quiz.mc_questions.each do |question| %>
      <div id="<%= dom_id(question) %>">
        <p>
          <%= question.question %>
          <%= link_to '🛈', mc_question_path(question) %>
          <%= link_to '✎', edit_mc_question_path(question) %>
          <%= link_to '🗑', mc_question_path(question), method: :delete %>
        </p>

        <%
        choices = [question.answer, question.distractor_1]
        choices << question.distractor_2 if !question.distractor_2.blank?
        choices.each do |c|
        %>
          <div>
            <%= radio_button_tag "guess_#{question.id}", c, checked = c == question.answer, disabled: true %>
            <%= label_tag "guess_#{question.id}_#{c}", c %>
          </div>

        <% end %>
      </div>
    <% end %>
    ```

    TODO: Try to create a new question using the link. Cannot save because of quiz id.

## 2. Refactoring Existing McQuestion Pages to Use the Association

TODO: In this section...
What actions need to be refactored? Shallow nesting - index, new, create

Refactor New/Create: 

1. Add a new controller QuizMcQuestionsController.

1. Move the index.html.erb and new.html.erb from mc_questions to quiz_mc_questions.

1. Replace the existing McQuestion routes for index, new, and show with nested routes:

    ```ruby
    # get 'mc_questions', to: 'mc_questions#index', as: 'mc_questions' # index
    get 'quizzes/:id/mc_questions', to: 'quiz_mc_questions#index', as: 'quiz_mc_questions' # nested index  
    # get 'mc_questions/new', to: 'mc_questions#new', as: 'new_mc_question' # new
    get 'quizzes/:id/mc_questions/new', to: 'quiz_mc_questions#new', as: 'new_quiz_mc_question' # nested new
    # post 'mc_questions', to: 'mc_questions#create'                        # create
    post 'quizzes/:id/mc_questions', to: 'quiz_mc_questions#create'                        # nested create
    ```

1. Comment out the existing index, new, create actions in McQuestionsController.

1. Add an index action in QuizMcQuestionsController:

    ```ruby
    def index
      quiz = Quiz.includes(:mc_questions).find(params[:id])
      respond_to do |format|
        format.html { render :index, locals: { quiz: quiz, questions: quiz.mc_questions } }
      end
    end
    ```

1. Change the path for the "New Question" link in `quiz_mc_questions/index.html.erb` and `quizzes/show.html.erb` to the nested path:

    ```erb
    <%= link_to 'New Question', new_quiz_mc_question_path(quiz) %>
    ```

1. Create the new action:

    ```ruby
    def new
      quiz = Quiz.find(params[:id])
      respond_to do |format|
        format.html { render :new, locals: { quiz: quiz, question: quiz.mc_questions.build } }
      end
    end
    ```

1. Change the URL for the form in new.html.erb:

    ```erb
    <%= form_with model: question, url: quiz_mc_questions_path(quiz), method: :post, local: true, scope: :mc_question do |form| %>
    ```

1. Create the create action:

    ```ruby
    def create
      # new object from params
      quiz = Quiz.find(params[:id])
      question = quiz.mc_questions.build(params.require(:mc_question).permit(:question, :answer, :distractor_1, :distractor_2))
      # respond_to block
      respond_to do |format|
        # html format block
        format.html {
          if question.save
            # success message
            flash[:success] = "Question saved successfully"
            # redirect to index
            redirect_to quiz_mc_questions_url(quiz)
          else
            # error message
            flash.now[:error] = "Error: Question could not be saved"
            # render new
            render :new, locals: { quiz: quiz, question: question }
          end
        }
      end
    end
    ```

1. Change the update action in McQuestionsController to permit quiz_id and redirect to the quiz show page:

    ```ruby
    def update
      # load existing object again from URL param
      question = McQuestion.find(params[:id])
      # respond_to block
      respond_to do |format|
        # html format block
        format.html {
          # if question updates with permitted params
          if question.update(params.require(:mc_question).permit(:question, :answer, :distractor_1, :distractor_2))
            # success message
            flash[:success] = 'Question updated successfully'
            # redirect to index
            redirect_to quiz_url(question.quiz_id)
          else
            # error message
            flash.now[:error] = 'Error: Question could not be updated'
            # render edit
            render :edit, locals: { question: question }
          end
        }
      end
    end
    ```

1. Change the destroy action to redirect to the quiz show page:

    ```ruby
    def destroy
      # load existing object again from URL param
      question = McQuestion.find(params[:id])
      # destroy object
      question.destroy
      # respond_to block
      respond_to do |format|
        # html format block
        format.html {
          # success message
          flash[:success] = 'Question removed successfully'
          # redirect to index
          redirect_to quiz_url(question.quiz_id)
        }
      end
    end
    ```
