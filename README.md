# Data Visualization in Haskell

Haskell’s [Diagrams](https://diagrams.github.io/doc/manual.html) package lets you create vector images with Haskell code and compile them on the command line.

While I’m quite comfortable with [Ti𝑘Z](https://github.com/gjoncas/Diagrammatic), it leaves a lot to be desired — 
code is limited to for-loops, the only data structure is lists or makeshift tuples, and it’s a nightmare to upload data.
Moreover, generalizing the code makes it into an unreadable monstrosity.

Conversely, Haskell is far more modular, and uses a declarative style whose intuitions are based on vectors rather than a Cartesian grid.
Most interesting of all is the idea of integrating it with other applications, such as [Euterpea](http://euterpea.com) for music, or mathematical modelling.

This repo will mainly replicate nice data visualizations made with other software.<br>
My main goal is to learn to make detailed diagrams [like these](https://diagrams.github.io/gallery.html), but calibrated to real data.

## Updates

![pie chart](/pics/piechart-small.png)
<br><b>Hollow pie chart – customizable colors, percentages, labels, and center text</b>
<br>2020.07.11: Finished.

![multi-pie chart](/pics/multi-pie.png)
<br><b>Multiple partial pie charts – customizable colors, percentages, labels, and center text</b>
<br>2020.07.17: Finished.  [e.g. percentage of days that you do a specific task]

![waffle chart](/pics/waffle.png)
<br><b>Waffle chart – customizable colors, percentages, labels, and shapes</b>
<br>2020.09.21: Finished.  [nice when percentages are integers]

![coxcomb chart](/pics/nightingale.png)
<br><b>Nightingale chart – customizable colors, percentages, and labels</b>
<br>2020.11.18: Finished. [e.g. <a href="https://www.maharam.com/stories/sherlock_florence-nightingales-rose-diagram">mortality rates</a> from various causes]
