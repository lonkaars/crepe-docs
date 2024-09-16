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
        item['label'] = f"{key}.{item['label']}"
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

def sanitize(item, ids):
  def die(msg):
    print(f"[{item['label']}]: {msg}")
    exit(1)

  # ensure properties
  item['description'] = item.get('description')
  item['done'] = item.get('done')
  item['priority'] = item.get('priority')
  item['type'] = item.get('type')

  # type checks
  if item['type'] not in ['system', 'user']:
    die(f"unknown or missing requirement type {repr(item['type'])}")
  if item['priority'] not in ['must', 'should', 'could', 'will not']:
    die(f"unknown or missing requirement priority {repr(item['type'])}")

  # logic checks
  if item['type'] != 'user' and item['done'] is not None:
    die("has definition of done but is not a user requirement")

  # conversions
  if isinstance(item['done'], list):
    # safety check
    if not set(item['done']).issubset(ids):
      die("definition of done includes unknown requirement(s)")
    item['done'] = tex.cmd('Cref', tex.label2ref(*item['done']))

def convert(data):
  reqs = flatten(data)
  index = 0
  for item in reqs:
    item['id'] = tex.esc(make_id(item))
    item['deleted'] = item.get('deleted', False)
    if item['deleted']: continue
    item['index'] = index
    index += 1
    sanitize(item, [req['label'] for req in reqs])

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

