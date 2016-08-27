
module.exports = {

  config: {
    // default font size in pixels for all tabs
    fontSize: 12,

    // font family with optional fallbacks
    fontFamily: 'SauceCodePowerline-Regular,Menlo, "DejaVu Sans Mono", "Lucida Console", monospace',

    // terminal cursor background color and opacity (hex, rgb, hsl, hsv, hwb or cmyk)
    cursorColor: 'rgba(248,28,229,0.75)',

    // `BEAM` for |, `UNDERLINE` for _, `BLOCK` for █
    cursorShape: 'BLOCK',

    // color of the text
    foregroundColor: '#fafafa',

    // terminal background color
    backgroundColor: '#212121',

    // border color (window, tabs)
    borderColor: '#333',

    // custom css to embed in the main window
    css: '',

    // custom css to embed in the terminal window
    termCSS: '',

    // custom padding (css format, i.e.: `top right bottom left`)
    padding: '0px',

    // the full list. if you're going to provide the full color palette,
    // including the 6 x 6 color cubes and the grayscale map, just provide
    // an array here instead of a color map object
	// default:https://github.com/zeit/hyperterm/pull/193/commits/970eac21cc6ac9f93083c3b9d3f8ac7edbb6fe2a#diff-1dfee92b62e747055fc44e019d136750R30
    colors: {
      black: '#21212',
      red: '#f44336',
      green: '#4CAF50',
      yellow: '#FFEB3B',
      blue: '#2196F3',
      magenta: '#E91E63',
      cyan: '#00BCD4',
      white: '#F5F5F5',
      lightBlack: '#9E9E9E',
      lightRed: '#f44336',
      lightGreen: '#8BC34A',
      lightYellow: '#FFC107',
      lightBlue: '#03A9F4',
      lightMagenta: '#F06292',
      lightCyan: '#4DD0E1',
      lightWhite: '#ffffff'
    },

    // the shell to run when spawning a new session (i.e. /usr/local/bin/fish)
    // if left empty, your system's login shell will be used by default
    shell: '',

    // for advanced config flags please refer to https://hyperterm.org/#cfg
   overlay: {
      hotkeys: ['Control+Space'],
	  size:0.6
   },
  },

  // a list of plugins to fetch and install from npm
  // format: [@org/]project[#version]
  // examples:
  //   `hyperpower`
  //   `@company/project`
  //   `project#1.0.1`

  plugins: [
    "hyperterm-overlay",
    "hyperlinks",
    "hyperterm-cursor",
    "hyperterm-tab-icons"
  ],
  // in development, you can create a directory under
  // `~/.hyperterm_plugins/local/` and include it here
  // to load it and avoid it being `npm install`ed
  localPlugins: []


};




