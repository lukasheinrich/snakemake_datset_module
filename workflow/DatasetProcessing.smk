checkpoint dataset_unzip:
    input:
        "<input_dataset>"
    output:
        directory("results/{sample}")
    shell:
        '''
        tar -xzvf {input}
        mv {wildcards.sample} results
        '''

def get_files(wildcards, input):
    return {
        "data_file": f"{input[0]}/file{wildcards.index}.txt",
        "meta_data": f"{input[0]}/meta.json"
    }

rule process_file:
    params:
        files = get_files
    input:
        "results/{sample}"
    output:
        "results/{sample}_processed/file{index}.txt"
    shell:
        '''
        python scripts/process.py {params.files[data_file]} {params.files[meta_data]} {output}
        '''

def collect_files(wildcards):
    check_out = checkpoints.dataset_unzip.get(sample = wildcards.sample).output[0]
    return collect("results/{sample}_processed/file{index}.txt", index = glob_wildcards(f'{check_out}/file{{index}}.txt').index, sample = wildcards.sample)

rule create_meta:
    input:
        collect_files

    output:
        "results/{sample}_processed/meta.json"

    shell:
        '''
        cat {input}| awk '{{a+=$1}}END{{print a}}'|jq '.|{{sum: .}}' > {output}
        '''


rule create_dataset:
    input:
        files = collect_files,
        meta = "results/{sample}_processed/meta.json"
    output:
        "<output_dataset>"
    shell:
        '''
        tar -czvf {output} {input.files} {input.meta}
        '''