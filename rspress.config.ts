import { defineConfig } from "rspress/config";

export default defineConfig({
  root: "docs",
  title: "Rexpress documentation",
  description:
    "Documentation for Rexpress, the ReScript binding for Express.js framework",
  lang: "en",
  themeConfig: {
    socialLinks: [
      {
        icon: "github",
        mode: "link",
        content: "https://github.com/MetalbolicX/rexpress.git",
      },
    ],
    sidebar: {
      "/": [
        {
          text: "Home",
          link: "/",
        },
        {
          text: "Quick Start",
          items: [
            { text: "Getting Started", link: "/getting-started" },
            { text: "Compile & Run", link: "/compile-run" },
          ],
        },
        {
          text: "API Reference",
          items: [
            { text: "Express", link: "/api/express" },
            { text: "Application", link: "/api/application" },
          ]
        },
      ],
    },
  },
});
