Xvfb :99 -screen 0 1024x768x16 &> xvfb.log &

raco test *.rkt

echo "hen"
