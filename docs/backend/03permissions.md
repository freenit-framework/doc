# Permissions

FastAPI has dependency injection which is a short way of saying that some
arguments to endpoint functions will not come from REST API. You already saw
`user_perm` before, but let's say you want different permissions for an
endpoint.

```py
from freenit.auth import permissions

my_perms = permissions()
```

That creates default permissions, which permits access only to the active user
(the one sending the request). You can use it as dependency like so:

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
function accept two additional arguments to help you express more complex
permissions.

```py
from freenit.auth import permissions

my_perms = permissions(['role 1', 'role 2'], ['role 3', 'role 4'])
```

Both arguments are lists of role names. First one is list of roles in which
user may be, second one is list of roles in which user has to be. In short if
user is assigned to at least one role from the first list and all roles in the
second list, access is granted. Default values for both are `[]`, which means
not to check roles at all. First argument is called `roles`, second one `allof`,
in case you need to set only one of them use named arguments. In the above
example the user can be in either `role 1` or `role 2` but has to be in both,
`role 3` and `role 4`.
