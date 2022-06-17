# Backend

## Initialize the Project
```bash
python -m venv ~/.virtualenvs/myproject
source ~/.virtualenvs/myproject/bin/activate
pip install freenit[dev]
freenit.sh myproject
cd myproject
bin/devel.sh
```
It will create initial DB migration, apply it and start 
[local development server](http://localhost:5000/api/v1) so you can check if 
everything is OK.

You will get just a few basic tests on initialization. You can run them with:
```bash
bin/test.sh
```

To write more tests, add `test_<name>.py` to `tests` directory.


## Model
Let's say you want to add the simplest model for blog post with only title and
contents. In your project's `models` directory you need to create `blog.py`:
```py
import ormar

from freenit.config import getConfig
from freenit.models.base import BaseModel
from freenit.models.metaclass import AllOptional
from freenit.models.user import User

config = getConfig()


class Blog(BaseModel):
    class Meta(config.meta):
        pass

    id: int = ormar.Integer(primary_key=True)
    title: str = ormar.String(max_length=1024)
    content: str = ormar.Text()
    user: User = ormar.ForeignKey(User)
    


class BlogOptional(Blog, metaclass=AllOptional):
    pass
```

Please note two things: `BaseModel` is Freenit class not Ormar and 
`BlogOptional` is for PATCH method so all it's fields are the same as `Blog`
except they are optional. The reason for this is that Ormar models are not just
for DB operations, but for validating JSON input and parsing objects into JSON.


## Endpoint
In `api` directory of your project add `blog.py` with the following content:
```py
from typing import List

import ormar
from fastapi import Depends, HTTPException
from freenit.decorators import description
from freenit.models.user import User
from freenit.permissions import user_perms
from freenit.router import route

from ..models.blog import Blog, BlogOptional


@route('/blogs', tags=['blog'])
class BlogListAPI():
    @staticmethod
    @description("Get blog list")
    async def get() -> List[Blog]:
        return await Blog.objects.all()

    @staticmethod
    async def post(blog: Blog, user: User = Depends(user_perms)) -> Blog:
        blog.user = user
        await blog.save()
        return blog


@route('/blogs/{id}', tags=['blog'])
class BlogDetailAPI():
    @staticmethod
    async def get(id: int) -> Blog:
        try:
            blog = await Blog.objects.get(pk=id)
        except ormar.exceptions.NoMatch:
            raise HTTPException(status_code=404, detail="No such blog")
        return blog

    @staticmethod
    async def patch(id: int, blog_data: BlogOptional) -> Blog:
        try:
            blog = await Blog.objects.get(pk=id)
            await blog.patch(blog_data)
        except ormar.exceptions.NoMatch:
            raise HTTPException(status_code=404, detail="No such blog")
        return blog

    @staticmethod
    async def delete(id: str) -> Blog:
        try:
            blog = await Blog.objects.get(pk=id)
        except ormar.exceptions.NoMatch:
            raise HTTPException(status_code=404, detail="No such blog")
        await blog.delete()
        return blog

```
What you have now is basic CRUD operations on your blog. Note that `@route` is
Freenit's decorator to make it easy to write class based endpoints. As FastAPI
itself has great support for function based endpoints, the idea was to make
it possible for developer to choose between functions and classes. With Freenit
you can write any style you want. Also note that class methods are static 
(decorated with `@staticmethod`) because API classes will never create an object. 
Or in other words, methods are going to be called on class, not object. Order of
decorators is important and `@staticmethod` has to be the top one. The
`@description` is not mandatory, but highly preferable. If no `@description` is
given, default is to take name of the method and first tag and use it as
description.

Return value type hinting is important. It will tell Freenit what object is
returned from the method and how to convert it to JSON. Alternatively, you can
use `responses` attribute in `@route` like the following:
```py
@route('/blogs', tags=['blog'], responses={'post': Blog})
class BlogListAPI():
    @staticmethod
    async def post(blog: Blog, user: User = Depends(user_perms)):
        blog.user = user
        await blog.save()
        return blog
```
Note that response for POST method is given as attribute to `@route`. Although
method also has return type hinting, if given, responses object has priority in
denoting how to serialize object to JSON. It is the same as FastAPI's 
`response_model` argument and it exists for situations when type hinting is not
expressive enough.

If you need to include and/or exclude fields, you can use `get_pydantic()` and
`exclude/include` to get what you want. For example:
```py
@route('/blogs', tags=['blog'])
class BlogListAPI():
    @staticmethod
    async def post(
        blog: Blog,
        user: User = Depends(user_perms),
    ) -> Blog.get_pydantic(exclude={'id'}):
        blog.user = user
        await blog.save()
        return blog
```
Of course, `Blog.get_pydantic()` can be used in type hinting as well as argument 
to `responses` object in `@route`.


## DB Migration
To connect it all, you need to add the following to `api/__init__.py`:
```py
import myproject.api.blog
```

After that you need to create migration. To do that run the following command
from `myproject` directory:
```
alembic revision --autogenerate -m blog
```
It will create new migration file in `alembic/versions` and format it with 
black. Next time you run `bin/devel.sh` that migration will be applied.

Now you should see Blog endpoint in [Swagger](http://localhost:5000/api/v1)


## Permissions
FastAPI has dependency injection which is a short way of saying that some
arguments to endpoint functions will not come from REST API. You already saw
`user_perm` before, but let's say you want different permissions for an
endpoint.

```py
from freenit.auth import permissions

my_perms = permissions()
```

That creates default permissions, which gives an active user from DB. You can
use it as dependency like so:

```py
@route('/blogs', tags=['blog'])
class BlogListAPI():
    @staticmethod
    async def post(blog: Blog, user: User = Depends(my_perms)) -> Blog:
        blog.user = user
        await blog.save()
        return blog
```

As a matter of fact, that's how default `user_perm` is defined. The `permissions`
function accept two additional arguments to help you with that.

```py
from freenit.auth import permissions

my_perms = permissions(['group 1', 'group 2'], ['group 3', 'group 4'])
```

Both arguments are lists of group names. First one is list of groups in which
user may be, second one is list of groups in which user has to be. In short if
user is assigned to at least one group from first list and all groups in the
second list. Default values for both are `[]`, which means not to check groups
at all. First argument is called `groups`, second one `allof`, in case you need
to set only one of them. In the above example the user can be in either
`group 1` or `group 2` but has to be in both, `group 3` and `group 4`.

## Used Liraries
* [Starlette](https://www.starlette.io/)
* [FastAPI](https://fastapi.tiangolo.com/)
* [Ormar](https://github.com/collerek/ormar)
* [Uvicorn](https://www.uvicorn.org/)
* [Passlib](https://passlib.readthedocs.io/)
* [JWT](https://github.com/jpadilla/pyjwt)

## Source
[Github](https://github.com/freenit-framework/backend)
