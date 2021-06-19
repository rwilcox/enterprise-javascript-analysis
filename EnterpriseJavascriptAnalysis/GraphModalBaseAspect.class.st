"
Allows injection and control of various aspects of functionality into a GraphModal traversal.

For example:

  * return only children that have an externalRef 
  * provide different non graph output formats (want your GraphModal hierarchy in a table?)
  * ... we could also move the gtInspector code from part of the GraphModel into some kind of GraphModalInspectorCompatibiltyAspect...
controlled in the graph by calling injectAspect into the root, which recurively injects it into all its children...


Almost any method implemented on GraphModal (or any subclass!) can be wired into this aspect system.
------------------------------------------
Here are the steps: 

  1. At the callsite you want to add this optional functionality to, call aspectContentFor: or aspectContentFor:withParameters: instead of direct message sending. Like s 

    self count.  ""<-- the old way!""
    self aspectContentFor: #count.  ""<-- the new way""

    Does your method have parameters? No problem (sorry for removing some Smalltalk illusions though)

    self putOn: myShirt pants: myPants andHat: myHat. ""<-- the old way!""
    self aspectContentFor: #putOn:pants:andHat: withParameters: { myShirt. myPants. myHat }.

  2. In your class, which ideally subclasess GraphModalBaseAspect, implement a method like the original signature, but with ""inContext:"" as the last parameter. Like so:

    countinContext: graphModelIstance.   ""<-- yes notice the i in inContext is lowercase!!!""

    Or, if you have mulitple parameters:

   putOn: myShirt pants: pants andHat: myHat inContext: graphModelInstance.


GraphModalBaseAspect, as a base class, wants to provide you with documentation around methods you _could_ override, if you wish. To do that, for every method which is not implemented in the superclass (itself) it uses a <unImplemented> pragma mark. 

HERE'S HOW IT WORKS / THE RULES
-------------------------------

All this happens in the GraphModal (super) class. aspectContentFor finds your passed in selector, appends inContext: to the name, and looks up the method. It then checks to see if that selector exists in the currentBehaviorAspect's class.

If it does, it calls _that_ method, and returns the result.

In all other cases it calls the original method on the GraphModal instance.

Implementation notes
----------------------------

Since your Aspect class has the original instance, you could _just call the original method on the original instance_ and decorate the results on the way out. Or decorate the parameters.

OTHER THINGS YOU CAN DO WITH ASPECTS!!
---------------------------

Since this is a behavior aspect, and you have full access to the instance of the object / you can walk the graph, you can do things like pull out all elements that have externalRefs and make a Markdown list of them, or something

"
Class {
	#name : #GraphModalBaseAspect,
	#superclass : #Object,
	#category : #EnterpriseJavascriptAnalysis
}

{ #category : #'aspect implementations' }
GraphModalBaseAspect >> childreninContext: inInstance [
	"comment stating purpose of instance-side message"
	"scope: class-variables  &  instance-variables"	

   <unimplemented>
	^ 42.
]

{ #category : #'aspect implementations' }
GraphModalBaseAspect >> defaultDepthLimitinContext: context [
	"comment stating purpose of instance-side message"
	"scope: class-variables  &  instance-variables"	
			
	<unimplemented>.
	^ 57.
]

{ #category : #'as yet unclassified' }
GraphModalBaseAspect >> gtDefaultDepthLimitinContext: context [
	"comment stating purpose of instance-side message"
	"scope: class-variables  &  instance-variables"	
			
	<unimplemented>
	^ 84.
]

{ #category : #'as yet unclassified' }
GraphModalBaseAspect >> injectIntoGraphWithRoot: rootGraphModal [
  rootGraphModal injectAspectBehavior: self.
]

{ #category : #'aspect implementations' }
GraphModalBaseAspect >> layoutOnCanvas: canvas inContext: context [
  <unimplemented>	
  ^78.
]
