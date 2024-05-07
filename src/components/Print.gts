import { Component } from '@lifeart/gxt';
import { style } from './../utils/print-style';

export class Print extends Component {
  <template>
    <style>{{style}}</style>
    <div class='header'>
      <button class='header__button'>
        Печать
      </button>
    </div>

    <div class='container'>
      <h1>Информационно-удостоверяющий лист</h1>

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
            Наименование изделия,
            <br />
            наименование документа
          </td>
          <td width='15.23%' class='text-center font-bold'>
            Версия
          </td>
          <td width='15.23%' class='text-center font-bold'>
            Номер
            <br />
            последнего
            <br />
            изменения
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
            Наименование файла
          </td>
          <td class='text-center font-bold'>
            Дата и время
            <br />
            последнего изменения файла
          </td>
          <td class='text-center font-bold' colspan='3' width='33.3%'>
            Размер файла,
            <br />
            байт
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
            Характер работы
          </td>
          <td width='25%' class='text-center font-bold'>
            ФИО
          </td>
          <td width='25%' class='text-center font-bold'>
            Подпись
          </td>
          <td width='25%' class='text-center font-bold'>
            Дата подписания
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
