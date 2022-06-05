# Svelte

```js
import { writable } from 'svelte/store'

class BlogStore {
  constructor() {
    const { set, update } = writable()
    this.set = set
    this.update = update
  }

  async getAll() {
    try {
      const response = await fetch(...)
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
}
```
