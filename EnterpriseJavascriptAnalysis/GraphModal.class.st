"
A very very basic ""I have some things that depend on each other that I need to graph"".

Smalltalk (can) make this look reasonably DSL-ish, see this example:

| t |

t := GraphModal withName: 'Travel' andChildren: { 
    GraphModal withName: 'pack suitcase' andChildren: { 
      GraphModal withName: 'find suitcase' }.
    GraphModal withName: 'find wallet' andChildren: { 
      GraphModal withName: 'buy tickets with credit card in wallet'
    }
 }

It also gives the ability to graph this...
"
Class {
	#name : #GraphModal,
	#superclass : #Object,
	#instVars : [
		'name',
		'externalRef',
		'children',
		'cachedCompositeShape',
		'currentBehaviorAspect'
	],
	#category : #EnterpriseJavascriptAnalysis
}

{ #category : #'instance creation' }
GraphModal class >> withName: inName [
	^ (self) withName: inName andChildren: nil.
]

{ #category : #'as yet unclassified' }
GraphModal class >> withName: inName andChildren: inChildren [
	"comment stating purpose of class-side message"
	"scope: class-variables  &  class-instance-variables"	
			
	| out |
	out := self new.
	out name: inName.
	out children: inChildren  .
	^ out.
]

{ #category : #'as yet unclassified' }
GraphModal class >> withName: inName childContext: resultsFromThisBlockWillBeAddedAsChildren [
	"comment stating purpose of message"

  |out|

  out := (self ) withName: inName.
  out children: (resultsFromThisBlockWillBeAddedAsChildren value).

  ^out.
]

{ #category : #'as yet unclassified' }
GraphModal class >> withName: inName children: children andExternalRef: exRef [
	"comment stating purpose of class-side message"
	"scope: class-variables  &  class-instance-variables"	
			
	| out |
	
   out := self new.
   out name: inName.
   out children: children.
   out externalRef: exRef.

   ^ out.
]

{ #category : #'as yet unclassified' }
GraphModal class >> withName: inName make: blockWillBeCalledWithConstructedObject [
	"comment stating purpose of message"

	| out |
	out := self withName: inName.
	
	blockWillBeCalledWithConstructedObject value: out.
	^ out.

]

{ #category : #'aspect handling' }
GraphModal >> _aspectDispatchIsToSelf: inSelectorWithContext [
	"comment stating purpose of instance-side message"
	"scope: class-variables  &  instance-variables"	
	
	|m| 
   currentBehaviorAspect ifNil: [ ^true ]. "guard, no behavior aspect"

   m := (currentBehaviorAspect class) lookupSelector: inSelectorWithContext. "guard, not there in the behavior aspect"
   m ifNil: [ ^true ].
  
	(m pragmas) detect: [ :currentPragma |
         (currentPragma selector) = #unimplemented 
       ]
   ifFound: [ :_ | ^true ]. "guard, it is flagged as unimplemented"

   ^ false.
]

{ #category : #Roassal }
GraphModal >> asRSCompositeShape [
	| output box rslabel |
	rslabel := RSLabel new text: name yourself.
	box := RSBox new
		withBorder;
		extent: rslabel extent + 10;
		color: Color white.
	output := RSComposite new
		draggable;
		model: self;
		shapes:
			{box.
			rslabel}.
	^ output
]

{ #category : #Roassal }
GraphModal >> asRTCompositeShape [
	| rslabel output outModal box |
	
	^ cachedCompositeShape 
	    ifNotNil: [ cachedCompositeShape  ]
	    ifNil: [ 	
			rslabel := RTLabel new text: name yourself.
	      box := RTBox new.	"extent: rslabel extent + 10;"	"color: (Color white)"
	      output := RTCompositeShape new.
	      "output add: box."
	      output add: rslabel.
	      output setAutomaticRelayout.
	      outModal := output elementOn: self.
	      outModal @ RTDraggable.
	
	     cachedCompositeShape := outModal.
	     cachedCompositeShape.
	    ].

]

{ #category : #'aspect handling' }
GraphModal >> aspectContentFor: inSelector [
	"If the current aspect for this instance has an implemented version of inSelector, call it and return result
	Elsewise, call our own implementation directly, returning result.
	
	Buckle up, losers."

   |selectorWithContext parameterCollection|

   selectorWithContext := (inSelector , 'inContext:') asSymbol .
   
  (self _aspectDispatchIsToSelf: selectorWithContext) ifTrue: [ 
    ^ self perform: inSelector
	]
   ifFalse:  [ 
	  "it WAS found, was NOT marked as unimplemented, which means the author wants us to use it. Do so."
		parameterCollection := OrderedCollection newFrom: { self }.
		^ currentBehaviorAspect perform: selectorWithContext  withArguments: (parameterCollection asArray).
	].




]

{ #category : #'aspect handling' }
GraphModal >> aspectContentFor: inSelector withParameters: inParams [
	"See aspectContentFor:"
	"scope: class-variables  &  instance-variables"	
			
	| selectorWithContext withContextParameters|
	withContextParameters := OrderedCollection newFrom: inParams.
	withContextParameters add: self.
	
   selectorWithContext := (inSelector , 'inContext:') asSymbol .
   
  (self _aspectDispatchIsToSelf: selectorWithContext) ifTrue: [ 
    ^ self perform: inSelector withArguments: inParams
	]
   ifFalse:  [ 
	  "it WAS found, was NOT marked as unimplemented, which means the author wants us to use it. Do so."
		^ currentBehaviorAspect perform: selectorWithContext  withArguments: (withContextParameters asArray).
	].



]

{ #category : #accessing }
GraphModal >> children [
	^ children
]

{ #category : #accessing }
GraphModal >> children: anObject [
	children := anObject
]

{ #category : #accessing }
GraphModal >> currentBehaviorAspect [
	^ currentBehaviorAspect.
]

{ #category : #Roassal }
GraphModal >> defaultDepthLimit [
	"subclasses may want to override me to control how much of graph is shown at once (how double-clickable it is)"
			
	^ 4000. "pick a very large number"
]

{ #category : #accessing }
GraphModal >> externalRef [
	^ externalRef
]

{ #category : #accessing }
GraphModal >> externalRef: anObject [
	externalRef := anObject
]

{ #category : #GTInspector }
GraphModal >> gtDefaultDepthLimit [
	"comment stating purpose of instance-side message"
	"scope: class-variables  &  instance-variables"	
			
	^ 4.
]

{ #category : #printing }
GraphModal >> gtDisplayOn: stream [
	"comment stating purpose of instance-side message"
	"scope: class-variables  &  instance-variables"	
			
	^ self name printOn: stream.
]

{ #category : #GTInspector }
GraphModal >> gtInspectorSubtopicsIn: composite [
	"comment stating purpose of instance-side message"
	"scope: class-variables  &  instance-variables"	
			
	<gtInspectorPresentationOrder: 1000>

	(composite respondsTo: #roassal3) 
	  ifTrue:  [ self gtInspectoryOnRoassal3: composite ]
	  ifFalse: [ self gtInspectoryOnRoassal2: composite ].

]

{ #category : #GTInspector }
GraphModal >> gtInspectoryOnRoassal2: composite [
	"comment stating purpose of message"

    composite roassal2 
	    title: 'Graph';
	    initializeView: [ |canvas|
	      canvas := RTView new.
	      canvas @ RTDraggableView.
	      "canvas add: (self asRTCompositeShape )."
	      self toRTCompositeOnCanvas: canvas depthLimit: (self aspectContentFor: #gtDefaultDepthLimit ).
	      self layoutOnCanvas: canvas.
	
	      canvas.
      ].
]

{ #category : #GTInspector }
GraphModal >> gtInspectoryOnRoassal3: composite [
	composite roassal3 
	    title: 'Graph';
	    initializeCanvas: [ |canvas|
	      canvas := RSCanvas new.
	      canvas @ RSCanvasController.
	      self toRSCompositeOnCanvas: canvas depthLimit: (self aspectContentFor: #gtDefaultDepthLimit ).
	      self layoutOnCanvas: canvas.
	
	      canvas.
	  ].
]

{ #category : #'aspect handling' }
GraphModal >> injectAspectBehavior: aspect [
	"For the current instance, and every child object in its graph, infect it with the given aspect.
	
	Through this, starting at the root node, the entire graph can be infected."	
			
	currentBehaviorAspect := aspect.
	
	(self children) ifNotNil: [ 
     self children do: [ :currentChild |
	    currentChild injectAspectBehavior: aspect.
	  ].
   ].
]

{ #category : #Roassal }
GraphModal >> layoutOnCanvas: canvas [
	"Subclasses could redefine this if you prefer another layout.
	 This current impl tries to be smart for what version of Roassal you have.
	"
	|cls nodes|
	
	nodes := (canvas respondsTo: #nodes) ifTrue: [ canvas nodes ] ifFalse: [ canvas elements ].
	cls := Smalltalk at: ('RSDominanceTreeLayout' asSymbol) ifAbsent: [ 
		Smalltalk at: ('RTHorizontalFlowLayout' asSymbol) ] .		
				
	cls new on: nodes.
]

{ #category : #accessing }
GraphModal >> name [
	^ name
]

{ #category : #accessing }
GraphModal >> name: anObject [
	name := anObject
]

{ #category : #Roassal }
GraphModal >> toRSCompositeOnCanvas: canvas [
	^ self toRSCompositeOnCanvas: canvas depthLimit: (self aspectContentFor: #defaultDepthLimit).
	
]

{ #category : #Roassal }
GraphModal >> toRSCompositeOnCanvas: canvas depthLimit: curentLimit [
	| output childrenGraphs childrenNodes |
	output := self asRSCompositeShape.
	canvas add: output.
	
	(curentLimit > 0) ifTrue: [ 
	  childrenGraphs := (self aspectContentFor: #children).	
	  childrenGraphs ifNotNil: [ 
		  childrenNodes := childrenGraphs collect: [ :curr | | childShape line |
					childShape := curr toRSCompositeOnCanvas: canvas depthLimit: (curentLimit -1).
					line := RSLine new
						from: childShape;
						to: output.
					canvas add: line ] ].
	].
	^ output
]

{ #category : #Roassal }
GraphModal >> toRSCompositeWithLayoutOnCanvas: canvas depthLimit: limit [
	"This performs the layout for you, in addition to setting up the graph. (It also will dispatch to a behaviorAspect if you have one set up"
	"scope: class-variables  &  instance-variables"	
			
  |out|

  out := self toRSCompositeOnCanvas: canvas depthLimit: limit.
  self aspectContentFor: #layoutOnCanvas: withParameters: { canvas }.

  ^out.
]

{ #category : #Roassal }
GraphModal >> toRTCompositeOnCanvas: canvas [
	"version of toRSCompositeOnCanvas but for Roassal2 (not 3)"
   ^ self toRTCompositeOnCanvas: canvas depthLimit: (self aspectContentFor: #defaultDepthLimit).
 
]

{ #category : #Roassal }
GraphModal >> toRTCompositeOnCanvas: canvas depthLimit: currentLimit [
	"comment stating purpose of message"

	| outModal childrenGraphs childrenNodes |
	"extent: rslabel extent + 10;"
	"color: (Color white)"
	"output add: box."
	outModal := self asRTCompositeShape.
	canvas add: outModal.
	
	(currentLimit > 0) ifTrue: [ 
		childrenGraphs := (self aspectContentFor: #children).
		
	  childrenGraphs ifNotNil: [ 
		childrenNodes := childrenGraphs collect: [ :curr | 
					| childShape line |
					childShape := curr toRTCompositeOnCanvas: canvas depthLimit: (currentLimit - 1).
					line := RTEdge from: outModal to: childShape.
					line + (RTLine new color: Color black) + RTSimpleArrowHead new.
					canvas add: line ] ].
	].
	^ outModal
]

{ #category : #Roassal }
GraphModal >> toRTCompositeWithLayoutOnCanvas: canvas depthLimit: limit [
	"This performs the layout for you, in addition to setting up the graph. (It also will dispatch to a behaviorAspect if you have one set up"
	"scope: class-variables  &  instance-variables"	
			
  |out|

  out := self toRTCompositeOnCanvas: canvas depthLimit: limit.
  self aspectContentFor: #layoutOnCanvas: withParameters: { canvas }.

  ^out.
]
