---
title: 'Forms That Handle One-to-Many Associations'
---

# {{ page.title }}

In this demonstration, I will show how incorporate an association into the basic CRUD resource pages and actions we have discussed previously (i.e., `index`, `show`, `new`/`create`, `edit`/`update`, and `destroy`). We will continue to build upon the _QuizMe_ project from the previous demos.

In particular, because our association now specifies that `McQuestion` objects belong to a particular `Quiz` object, several changes to our CRUD pages and actions are necessitated. These changes will involve three main tasks:

1. Update the `show` page for `Quiz` to display associated `McQuestion` objects, as depicted in Figure 1.
1. Move `index`, `new`, and `create` actions into a new `QuizMcQuestionsController` class with new routes that include the `Quiz` ID in the URI.
1. Update the existing `update` and `destroy` actions to, for example, redirect to the parent `Quiz`'s `show` page (instead of the `McQuestion` `index` page).

<div class="figure-container mx-auto my-4" style="max-width: 960px;">
<figure class="figure">
<img src="{{ site.baseurl }}/resources/demo12_fig01.png" class="figure-img img-fluid rounded border" alt="Screenshot of browser page">
<figcaption class="figure-caption">Figure 1. Updated <code>show</code> page for <code>Quiz</code> records that now has a "Questions" subsection that displays the associated <code>McQuestion</code> objects.</figcaption>
</figure>
</div>

As we perform the tasks below, don't forget, after you finish each page, to run the page so as to "fail fast", catching and fixing bugs quickly when it's easier to find and understand them.

## 1. Displaying Associated Records on a Model's `show` Page

1. On the `show` page for a `Quiz` object, display the questions associated with that quiz by adding HTML.ERB code to the `show.html.erb`, like this:

    ```erb
    <h2>Questions</h2>

    <% quiz.mc_questions.each do |question| %>
      <div id="<%= dom_id(question) %>">
        <p>
          <%= question.question %>
          <%= link_to '🔎', mc_question_path(question) %>
          <%= link_to '🖋', edit_mc_question_path(question) %>
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

## 2. Moving `index`, `new`, and `create` Actions from `McQuestion` into `QuizMcQuestionsController`

1. Create a new controller `QuizMcQuestionsController` using this command:

    ```bash
    rails g controller QuizMcQuestions
    ```

1. Replace the existing `McQuestion` routes for `index`, `new`, and `show` with nested routes, like this:

    ```ruby
    # get 'mc_questions', to: 'mc_questions#index', as: 'mc_questions' # index
    get 'quizzes/:id/mc_questions', to: 'quiz_mc_questions#index', as: 'quiz_mc_questions' # nested index

    # get 'mc_questions/new', to: 'mc_questions#new', as: 'new_mc_question' # new
    get 'quizzes/:id/mc_questions/new', to: 'quiz_mc_questions#new', as: 'new_quiz_mc_question' # nested new

    # post 'mc_questions', to: 'mc_questions#create' # create
    post 'quizzes/:id/mc_questions', to: 'quiz_mc_questions#create' # nested create
    ```

1. Move the `index.html.erb` and `new.html.erb` view files from `app/views/mc_questions` to `app/views/quiz_mc_questions`.

1. Comment out (or delete) the existing `index`, `new`, and `create` actions in `McQuestionsController`.

1. Add a new `index` action to `QuizMcQuestionsController`, like this:

    ```ruby
    def index
      quiz = Quiz.includes(:mc_questions).find(params[:id])
      respond_to do |format|
        format.html { render :index, locals: { quiz: quiz, questions: quiz.mc_questions } }
      end
    end
    ```

    The `includes` method helps minimize the number of database queries by specifying the associations that need to be loaded (see the [N+1 Queries Problem](https://guides.rubyonrails.org/active_record_querying.html#eager-loading-associations)).

1. Update the "`New Question`" link in `quiz_mc_questions/index.html.erb` and add a "`New Question`" link to `quizzes/show.html.erb` (as per Figure 1), like this:

    ```erb
    <%= link_to 'New Question', new_quiz_mc_question_path(quiz) %>
    ```

1. Add a `new` action to `QuizMcQuestionsController`, like this:

    ```ruby
    def new
      quiz = Quiz.find(params[:id])
      respond_to do |format|
        format.html { render :new, locals: { quiz: quiz, question: quiz.mc_questions.build } }
      end
    end
    ```

    The call to `build` allocates in memory a new empty `McQuestion` object that is associated with the `quiz`; however, the `McQuestion` object is not yet saved to the database (and thus, for example, has an `id` that is `nil`).

1. In `new.html.erb`, change the `url` argument for `form_with`, like this:

    ```erb
    <%= form_with model: question, url: quiz_mc_questions_path(quiz), method: :post, local: true, scope: :mc_question do |form| %>
    ```

1. Add a `create` action to `QuizMcQuestionsController`, like this::

    ```ruby
    def create
      # find the quiz to which the new question will be added
      quiz = Quiz.find(params[:id])
      # allocate a new question associated with the quiz
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

## 3. Updating `McQuestion` `update` and `destroy` Actions to Use Parent `Quiz`

1. Modify the `update` action in `McQuestionsController` to permit `quiz_id` and redirect to the `Quiz` `show` page, like this:

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

1. Change the `destroy` action in `McQuestionsController` to redirect to the `Quiz` `show` page, like this:

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

Having successfully completed the above tasks, the QuizMe app now provides users with a full set of features for CRUDing quizzes and questions.

{% include pagination.html prev_page='demo-one-to-many.md' next_page='demo-devise-auth.md' %}
