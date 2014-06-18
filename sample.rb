require "./flashair.rb"

fl = Flashair.new('MASTERCODE','APPNAME')

# 1: success nil: fault
p fl.upload("/Users/foo/bar.jpg")
