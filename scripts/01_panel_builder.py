import pandas as pd
import numpy as np
import os
import glob

def main():
    print("🚀 Iniciando Construcción del Panel Maestro (22 Variables)")
    
    # Rutas absolutas automáticas
    # Se asume que el script está en la carpeta 'scripts'
    base_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    raw_dir = os.path.join(base_dir, "data", "raw")
    processed_dir = os.path.join(base_dir, "data", "processed")
    os.makedirs(processed_dir, exist_ok=True)

    # Mapeo estricto basado en Diccionario e Indicadores validados
    mapeo_22 = {
        2015: {
            'UBIGEO': 'ubigeo', 'C42_P50_T': 'Gasto_Total', 'C42_P50_1': 'Gasto_Recojo', 'C42_P50_2': 'Gasto_Barrido', 'C42_P50_3': 'Gasto_Otros',
            'C37_P45_1': 'FR', 'C38_P46_1': 'QPRS', 'C39_P47_1': 'CSRS',
            'C40_P48_1': 'PIGARS', 'C40_P48_2': 'PMRS', 'C40_P48_3': 'SRRS', 'C40_P48_4': 'PTRS', 'C40_P48_5': 'PSFRSRS',
            'C41_P49_1_1': 'RS', 'C41_P49_1': 'PRS', 'C41_P49_2_2': 'Botadero', 'C41_P49_2': 'PBotadero',
            'C41_P49_3_3': 'Reciclados', 'C41_P49_3': 'PReciclados', 'C41_P49_4_4': 'Quemados', 'C41_P49_4': 'PQuemados',
            'C41_P49_5_5': 'RSRO', 'C41_P49_5': 'PRSRO'
        },
        2016: {
            'UBIGEO': 'ubigeo', 'C42_P50_T': 'Gasto_Total', 'C42_P50_1': 'Gasto_Recojo', 'C42_P50_2': 'Gasto_Barrido', 'C42_P50_3': 'Gasto_Otros',
            'C37_P45_1': 'FR', 'C38_P46_1': 'QPRS', 'C39_P47_1': 'CSRS',
            'C40_P48_1': 'PIGARS', 'C40_P48_2': 'PMRS', 'C40_P48_3': 'SRRS', 'C40_P48_4': 'PTRS', 'C40_P48_5': 'PSFRSRS',
            'C41_P49_1_1': 'RS', 'C41_P49_1': 'PRS', 'C41_P49_2_2': 'Botadero', 'C41_P49_2': 'PBotadero',
            'C41_P49_3_3': 'Reciclados', 'C41_P49_3': 'PReciclados', 'C41_P49_4_4': 'Quemados', 'C41_P49_4': 'PQuemados',
            'C41_P49_5_5': 'RSRO', 'C41_P49_5': 'PRSRO'
        },
        2017: {
            'UBIGEO': 'ubigeo', 'P48_T': 'Gasto_Total', 'P48_1': 'Gasto_Recojo', 'P48_2': 'Gasto_Barrido', 'P48_3': 'Gasto_Otros',
            'P43_1': 'FR', 'P44_1': 'QPRS', 'P45_1': 'CSRS',
            'P46_1': 'PIGARS', 'P46_2': 'PMRS', 'P46_3': 'SRRS', 'P46_4': 'PTRS', 'P46_5': 'PSFRSRS',
            'P47_1_1': 'RS', 'P47_1': 'PRS', 'P47_2_2': 'Botadero', 'P47_2': 'PBotadero',
            'P47_3_3': 'Reciclados', 'P47_3': 'PReciclados', 'P47_4': 'Quemados', 'P47_4_1': 'PQuemados',
            'P47_5_5': 'RSRO', 'P47_5': 'PRSRO'
        },
        2018: {
            'UBIGEO': 'ubigeo', 'P46_T': 'Gasto_Total', 'P46_1': 'Gasto_Recojo', 'P46_2': 'Gasto_Barrido', 'P46_3': 'Gasto_Otros',
            'P41_1': 'FR', 'P42_1': 'QPRS', 'P43_1': 'CSRS',
            'P44_1': 'PIGARS', 'P44_2': 'PMRS', 'P44_3': 'SRRS', 'P44_4': 'PTRS', 'P44_5': 'PSFRSRS',
            'P45_1': 'RS', 'P45_1_1': 'PRS', 'P45_2': 'Botadero', 'P45_2_1': 'PBotadero',
            'P45_3': 'Reciclados', 'P45_3_1': 'PReciclados', 'P45_4': 'Quemados', 'P45_4_1': 'PQuemados',
            'P45_5': 'RSRO', 'P45_5_1': 'PRSRO'
        },
        2019: {
            'UBIGEO': 'ubigeo', 'P45_T': 'Gasto_Total', 'P45_1': 'Gasto_Recojo', 'P45_2': 'Gasto_Barrido', 'P45_3': 'Gasto_Otros',
            'P40_1': 'FR', 'P41_1': 'QPRS', 'P42_1': 'CSRS',
            'P43_1': 'PIGARS', 'P43_2': 'PMRS', 'P43_3': 'SRRS', 'P43_4': 'PTRS', 'P43_5': 'PSFRSRS',
            'P44_1': 'RS', 'P44_1_1': 'PRS', 'P44_2': 'Botadero', 'P44_2_1': 'PBotadero',
            'P44_3': 'Reciclados', 'P44_3_1': 'PReciclados', 'P44_4': 'Quemados', 'P44_4_1': 'PQuemados',
            'P44_5': 'RSRO', 'P44_5_1': 'PRSRO'
        }
    }

    df_list = []
    for year in range(2015, 2020):
        # Buscar cualquier archivo que contenga el año en data/raw
        pattern = os.path.join(raw_dir, f"*{year}*")
        found = glob.glob(pattern)
        
        if found:
            f = found[0]
            print(f"⏳ Procesando {year} desde: {os.path.basename(f)}")
            # Soporte para Excel y CSV
            df = pd.read_excel(f) if f.endswith('.xlsx') or f.endswith('.xls') else pd.read_csv(f, low_memory=False)
            df.columns = df.columns.astype(str).str.upper()
            
            mapping = {k.upper(): v for k, v in mapeo_22[year].items()}
            df = df.rename(columns=mapping)
            cols = [v for v in mapping.values() if v in df.columns]
            df = df[cols].copy()
            df['anio'] = year
            df_list.append(df)
        else:
            print(f"⚠️ No se encontró archivo para el año {year}")

    if not df_list:
        print("❌ Error: No se encontraron datos para procesar.")
        return

    panel = pd.concat(df_list, ignore_index=True)
    
    # Limpieza: Asegurar números y binarias (1/0)
    for col in panel.columns:
        if col not in ['ubigeo', 'anio']:
            panel[col] = pd.to_numeric(panel[col], errors='coerce').fillna(0)
    
    # Ingeniería de variables: Mundlak (CRE)
    panel['log_gasto'] = np.log1p(panel['Gasto_Total'])
    panel['mean_log_gasto'] = panel.groupby('ubigeo')['log_gasto'].transform('mean')

    # --- SALIDAS ---
    
    # 1. Guardar CSV (Para Python/Stata)
    csv_path = os.path.join(processed_dir, "panel_final_tesis.csv")
    panel.to_csv(csv_path, index=False)
    
    # 2. Guardar EXCEL Profesional (Para Revisión y Tesis)
    excel_path = os.path.join(processed_dir, "Panel_Maestro_22_Variables.xlsx")
    with pd.ExcelWriter(excel_path, engine='openpyxl') as writer:
        # Hoja 1: Data Completa
        panel.to_excel(writer, sheet_name='Data_Panel', index=False)
        
        # Hoja 2: Resumen Estadístico (Capítulo 4)
        resumen = panel.describe().T
        resumen.to_excel(writer, sheet_name='Resumen_Descriptivo')
        
    print(f"\n✨ ¡PROCESO COMPLETADO!")
    print(f"📊 Registros totales: {len(panel)}")
    print(f"📁 CSV creado: {csv_path}")
    print(f"📁 EXCEL creado: {excel_path}")

if __name__ == "__main__":
    main()