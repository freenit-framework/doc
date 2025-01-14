# Endpoints

## CRUD
In `api` directory of your project add `blog.py` with the following content:
```py
import ormar.exceptions
from fastapi import Header, HTTPException
from freenit.api.router import route
from freenit.models.pagination import Page, paginate

from ..models.blog import Blog, BlogOptional

tags = ["blog"]


@route("/blogs", tags=tags)
class BlogListAPI:
    @staticmethod
    async def get(
        page: int = Header(default=1),
        perpage: int = Header(default=10),
    ) -> Page[Blog]:
        return await paginate(Blog.objects, page, perpage)

    @staticmethod
    async def post(blog: Blog) -> Blog:
        await blog.save()
        return blog


@route("/blogs/{id}", tags=tags)
class BlogDetailAPI:
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
    async def delete(id: int) -> Blog:
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
given, default is to concatenate name of the method and first tag and use them
as description.

By default endpoint to get list of blog posts is paginated. That means that it 
will return first page with first 10 results by default. Through `page` and
`perpage` frontend can require other pages and the page size.

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
Note that response for POST method is given as attribute to `@route`. If method
also has return type hinting, responses object has priority in denoting how to
serialize object to JSON. It is the same as FastAPI's `response_model` argument
and it exists for situations when type hinting is not expressive enough.

If you need to include and/or exclude fields, you can use `get_pydantic()` and
`exclude/include` to get what you want. For example:
```py
BlogReturn = Blog.get_pydantic(exclude={'id'}):
@route('/blogs', tags=['blog'])
class BlogListAPI():
    @staticmethod
    async def post(blog: Blog, user: User = Depends(user_perms)) -> BlogReturn:
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
