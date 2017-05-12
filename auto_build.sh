#!/bin/bash
# 一些变量定义 ######
#工程的target
target_name="BatchPackDemo"

#.ipa文件打包缓存文件目录
tmp_dir="ipa_tmp"

#.ipa最终生成输出目录
ipa_dir="ipa"

#打包描述文件id
provision_profile_id="xxx"

#发布证书名称
code_sign_id="xxx"

#配置plist
option_plist="archive.plist"

#一些需要替换的数据资源 =====================================
#app名称
app_names=("dummy" "app1" "app2") #dummy表示忽略第一个

#app图标资源路径
app_icons_dir="./$target_name/appIcons"

#bundle id每个app是不一样的，前缀
app_bundle_id_prefix=("com.xxx.demo")

#version 1.0.0.20170512
app_bundle_version="1.0.0."`date +"%Y%m%d"`

#.ipa文件前缀
ipa_name_prefix="com-xxx-demo"

#app个数
app_num=${#app_names[@]}

#打包开始时间点
begin_time=`date +%s`

#主要操作 =====================================
mkdir $ipa_dir #创建ipa输出目录

for (( i = 1 ; $i < ${app_num}; i++ )) ; do
echo "--------Started: " $i

# 拷贝替换app icon图片
cd -
cp -a "$app_icons_dir/${app_names[$i]}/AppIcon.appiconset/." "./$target_name/Assets.xcassets/AppIcon.appiconset/"

#app info要在工程中修改的信息
app_name=${app_names[$i]}
app_bundle_id=$app_bundle_id_prefix$i

#modify project settings 执行Xcodeproj脚本修改工程配置文件
ruby modifyProj.rb $app_name $app_bundle_id $app_bundle_version

#archive 打包
xcodebuild archive -scheme $target_name -configuration Release -archivePath $tmp_dir/target.xcarchive CONFIGURATION_BUILD_DIR=$tmp_dir CODE_SIGN_IDENTITY="$code_sign_id" PROVISIONING_PROFILE="$provision_profile_id"

#export 导出ipa到 $ipa_dir/$target_name.ipa
xcodebuild -exportArchive -archivePath $tmp_dir/target.xcarchive -exportPath $ipa_dir -exportOptionsPlist $option_plist

#move ipa & rename 移动和重命名生成的.ipa文件
mv $ipa_dir/"$target_name.ipa" $ipa_dir/$app_name.ipa

echo "--------Finished: " $app_name

#clear temps 清除缓存文件夹
rm -rf $tmp_dir

done

#end =========================================
end_time=`date +%s` #打包结束时间
echo -e "打包时间$[ end_time - begin_time ]秒" #打包所用时间
