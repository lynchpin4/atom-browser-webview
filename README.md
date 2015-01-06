# web-browser package

A web browser that runs seamlessly in the Atom editor

![Animated GIF](https://github.com/mark-hahn/web-browser/blob/master/screenshots/browser.gif?raw=true)

This is a web browser tightly integrated into the Atom editor.  The web pages appear in the normal editor tabs.  The pages are fully functional with scripting and linking. A browser toolbar appears at the top of the Atom window to allow simple webpage navigation.

The browser is quite useful for testing a web page inside the same programming editor being used for development.  Splitting panes allow code to be seen next to the web page.

The browser has a simple API for other Atom packages to use.  @kgrossjo on the Atom discussion board suggested a package that allows clicking on a word in source code and showing the web page documention for the word.

### News (2014-11-02)

The package `command-toolbar` now supports buttons to save webpages and open them at any time with a single click.  This means that it can act as a "favorites" toolbar for this `web-browser` package.  It also provides buttons to execute any Atom command and open any text file, just like using the file tree.

## Usage
  
- Install with `apm install atom-browser-webview` (Or you may have to install from git: 
- Press `ctrl-alt-B` (`web-browser:toggle`) and a toolbar will appear above the tabs
- Enter a url and press enter
- To later create a new tab use ctrl-enter instead
- Press `ctrl-alt-B` again to refocus input
- Press `ctrl-alt-B` again to close toolbar
- Click on globe in toolbar to close the toolbar (secret feature)


## License

Copyright Mark Hahn / gstack by MIT license
