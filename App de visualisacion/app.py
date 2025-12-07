import streamlit as st
import pandas as pd
import pydeck as pdk 
from datetime import date, timedelta
from database import get_all_stations, get_data, obtener_ubicaciones, obtener_ultimo_valor
st.markdown("""
    <style>
        /* Quita el espacio blanco gigante de arriba */
        .block-container {padding-top: 1rem; padding-bottom: 0rem;}
        /* Quita el borde feo del iframe si lo tuviera */
        iframe {border: none;}
    </style>
""", unsafe_allow_html=True)

st.set_page_config(
    page_title="Monitor Ambiental IoT",
    page_icon="🌿",
    layout="wide",
    initial_sidebar_state="expanded"
)


st.markdown("""
    <style>
    .block-container {padding-top: 1rem; padding-bottom: 0rem;}
    iframe {border: 2px solid #0078d4; border-radius: 10px;}
    </style>
""", unsafe_allow_html=True)


st.title("🌿 Sistema de Monitoreo (BOB)")
st.markdown("---")


with st.sidebar:
    st.header("📍 Ubicación de Estaciones")
    
    # 1. Cargar y mostrar Mapa (PyDeck)
    df_mapa = obtener_ubicaciones()
    
    if not df_mapa.empty:
        # Centro promedio del mapa
        lat_inicial = df_mapa['lat'].mean()
        lon_inicial = df_mapa['lon'].mean()

        view_state = pdk.ViewState(
            latitude=lat_inicial,
            longitude=lon_inicial,
            zoom=15,
            pitch=0)

     
        layer = pdk.Layer(
            "ScatterplotLayer",
            data=df_mapa,
            get_position='[lon, lat]',
            get_color='[255, 0, 0, 200]', 
            get_radius=15,
            pickable=True,
            auto_highlight=True
        )

 
        st.pydeck_chart(pdk.Deck(
            map_style=None,
            initial_view_state=view_state,
            layers=[layer],
            tooltip={
                "html": "<b>Estación:</b> {Nombre}",
                "style": {"backgroundColor": "steelblue", "color": "white"}
            }
        ))
    else:
        st.warning("No hay coordenadas en la BD.")

    st.divider()
    
    st.header("🎛️ Filtros de Consulta")
    
    
    stations = get_all_stations()
    station_id = None
    selected_station_name = "Sin Estaciones"

    if stations:
        station_options = {s['Nombre']: s['EstacionID'] for s in stations}
        selected_station_name = st.selectbox("Selecciona la Estación:", list(station_options.keys()))
        station_id = station_options[selected_station_name]
    else:
        st.error("BD vacía o sin conexión.")

 
    st.subheader("📅 Rango de Fechas")
    col_d1, col_d2 = st.columns(2)
    
    today = date.today()
    last_week = today - timedelta(days=7)

    start_date = col_d1.date_input("Inicio", last_week)
    end_date = col_d2.date_input("Fin", today)


tab_local, tab_nube, tab_stats = st.tabs(["📊 Dashboard Local", "☁️ Visualización Power BI", "📈 Estadísticas Detalladas"])


with tab_local:
    if station_id:
        st.subheader(f"Análisis Local: {selected_station_name}")
        
    
        last_temp = obtener_ultimo_valor("Lectura_Temperatura", station_id) or "--"
        last_hum = obtener_ultimo_valor("Lectura_Humedad", station_id) or "--"
        last_co2 = obtener_ultimo_valor("Lectura_eCO2", station_id) or "--"
        last_tvoc = obtener_ultimo_valor("Lectura_TVOC", station_id) or "--"

 
        col1, col2, col3, col4 = st.columns(4)
        col1.metric("Temperatura", f"{last_temp} °C", "En vivo")
        col2.metric("Humedad", f"{last_hum} %", "Normal")
        col3.metric("Calidad Aire (eCO2)", f"{last_co2} ppm", "Estable", delta_color="inverse")
        col4.metric("TVOC", f"{last_tvoc} ppb", "Alerta", delta_color="inverse")

        st.markdown("---")

     
        col_g1, col_g2 = st.columns(2)
        with col_g1:
            st.info("🌡️ Temperatura Histórica")
            df_temp = get_data("Lectura_Temperatura", station_id, start_date, end_date)
            if not df_temp.empty:
                st.line_chart(df_temp.set_index("Fecha")["Valor"], color="#FF4B4B")
            else:
                st.warning(f"Sin datos del {start_date} al {end_date}")

        with col_g2:
            st.info("💧 Humedad Histórica")
            df_hum = get_data("Lectura_Humedad", station_id, start_date, end_date)
            if not df_hum.empty:
                st.line_chart(df_hum.set_index("Fecha")["Valor"], color="#0083B8")
            else:
                st.warning("Sin datos.")

        col_g3, col_g4 = st.columns(2)
        with col_g3:
            st.info("💨 CO2 Histórico")
            df_co2 = get_data("Lectura_eCO2", station_id, start_date, end_date)
            if not df_co2.empty:
                st.line_chart(df_co2.set_index("Fecha")["Valor"], color="#2E8B57")
            else:
                st.warning("Sin datos.")

        with col_g4:
            st.info("☣️ TVOC Histórico")
            df_tvoc = get_data("Lectura_TVOC", station_id, start_date, end_date)
            if not df_tvoc.empty:
                st.line_chart(df_tvoc.set_index("Fecha")["Valor"], color="#FFA500")
            else:
                st.warning("Sin datos.")


with tab_nube:
    st.subheader("☁️ Visualización en la Nube (Azure)")
    
 
    url_reporte = "https://app.powerbi.com/view?r=eyJrIjoiZTAwNDcyYzYtMDZlOS00NmYyLTkyZmMtZDY5N2E5MTE0N2IzIiwidCI6ImM2NWEzZWE2LTBmN2MtNDAwYi04OTM0LTVhNmRjMTcwNTY0NSIsImMiOjR9"
    col_text, col_btn = st.columns([3, 1])
    
    with col_text:
        st.info("ℹ️ Este dashboard se alimenta en tiempo real desde Azure IoT Hub.")
        
    with col_btn:
    
        st.link_button("↗️ Abrir en Navegador", url_reporte)

    st.components.v1.iframe(url_reporte + "&navContentPaneEnabled=false", width=None, height=700, scrolling=True)

with tab_stats:
    st.subheader("📋 Análisis Estadístico Detallado")
    
    if station_id:

        col_sel, _ = st.columns([1, 2])
        with col_sel:
            variable_selec = st.selectbox(
                "Selecciona Variable para Analizar:", 
                ["Lectura_Temperatura", "Lectura_Humedad", "Lectura_eCO2", "Lectura_TVOC"],
                format_func=lambda x: x.replace("Lectura_", "") # Limpia el nombre en el menú
            )
        
  
        df_stats = get_data(variable_selec, station_id, start_date, end_date)
        
        if not df_stats.empty:

            max_val = df_stats["Valor"].max()
            min_val = df_stats["Valor"].min()
            avg_val = df_stats["Valor"].mean()
            std_dev = df_stats["Valor"].std()
            total_readings = df_stats["Valor"].count()
            

            st.markdown("#### 📊 Indicadores Clave")
            kpi1, kpi2, kpi3, kpi4 = st.columns(4)
            kpi1.metric("Máximo Histórico", f"{max_val:.2f}")
            kpi2.metric("Mínimo Histórico", f"{min_val:.2f}")
            kpi3.metric("Promedio Global", f"{avg_val:.2f}")
            kpi4.metric("Desviación Estándar", f"{std_dev:.2f}")
            
            st.markdown("---")
            
            col_tabla1, col_tabla2 = st.columns(2)
            
            with col_tabla1:
                st.write("#### 📐 Distribución de Datos (Describe)")
         
                st.dataframe(df_stats["Valor"].describe().to_frame().T, use_container_width=True)
                
                st.write(f"**Total de lecturas analizadas:** {total_readings}")

            with col_tabla2:
                st.write("#### 📥 Exportar Datos")
                st.write("Descarga los datos filtrados para usarlos en Excel u otras herramientas.")
                csv = df_stats.to_csv(index=False).encode('utf-8')
                st.download_button(
                    label="📥 Descargar CSV",
                    data=csv,
                    file_name=f"{variable_selec}_stats.csv",
                    mime="text/csv",
                )
            
            st.markdown("#### 📝 Tabla de Registros")
            st.dataframe(df_stats, use_container_width=True, height=300)
            
        else:
            st.warning(f"No hay datos de {variable_selec} en el rango seleccionado ({start_date} - {end_date}).")
    else:
        st.error("Selecciona una estación en el menú lateral.")
