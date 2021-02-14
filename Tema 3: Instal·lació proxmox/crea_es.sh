#!/bin/bash
pandoc instalproxmox_es.md -o instalproxmox_es.pdf --from markdown+implicit_figures --template eisvogel --listings --filter pandoc-latex-environment --number-sections
