## Throw an error and exit.
## Used when shit hits the fan.
def petlError(msg: str) -> None:
    print(f"PETL ERROR: {msg}")
    exit(1)

    
## Simply reads a file.
## Throws an error if the file cannot be read.
def readFile(path: str) -> str:
    try:
        with open(path, "r") as f:
            return f.read()
    except:
        petlError(f"Could not read file '{path}'.")
