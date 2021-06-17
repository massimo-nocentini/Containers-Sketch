Class {
	#name : #CTBottomKSketch,
	#superclass : #CTkMinSketch,
	#category : #'Containers-Sketch'
}

{ #category : #accessing }
CTBottomKSketch >> createSketch [

	sketch := SortedCollection sortUsing: [ :a :b | a first < b first ]
]

{ #category : #updating }
CTBottomKSketch >> random [

	| sum k |
	k := self k min: sketch size.

	sum := 0.
	1 to: k do: [ :i | sum := sum + (sketch at: i) second ].

	^ random
		  lambda: sum;
		  yourself
]

{ #category : #updating }
CTBottomKSketch >> sizeMaximumLikelihood [

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
		ifTrue: [ ^ middle ceiling ]
		ifFalse: [ 
			v > r
				ifTrue: [ stop := middle ]
				ifFalse: [ start := middle ] ] ] repeat
]

{ #category : #accessing }
CTBottomKSketch >> sketch [

	^ sketch copyFrom: 1 to: self k
]

{ #category : #updating }
CTBottomKSketch >> update: u [

	| rank k w |
	k := self k.
	w := wBlock value: u.
	rank := random
		        lambda: w;
		        next.

	(sketch size < k or: [ rank < sketch lastButOne first ]) ifTrue: [ 
		| tuple |
		tuple := Array with: rank with: w with: u.
		sketch add: tuple.
		k + 1 < sketch size ifTrue: [ sketch removeLast ] ]
]

{ #category : #updating }
CTBottomKSketch >> weightEstimation [

	| r |
	r := sketch last first.

	^ sketch inject: 0 into: [ :sum :each | 
		  | w |
		  w := each second.
		  w / (1 - (w * r) negated exp) + sum ]
]
