Class {
	#name : #GraphMoalExample,
	#superclass : #Object,
	#category : #EnterpriseJavascriptAnalysis
}

{ #category : #'as yet unclassified' }
GraphMoalExample class >> alternativeDslExample [
	<sampleInstance>	
	| out |
	
	out := GraphModal withName: 'Cloud Migration' composedOfTasks: { 
	  GraphModal withName: 'Provision AWS Infrastructure (INFRA-RFC-1)' composedOfTasks: { 
	    GraphModal withName: 'Provision VPCs, ELBs (Epic)' composedOfTasks: { 
	      GraphModal withName: 'Provision VPC (2x)'.
	      GraphModal withName: 'Provision ELBs (2b)'.
	    }.
	    GraphModal withName: 'Provision EC2 instances (Epic)' childContext: [ |foo|
		   foo := GraphModal withName: 'create, provisision AMI'.
		   { foo. GraphModal withName: 'IaC provision ASG, ELB connection' }
		 ].
	  }.
	
	  GraphModal withName: 'Data migration (INFRA-RFC-2)' tasks: { 
	    GraphModal withName: 'DMS connections to current databases'.
	    GraphModal withName: 'RDS instances configured viga IaC'.
	  } andExternalRef: 'INFRA-RFC-2'.
	
	  GraphModal withName: 'Migrate FancyService (DEV-RFC-1)' composedOfTasks: { 
	    GraphModal withName: 'migrate secrets -> AWS Secrets Manager'.
	    (GraphModal withName: 'Adopt 12 factor app princples') externalRef: 'DEV-112'; yourself.
	    GraphModal withName: 'containerize' andChildren: { 
	      GraphModal withName: 'get really good at Docker' andChildren: {
	         GraphModal withName: 'brown bag lunch with that Udemy video'.
	      }.
	      GraphModal withName: 'security scan the base container'.
	    }.
	  }. 
 	}.
	
	^ out.
	 
]

{ #category : #'as yet unclassified' }
GraphMoalExample class >> displayedInAGraph [
	"see it rendered out into a graph"
	"scope: class-variables  &  class-instance-variables"	
	
	<sampleInstance>
	| out canvas|
	out := GraphMoalExample dslExample .
	canvas := RSCanvas new.
	canvas @ RSCanvasController.
	
	out toRSCompositeWithLayoutOnCanvas: canvas depthLimit: 1.
	
	^ canvas. 

]

{ #category : #'as yet unclassified' }
GraphMoalExample class >> dslExample [
	"How you might use Graphodal"
			
	<sampleInstance>	
	| out |
	
	out := GraphModal withName: 'Cloud Migration' andChildren: { 
	  GraphModal withName: 'Provision AWS Infrastructure (INFRA-RFC-1)' andChildren: { 
	    GraphModal withName: 'Provision VPCs, ELBs (Epic)' andChildren: { 
	      GraphModal withName: 'Provision VPC (2x)'.
	      GraphModal withName: 'Provision ELBs (2b)'.
	    }.
	    GraphModal withName: 'Provision EC2 instances (Epic)' childContext: [ |foo|
		   foo := GraphModal withName: 'create, provisision AMI'.
		   { foo. GraphModal withName: 'IaC provision ASG, ELB connection' }
		 ].
	  }.
	
	  GraphModal withName: 'Data migration (INFRA-RFC-2)' children: { 
	    GraphModal withName: 'DMS connections to current databases'.
	    GraphModal withName: 'RDS instances configured viga IaC'.
	  } andExternalRef: 'INFRA-RFC-2'.
	
	  GraphModal withName: 'Migrate FancyService (DEV-RFC-1)' andChildren: { 
	    GraphModal withName: 'migrate secrets -> AWS Secrets Manager'.
	    (GraphModal withName: 'Adopt 12 factor app princples') externalRef: 'DEV-112'; yourself.
	    GraphModal withName: 'containerize' andChildren: { 
	      GraphModal withName: 'get really good at Docker' andChildren: {
	         GraphModal withName: 'brown bag lunch with that Udemy video'.
	      }.
	      GraphModal withName: 'security scan the base container'.
	    }.
	  }. 
 	}.
	
	^ out.
	 
]

{ #category : #'as yet unclassified' }
GraphMoalExample class >> listOnlyItemsWithExternalRefs [
	"this is interesting, because question: if a dependency has a external ref but
	none of its parents do, do we show it?
	
	The answer is yes. So we iterate all children normally, and if there's a child when an
	external reference add it to an array on the side. Then after traversal, return ONLY the array on the side.
	
	Which wil be out of hierarctical order, and since items are only singly linked, no way to reconstruct the object
	graph structure from that point. This likely better be an accompying piece of documentation."
	<sampleInstance>	
	| dslExampeGraph behavior itemsWithExternalRefs outputStr|
	itemsWithExternalRefs := OrderedCollection new.
	
	dslExampeGraph := GraphMoalExample dslExample .
   behavior := GraphModalOnlyItemsWithExternalRefsAspect new.
   
  dslExampeGraph walk: [ :currItem |
	currItem externalRef ifNotNil: [ itemsWithExternalRefs add: currItem.]. 
	].
  
  outputStr := String new writeStream .
  outputStr << '||name||reference||'.
  outputStr << String cr.
  itemsWithExternalRefs do: [ :currItem |
	 outputStr << '|'; << currItem name.
	 outputStr << '|'; << currItem externalRef.
	  outputStr << '|'; << String cr.
  ].  

  ^ outputStr contents.
  "^ itemsWithExternalRefs ."
]
