#!/bin/bash
pandoc Model_de_centre_virtualbox_es.md -o Model_de_centre_virtualbox_es.pdf --from markdown+implicit_figures --template eisvogel --listings --filter pandoc-latex-environment --number-sections --toc
