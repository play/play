data = {
  world: "World!"
}

template = Hogan.compile('hello {{world}}')

#alert template.render(data)