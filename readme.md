
# Mission Age of War

Mission Age of War is my journey to learn assembly. The goal is to re-create the game Age of War from scratch in assembly with no external libraries.

## Project Structure

- `test.asm`: Main assembly file that includes various library files and sets up the initial data and text sections.
- `myLib/`: Directory containing various assembly library files.
  - `print_flush.asm`: Handles flushing the print buffer.
  - `print.asm`: Handles printing strings.
  - `print_decimal.asm`: Handles printing decimal numbers.
  - `print_hex.asm`: Handles printing hexadecimal numbers.
  - `print_binary.asm`: Handles printing binary numbers.
  - `print_ascii_value.asm`: Handles printing ASCII values.
  - `rand_int.asm`: Generates random integers.
  - `file_open.asm`: Handles opening files.
  - `file_close.asm`: Handles closing files.
  - `file_read.asm`: Handles reading files.

## Setup

1. Clone the repository:
    ```bash
    git clone https://github.com/yourusername/missionAgeOfWar.git
    ```

2. Navigate to the project directory:
    ```bash
    cd missionAgeOfWar
    ```

## Building the Project

To assemble and link the project, run:
```bash
nasm -f elf64 -o test.o test.asm
ld -o test test.o
```

## Running the Project

To run the assembled and linked executable, use:
```bash
./test
```

## Contributing
Contributions are not being accepted at this time as this project is part of a personal learning journey.

## License

This project is licensed under the MIT License.
