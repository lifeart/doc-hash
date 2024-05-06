import { Component } from '@lifeart/gxt';

export class FileForm extends Component {
  <template>
    <div class='bg-success bg-opacity-10 pt-3 pb-4 px-4'><h3 class='py-2'>2.
        Файл</h3><div class='mt-3'><input
          type='file'
          class='form-control'
          id='filePz'
        /></div><div class='mt-4 d-flex flex-column align-items-start'><label
          class='form-label me-3 py-0'
        >Алгоритм расчета контрольной суммы:</label>
        {{yield}}</div></div>
  </template>
}
