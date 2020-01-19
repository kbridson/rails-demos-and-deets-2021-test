## Which Rails database command do I need?

There are several commonly used Rails db commands:

    - rails db:create
        Creates the development and test databases for the project 
    - rails db:drop
        Deletes the development and test databases for the project 
    - rails db:migrate:status
        If the database
    - rails db:migrate
    
    - rails db:seed
    - rails db:migrate:status
    - rails db:reset

    - rails db:migrate:reset
    - rails db:seed:replant

Which one you use in a given situation depends on the circumstances. Here are some common situations and the commands that are most useful in them:

1. Situation: 
      - My database migrations are up to date
      - I have extra data in the db that I want to delete, or I have updated my seeds file.
    Use:
      `rails db:seed:replant`
      This command will keep the structure of the database (tables), but delete the data from all the tables and refill them with the seed data.

1. Situation:
      - I have a database
      - I don't know which migrations have been run.
    Use:
      `rails db:migrate:status`
      This command shows a list of migrations with "up" (run) or "down" (not run).

1. Situation:
      - 
