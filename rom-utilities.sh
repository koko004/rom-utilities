#!/bin/bash

echo "------------------------------------------"
echo "   ASISTENTE DE GESTIÓN DE ROMS Y ARCHIVOS"
echo "------------------------------------------"

# 1. Preguntar por la extracción de archivos
read -p "¿Necesitas extraer archivos .zip en esta carpeta primero? (s/n): " respuesta_zip

if [[ "$respuesta_zip" =~ ^[sS]$ ]]; then
    echo "Extrayendo archivos .zip sin crear subcarpetas..."
    # -j ignora rutas, -n no sobrescribe archivos existentes
    unzip -j -n '*.zip'
    echo "Extracción completada."
else
    echo "Saltando extracción."
fi

echo "------------------------------------------"

# 2. Preguntar por las extensiones para renombrar
read -p "Introduce la extensión de ORIGEN (ej. sfc): " ext_origen
read -p "Introduce la extensión de DESTINO (ej. snes): " ext_destino

# Limpiar el punto en caso de que el usuario lo haya escrito (ej. .sfc -> sfc)
ext_origen=${ext_origen#.}
ext_destino=${ext_destino#.}

# 3. Confirmación antes de proceder
count=$(ls -1 *."$ext_origen" 2>/dev/null | wc -l)

if [ "$count" -eq 0 ]; then
    echo "No se encontraron archivos con la extensión .$ext_origen."
    exit 1
fi

echo "Se han encontrado $count archivos .$ext_origen"
read -p "¿Estás seguro de que quieres cambiarlos a .$ext_destino? (s/n): " confirmar

if [[ "$confirmar" =~ ^[sS]$ ]]; then
    echo "Renombrando archivos..."
    
    for archivo in *."$ext_origen"; do
        if [ -f "$archivo" ]; then
            nombre_base="${archivo%."$ext_origen"}"
            mv "$archivo" "${nombre_base}.${ext_destino}"
        fi
    done
    
    echo "¡Proceso terminado! Se han renombrado $count archivos."
else
    echo "Operación cancelada por el usuario."
fi

echo "------------------------------------------"
