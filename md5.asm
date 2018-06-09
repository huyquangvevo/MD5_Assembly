.Model Small
.Stack 100h
Data Segment
  
  USART_CMD equ 002h
  USART_DATA equ 000h
  
  
  ThongBao DB 'Nhap chuoi: $'
  r dd 7,12,17,22,7,12,17,22,7,12,17,22,7,12,17,22,5,9,14,20,5,9,14,20,5,9,14,20,5,9,14,20,4,11,16,23,4,11,16,23,4,11,16,23,4,11,16,23,6,10,15,21,6,10,15,21,6,10,15,21,6,10,15,21
 
  k dd 0d76aa478h, 0e8c7b756h, 0242070dbh, 0c1bdceeeh, 0f57c0fafh, 04787c62ah, 0a8304613h, 0fd469501h, 0698098d8h, 08b44f7afh, 0ffff5bb1h, 0895cd7beh, 06b901122h, 0fd987193h, 0a679438eh, 049b40821h , 0f61e2562h, 0c040b340h, 0265e5a51h, 0e9b6c7aah, 0d62f105dh, 02441453h, 0d8a1e681h, 0e7d3fbc8h, 021e1cde6h, 0c33707d6h, 0f4d50d87h, 0455a14edh, 0a9e3e905h, 0fcefa3f8h, 0676f02d9h, 08d2a4c8ah , 0fffa3942h, 08771f681h, 06d9d6122h, 0fde5380ch, 0a4beea44h, 04bdecfa9h, 0f6bb4b60h, 0bebfbc70h, 0289b7ec6h, 0eaa127fah, 0d4ef3085h, 04881d05h, 0d9d4d039h, 0e6db99e5h, 01fa27cf8h, 0c4ac5665h,0f4292244h, 0432aff97h, 0ab9423a7h, 0fc93a039h, 0655b59c3h, 08f0ccc92h, 0ffeff47dh, 085845dd1h, 06fa87e4fh, 0fe2ce6e0h, 0a3014314h, 04e0811a1h, 0f7537e82h, 0bd3af235h, 02ad7d2bbh, 0eb86d391h
  
 
  
  h0 dd 67452301h
  h1 dd EFCDAB89h
  h2 dd 98BADCFEh
  h3 dd 10325476h
  
  hash dd 4 dup (?)
  w dw 0,0,0,0,0,0,0,0,0x80,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0x80,0,0,0     
 
  
  
  a dd ?
  b dd ?
  c dd ?
  d dd ?
  f dd ?
  g dd 0
  cache dw 20 dup(?)
  cache2 dw 20 dup(?)
  temp dd ?
  
  Chuoi db 1000 dup(?)
  Result db 32 dup(?)  
  
  count dd ?

ends
  
Code segment 
Start:

    mov ax,@Data
    mov ds,ax
    mov es,ax
    cld
    
  
   
   
   CALL initUART
   
   mov cx,12
   lea di,ThongBao
   Call uart_print_string
   
   
   mov cx,0 
   
   
   lea di,Chuoi
   cld 
   xor cx,cx
   
   Nhapchuoi:

    Call DELAY
    Call uart_recv
    
    cmp al,13
    je Append
    
    OUT USART_DATA,AL
  
    stosb
    inc cx
    jmp Nhapchuoi 
     
    
   
           
    
     
   Append:
    
    mov al,13
    OUT USART_DATA,AL
    
    lea si,Chuoi
    lea di,w
    cld
   
    mov cx,8
    rep movsw
    
   
    
     
     mov dx,word ptr h0
     mov word ptr a,dx
     mov dx,word ptr h0+2
     mov word ptr a+2,dx
     
     mov dx,word ptr h1
     mov word ptr b,dx
     mov dx,word ptr h1+2
     mov word ptr b+2,dx
     
     mov dx,word ptr h2
     mov word ptr c,dx
     mov dx,word ptr h2+2
     mov word ptr c+2,dx
     
     mov dx,word ptr h3
     mov word ptr d,dx
     mov dx,word ptr h3+2
     mov word ptr d+2,dx
   
   
    
    mov dx,0
   Lapchinh:
    cmp dx,64
    jae CapnhatH
    
    ; if i<16
    Range1:
        cmp dx,16
        jae Range2
        
        mov ax,word ptr c
        mov bx,word ptr d
        xor ax,bx
        mov word ptr f,ax 
        
        mov ax,word ptr c+2
        mov bx,word ptr d+2
        xor ax,bx
        mov word ptr f+2,ax
        
        mov ax,word ptr f
        mov bx,word ptr b
        and ax,bx
        mov word ptr f,ax
        
        mov ax,word ptr f+2
        mov bx,word ptr b+2
        and ax,bx
        mov word ptr f+2,ax
        
        mov ax,word ptr f
        mov bx,word ptr d
        xor ax,bx
        mov word ptr f,ax
        
        mov ax,word ptr f+2
        mov bx,word ptr d+2
        xor ax,bx
        mov word ptr f+2,ax
        
       
        
        mov word ptr g,dx
        
        jmp Convert 
        
    ;if 16=<i<=32    
    Range2:
    
        cmp dx,32
        jae Range3
        
        mov ax,word ptr c
        mov bx,word ptr b
        xor ax,bx
        mov word ptr f,ax
        mov ax,word ptr c+2
        mov bx,word ptr b+2
        xor ax,bx
        mov word ptr f+2,ax
        
        mov ax,word ptr d
        mov bx,word ptr f
        and ax,bx
        mov word ptr f,ax
        mov ax,word ptr d+2
        mov bx,word ptr f+2
        and ax,bx
        mov word ptr f+2,ax
        
        mov ax,word ptr f
        mov bx,word ptr c
        xor ax,bx
        mov word ptr f,ax
        mov ax,word ptr f+2
        mov bx,word ptr c+2
        xor ax,bx
        mov word ptr f+2,ax
           
        
        mov word ptr g,0
        mov cx,5
       TinhG2:
        add word ptr g,dx
        Loop TinhG2
        
        add word ptr g,1
        and word ptr g,000Fh
        
        jmp Convert
    
    ;if 32=<i<48    
    Range3:
        
        cmp dx,48
        jae Range4
        
        
        mov ax,word ptr d
        mov bx,word ptr c
        xor ax,bx
        mov word ptr f,ax
        mov ax,word ptr d+2
        mov bx,word ptr c+2
        xor ax,bx
        mov word ptr f+2,ax
        
        mov ax,word ptr f
        mov bx,word ptr b
        xor ax,bx
        mov word ptr f,ax
        mov ax,word ptr f+2
        mov bx,word ptr b+2
        xor ax,bx
        mov word ptr f+2,ax
        
       
     
        mov word ptr g,0      
        mov cx,3
        
       TinhG3:
        add word ptr g,dx
        Loop TinhG3
        
        add word ptr g,5
        and word ptr g,000Fh 
        
        jmp Convert
        
    ;if i>= 48    
    Range4:
    
        not word ptr d
        not word ptr d+2
        
        mov ax,word ptr d
        mov bx,word ptr b
        or ax,bx
        mov word ptr f,ax
        mov ax,word ptr d+2
        mov bx,word ptr b+2
        or ax,bx
        mov word ptr f+2,ax
        
        mov ax,word ptr c
        mov bx,word ptr f
        xor ax,bx
        mov word ptr f,ax
        mov ax,word ptr c+2
        mov bx,word ptr f+2
        xor ax,bx
        mov word ptr f+2,ax
        
        not word ptr d
        not word ptr d+2
        
                
        mov word ptr g,0        
        mov cx,7
       TinhG4:
        add word ptr g,dx
        Loop TinhG4
        
        and word ptr g,000Fh
        
        
    
     
     Convert:
        mov ax,word ptr d
        mov word ptr temp,ax
        mov ax,word ptr d+2
        mov word ptr temp+2,ax 
        
        
        mov ax,word ptr c
        mov word ptr d,ax
        mov ax,word ptr c+2
        mov word ptr d+2,ax
        
        mov ax,word ptr b
        mov word ptr c,ax
        mov ax,word ptr b+2
        mov word ptr c+2,ax
        
     
     
        
       
        
      Tinhb:
        mov ax,word ptr a
        mov bx,word ptr f
        add ax,bx
        mov word ptr cache,ax
        mov ax,word ptr a+2
        mov bx,word ptr f+2
        adc ax,bx
        mov word ptr cache+2,ax
       
        mov ax,word ptr cache 
        ;w[g]
        mov cx,word ptr g
        lea di,w
        sal cx,2
        add di,cx
        mov bx,[di]
        
        add ax,bx
        mov word ptr cache+4,ax
        
        mov ax,word ptr cache+2
        mov bx,[di+2]
        adc ax,bx
        mov word ptr cache+6,ax
        
        ;k[i]
        mov ax,word ptr cache+4
        mov cx,dx
        sal cx,2
        lea di,k
        add di,cx
        mov bx,[di]
        
        add ax,bx
        mov word ptr cache,ax
        
        mov ax,word ptr cache+6
        mov bx,[di+2]
        adc ax,bx
        mov word ptr cache+2,ax
        
      
       lea di,r
       add di,cx
       mov cl,[di]
       mov byte ptr count,cl
       
     Dichtrai: 
     
       mov ax,word ptr cache
       cmp cl,16
       ja DT2
       
       sal ax,cl
     
       mov word ptr cache2,ax
       
       mov ax,word ptr cache
      ; not si
       mov si,0xFFFF
       sal si,cl
       ror si,cl
       not si
      ; rol ax,cl
       and ax,si
       rol ax,cl
       mov word ptr cache+4,ax
                               
                                                         
       mov ax,word ptr cache+2
       mov si,0xFFFF
       sal si,cl
       ror si,cl
       and ax,si
       rol ax,cl
       mov bx,word ptr cache+4
       or ax,bx
       mov word ptr cache2+2,ax  
   
       jmp Dichphai  
        
      DT2:
       sub cl,16
       mov word ptr cache2,0
       mov ax,word ptr cache
       sal ax,cl
       mov word ptr cache2+2,ax
       
      
      Dichphai:
       mov cl,[di]
       mov cl,byte ptr count
       mov ch,32
       sub ch,cl
       mov cl,ch
       mov ax,word ptr cache+2
       
       cmp cl,16
       ja DP2
      
       mov si,0xFFFF
       sal si,cl
       ror si,cl
       sar ax,cl
       and ax,si
       mov word ptr cache2+6,ax 
       
       mov ax,word ptr cache+2
       mov si,0xFFFF
       sal si,cl
       not si
       and ax,si
       ror ax,cl
       mov word ptr cache+4,ax
       
       mov ax,word ptr cache
       sar ax,cl
       mov si,0xFFFF
       sal si,cl
       ror si,cl
       and ax,si
       mov bx,word ptr cache+4
       or ax,bx
       mov word ptr cache2+4,ax 
      
   
       jmp Leftrotate
       
      DP2:
    
       sub cl,16
       mov word ptr cache2+6,0
       
       mov ax,word ptr cache+2
       sar ax,cl
       mov si,0x7FFF
       sub cl,1
       sar si,cl
       and ax,si
       mov word ptr cache2+4,ax
       
      Leftrotate:
       mov ax,word ptr cache2
       mov bx,word ptr cache2+4
       or ax,bx
       mov word ptr cache,ax
       
       mov ax,word ptr cache2+2
       mov bx,word ptr cache2+6
       or ax,bx
       mov word ptr cache+2,ax
       
       ;b
       
       mov ax,word ptr cache
       mov bx,word ptr b
       add ax,bx
       mov word ptr b,ax
       
       mov ax,word ptr cache+2
       mov bx,word ptr b+2
       adc ax,bx
       mov word ptr b+2,ax
       
       
         
       ;a
       
       mov ax,word ptr temp
       mov word ptr a,ax
       mov ax,word ptr temp+2
       mov word ptr a+2,ax
       
       
       inc dx
       jmp Lapchinh
       
       ;Cong h
      
     CapnhatH: 
       mov ax,word ptr a
       mov bx,word ptr h0
       add ax,bx
       mov word ptr h0,ax
       mov ax,word ptr a+2
       mov bx,word ptr h0+2
       adc ax,bx
       mov word ptr h0+2,ax
       
       mov ax,word ptr b
       mov bx,word ptr h1
       add ax,bx
       mov word ptr h1,ax
       mov ax,word ptr b+2
       mov bx,word ptr h1+2
       adc ax,bx
       mov word ptr h1+2,ax
       
       mov ax, word ptr c
       mov bx,word ptr h2
       add ax,bx
       mov word ptr h2,ax
       mov ax,word ptr c+2
       mov bx,word ptr h2+2
       adc ax,bx
       mov word ptr h2+2,ax
       
       mov ax,word ptr d
       mov bx,word ptr h3
       add ax,bx
       mov word ptr h3,ax
       mov ax,word ptr d+2
       mov bx,word ptr h3+2
       adc ax,bx
       mov word ptr h3+2,ax
 
       
       
       mov cx,16
       mov ah,2
       lea si,h0
       cld
       
       
       lea di,Result
       cld
       
      SetMD5:
        lodsb
       First: 
        mov dl,al
        mov dh,al
        and dl,0xF0
        ror dl,4
        cmp dl,10
        jae Chu
        add dl,48
        jmp Print1
       Chu:
        add dl,87
       Print1:
        mov al,dl
        stosb          
        
       Secornd: 
        mov dl,dh
        and dl,0x0F
        cmp dl,10
        jae Chu2
        add dl,48
        jmp Print2
       Chu2:
        add dl,87
       Print2:
        mov al,dl
        stosb
        Loop SetMD5 
       
 
     Exit: 
     
        lea di,Result
        mov cx,32
        Call uart_print_string
     
        
    
ends 
    

     
     
        DELAY PROC
            mov cx,10000
            L2:
            nop ;3 cycles
            loop L2; ;17 cycles
            RET
        DELAY ENDP
     
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
        
        
      
        uart_print_string proc    

        uart_print_loop:        
            mov al, [di]
            call uart_send
            inc di      
            loop uart_print_loop

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
          
        
        initUART PROC
            ;Set up UART
            MOV AL,01001101b; //8E1 - /64 
            OUT USART_CMD,AL;
            MOV AL,00000111b;
            OUT USART_CMD,AL; 
            ;End Set up
            RET    
        initUART ENDP           
            
    
end start       