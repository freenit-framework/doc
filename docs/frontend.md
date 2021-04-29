# Frontend

## Install package
```bash
yarn add @freenit-framework/axios
```

## Initialize API object
For example in `api.js`
```js
import React from 'react'
import { API } from '@freenit-framework/axios'

export const api = new API()
```

## Use it in a component
```js
import React from 'react'
import { api } from 'api'

class App extends React.Component {
  state = {
    users: {
      data: [],
      total: 0,
      page: 0,
    }
  }

  constructor(props) {
    super(props)
    this.fetch()
  }

  fetch = async () => {
    const response = await api.user.getList()
    if (response.ok) {
      this.setState({ users: response.data })
    } else {
      console.log('error in App', api.errors(response).message)
    }
  }

  render() {
    return <div>App</div>
  }
}
```

## Config
API accepts two parameters: `prefix` and `config`. Prefix is what axios calls
`baseURL` and by default is `/api/v0`. If you want to further customize axios
you can pass `config` object like so 
`const api = new API('/api/v1', { withCredentials: false })`. All axios config
params are supported.

API also has 3 objects, one for `auth`, `me` and `user`. That means you can
call
```js
await api.auth.login('admin@example.com', 'Sekrit')
await api.user.patch(<id>, { email: 'something@example.com' })
```
to login and change email to user with ID `<id>`.

## API Reference
This is the full list of supported calls:
#### auth

  * login
  * logout

#### me

  * get
  * patch

#### user

  * get
  * getList
  * patch
  * post
  * delete

If you need to implement call to new endpoint
```js
const doit = async () => {
  return await api.get('/some/endpoint')
}
```
What it returns is either data that came with the response or the error object.
If you need access to underlaying axios object use `api.api` instead of `api`.
