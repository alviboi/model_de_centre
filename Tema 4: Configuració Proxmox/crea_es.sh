#!/bin/bash
pandoc Configuracio_proxmox_es.md -o Configuracio_proxmox_es.pdf --from markdown+implicit_figures --template eisvogel --listings --filter pandoc-latex-environment --number-sections
