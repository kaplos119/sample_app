# README

1. clone the repo
	a. git clone https://github.com/kaplos119/sample_app.git
	b. go to root folder of app
2. Below command will create two containers one for web app and another for postgres
	a. docker compose up
3. Now, check running two containers and pick web app container id
	a. docker exec -it {web_app_container id} bash
	b. now, you are in /app folder of container and execute --> rake db:migrate
	c. rake db:seed
	d. rake jobs:work
4. Go to localhost:3000 and sign up with a user
5. You will be able to see two event buttons
6. Created two mock apis on wiremock cloud where you can see request log under left navigation.

