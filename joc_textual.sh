#!/bin/bash

localizacion="inicio"
subzona=""
inventario=()
respuestas_erroneas=("No te entiendo..." "¿Qué dices?" "¡Eso no tiene sentido!")

mostrar_localizacion() {
    case $localizacion in
        "inicio")
            echo -e "Estás en el punto de inicio. Puedes ir a la ciudad o al bosque.";cat ciudad;cat bosque;cat cueva;sleep 2
            ;;
        "ciudad")
            echo -e "Estás en la ciudad. Puedes visitar el mercado o la taberna.";cat ciudad
            mostrar_submenu_ciudad
            ;;
        "bosque")
            echo -e "Estás en el bosque. Puedes ir al camino, al río o a la cabaña.";cat bosque
            mostrar_submenu_bosque
            ;;
        "cueva")
            echo -e "Estás en una cueva oscura.";cat cueva
            echo "¡Aquí hay un dragón peligroso!";cat dragon
	    sleep 2
            ;;
        "torre")
            echo -e "Estás en la torre. Hay un cofre misterioso."
            mostrar_submenu_torre
            ;;
    esac
    sleep 2
    clear
}

mostrar_submenu_ciudad() {
    while true; do
        echo -e "¿Dónde quieres ir?"
        echo "1. Mercado"
        echo "2. Taberna"
        echo "3. Volver"
        read -p "Elige una opción: " subopcion
        sleep 2
        clear
        case $subopcion in
            1) echo -e "Exploras el mercado y ves muchos artículos.";sleep 2;cat mercado ;;
            2) echo -e "Entras a la taberna y escuchas rumores sobre una espada mágica.";sleep 2;cat Taberna ;;
            3) break ;;
            *) echo "Opción no válida." ;;
        esac
    done
}

mostrar_submenu_bosque() {
    while true; do
        echo -e "¿Dónde quieres ir?"
        echo "1. Camino"
        echo "2. Río"
        echo "3. Cabaña"
        echo "4. Volver"
        read -p "Elige una opción: " subopcion
        sleep 2
        clear
        case $subopcion in
            1) echo -e "Sigues el camino y llegas a una torre misteriosa.";cat torre; localizacion="torre"; mostrar_submenu_torre; return ;;
            2) echo -e "Encuentras un río cristalino y bebes agua.";cat rio ;;
            3) echo -e "Entras a la cabaña y descansas un momento.";cat Cabanya ;;
            4) break ;;
            *) echo "Opción no válida." ;;
        esac
    done
}

mostrar_submenu_torre() {
    while true; do
        echo -e "¿Qué quieres hacer en la torre?"
        echo "1. Abrir el cofre";
        echo "2. Volver al bosque"
        read -p "Elige una opción: " subopcion
        sleep 2
        clear
        case $subopcion in
            1) abrir_cofre ;;
            2) mostrar_submenu_bosque; return ;;
            *) echo "Opción no válida." ;;
        esac
    done
}

abrir_cofre() {
    echo -e "Has encontrado un cofre misterioso. ¿Quieres abrirlo? (si/no)";cat cofre
    read -p "Elige una opción: " respuesta
    sleep 2
    clear
    if [[ "$respuesta" == "si" ]]; then
        if [[ " ${inventario[@]} " =~ " espada " ]]; then
            echo -e "Ya has abierto el cofre y tomado sus objetos."
        else
            echo -e "¡Has encontrado una espada mágica, una armadura y una poción de sanación!";cat espada;cat armadura;cat pocion
            inventario+=("espada" "armadura" "pocion")
        fi
    else
        echo -e "Decides no abrir el cofre."
    fi
}

comprobar_inventario() {
    if [ ${#inventario[@]} -eq 0 ]; then
        echo -e "Inventario vacío."
    else
        echo -e "Inventario: ${inventario[*]}"
    fi
	case $subopcion in
            1) mostrar_menu; return ;;
        esac
}

luchar() {
    if [ "$localizacion" != "cueva" ]; then
        echo -e "Aquí no hay nada con qué luchar."
        return
    fi
    sleep 2
    clear
    if [[ " ${inventario[@]} " =~ " espada " ]]; then
        echo -e "¡Has derrotado al dragón con la espada! ¡Has ganado el juego!";cat final;sleep 2
        exit 0
    else
        echo -e "El dragón te ha vencido... ¡Necesitas un arma!";cat derrota;sleep 2
    fi
}

mostrar_menu() {
    echo -e "¿Qué quieres hacer?"
    echo "1. Ir a la ciudad"
    echo "2. Ir al bosque"
    echo "3. Ir a la cueva"
    echo "4. Ver inventario"
    echo "5. Luchar"
    echo "6. Salir"
}

jugar() {
    while true; do
        mostrar_localizacion
        mostrar_menu
        read -p "Elige una opción: " opcion
        sleep 2
        clear
        case $opcion in
            1) localizacion="ciudad" ;;
            2) localizacion="bosque" ;;
            3) localizacion="cueva" ;;
            4) comprobar_inventario ;;
            5) luchar ;;
            6) echo -e "Saliendo del juego..."; exit 0 ;;
            *)
                respuesta_random=${respuestas_erroneas[$RANDOM % ${#respuestas_erroneas[@]}]}
                echo -e "$respuesta_random"
                ;;
        esac
    done
}

jugar
