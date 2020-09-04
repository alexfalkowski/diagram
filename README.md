# Diagram

Tooling needed to generate diagrams

## Structurizr

Structurizr is a collection of tooling to create software architecture diagrams and documentation based upon the C4 model.

### Setup

Just run the following:

```sh
make setup
```

### Diagrams

This solution uses the DSL, which is a very easy to describe the diagrams.

#### Language Reference

The language reference can be found [here](https://github.com/structurizr/dsl/blob/master/docs/language-reference.md).

### Online Editor

To quickly see how your diagram might look like you can use the [tool](https://structurizr.com/dsl).

### Generate

Just run the following:

```sh
make type=connect generate
```
