# django-heroku-playground
Using latest django, deploy on heroku and debug collectstatic

- Create Django project: https://devcenter.heroku.com/articles/django-memcache
- Create a heroku app
    - First you need the herokucli. Here we build the herokucli in a docker image `shaungc/herokucli`
    - Then run ` docker run --rm -it -v $(pwd):/temp -v $(pwd)/root:/root shaungc/herokucli create django-heroku-playground`
    - And run ` docker run --rm -it -v $(pwd):/temp -v $(pwd)/root:/root shaungc/herokucli git:remote -a django-heroku-playground`
    - After login, you should see auth token appear in `.netrc`.
- Deploy the app
    - Run `git push heroku <your-current-branch>:master`.
    - When prompted credential, username use Heroku email, password use the token we got above.
- Create app in django - refer to Django doc: https://docs.djangoproject.com/en/3.1/intro/tutorial01/
- Create the react app: run `npx create-react-app react_project --template typescript`.
- Let Heroku build the frontend (refer to https://librenepal.com/article/django-and-create-react-app-together-on-heroku/)
    - Need a package.json and yarn.lock to trick Heroku to provide nodejs compute environment. See the article.
    - Run `heroku buildpacks:set heroku/python --app django-heroku-playground`
    - Run `heroku buildpacks:add --index 1 heroku/nodejs --app django-heroku-playground` 
