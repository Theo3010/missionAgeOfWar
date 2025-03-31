# Mission Age of War

Mission Age of War is my journey to learn assembly. The goal is to re-create the game Age of War from scratch in assembly with no external libraries.

## Project Structure

- `src/`: Contains the assembly source files (`.asm`).
- `out/`: Output directory for compiled object files and binaries.
- `makefile`: Build system for compiling and running the programs.

## Targets in the Makefile

### `all`
Builds the default program, runs it, and cleans up the output files.

```bash
make all
```

### `build`
Compiles the default program (`main`) into the `out/` directory.

```bash
make build
```

### `back`
Builds the `back` program from `src/back.asm` and places the binary in `out/`.

```bash
make back
```

### `run`
Runs the default program (`main`) binary.

```bash
make run
```

### `clean`
Removes all compiled object files and binaries from the `out/` directory.

```bash
make clean
```

## Setup

1. Clone the repository:
    ```bash
    git clone https://github.com/yourusername/missionAgeOfWar.git
    ```

2. Navigate to the project directory:
    ```bash
    cd missionAgeOfWar
    ```

## Notes

- The default program is `main`, and its source file is `src/main.asm`.
- To build the `back` program, ensure `src/back.asm` exists.
- Modify the `program` variable in the Makefile if you want to change the default program.

## Contributing
Contributions are not being accepted at this time as this project is part of a personal learning journey.

## License

This project is licensed under the MIT License.
