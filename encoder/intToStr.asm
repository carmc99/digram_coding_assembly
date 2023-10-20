.data
bufferItoa: .space 32

.text

.globl itoa   

# Covierte un entero a codigo ascii
itoa:
      la   $t0, bufferItoa+30  # pointer to almost-end of buffer
      sb   $0, 1($t0)      # null-terminated str
      li   $t1, '0'  
      sb   $t1, ($t0)     # init. with ascii 0
      li   $t3, 10        # preload 10

      slt  $t2, $a0, $0   # keep the sign
      beq  $a0, $0, iend  # end if 0
      bgtz $a0, loop
      neg  $a0, $a0       # absolute value (unsigned)
loop:
      div  $a0, $t3       # a /= 10
      mflo $a0
      mfhi $t4            # get remainder
      add  $t4, $t4, $t1  # convert to ASCII digit
      sb   $t4, ($t0)     # store it
      sub  $t0, $t0, 1    # dec. buf ptr
      bne  $a0, $0, loop  # if not zero, loop
      addi $t0, $t0, 1    # adjust buf ptr
iend:
      beq  $t2, $0, nolz  # was < 0?
      addi $t0, $t0, -1
      li   $t1, '-'
      sb   $t1, ($t0)
nolz:
      move $v0, $t0      # return the addr.
      jr   $ra           # of the string