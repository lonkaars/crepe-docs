#!/bin/python3
import sys, tomllib, tex
from enum import StrEnum

def label2ref(*labels):
  return ",".join(["req:" + label.replace('.', ':') for label in labels])

class KEY(StrEnum):
  LABEL = 'label'
  TYPE = 'type'
  ID = 'id'
  INDEX = 'index'
  DELETED = 'deleted'
  DONE = 'done'
  DESCRIPTION = 'description'
  PRIORITY = 'priority'

class REQ_TYPE(StrEnum):
  SYSTEM = 'system'
  USER = 'user'

class REQ_PRIORITY(StrEnum):
  MUST = 'must'
  SHOULD = 'should'
  COULD = 'could'
  WONT = 'will not'

def flatten(data):
  out = []
  for key, value in data.items():
    # this item is a requirement
    if key == KEY.DESCRIPTION:
      out.append(data)

    # skip over reserved keys
    if key in KEY: continue

    # recursively flatten other requirements
    items = flatten(value)
    # and prefix them with the current key
    for item in items:
      if KEY.LABEL in item:
        item[KEY.LABEL] = f"{key}.{item[KEY.LABEL]}"
      else:
        item[KEY.LABEL] = f"{key}"
    out += items
  return out

id_counter = 0
def make_id(item):
  global id_counter
  id_counter += 1
  return "{type_short}#{counter:03d}".format(
    type_short = item[KEY.TYPE][0].upper(),
    counter = id_counter,
  )

def sanitize(item, ids):
  def die(msg):
    print(f"[{item[KEY.LABEL]}]: {msg}")
    exit(1)

  # ensure properties
  item[KEY.DESCRIPTION] = item.get(KEY.DESCRIPTION)
  item[KEY.DONE] = item.get(KEY.DONE)
  item[KEY.PRIORITY] = item.get(KEY.PRIORITY)
  item[KEY.TYPE] = item.get(KEY.TYPE)

  # type checks
  if item[KEY.TYPE] not in REQ_TYPE:
    die(f"unknown or missing requirement type: {repr(item[KEY.TYPE])}")
  if item[KEY.PRIORITY] not in REQ_PRIORITY:
    die(f"unknown or missing requirement priority: {repr(item[KEY.PRIORITY])}")

  # conversions
  if isinstance(item[KEY.DONE], list):
    # safety check
    if not set(item[KEY.DONE]).issubset(ids):
      die("definition of done includes unknown requirement(s)")
    item[KEY.DONE] = tex.cmd('Cref', label2ref(*item[KEY.DONE]))

def convert(data):
  reqs = flatten(data)
  all_ids = [item[KEY.LABEL] for item in reqs]
  index = 0
  for item in reqs:
    item[KEY.ID] = tex.esc(make_id(item))
    item[KEY.DELETED] = item.get(KEY.DELETED, False)
    if item[KEY.DELETED]: continue
    item[KEY.INDEX] = index
    index += 1
    sanitize(item, all_ids)

  # skip deleted requirements (but process for make_id)
  reqs = [item for item in reqs if item[KEY.DELETED] == False]

  return reqs

def fmt_aux(data):
  out = []
  for item in data:
    ref = label2ref(item[KEY.LABEL])
    out += [
      tex.cmd('newlabel', f"{ref}", tex.group(
        item[KEY.ID],
        '',
        '',
        ref,
        '',
      )),
      tex.cmd('newlabel', f"{ref}@cref", tex.group(
        f"[requirement][][]{item[KEY.ID]}",
        '[][][]',
        '',
        '',
        '',
      )),
    ]
  return "\n".join(out)

def fmt_tex(data):
  out = ""
  for item in data:
    out += tex.join(
      tex.cmd('subsection', f"{item[KEY.ID]}: {item[KEY.LABEL]}".upper()),
      tex.withatletter(
        tex.cmd('cref@constructprefix', 'requirement', r'\cref@result'),
        tex.pedef('@currentlabel', item[KEY.ID]),
        tex.pedef('@currentlabelname', item[KEY.ID]),
        tex.pedef('cref@currentlabel', tex.group(['requirement'], [''], [r'\cref@result']) + item[KEY.ID]),
      ),
      tex.cmd('label', ['requirement'], label2ref(item[KEY.LABEL])),
      tex.cmd('parbox', tex.cmd('linewidth'),
        tex.env('description', tex.join(
          tex.cmd('item', ['Priority']) + item[KEY.PRIORITY].title(),
          tex.cmd('item', ['Requirement']) + item[KEY.DESCRIPTION],
          (tex.cmd('item', ['Definition of done']) + item[KEY.DONE] if item[KEY.DONE] is not None else ""),
        )),
      )
    )
  return out

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

