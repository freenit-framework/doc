# Authorization

## Default and Custom Model
The default Freenit User is defined as this:
```py
import ormar

from freenit.auth import verify
from freenit.config import getConfig
from freenit.models.metaclass import AllOptional
from freenit.models.ormar.base import OrmarBaseModel, OrmarUserMixin
from freenit.models.role import Role

config = getConfig()


class User(OrmarBaseModel, OrmarUserMixin):
    class Meta(config.meta):
        tablename = "users"

    roles = ormar.ManyToMany(Role)

    def check(self, password: str) -> bool:
        return verify(password, self.password)


class UserOptional(User, metaclass=AllOptional):
    pass
```

If you need a custom User model, you can copy/paste that code and add any field
to User class you need. For example, let's say the project is name `myproject`
and custom User class is needed. In that case file `myproject/models/user.py`
should look like this:

```py
class User(OrmarBaseModel, OrmarUserMixin):
    class Meta(config.meta):
        tablename = "users"

    roles = ormar.ManyToMany(Role, unique=True)
    nickname = ormar.Text()

    def check(self, password: str) -> bool:
        return verify(password, self.password)
```

## Confguration

To use the new User class you need to change `myproject/base_config.py`. By
default it looks like this:

```py
from freenit.base_config import Auth
from freenit.base_config import BaseConfig as FreenitBaseConfig


class BaseConfig(FreenitBaseConfig):
    name = "NAME"
    version = "0.0.1"


class DevConfig(BaseConfig):
    debug = True
    auth = Auth(False)
    dburl = "sqlite:///db.sqlite"


class TestConfig(BaseConfig):
    debug = True
    auth = Auth(False)
    dburl = "sqlite:///test.sqlite"


class ProdConfig(BaseConfig):
    secret = "MORESECURESECRET"
```

To make Freenit use custom User class only one line is needed:
```py
class BaseConfig(FreenitBaseConfig):
    name = "NAME"
    version = "0.0.1"
    user = 'myproject.models.user'
```

Freenit will make it so that you always import `freenit.models.user` but it will
know which module to actually use under the hood.

To customize Role, same principle applies: create model using base models and
register it in configuration.

!!! note 
    Always import from `freenit.models.user` and `freenit.models.role`, even
    when using custom classes as Freenit knows how to serve you the right
    user/role.

Nice thing is that just swapping the User and/or Role class allows you to use
Freenit's default API for auth, user, profile and roles. Of course, you can
replace them, too, but if you only need extra few fields on your class, API
overwrite is not needed.
