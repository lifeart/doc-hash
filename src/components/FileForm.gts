import { Component } from '@lifeart/gxt';
import { t } from './../utils/constants';
import { Input } from './Input';
import { Label } from './Label';

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
    <div class='p-3'>
      <div class='mt-0'>
        <Input
          type='file'
          id='filePz'
          {{on 'change' this.onFileChange}}
          @value={{''}}
        />
      </div>
      <div class='mt-6 d-flex flex-column align-items-start'>
        <Label @for=''>{{t.checksum_calculation_algorithm}}:</Label>
        {{yield}}
      </div>
    </div>
  </template>
}
