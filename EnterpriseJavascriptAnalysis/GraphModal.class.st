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
		'children'
	],
	#category : #EnterpriseJavascriptAnalysis
}

{ #category : #'instance creation' }
GraphModal class >> withName: inName [
	^ GraphModal withName: inName andChildren: nil.
]

{ #category : #'as yet unclassified' }
GraphModal class >> withName: inName andChildren: inChildren [
	"comment stating purpose of class-side message"
	"scope: class-variables  &  class-instance-variables"	
			
	| out |
	out := GraphModal new.
	out name: inName.
	out children: inChildren  .
	^ out.
]

{ #category : #'as yet unclassified' }
GraphModal class >> withName: inName childen: children andExternalRef: exRef [
	"comment stating purpose of class-side message"
	"scope: class-variables  &  class-instance-variables"	
			
	| out |
	
   out := GraphModal new.
   out name: name
   out children: children.
   out externalRef: exRef.

   ^ out.
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
GraphModal >> externalRef [
	^ externalRef
]

{ #category : #accessing }
GraphModal >> externalRef: anObject [
	externalRef := anObject
]

{ #category : #printing }
GraphModal >> gtDisplayOn: stream [
	"comment stating purpose of instance-side message"
	"scope: class-variables  &  instance-variables"	
			
	^ self name printOn: stream.
]

{ #category : #accessing }
GraphModal >> name [
	^ name
]

{ #category : #accessing }
GraphModal >> name: anObject [
	name := anObject
]

{ #category : #'as yet unclassified' }
GraphModal >> toRSComposite [ 
	| rslabel box output|
	
	rslabel := RSLabel new text: name yourself.
	box := RSBox new withBorder; extent: rslabel extent + 10.
	
	output := RSComposite new draggable;
	model: self; shapes: {  box. rslabel }.
	
    ^output.
]

{ #category : #'as yet unclassified' }
GraphModal >> toRSCompositeOnCanvas: canvas [ 
	| rslabel box output childrenNodes|
	
	rslabel := RSLabel new text: name yourself.
	box := RSBox new withBorder; extent: rslabel extent + 10; color: (Color white).
	
	output := RSComposite new draggable;
	model: self; shapes: {  box. rslabel }.
	canvas add: output.
	
	self children ifNotNil: [  
	  childrenNodes := self children collect: [ :curr |  | childShape line|
		
		childShape := curr toRSCompositeOnCanvas: canvas.
		line := RSLine new from: childShape; to: output.
		canvas add: line.
	  ].
	  	
	].
  ^output. 
]
