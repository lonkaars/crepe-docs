#!/bin/python3
import sys
from datetime import datetime, timedelta

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

def fmt_percentage(fac):
  return f"{{\\footnotesize\\itshape({round(fac * 100)}\\%)}}"

def fmt_member_overview(times):
  # calculations
  out = ""
  members = {}
  total_time = 0
  for time in times:
    if not time["name"] in members:
      members[time["name"]] = 0
    members[time["name"]] += time["duration"]
    total_time += time["duration"]

  # begin table
  out += r"\begin{table}\centering"
  out += r"\begin{tabular}{lr@{~}l}\toprule"
  out += r"\textbf{Member} & \textbf{Tracked} &\\\midrule{}"

  # member overview
  for name, tracked in members.items():
    out += f"{name} & {fmt_duration(tracked)} & {fmt_percentage(tracked / total_time)}\\\\"
  out += r"\midrule{}"

  # sum
  out += f"&{fmt_duration(total_time)}&\\\\"

  # end table
  out += r"\bottomrule\end{tabular}"
  out += r"\caption{Tracked time per group member}\label{tab:time-member}"
  out += r"\end{table}"

  return out

def fmt_weekly_overview(times):
  # calculations
  out = ""
  weeks = []
  member_totals = {}
  total_time = sum(time["duration"] for time in times)
  members = list(set(time["name"] for time in times))
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

  # begin table
  out += r"\begin{table}\centering"
  out += f"\\begin{{tabular}}{{l{'r@{~}l' * len(members)}@{{\\qquad}}r}}\\toprule"
  out += r"\textbf{Week\#}"
  for member in members:
    out += f"&\\textbf{{{member}}}&"
  out += r"&\textbf{Subtotal}\\\midrule{}"

  for entry in weeks:
    out += f"{entry['num']}"
    for member in members:
      out += f"&{fmt_duration(entry['members'][member])}&{fmt_percentage(entry['members'][member] / entry['total'])}"
    out += f"&{fmt_duration(entry['total'])}\\\\"

  out += r"\midrule{}"
  for member in members:
    out += f"&{fmt_duration(member_totals[member])}&{fmt_percentage(member_totals[member] / total_time)}"
  out += f"&{fmt_duration(total_time)}\\\\"

  # end table
  out += r"\bottomrule\end{tabular}"
  out += r"\caption{Tracked time per week}\label{tab:time-weekly}"
  out += r"\end{table}"

  return out

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
  # TODO: Task overview
  print(f"""
\\section{{Overviews}}\n
\\subsection{{Members}}\n
{fmt_member_overview(times)}
\\subsection{{Weekly}}\n
{fmt_weekly_overview(times)}
""")

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

