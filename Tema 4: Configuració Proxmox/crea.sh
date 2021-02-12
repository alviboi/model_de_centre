#!/bin/bash
pandoc Configuracio_proxmox.md -o example.pdf --from markdown+implicit_figures --template eisvogel --listings --filter pandoc-latex-environment --number-sections
