import { Component } from '@lifeart/gxt';
import { style } from '@/utils/print-style';
import { type User, algos, AlgorithmType } from './../utils/constants';
import { t } from '@/utils/t';
import { DocumentDTO, FileDTO } from '@/utils/file-manager';

function nameForAlgo(algo: AlgorithmType) {
  return algos.find((a) => a.value === algo)?.label || '';
}
function hashForFile(file: FileDTO, algo: AlgorithmType) {
  return file.hash[algo] || '';
}

export class Print extends Component<{
  Args: {
    hidePrintButton?: boolean;
    selectedAlgo: AlgorithmType[];
    doc: DocumentDTO;
    files: FileDTO[];
    users: User[];
  };
}> {
  get singleFileMode() {
    return this.args.files.length === 1;
  }
  get firstFile() {
    return this.args.files[0];
  }
  get singleAlgoMode() {
    return this.args.selectedAlgo.length === 1;
  }
  get firstAlgo() {
    return this.selectedAlgo[0];
  }
  get selectedAlgo() {
    return this.args.selectedAlgo.map((algo) => {
      return {
        value: algo,
        label: nameForAlgo(algo),
      }
    });
  }
  <template>
    <style>{{style}}</style>
    {{#if (not @hidePrintButton)}}
      <div class='header'>
        <button class='header__button'>
          {{t.print}}
        </button>
      </div>
    {{/if}}

    <div class='container'>
      <h1>{{t.assurance_sheet}}</h1>

      <table>
        <tr style='break-inside: avoid; break-after: avoid;'>
          <td colspan='2' class='text-center font-bold'>
            {{t.object_name}}
          </td>
          <td colspan='5' class='text-center font-bold'>
            {{@doc.objectName}}
          </td>
        </tr>
        <tr style='break-inside: avoid; break-after: avoid;'>
          <td width='15%' class='text-center font-bold'>
            {{t.serial_number}}
          </td>
          <td width='23.7%' class='text-center font-bold' colspan='2'>
            {{t.document_designation}}
          </td>
          <td width='39.55%' class='text-center font-bold' colspan='3'>
            {{t.product_name}}
          </td>
          <td width='15.23%' class='text-center font-bold'>
            {{t.last_change_number}}
          </td>
        </tr>
        <tr style='break-inside: avoid; break-after: avoid;'>
          <td class='text-center'>{{@doc.serialNumber}}</td>
          <td class='text-center' colspan='2'>{{@doc.designation}}</td>
          <td colspan='3'>{{@doc.documentName}}</td>
          <td class='text-center'>{{@doc.lastChangeNumber}}</td>
        </tr>
        {{#if this.singleAlgoMode}}
          <tr style='break-inside: avoid; break-after: avoid;'>
              <td class='text-center font-bold' colspan='2'>
                {{this.firstAlgo.label}}
              </td>
              <td class='text-center font-bold' colspan='5'>
                {{#if this.singleFileMode}}
                  {{hashForFile this.firstFile this.firstAlgo.value}}
                {{/if}}
              </td>
          </tr> 
        {{else if this.singleFileMode}}
          {{#each this.selectedAlgo key="value" sync=true as |algo|}}
            <tr style='break-inside: avoid; break-after: avoid;'>
              <td class='text-center font-bold' colspan='2'>
                {{algo.label}}
              </td>
              <td class='text-center font-bold' colspan='5'>
                {{hashForFile this.firstFile algo.value}}
              </td>
            </tr> 
          {{/each}}
        {{/if}}
        <tr style='break-inside: avoid; break-after: avoid;'>
          <td class='text-center font-bold' colspan='2'>
            {{t.file_name}}
          </td>
          <td class='text-center font-bold' colspan='2'>
            {{t.last_modified}}
          </td>
          <td
            class='text-center font-bold'
            colspan={{if this.singleFileMode 3 1}}
          >
            {{t.file_size}}
          </td>
          {{#if (not this.singleFileMode)}}
            <td class='text-center font-bold' colspan='2'>
              {{t.checksum_value}}
            </td>
          {{/if}}
        </tr>
        {{#each @files as |model|}}
          <tr style='break-inside: avoid; break-after: avoid;'>
            <td class='text-center' colspan='2'>
              {{model.fileName}}
            </td>
            <td class='text-center' colspan='2'>{{model.fileLastModified}}</td>
            <td class='text-center' colspan={{if this.singleFileMode 3 1}}>
              {{model.formattedSize}}
            </td>
            {{#if (not this.singleFileMode)}}
              <td class='text-center' colspan='2'>
                {{#if this.singleAlgoMode}}
                  {{hashForFile model this.firstAlgo.value}}
                {{else}}
                  {{#each this.selectedAlgo key="value" sync=true as |algo|}}
                    {{algo.label}}: {{hashForFile model algo.value}}<br>
                  {{/each}}
                {{/if}}
              </td>
            {{/if}}
          </tr>
        {{/each}}
        <tr style='break-inside: avoid; break-after: auto;'>
          <td colspan='7' style='padding: 2px'>
            &nbsp;
          </td>
        </tr>

        <tr>
          <td class='text-center font-bold' colspan='2'>
            {{t.work_type}}
          </td>
          <td class='text-center font-bold' colspan='2'>
            {{t.full_name}}
          </td>
          <td class='text-center font-bold' colspan='1'>
            {{t.signature}}
          </td>
          <td class='text-center font-bold' colspan='2'>
            {{t.signing_date}}
          </td>
        </tr>

        {{#each @users as |user|}}
          <tr>
            <td colspan='2'>{{user.role}}</td>
            <td colspan='2'>{{user.lastName}}</td>
            <td colspan='1'>&nbsp;</td>
            <td colspan='2'>&nbsp;</td>
          </tr>
        {{/each}}
        <tr style='break-inside: avoid; break-after: avoid;'>
          <td colspan='7' style='padding: 2px'>
            &nbsp;
          </td>
        </tr>
        <tr style='break-inside: avoid; break-after: auto;'>
          <td colspan='2' rowspan='2'>{{t.assurance_sheet}}</td>
          <td colspan='3' rowspan='2'>{{@doc.designation}} {{t.u_l}}</td>

          <td rowspan='1' width='14%'>{{t.sheet}}</td>
          <td rowspan='1' width='14%'>{{t.sheets}}</td>
        </tr>
        <tr style='break-inside: avoid; break-after: auto;'>
          <td rowspan='1'>&nbsp;</td>
          <td rowspan='1'>&nbsp;</td>
        </tr>
      </table>
    </div>
  </template>
}
