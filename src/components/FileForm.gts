import { Component } from '@lifeart/gxt';
import { t } from './../utils/constants';

export class FileForm extends Component<{
  onFileSelect: (file: File) => void;
}> {
  onFileChange = (e: Event) => {
    const file = e.target.files[0];
    this.args.onFileSelect(file ?? null);
  };
  <template>
    <div class='bg-success bg-opacity-10 pt-3 pb-4 px-4'>
      <h3 class='py-2'>2. {{t.file}}</h3>
      <div class='mt-3'>
        <input
          type='file'
          class='form-control'
          id='filePz'
          {{on 'change' this.onFileChange}}
        />
      </div>
      <div class='mt-4 d-flex flex-column align-items-start'>
        <label
          class='form-label me-3 py-0'
        >{{t.checksum_calculation_algorithm}}:</label>
        {{yield}}
      </div>
    </div>
  </template>
}
