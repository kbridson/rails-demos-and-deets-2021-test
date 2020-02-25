---
title: 'Forms That Handle One-to-Many Associations'
---

# {{ page.title }}

In this demonstration, I will show how incorporate an association into the basic Rails resource pages and actions (i.e., `index`, `show`, `new`/`create`, `edit`/`update`, and `destroy`). We will continue to build upon the [QuizMe project](https://github.com/human-se/quiz-me-2020){:target="_blank"} from the previous demos.

Recall from Figure 1 that our association now specifies that `McQuestion` objects belong to a particular parent `Quiz` object.

{% include image.html file="one-to-many_class_assoc.svg" alt="A UML class diagram depicting the one-to-many association between the Quiz and McQuestion model classes" caption="Figure 1. Model class design diagram showing the one-to-many association between `Quiz` and `McQuestion`. As per the association, each `Quiz` object has many `McQuestion` objects, and each `McQuestion` object belongs to one `Quiz` object." %}

As a consequence, several changes to our Rails resource pages and actions are necessitated. These changes will involve the following main tasks:

1. Update the `show` page for `Quiz` to display associated `McQuestion` objects, as depicted in Figure 2.
1. Generate a `QuizMcQuestionsController` to use for actions on `McQuestion` records that require the ID of the parent `Quiz` to be included in their routes.
1. Move the `index` controller actions for `McQuestion` records into the new `QuizMcQuestionsController` class with a new route that includes the `Quiz` ID in the URI.
1. Move the `new` and `create` controller actions for `McQuestion` records into the new `QuizMcQuestionsController` class with new routes that include the `Quiz` ID in their URIs.
1. Update the existing `update` and `destroy` controller actions for `McQuestion` records so that they redirect to the parent `Quiz` object's `show` page.

{% include image.html file="quiz_show_with_questions.png" alt="Screenshot of a web browser" caption='Figure 2. Updated `show` page for `Quiz` records that now has a "Questions" subsection that displays the associated `McQuestion` objects.' %}

## 1. Displaying Associated `McQuestion` Records on the `show` Page for `Quiz` Records

On the `show` page for a `Quiz` object, display the questions associated with that quiz by adding HTML.ERB code to the `show.html.erb`, like this:

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

Confirm that this code works correctly by running the app, opening the `index` page for `Quiz` records, and navigating to the `show` page for each `Quiz` record. The `show` pages should now include a "Questions" subsection, as depicted in Figure 2.

**[➥ Code changeset for this part](https://github.com/human-se/quiz-me-2020/commit/f9c100b14267fccfa2fdbf1fed4629591dec9e05){:target="_blank"}**

## 2. Generating a `QuizMcQuestionsController` Class

Create a new controller `QuizMcQuestionsController` using this command:

```bash
rails g controller QuizMcQuestions
```

We will use this controller class, `QuizMcQuestionsController`, to handle HTTP requests that primarily act upon `McQuestion` records, include a parent `Quiz` ID in the resource path.

Confirm that the file `app/controllers/quiz_mc_questions_controller.rb` was generated correctly.

**[➥ Code changeset for this part](https://github.com/human-se/quiz-me-2020/commit/53d28bdd24948c4bcd96c3351f2f454fe3a6ed06){:target="_blank"}**

## 3. Moving the `index` Action from `McQuestionsController` to `QuizMcQuestionsController`

Replace the existing `McQuestion` route for `index` with a nested route, like this:

```ruby
# get 'mc_questions', to: 'mc_questions#index', as: 'mc_questions' # index
get 'quizzes/:id/mc_questions', to: 'quiz_mc_questions#index', as: 'quiz_mc_questions' # nested index
```

Note that this route requires the parent `Quiz` ID in the resource path. The `index` route needs the parent ID, because it no longer makes sense to display all `McQuestion` objects, rather, we will group them by their parent `Quiz` object.

Comment out (or delete) the existing `index` action in `McQuestionsController`.

Add a new `index` action to `QuizMcQuestionsController`, like this:

```ruby
def index
  quiz = Quiz.includes(:mc_questions).find(params[:id])
  respond_to do |format|
    format.html { render :index, locals: { quiz: quiz, questions: quiz.mc_questions } }
  end
end
```

The `includes` method helps minimize the number of database queries by specifying the associations that need to be loaded (see the [N+1 Queries Problem](https://guides.rubyonrails.org/active_record_querying.html#eager-loading-associations)).

Move the `index.html.erb` view file from `app/views/mc_questions` to `app/views/quiz_mc_questions`.

Confirm that these changes work correctly by running the app and opening the URL <http://localhost:3000/quizzes/1/mc_questions> for the first `Quiz` record and <http://localhost:3000/quizzes/1/mc_questions> for the second `Quiz` record.

**[➥ Code changeset for this part](https://github.com/human-se/quiz-me-2020/commit/8d7a430ccfa77486242cf44884011e5edc7e9912){:target="_blank"}**

## 4. Moving `new` and `create` Actions from `McQuestionsController` to `QuizMcQuestionsController`

Replace the existing `McQuestion` routes for `new`, and `create` with nested routes, like this:

```ruby
# get 'mc_questions/new', to: 'mc_questions#new', as: 'new_mc_question' # new
get 'quizzes/:id/mc_questions/new', to: 'quiz_mc_questions#new', as: 'new_quiz_mc_question' # nested new

# post 'mc_questions', to: 'mc_questions#create' # create
post 'quizzes/:id/mc_questions', to: 'quiz_mc_questions#create' # nested create
```

Note that these routes both require the parent `Quiz` ID in the resource path. The `new` and `create` routes need the parent `Quiz` ID, so the `create` controller action knows which `Quiz` object has the new `McQuestion` object.

Comment out (or delete) the existing `new` and `create` actions in `McQuestionsController`.

Add a new `new` action to `QuizMcQuestionsController`, like this:

```ruby
def new
  quiz = Quiz.find(params[:id])
  respond_to do |format|
    format.html { render :new, locals: { quiz: quiz, question: quiz.mc_questions.build } }
  end
end
```

The call to `build` allocates in memory a new empty `McQuestion` object that is associated with the `quiz`; however, the `McQuestion` object is not yet saved to the database (and thus, for example, has an `id` that is `nil`).

Move the `new.html.erb` view file from `app/views/mc_questions` to `app/views/quiz_mc_questions`.

In `new.html.erb`, change the `url` argument for `form_with`, like this:

```erb
<%= form_with model: question, url: quiz_mc_questions_path(quiz), method: :post, local: true, scope: :mc_question do |form| %>
```

Add a new `create` action to `QuizMcQuestionsController`, like this::

```ruby
def create
  # find the quiz to which the new question will be added
  quiz = Quiz.find(params[:id])
  # allocate a new question associated with the quiz
  question = quiz.mc_questions.build(params.require(:mc_question).permit(:question, :answer, :distractor_1, :distractor_2))
  # respond_to block
  respond_to do |format|
    format.html do
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
    end
  end
end
```

Update the "`New Question`" link in `quiz_mc_questions/index.html.erb` and add a "`New Question`" link to `quizzes/show.html.erb` (as per Figure 1), like this:

```erb
<%= link_to 'New Question', new_quiz_mc_question_path(quiz) %>
```

Confirm that these changes work correctly by resetting the database, running the app, navigating the various `show` pages for `Quiz` records, and using the "`New Question`" link to add new `McQuestion` records.

**[➥ Code changeset for this part](https://github.com/human-se/quiz-me-2020/commit/1a4428e86ca05af35515a2c5d943d4768af3cb25){:target="_blank"}**

## 5. Updating the `McQuestion` `update` and `destroy` Actions to Use the Parent `Quiz`

Modify the `update` action in `McQuestionsController` such that, on a successful save, the browser is redirected to the `show` page of the parent `Quiz` object, like this:

```ruby
def update
  # load existing object again from URL param
  question = McQuestion.find(params[:id])
  # respond_to block
  respond_to do |format|
    format.html do
      if question.update(params.require(:mc_question).permit(:question, :answer, :distractor_1, :distractor_2))
        # success message
        flash[:success] = 'Question updated successfully'
        # redirect to index
        redirect_to quiz_url(question.quiz)
      else
        # error message
        flash.now[:error] = 'Error: Question could not be updated'
        # render edit
        render :edit, locals: { question: question }
      end
    end
  end
end
```

Change the `destroy` action in `McQuestionsController` such that, after the record is deleted, the browser is redirected to the `show` page of the parent `Quiz` object, like this:

```ruby
def destroy
  # load existing object again from URL param
  question = McQuestion.find(params[:id])
  # destroy object
  question.destroy
  # respond_to block
  respond_to do |format|
    format.html do
      # success message
      flash[:success] = 'Question removed successfully'
      # redirect to index
      redirect_to quiz_url(question.quiz)
    end
  end
end
```

Confirm that these changes work correctly by resetting the database, running the app, navigating the various `show` pages for `Quiz` records, and using the "`🖋`" (edit) and "`🗑`" (delete) links to update and delete some `McQuestion` records for each `Quiz`.

Having successfully completed the above tasks, the QuizMe app now provides users with a full set of features for CRUDing quizzes and questions that properly handle the association links between quizzes and questions.

**[➥ Code changeset for this part](https://github.com/human-se/quiz-me-2020/commit/1917e1b67d55bcd9b1e58457accb0407e4ae8373){:target="_blank"}**

{% include pagination.html prev_page='demo-one-to-many.md' next_page='demo-devise-auth.md' %}
