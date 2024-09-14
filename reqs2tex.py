#!/bin/python3
import sys, tomllib

def fmt(data):
  print(data)
  return f"""
\\makeatletter
\\makeatother
"""

def main(input_file):
  data = {}
  with open(input_file, "rb") as file:
    data = tomllib.load(file)

  output = fmt(data)

  output_file = input_file.removesuffix(".toml") + ".tex"
  with open(output_file, "w+") as file:
    file.write(output)

if __name__ == "__main__":
  if len(sys.argv) != 2:
    print("usage: reqs2tex.py reqs.toml")
    exit(1)
  main(sys.argv[1])

