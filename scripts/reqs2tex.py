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

def fmt_aux(data):
  out = []
  for req in data:
    ref = tex.label2ref(req['label'])
    out += [
      tex.cmd('newlabel', f"{ref}", tex.group(req['id'], req['id'], 'ggg', 'hhh', 'iii')),
      tex.cmd('newlabel', f"{ref}@cref", tex.group(f"[requirement][aaa][bbb]{req['id']}", '[ccc][ddd][eee]fff')),
    ]
  return "\n".join(out)

def fmt_tex(data):
  out = []
  for req in data:
    out.append(
      tex.cmd('subsection', req['id']) + "\n\n" +\
      tex.env('description',
        tex.cmd('item', ['Priority']) + req['priority'].title() +\
        tex.cmd('item', ['Requirement']) + req['description'] +\
        (tex.cmd('item', ['Definition of done']) + req['done'] if req['done'] is not None else "")
      )
    )
  return "\n\n".join(out)

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

