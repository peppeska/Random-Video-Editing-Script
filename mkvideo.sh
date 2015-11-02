#! /bin/bash
mkdir editing
rm -rf editing/*
files=(./*)
seconds=2
I=0
while [[ $I -le 140 ]]
do
	video=${files[RANDOM % ${#files[@]}]}
	if [[ $video == *GOPR* ]]
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
			command=`ffmpeg -loglevel panic -i $video -ss $start -t $seconds -strict -2 editing/$I.MP4`
			I=$(( $I + 1 ))
		fi
	fi
done

rm output.MP4
mencoder -ovc copy -oac pcm editing/*.MP4 -o output.MP4

rm output_final.MP4
ffmpeg -i output.MP4 -i music.mp3 -map 0:0 -map 1:0 -shortest output_final.MP4
