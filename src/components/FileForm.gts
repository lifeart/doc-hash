import { Component } from '@lifeart/gxt';
import { t } from '@/utils/t';
import { Input } from '@/components/Input';
import { Label } from '@/components/Label';

export class FileForm extends Component<{
  Args: {
    onFileSelect: (file: FileList) => void;
  };
  Blocks: {
    default: [];
  };
}> {
  onFileChange = (e: Event) => {
    const target = e.target as HTMLInputElement;
    const files = target.files;
    if (!files) {
      return;
    }
    this.args.onFileSelect(files);
  };
  <template>
    <div class='p-3'>
      <div class='mt-0'>
        <Label @for='file'>{{t.specify_files}}</Label>
        <Input
          type='file'
          id='file'
          multiple={{true}}
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
