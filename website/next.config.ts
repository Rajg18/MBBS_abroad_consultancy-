import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  // Static export → deployed as static assets to Cloudflare Pages, same as
  // the existing Flutter frontend. No server/edge runtime in this stack.
  output: "export",
  images: {
    // No Next Image Optimization server under static export.
    unoptimized: true,
  },
};

export default nextConfig;
