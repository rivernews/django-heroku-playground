# django-heroku-playground

The latest code in this repo serves as a working example for project that wants to
- Combine React into Django; i.e., let Django serve React over the same origin, so you don't have to deal with CORS.
- Deploy on Heroku for production

## How to scaffold a project

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
- Create the react app: run `npx create-react-app <directory-to-create> --template typescript`. You may want to plan the directory in the way below:
```yml
repo_root:
    django_project_root:
        manage.py
        django_project_name:
            wsgi.py
            settings.py
        other_django_app:
        frontend:  <-----------  💬create react here!
    .gitignore
    other_files
```
- Let Heroku build the frontend (refer to https://librenepal.com/article/django-and-create-react-app-together-on-heroku/)
    - Need a package.json and yarn.lock to trick Heroku to provide nodejs compute environment. See the article.
    - Run `heroku buildpacks:set heroku/python --app django-heroku-playground`
    - Run `heroku buildpacks:add --index 1 heroku/nodejs --app django-heroku-playground` 

## Key takeaways of making static file work for react-django bundling
- The heroku toolkit `django_heroku` may help, even if it's deprecated (still, we have a succession maintainer `django_on_heroku`, so not too bad)
    - This worked, but just have to install lots of stuff, including postgres (can't use psycopg2-binary, but `django_on_heroku` addressed this issue).
    - What does the toolkit bundle actually do?
        - Setup `ALLOW_HOST`, `STATIC_ROOT`, and also postgres database.
        - Setup `staticfiles` empty directory
        - Setup `WhiteNoise`.
    - How the toolkit achieves the above? Take a look at [the code](https://github.com/heroku/django-heroku/blob/master/django_heroku/core.py).
- The `STATIC_ROOT` points to a directory on the filesystem and need to pre-exist, otherwise `collectstatic` will not work and not copying files there. More than one places state this.
    - At a best practice standpoint however, will be against this, since the directory is only for production environment, and has no use on local environment. Maybe creating that directory ad-hoc when deploying production would be better, which is likely what the heroku toolkit `django_heroku` is already doing.
- To not need to build react separately every time we deploy Django, we need to setup heroku a nodejs environment
- To eliminate all 404 - mainly the files in `public/`, which later on get copied to `build/`, we need to extend `STATICFILES_DIRS` to point to directory that contains those files too.
    - First need to let `npm run build` generate a `index.html` where all resources starts by `/static/`. To do this, make sure supple `PUBLIC_URL=/static` when building.
    - Typically, we want all `build/static` and let it be under django's collected static directory. We also want files at `build/` to be under django's static directory.
    - One way to do this is to just copy over entire `build` (or if react resides inside Django app, just need to `npm run build`), then have `STATICFILES_DIRS` point to both `...build/static` and `...build`.