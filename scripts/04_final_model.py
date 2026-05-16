import pandas as pd
import numpy as np
import statsmodels.api as sm
from statsmodels.miscmodels.ordinal_model import OrderedModel
import os

def main():
    print("⚖️ Iniciando Modelamiento Econométrico Final (Wooldridge CRE+CF)")
    
    # 1. Cargar Panel Validado
    base_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    data_path = os.path.join(base_dir, "data", "processed", "panel_final_tesis.csv")
    df = pd.read_csv(data_path).dropna(subset=['frecuencia', 'log_gasto_pc', 'mean_log_gasto'])
    
    # 2. ETAPA 1: Función de Control (CF)
    # Estimamos el gasto basándonos en variables exógenas (aquí usamos el enfoque de medias de Mundlak)
    # El residuo (vhat) capturará la endogeneidad
    print("  -> Ejecutando Etapa 1 (First Stage)...")
    X_stage1 = sm.add_constant(df[['mean_log_gasto']])
    stage1_res = sm.OLS(df['log_gasto_pc'], X_stage1).fit()
    df['vhat'] = stage1_res.resid # Residuos de la función de control
    
    # 3. ETAPA 2: Ordered Probit con CF
    # Variable dependiente: Frecuencia (Categoría ordenada 1-5)
    print("  -> Ejecutando Etapa 2 (Ordered Probit con vhat)...")
    df['frecuencia'] = df['frecuencia'].astype(int)
    
    # Variables: Gasto + Medias de Mundlak + Residuo de Etapa 1
    X_stage2 = df[['log_gasto_pc', 'mean_log_gasto', 'vhat']]
    
    model = OrderedModel(df['frecuencia'], X_stage2, distr='probit')
    results = model.fit(method='bfgs', disp=False)
    
    # 4. Reporte de Resultados
    print("\n" + "="*60)
    print("RESULTADOS FINALES: IMPACTO DEL GASTO EN EFICIENCIA (FR)")
    print("="*60)
    print(results.summary())
    
    # Interpretación del vhat
    p_vhat = results.pvalues['vhat']
    if p_vhat < 0.05:
        print(f"\n✅ vhat es significativo (p={p_vhat:.4f}): Hay evidencia de endogeneidad.")
        print("   El uso de la Función de Control fue necesario y correcto.")
    else:
        print(f"\n⚠️ vhat no es significativo (p={p_vhat:.4f}): No se detecta endogeneidad fuerte.")

    # Guardar resultados
    output_path = os.path.join(base_dir, "quality_reports", "model_final_results.txt")
    with open(output_path, "w") as f:
        f.write(str(results.summary()))
    print(f"\n📁 Resultados guardados en: {output_path}")

if __name__ == "__main__":
    main()