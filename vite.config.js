const { resolve } = require('path')

module.exports = {
  root: resolve(__dirname, './src'),
  build: {
    rollupOptions: {
      input: {
        main: resolve(__dirname, 'src/index.html'),
        privacy: resolve(__dirname, 'src/privacy-policy.html'),
        terms: resolve(__dirname, 'src/terms-and-conditions.html'),
        thank: resolve(__dirname, 'src/thank-you.html')
      },
      output: {
        dir: resolve(__dirname, './dist'),
        format: 'es'
      }
    },
    outDir: resolve(__dirname, './dist')
  }
}
