bits 64

global main

%define GTK_WIN_POS_CENTER 1
%define GTK_WIN_WIDTH 400
%define GTK_WIN_HEIGHT 250

extern exit
extern gtk_init
extern gtk_main
extern g_object_set
extern gtk_main_quit
extern gtk_window_new
extern gtk_widget_show
extern g_signal_connect
extern gtk_window_set_title
extern g_signal_connect_data
extern gtk_window_set_position
extern gtk_settings_get_default
extern gtk_widget_set_size_request
extern gtk_window_set_default_size
extern find_root
extern gtk_button_new_with_label
extern gtk_container_add
extern gtk_grid_new
extern gtk_grid_attach
extern gtk_widget_show_all
extern gtk_entry_new
extern gtk_label_new
extern gtk_label_set_text
extern gtk_entry_get_text

section .bss
    window: resq 1
    grid: resq 1
    button: resq 1
    entry_start: resq 1
    entry_stop: resq 1
    entry_iters: resq 1
    label_answer: resq 1
    start_text: resq 1
    stop_text: resq 1
    iters_text: resq 1
    label_start: resq 1
    label_end: resq 1
    label_iters: resq 1

section .rodata
    signal:
    .destroy: db "destroy", 0
    .clicked: db "clicked", 0
    title: db "Lab 10!", 0
    button_text: db "Calculate", 0
    std_ans: db "Answer will be here.", 0
    label_start_text: db "Start:", 0
    label_end_text: db "End:", 0
    label_iters_text: db "Iterations:", 0

section .stack
    db 10000 dup(0)

section .data
    answer_str: db 1000 dup(0), 0
    x_prev: dq 0
    x_curr: dq 0
    iterations: dd 0
    x_next: dq 0
    tmp: dq 0
    eps: dq 0.001

section .text
    _destroy_window:
        jmp gtk_main_quit

    _make_magic:
        push rbp
        mov rbp, rsp
        ;and rsp, 0xFFFFFFFFFFFFFFF0
        mov rdi, qword [ rel entry_start ]
        call gtk_entry_get_text
        mov qword [ rel start_text ], rax

        mov rdi, qword [ rel entry_stop ]
        call gtk_entry_get_text
        mov qword [ rel stop_text ], rax

        mov rdi, qword [ rel entry_iters ]
        call gtk_entry_get_text
        mov qword [ rel iters_text ], rax


        mov rdi, qword [ rel start_text ]
        mov rsi, qword [ rel stop_text ]
        mov rdx, qword [ rel iters_text ]
        call find_root
        ; mov qword [ rel text_to_show ], rax
        
        mov rdi, qword [ rel label_answer ]
        mov rsi, answer_str
        call gtk_label_set_text

        pop rbp 
        ret

    main:
    push rbp
    mov rbp, rsp

    xor rdi, rdi
    xor rsi, rsi
    call gtk_init

    xor rdi, rdi
    call gtk_window_new
    mov qword [ rel window ], rax

    mov rdi, qword [ rel window ]
    mov rsi, title
    call gtk_window_set_title

    mov rdi, qword [ rel window ]
    mov rsi, GTK_WIN_WIDTH
    mov rdx, GTK_WIN_HEIGHT
    call gtk_window_set_default_size

    mov rdi, qword [ rel window ]
    mov rsi, GTK_WIN_POS_CENTER
    call gtk_window_set_position

    mov rdi, qword [ rel window ]
    mov rsi, signal.destroy
    mov rdx, _destroy_window
    xor rcx, rcx
    xor r8d, r8d
    xor r9d, r9d
    call g_signal_connect_data

    xor rdi, rdi
    call gtk_grid_new
    mov qword [ rel grid ], rax

    mov rdi, qword [ rel window ]
    mov rsi, qword [ rel grid ]
    call gtk_container_add

    xor rdi, rdi
    mov rdi, button_text
    call gtk_button_new_with_label
    mov qword [ rel button ], rax

    mov rdi, qword [ rel button ]
    mov rsi, signal.clicked
    mov rdx, _make_magic
    xor rcx, rcx
    xor r8d, r8d
    xor r9d, r9d
    call g_signal_connect_data

    ;
    xor rdi, rdi
    call gtk_label_new
    mov qword [ rel label_start ], rax

    mov rdi, qword [ rel label_start ]
    mov rsi, label_start_text
    call gtk_label_set_text

    mov rdi, qword [ rel grid ]
    mov rsi, qword [ rel label_start ]
    mov rdx, 0
    mov rcx, 0
    mov r8d, 1
    mov r9d, 1
    call gtk_grid_attach
    ;
    xor rdi, rdi
    call gtk_label_new
    mov qword [ rel label_end ], rax

    mov rdi, qword [ rel label_end ]
    mov rsi, label_end_text
    call gtk_label_set_text

    mov rdi, qword [ rel grid ]
    mov rsi, qword [ rel label_end ]
    mov rdx, 1
    mov rcx, 0
    mov r8d, 1
    mov r9d, 1
    call gtk_grid_attach
    ;
    xor rdi, rdi
    call gtk_label_new
    mov qword [ rel label_iters ], rax

    mov rdi, qword [ rel label_iters ]
    mov rsi, label_iters_text
    call gtk_label_set_text

    mov rdi, qword [ rel grid ]
    mov rsi, qword [ rel label_iters ]
    mov rdx, 2
    mov rcx, 0
    mov r8d, 1
    mov r9d, 1
    call gtk_grid_attach
    ;
    xor rdi, rdi 
    call gtk_entry_new
    mov qword [ rel entry_start ], rax

    mov rdi, qword [ rel grid ]
    mov rsi, qword [ rel entry_start ]
    mov rdx, 0
    mov rcx, 1
    mov r8d, 1
    mov r9d, 1
    call gtk_grid_attach

    xor rdi, rdi 
    call gtk_entry_new
    mov qword [ rel entry_stop ], rax

    mov rdi, qword [ rel grid ]
    mov rsi, qword [ rel entry_stop ]
    mov rdx, 1
    mov rcx, 1
    mov r8d, 1
    mov r9d, 1
    call gtk_grid_attach

    xor rdi, rdi 
    call gtk_entry_new
    mov qword [ rel entry_iters ], rax

    mov rdi, qword [ rel grid ]
    mov rsi, qword [ rel entry_iters ]
    mov rdx, 2
    mov rcx, 1
    mov r8d, 1
    mov r9d, 1
    call gtk_grid_attach

    xor rdi, rdi
    call gtk_label_new
    mov qword [ rel label_answer ], rax

    mov rdi, qword [ rel label_answer ]
    mov rsi, std_ans
    call gtk_label_set_text

    mov rdi, qword [ rel grid ]
    mov rsi, qword [ rel label_answer ]
    mov rdx, 1
    mov rcx, 3
    mov r8d, 1
    mov r9d, 1
    call gtk_grid_attach

    mov rdi, qword [ rel grid ]
    mov rsi, qword [ rel button ]
    mov rdx, 0
    mov rcx, 2
    mov r8d, 3
    mov r9d, 1
    call gtk_grid_attach

    ;mov rdi, qword [ rel window ]
    ;mov rsi, qword [ rel button ]
    ;call gtk_container_add

    mov rdi, qword [ rel window ]
    call gtk_widget_show_all

    call gtk_main
    pop rbp
    ret

global answer_str
global x_prev
global x_curr
global iterations
global x_next
global tmp
global eps