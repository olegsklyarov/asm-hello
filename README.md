# asm-hello

Минимальная программа **Hello, World** для **macOS x86_64**, которая печатает строку и завершается **без libc** — только через системные вызовы.

## Сборка и запуск

```bash
make build
make run
```

Или одной командой: `make test` (сборка, запуск и проверка кода выхода).

Ожидаемый вывод:

```
Hello, World!
```

Код выхода: `0`.

## Что делает `hello.s`

### Структура файла

1. **`.section __TEXT, __text`** — исполняемый код. Точка входа — `_main` (так ожидает линковщик: флаг `-e _main` в `Makefile`).
2. **`.section __TEXT,__const`** — строковые константы. Буфер `message` (`.ascii`) и метка `message_end`; длина вычисляется при сборке как `message_end - message`.

### Функция `_main`

#### 1. Syscall [`write(2)`](https://developer.apple.com/library/archive/documentation/System/Conceptual/ManPages_iPhoneOS/man2/write.2.html) — вывод в stdout

На macOS x86_64 аргументы syscall передаются в регистрах:

| Регистр | Роль в ABI |
|---------|------------|
| `rax` | номер syscall |
| `rdi` | аргумент 1 |
| `rsi` | аргумент 2 |
| `rdx` | аргумент 3 |
| `r10` | аргумент 4 |
| `r8`  | аргумент 5 |
| `r9`  | аргумент 6 |

Для `write(int fd, user_addr_t cbuf, user_size_t nbyte)`:

| Регистр | Значение | Смысл |
|---------|----------|--------|
| `rax` | `SYSCALL_write` (`0x2000004`) | номер syscall `write` (BSD `4` + префикс `0x2000000` на macOS) |
| `rdi` | `STDOUT_FILENO` (`1`) | файловый дескриптор stdout |
| `rsi` | адрес `message` | буфер (`leaq message(%rip), %rsi` — RIP-relative адрес) |
| `rdx` | `message_end - message` | длина строки (вычисляется ассемблером при сборке) |

Затем `syscall` — переход в ядро, которое записывает строку в stdout.

#### 2. Syscall [`_exit(2)`](https://developer.apple.com/library/archive/documentation/System/Conceptual/ManPages_iPhoneOS/man2/_exit.2.html) (`exit`) — завершение процесса

| Регистр | Значение | Смысл |
|---------|----------|--------|
| `rax` | `SYSCALL_exit` (`0x2000001`) | номер syscall `exit` (BSD `1`) |
| `rdi` | `EXIT_SUCCESS` (`0`) | код выхода (успех) |

Второй `syscall` завершает процесс.

## Линковка

`Makefile` собирает бинарник так:

```makefile
as hello.s -o hello.o
ld hello.o -o hello -lSystem -syslibroot "$(xcrun -sdk macosx --show-sdk-path)" -e _main -arch x86_64
```

Ассемблер → объектный файл → линковка с `-lSystem` и SDK macOS в исполняемый файл `hello` для архитектуры **x86_64**.

## Цели Makefile

| Цель | Описание |
|------|----------|
| `make` / `make all` | собрать `hello` (то же, что `make build`) |
| `make build` | собрать `hello` |
| `make run` | собрать и запустить |
| `make test` | собрать, запустить и проверить код выхода `0` |
| `make clean` | удалить `hello.o` и `hello` |
| `make watch` | пересобирать при изменении `hello.s` (нужен `fswatch`) |
| `make objdump` | дизассемблировать бинарник |
| `make otool` | вывод секций и кода (`otool -tV`) |
| `make hexdump` | hex-дамп бинарника |

## Требования

- macOS с Xcode Command Line Tools (`as`, `ld`, `xcrun`)
- архитектура **x86_64** (на Apple Silicon может понадобиться Rosetta или отдельная сборка под `arm64`)
