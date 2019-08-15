# Design Principles

These are the design principles that we follow for the toolkit.
Understanding the design principles is helpful for understanding the intended usage of the toolkit.

Contributors should be familar with these principles before submiting a pull request or recommending a new feature.

There are some instances where the toolkit is not consistent with the stated design principles. 
However, our intent to always improve our consistency.

## Automated, Declarative, Everything-as-Code

The toolkit is following the common [principles of DevOps](https://docs.microsoft.com/azure/architecture/checklist/dev-ops). More

## Don't abstract the platform

The toolkit should avoid introducing abstractions that encapsulate the native platform.
Instead, it should leverage native features and existing technologies as much as possible.

Any custom code included in the toolkit should be use to compose (or "glue together") native features.

## Open technology choices

A core purpose for the toolkit is to provide end-to-end reference implementations for core enterprise control plane scenarios. The reference implementations are concrete implementations and we have to choose specific technologies. While we have chosen native Azure technologies for our reference implementations, we recognize that customers may have other technology preferences. 

The toolkit should avoid designs that introduce [tight coupling](https://en.wikipedia.org/wiki/Loose_coupling) between different functions. For example, the technology used to orchestrate a deployment (i.e., Azure DevOps, Jenkins) should not restrict the technology used to define the deployment (i.e., Azure Resource Manager templates, Terraform).