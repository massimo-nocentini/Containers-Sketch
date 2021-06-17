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
