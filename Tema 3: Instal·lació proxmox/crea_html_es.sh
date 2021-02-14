#!/bin/bash
pandoc instalproxmox_es.md -o index_es.html --from markdown+implicit_figures -c pandoc.css --template elegant_bootstrap_menu --listings --filter pandoc-latex-environment --toc --toc-depth 2
