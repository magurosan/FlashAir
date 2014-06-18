require "./flashair.rb"

fl = Flashair.new('aaa121212121','foobar')

# 1: success nil: fault
p fl.upload("/Users/foo/bar.jpg")
