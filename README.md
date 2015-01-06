# web-browser package

A web browser that runs seamlessly in the Atom editor

## Info

This is a web browser tightly integrated into the Atom editor.  The web pages appear in the normal editor tabs.  The pages are fully functional with scripting and linking. A browser toolbar appears at the top of the Atom window to allow simple webpage navigation.

The browser is quite useful for testing a web page inside the same programming editor being used for development.  Splitting panes allow code to be seen next to the web page.

The browser has a simple API for other Atom packages to use.  @kgrossjo on the Atom discussion board suggested a package that allows clicking on a word in source code and showing the web page documention for the word.

### News (2015-06-01)

Finally a working tabbed browser that's using webviews. The easiest way to get going is to toggle the UI in Packages -> Browser, or make atom.workspace.open('http://google.com/'); calls after launching.

This extension is designed to support multiple active tabs using visibility: css to work-around the deallocating webviews with display: none;

## Usage
  
- Install with `apm install atom-browser-webview`
- Press `ctrl-alt-B` (`web-browser:toggle`) and a toolbar will appear above the tabs
- Enter a url and press enter
- To later create a new tab use ctrl-enter instead
- Press `ctrl-alt-B` again to refocus input
- Press `ctrl-alt-B` again to close toolbar
- Click on globe in toolbar to close the toolbar (secret feature)

## Gif

![GIF](https://github.com/mark-hahn/web-browser/blob/master/screenshots/browser.gif?raw=true)

## License

Copyright Gstack / Mark Han by MIT license
