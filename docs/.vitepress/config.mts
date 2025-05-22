import { defineConfig } from "vitepress";

// https://vitepress.dev/reference/site-config
export default defineConfig({
  title: "rexpress-docs",
  description: "The ReScript bindings to use the Express js backend framework",
  themeConfig: {
    // https://vitepress.dev/reference/default-theme-config
    nav: [{ text: "Home", link: "/" }],

    sidebar: [
      {
        text: "Setup",
        items: [
          { text: "Getting Started", link: "/getting-started" },
          { text: "How to run", link: "/how-to-run" },
        ],
      },
      {
        text: "API",
        items: [
          { text: "API Reference", link: "/api" }
        ],
      },
      {
        text: "Examples",
        items: [
          { text: "Simple Example", link: "/examples" },
          { text: "Advanced Example", link: "/examples/advanced" },
        ],
      }
    ],

    socialLinks: [
      { icon: "github", link: "https://github.com/MetalbolicX/rexpress" },
    ],
  },
});
