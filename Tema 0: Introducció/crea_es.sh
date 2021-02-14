#!/bin/bash
pandoc UD1_Introduccio_es.md -o UD1_Introduccio_es.pdf --from markdown+implicit_figures --template eisvogel --listings --filter pandoc-latex-environment --number-sections --toc
