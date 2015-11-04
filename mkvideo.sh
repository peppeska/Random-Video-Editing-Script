#! /bin/bash

echo "+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|R|a|n|d|o|m|-|V|i|d|e|o|-|E|d|i|t|i|n|g|-|S|c|r|i|p|t|
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+"

echo "###########################################################"
echo "# https://github.com/peppeska/Random-Video-Editing-Script #"
echo "###########################################################"

options=("-u" "-m" "-h" "-s" "-n" "-o")

helpmenu () {
	echo "##############################"
	echo "# Parameters Allowed:"
	echo "# ${options[*]} "
	echo "#"
	echo "# -u unique file selection"
	echo "# -m music file (default: music.mp3)"
	echo "# -s seconds cut fro video (default: 2)"
	echo "# -n numer of selection (default: 140)"
	echo "# -o output file (default: output_final.MP4)"
	echo "# -h show this help menu"
	echo "##############################"
}

unique=false
music="music.mp3"
seconds=2
selectionNumber=140
outputFile="output_final.MP4"

while getopts ":uhm:s:n:o:" optname
  do
    case "$optname" in
      "u")
        echo "Option $optname is specified"
	$unique = true
        ;;
      "m")
        echo "Option $optname has value $OPTARG"
	music=$OPTARG
        ;;
      "s")
        echo "Option $optname has value $OPTARG"
	seconds=$OPTARG
        ;;
      "n")
        echo "Option $optname has value $OPTARG"
	selectionNumber=$OPTARG
        ;;
      "o")
        echo "Option $optname has value $OPTARG"
	outputFile=$OPTARG
        ;;
      "h")
        helpmenu
	exit
	;;
      "?")
        echo "Unknown option $OPTARG"
        ;;
      ":")
        echo "No argument value for option $OPTARG"
        ;;
      *)
      # Should not occur
        echo "Unknown error while processing options"
        ;;
    esac
  done



echo "LET'S GO EDITING!"

editdir=editing`(date +"%Y%d%m-%H%M%S")`
mkdir $editdir
files=(./*)
I=0
VIDEOS=()
while [[ $I -le $selectionNumber ]]
do
	video=${files[RANDOM % ${#files[@]}]}
	if [[ $video == *GOPR* ]]
	then
		if [[ (" ${VIDEOS[*]} " != *$video*)  || !$unique ]] 
		then
				echo "=="
				echo "File: " $video
				durata=`ffmpeg -i $video 2>&1 | grep "Duration"| cut -d ' ' -f 4 | sed s/,// | sed 's@\..*@@g' | awk '{ split($1, A, ":"); split(A[3], B, "."); print 3600*A[1] + 60*A[2] + B[1] }' `
				echo "duration: "$durata
				if [[ $durata -ge $seconds ]]
				then
					echo $I
					end=`shuf -i $seconds-$durata -n 1`
					start=$((end-$seconds))
					echo start: $start , end: $end
					command=`ffmpeg -loglevel panic -i $video -ss $start -t $seconds -strict -2 $editdir/$I.MP4`
					I=$(( $I + 1 ))
					VIDEOS+=($video)
				fi
		fi
	fi
done

rm output.MP4
mencoder -ovc copy -oac pcm $editdir/*.MP4 -o output.MP4

rm $outputFile
ffmpeg -i output.MP4 -i $music -map 0:0 -map 1:0 -shortest $outputFile
