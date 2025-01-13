# Store

If you already exported the design and want to integrate backend, you have to
create store for it. Svelte has store and fetch built in, so simplest store for
blog CRUD would be to make custom store:

```ts
import { methods, store } from '.'

export default class BlogStore {
  list = $state({})
  detail = $state({})

  constructor(prefix) {
    this.prefix = prefix
  }
}

```
This just declares `BlogStore` as custom store, with initial value of empty
array. To get the list from the REST API, add `fetchAll` function inside
`BlogStore`. To make things easier, Freenit comes with helper `methods`.
Because arrow functions handle `this` better, it is wise to use them.

```ts
fetchAll = async () => {
  await store.auth.refresh_token()
  const response = await methods.get(`${this.prefix}/blogs`)
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
After fetching list of blogs `fetchAll` will set the store and return the data to the
caller. To create the blog post, you need to add `create` function which calls
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

So now in your code you would refer to it through global store.
```ts
import { store } from '@freenit-framework/core'

console.log(store.blog.detail.id)
```
