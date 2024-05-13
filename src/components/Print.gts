import { Component } from '@lifeart/gxt';
import { style } from '@/utils/print-style';
import { type User } from './../utils/constants';
import { t } from '@/utils/t';
import { FileDTO } from '@/utils/file-manager';

export class Print extends Component<{
  Args: {
    hidePrintButton?: boolean;
    selectedAlgo: string;
    files: FileDTO[];
    users: User[];
  };
}> {
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

        {{#each @files as |model|}}
          <tr>

            <td width='15%' class='text-center font-bold'>
              {{t.serial_number}}
            </td>
            <td width='23.7%' class='text-center font-bold'>
              {{t.document_designation}}
            </td>
            <td width='39.55%' class='text-center font-bold' colspan='3'>
              {{t.product_name}}
            </td>
            <td width='15.23%' class='text-center font-bold'>
              {{t.version}}
            </td>
            <td width='15.23%' class='text-center font-bold'>
              {{t.last_change_number}}
            </td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td class='text-center'>{{model.designation}}</td>
            <td colspan='3'>{{model.documentName}}</td>
            <td class='text-center'>{{model.version}}</td>
            <td class='text-center'>{{model.lastChangeNumber}}</td>
          </tr>
          <tr>
            <td class='text-center font-bold' colspan='2'>
              {{@selectedAlgo}}
            </td>
            <td class='text-center' colspan='5'>
              {{model.hash}}
            </td>
          </tr>
          <tr>
            <td colspan='7' style='padding: 2px'>
              &nbsp;
            </td>
          </tr>
          <tr>
            <td class='text-center font-bold' colspan='3'>
              {{t.file_name}}
            </td>
            <td class='text-center font-bold'>
              {{t.last_modified}}
            </td>
            <td class='text-center font-bold' colspan='3' width='33.3%'>
              {{t.file_size}}
            </td>
          </tr>
          <tr>
            <td class='text-center' colspan='3'>
              {{model.fileName}}
            </td>
            <td class='text-center'>{{model.fileLastModified}}</td>
            <td class='text-center' colspan='3'>
              {{model.fileSize}}
            </td>
          </tr>
          <tr>
            <td colspan='7' style='padding: 2px'>
              &nbsp;
            </td>
          </tr>
        {{/each}}

      </table>

      <table style='margin-top: 2%'>
        <tr>
          <td width='25%' class='text-center font-bold'>
            {{t.work_type}}
          </td>
          <td width='25%' class='text-center font-bold'>
            {{t.full_name}}
          </td>
          <td width='25%' class='text-center font-bold'>
            {{t.signature}}
          </td>
          <td width='25%' class='text-center font-bold'>
            {{t.signing_date}}
          </td>
        </tr>

        {{#each @users as |user|}}
          <tr>
            <td width='25%'>{{user.role}}</td>
            <td width='25%'>{{user.lastName}}</td>
            <td width='25%'>&nbsp;</td>
            <td width='25%'>&nbsp;</td>
          </tr>
        {{/each}}

      </table>
    </div>
  </template>
}
