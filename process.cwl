cwlVersion: v1.2

# ==============================================================================
# Refractor Retrieve STAC - OGC Application Package
# ==============================================================================

$namespaces:
  s: https://schema.org/

$schemas:
  - http://schema.org/version/latest/schemaorg-current-https.rdf

# Schema.org Metadata for Discoverability
s:softwareVersion: 0.91
s:version: 1.0.1
s:datePublished: 2026-05-10
s:author:
  - class: s:Person
    s:name: TROPESS Team
    s:email: James.McDuffie@jpl.nasa.gov

s:license: https://opensource.org/licenses/BSD-3-Clause

$graph:

  # ============================================================================
  # WORKFLOW (Entry Point)
  # ============================================================================

  - class: Workflow
    id: refractor-retrieve-stac
    label: Refractor Retrieve STAC Workflow

    doc: |
      This workflow runs the refractor-retrieve process using positional arguments. 
      It returns the individual files generated within the output directory 
      along side the standard output and error logs.

    # ========================================================================
    # Workflow Inputs
    # ========================================================================

    inputs:
      # ====== REQUIRED PARAMETERS ======
      stac_catalog_dir:
        type: Directory
        label: STAC Catalog Directory
        doc: "Directory containing the STAC catalog (catalog.json)."

      # ====== OPTIONAL PARAMETERS ======
      # These parameters have defaults defined and do not need to be provided
      # by the user unless a custom configuration is required.
      
      output_dir:
        type: string?
        default: "output"
        label: Output Directory Name
        doc: |
          The name of the directory where the tool will write files. 
          Defaults to 'output' if not specified. [cite: 31, 37, 40, 44, 46]

      retrieval_config:
        type: string?
        default: "/home/muses/cris_ml_test_in/ml_1/retrieval_config.yaml"
        label: Retrieval Configuration Path
        doc: |
          Path to the retrieval configuration yaml file. 
          Default is a fixed input file stored in the docker image. [cite: 5, 6, 7]

      strategy_table:
        type: string?
        default: "/home/muses/cris_ml_test_in/ml_1/strategy.yaml"
        label: Strategy Table Path
        doc: |
          Path to the strategy table yaml file defining the processing logic. 
          Default is a fixed input file stored in the docker image. [cite: 8, 9, 10]

    # ========================================================================
    # Workflow Outputs
    # ========================================================================

    outputs:
      wf_outputs:
        type: Any
        label: Workflow Results Contents
        outputSource: step_1/results

      stdout_log:
        type: File
        label: Standard Output Log
        outputSource: step_1/stdout_file

      stderr_log:
        type: File
        label: Standard Error Log
        outputSource: step_1/stderr_file

    # ========================================================================
    # Workflow Steps
    # ========================================================================

    steps:
      step_1:
        run: "#main"
        in:
          retrieval_config: retrieval_config
          strategy_table: strategy_table
          stac_catalog_dir: stac_catalog_dir
          output_dir: output_dir
        out: [results, stdout_file, stderr_file]

  # ============================================================================
  # COMMANDLINETOOL (Execution Step)
  # ============================================================================

  - class: CommandLineTool
    id: main
    label: Refractor Retrieve Tool

    requirements:
      # Not sure if this is the best way to pass this in. I have a build of docker
      # in my personal docker account. This can also just be built from our
      # Dockerfile (make docker-public-build)
      DockerRequirement:
        dockerPull: docker.io/mikesmyth/refractor-docker:0.91

      EnvVarRequirement:
        envDef:
          PATH: /root/.pixi/bin:/home/muses/muses-env/.pixi/envs/default/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/bin
          PYTHONUNBUFFERED: "1"

    inputs:
      retrieval_config:
        type: string?
        inputBinding:
          position: 1

      strategy_table:
        type: string?
        inputBinding:
          position: 2

      stac_catalog_dir:
        type: Directory
        inputBinding:
          position: 3
          valueFrom: $(self.path)/catalog.json

      output_dir:
        type: string?
        inputBinding:
          position: 4

    outputs:
      results:
        type: 
          type: array
          items: [File, Directory]
        outputBinding:
          glob: $(inputs.output_dir)/*

      stdout_file:
        type: File
        outputBinding:
          glob: std.out

      stderr_file:
        type: File
        outputBinding:
          glob: std.err

    baseCommand: [refractor-retrieve, stac]
    stdout: std.out
    stderr: std.err
