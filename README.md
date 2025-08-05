# Tribble Agent Factory - Website Refresh 2025

An interactive 3D visualization showcasing Tribble's agent platform capabilities through a futuristic factory metaphor.

## Overview

This website features:
- 🏭 Interactive 3D wireframe factory visualization with Three.js
- 📜 Scroll-based journey from aerial view to inside the factory
- 🎯 HUD overlays with animated data visualizations
- 💬 Modal system explaining Tribble's capabilities at each zoom level
- 🔌 3D grid of microchips with neural network connections
- 🎨 Clean, light mode aesthetic with blue wireframe design

## Setup

1. Clone the repository
2. The `microchip_prototype.glb` file (102MB) is not included due to GitHub file size limits. You can:
   - Download it separately from the Tribble team
   - Use the fallback visualization (the site will still work without it)
   - Host it on a CDN and update the path in `index.html` line 990

3. Serve the files using any web server:
   ```bash
   python3 -m http.server 8000
   # or
   npx serve
   ```

4. Open http://localhost:8000 in your browser

## Features

- **Real-time Processing Engine** - Visualizes Tribble's zero-latency response capabilities
- **Integration Layer** - Shows how Tribble unifies knowledge across all systems
- **Active Learning** - Demonstrates continuous improvement and knowledge gap identification
- **Workflow Automation** - Showcases deployment across Sales, Pre-Sales, and Product teams
- **Tribblytics** - Preview of real-time analytics and insights

## Technologies

- Three.js for 3D graphics
- Anime.js for animations
- Vanilla JavaScript (no framework dependencies)
- ES6 modules with import maps

## Browser Support

Works best in modern browsers with WebGL support:
- Chrome 90+
- Firefox 88+
- Safari 14+
- Edge 90+

## License

© 2025 Tribble. All rights reserved.