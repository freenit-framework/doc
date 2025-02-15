# Snippets

Snippets are templates for portions of code. For example, you will probably make
DB models in the same way with only table/class name that is different. Freenit
offers [repository with snippets](https://github.com/freenit-framework/snippets)
for Python, Svelte and Typescript. After successful installation of snippets, typing
`freenit` will give you a menu with all snippets for that file type.

## VSCode

Press `CTRL + P`, enter `ext install svelte.svelte-vscode` and press `Enter` to
install Svelte extension. After that press `Shift + CTRL + P` and then enter `snip`.
One of the choices in the drop-down menu will be `Snippets: Configure snippets`. When
you click on it or press `Enter`, you'll be presented with another drop-down menu,
this time it will contain list of languages. Select one by one languages: python,
svelte, typescript and copy/paste content of `<language>.json` file.

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
