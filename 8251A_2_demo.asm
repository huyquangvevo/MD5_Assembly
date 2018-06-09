; multi-segment executable file template.

data segment
    ; add your data here!
    USART_CMD Equ 002h
    USART_DATA Equ 000h
    Chuoi db 'nguyen quang huy'
    
ends

stack segment
    dw   128  dup(0)
ends

code segment
start:
; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax

   
    CALL initUART
    
    
    
    LAP:               
    
    CALL DELAY
    Call uart_recv 

   ; IN AL,USART_CMD
    
    CMP AL,13
    
    JE Print
    ;CALL DELAY 
   ; MOV AL,65
    OUT USART_DATA,AL
    
            
    JMP LAP
    
    Print:
       
       lea di,Chuoi
    
       Call uart_print_string  
    
             
ends 
DELAY PROC
    mov cx,10000
    L2:
    nop ;3 cycles
    loop L2; ;17 cycles
    RET
DELAY ENDP

initUART PROC
    ;Set up UART
    MOV AL,01001101b; //8E1 - /64 
    OUT USART_CMD,AL;
    MOV AL,00000111b;
    OUT USART_CMD,AL; 
    ;End Set up
    RET    
initUART ENDP



; input: al
uart_send proc
    push bx 
    mov bl, al 
            
uart_send_loop:    
    xor ax, ax
    in al, USART_CMD
    and al, 0x1
    jz uart_send_loop   
    
    mov al, bl 
    out USART_DATA, al   
    
    pop bx
    ret 
uart_send endp  


; input di, cx
uart_print_string proc    
   push ax  
   push cx    
   push di
  
  mov cx,30
  
uart_print_loop:        
    mov al, [di]
    call uart_send
    inc di      
    loop uart_print_loop
           
    pop di   
    pop cx    
    pop ax
    ret
uart_print_string endp
    
; output: al
uart_recv proc  
uart_recv_loop: 
    xor ax, ax
    in al, USART_CMD
    and al, 0x2
    jz uart_recv_loop
    
    in al, USART_DATA 
    shr al, 1
    ret
uart_recv endp
  


end start ; set entry point and stop the assembler.
