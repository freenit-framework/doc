# Store

## Custom Store
Svelte has state and fetch built into it, so simplest store for blog CRUD would
be to make it like this:

```ts
import { methods, store } from '.'

export default class BlogStore {
  list = $state({})
  detail = $state({ page: 0, perpage: 0, data: [], total: 0 })

  constructor(prefix) {
    this.prefix = prefix
  }
}

```
This just declares `BlogStore` as a store, with initial values for
`list` and `detail` state. To get the list of blog posts from the
REST API, add `fetchAll` function inside `BlogStore`. To make things
easier, Freenit comes with helper `methods`. Because arrow functions
handle `this` better, it is wise to use them.

```ts
fetchAll = async (page: Number = 1, perpage: Number = 10) => {
  await store.auth.refresh_token()
  const response = await methods.get(`${this.prefix}/blogs`, { page, perpage })
  if (response.ok) {
    const data = await response.json()
    this.list = data
    return { ...data, ok: true }
  }
  return response
}

```
The `refresh_token` function is written so that if there is no token or the currently
held token has expired it will call REST API to refresh it, otherwise it will do nothing.
After fetching list of blogs, `fetchAll` will set the store and return the data to the
caller. By default we also tell backend to return first 10 blog posts by setting headers
`page` and `perpage` in `methods.get` call.

To create the blog post, you need to add `create` function which calls
`POST` on the REST API.

```ts
create = async (fields: Record<string, any>) => {
  await store.auth.refresh_token()
  const response = await methods.post(`${this.prefix}/blogs`, fields)
  if (response.ok) {
    const data = await response.json()
    this.list = data
    return { ...data, ok: true }
  }
  return response
}
```

It is similar with the blog detail and it's API calls. Here are the methods
blog detail.
```ts
fetch = async (id: Number) => {
  await store.auth.refresh_token()
  const response = await methods.get(`${this.prefix}/blogs/${id}`)
  if (response.ok) {
    const data = await response.json()
    this.detail = data
    return { ...data, ok: true }
  }
  return response
}

edit = async (id: Number, fields: Record<string, any>) => {
  await store.auth.refresh_token()
  const response = await methods.patch(`${this.prefix}/blogs/${id}`, fields)
  if (response.ok) {
    const data = await response.json()
    this.detail = data
    return { ...data, ok: true }
  }
  return response
}

destroy = async (id: Number) => {
  await store.auth.refresh_token()
  const response = await methods.delete(`${this.prefix}/blogs/${id}`)
  if (response.ok) {
    const data = await response.json()
    return { ...data, ok: true }
  }
  return response
}
```

You can use `blog.detail` and `blog.list` in `.svelte` files like any other
store. What will make it more flexible is to add blog store to the global Freenit
store. To do that, have the following snippet of code added somewhere in your initialization

```ts
import { store } from '@freenit-framework/core'
import BlogStore from './blog'

store.blog = new BlogStore(store.auth.prefix)
```

So now in your `.svelte` component you would refer to it through global store.
```ts
import { store } from '@freenit-framework/core'

console.log(store.blog.list.total)
```

## Built-in Stores

Freenit offers some ready made stores to make development easier. They are all part of
a global store, so let's see what's included.

### Auth

Store to handle authentication. It has following methods:

* `login(email, password)` - login with email and password
* `logout()` - logout currently logged in user
* `register(email, password)` - register new user and make it inactive
* `verify(verification_token)` - on register, mail will be sent with verification token/URL
* `refresh_token()` - refresh access token

### Role

Store to handle roles. It has following methods:

* `fetchAll(page, perpage)` - fetch `perpage` roles at a time
* `create(fields)` - create role from `fields` (JS object with role data)
* `fetch(id)` - fetch single role
* `edit(id)` - edit role
* `destroy(id)` - destroy role
* `assign(role_id, user_id)` - add user to role
* `deassign(role_id, user_id)` - remove user from role

### User

Store to handle roles. It has following methods:

* `fetchAll(page, perpage)` - fetch `perpage` users at a time
* `create(fields)` - create user from `fields` (JS object with user data)
* `fetch(id)` - fetch single user
* `edit(id)` - edit user
* `destroy(id)` - destroy user

### Theme

Store to handle themes. It has following methods:

* `fetchAll(page, perpage)` - fetch `perpage` themes at a time
* `create(fields)` - create theme from `fields` (JS object with theme data)
* `fetch(id)` - fetch single theme
* `edit(id)` - edit theme
* `destroy(id)` - destroy theme
* `active()` - fetch currently active theme
