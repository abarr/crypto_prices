module.exports = {
    mode: "jit",
    purge: ["./js/**/*.js", "../lib/*_web/**/*.*ex"],
    theme: {
      extend: {
        keyframes: {
          highlightInc: {
            '0%': {
              background: '#9fdf9f',
            },
            '100%': {
              background: 'none',
            },
          },
          highlightDec: {
            '0%': {
              background: '#ff9999',
            },
            '100%': {
              background: 'none',
            },
          }

        },
        animation: {
          highlightDec: 'highlightDec 1s',
          highlightInc: 'highlightInc 1s'
        }
      },
    },
    variants: {
      extend: {},
    },
    plugins: [],
  };