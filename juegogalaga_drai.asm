title "Proyecto: Galaga" ;codigo opcional. Descripcion breve del programa, el texto entrecomillado se imprime como cabecera en cada página de código
	.model small	;directiva de modelo de memoria, small => 64KB para memoria de programa y 64KB para memoria de datos
	.386			;directiva para indicar version del procesador
	.stack 128 		;Define el tamano del segmento de stack, se mide en bytes
	.data			;Definicion del segmento de datos
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Definición de constantes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Valor ASCII de caracteres para el marco del programa
marcoEsqInfIzq 		equ 	200d 	;'╚'
marcoEsqInfDer 		equ 	188d	;'╝'
marcoEsqSupDer 		equ 	187d	;'╗'
marcoEsqSupIzq 		equ 	201d 	;'╔'
marcoCruceVerSup	equ		203d	;'╦'
marcoCruceHorDer	equ 	185d 	;'╣'
marcoCruceVerInf	equ		202d	;'╩'
marcoCruceHorIzq	equ 	204d 	;'╠'
marcoCruce 			equ		206d	;'╬'
marcoHor 			equ 	205d 	;'═'
marcoVer 			equ 	186d 	;'║'
;Atributos de color de BIOS
;Valores de color para carácter
cNegro 			equ		00h
cAzul 			equ		01h
cVerde 			equ 	02h
cCyan 			equ 	03h
cRojo 			equ 	04h
cMagenta 		equ		05h
cCafe 			equ 	06h
cGrisClaro		equ		07h
cGrisOscuro		equ		08h
cAzulClaro		equ		09h
cVerdeClaro		equ		0Ah
cCyanClaro		equ		0Bh
cRojoClaro		equ		0Ch
cMagentaClaro	equ		0Dh
cAmarillo 		equ		0Eh
cBlanco 		equ		0Fh
;Valores de color para fondo de carácter
bgNegro 		equ		00h
bgAzul 			equ		10h
bgVerde 		equ 	20h
bgCyan 			equ 	30h
bgRojo 			equ 	40h
bgMagenta 		equ		50h
bgCafe 			equ 	60h
bgGrisClaro		equ		70h
bgGrisOscuro	equ		80h
bgAzulClaro		equ		90h
bgVerdeClaro	equ		0A0h
bgCyanClaro		equ		0B0h
bgRojoClaro		equ		0C0h
bgMagentaClaro	equ		0D0h
bgAmarillo 		equ		0E0h
bgBlanco 		equ		0F0h
;Valores para delimitar el área de juego
lim_superior 	equ		1
lim_inferior 	equ		23
lim_izquierdo 	equ		1
lim_derecho 	equ		39
;Valores de referencia para la posición inicial del jugador
ini_columna 	equ 	lim_derecho/2
ini_renglon 	equ 	22

;Valores para la posición de los controles e indicadores dentro del juego
;Lives
lives_col 		equ  	lim_derecho+7
lives_ren 		equ  	4

;Scores
hiscore_ren	 	equ 	11
hiscore_col 	equ 	lim_derecho+7
score_ren	 	equ 	13
score_col 		equ 	lim_derecho+7

;Botón STOP
stop_col 		equ 	lim_derecho+10
stop_ren 		equ 	19
stop_izq 		equ 	stop_col-1
stop_der 		equ 	stop_col+1
stop_sup 		equ 	stop_ren-1
stop_inf 		equ 	stop_ren+1

;Botón PAUSE
pause_col 		equ 	stop_col+10
pause_ren 		equ 	19
pause_izq 		equ 	pause_col-1
pause_der 		equ 	pause_col+1
pause_sup 		equ 	pause_ren-1
pause_inf 		equ 	pause_ren+1

;Botón PLAY
play_col 		equ 	pause_col+10
play_ren 		equ 	19
play_izq 		equ 	play_col-1
play_der 		equ 	play_col+1
play_sup 		equ 	play_ren-1
play_inf 		equ 	play_ren+1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;////////////////////////////////////////////////////
;Definición de variables
;////////////////////////////////////////////////////
titulo 			db 		"GALAGA"
scoreStr 		db 		"SCORE"
hiscoreStr		db 		"HI-SCORE"
livesStr		db 		"LIVES"
blank			db 		"     "
player_lives 	db 		3
player_score 	dw 		0
player_hiscore 	dw 		0

player_col		db 		ini_columna 	;posicion en columna del jugador
player_ren		db 		ini_renglon 	;posicion en renglon del jugador

enemy_col1		db 		9 			 	;posicion en columna del enemigo 1
enemy_ren1		db 		3 				;posicion en renglon del enemigo 1
enemy_col2		db 		ini_columna 	;posicion en columna del enemigo 2
enemy_ren2		db 		3 				;posicion en renglon del enemigo 2
enemy_col3		db 		29  		 	;posicion en columna del enemigo 3 
enemy_ren3		db 		3 				;posicion en renglon del enemigo 3

shot_col		db 		ini_columna      ;posicion en columna del disparo (player)
shot_ren		db      ini_renglon-3    ;posicion en renglon del disparo (playe)

col_aux 		db 		0  		;variable auxiliar para operaciones con posicion - columna
ren_aux 		db 		0 		;variable auxiliar para operaciones con posicion - renglon

conta 			db 		0 		;contador
game_over  		db      0 		;variable para terminar el juego cuando el jugador ha agotado sus vidas
pause_val  		db      0       ;variable para detener el juego si stop es presionado

;; Variables de ayuda para lectura de tiempo del sistema
tick_ms			dw 		55 		;55 ms por cada tick del sistema, esta variable se usa para operación de MUL convertir ticks a segundos
mil				dw		1000 	;1000 auxiliar para operación DIV entre 1000
diez 			dw 		10 		;10 auxiliar para operaciones
sesenta			db 		60 		;60 auxiliar para operaciones
status 			db 		0 		;0 stop, 1 play, 2 pause
ticks 			dw		0 		;Variable para almacenar el número de ticks del sistema y usarlo como referencia
tiempo     		dw 		1       ;tiempo necesario para la interrupción 1Ah
enecol   		db 		0  		;si hay colisión con el enemigo, no volver a disparar
placol   		db      0       ;si hay colisión con el jugador, no volver a disparar
movcol    		db 		0   	;si hay colisión por movimiento, no volver a disparar
cambio  		db      0       ;cambia la dirección de izq a der del enemigo
pasos   		db      0 		;cuenta el número de desplazamientos horizontales que hizo el enemigo
bajar 	 		db      0 		;indica cuando el enemigo debe desplazarse hacia abajo

;Variables que sirven de parámetros de entrada para el procedimiento IMPRIME_BOTON
boton_caracter 	db 		0
boton_renglon 	db 		0
boton_columna 	db 		0
boton_color		db 		0
boton_bg_color	db 		0


;Auxiliar para calculo de coordenadas del mouse en modo Texto
ocho			db 		8
;Cuando el driver del mouse no está disponible
no_mouse		db 	'No se encuentra driver de mouse. Presione [enter] para salir$'

;////////////////////////////////////////////////////

;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;Macros;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;
;clear - Limpia pantalla
clear macro
	mov ax,0003h 	;ah = 00h, selecciona modo video
					;al = 03h. Modo texto, 16 colores
	int 10h		;llama interrupcion 10h con opcion 00h. 
				;Establece modo de video limpiando pantalla
endm

;posiciona_cursor - Cambia la posición del cursor a la especificada con 'renglon' y 'columna' 
posiciona_cursor macro renglon,columna
	mov dx,0
	mov dh,renglon	;dh = renglon
	mov dl,columna	;dl = columna
	mov bx,0
	mov ax,0200h 	;preparar ax para interrupcion, opcion 02h
	int 10h 		;interrupcion 10h y opcion 02h. Cambia posicion del cursor
endm 

;inicializa_ds_es - Inicializa el valor del registro DS y ES
inicializa_ds_es 	macro
	mov ax,@data
	mov ds,ax
	mov es,ax 		;Este registro se va a usar, junto con BP, para imprimir cadenas utilizando interrupción 10h
endm

;muestra_cursor_mouse - Establece la visibilidad del cursor del mouser
muestra_cursor_mouse	macro
	mov ax,1		;opcion 0001h
	int 33h			;int 33h para manejo del mouse. Opcion AX=0001h
					;Habilita la visibilidad del cursor del mouse en el programa
endm

;posiciona_cursor_mouse - Establece la posición inicial del cursor del mouse
posiciona_cursor_mouse	macro columna,renglon
	mov dx,renglon
	mov cx,columna
	mov ax,4		;opcion 0004h
	int 33h			;int 33h para manejo del mouse. Opcion AX=0001h
					;Habilita la visibilidad del cursor del mouse en el programa
endm

;oculta_cursor_teclado - Oculta la visibilidad del cursor del teclado
oculta_cursor_teclado	macro
	mov ah,01h 		;Opcion 01h
	mov cx,2607h 	;Parametro necesario para ocultar cursor
	int 10h 		;int 10, opcion 01h. Cambia la visibilidad del cursor del teclado
endm

;apaga_cursor_parpadeo - Deshabilita el parpadeo del cursor cuando se imprimen caracteres con fondo de color
;Habilita 16 colores de fondo
apaga_cursor_parpadeo	macro
	mov ax,1003h 		;Opcion 1003h
	xor bl,bl 			;BL = 0, parámetro para int 10h opción 1003h
  	int 10h 			;int 10, opcion 01h. Cambia la visibilidad del cursor del teclado
endm

;imprime_caracter_color - Imprime un caracter de cierto color en pantalla, especificado por 'caracter', 'color' y 'bg_color'. 
;Los colores disponibles están en la lista a continuacion;
; Colores:
; 0h: Negro
; 1h: Azul
; 2h: Verde
; 3h: Cyan
; 4h: Rojo
; 5h: Magenta
; 6h: Cafe
; 7h: Gris Claro
; 8h: Gris Oscuro
; 9h: Azul Claro
; Ah: Verde Claro
; Bh: Cyan Claro
; Ch: Rojo Claro
; Dh: Magenta Claro
; Eh: Amarillo
; Fh: Blanco
; utiliza int 10h opcion 09h
; 'caracter' - caracter que se va a imprimir
; 'color' - color que tomará el caracter
; 'bg_color' - color de fondo para el carácter en la celda
; Cuando se define el color del carácter, éste se hace en el registro BL:
; La parte baja de BL (los 4 bits menos significativos) define el color del carácter
; La parte alta de BL (los 4 bits más significativos) define el color de fondo "background" del carácter
imprime_caracter_color macro caracter,color,bg_color
	mov bx,0
	mov ax,0
	mov ah,09h				;preparar AH para interrupcion, opcion 09h
	mov al,caracter 		;AL = caracter a imprimir
	mov bh,0				;BH = numero de pagina
	mov bl,color 			
	or bl,bg_color 			;BL = color del caracter
							;'color' define los 4 bits menos significativos 
							;'bg_color' define los 4 bits más significativos 
	mov cx,1				;CX = numero de veces que se imprime el caracter
							;CX es un argumento necesario para opcion 09h de int 10h
	int 10h 				;int 10h, AH=09h, imprime el caracter en AL con el color BL
endm


;imprime_caracter_color - Imprime un caracter de cierto color en pantalla, especificado por 'caracter', 'color' y 'bg_color'. 
; utiliza int 10h opcion 09h
; 'cadena' - nombre de la cadena en memoria que se va a imprimir
; 'long_cadena' - longitud (en caracteres) de la cadena a imprimir
; 'color' - color que tomarán los caracteres de la cadena
; 'bg_color' - color de fondo para los caracteres en la cadena
imprime_cadena_color macro cadena,long_cadena,color,bg_color
	mov ah,13h				;preparar AH para interrupcion, opcion 13h
	lea bp,cadena 			;BP como apuntador a la cadena a imprimir
	mov bh,0				;BH = numero de pagina
	mov bl,color 			
	or bl,bg_color 			;BL = color del caracter
							;'color' define los 4 bits menos significativos 
							;'bg_color' define los 4 bits más significativos 
	mov cx,long_cadena		;CX = longitud de la cadena, se tomarán este número de localidades a partir del apuntador a la cadena
	int 10h 				;int 10h, AH=09h, imprime el caracter en AL con el color BL
endm
;lee_mouse - Revisa el estado del mouse
;Devuelve:
;;BX - estado de los botones
;;;Si BX = 0000h, ningun boton presionado
;;;Si BX = 0001h, boton izquierdo presionado
;;;Si BX = 0002h, boton derecho presionado
;;;Si BX = 0003h, boton izquierdo y derecho presionados
; (400,120) => 80x25 =>Columna: 400 x 80 / 640 = 50; Renglon: (120 x 25 / 200) = 15 => 50,15
;;CX - columna en la que se encuentra el mouse en resolucion 640x200 (columnas x renglones)
;;DX - renglon en el que se encuentra el mouse en resolucion 640x200 (columnas x renglones)
lee_mouse	macro
	mov ax,0003h
	int 33h
endm

;comprueba_mouse - Revisa si el driver del mouse existe
comprueba_mouse 	macro
	mov ax,0		;opcion 0
	int 33h			;llama interrupcion 33h para manejo del mouse, devuelve un valor en AX
					;Si AX = 0000h, no existe el driver. Si AX = FFFFh, existe driver
endm

;desplazamiento hacia la izquierda del jugador, presionar a o A
mover_izq macro
	;presionar a o A para moverse a la izquierda
	xor ax,ax
	int 16h 			;interrupción de teclado
	cmp al,41h 			;compara si se presiono A
	je izquierda
	xor ax,ax
	int 16h
	cmp al,61h    		;compara si se presiono a
	je izquierda
	jmp no_mov      	;si no se presiono, no se mueve
izquierda:
	mov bl,[player_col]
	sub bl,2d
	cmp bl,1 			;compra si el jugador se encuentra en el límite del área de juego
	je no_mov
	;se realiza el desplazamiento
	call BORRA_JUGADOR
	dec [player_col]
	call IMPRIME_JUGADOR
no_mov:
	;no ocurre el desplazamiento
	xor ax,ax
	lee_mouse
	cmp bx,0001h
	je mouse
endm

;desplazamiento hacia la izquierda del jugador, presionar d o D
mover_der macro
	;presionar d o D para moverse a la derecha
	xor ax,ax
	int 16h  			;interrupción de teclado
	cmp al,44h			;compara si se presiono D
	je derecha
	xor ax,ax
	int 16h
	cmp al,64h    		;compara si se presiono d
	je derecha
	jmp no_mov2    		;si no se presiono, no se mueve
derecha:
	mov bl,[player_col]
	add bl,2d
	cmp bl,39     		;compra si el jugador se encuentra en el límite del área de juego
	je no_mov2
	;se realiza el desplazamiento
	call BORRA_JUGADOR
	inc [player_col]
	call IMPRIME_JUGADOR
no_mov2:
	;no ocurre el desplazamiento
	xor ax,ax
	lee_mouse
	cmp bx,0001h
	je mouse
endm

;disparo por parte del jugador, presionar w o W
disparar macro
	;presionar w o W para disparar
	xor ax,ax
	int 16h 			;interrupción de teclado
	cmp al,57h  		;compara si se presiono W
	je disp
	xor ax,ax
	int 16h
	cmp al,77h  		;compara si se presiono w
	je disp
	jmp no_disp         ;si no se presiono, no dispara
disp:
	xor ax,ax
	mov bl,[player_col]
	mov [shot_col],bl   ;posicina el disparo en la misma columna
	mov bl,[player_ren]
	sub bl,3
	mov [shot_ren],bl   ;posiciona el disparo arriba del jugador
	call IMPRIME_SHOT   ;imprime el disparo
	ms:
		mov ah, 00h
		int 1Ah
		add dx,tiempo
		mov ticks,dx
		;espera cierto tiempo antes de borrar el disparo
		regreso_shot:
			int 1Ah
			cmp dx,ticks
			jne regreso_shot
			call BORRA_SHOT
		dec [shot_ren]      		;decrementa el renglón del disparo, provocanco que se desplace hacia arriba
		call IMPRIME_SHOT
		;comprueba si hubo alguna colisión con algún enemigo
		call colision_enemigo1      
		call colision_enemigo2
		call colision_enemigo3
		;si hubo colisión ya no vuelve a borrar el disparo
		cmp enecol,1
		je no_disp
		;se comprueba si el disparo se encuentra en el límte del área de juego
		cmp [shot_ren],3
		jne ms
		call BORRA_SHOT
no_disp:
	;no ocurre el desplazamiento
	mov enecol,0
	xor ax,ax
	lee_mouse
	cmp bx,0001h
	je mouse
endm

;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;Fin Macros;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;

	.code
inicio:					;etiqueta inicio
	inicializa_ds_es
	comprueba_mouse		;macro para revisar driver de mouse
	xor ax,0FFFFh		;compara el valor de AX con FFFFh, si el resultado es zero, entonces existe el driver de mouse
	jz imprime_ui		;Si existe el driver del mouse, entonces salta a 'imprime_ui'
	;Si no existe el driver del mouse entonces se muestra un mensaje
	lea dx,[no_mouse]
	mov ax,0900h	;opcion 9 para interrupcion 21h
	int 21h			;interrupcion 21h. Imprime cadena.
	jmp teclado		;salta a 'teclado'
imprime_ui:
	clear 					;limpia pantalla
	oculta_cursor_teclado	;oculta cursor del mouse
	apaga_cursor_parpadeo 	;Deshabilita parpadeo del cursor
	call DIBUJA_UI 			;procedimiento que dibuja marco de la interfaz
	muestra_cursor_mouse 	;hace visible el cursor del mouse

;En "mouse_no_clic" se revisa que el boton izquierdo del mouse no esté presionado
;Si el botón está suelto, continúa a la sección "mouse"
;si no, se mantiene indefinidamente en "mouse_no_clic" hasta que se suelte
mouse_no_clic:
	lee_mouse
	test bx,0001h
	jnz mouse_no_clic
;Lee el mouse y avanza hasta que se haga clic en el boton izquierdo
mouse:
	lee_mouse
	conversion_mouse:
	;Leer la posicion del mouse y hacer la conversion a resolucion
	;80x25 (columnas x renglones) en modo texto
	mov ax,dx 			;Copia DX en AX. DX es un valor entre 0 y 199 (renglon)
	div [ocho] 			;Division de 8 bits
						;divide el valor del renglon en resolucion 640x200 en donde se encuentra el mouse
						;para obtener el valor correspondiente en resolucion 80x25
	xor ah,ah 			;Descartar el residuo de la division anterior
	mov dx,ax 			;Copia AX en DX. AX es un valor entre 0 y 24 (renglon)

	mov ax,cx 			;Copia CX en AX. CX es un valor entre 0 y 639 (columna)
	div [ocho] 			;Division de 8 bits
						;divide el valor de la columna en resolucion 640x200 en donde se encuentra el mouse
						;para obtener el valor correspondiente en resolucion 80x25
	xor ah,ah 			;Descartar el residuo de la division anterior
	mov cx,ax 			;Copia AX en CX. AX es un valor entre 0 y 79 (columna)

	;Aquí se revisa si se hizo clic en el botón izquierdo
	test bx,0001h 		;Para revisar si el boton izquierdo del mouse fue presionado
	jz mouse 			;Si el boton izquierdo no fue presionado, vuelve a leer el estado del mouse
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Aqui va la lógica de la posicion del mouse;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;Si el mouse fue presionado en el renglon 0
	;se va a revisar si fue dentro del boton [X]
	cmp dx,0
	je boton_x

	jmp mas_botones1
boton_x:
	jmp boton_x1

;Lógica para revisar si el mouse fue presionado en [X]
;[X] se encuentra en renglon 0 y entre columnas 76 y 78
boton_x1:
	cmp cx,76
	jge boton_x2
	jmp mas_botones1
boton_x2:
	cmp cx,78
	jbe boton_x3
	jmp mas_botones1
boton_x3:
	;Se cumplieron todas las condiciones
	jmp salir

;Lógica para revisar si el mouse fue presionado en el boton de stop
;stop se encuentra entre los renglones 19, 20 y 21 y entre columnas 49 y 51
mas_botones1:
	cmp dx,19
	je boton_stop
	cmp dx,20
	je boton_stop
	cmp dx,21
	je boton_stop
	jmp mas_botones2
boton_stop:
	cmp cx,49
	jge boton_stop2
	jmp mas_botones2
boton_stop2:
	cmp cx,51
	jbe boton_stop3
	jmp mas_botones2
boton_stop3:
	;Se cumplieron todas las condiciones
	;vuelve a empezar el juego con los valores iniciales
	mov enemy_col1,9 			 	
	mov enemy_ren1,3 				
	mov enemy_col2,ini_columna 	
	mov enemy_ren2,3 				
	mov enemy_col3,29  		 	
	mov enemy_ren3,3 				
	jmp inicio

;Lógica para revisar si el mouse fue presionado en el boton de pause
;pause se encuentra entre los renglones 19, 20 y 21 y entre columnas 59 y 61
mas_botones2:
	cmp dx,19
	je boton_pause
	cmp dx,20
	je boton_pause
	cmp dx,21
	je boton_pause
	jmp mas_botones3
boton_pause:
	cmp cx,59
	jge boton_pause2
	jmp play
boton_pause2:
	cmp cx,61
	jbe boton_pause3
	jmp mas_botones3
boton_pause3:
	;Se cumplieron todas las condiciones
	;pausa el juego en el momento en donde se encuentre
	inc [pause_val]
	cmp [pause_val],2
	jae play
	jmp mouse_no_clic

;Lógica para revisar si el mouse fue presionado en el boton de play
;play se encuentra entre los renglones 19, 20 y 21 y entre columnas 69 y 71
mas_botones3:
	cmp dx,19
	je boton_play
	cmp dx,20
	je boton_play
	cmp dx,21
	je boton_play
	jmp mouse_no_clic
boton_play:
	cmp cx,69
	jge boton_play2
	jmp mouse_no_clic
boton_play2:
	cmp cx,71
	jbe boton_play3
	jmp mouse_no_clic
boton_play3:
	;Se cumplieron todas las condiciones
	mov player_lives,3      	;inicia las vidas del jugador
	mov game_over,0  			;desactiva el game over
	mov si, player_score  		;guarda el player score
	mov player_score,0          ;reinicia el valore de player score
	call IMPRIME_SCORE
	cmp player_hiscore, si      ;hi score < score
	jb score_mod  				;si se cumple, cambia el hi score
	jmp play  
score_mod:
	mov player_hiscore,si       ;guarda el nuevo valor de hi score
	call BORRA_SCORES           ;actualiza el valor de los score en pantalla
	call IMPRIME_SCORES
	jmp play

play:
	call IMPRIME_LIVES 			;imprime en pantalla los valores que se tengan de lives
	mov [pause_val],0           ;actualiza el valor de pausa
	xor ax,ax
	lee_mouse
	cmp bx,0001h  				;comprueba si el mouse fue presionado
	je mouse    				;revisa que boton fue presionado
	mover_izq                   ;movimiento a la izquierda del jugador
	mover_der                   ;movimiento a la derecha del jugador
	disparar  					;disparo del jugador
	xor ax,ax
	lee_mouse
	cmp bx,0001h
	je mouse
	call enemigo_activo         ;activa al enemigo
	cmp game_over,1    			;comprueba si ocurrio un game over
	je mouse_no_clic  			;termina el juego
	xor ax,ax
	lee_mouse
	cmp bx,0001h
	je mouse
	int 16h  					;interrupción de teclado
	cmp al,1Bh 					;comprueba si Esc fue presionado
	jne play                    ;si no fue presionado, continua con el ciclo infinito del programa
	jmp mouse_no_clic 
	
;Si no se encontró el driver del mouse, muestra un mensaje y el usuario debe salir tecleando [enter]
teclado:
	mov ah,08h
	int 21h
	cmp al,0Dh		;compara la entrada de teclado si fue [enter]
	jnz teclado 	;Sale del ciclo hasta que presiona la tecla [enter]

salir:				;inicia etiqueta salir
	clear 			;limpia pantalla
	mov ax,4C00h	;AH = 4Ch, opción para terminar programa, AL = 0 Exit Code, código devuelto al finalizar el programa
	int 21h			;señal 21h de interrupción, pasa el control al sistema operativo

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;PROCEDIMIENTOS;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	DIBUJA_UI proc
		;imprimir esquina superior izquierda del marco
		posiciona_cursor 0,0
		imprime_caracter_color marcoEsqSupIzq,cAmarillo,bgNegro
		
		;imprimir esquina superior derecha del marco
		posiciona_cursor 0,79
		imprime_caracter_color marcoEsqSupDer,cAmarillo,bgNegro
		
		;imprimir esquina inferior izquierda del marco
		posiciona_cursor 24,0
		imprime_caracter_color marcoEsqInfIzq,cAmarillo,bgNegro
		
		;imprimir esquina inferior derecha del marco
		posiciona_cursor 24,79
		imprime_caracter_color marcoEsqInfDer,cAmarillo,bgNegro
		
		;imprimir marcos horizontales, superior e inferior
		mov cx,78 		;CX = 004Eh => CH = 00h, CL = 4Eh 
	marcos_horizontales:
		mov [col_aux],cl
		;Superior
		posiciona_cursor 0,[col_aux]
		imprime_caracter_color marcoHor,cAmarillo,bgNegro
		;Inferior
		posiciona_cursor 24,[col_aux]
		imprime_caracter_color marcoHor,cAmarillo,bgNegro
		
		mov cl,[col_aux]
		loop marcos_horizontales

		;imprimir marcos verticales, derecho e izquierdo
		mov cx,23 		;CX = 0017h => CH = 00h, CL = 17h 
	marcos_verticales:
		mov [ren_aux],cl
		;Izquierdo
		posiciona_cursor [ren_aux],0
		imprime_caracter_color marcoVer,cAmarillo,bgNegro
		;Inferior
		posiciona_cursor [ren_aux],79
		imprime_caracter_color marcoVer,cAmarillo,bgNegro
		;Limite mouse
		posiciona_cursor [ren_aux],lim_derecho+1
		imprime_caracter_color marcoVer,cAmarillo,bgNegro

		mov cl,[ren_aux]
		loop marcos_verticales

		;imprimir marcos horizontales internos
		mov cx,79-lim_derecho-1 		
	marcos_horizontales_internos:
		push cx
		mov [col_aux],cl
		add [col_aux],lim_derecho
		;Interno superior 
		posiciona_cursor 8,[col_aux]
		imprime_caracter_color marcoHor,cAmarillo,bgNegro

		;Interno inferior
		posiciona_cursor 16,[col_aux]
		imprime_caracter_color marcoHor,cAmarillo,bgNegro

		mov cl,[col_aux]
		pop cx
		loop marcos_horizontales_internos

		;imprime intersecciones internas	
		posiciona_cursor 0,lim_derecho+1
		imprime_caracter_color marcoCruceVerSup,cAmarillo,bgNegro
		posiciona_cursor 24,lim_derecho+1
		imprime_caracter_color marcoCruceVerInf,cAmarillo,bgNegro

		posiciona_cursor 8,lim_derecho+1
		imprime_caracter_color marcoCruceHorIzq,cAmarillo,bgNegro
		posiciona_cursor 8,79
		imprime_caracter_color marcoCruceHorDer,cAmarillo,bgNegro

		posiciona_cursor 16,lim_derecho+1
		imprime_caracter_color marcoCruceHorIzq,cAmarillo,bgNegro
		posiciona_cursor 16,79
		imprime_caracter_color marcoCruceHorDer,cAmarillo,bgNegro

		;imprimir [X] para cerrar programa
		posiciona_cursor 0,76
		imprime_caracter_color '[',cAmarillo,bgNegro
		posiciona_cursor 0,77
		imprime_caracter_color 'X',cRojoClaro,bgNegro
		posiciona_cursor 0,78
		imprime_caracter_color ']',cAmarillo,bgNegro

		;imprimir título
		posiciona_cursor 0,37
		imprime_cadena_color [titulo],6,cAmarillo,bgNegro

		call IMPRIME_TEXTOS

		call IMPRIME_BOTONES

		call IMPRIME_DATOS_INICIALES

		call IMPRIME_SCORES

		call IMPRIME_LIVES

		ret
	endp

	IMPRIME_TEXTOS proc
		;Imprime cadena "LIVES"
		posiciona_cursor lives_ren,lives_col
		imprime_cadena_color livesStr,5,cGrisClaro,bgNegro

		;Imprime cadena "SCORE"
		posiciona_cursor score_ren,score_col
		imprime_cadena_color scoreStr,5,cGrisClaro,bgNegro

		;Imprime cadena "HI-SCORE"
		posiciona_cursor hiscore_ren,hiscore_col
		imprime_cadena_color hiscoreStr,8,cGrisClaro,bgNegro
		ret
	endp

	IMPRIME_BOTONES proc
		;Botón STOP
		mov [boton_caracter],254d		;Carácter '■'
		mov [boton_color],bgAmarillo 	;Background amarillo
		mov [boton_renglon],stop_ren 	;Renglón en "stop_ren"
		mov [boton_columna],stop_col 	;Columna en "stop_col"
		call IMPRIME_BOTON 				;Procedimiento para imprimir el botón
		;Botón PAUSE
		mov [boton_caracter],19d 		;Carácter '‼'
		mov [boton_color],bgAmarillo 	;Background amarillo
		mov [boton_renglon],pause_ren 	;Renglón en "pause_ren"
		mov [boton_columna],pause_col 	;Columna en "pause_col"
		call IMPRIME_BOTON 				;Procedimiento para imprimir el botón
		;Botón PLAY
		mov [boton_caracter],16d  		;Carácter '►'
		mov [boton_color],bgAmarillo 	;Background amarillo
		mov [boton_renglon],play_ren 	;Renglón en "play_ren"
		mov [boton_columna],play_col 	;Columna en "play_col"
		call IMPRIME_BOTON 				;Procedimiento para imprimir el botón
		ret
	endp

	IMPRIME_SCORES proc
		;Imprime el valor de la variable player_score en una posición definida
		call IMPRIME_SCORE
		;Imprime el valor de la variable player_hiscore en una posición definida
		call IMPRIME_HISCORE
		ret
	endp

	IMPRIME_SCORE proc
		;Imprime "player_score" en la posición relativa a 'score_ren' y 'score_col'
		mov [ren_aux],score_ren
		mov [col_aux],score_col+20
		mov bx,[player_score]
		call IMPRIME_BX
		ret
	endp

	IMPRIME_HISCORE proc
	;Imprime "player_score" en la posición relativa a 'hiscore_ren' y 'hiscore_col'
		mov [ren_aux],hiscore_ren
		mov [col_aux],hiscore_col+20
		mov bx,[player_hiscore]
		call IMPRIME_BX
		ret
	endp

	;BORRA_SCORES borra los marcadores numéricos de pantalla sustituyendo la cadena de números por espacios
	BORRA_SCORES proc
		call BORRA_SCORE
		call BORRA_HISCORE
		ret
	endp

	BORRA_SCORE proc
		posiciona_cursor score_ren,score_col+20 		;posiciona el cursor relativo a score_ren y score_col
		imprime_cadena_color blank,5,cBlanco,bgNegro 	;imprime cadena blank (espacios) para "borrar" lo que está en pantalla
		ret
	endp

	BORRA_HISCORE proc
		posiciona_cursor hiscore_ren,hiscore_col+20 	;posiciona el cursor relativo a hiscore_ren y hiscore_col
		imprime_cadena_color blank,5,cBlanco,bgNegro 	;imprime cadena blank (espacios) para "borrar" lo que está en pantalla
		ret
	endp

	;Imprime el valor del registro BX como entero sin signo (positivo)
	;Se imprime con 5 dígitos (incluyendo ceros a la izquierda)
	;Se usan divisiones entre 10 para obtener dígito por dígito en un LOOP 5 veces (una por cada dígito)
	IMPRIME_BX proc
		mov ax,bx
		mov cx,5
	div10:
		xor dx,dx
		div [diez]
		push dx
		loop div10
		mov cx,5
	imprime_digito:
		mov [conta],cl
		posiciona_cursor [ren_aux],[col_aux]
		pop dx
		or dl,30h
		imprime_caracter_color dl,cBlanco,bgNegro
		xor ch,ch
		mov cl,[conta]
		inc [col_aux]
		loop imprime_digito
		ret
	endp

	IMPRIME_DATOS_INICIALES proc
		call DATOS_INICIALES 		;inicializa variables de juego
		;imprime la 'nave' del jugador
		;borra la posición actual, luego se reinicia la posición y entonces se vuelve a imprimir
		call BORRA_JUGADOR
		mov [player_col], ini_columna
		mov [player_ren], ini_renglon
		;Imprime jugador
		call IMPRIME_JUGADOR

		;Borrar posicion actual del enemigo y reiniciar su posicion

		;Imprime enemigo
		call IMPRIME_ENEMIGO1
		call IMPRIME_ENEMIGO2
		call IMPRIME_ENEMIGO3
		ret
	endp

	;Inicializa variables del juego
	DATOS_INICIALES proc
		mov [player_score],0
		mov [player_lives], 3
		ret
	endp

	;Imprime los caracteres ☻ que representan vidas. Inicialmente se imprime el número de 'player_lives'
	IMPRIME_LIVES proc
		xor cx,cx
		mov di,lives_col+20
		mov cl,[player_lives]
		cmp cl,0    			;comprueba si las vidas=0
		jbe over 				;si vidas <= o, no vuelve a imprimir las vidas
	imprime_live:
		push cx
		mov ax,di
		posiciona_cursor lives_ren,al
		imprime_caracter_color 2d,cCyanClaro,bgNegro
		add di,2
		pop cx
		loop imprime_live
		jmp retu
	over:
		mov game_over,1 		;como las vidas se acabaron, actualiza el valor de game over para que finalice el juego
	retu:
		ret
	endp

	BORRA_LIVES proc
		xor cx,cx
		mov di,lives_col+20
		mov cl,[player_lives]
		cmp cl,0
		jbe retu2
	borra_live:
		push cx
		mov ax,di
		posiciona_cursor lives_ren,al
		imprime_caracter_color 2d,cNegro,bgNegro
		add di,2
		pop cx
		loop borra_live
		jmp retu2
	retu2:
		ret
	endp

	;Imprime la nave del jugador, que recibe como parámetros las variables ren_aux y col_aux, que indican la posición central inferior
	PRINT_PLAYER proc

		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 219,cBlanco,bgNegro
		dec [ren_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 219,cBlanco,bgNegro
		dec [ren_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 219,cBlanco,bgNegro
		add [ren_aux],2
		
		dec [col_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 219,cBlanco,bgNegro
		dec [ren_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 219,cBlanco,bgNegro
		inc [ren_aux]
		
		dec [col_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 219,cBlanco,bgNegro
		
		add [col_aux],3
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 219,cBlanco,bgNegro
		dec [ren_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 219,cBlanco,bgNegro
		inc [ren_aux]
		
		inc [col_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 219,cBlanco,bgNegro
		ret
	endp

	;Borra la nave del jugador, que recibe como parámetros las variables ren_aux y col_aux, que indican la posición central de la barra
	DELETE_PLAYER proc

		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 219,cNegro,bgNegro
		dec [ren_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 219,cNegro,bgNegro
		dec [ren_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 219,cNegro,bgNegro
		add [ren_aux],2
		
		dec [col_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 219,cNegro,bgNegro
		dec [ren_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 219,cNegro,bgNegro
		inc [ren_aux]
		
		dec [col_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 219,cNegro,bgNegro
		
		add [col_aux],3
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 219,cNegro,bgNegro
		dec [ren_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 219,cNegro,bgNegro
		inc [ren_aux]
		
		inc [col_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 219,cNegro,bgNegro
		ret
	endp

	;Imprime la nave del enemigo, que recibe como parámetros las variables ren_aux y col_aux, que indican la posición central inferior
	PRINT_ENEMY proc

		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 178,cRojo,bgNegro
		inc [ren_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 178,cRojo,bgNegro
		inc [ren_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 178,cRojo,bgNegro
		sub [ren_aux],2
		
		dec [col_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 178,cRojo,bgNegro
		inc [ren_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 178,cRojo,bgNegro
		dec [ren_aux]
		
		dec [col_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 178,cRojo,bgNegro
		
		add [col_aux],3
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 178,cRojo,bgNegro
		inc [ren_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 178,cRojo,bgNegro
		dec [ren_aux]
		
		inc [col_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 178,cRojo,bgNegro
		ret
	endp

	;Borra la nave del enemigo, que recibe como parámetros las variables ren_aux y col_aux, que indican la posición central inferior
	DELETE_ENEMY proc
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 178,cNegro,bgNegro
		inc [ren_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 178,cNegro,bgNegro
		inc [ren_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 178,cNegro,bgNegro
		sub [ren_aux],2
		
		dec [col_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 178,cNegro,bgNegro
		inc [ren_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 178,cNegro,bgNegro
		dec [ren_aux]
		
		dec [col_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 178,cNegro,bgNegro
		
		add [col_aux],3
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 178,cNegro,bgNegro
		inc [ren_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 178,cNegro,bgNegro
		dec [ren_aux]
		
		inc [col_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 178,cNegro,bgNegro
		ret
	endp

	;Imprime el disparo, que recibe como parámetros las variables ren_aux y col_aux, que indican la posición central inferior
	PRINT_SHOT proc
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 219,cVerdeClaro,bgNegro
		dec [ren_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 219,cVerdeClaro,bgNegro
	endp

	;Borra el disparo, que recibe como parámetros las variables ren_aux y col_aux, que indican la posición central inferior
	DELETE_SHOT proc
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 219,cNegro,bgNegro
		dec [ren_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 219,cNegro,bgNegro
	endp

	;procedimiento IMPRIME_BOTON
	;Dibuja un boton que abarca 3 renglones y 5 columnas
	;con un caracter centrado dentro del boton
	;en la posición que se especifique (esquina superior izquierda)
	;y de un color especificado
	;Utiliza paso de parametros por variables globales
	;Las variables utilizadas son:
	;boton_caracter: debe contener el caracter que va a mostrar el boton
	;boton_renglon: contiene la posicion del renglon en donde inicia el boton
	;boton_columna: contiene la posicion de la columna en donde inicia el boton
	;boton_color: contiene el color del boton
	IMPRIME_BOTON proc
	 	;background de botón
		mov ax,0600h 		;AH=06h (scroll up window) AL=00h (borrar)
		mov bh,cRojo	 	;Caracteres en color amarillo
		xor bh,[boton_color]
		mov ch,[boton_renglon]
		mov cl,[boton_columna]
		mov dh,ch
		add dh,2
		mov dl,cl
		add dl,2
		int 10h
		mov [col_aux],dl
		mov [ren_aux],dh
		dec [col_aux]
		dec [ren_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color [boton_caracter],cRojo,[boton_color]
	 	ret 			;Regreso de llamada a procedimiento
	endp	 			;Indica fin de procedimiento UI para el ensamblador
	
	BORRA_JUGADOR proc
		mov al,[player_col]
		mov ah,[player_ren]
		mov [col_aux],al
		mov [ren_aux],ah
		call DELETE_PLAYER
		ret
	endp

	IMPRIME_JUGADOR proc
		mov al,[player_col]
		mov ah,[player_ren]
		mov [col_aux],al
		mov [ren_aux],ah
		call PRINT_PLAYER
		ret
	endp

	BORRA_ENEMIGO1 proc
		mov al,[enemy_col1]
		mov ah,[enemy_ren1]
		mov [col_aux],al
		mov [ren_aux],ah
		call DELETE_ENEMY
		ret
	endp

	IMPRIME_ENEMIGO1 proc
		mov al,[enemy_col1]
		mov ah,[enemy_ren1]
		mov [col_aux],al
		mov [ren_aux],ah
		call PRINT_ENEMY
		ret
	endp

	BORRA_ENEMIGO2 proc
		mov al,[enemy_col2]
		mov ah,[enemy_ren2]
		mov [col_aux],al
		mov [ren_aux],ah
		call DELETE_ENEMY
		ret
	endp

	IMPRIME_ENEMIGO2 proc
		mov al,[enemy_col2]
		mov ah,[enemy_ren2]
		mov [col_aux],al
		mov [ren_aux],ah
		call PRINT_ENEMY
		ret
	endp

	BORRA_ENEMIGO3 proc
		mov al,[enemy_col3]
		mov ah,[enemy_ren3]
		mov [col_aux],al
		mov [ren_aux],ah
		call DELETE_ENEMY
		ret
	endp

	IMPRIME_ENEMIGO3 proc
		mov al,[enemy_col3]
		mov ah,[enemy_ren3]
		mov [col_aux],al
		mov [ren_aux],ah
		call PRINT_ENEMY
		ret
	endp


	BORRA_SHOT proc
		mov al,[shot_col]
		mov ah,[shot_ren]
		mov [col_aux],al
		mov [ren_aux],ah
		call DELETE_SHOT
		ret
	endp

	IMPRIME_SHOT proc
		mov al,[shot_col]
		mov ah,[shot_ren]
		mov [col_aux],al
		mov [ren_aux],ah
		call PRINT_SHOT
		ret
	endp

	enemigo_activo proc
		mov ah, 00h
		int 1Ah
		add dx,tiempo
		mov ticks,dx
		add ticks,4
		;espera un tiempo antes de mover las naves enemigas
		regreso_enemydisp:
			int 1Ah
			cmp dx,ticks
			jne regreso_enemydisp
			;provoca un desplazamiento de las naves enemigas
			call movimiento1 	;enemigo de la columna 9
			call movimiento2 	;enemigo de la columna 19
			call movimiento3    ;enemigo de la columna 29
			;disparo de las naves enemigas
			call disp_enemigo1  ;enemigo de la columna 9
			call disp_enemigo2  ;enemigo de la columna 19
			call disp_enemigo3  ;enemigo de la columna 29
 		ret
	endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;PROCEDIMIENTOS de los tres enemigos;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;misma implementacion que el movimiento del jugador, pero con ciertos cambios
	movimiento1 proc
		ms31:
			mov ah, 00h
			int 1Ah
			add dx,tiempo
			mov ticks,dx
			add ticks,1
			regreso_enemy1:
				int 1Ah
				cmp dx,ticks
				jne regreso_enemy1
				call BORRA_ENEMIGO1
			cmp cambio,1  				;comprueba si se mueve a la derecha
			je der_mov1
			mov bl,[enemy_col1]
			sub bl,2d
			cmp bl,1   					;comprueba si se encuentra en el límite del área de juego
			je der_mov01 				;si se encuentra en dicho límite, cambia el desplazamiento hacia la derecha
			cmp bajar,2  				;comprueba si tiene que hacer un desplazamiento vértical
			je izq_mov01
			jmp izq_mov1  				;realiza un desplazamiento hacia la izquierda
			izq_mov01:
			inc [enemy_ren1]    		;realiza un desplazamiento vértical hacia abajo
			izq_mov1:
			mov cambio,0          		;activa el desplazamiento a la izquierda
			dec [enemy_col1]   			;realiza el desplazamiento a la izquierda
			jmp exit1
			der_mov01:
			inc [enemy_ren1]  			;realiza un desplazamiento vértical hacia abajo
			mov bajar,1 				;variable que indica que los otros dos enemigos deben realizar un desplazamiento vértical
			der_mov1:
			mov cambio,1  				;activa el desplazamiento a la derecha
			inc [enemy_col1]   			;realiza el desplazamiento a la derecha
			exit1:
			call IMPRIME_ENEMIGO1 		;imprime al enemigo con los despalzamientos
			call colision_playermov1    ;comprueba si hay una colisión con el jugador
			cmp movcol,1
			je no_disp31
			mov dl,[enemy_ren1]
			add dl,2d
			cmp dl,21 					;comprueba si se encuentra en el límte del área de juego
			je lim1
			jmp no_disp31
		lim1:
			;borra al enemigo, y lo imprime en su renglón inicial
			call BORRA_ENEMIGO1
			mov [enemy_ren1],3
			call IMPRIME_ENEMIGO1
		no_disp31:
			;no se mueve
			mov movcol,0
			ret
	endp

	movimiento2 proc
		ms32:
			mov ah, 00h
			int 1Ah
			add dx,tiempo
			mov ticks,dx
			add ticks,1
			regreso_enemy2:
				int 1Ah
				cmp dx,ticks
				jne regreso_enemy2
				call BORRA_ENEMIGO2
			cmp bajar,1
			je der_mov02
			cmp bajar,2
			je izq_mov02
			cmp cambio,1
			je der_mov2
			jmp izq_mov2
			izq_mov02:
			inc [enemy_ren2]
			mov bajar,0
			izq_mov2:
			mov cambio,0
			dec [enemy_col2]
			jmp exit2
			der_mov02:
			inc [enemy_ren2]
			der_mov2:
			mov cambio,1
			inc [enemy_col2]
			exit2:
			call IMPRIME_ENEMIGO2
			call colision_playermov2
			cmp movcol,1
			je no_disp32
			mov dl,[enemy_ren2]
			add dl,2d
			cmp dl,21
			je lim2
			jmp no_disp32
		lim2:
			call BORRA_ENEMIGO2
			mov [enemy_ren2],3
			call IMPRIME_ENEMIGO2
		no_disp32:
			mov movcol,0
			ret
	endp

	movimiento3 proc
		ms33:
			mov ah, 00h
			int 1Ah
			add dx,tiempo
			mov ticks,dx
			add ticks,1
			regreso_enemy3:
				int 1Ah
				cmp dx,ticks
				jne regreso_enemy3
				call BORRA_ENEMIGO3
			cmp bajar,1
			je der_mov03
			mov bl,[enemy_col3]
			add bl,2d
			cmp bl,39
			je izq_mov03
			cmp cambio,1
			je der_mov3
			jmp izq_mov3
			izq_mov03:
			inc [enemy_ren3]
			mov bajar,2
			izq_mov3:
			mov cambio,0
			dec [enemy_col3]
			jmp exit3
			der_mov03:
			inc [enemy_ren3]
			mov bajar,0
			der_mov3:
			mov cambio,1
			inc [enemy_col3]
			exit3:
			call IMPRIME_ENEMIGO3
			call colision_playermov3
			cmp movcol,1
			je no_disp33
			mov dl,[enemy_ren3]
			add dl,2d
			cmp dl,21
			je lim3
			jmp no_disp33
		lim3:
			call BORRA_ENEMIGO3
			mov [enemy_ren3],3
			call IMPRIME_ENEMIGO3
		no_disp33:
			mov movcol,0
			inc [pasos] 		;incrementa el núm de pasos para el disparo
			ret
	endp

;el dispero funciona de forma similar al del jugador, pero con ciertos cambios
	disp_enemigo1 proc
		cmp pasos,3
		jne no_disp21 						;comprueba si ocurrieron tres pasos, ya que el enemigo dispara cada tres pasos
		mov bl,[enemy_col1]
		mov [shot_col],bl
		mov bl,[enemy_ren1]
		add bl,5
		mov [shot_ren],bl
		call IMPRIME_SHOT
		ms21:
			mov ah, 00h
			int 1Ah
			add dx,tiempo
			mov ticks,dx
			regreso_shotenemy1:
				int 1Ah
				cmp dx,ticks
				jne regreso_shotenemy1
				call BORRA_SHOT
			inc [shot_ren]    				;provoca un desplazamiento hacia abajo
			mov dl,[enemy_ren1]
			add dl,2
			cmp dl,20 						;comrpueba si se encuentra en el límte del área de juego, en esta ocasión no se vuelve a imprimir
			je no_disp21
			call IMPRIME_SHOT
			call colision_player 			;comprueba si ocurrio una colisión con el jugador, para este procedimiento es el mismo para los tres enemigos
			cmp placol,1
			je no_disp21
			mov dl,[shot_ren]
			add dl,2
			cmp dl,23  						;comrpueba si se encuentra en el límte del área de juego
			jnae ms21
			call BORRA_SHOT
	no_disp21:
		;ya no dispara
		mov placol,0
	ret
	endp

	disp_enemigo2 proc
		cmp pasos,3
		jne no_disp22
		mov bl,[enemy_col2]
		mov [shot_col],bl
		mov bl,[enemy_ren2]
		add bl,5
		mov [shot_ren],bl
		call IMPRIME_SHOT
		ms22:
			mov ah, 00h
			int 1Ah
			add dx,tiempo
			mov ticks,dx
			regreso_shotenemy2:
				int 1Ah
				cmp dx,ticks
				jne regreso_shotenemy2
				call BORRA_SHOT
			inc [shot_ren]
			mov dl,[enemy_ren2]
			add dl,2
			cmp dl,20
			je no_disp22
			call IMPRIME_SHOT
			call colision_player
			cmp placol,1
			je no_disp22
			mov dl,[shot_ren]
			add dl,2
			cmp dl,23
			jnae ms22
			call BORRA_SHOT
	no_disp22:
		mov placol,0
	ret
	endp

	disp_enemigo3 proc
		cmp pasos,3
		jne no_disp23
		mov pasos,0  				;reinicia el núm de pasos
		mov bl,[enemy_col3]
		mov [shot_col],bl
		mov bl,[enemy_ren3]
		add bl,5
		mov [shot_ren],bl
		call IMPRIME_SHOT
		ms23:
			mov ah, 00h
			int 1Ah
			add dx,tiempo
			mov ticks,dx
			regreso_shotenemy3:
				int 1Ah
				cmp dx,ticks
				jne regreso_shotenemy3
				call BORRA_SHOT
			inc [shot_ren]
			mov dl,[enemy_ren3]
			add dl,2
			cmp dl,20
			je no_disp23
			call IMPRIME_SHOT
			call colision_player
			cmp placol,1
			je no_disp23
			mov dl,[shot_ren]
			add dl,2
			cmp dl,23
			jnae ms23
			call BORRA_SHOT
	no_disp23:
		mov placol,0
	ret
	endp

;se llama cuando ocurre una colisión entre el enemigo y el disparo del jugador
	colision_enemigo1 proc
		mov al,[enemy_col1]
		mov ah,[enemy_ren1]
		sub al,2d
		cmp [shot_col],al      ;se comrpueba que el disparo se encuentre en la misma columna que el enemigo. lím izq
		jae col1a
		jmp no_colisiona
	col1a:
		add al,4d
		cmp [shot_col],al  	   ;se comrpueba que el disparo se encuentre en la misma columna que el enemigo. lím der
		jbe col2a
		jmp no_colisiona
	col2a:
		mov cx,2
		mov dl,[shot_ren]
		;ciclo para comprobar si alguno de los dos renglones que componen el disparo coinciden con los renglones del enemigo
		loop1a:
			inc ah 			;inc renglon del enemigo
			cmp dl,ah 		;renglon del disp = renglon del enemigo
			je colisionen1a
			inc ah 			;inc renglon del enemigo
			cmp dl, ah   	;renglon del disp = renglon del enemigo
			je colisionen1a
			sub ah,2 		;reinica el valor del renglon enemigo
			dec dl  		;decrementa el renglon del disp
			loop loop1a     ;¿ya se comprobaron los dos renglones del disparo?
	col3a:
		inc dl 				;regresa al renglon inicial del disp
		cmp dl, ah  		;realiza una última comparación entre el renglon disp y el del enemigo
		je colisionen1a
		jmp no_colisiona 	;si ninguna se cumplio, no hay colisión
	colisionen1a:
		call BORRA_SHOT  	;borra el disparo del jugador
		call BORRA_ENEMIGO1 ;borra al enemigo
		inc player_score  	;incrementa player score
		call IMPRIME_SCORE  ;imprime player score con el valor actualizado
		mov ah, 00h
		int 1Ah
		add dx,tiempo
		mov ticks,dx
		add ticks,7
		;espera cierto tiempo antes de volver a imprimir al enemigo
		regreso_enemy2a:
			int 1Ah
			cmp dx,ticks
			jne regreso_enemy2a
			mov [enemy_ren1],3 		;vuelve a imprimir al enemigo es su renglón inicial
			call IMPRIME_ENEMIGO1
			mov enecol,1
	no_colisiona:
		ret
	endp

	colision_enemigo2 proc
		mov al,[enemy_col2]
		mov ah,[enemy_ren2]
		sub al,2d
		cmp [shot_col],al
		jae col1b
		jmp no_colisionb
	col1b:
		add al,4d
		cmp [shot_col],al
		jbe col2b
		jmp no_colisionb
	col2b:
		mov cx,2
		mov dl,[shot_ren]
		loop1b:
			inc ah
			cmp dl,ah
			je colisionen1b
			inc ah
			cmp dl, ah
			je colisionen1b
			sub ah,2
			dec dl 
			loop loop1b
	col3b:
		inc dl
		cmp dl, ah
		je colisionen1b
		jmp no_colisionb
	colisionen1b:
		call BORRA_SHOT
		call BORRA_ENEMIGO2
		inc player_score
		call IMPRIME_SCORE
		mov ah, 00h
		int 1Ah
		add dx,tiempo
		mov ticks,dx
		add ticks,7
		regreso_enemy2b:
			int 1Ah
			cmp dx,ticks
			jne regreso_enemy2b
			mov [enemy_ren2],3
			call IMPRIME_ENEMIGO2
			mov enecol,1
	no_colisionb:
		ret
	endp

	colision_enemigo3 proc
		mov al,[enemy_col3]
		mov ah,[enemy_ren3]
		sub al,2d
		cmp [shot_col],al
		jae col1c
		jmp no_colisionc
	col1c:
		add al,4d
		cmp [shot_col],al
		jbe col2c
		jmp no_colisionc
	col2c:
		mov cx,2
		mov dl,[shot_ren]
		loop1c:
			inc ah
			cmp dl,ah
			je colisionen1c
			inc ah
			cmp dl, ah
			je colisionen1c
			sub ah,2
			dec dl 
			loop loop1c
	col3c:
		inc dl
		cmp dl, ah
		je colisionen1c
		jmp no_colisionc
	colisionen1c:
		call BORRA_SHOT
		call BORRA_ENEMIGO3
		inc player_score
		call IMPRIME_SCORE
		mov ah, 00h
		int 1Ah
		add dx,tiempo
		mov ticks,dx
		add ticks,7
		regreso_enemy2c:
			int 1Ah
			cmp dx,ticks
			jne regreso_enemy2c
			mov [enemy_ren3],3
			call IMPRIME_ENEMIGO3
			mov enecol,1
	no_colisionc:
		ret
	endp

;se llama cuando ocurre una colisión entre el jugador y el enemigo
	colision_playermov1 proc
	;comprueba si el enemigo esta dentro del rango del jugador
		mov al,[player_col]
		mov ah,[player_ren]
		sub al,2d
		mov dl,[enemy_col1]
		sub dl,2d
		cmp dl,al  				;columna del enemigo (lím izq) >= columna del jugador (lím izq)
		jae col21z
		add dl,4d
		cmp dl,al
		jae col21z  			;columna del enemigo (lím der) >= columna del jugador (lím izq)
		jmp no_colision3z
	col21z:
		add al,4d
		mov dl,[enemy_col1]
		sub dl,2d
		cmp dl,al  				;columna del enemigo (lím izq) <= columna del jugador (lím der)
		jbe col22z
		add dl,4d
		cmp dl,al 				;columna del enemigo (lím der) <= columna del jugador (lím der)
		jbe col22z
		jmp no_colision3z
	col22z:
		mov cx,2
		mov dl,[enemy_ren1]
		loop2z:
			dec ah 				;decrementa el renglon del jugador
			cmp dl,ah         	;renglon del enemigo = renglon del jugador
			je colisionen3z
			dec ah  			;decrementa el renglon del jugador
			cmp dl, ah 			;renglon del enemigo = renglon del jugador
			je colisionen3z
			sub ah,2 			;reinicia el valor del renglón del jugador
			inc dl  			;incrementa el valor del renglon del enemigo
			loop loop2z
			jmp no_colision3z
	colisionen3z:
		call BORRA_ENEMIGO1  	;borra al enemigo
		call BORRA_JUGADOR 		;borra al jugador
		call BORRA_LIVES 		;borra las vidas
		dec player_lives 		;decrementa el valore de las vidas
		call IMPRIME_LIVES 		;vuelve a imprimir el valor de las vidas
		mov ah, 00h
		int 1Ah
		add dx,tiempo
		mov ticks,dx
		add ticks,7
		;espera cirto tiempo antes de volver a imprimir
		regreso_enemy3z:
			int 1Ah
			cmp dx,ticks
			jne regreso_enemy3z
			call IMPRIME_JUGADOR 	;imprime al jugador
			mov [enemy_ren1],3 		;imprime al enemigo en su renglón inicial
			call IMPRIME_ENEMIGO1
			mov movcol,1
	no_colision3z:
		ret
	endp

	colision_playermov2 proc
		mov al,[player_col]
		mov ah,[player_ren]
		sub al,2d
		mov dl,[enemy_col2]
		sub dl,2d
		cmp dl,al
		jae col21y
		add dl,4d
		cmp dl,al
		jae col21y
		jmp no_colision3y
	col21y:
		add al,4d
		mov dl,[enemy_col2]
		sub dl,2d
		cmp dl,al
		jbe col22y
		add dl,4d
		cmp dl,al
		jbe col22y
		jmp no_colision3y
	col22y:
		mov cx,2
		mov dl,[enemy_ren2]
		loop2y:
			dec ah
			cmp dl,ah
			je colisionen3y
			dec ah
			cmp dl, ah
			je colisionen3y
			sub ah,2
			inc dl 
			loop loop2y
			jmp no_colision3y
	colisionen3y:
		call BORRA_ENEMIGO2
		call BORRA_JUGADOR
		call BORRA_LIVES
		dec player_lives
		call IMPRIME_LIVES
		mov ah, 00h
		int 1Ah
		add dx,tiempo
		mov ticks,dx
		add ticks,7
		regreso_enemy3y:
			int 1Ah
			cmp dx,ticks
			jne regreso_enemy3y
			call IMPRIME_JUGADOR
			mov [enemy_ren2],3
			call IMPRIME_ENEMIGO2
			mov movcol,1
	no_colision3y:
		ret
	endp

	colision_playermov3 proc
		mov al,[player_col]
		mov ah,[player_ren]
		sub al,2d
		mov dl,[enemy_col3]
		sub dl,2d
		cmp dl,al
		jae col21x
		add dl,4d
		cmp dl,al
		jae col21x
		jmp no_colision3x
	col21x:
		add al,4d
		mov dl,[enemy_col3]
		sub dl,2d
		cmp dl,al
		jbe col22x
		add dl,4d
		cmp dl,al
		jbe col22x
		jmp no_colision3x
	col22x:
		mov cx,2
		mov dl,[enemy_ren3]
		loop2x:
			dec ah
			cmp dl,ah
			je colisionen3x
			dec ah
			cmp dl, ah
			je colisionen3x
			sub ah,2
			inc dl 
			loop loop2x
			jmp no_colision3x
	colisionen3x:
		call BORRA_ENEMIGO3
		call BORRA_JUGADOR
		call BORRA_LIVES
		dec player_lives
		call IMPRIME_LIVES
		mov ah, 00h
		int 1Ah
		add dx,tiempo
		mov ticks,dx
		add ticks,7
		regreso_enemy3x:
			int 1Ah
			cmp dx,ticks
			jne regreso_enemy3x
			call IMPRIME_JUGADOR
			mov [enemy_ren3],3
			call IMPRIME_ENEMIGO3
			mov movcol,1
	no_colision3x:
		ret
	endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;FIN DE PROCEDIMIENTOS ENEMIGOS;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;se llama cuando ocurre una colisión entre el jugador y el disparo de un enemigo
	colision_player proc
		mov al,[player_col]
		mov ah,[player_ren]
		sub al,2d
		cmp [shot_col],al 			;comprueba si el disparo se encuentra en la misma columna que la del jugador (lím izq)
		jae col11
		jmp no_colision2
	col11:
		add al,4d
		cmp [shot_col],al  			;comprueba si el disparo se encuentra en la misma columna que la del jugador (lím der)
		jbe col12
		jmp no_colision2
	col12:
		mov dl,[shot_ren] 			
		dec ah 						;decrementa el renglon del jugador
		cmp dl,ah 					;renglon disp = renglon del jugador
		je colisionen2
		dec ah 						;decrementa el renglon del jugador
		cmp dl, ah 					;renglon disp = renglon del jugador
		je colisionen2
		add ah,2   					;vuelve a iniciar el renglon del jugador
	colisionen2:
		call BORRA_SHOT 		;borra el disparo
		call BORRA_JUGADOR 		;borra al jugador
		call BORRA_LIVES 		;borra las vidas
		dec player_lives 		;decrementa el valore de las vidas
		call IMPRIME_LIVES 		;vuelve a imprimir el valor de las vidas
		mov ah, 00h
		int 1Ah
		add dx,tiempo
		mov ticks,dx
		add ticks,7
		;espera cierto tiempo antes de volver a imprimir
		regreso_player:
			int 1Ah
			cmp dx,ticks
			jne regreso_player
			call IMPRIME_JUGADOR 	;imprime al jugador
			mov placol,1
	no_colision2:
		ret
	endp 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;FIN PROCEDIMIENTOS;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
end inicio			;fin de etiqueta inicio, fin de programa
