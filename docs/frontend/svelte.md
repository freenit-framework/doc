# Svelte

If you already exported the design and want to integrate backend, you have to
create store for it. Svelte has store and fetch built in, so simplest store for
blog CRUD would be:

```js
import { writable } from 'svelte/store'

class BlogListStore {
  constructor() {
    const { set, update } = writable([])
    this.set = set
    this.update = update
  }

  async getList() {
    try {
      const response = await fetch('/api/v1/blogs')
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

  async create(blogData) {
    try {
      const response = await fetch(
        '/api/v1/blogs', 
        {method: 'POST', body: blogData},
      )
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
}

class BlogDetailStore {
  constructor() {
    const { set, update } = writable({})
    this.set = set
    this.update = update
  }

  async get(id: Number) {
    try {
      const response = await fetch(`/api/v1/blogs/${id}`)
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
      const response = await fetch(
        `/api/v1/blogs/${id}`,
        {method: 'PATCH', body: blogData},
      )
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
      const response = await fetch(
        `/api/v1/blogs/${id}`,
        {method: 'DELETE'},
      )
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

const blog = {
  detail: new BlogDetailStore(),
  list: new BlogListStore(),
}

export default blog
```
