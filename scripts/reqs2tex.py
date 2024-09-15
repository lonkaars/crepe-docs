#!/bin/python3
import sys, tomllib, tex

def flatten(data):
  if 'description' in data:
    return [ data ]
  out = []
  for key, value in data.items():
    items = flatten(value)
    for item in items:
      if 'label' in item:
        item['label'] = f"{key}:{item['label']}"
      else:
        item['label'] = f"{key}"
    out += items
  return out

id_counter = 0
def make_id(item):
  global id_counter
  id_counter += 1
  return "{type_short}#{counter:03d}".format(
    type_short = item['type'][0].upper(),
    counter = id_counter,
  )

def convert(data):
  reqs = flatten(data)
  for index, item in enumerate(reqs):
    item['id'] = tex.esc(make_id(item))
    item['index'] = index
    item['description'] = item.get('description', '???')
    item['done'] = item.get('done', None)
    item['priority'] = item.get('priority', 'must')
    item['type'] = item.get('type', 'system')
    item['deleted'] = item.get('deleted', False)

  # skip deleted requirements (but process for make_id)
  reqs = [item for item in reqs if item['deleted'] == False]

  return reqs

def req2aux(req):
  # TODO: this is a dead-end solution, newlabel only works for in-document anchors, not external links
  out = [
    tex.scmd('newlabel', f"req:{req['label']}:id", tex.group(req['id'], req['id'], '', './requirements.pdf', '')),
    tex.scmd('newlabel', f"req:{req['label']}:id@cref", tex.group(f"[requirement][][]{req['id']}", '')),
  ]
  return "\n".join([tex.auxout(line) for line in out])

def fmt_aux(data):
  out = ""
  out += tex.cmd('makeatletter')
  out += "\n".join([req2aux(req) for req in data])
  out += tex.cmd('makeatother')
  return out

def fmt_tex(data):
  return "\n".join([
    tex.cmd('relax')
  ])

def main(input_file):
  data = {}
  with open(input_file, "rb") as file:
    data = tomllib.load(file)

  requirements = convert(data)

  output_aux = input_file.removesuffix(".toml") + ".aux"
  with open(output_aux, "w+") as file:
    file.write(fmt_aux(requirements))

  output_tex = input_file.removesuffix(".toml") + ".tex"
  with open(output_tex, "w+") as file:
    file.write(fmt_tex(requirements))

if __name__ == "__main__":
  if len(sys.argv) != 2:
    print("usage: reqs2tex.py reqs.toml")
    exit(1)
  main(sys.argv[1])

