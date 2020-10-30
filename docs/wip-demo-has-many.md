
# Adding a Many-to-Many Association



## Creating a Join Table for a User's Favorite Quizzes


rails g migration CreateJoinTableFavoriteQuizzes quiz:references user:references


https://guides.rubyonrails.org/v6.0.2.1/active_record_migrations.html#creating-a-standalone-migration



## Adding has_and_belongs_to_many Declarations to User and Quiz


user.rb:

has_and_belongs_to_many(
  :favorite_quizzes, 
  class_name: 'Quiz',
  join_table: 'favorite_quizzes',
  association_foreign_key: 'quiz_id',
  inverse_of: :users_favorited_by
)


quiz.rb:

has_and_belongs_to_many(
  :users_favorited_by, 
  class_name: 'User',
  join_table: 'favorite_quizzes',
  association_foreign_key: 'user_id',
  inverse_of: :favorite_quizzes
)



## Seeding the Database


seeds.rb:

test_quizzes = []
10.times do |i|
  q = Quiz.create!(creator: u2, title: "TestQuiz#{i}", description: 'Testing')
  if i % 2 == 0
    u1.favorite_quizzes << q
  end
end



# Displaying HMABTM



## Controller


rails g controller FavoriteQuizzes


favorite_quizzes_controller.rb:

before_action :authenticate_user!



## Index Action/View

routes.rb:

get 'account/quizzes/favorites', to: 'favorite_quizzes#index', as: 'favorite_quizzes'


favorite_quizzes_controller.rb:

def index
  # get all quizzes user has favorited
  favorite_quizzes = current_user.favorite_quizzes
  # display list of quizzes
  respond_to do |format|
    format.html { render :index, locals: { favorite_quizzes: favorite_quizzes } }
  end
end


favorite_quizzes/index.html.erb:

<h1>Favorite Quizzes</h1>

<% favorite_quizzes.each do |quiz| %>
  <div id="<%= dom_id(quiz) %>">
    <div class="card container border-primary mb-3">
      <div class="card-header row justify-content-between text-white bg-primary">
        <h5 class='m-0'><%= quiz.title %></h5>
        <div>
          <%= link_to '🔎', quiz_path(quiz) %>
          <% if quiz.creator == current_user %>
            <%= link_to '🖋', edit_quiz_path(quiz) %>
            <%= link_to '🗑', quiz_path(quiz), method: :delete %>
          <% end %>
        </div>
      </div>
      <div class="card-body">
        <h6 class="card-subtitle mb-2 text-muted">By: <%= quiz.creator.email %></h6>
        <p class="card-text"><%= truncate quiz.description, length: 75, separator: ' ' %></p>
      </div>
    </div>
  </div>
<% end %>



## Link on Navbar


application.html.erb:

<li class="nav-item <%= active_class(favorite_quizzes_path) %>">
  <%= link_to 'Favorite Quizzes', favorite_quizzes_path, class: 'nav-link' %>
</li>



# Creating and Destroying HSABTM Association Links



## Controller Action for Creating Association Link


routes.rb:

post 'quizzes/:id/favorite', to: 'favorite_quizzes#create', as: 'favorite_quiz'


favorite_quizzes_controller.rb:

  def create
    # find the quiz to favorite
    quiz = Quiz.find(params[:id])
    # add quiz to user's favorites
    current_user.favorite_quizzes << quiz
    respond_to do |format|
      format.html { 
        if current_user.save
          # success message
          flash[:success] = "Favorite saved successfully"
        else
          # error message
          flash[:error] = "Error: Quiz could not be favorited"
        end
        # redirect to index
        redirect_to quizzes_url
      }
    end
  end



## Controller Action for Destroying Association Link


routes.rb:

delete 'quizzes/:id/favorite', to: 'favorite_quizzes#destroy'


	favorite_quizzes_controller.rb:

  def destroy
    quiz = Quiz.find(params[:id])
    respond_to do |format|
      format.html { 
        if current_user.favorite_quizzes.delete(quiz)
          # success message
          flash[:success] = "Favorite successfully deleted"
        else
          # error message
          flash[:error] = "Error: Favorite cannot be deleted"
        end
        # redirect to index
        redirect_to quizzes_url
      }
    end
  end



## Links to Favorite and Unfavorite


quizzes/index.html.erb:

          <% favorited = quiz.users_favorited_by.find { |u| u == current_user } %>
          <% if favorited.blank? %>
            <%= link_to '☆', favorite_quiz_path(quiz), { method: :post, class: "text-dark", style: "font-size: 1.5rem;" }  %>
          <% else %>
            <%= link_to '★', favorite_quiz_path(quiz), { method: :delete, class: "text-dark", style: "font-size: 1.5rem;" } %>
          <% end %>


quizzes_controller.rb:

quizzes = Quiz.includes(:creator, :users_favorited_by).all

