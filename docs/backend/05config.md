# Configuration

## Base Configuration

The base of configuration is given below.

```py
second = 1
minute = 60 * second
hour = 60 * minute
day = 24 * hour
year = 365 * day


class Auth:
    def __init__(self, secure=True, expire=hour, refresh_expire=year):
        self.secure = secure
        self.expire = expire
        self.refresh_expire = refresh_expire


class BaseConfig:
    name = "Freenit"
    version = "0.0.1"
    api_root = "/api/v1"
    hostname = socket.gethostname()
    port = 5000
    debug = False
    metadata = sqlalchemy.MetaData()
    dburl = "sqlite:///db.sqlite"
    database = None
    engine = None
    secret = "SECRET"  # nosec
    user = "freenit.models.sql.user"
    role = "freenit.models.sql.role"
    theme = "freenit.models.sql.theme"
    theme_name = "Freenit"
    meta = None
    auth = Auth()
```

As you see, it's mostly about setting DB and proper user/role/theme models. On top of that, there
is a class for configuring mail server for sending.

```py
class Mail:
    def __init__(
        self,
        server="mail.example.com",
        user="user@example.com",
        password="Sekrit",  # nosec
        port=587,
        tls=True,
        from_addr="no-reply@mail.com",
        register_subject="[Freenit] User Registration",
        register_message=register_message,
        master_user="dovecot@example.com",
        master_pw="Sekrit",
    ) -> None:
        self.server = server
        self.user = user
        self.password = password
        self.port = port
        self.tls = tls
        self.from_addr = from_addr
        self.register_subject = register_subject
        self.register_message = register_message
        self.master_user = master_user
        self.master_pw = master_pw

```

## Project Configuration

To actually create config for development, testing and production, declare the following classes.

```py
class DevConfig(BaseConfig):
    debug = True
    dburl = "sqlite:///db.sqlite"
    auth = Auth(secure=False)


class TestConfig(BaseConfig):
    debug = True
    dburl = "sqlite:///test.sqlite"
    auth = Auth(secure=False)


class ProdConfig(BaseConfig):
    secret = "MORESECURESECRET"  # nosec
    mail = Mail()
```

Freenit will try to include every one of them, and if it fails, it will use default config class
instead. That's how it looks in Freenit itself, but in your project you should organize a bit
differently. In `myproject/myproject/base_config.py` define 3 classes.

```py
from freenit.base_config import Auth, Mail, BaseConfig as FreenitBaseConfig


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
    secret = "MORESECURESECRET"  # nosec
    mail = Mail()
```

Then in `myproject/myproject/config.py` you have the following.

```py
import os

from freenit.config import configs

try:
    from .local_config import DevConfig
except ImportError:
    from .base_config import DevConfig

try:
    from .local_config import TestConfig
except ImportError:
    from .base_config import TestConfig

try:
    from .local_config import ProdConfig
except ImportError:
    from .base_config import ProdConfig


configs[DevConfig.envname()] = DevConfig()
configs[TestConfig.envname()] = TestConfig()
configs[ProdConfig.envname()] = ProdConfig()


def getConfig():
    config_name = os.getenv("FREENIT_ENV", "prod")
    return configs.get(config_name, configs["prod"])
```

That way if you create `myproject/myproject/local_config.py`, you can override any of the config
items. The idea behind `local_config.py` is to be able to override settings in production so the
sensitive data is not distributed with the repository of the project. Also, if you need extra
settings, you can add them in your base config to share with other configs, or just to the
production config. For example, you might need Redis or some other external service to be
configured. The following code shows you how to change `secret` in production.

```py
from .base_config ProdConfig as BaseProdConfig

class ProdConfig(BaseProdConfig):
    secret = "WAYMORESECURESECRET"
```

!!! note 
    Once in production, your code has to initialize the database, so don't forget to run
    `bin/init.sh`.

Once first user is registered, you probably want to promote them to admin. To do that, run
`bin/shell.sh`.

```python
# bin/shell.sh

from bsidesrs.config import getConfig

config = getConfig()
await config.database.connect()
user = await User.objects.get(pk=1)
await config.database.connect()
```

Every script in `bin` directory is aware of these environment variables

* `FREENIT_ENV` - configuration to use like `prod`, `dev` or `test`
* `SYSPKG` - don't use virtualenv and use system provided packages
* `OFFLINE` - use virtualenv, but don't install or upgrade anything

For example, you can run this to get shell in production using only system provided packages

```
env SYSPKG=YES FREENIT_ENV=prod bin/shell.sh
```
