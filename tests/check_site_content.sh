#!/usr/bin/env bash
set -euo pipefail

page="index.html"

required=(
  "End-to-End Differentiable Particle Filter for Multi-Environment 3D-LiDAR Localization"
  "CoRL 2026"
  "3D-LiDAR"
  "SE(3)"
  "Unit Dual Quaternion"
  "differentiable resampling"
  "static/pdfs/CORL_2026___Diff_SLAM.pdf"
)

for text in "${required[@]}"; do
  if ! grep -Fq "$text" "$page"; then
    echo "Missing required site content: $text" >&2
    exit 1
  fi
done

if grep -Fq "Differentiable Weights-Varying Nonlinear MPC" "$page"; then
  echo "Outdated MPC paper title is still present" >&2
  exit 1
fi

if grep -Fq "bulmaCarousel.attach" static/js/index.js && ! grep -Fq "typeof bulmaCarousel" static/js/index.js; then
  echo "Carousel initialization is not guarded for pages without the carousel library" >&2
  exit 1
fi

centering_rules=(
  ".paper-section-center"
  "margin-left: auto;"
  "margin-right: auto;"
  ".preview-frame"
  ".pipeline-grid"
)

for text in "${centering_rules[@]}"; do
  if ! grep -Fq "$text" "$page"; then
    echo "Missing centering/layout rule in project page: $text" >&2
    exit 1
  fi
done

if grep -Pzo '<div class="container is-max-desktop has-text-centered">\s*</div>\s*<h1' "$page" >/dev/null; then
  echo "Hero centered container closes before the title" >&2
  exit 1
fi

if ! grep -Fq "paper-footer" "$page"; then
  echo "Footer is missing centered paper-footer wrapper" >&2
  exit 1
fi
