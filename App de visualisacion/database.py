import mysql.connector
from mysql.connector import Error
import pandas as pd
import streamlit as st

def get_db_connection():
    """Crea y devuelve una conexión a la base de datos MySQL"""
    try:
        connection = mysql.connector.connect(
            host='localhost',
            user='iot_user',      # Tu usuario seguro
            password='pass1234',  # Tu contraseña
            database='iot'        # Tu base de datos
        )
        return connection
    except Error as e:
        st.error(f"Error al conectar a la base de datos: {e}")
        return None


def get_all_stations():
    """Devuelve una lista de diccionarios con ID y Nombre de todas las estaciones"""
    conn = get_db_connection()
    if conn:
        try:
            cursor = conn.cursor(dictionary=True)
            cursor.execute("SELECT EstacionID, Nombre FROM Estacion ORDER BY EstacionID ASC")
            stations = cursor.fetchall()
            return stations
        except Error as e:
            st.error(f"Error al obtener estaciones: {e}")
            return []
        finally:
            if conn.is_connected():
                conn.close()
    return []


def get_data(table_name, station_id, start_date, end_date):
    """
    Obtiene los datos históricos de una tabla específica (ej. Lectura_Temperatura)
    filtrados por estación y rango de fechas.
    Devuelve un Pandas DataFrame.
    """
    conn = get_db_connection()
    if conn:
        try:

            query = f"""
                SELECT L.Timestamp as Fecha, L.Valor
                FROM {table_name} L
                JOIN Sensor S ON L.SensorID = S.SensorID
                WHERE S.EstacionID = %s
                AND DATE(L.Timestamp) BETWEEN %s AND %s
                ORDER BY L.Timestamp ASC
            """
            

            df = pd.read_sql(query, conn, params=(station_id, start_date, end_date))
            return df
            
        except Error as e:
            st.error(f"Error al obtener datos de {table_name}: {e}")
            return pd.DataFrame() 
        finally:
            if conn.is_connected():
                conn.close()
    return pd.DataFrame()

def obtener_ubicaciones():
    """Obtiene latitud, longitud y nombre para el mapa"""
    conn = get_db_connection()
    if conn:
        try:
            cursor = conn.cursor(dictionary=True)
            query = "SELECT Nombre, Latitud as lat, Longitud as lon FROM Estacion"
            cursor.execute(query)
            data = cursor.fetchall()
            
            df = pd.DataFrame(data)
            

            if not df.empty:

                df['lat'] = df['lat'].astype(float)
                df['lon'] = df['lon'].astype(float)
       
                df = df.dropna(subset=['lat', 'lon'])
            
            return df

        except Error as e:
            st.error(f"Error mapa: {e}")
            return pd.DataFrame()
        finally:
            if conn.is_connected():
                conn.close()
    return pd.DataFrame()

def obtener_ultimo_valor(tabla, station_id):
    """Obtiene el dato más reciente de una estación para mostrarlo en grande"""
    conn = get_db_connection()
    result = None
    if conn:
        try:
            cursor = conn.cursor(dictionary=True)

            query = f"""
                SELECT L.Valor 
                FROM {tabla} L
                JOIN Sensor S ON L.SensorID = S.SensorID
                WHERE S.EstacionID = %s 
                ORDER BY L.Timestamp DESC LIMIT 1
            """
            cursor.execute(query, (station_id,))
            row = cursor.fetchone()
            if row:
                result = row['Valor']
        except Error:
            pass
        finally:
            if conn.is_connected():
                conn.close()
    return result
