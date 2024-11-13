.data
##### R1 START MODIFIQUE AQUI START #####
# Este espaço é para definir as constantes e vetores auxiliares, caso necessário.
##### R1 END MODIFIQUE AQUI END #####

.text
# Inicialização de testes
add s0, zero, zero          # Quantidade de testes que passaram

# Teste 1: MMC de 10 e 2 (resultado esperado: 10)
addi a0, zero, 10
addi a1, zero, 2
jal ra, mmc                 # Chama o procedimento mmc
addi t0, zero, 10           # Resultado esperado
bne a0, t0, teste2          # Se a0 != 10, passa para o próximo teste
addi s0, s0, 1              # Incrementa s0 se o teste passou

# Teste 2: MMC de 6 e 4 (resultado esperado: 12)
teste2:
addi a0, zero, 6
addi a1, zero, 4
jal ra, mmc                 # Chama o procedimento mmc
addi t0, zero, 12           # Resultado esperado
bne a0, t0, FIM             # Se a0 != 12, pula para o fim
addi s0, s0, 1              # Incrementa s0 se o teste passou

beq zero, zero, FIM         # Salto incondicional para o fim

##### R2 START MODIFIQUE AQUI START #####

# Procedimento para calcular o MMC
mmc:
    # Salva os registradores usados no procedimento na pilha
    addi sp, sp, -16
    sw ra, 12(sp)
    sw s1, 8(sp)
    sw s2, 4(sp)

    # Calcula o MDC usando o procedimento auxiliar
    mv s1, a0                # s1 = a (primeiro número)
    mv s2, a1                # s2 = b (segundo número)
    jal ra, mdc              # Chama o procedimento mdc; resultado em a0

    # Calcula MMC usando a fórmula (a * b) / MDC
    mul a1, s1, s2           # a1 = a * b
    div a0, a1, a0           # a0 = (a * b) / MDC

    # Restaura os registradores e retorna
    lw ra, 12(sp)
    lw s1, 8(sp)
    lw s2, 4(sp)
    addi sp, sp, 16
    jalr zero, 0(ra)

# Procedimento auxiliar para calcular o MDC usando o Algoritmo de Euclides
mdc:
    mv t0, a0                # t0 = a
    mv t1, a1                # t1 = b

mdc_loop:
    beq t1, zero, mdc_done   # Se t1 == 0, termina o loop
    rem t2, t0, t1           # t2 = t0 % t1
    mv t0, t1                # t0 = t1
    mv t1, t2                # t1 = t2
    beq zero, zero, mdc_loop # Repete o loop

mdc_done:
    mv a0, t0                # Resultado MDC em a0
    jalr zero, 0(ra)         # Retorna

##### R2 END MODIFIQUE AQUI END #####

FIM:
    addi t0, s0, 0           # t0 = quantidade de testes que passaram