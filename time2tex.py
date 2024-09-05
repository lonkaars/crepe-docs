#!/bin/python3
import sys
from datetime import datetime

def fmt_duration(sec):
  mins = (sec + 59) // 60 # integer divide, round up
  out = []

  if mins == 0:
    return "--"

  hour = mins // 60
  if hour > 0:
    out.append("%02dh" % (hour, ))
    mins = mins % 60

  out.append("%02dm" % (mins, ))

  return "\\,".join(out)

def fmt_member_overview(times):
  members = {}
  total_time = 0
  for time in times:
    if not time["name"] in members:
      members[time["name"]] = 0
    members[time["name"]] += time["duration"]
    total_time += time["duration"]
  print("""\\section{Member overview}\n
\\begin{table}
\\centering
\\begin{tabular}{lr}
\\toprule
\\textbf{Member} & \\textbf{Tracked}\\\\
\\midrule""")
  for name, tracked in members.items():
    print(f"{name} & {fmt_duration(tracked)}\\\\")
  print("\\midrule")
  print(f"& sum\\quad {fmt_duration(total_time)}\\\\")
  print("""\\bottomrule
\\end{tabular}
\\caption{Tracked time per group member}
\\label{tab:time-member}
\\end{table}""")

def duration2secs(duration):
  out = 0 # output (seconds)
  cur = 0 # current figure (unknown)
  for c in duration:
    if c.isdigit():
      cur = cur * 10 + int(c)
      continue
    if c == "h":
      out += cur * 3600
      cur = 0
      continue
    if c == "m":
      out += cur * 60
      cur = 0
      continue
    if c == "s":
      out += cur * 1
      cur = 0
      continue

    raise Exception("invalid duration format")
  if cur != 0: raise Exception("invalid duration format")
  return out

def line2data(line):
  # parse fields from input string
  data = {}
  next = line.find(':')
  data["name"] = line[0:next].strip()
  line = line[next+1:].strip()
  next = line.find(' ')
  data["date"] = line[0:next].strip()
  line = line[next+1:].strip()
  next = line.find(' ')
  data["duration"] = line[0:next].strip()
  line = line[next+1:].strip()
  data["description"] = line

  # deserialize parsed fields
  data["name"] = data["name"].title()
  data["date"] = datetime.strptime(data["date"], '%Y-%m-%d')
  data["duration"] = duration2secs(data["duration"])
  data["description"] = [el.strip() for el in data["description"].split("::")]

  return data

def parse(content):
  # split content at newlines
  lines = content.split("\n")
  out = []
  for i, line in enumerate(lines):
    line = line.strip()
    if line.startswith("#"): continue
    if len(line) == 0: continue

    try: out.append(line2data(line))
    except Exception as e: raise Exception(f"line {i+1}: {e}")
  return out

def fmt(times):
  fmt_member_overview(times)

def main():
  input_file = sys.argv[1]
  content = ""
  with open(input_file, "r") as file:
    content = file.read()

  try: parsed = parse(content)
  except Exception as e:
    print(f"{input_file}: {e}")
    exit(1)

  fmt(parsed)

if __name__ == "__main__":
  if len(sys.argv) != 2:
    print("usage: time2tex <input>")
    exit(1)
  main()

