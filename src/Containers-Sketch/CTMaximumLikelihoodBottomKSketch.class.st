Class {
	#name : #CTMaximumLikelihoodBottomKSketch,
	#superclass : #CTBottomKSketch,
	#category : #'Containers-Sketch'
}

{ #category : #updating }
CTMaximumLikelihoodBottomKSketch >> weightEstimation [

	| r cumulatedWeights process start stop middle |
	self flag: 'To fix'.

	r := sketch last first.

	cumulatedWeights := ((sketch collect: [ :each | each second ])
		                     scan: [ :acc :w | acc + w ]
		                     init: 0)
		                    removeLast;
		                    yourself.

	process := [ :x | 
	           cumulatedWeights
		           inject: 0
		           into: [ :s :w | s + (x - w) reciprocal ] ].

	start := cumulatedWeights last + (1 / r).
	stop := cumulatedWeights last + (self k + 1 / r).

	[ 
	| v |
	middle := stop - start / 2.
	v := process value: middle.

	((v closeTo: r) or: [ middle closeTo: 0 ])
		ifTrue: [ ^ middle ]
		ifFalse: [ 
			v > r
				ifTrue: [ stop := middle ]
				ifFalse: [ start := middle ] ] ] repeat
]
