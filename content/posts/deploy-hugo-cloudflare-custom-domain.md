---
title: Custom Domain with Cloudflare Pages and Hugo
slug: deploy-hugo-cloudflare-custom-domain
summary: How to deploy a Hugo site on Cloudflare Pages with a custom domain while maintaining functional preview builds using dynamic `baseURL` configuration.
published: "2025-01-11T22:21:00"
---

I host my [Hugo](https://gohugo.io/) blog through Cloudflare Pages as it's free to host and the deployment process is simple. In this post, I'll share my experience deploying the blog, the challenges I faced with custom domains, and how I solved them.

### Why Cloudflare Pages?

Cloudflare Pages offers an attractive option for hosting static sites due to its simplicity, fast build process, and generous free tier. Deploying is straightforward—you push changes to your repository's `main` branch, and Cloudflare automatically detects this, builds the site, and deploys it.

### Deployment Basics

Deploying a Hugo site on Cloudflare Pages is straightforward, thanks to the official guide available [here](https://developers.cloudflare.com/pages/framework-guides/deploy-a-hugo-site/). A key piece of information is configuring the `baseURL`, which Hugo uses to construct full canonical URLs. The recommended build command in the documentation is:

```shell
hugo -b "$CF_PAGES_URL/"
```

The `$CF_PAGES_URL` environment variable holds the dynamically generated URL for the build. This ensures that URLs for posts and links are accurate for each build. This setup is particularly useful if you push draft posts to a separate branch as each branch gets its own preview URL, preserving the correct link structure.

### The Custom Domain Challenge

However, issues arise when using a custom domain for your blog. Hugo's `baseURL` configuration must align with the custom domain to generate correct production URLs. The simplest solution is to hard-code your custom domain in the build command:

```shell
hugo -b "https://benpoppy.dev/"
```

This works perfectly for the `main` branch but breaks preview builds for other branches, as they will also use the custom domain instead of the dynamically generated preview URL.

### A Dynamic Solution

To solve this, I discovered the `$CF_PAGES_BRANCH` environment variable, which specifies the branch being built. Using this variable, we can conditionally set the `baseURL` in the build command to handle both production and preview builds. Here's a shell script to achieve this:

```shell
if [ "$CF_PAGES_BRANCH" = "main" ]; then
  hugo -b "https://benpoppy.dev/"
else
  hugo -b "$CF_PAGES_URL/"
fi
```

This script checks if the build is for the `main` branch. If so, it uses the custom domain; otherwise, it uses the dynamically generated URL. This ensures accurate URLs for both production and preview builds.

### Running Locally

When working locally, it's essential to provide the correct `baseURL` to ensure consistency with production. The default command for Hugo's local server can be updated as follows:

```shell
hugo serve -b http://localhost:1313/
```

This ensures that links are generated correctly when previewing your site locally.

### Conclusion

By dynamically setting the `baseURL` based on the branch, you can seamlessly use a custom domain for production while maintaining accurate URLs for preview builds. This setup is robust and allows for a smooth workflow when drafting posts in separate branches.
