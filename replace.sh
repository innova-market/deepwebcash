sed -i '' "s/ZCash/DeepWebCash/g" `grep ZCash -rl --exclude-dir=.git --exclude=replace.sh .`
sed -i '' "s/ZCASH/DWCASH/g" `grep ZCASH -rl --exclude-dir=.git --exclude=replace.sh .`
sed -i '' "s/z\.cash/dw\.cash/g" `grep z\.cash -rl --exclude-dir=.git --exclude=replace.sh .`
sed -i '' "s/zcash/dwcash/g" `grep zcash -rl --exclude-dir=.git --exclude=replace.sh .`
