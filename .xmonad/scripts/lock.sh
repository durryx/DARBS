pkill --exact picom
while pgrep --exact picom; do sleep 1; done
picom --backend glx &

xsecurelock

pkill --exact picom
while pgrep --exact picom; do sleep 1; done
picom &
