Class {
	#name : #GraphMoalExample,
	#superclass : #Object,
	#category : #EnterpriseJavascriptAnalysis
}

{ #category : #'as yet unclassified' }
GraphMoalExample class >> displayedInAGraph [
	"see it rendered out into a graph"
	"scope: class-variables  &  class-instance-variables"	
	
	<sampleInstance>
	| out canvas|
	out := GraphMoalExample dslExample .
	canvas := RSCanvas new.
	canvas @ RSCanvasController.
	
	out toRSCompositeOnCanvas: canvas depthLimit: 1.
	RSDominanceTreeLayout   new on: (canvas nodes).
	
	^ canvas. 

]

{ #category : #'as yet unclassified' }
GraphMoalExample class >> dslExample [
	"How you might use Graphodal"
			
	<sampleInstance>	
	| out |
	
	out := GraphModal withName: 'making a sandwhich' andChildren: { 
	  GraphModal withName: 'gather things' andChildren: { 
	    GraphModal withName: 'get bread' andChildren: {
	      GraphModal withName: 'shut the breadbox door too!'
	    }. 
	    (GraphModal withName: 'get peanut butter') externalRef: 'in the cupboard)'; yourself.
	    GraphModal withName: 'get jam'.
	  }.
	
	  GraphModal withName: 'build sandwich' make: [ :sandwich | |peanutButter jam|
		"there is an escape valve for when declarative just isn't working"
		
		peanutButter := GraphModal withName: 'spread peanut butter on one slice of bread'.
		jam          := GraphModal withName: 'spread jam on other slice of bread'.
		
		sandwich children: { peanutButter . jam }.
	  ].  
	}.
	
	^ out.
	 
]
