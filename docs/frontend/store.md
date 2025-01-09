# Store

If you already exported the design and want to integrate backend, you have to
create store for it. Svelte has store and fetch built in, so simplest store for
blog CRUD would be to make custom store:

```ts
import { writable } from 'svelte/store'
import { methods } from '@freenit-framework/svelte-base'

class BlogListStore {
  constructor() {
    const { set, subscribe, update } = writable([])
    this.set = set
    this.subscribe = subscribe
    this.update = update
  }
}
```
This just declares `BlogListStore` as custom store, with initial value of empty
array. To get the list from the REST API, add `get` function inside
`BlogListStore`. To make things easier, Freenit comes with helper `methods`.

```ts

async get() {
  try {
    const response = await methods.get('/api/v1/blogs')
    const data = await.response.json()
    this.set(data)
    return {
      ...data,
      ok: true,
    }
  } catch(error) {
    return {
      ...error,
      ok: false
    }
  }
}
```
After fetching list of blogs `get` will set the store and return the data to the
caller. To create the blog post, you need to add `create` function which calls
`POST` on the REST API.

```ts
async create(blogData: Record<string, any>) {
  try {
    const response = await methods.post('/api/v1/blogs', blogData)
    const data = await.response.json()
    this.update((store) => [...store, data])
    return {
      ...data,
      ok: true,
    }
  } catch(error) {
    return {
      ...error,
      ok: false
    }
  }
}
```

It is similar with the blog detail and it's API calls. Here is the whole store
for that.
```ts
class BlogDetailStore {
  constructor() {
    const { set, subscribe, update } = writable({})
    this.set = set
    this.subscribe = subscribe
    this.update = update
  }

  async get(id: Number) {
    try {
      const response = await methods.get(`/api/v1/blogs/${id}`)
      const data = await.response.json()
      this.set(data)
      return {
        ...data,
        ok: true,
      }
    } catch(error) {
      return {
        ...error,
        ok: false
      }
    }
  }

  async edit(id: Number, blogData: Record<string, any>) {
    try {
      const response = await methods.patch(`/api/v1/blogs/${id}`, blogData)
      const data = await.response.json()
      this.set(data)
      return {
        ...data,
        ok: true,
      }
    } catch(error) {
      return {
        ...error,
        ok: false
      }
    }
  }

  async delete(id: Number) {
    try {
      const response = await methods.delete(`/api/v1/blogs/${id}`)
      const data = await.response.json()
      return {
        ...data,
        ok: true,
      }
    } catch(error) {
      return {
        ...error,
        ok: false
      }
    }
  }
}
```

To tie everything together, we export objects of type `BlogDetailStore` and
`BlogListStore` from our module.
```ts
const blog = {
  detail: new BlogDetailStore(),
  list: new BlogListStore(),
}

export default blog
```

You can use `blog.$detail` and `blog.$list` in `.svelte` files like any other
store.

```ts
import { blog } from '$lib/store'

$: console.log(blog.$detail.id)
```

What will make it more flexible is to add blog store to the global Freenit
store. Assuming the `BlogListStore` and `BlogDetailStore` are in
`src/lib/store/blog.ts`, you can create `src/lib/store/index.ts` and do the
following.

```ts
import { store } from '@freenit-framework/svelte-base'
import blog from './blog'

store().blog = blog
```

So now in your code you would refer to it through global store.
```ts
import { store } from '@freenit-framework/svelte-base'

$: console.log(store().blog.$detail.id)
```
