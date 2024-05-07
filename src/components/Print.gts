import { Component } from '@lifeart/gxt';
import { style } from './../utils/print-style';
import { t } from './../utils/constants';

export class Print extends Component {
  <template>
    <style>{{style}}</style>
    <div class='header'>
      <button class='header__button'>
        Печать
      </button>
    </div>

    <div class='container'>
      <h1>{{t.assurance_sheet}}</h1>

      <table>
        <tr>
          <td class='text-center font-bold'>
            №<br />
            п/п
          </td>
          <td width='23.7%' class='text-center font-bold'>
            Обозначение
            <br />
            документа
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
          <td class='text-center'>{{@designation}}</td>
          <td colspan='3'>{{@document_name}}</td>
          <td class='text-center'>{{@version}}</td>
          <td class='text-center'>{{@last_change_number}}</td>
        </tr>

        <tr>
          <td class='text-center font-bold' colspan='2'>
            {{@selectedAlgo}}
          </td>
          <td class='text-center' colspan='5'>
            {{@fileHash}}
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
            {{@fileName}}
          </td>
          <td class='text-center'>{{@fileLastModified}}</td>
          <td class='text-center' colspan='3'>
            {{@fileSize}}
          </td>
        </tr>
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
