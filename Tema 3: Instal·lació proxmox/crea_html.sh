#!/bin/bash
pandoc instalproxmox.md -o index_va.html --from markdown+implicit_figures -c pandoc.css --template elegant_bootstrap_menu --listings --filter pandoc-latex-environment --toc --toc-depth 2
