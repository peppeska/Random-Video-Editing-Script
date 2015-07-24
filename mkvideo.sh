#! /bin/bash
mkdir editing
rm -rf editing/*
files=(./*)
seconds=2
for ((I=0;I<30;I++))
do
	video=${files[RANDOM % ${#files[@]}]}
	if [[ $video == *GOPR* ]]
	then
		echo $video
		durata=`ffmpeg -i $video 2>&1 | grep "Duration"| cut -d ' ' -f 4 | sed s/,// | sed 's@\..*@@g' | awk '{ split($1, A, ":"); split(A[3], B, "."); print 3600*A[1] + 60*A[2] + B[1] }' `
		echo $durata
		end=`shuf -i $seconds-$durata -n 1`
		start=$((end-$seconds))
		echo START $start , END $end
		command=`ffmpeg -i $video -ss $start -t $seconds -strict -2 editing/$I.MP4`
		#echo $command
	fi
done

mencoder -ovc copy -oac pcm editing/*.MP4 -o output.MP4
ffmpeg -i output.MP4 -i music.mp3 -map 0:0 -map 1:0 output_final.MP4
