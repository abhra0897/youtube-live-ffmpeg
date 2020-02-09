#! /bin/bash
VBR="3000k"
VID_SOURCE="/dev/video0"                #for lappy's webcam, it works. for usb cam try changing the location
IM_SOURCE="/home/rik/Desktop/riktronics_small.bmp"  #logo location
TXT_OVERLAY_SOURCE="/home/rik/Desktop/txtfile.txt"   #txt overlay file location
FONT_SOURCE="/usr/share/fonts/truetype/freefont/FreeMono.ttf"   #font file location. Probably same for all ubuntu. (or all linux ?)
FPS="30"
QUAL="ultrafast"
URL="rtmp://a.rtmp.youtube.com/liveStreamName"         #Your live stream url
KEY="hqd5-pu3v-abcd-vxyz"                     #your stream api
ffmpeg \
	 -f v4l2 -video_size 640x480 -framerate $FPS\
    -i "$VID_SOURCE" -deinterlace \
    -i "$IM_SOURCE" \
    -f lavfi -i anullsrc -c:v copy -c:a aac -strict -2\
    -vcodec libx264 -pix_fmt yuv420p -preset $QUAL -tune zerolatency -g $(($FPS * 2)) -b:v $VBR \
    -ar 44100 -threads 6 -q:a 3 -b:a 712000 -bufsize 128k \
    -filter_complex "[0:v][1:v] overlay=(W-w):0 [b]; \
    [b] drawtext=fontfile=$FONT_SOURCE: textfile=$TXT_OVERLAY_SOURCE: reload=1:\
          x=5: y=450: fontsize=25: fontcolor=white@1.0: box=1: boxcolor=black@0.5"\
    -f flv "$URL/$KEY"
    
    
#Kill the stream by pressing q  (NOT Q, but q). This is set by the ffmpeg encoder
