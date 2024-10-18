#!/bin/python3
import sys, tex
from datetime import datetime, timedelta

def fmt_duration(sec):
  mins = (sec + 59) // 60 # integer divide, round up
  out = []

  if mins == 0:
    return "--"

  hour = mins // 60
  if hour > 0:
    out.append("%dh" % (hour, ))
    mins = mins % 60

  out.append("%02dm" % (mins, ))

  return "\\,".join(out)

def fmt_percentage(fac):
  return tex.group(
    tex.cmd('footnotesize') +\
    tex.cmd('itshape') +\
    tex.esc(f"({round(fac * 100)}%)")
  )

def fmt_member_overview(times):
  # calculations
  tracked = {}
  total_time = 0
  for time in times:
    if not time["name"] in tracked:
      tracked[time["name"]] = 0
    tracked[time["name"]] += time["duration"]
    total_time += time["duration"]

  members = sorted(list(set(time["name"] for time in times)))
  return tex.env('table', tex.join(
    tex.cmd('centering'),
    tex.env('tabular', 'lr@{~}l', tex.join(
      tex.cmd('toprule'),
      tex.tabrule(tex.cmd('textbf', 'Member'), tex.cmd('textbf', 'Tracked')),
      tex.cmd('midrule'),
      *[
        tex.tabrule(
          name,
          fmt_duration(tracked[name]),
          fmt_percentage(tracked[name] / total_time))
        for name in members
      ],
      tex.cmd('midrule'),
      tex.tabrule('', fmt_duration(total_time), ''),
      tex.cmd('bottomrule'),
    )),
    tex.cmd('caption', 'Tracked time per group member'),
    tex.cmd('label', 'tab:time-member'),
  ))

def fmt_weekly_overview(times):
  # calculations
  weeks = []
  member_totals = {}
  total_time = sum(time["duration"] for time in times)
  members = sorted(list(set(time["name"] for time in times)))
  time_start = min(time["date"] for time in times)
  time_end = max(time["date"] for time in times)
  week_start = time_start - timedelta(days=time_start.weekday()) # round down to nearest monday
  week_end = time_end + timedelta(days=7-time_end.weekday())

  week = week_start
  week_num = 1
  while week < week_end:
    week_times = [time for time in times if time["date"] >= week and time["date"] < (week + timedelta(days=7))]

    week_entry = {
      "num": week_num,
      "members": {},
      "total": sum(time["duration"] for time in week_times)
    }

    for member in members:
      week_entry["members"][member] = sum(time["duration"] for time in week_times if time["name"] == member)

    weeks.append(week_entry)
    week_num += 1
    week += timedelta(days=7)
  for member in members:
    member_totals[member] = sum(time["duration"] for time in times if time["name"] == member)

  return tex.env('table', tex.join(
    tex.cmd('centering'),
    tex.cmd('fitimg',
      tex.env('tabular', r'l' + r'r@{~}l' * len(members) + r'>{\quad}r', tex.join(
        tex.cmd('toprule'),
        tex.tabrule(
          tex.cmd("textbf", tex.esc("#")),
          *[tex.cmd("multicolumn", "2", "c", tex.cmd("textbf", member)) for member in members],
          tex.cmd("textbf", "Subtotal"),
        ),
        tex.cmd('midrule'),
        *[
          tex.tabrule(*[
            str(entry['num']),
            *tex.explist(
              [
                fmt_duration(entry['members'][member]),
                fmt_percentage(entry['members'][member] / entry['total']),
              ]
              for member in members
            ),
            fmt_duration(entry['total']),
          ])
          for entry in weeks
        ],
        tex.cmd('bottomrule'),
      )),
    ),
    tex.cmd('caption', 'Tracked time per week'),
    tex.cmd('label', 'tab:time-weekly'),
  ))

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
  return tex.join(
    tex.cmd('section', 'Overviews'),
    tex.cmd('subsection', 'Members'),
    fmt_member_overview(times),
    tex.cmd('subsection', 'Weekly'),
    fmt_weekly_overview(times),
  )

def main(input_file):
  content = ""
  with open(input_file, "r") as file:
    content = file.read()

  try: parsed = parse(content)
  except Exception as e:
    print(f"{input_file}: {e}")
    exit(1)
  output = fmt(parsed)

  output_file = input_file.removesuffix(".txt") + ".tex"
  with open(output_file, "w+") as file:
    file.write(output)

if __name__ == "__main__":
  if len(sys.argv) != 2:
    print("usage: time2tex.py time.txt")
    exit(1)
  main(sys.argv[1])

