#!/bin/bash
pandoc UD1_Introduccio.md -o UD1_Introduccio_va.pdf --from markdown+implicit_figures --template eisvogel --listings --filter pandoc-latex-environment --number-sections --toc
