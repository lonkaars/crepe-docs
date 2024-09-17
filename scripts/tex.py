# utility function for converting latex code

def group(*args):
  out = ""
  for arg in args:
    if isinstance(arg, list):
      out += "[" + arg[0] + "]"
    if isinstance(arg, str):
      out += "{" + arg + "}"
  return out

def join(*things):
  return "".join(things)

def string(content):
  return r"\string" + content

def cmd(*args):
  name = args[0]
  args = args[1:]
  if len(args) == 0: args = [""]
  return f"\\{name}" + group(*args)

def pedef(*args):
  return r"\protected@edef" + cmd(*args)

def csdef(*args):
  return r"\def" + cmd(*args)

def auxout(*content):
  return r"\write\@auxout" + group(join(*content))

def scmd(*args):
  return string(cmd(*args))

def env(name, *args):
  content = args[-1]
  args = args[0:-1]
  out = f"\\begin{{{name}}}"
  if len(args) > 0:
    out += group(*args)
  out += content
  out += f"\\end{{{name}}}"
  return out

def esc(plain):
  plain = plain.replace("\\", "\\string\\")
  plain = plain.replace("#", "\\#")
  plain = plain.replace("$", "\\$")
  plain = plain.replace("%", "\\%")
  return plain

def tabrule(*cells):
  return "&".join(cells) + "\\\\"

def withatletter(*content):
  return join(
    cmd('makeatletter'),
    *content,
    cmd('makeatother'),
  )

def explist(*items):
  out = []
  for item in items:
    if isinstance(item, str) or not hasattr(item, '__iter__'):
      out.append(item)
    else:
      out += explist(*item)
  return out

