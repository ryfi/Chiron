#!/usr/bin/env cwl-runner
cwlVersion: v1.0
label: Squeezemeta - Run Squeezemeta tool
class: CommandLineTool

hints:
  - class: DockerRequirement
    dockerPull: umigs/chiron-squeezemeta

inputs:
  mode:
    label: Either sequential, coassembly, or merged (REQUIRED)
    inputBinding:
      prefix: -m
    type: string
  project:
    label: Project name, (REQUIRED for coassembly and merged modes)
    inputBinding:
      prefix: -p
    type: string
  samples_file:
    label: Samples file listing all file names expected as input (REQUIRED) It has the format <Sample> <filename> <pair1|pair2>. A fourth optional column can take the noassembly value, indicating that these sample must not be assembled with the rest (but will be mapped against the assembly to get abundances).
    inputBinding:
      prefix: -s
    type: File
  sequence_file_path:
    label: Path to directory containing FASTQ files (REQUIRED)
    inputBinding:
      prefix: -f
    type: string
  cleaning:
    label: Filters with Trimmomatic (Default no)
    inputBinding:
      prefix: --cleaning
    type: string
  cleaning_options:
    label: Options for Trimmomatic
    inputBinding:
      prefix: -cleaning_options
    type: string
  assembler:
    label: Either megahit, spades, canu, flye assembler (Default megahit)
    inputBinding:
      prefix: -a
    type: string
  assembler_options:
    label: Additional options specific to assembler
    inputBinding:
      prefix: -assembly_options
    type: string
  contiglen:
    label: Minimum length of contigs (Default 200)
    inputBinding:
      prefix: -contiglen
    type: int
  extassembly:
    label: Path to an external assembly provided by the user. The file must contain contigs in the fasta format. This overrides the assembly step of SqueezeMeta.
    inputBinding:
      prefix: -extassembly
    type: string
  singletons:
    label: unassembled reads will be treated as contigs and included in the contig fasta file resulting from the assembly. This will produce 100% mapping percentages, and will increase BY A LOT the number of contigs to process. Use with caution (Default no)
    inputBinding:
      prefix: -singletons
    type: string
  nocog:
    label: Skipp COG assignment (Default no)
    inputBinding:
      prefix: --nocog
    type: string
  nokegg:
    label: Skip KEGG assignment (Default no)
    inputBinding:
      prefix: --nokegg
    type: string
  nopfam:
    label: Skip Pfam assignment (Default no)
    inputBinding:
      prefix: --nopfam
    type: string
  euk:
    label: Drop identity filters for eukaryotic annotation (Default: no). This is recommended for analyses in which the eukaryotic population is relevant, as it will yield more annotations. See the manual for details.
    inputBinding:
      prefix: --euk
    type: string
  extdb:
    label: List of additional user-provided databases for functional annotations. More information can be found in the manual.
    inputBinding:
      prefix: -extdb
    type: string
  doublepass:
    label: Run BlastX ORF prediction in addition to Prodigal (Default no)
    inputBinding:
      prefix: --doublepass
    type: string
  mapping:
    label: Either bowtie, bwa, minimap2-ont, minimap2-pb, minimap2-sr as read mapper (Default bowtie)
    inputBinding:
      prefix: -map
    type: string
  nobins:
    label: Skip binning (Default no)
    inputBinding:
      prefix: --nobins
    type: string
  nomaxbin:
    label: Skip MaxBin binning (Default no)
    inputBinding:
      prefix: --nomaxbin
    type: string
  nometabat:
    label: Skip MetaBat2 binning (Default no)
    inputBinding:
      prefix: --nometabat
    type: string
  threads:
    label: Number of threads (Default 12)
    inputBinding:
      prefix: -t
    type: int
    default: 12
  block_size:
    label: Block size for DIAMOND against the nr database (Default 8)
    inputBinding:
      prefix: -b
    type: int
    default: 8
  canumem:
    label: Memory for canu in Gb (Default 32)
    inputBinding:
      prefix: -canumem
    type: int
    default: 32
  lowmem:
    label: Run on less than 16 Gb of RAM memory (Default no). Equivalent to --block_size 3 --canumem 15
    inputBinding:
      prefix: --lowmem
    type: string
    default: "no"
  minion:
    label: Run on MinION reads (Default no)
    inputBinding:
      prefix: --minion
    type: string


baseCommand: ["perl /SqueezeMeta-1.3.0/scripts/SqueezeMeta.pl"]
