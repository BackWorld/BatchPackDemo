# encoding: utf-8
#!/usr/bin/ruby

require 'xcodeproj'
project_path = './BatchPackDemo.xcodeproj'
project = Xcodeproj::Project.open(project_path) #打开工程文件

plist_path = './BatchPackDemo/Info.plist'
plistHash = Xcodeproj::Plist.read_from_path(plist_path) #读取工程plist配置文件

#传过来的参数 ARGV
if ARGV.size != 3
    puts "The params number is not match with 3"
    else
    plistHash['CFBundleDisplayName'] = ARGV[0] #app显示名称
    plistHash['CFBundleIdentifier'] = ARGV[1] #bundle id
    plistHash['CFBundleVersion'] = ARGV[2] #bundle version

    Xcodeproj::Plist.write_to_path(plistHash, plist_path)  #覆盖修改工程plist配置文件
end
