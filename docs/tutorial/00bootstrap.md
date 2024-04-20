# Bootstrap the Project

The first thing to do is create the project itself. First, make sure you have
`tmux` installed, as Freenit uses it to run different services (backend and
frontend, currently, but you can add more later).

```sh
$ freenit
Ok to proceed? (y) y
Which Svelte app template?
  SvelteKit demo app
Add type checking with TypeScript?
  Yes, using TypeScript syntax
Select additional options (use arrow keys/space bar)
  Add ESLint for code linting
  Add Prettier for code formatting
  Add Vitest for unit testing
```

This will create the directory `myproject` and initialize it. Let's start the
project.

```sh
$ cd myproject
$ bin/devel.sh
```

At this point you'll be presented with a split screen: one for backend, one for
frontend. At that screen, you'll see URLs for both services. The interesting
one is `http://localhost:5173`. If you visit it, it will greet you with a
message `Landing Page in src/routes/+page.svelte`. That is usually the first
page you will change.
