# Security

## User Password

If you use `User` class for serialization, you'll notice that the password is returned in it's
encrypted form. To exclude password from JSON you have to use `UserSafe`. To do that, in file
`blog.py` under `models` let's add this to the end

```py hl_lines="5 25 26"
import ormar

from freenit.models.sql.base import OrmarBaseModel, make_optional, ormar_config
from freenit.models.user import User
from freenit.models.safe import UserSafe


class Blog(OrmarBaseModel):
    ormar_config = ormar_config.copy()

    id: int = ormar.Integer(primary_key=True)
    title: str = ormar.String(max_length=1024)
    content: str = ormar.Text()
    user: User = ormar.ForeignKey(User)
    


class BlogOptional
    pass


make_optional(BlogOptional)


class BlogSafe(Blog.get_pydantic(exclude={"user__password"})):
    pass
```

Now in `blog.py` under `api`, let's use the newly created `BlogSafe`.

```py hl_lines="6 17 21 29 37 46"
import ormar.exceptions
from fastapi import Header, HTTPException
from freenit.api.router import route
from freenit.models.pagination import Page, paginate

from ..models.blog import Blog, BlogOptional, BlogSafe

tags = ["blog"]


@route("/blogs", tags=tags)
class BlogListAPI:
    @staticmethod
    async def get(
        page: int = Header(default=1),
        perpage: int = Header(default=10),
    ) -> Page[BlogSafe]:
        return await paginate(Blog.objects, page, perpage)

    @staticmethod
    async def post(blog: Blog) -> BlogSafe:
        await blog.save()
        return blog


@route("/blogs/{id}", tags=tags)
class BlogDetailAPI:
    @staticmethod
    async def get(id: int) -> BlogSafe:
        try:
            blog = await Blog.objects.get(pk=id)
        except ormar.exceptions.NoMatch:
            raise HTTPException(status_code=404, detail="No such blog")
        return blog

    @staticmethod
    async def patch(id: int, blog_data: BlogOptional) -> BlogSafe:
        try:
            blog = await Blog.objects.get(pk=id)
            await blog.patch(blog_data)
        except ormar.exceptions.NoMatch:
            raise HTTPException(status_code=404, detail="No such blog")
        return blog

    @staticmethod
    async def delete(id: int) -> BlogSafe:
        try:
            blog = await Blog.objects.get(pk=id)
        except ormar.exceptions.NoMatch:
            raise HTTPException(status_code=404, detail="No such blog")
        await blog.delete()
        return blog
```

Now nested `user` object will just omit the password. You can do it with any class that has
reference to `User` and in fact, there's `RoleSafe` in the same module where `UserSafe` is.
