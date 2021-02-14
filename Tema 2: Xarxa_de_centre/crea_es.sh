#!/bin/bash
pandoc Xarxa_es.md -o red_es.pdf --from markdown+implicit_figures --template eisvogel --listings --filter pandoc-latex-environment --number-sections
