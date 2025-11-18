# Import UDPipe models to begin Parts of Speech Analysis

A function that retrieves and downloads pre-built models made by the
UDPipe community, covering 65 different languages. For more information
on what models are available, visit:[UDPipe
Documentation](https://bnosac.github.io/udpipe/docs/doc1.html#pre-trained-models)

## Usage

``` r
limpiar_pos_import_model(language)
```

## Arguments

- language:

  The chosen language that the user wishes to select. There are 65
  options to choose from

## Value

Loads the model into memory, ready for the annotation steps in the parts
of speech workflow.

## Examples

``` r
pos_model <- limpiar_pos_import_model(language = "english")
```
