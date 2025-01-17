import sys
import math

class CacheSimulator:
    def __init__(self, cache_size, line_size, associativity, input_file):
        self.cache_size = cache_size
        self.line_size = line_size
        self.associativity = associativity
        self.num_lines = cache_size // line_size
        self.num_sets = self.num_lines // associativity
        self.cache = [
            [{'valid': 0, 'tag': None} for _ in range(associativity)]
            for _ in range(self.num_sets)
        ]
        self.replacement_index = [0] * self.num_sets  # FIFO replacement index por conjunto
        self.input_file = input_file
        self.hits = 0
        self.misses = 0

    def address_to_cache(self, address):
        address = int(address, 16)  # Converte hexadecimal para inteiro
        block_address = address // self.line_size  # Remove deslocamento
        set_index = block_address % self.num_sets  # Índice do conjunto
        tag = block_address // self.num_sets  # Tag
        return set_index, tag

    def access_cache(self, address):
        set_index, tag = self.address_to_cache(address)
        cache_set = self.cache[set_index]

        # Verifica se é um HIT
        for line in cache_set:
            if line['valid'] == 1 and line['tag'] == tag:
                self.hits += 1
                return

        # Caso contrário, é um MISS
        self.misses += 1
        replacement_line = self.replacement_index[set_index]
        cache_set[replacement_line]['valid'] = 1
        cache_set[replacement_line]['tag'] = tag
        self.replacement_index[set_index] = (replacement_line + 1) % self.associativity

    def simulate(self):
        with open(self.input_file, 'r') as file:
            addresses = file.readlines()

        with open('output.txt', 'w') as output:
            for address in addresses:
                address = address.strip()
                self.access_cache(address)
                self.write_cache_state(output)

            # Escreve os HITS e MISSES
            output.write("\n")
            output.write(f"#hits: {self.hits}\n")
            output.write(f"#miss: {self.misses}")

    def write_cache_state(self, output):
        output.write("================\n")
        output.write("IDX V ** ADDR **\n")
        for set_index, cache_set in enumerate(self.cache):
            for line_index, line in enumerate(cache_set):
                global_index = set_index * self.associativity + line_index
                valid = line['valid']
                tag = f"0x{line['tag']:08X}" if line['tag'] is not None else ""
                output.write(f"{global_index:03d} {valid} {tag}\n")


if len(sys.argv) != 5:
    print("Uso: python3 simulador.py <tamanho_cache> <tamanho_linha> <associatividade> <arquivo_entrada>")
    sys.exit(1)

cache_size = int(sys.argv[1])
line_size = int(sys.argv[2])
associativity = int(sys.argv[3])
input_file = sys.argv[4]

simulator = CacheSimulator(cache_size, line_size, associativity, input_file)
simulator.simulate()
