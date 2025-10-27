# ==========================================
"""
sp_menu_refactorizado.py
Sistema de gestión de empleados con procedimientos almacenados MySQL
Autor: Dany (versión refactorizada)
Propósito: Proporcionar una interfaz Python para operaciones CRUD sobre empleados
mediante procedimientos almacenados en MySQL, con manejo mejorado de
recursos y errores.
"""
# ==========================================
# Importación del conector oficial de MySQL para Python
import mysql.connector
from typing import Optional, List, Tuple, Dict, Any

# ---------- CONFIGURACIÓN DE BASE DE DATOS ----------
# Parámetros de conexión a la base de datos MySQL
DB_CONFIG = {
    "host": "localhost", # Dirección del servidor MySQL
    "user": "root", # Nombre de usuario para la conexión
    "password": "1234", # Contraseña del usuario (modificar según corresponda)
    "database": "empresa" # Base de datos de trabajo
    # "port": 3306, # Puerto personalizado (descomentar si es necesario)
}

# ---------- GESTIÓN DE CONEXIÓN ----------
def obtener_conexion():
    """
    Establece una conexión con la base de datos MySQL utilizando la configuración
    definida en DB_CONFIG.
    Returns:
    mysql.connector.connection.MySQLConnection: Objeto de conexión activo

    Raises:
    mysql.connector.Error: Si la conexión no puede establecerse
    """
    try:
        return mysql.connector.connect(**DB_CONFIG)
    except mysql.connector.Error as e:
        print(f"Error al conectar con la base de datos: {e}")
        raise

# ---------- FUNCIONES DE GESTIÓN DE EMPLEADOS ----------
def insertar_empleado(nombre: str, cargo: str, sueldo: float) -> int:
    """
    Crea un nuevo registro de empleado en la base de datos.
    Args:
    nombre (str): Nombre completo del empleado
    cargo (str): Posición o rol del empleado en la empresa
    sueldo (float): Salario mensual del empleado

    Returns:
    int: ID del nuevo empleado creado, o -1 si ocurrió un error

    Nota:
    Utiliza el procedimiento almacenado sp_insertar_empleado
    """
    try:
        with obtener_conexion() as conexion:
            with conexion.cursor() as cursor:
                # Preparar argumentos para el procedimiento almacenado
                args = [nombre, cargo, sueldo, 0] # El último parámetro es de salida (OUT)

                # Ejecutar procedimiento almacenado
                cursor.callproc("sp_insertar_empleado", args)

                # Confirmar la transacción
                conexion.commit()

                # Obtener el ID generado (parámetro de salida)
                nuevo_id = args[3]
                print(f"Empleado creado exitosamente con ID: {nuevo_id}")
                return nuevo_id

    except mysql.connector.Error as e:
        print(f"Error al insertar empleado: {e}")
        return -1

def listar_empleados_activos() -> None:
    """
    Recupera y muestra todos los empleados que no han sido eliminados lógicamente.
    Nota:
    Utiliza el procedimiento almacenado sp_listar_empleados_activos
    """
    try:
        with obtener_conexion() as conexion:
            with conexion.cursor() as cursor:
                # Ejecutar procedimiento almacenado
                cursor.callproc("sp_listar_empleados_activos")

                # Procesar resultados
                resultados = []
                for result in cursor.stored_results():
                    resultados.extend(result.fetchall())

                # Mostrar resultados
                print("\n=== EMPLEADOS ACTIVOS ===")
                if not resultados:
                    print("No se encontraron empleados activos.")
                    return

                for id_, nombre, cargo, sueldo, created_at, updated_at in resultados:
                    ua = updated_at if updated_at is not None else "-"
                    print(f"ID:{id_:<3} | Nombre:{nombre:<15} | Cargo:{cargo:<13} | "
                          f"Sueldo:${sueldo:,.0f} | Creado:{created_at} | Actualizado:{ua}")

    except mysql.connector.Error as e:
        print(f"Error al listar empleados activos: {e}")

def listar_todos_los_empleados() -> None:
    """
    Recupera y muestra todos los empleados, tanto activos como eliminados lógicamente.
    Nota:
    Utiliza el procedimiento almacenado sp_listar_empleados_todos
    """
    try:
        with obtener_conexion() as conexion:
            with conexion.cursor() as cursor:
                # Ejecutar procedimiento almacenado
                cursor.callproc("sp_listar_empleados_todos")

                # Procesar resultados
                resultados = []
                for result in cursor.stored_results():
                    resultados.extend(result.fetchall())

                # Mostrar resultados
                print("\n=== TODOS LOS EMPLEADOS ===")
                if not resultados:
                    print("No hay empleados registrados en la base de datos.")
                    return

                for id_, nombre, cargo, sueldo, eliminado, created_at, updated_at, deleted_at in resultados:
                    estado = "ACTIVO" if eliminado == 0 else "ELIMINADO"
                    ua = updated_at if updated_at is not None else "-"
                    da = deleted_at if deleted_at is not None else "-"
                    print(
                        f"ID:{id_:<3} | Nombre:{nombre:<15} | Cargo:{cargo:<13} | "
                        f"Sueldo:${sueldo:,.0f} | {estado:<9} | Creado:{created_at} | "
                        f"Actualizado:{ua} | Eliminado:{da}"
                    )

    except mysql.connector.Error as e:
        print(f"Error al listar todos los empleados: {e}")

def eliminar_logicamente_empleado(id_empleado: int) -> None:
    """
    Marca un empleado como eliminado sin eliminarlo físicamente de la base de datos.
    Args:
    id_empleado (int): Identificador único del empleado a eliminar

    Nota:
    Utiliza el procedimiento almacenado sp_borrado_logico_empleado
    """
    try:
        with obtener_conexion() as conexion:
            with conexion.cursor() as cursor:
                # Ejecutar procedimiento almacenado
                cursor.callproc("sp_borrado_logico_empleado", [id_empleado])

                # Confirmar la transacción
                conexion.commit()

                print(f"Se ha marcado como eliminado al empleado con ID {id_empleado}")

    except mysql.connector.Error as e:
        print(f"Error al eliminar lógicamente el empleado: {e}")

def restaurar_empleado(id_empleado: int) -> None:
    """
    Restaura un empleado que fue eliminado lógicamente.
    Args:
    id_empleado (int): Identificador único del empleado a restaurar

    Nota:
    Utiliza el procedimiento almacenado sp_restaurar_empleado
    """
    try:
        with obtener_conexion() as conexion:
            with conexion.cursor() as cursor:
                # Ejecutar procedimiento almacenado
                cursor.callproc("sp_restaurar_empleado", [id_empleado])

                # Confirmar la transacción
                conexion.commit()

                print(f"Se ha restaurado al empleado con ID {id_empleado}")

    except mysql.connector.Error as e:
        print(f"Error al restaurar el empleado: {e}")

def actualizar_datos_empleado(id_emp: int, nombre: str, cargo: str, sueldo: float) -> None:
    """
    Modifica la información de un empleado existente en la base de datos.
    Args:
    id_emp (int): Identificador único del empleado a actualizar
    nombre (str): Nuevo nombre del empleado
    cargo (str): Nuevo cargo del empleado
    sueldo (float): Nuevo sueldo del empleado

    Nota:
    Utiliza el procedimiento almacenado sp_actualizar_empleado
    """
    try:
        with obtener_conexion() as conexion:
            with conexion.cursor() as cursor:
                # Preparar argumentos para el procedimiento almacenado
                args = [id_emp, nombre, cargo, sueldo]

                # Ejecutar procedimiento almacenado
                cursor.callproc("sp_actualizar_empleado", args)

                # Confirmar la transacción
                conexion.commit()

                print(f"Datos del empleado ID {id_emp} actualizados correctamente")

    except mysql.connector.Error as e:
        print(f"Error al actualizar el empleado: {e}")

def buscar_empleado_por_id(id_empleado: int) -> Optional[Tuple]:
    """
    Busca y muestra la información detallada de un empleado específico.
    Args:
    id_empleado (int): Identificador único del empleado a buscar

    Returns:
    Optional[Tuple]: Tupla con los datos del empleado si se encuentra, None en caso contrario

    Nota:
    Utiliza el procedimiento almacenado sp_buscar_empleado_por_id
    """
    try:
        with obtener_conexion() as conexion:
            with conexion.cursor() as cursor:
                # Ejecutar procedimiento almacenado
                cursor.callproc("sp_buscar_empleado_por_id", [id_empleado])

                # Obtener resultados
                empleado = None
                for result in cursor.stored_results():
                    empleado = result.fetchone()

                # Mostrar resultados
                print(f"\n=== DETALLE DEL EMPLEADO ID: {id_empleado} ===")
                if not empleado:
                    print(f"No se encontró ningún empleado con el ID {id_empleado}")
                    return None

                id_, nombre, cargo, sueldo, eliminado, created_at, updated_at, deleted_at = empleado
                estado = "ACTIVO" if eliminado == 0 else "ELIMINADO"
                ua = updated_at if updated_at is not None else "-"
                da = deleted_at if deleted_at is not None else "-"

                print(f"ID: {id_}")
                print(f"Nombre: {nombre}")
                print(f"Cargo: {cargo}")
                print(f"Sueldo: ${sueldo:,.0f}")
                print(f"Estado: {estado}")
                print(f"Creado: {created_at}")
                print(f"Actualizado: {ua}")
                print(f"Eliminado: {da}")

                return empleado

    except mysql.connector.Error as e:
        print(f"Error al buscar el empleado: {e}")
        return None

def listar_empleados_eliminados() -> None:
    """
    Recupera y muestra únicamente los empleados que han sido eliminados lógicamente.
    Nota:
    Utiliza el procedimiento almacenado sp_listar_empleados_eliminados
    """
    try:
        with obtener_conexion() as conexion:
            with conexion.cursor() as cursor:
                # Ejecutar procedimiento almacenado
                cursor.callproc("sp_listar_empleados_eliminados")

                # Procesar resultados
                resultados = []
                for result in cursor.stored_results():
                    resultados.extend(result.fetchall())

                # Mostrar resultados
                print("\n=== EMPLEADOS ELIMINADOS ===")
                if not resultados:
                    print("No se encontraron empleados eliminados.")
                    return

                for id_, nombre, cargo, deleted_at in resultados:
                    da = deleted_at if deleted_at is not None else "Fecha no registrada"
                    print(f"ID:{id_:<3} | Nombre:{nombre:<15} | Cargo:{cargo:<13} | Eliminado en:{da}")

    except mysql.connector.Error as e:
        print(f"Error al listar empleados eliminados: {e}")

def eliminar_fisicamente_empleado(id_empleado: int) -> None:
    """
    Elimina permanentemente un registro de empleado de la base de datos.
    Args:
    id_empleado (int): Identificador único del empleado a eliminar

    Nota:
    Esta acción es irreversible. Utiliza el procedimiento almacenado sp_borrado_fisico_empleado
    """
    try:
        with obtener_conexion() as conexion:
            with conexion.cursor() as cursor:
                # Ejecutar procedimiento almacenado
                cursor.callproc("sp_borrado_fisico_empleado", [id_empleado])

                # Confirmar la transacción
                conexion.commit()

                print(f"El empleado con ID {id_empleado} ha sido eliminado permanentemente de la base de datos")

    except mysql.connector.Error as e:
        print(f"Error al eliminar físicamente el empleado: {e}")

# ---------- INTERFAZ DE USUARIO ----------
def mostrar_menu_principal() -> None:
    """
    Despliega el menú principal del sistema y gestiona las interacciones del usuario.
    """
    while True:
        print("\n===== SISTEMA DE GESTIÓN DE EMPLEADOS =====")
        print("--- Operaciones CRUD ---")
        print("1) Registrar nuevo empleado")
        print("2) Ver empleados activos")
        print("3) Ver todos los empleados")
        print("4) Eliminar empleado (lógico)")
        print("5) Restaurar empleado eliminado")
        print("6) Actualizar datos de empleado")
        print("--- Operaciones de consulta ---")
        print("7) Buscar empleado por ID")
        print("8) Ver empleados eliminados")
        print("--- Operaciones permanentes ---")
        print("9) Eliminar empleado permanentemente")
        print("--------------------------------------")
        print("0) Salir del sistema")
        opcion = input("Seleccione una opción: ").strip()

        # Opción 1: Insertar nuevo empleado
        if opcion == "1":
            nombre = input("Nombre completo: ").strip()
            cargo = input("Cargo o posición: ").strip()

            if not nombre or not cargo:
                print("El nombre y el cargo son campos obligatorios")
                continue

            try:
                sueldo = float(input("Sueldo mensual (ej: 750000): ").strip())
                insertar_empleado(nombre, cargo, sueldo)
            except ValueError:
                print("El sueldo debe ser un valor numérico válido")

        # Opción 2: Listar empleados activos
        elif opcion == "2":
            listar_empleados_activos()

        # Opción 3: Listar todos los empleados
        elif opcion == "3":
            listar_todos_los_empleados()

        # Opción 4: Eliminación lógica
        elif opcion == "4":
            try:
                id_emp = int(input("ID del empleado a eliminar: ").strip())
                eliminar_logicamente_empleado(id_emp)
            except ValueError:
                print("El ID debe ser un número entero válido")

        # Opción 5: Restaurar empleado
        elif opcion == "5":
            try:
                id_emp = int(input("ID del empleado a restaurar: ").strip())
                restaurar_empleado(id_emp)
            except ValueError:
                print("El ID debe ser un número entero válido")

        # Opción 6: Actualizar empleado
        elif opcion == "6":
            try:
                id_emp = int(input("ID del empleado a actualizar: ").strip())

                print(f"\n--- Ingrese los nuevos datos para el empleado ID {id_emp} ---")
                nombre = input("Nuevo nombre: ").strip()
                cargo = input("Nuevo cargo: ").strip()

                if not nombre or not cargo:
                    print("El nombre y el cargo son campos obligatorios")
                    continue

                sueldo = float(input("Nuevo sueldo: ").strip())
                actualizar_datos_empleado(id_emp, nombre, cargo, sueldo)
            except ValueError:
                print("El ID y el sueldo deben ser valores numéricos válidos")

        # Opción 7: Buscar por ID
        elif opcion == "7":
            try:
                id_emp = int(input("ID del empleado a buscar: ").strip())
                buscar_empleado_por_id(id_emp)
            except ValueError:
                print("El ID debe ser un número entero válido")

        # Opción 8: Listar eliminados
        elif opcion == "8":
            listar_empleados_eliminados()

        # Opción 9: Eliminación física
        elif opcion == "9":
            try:
                id_emp = int(input("ID del empleado a eliminar permanentemente: ").strip())

                confirmacion = input(f"ADVERTENCIA: Está a punto de eliminar permanentemente el empleado ID {id_emp}. "
                                     "Esta acción no se puede deshacer. Escriba 'CONFIRMAR' para proceder: ").strip()

                if confirmacion == "CONFIRMAR":
                    eliminar_fisicamente_empleado(id_emp)
                else:
                    print("Operación cancelada")
            except ValueError:
                print("El ID debe ser un número entero válido")

        # Opción 0: Salir
        elif opcion == "0":
            print("Cerrando el sistema de gestión de empleados...")
            break

        # Opción no válida
        else:
            print("Opción no reconocida. Por favor, seleccione una opción válida del menú")

# ---------- PUNTO DE ENTRADA ----------
if __name__ == "__main__":
    mostrar_menu_principal()