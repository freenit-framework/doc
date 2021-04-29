# Backend

## Initialize  the project
```bash
python -m venv ~/.virtualenvs/myproject
source ~/.virtualenvs/myproject/bin/activate
pip install freenit
freenit.sh myproject
cd myproject
bin/devel.sh
```
It will create initial DB migration, apply it and start 
[local development server](http://localhost:5000/api/v1) so you can check if 
everything is OK.
