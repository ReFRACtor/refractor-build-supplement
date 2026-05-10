$graph:
- baseCommand: refractor-retrieve-stac
  class: CommandLineTool
  hints:
    DockerRequirement:
      dockerPull: docker.io/mikesmyth/refractor-docker:0.91
  id: clt
  inputs:
    retrieval_config:
      inputBinding:
        position: 1
        prefix: --retrieval-config
      type: string?
    strategy_table:
      inputBinding:
        position: 2
        prefix: --strategy-table
      type: string?
    stac_catalog_dir:
      inputBinding:
        position: 3
        prefix: --stac-catalog-dir
      type: Directory
    output_dir:
      inputBinding:
        position: 4
        prefix: --output-dir
      type: Directory
  outputs:
    results:
      outputBinding:
        glob: .
      type: Directory
  requirements:
    EnvVarRequirement:
      envDef:
        PATH: /ldata/smyth/muses-env-pixi/.pixi/envs/default/bin:/opt/afids_support/bin:/usr/local/MATLAB/R2017a/bin:/home/smyth/.pixi/bin:/usr/local/texlive/2021/bin/x86_64-linux:/home/smyth/Install/bin:/home/smyth/.local/bin:/bigdata/smyth/miniforge3/condabin:/opt/afids_support/bin:/usr/local/MATLAB/R2017a/bin:/home/smyth/.pixi/bin:/usr/local/texlive/2021/bin/x86_64-linux:/home/smyth/Install/bin:/home/smyth/.local/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin
    ResourceRequirement: {}
  stderr: std.err
  stdout: std.out
- class: Workflow
  doc: This runs refractor-retrieve
  id: refractor-retrieve-stac
  inputs:
    retrieval_config:
      default: /home/muses/cris_ml_test_in/ml_1/retrieval_config.yaml
      doc: this is the retrieval configuration yaml file. Default is to use a fixed
        input file stored in the docker image.
      label: this is the retrieval configuration yaml file. Default is to use a fixed
        input file stored in the docker image.
      type: string?
    strategy_table:
      default: /home/muses/cris_ml_test_in/ml_1/strategy.yaml
      doc: this is the strategy table yaml file. Default is to use a fixed input file
        stored in the docker image.
      label: this is the strategy table yaml file. Default is to use a fixed input
        file stored in the docker image.
      type: string?
    stac_catalog_dir:
      default: &id001 !!python/object/apply:click._utils.Sentinel
      - !!python/object:builtins.object {}
      doc: this is the directory with the STAC catalog for the input data, we look
        for catalog.json
      label: this is the directory with the STAC catalog for the input data, we look
        for catalog.json
      type: Directory
    output_dir:
      default: *id001
      doc: this is the output directory. We generate a stac with date
      label: this is the output directory. We generate a stac with date
      type: Directory
  label: This runs refractor-retrieve
  outputs:
  - id: wf_outputs
    outputSource:
    - step_1/results
    type: Directory
  steps:
    step_1:
      in:
        retrieval_config: retrieval_config
        strategy_table: strategy_table
        stac_catalog_dir: stac_catalog_dir
        output_dir: output_dir
      out:
      - results
      run: '#clt'
$namespaces:
  s: https://schema.org/
cwlVersion: v1.0
schemas:
- http://schema.org/version/9.0/schemaorg-current-http.rdf

