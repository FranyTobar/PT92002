# Portafolio NASM - PT92002

**Estudiante:** Frany Esmeralda Peña Tobar
**Carnet:** PT92002  
**Asignatura:** Diseño y Estructura de Computadoras  
**Universidad:** Universidad de El Salvador  
**Ciclo:** I-2025  

---

##  Archivos del proyecto

| Archivo | Tipo | Descripción |
|---------|------|-------------|
| `division32.asm` | Programa NASM | Implementa operaciones de división de 32 bits |
| `multBbits.asm` | Programa NASM | Realiza multiplicaciones de 8 bits 
| `resta_input.asm` | Programa NASM | Ejecuta restas con entrada interactiva del usuario |

---

##  Requisitos técnicos

- **Ensamblador NASM** (versión 2.15+)
  ```bash
  # Instalación en Linux:
  sudo apt install nasm

  division32.asm
 nasm -f elf32 division32.asm -o division.o
ld -m elf_i386 division.o -o division
./division

multBbits.asm
nasm -f elf32 multBbits.asm -o mult.o
ld -m elf_i386 mult.o -o mult
./mult

resta_input.asm
nasm -f elf64 resta_input.asm -o resta.o
ld resta.o -o resta
./resta

