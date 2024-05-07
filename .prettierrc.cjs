module.exports = {
  // ...
  plugins: ["prettier-plugin-ember-template-tag"],
  overrides: [
    {
      files: "*.{js,ts,gjs,gts}",

      options: {
        singleQuote: true,
        lineLength: 120,
      },
    },

    {
      files: "*.gjs",
      options: {
        parser: "ember-template-tag",
      },
    },
    {
      files: "*.gts",
      options: {
        parser: "ember-template-tag",
      },
    },

    // ...
  ],
};
