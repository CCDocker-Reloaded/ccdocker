local logger = {}
function logger.FATA(e)
  term.write("FATA", "red")
  print(e)
end
function logger.NOTI(e)
  term.write("NOTI", "cyan")
  print(e)
end
function logger.WARN(e)
  term.write("WARN", "orange")
  print(e)
end
function logger.success(e)
  write('[')
  term.write(" /", "green")
  write(']')
  print(e)
end
function logger.fail(e)
  write('[')
  term.write("X ", "red")
  write(']')
  print(e)
end
return logger
