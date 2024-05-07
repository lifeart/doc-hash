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
    <div>
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
