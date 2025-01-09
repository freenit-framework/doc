# Model

Let's say you want to add the simplest model for blog post with only title and
contents. In your project's `models` directory you need to create `blog.py`:
```py
import ormar

from freenit.models.sql.base import OrmarBaseModel, make_optional, ormar_config
from freenit.models.user import User


class Blog(OrmarBaseModel):
    ormar_config = ormar_config.copy()

    id: int = ormar.Integer(primary_key=True)
    title: str = ormar.String(max_length=1024)
    content: str = ormar.Text()
    user: User = ormar.ForeignKey(User)
    


class BlogOptional
    pass


make_optional(BlogOptional)
```

Please note two things: `BaseModel` is Freenit class not Ormar and 
`BlogOptional` is for PATCH method so all its fields are the same as `Blog`
except they are optional. The reason for this is that Ormar models are not just
for DB operations, but for validating JSON input and parsing objects into JSON.
