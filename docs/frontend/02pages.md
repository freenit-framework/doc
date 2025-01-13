# Pages

Freenit comes with some of the most common pages implemented in the core library.

## Login

The minimal code to add login page to your site

```ts
<script lang="ts">
  import { Login } from '@freenit-framework/core'
</script>

<Login />
```

## Register

The minimal code to add user registration page to your site

```ts
<script lang="ts">
  import { Register } from '@freenit-framework/core'
</script>

<Register />
```

## Role

The page to add to the dashboard to have `Role` management, like adding and
removing users from the role. It is assumed that page is in `[id]/+page.svelte`
file, hence the parameter `id` in the code.

```ts
<script lang="ts">
  import { Role } from '@freenit-framework/core'
  import { page } from '$app/stores'
</script>

<Role pk={$page.params.id} />
```

## Roles

The dashboard page for management of `Roles`.

```ts
<script lang="ts">
  import { Roles } from '@freenit-framework/core'
</script>

<Roles />
```

## Theme

The page to add to the dashboard to have `Theme` management. It is assumed
that page is in `[name]/+page.svelte` file, hence the parameter `name` in the code.

```ts
<script lang="ts">
  import { Theme } from '@freenit-framework/core'
  import { page } from '$app/stores'
</script>

<Theme name={$page.params.name} />
```

## Themes

The dashboard page for management of `Themes`.

```ts
<script lang="ts">
  import { Themes } from '@freenit-framework/core'
</script>

<Themes />
```

## User

The page to add to the dashboard to have `User` management. It is assumed that
page is in `[id]/+page.svelte` file, hence the parameter `id` in the code.

```ts
<script lang="ts">
  import { User } from '@freenit-framework/core'
  import { page } from '$app/stores'
</script>

<User pk={$page.params.id} />
```

## Users

The dashboard page for management of `Roles`.

```ts
<script lang="ts">
  import { Users } from '@freenit-framework/core'
</script>

<Users />
```
