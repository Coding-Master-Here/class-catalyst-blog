# README

# Blog API

This is a simple blog API built with Ruby on Rails and PostgreSQL.

## Requirements

1. Install ruby 3
2. Install rails 7
## Setup

1. Clone the repository:
  ```
  git clone https://github.com/<your-username>/<repository-name>.git
  cd <repository-name>
```
2. Install dependencies:
  ```
  bundle install
  ```
3. Set up the database:
  ```
  rails db:create
  rails db:migrate
  ```
4. Run the Rails server:
  ```
  rails server
  ```
5. Add Env vars
  ```
  Create .env file in root directory of the project and add this ENV in it if your db user is different else postgres will be used by default
  DB_USER=postgres
  ```

## Postman Collection

Please check public folder for postman collection

## App Flow
1. First create a new user using `Create User` postman collection to get it's auth token
2. Then use the auth token to create a new post using `Create Post` collection and pass body as json with appropriate params.
3. To get all posts use `Get All Posts` collection.
4. To get one post and it's details use `Get One Post` collection.
5. To add comment to a post use `Create Comment` collection.

## App Code Logic
1. I've used base controller strategy to imply DRY methodology of rails so we can achieve code re-usability as much as we can.
2. I've added test covergage for post and comment models.
3. Also added serialization so we can have proper control over json response

##Bonus Part
1. I've also implemented pagination using kaminari