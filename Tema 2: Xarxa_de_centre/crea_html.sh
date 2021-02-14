#!/bin/bash
pandoc Xarxa.md -o index_va.html --from markdown+implicit_figures -c pandoc.css --template elegant_bootstrap_menu --listings --filter pandoc-latex-environment --number-sections --toc --toc-depth 3
