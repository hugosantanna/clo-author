import pandas as pd
import numpy as np
import os

def validate_data():
    print("--- 🔍 INICIANDO AUDITORÍA DE DATOS: TESIS BARRETO ---")
    
    # 1. Configuración de ruta absoluta automática (Basado en la ubicación del script)
    # Detectamos la raíz del proyecto retrocediendo un nivel desde la carpeta 'scripts'
    base_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    processed_path = os.path.join(base_dir, "data", "processed", "panel_final_tesis.csv")
    
    print(f"📂 Verificando archivo en: {processed_path}")
    
    if not os.path.exists(processed_path):
        print(f"❌ ERROR: No se encuentra el panel en la ruta especificada.")
        print(f"👉 Por favor, asegúrate de que el archivo exista en la carpeta 'processed'.")
        return

    # 2. Carga de Datos y validación inicial
    df = pd.read_csv(processed_path)
    print(f"✅ Panel cargado con éxito: {len(df)} registros detectados.")

    # 3. Validación de estructura temporal
    anios_presentes = sorted(df['anio'].unique().tolist())
    print(f"📅 Años detectados en el panel: {anios_presentes}")
    
    # 4. Auditoría de Variables Críticas (Basado en Diccionario)
    print("\n--- 📊 Verificación de Consistencia (Diccionario vs Data) ---")
    
    # Rango de Frecuencia
    frec_min = df['frecuencia'].min()
    frec_max = df['frecuencia'].max()
    print(f"🔹 Frecuencia: Rango detectado de {frec_min} a {frec_max}.")
    
    # Validación de NAs
    nas = df[['gasto_total', 'frecuencia', 'poblacion']].isna().sum()
    print("\n--- 🛠️ Reporte de Valores Faltantes (NAs) ---")
    for col, val in nas.items():
        pct = (val / len(df)) * 100
        print(f"   Variable {col}: {val} faltantes ({pct:.2f}%)")

    # 5. Verificación de Cálculos Econométricos
    if 'log_gasto_pc' in df.columns and 'mean_log_gasto' in df.columns:
        print("\n✅ Variables Mundlak (CRE) detectadas. El panel está listo para Wooldridge.")
    else:
        print("\n⚠️ ADVERTENCIA: Faltan variables de Mundlak para el análisis econométrico.")

    print("\n--- ✨ AUDITORÍA FINALIZADA ---")

if __name__ == "__main__":
    validate_data()