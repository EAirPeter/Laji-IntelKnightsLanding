#用于数据相关性测试，程序最终完成等差数列求和部分运算，38条指令
.text
addi $v0, $zero, 34
add $a0, $zero, $zero
addi $a0, $a0, 4
addi $a0, $a0, 5
addi $a0, $a0, 6
addi $a0, $a0, 8
add $a0, $a0, $a0
add $a0, $a0, $a0
add $a0, $a0, $a0
syscall
syscall
add $a0, $a0, $a0
syscall
add $a0, $a0, $a0
add $a0, $a0, $a0
syscall
addi $v0,$zero,10         # system call for exit
addi $s0,$zero, 0            #消除相关性
addi $s0,$zero, 0
addi $s0,$zero, 0
syscall                   # we are out of here.   
