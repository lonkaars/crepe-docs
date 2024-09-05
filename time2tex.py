#!/bin/python3
import sys


if __name__ == "__main__":
  if len(sys.argv) != 2:
    print("usage: time2tex <input>")
    exit(1)

  input_file = sys.argv[1]
  content = ""
  with open(input_file, "r") as file:
    content = file.read()
  parsed = parse(content)



