#!/bin/bash
cy_code="
https://zjfpcyweb.bjsat.gov.cn/WebQuery/yzmQuery?callback=jQuery110204343902260255784_1494575978645&fpdm=1100134170&r=0.5880412800710137&_=1494575978649
https://fpcy.tjsat.gov.cn/WebQuery/yzmQuery?callback=jQuery110204343902260255784_1494575978645&fpdm=1200154130&r=0.221210378867988&_=1494575978650
https://fpcy.he-n-tax.gov.cn:82/WebQuery/yzmQuery?callback=jQuery110204343902260255784_1494575978645&fpdm=1300162160&r=0.8824509063015221&_=1494575978651
https://fpcy.tax.sx.cn/WebQuery/yzmQuery?callback=jQuery110204343902260255784_1494575978645&fpdm=1400152130&r=0.31730840733985083&_=1494575978652
https://fpcy.nm-n-tax.gov.cn/WebQuery/yzmQuery?callback=jQuery110204343902260255784_1494575978645&fpdm=1500162130&r=0.7514875574841645&_=1494575978653
https://fpcy.tax.ln.cn/WebQuery/yzmQuery?callback=jQuery110204343902260255784_1494575978645&fpdm=2100153160&r=0.01373892905013313&_=1494575978654
https://fpcy.dlntax.gov.cn/WebQuery/yzmQuery?callback=jQuery110204343902260255784_1494575978645&fpdm=2102151160&r=0.9939262131820534&_=1494575978655
https://fpcy.jl-n-tax.gov.cn:4432/WebQuery/yzmQuery?callback=jQuery110204343902260255784_1494575978645&fpdm=2200154130&r=0.5380072259457664&_=1494575978656
https://fpcy.hl-n-tax.gov.cn/WebQuery/yzmQuery?callback=jQuery110204343902260255784_1494575978645&fpdm=2300154130&r=0.48939151476633635&_=1494575978657
https://fpcyweb.tax.sh.gov.cn:1001/WebQuery/yzmQuery?callback=jQuery110204343902260255784_1494575978645&fpdm=3100153130&r=0.5285536408997139&_=1494575978658
https://fpdk.jsgs.gov.cn:80/WebQuery/yzmQuery?callback=jQuery110204343902260255784_1494575978645&fpdm=3200154130&r=0.09571988464766057&_=1494575978659
https://fpcyweb.zjtax.gov.cn/WebQuery/yzmQuery?callback=jQuery110204343902260255784_1494575978645&fpdm=3300143130&r=0.3076208386094079&_=1494575978660
https://fpcy.nb-n-tax.gov.cn/WebQuery/yzmQuery?callback=jQuery110204343902260255784_1494575978645&fpdm=3302153130&r=0.12736527220037458&_=1494575978661
https://fpcy.ah-n-tax.gov.cn/WebQuery/yzmQuery?callback=jQuery110204343902260255784_1494575978645&fpdm=3400153160&r=0.9791075810002491&_=1494575978662
https://fpcyweb.fj-n-tax.gov.cn/WebQuery/yzmQuery?callback=jQuery110204343902260255784_1494575978645&fpdm=3500161130&r=0.5165047977849353&_=1494575978663
https://fpcy.xm-n-tax.gov.cn/WebQuery/yzmQuery?callback=jQuery110204343902260255784_1494575978645&fpdm=3502162130&r=0.7651779084347103&_=1494575978664
https://fpcy.jxgs.gov.cn:82/WebQuery/yzmQuery?callback=jQuery110204343902260255784_1494575978645&fpdm=3600161130&r=0.8512470403994381&_=1494575978665
https://fpcy.sd-n-tax.gov.cn/WebQuery/yzmQuery?callback=jQuery110204343902260255784_1494575978645&fpdm=3700161130&r=0.16544266821746634&_=1494575978666
https://fpcy.qd-n-tax.gov.cn/WebQuery/yzmQuery?callback=jQuery110204343902260255784_1494575978645&fpdm=3702154130&r=0.6626264504238559&_=1494575978667
https://fpcy.ha-n-tax.gov.cn/WebQuery/yzmQuery?callback=jQuery110204343902260255784_1494575978645&fpdm=4100161130&r=0.9748653454137469&_=1494575978668
https://fpcy.hb-n-tax.gov.cn/WebQuery/yzmQuery?callback=jQuery110204343902260255784_1494575978645&fpdm=4200161130&r=0.8057954873968898&_=1494575978669
https://fpcy.hntax.gov.cn:8083/WebQuery/yzmQuery?callback=jQuery110204343902260255784_1494575978645&fpdm=4300162130&r=0.6821438925609905&_=1494575978670
https://fpcy.gd-n-tax.gov.cn/WebQuery/yzmQuery?callback=jQuery110204343902260255784_1494575978645&fpdm=4400154130&r=0.8057855479265659&_=1494575978672
https://fpcy.szgs.gov.cn/WebQuery/yzmQuery?callback=jQuery110204343902260255784_1494575978645&fpdm=4403161130&r=0.8426488193492899&_=1494575978675
https://fpcy.gxgs.gov.cn:8200/WebQuery/yzmQuery?callback=jQuery110204343902260255784_1494575978673&fpdm=4500154130&r=0.5441905722972696&_=1494575978676
https://fpcy.hitax.gov.cn/WebQuery/yzmQuery?callback=jQuery110204343902260255784_1494575978677&fpdm=4600162130&r=0.5012287026172912&_=1494575978678
https://fpcy.cqsw.gov.cn:80/WebQuery/yzmQuery?callback=jQuery110204343902260255784_1494575978645&fpdm=5000162130&r=0.08288240776078937&_=1494575978680
https://fpcy.sc-n-tax.gov.cn/WebQuery/yzmQuery?callback=jQuery110204343902260255784_1494575978645&fpdm=5100154130&r=0.19929029998269254&_=1494575978681
https://fpcy.gz-n-tax.gov.cn:80/WebQuery/yzmQuery?callback=jQuery110204343902260255784_1494575978645&fpdm=5200153130&r=0.3376371896098268&_=1494575978682
https://fpcy.yngs.gov.cn/WebQuery/yzmQuery?callback=jQuery110204343902260255784_1494575978645&fpdm=5300153160&r=0.3099516580547497&_=1494575978683
https://fpcy.xztax.gov.cn:81/WebQuery/yzmQuery?callback=jQuery110204343902260255784_1494575978645&fpdm=5400141170&r=0.9519136539579187&_=1494575978684
https://fpcyweb.sn-n-tax.gov.cn/WebQuery/yzmQuery?callback=jQuery110204343902260255784_1494575978645&fpdm=6100161130&r=0.5807835107515389&_=1494575978685
https://fpcy.gs-n-tax.gov.cn/WebQuery/yzmQuery?callback=jQuery110204343902260255784_1494575978645&fpdm=6200153130&r=0.3837907101880789&_=1494575978686
https://fpcy.qh-n-tax.gov.cn/WebQuery/yzmQuery?callback=jQuery110204343902260255784_1494575978645&fpdm=6300153160&r=0.830324193894828&_=1494575978687
https://fpcy.nxgs.gov.cn/WebQuery/yzmQuery?callback=jQuery110204343902260255784_1494575978677&fpdm=6400153130&r=0.43726981714192003&_=1494575978689
https://fpcy.xj-n-tax.gov.cn/WebQuery/yzmQuery?callback=jQuery110204343902260255784_1494575978645&fpdm=6500161130&r=0.1716991829616346&_=1494575978691"
rm -rf logfile
for i in $cy_code
do
{
cy_result=`curl -k -s --connect-timeout 5 -m 5 "$i"`
echo ${i}"@"${cy_result} >>logfile
} &
done
wait

echo "fpcy failed:"
cat logfile | grep -v 'key1' | cut -d "W" -f 1

dk_code="
https://fpdk.fj-n-tax.gov.cn/
http://fpdk.qh-n-tax.gov.cn/
https://fpdk.xm-n-tax.gov.cn/
https://fpdk.xztax.gov.cn/
https://fpdk.ningxia.chinatax.gov.cn/
https://fpdk.qd-n-tax.gov.cn/
https://fpdk.jxgs.gov.cn/
https://fpdk.gd-n-tax.gov.cn/
https://fpdk.bjsat.gov.cn/
https://fpdk.sd-n-tax.gov.cn/
https://fpdk.szgs.gov.cn/
https://fpdk.xj-n-tax.gov.cn/
https://fpdk.nm-n-tax.gov.cn/
https://fpdk.dlntax.gov.cn/
https://fpdk.jsgs.gov.cn:81/
https://fpdk.jl-n-tax.gov.cn:4431/
https://fpdk.tax.sh.gov.cn/
https://fpdk.yngs.gov.cn/
https://fpdk.hb-n-tax.gov.cn/
https://fpdk.zhejiang.chinatax.gov.cn/
https://fpdk.nb-n-tax.gov.cn/
https://fpdk.tax.ln.cn/
https://fpdk.he-n-tax.gov.cn:81/
https://fpdk.gz-n-tax.gov.cn/
https://fpdk.hl-n-tax.gov.cn/
https://fpdk.shanxi.chinatax.gov.cn/
https://fpdk.ha-n-tax.gov.cn/
https://fpdk.cqsw.gov.cn/
https://fpdk.gansu.chinatax.gov.cn/
https://fpdk.tjsat.gov.cn/
https://fpdk.hitax.gov.cn/
https://fprzweb.sn-n-tax.gov.cn/
https://fpdk.guangxi.chinatax.gov.cn/
https://fpdk.ah-n-tax.gov.cn/
https://fpdk.sc-n-tax.gov.cn/
https://fpdk.hntax.gov.cn/"
rm -rf dklogfile
for i in $dk_code
do
{
dk_result=`curl -k -s --connect-timeout 5 -m 5 "$i" | grep Login`
echo ${i}"@"${dk_result} >>dklogfile
} &
done
wait

echo "fpdk failed:"
cat dklogfile | grep -v 'Login' | cut -d "@" -f 1