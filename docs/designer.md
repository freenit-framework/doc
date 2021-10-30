# Designer

[The Designer](https://designer.freenit.org/) is intended to make transition
from idea to implementation easier. You can drag components from the left pane
to the preview in the middle or the component tree on the right pane to add
them to the DOM tree. `Save` button will save current design in .json format so
you can load it with `Load` button later. Export will generate .js file with
code corresponding to that design.

To see designer in action please watch
[Designer Intro](https://www.youtube.com/watch?v=l1CD-84fs8k&list=PLpeJ1COhO5ak9X3UE85mlFZrrIxiPynKy)
and [Practical Designer](https://www.youtube.com/watch?v=5aapP8A0CHI&list=PLpeJ1COhO5ak9X3UE85mlFZrrIxiPynKy&index=2)

There are 3 tabs that show current design and two modes for editing. Available
tabs:

* Design (where you'll DnD, edits and rearanging)
* Load/Save (where you can save your work and load it some other day to
  continue your work on design)
* Export (converts design to React code)

Modes are:

* Add - If you drag component A to component B, A will become B's child
* Rearange - If you drag component A to component B, B has parent C, A will
  become C's child and placed right before B

To enter `rearange` mode, press `Shift` key (on Firefox) or click on a `reload`
icon (any browser). To exit that mode and switch back to `add`, release `Shift`
or click on reload icon again.

## Source
[Github](https://github.com/freenit-framework/designer)
