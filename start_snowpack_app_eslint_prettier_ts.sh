#! /bin/bash

npx create-snowpack-app $APPNAME --template @snowpack/app-template-react-typescript --use-yarn && \
cd $APPNAME && \
yarn add -D @typescript-eslint/parser @typescript-eslint/eslint-plugin eslint eslint-config-prettier eslint-plugin-jsx-a11y eslint-plugin-prettier eslint-plugin-react eslint-plugin-react-hooks eslint-plugin-simple-import-sort && \
rm -rf .prettierrc && \
echo "module.exports = {
  semi: false, // Print semicolons at the ends of statements.
  trailingComma: 'es5', // Trailing commas where valid in ES5 (objects, arrays, etc.)
  jsxBracketSameLine: false, // Put the > of a multi-line JSX element at the end of the last line
  singleQuote: true, // Use single quotes instead of double quotes.
  printWidth: 90, // Specify the line length that the printer will wrap on.
  useTabs: true, // Indent lines with tabs instead of spaces.
  tabWidth: 2, // Specify the number of spaces per indentation-level.
  jsxSingleQuote: false, // Use single quotes instead of double quotes in JSX.
  endOfLine: 'auto', // Maintain existing line endings
};" > .prettierrc.js && \
echo "module.exports = {
  root: true,
  parser: '@typescript-eslint/parser',
  parserOptions: {
    ecmaVersion: 2020,
    sourceType: 'module',
    ecmaFeatures: {
      jsx: true,
    },
  },
  settings: {
    react: {
      version: 'detect',
    },
  },
  env: {
    browser: true,
    amd: true,
    node: true,
  },
  plugins: ['simple-import-sort'],
  extends: [
    'eslint:recommended',
    'plugin:@typescript-eslint/eslint-recommended',
    'plugin:@typescript-eslint/recommended',
    'plugin:react/recommended',
    'plugin:jsx-a11y/recommended',
    'plugin:react-hooks/recommended',
    'plugin:prettier/recommended',
  ],
  rules: {
    'prettier/prettier': ['error', {}, { usePrettierrc: true }],
    '@typescript-eslint/ban-ts-comment': 'off',
    'react/prop-types': 'off',
    'simple-import-sort/imports': 'warn',
  },
};" > .eslintrc.js && \
echo "/** @type {import("snowpack").SnowpackUserConfig } */
export default {
  mount: {
    public: { url: '/', static: true },
    src: { url: '/dist' },
  },
  plugins: [
    '@snowpack/plugin-react-refresh',
    '@snowpack/plugin-dotenv',
    [
      '@snowpack/plugin-typescript',
      {
        /* Yarn PnP workaround: see https://www.npmjs.com/package/@snowpack/plugin-typescript */
        ...(process.versions.pnp ? { tsc: 'yarn pnpify tsc' } : {}),
      },
    ],
  ],
  routes: [
    /* Enable an SPA Fallback in development: */
    // {"match": "routes", "src": ".*", "dest": "/index.html"},
  ],
  optimize: {
    /* Example: Bundle your final build: */
    // "bundle": true,
  },
  packageOptions: {
    /* ... */
  },
  devOptions: {
    /* ... */
  },
  buildOptions: {
    /* ... */
  },
  alias: {
    "@components": "./src/components",
  }

};
" > snowpack.config.mjs && \
echo "{
  "include": ["src", "types"],
  "compilerOptions": {
    "module": "esnext",
    "target": "esnext",
    "moduleResolution": "node",
    "jsx": "preserve",
    "baseUrl": "./",
    /* paths - import rewriting/resolving */
    "paths": {
      "@components": ["src/components"]
      // If you configured any Snowpack aliases, add them here.
      // Add this line to get types for streaming imports (packageOptions.source="remote"):
      //     "*": [".snowpack/types/*"]
      // More info: https://www.snowpack.dev/guides/streaming-imports
    },
    /* noEmit - Snowpack builds (emits) files, not tsc. */
    "noEmit": true,
    /* Additional Options */
    "strict": true,
    "skipLibCheck": true,
    "types": ["mocha", "snowpack-env"],
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "allowSyntheticDefaultImports": true,
    "importsNotUsedAsValues": "error"
  }
}
" > tsconfig.json

