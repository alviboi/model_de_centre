#!/bin/bash
pandoc Configuracio_proxmox.md -o Configuracio_proxmox.pdf --from markdown+implicit_figures --template eisvogel --listings --filter pandoc-latex-environment --number-sections
