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
