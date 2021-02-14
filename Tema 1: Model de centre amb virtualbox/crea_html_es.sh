#!/bin/bash
pandoc Model_de_centre_virtualbox_es.md -o index_es.html --from markdown+implicit_figures -c pandoc.css --template elegant_bootstrap_menu --listings --filter pandoc-latex-environment --number-sections --toc --toc-depth 3
