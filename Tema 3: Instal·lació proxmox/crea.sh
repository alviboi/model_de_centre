#!/bin/bash
pandoc instalproxmox.md -o instalproxmox_va.pdf --from markdown+implicit_figures --template eisvogel --listings --filter pandoc-latex-environment --number-sections
