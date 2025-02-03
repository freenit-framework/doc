# Snippets

Snippets are templates for portions of code. For example, you will probably make
DB models in the same way with only table/class name that is different. Freenit
offers [repository with snippets](https://github.com/freenit-framework/snippets)
for Python, Svelte and Typescript. After successful installation of snippets, typing
`freenit` will give you a menu with all snippets for that file type.

## VSCode

`File -> Preferences -> Configure User Snippets -> New Global Snippets file`
In the window that opens, copy the contents of python.json, svelte.json and
typescript.json from the repository.

## LunarVim

You will need [jsregexp](https://github.com/kmarius/jsregexp) compiled and
placed in the right directory. To find out the path of that directory, type
`:lua print(package.cpath)`. The snippets should be cloned into
`~/.config/lvim`.

## NvChad

Specify where to look for snippets by adding the following line to
~/.config/nvim/lua:
```
vim.g.vscode_snippets_path = "~/repos/snippets"
```

Now clone snippets repository into `~/repos/snippets`, and that should be it.
