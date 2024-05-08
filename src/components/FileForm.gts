import { Component } from '@lifeart/gxt';
import { t } from './../utils/constants';
import { Input } from './Input';

export class FileForm extends Component<{
  Args: {
    onFileSelect: (file: File | null) => void;
  };
  Blocks: {
    default: [];
  };
}> {
  onFileChange = (e: Event) => {
    const target = e.target as HTMLInputElement;
    const file = target.files?.[0];
    this.args.onFileSelect(file ?? null);
  };
  <template>
    <div>
      <div class='mt-3'>
        <Input
          type='file'
          id='filePz'
          {{on 'change' this.onFileChange}}
          @value={{''}}
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
