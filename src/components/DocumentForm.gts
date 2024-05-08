import { Component } from '@lifeart/gxt';
import { type DocumentField } from '@/utils/constants';
import { Input } from '@/components/Input';
import { Label } from '@/components/Label';
import { t } from '@/utils/t';

export class DocumentForm extends Component<{
  Args: {
    designation: string;
    documentName: string;
    version: number;
    lastChangeNumber: number;
    onChange: (field: DocumentField, value: string | number) => void;
  };
}> {
  onChange = (field: DocumentField, e: Event) => {
    const target = e.target as HTMLInputElement;
    if (field === 'version' || field === 'lastChangeNumber') {
      this.args.onChange(field, target.valueAsNumber);
    } else {
      this.args.onChange(field, target.value);
    }
  };

  <template>
    <div>
      <div class='flex'>
        <div class='flex-auto p-4'>
          <Label @for='designation'>{{t.designation}}:</Label>
          <Input
            type='text'
            id='designation'
            @value={{@designation}}
            class={{if (not @designation.length) 'border-danger' ''}}
            {{on 'input' (fn this.onChange 'designation')}}
          />
        </div>
      </div>

      <div class='flex'>
        <div class='flex-auto p-4'>
          <Label @for='document_name'>{{t.document_name}}:</Label>
          <textarea
            id='document_name'
            value={{@documentName}}
            class='block w-full rounded-md border-0 p-2 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6'
            class={{if (not @documentName.length) 'border-danger' ''}}
            rows='2'
            {{on 'input' (fn this.onChange 'documentName')}}
          ></textarea>
        </div>
      </div>

      <div class='flex'>
        <div class='flex-auto p-4'>
          <Label @for='version'>{{t.version}}:</Label>
          <Input
            type='number'
            min='1'
            max='9999'
            step='1'
            id='version'
            @value={{@version}}
            class={{if (not @version) 'border-danger' ''}}
            {{on 'input' (fn this.onChange 'version')}}
          />
        </div>

        <div class='flex-auto p-4'>
          <Label @for='last_change_number'>{{t.last_change_number}}:</Label>

          <Input
            type='number'
            min='1'
            max='9999'
            step='1'
            class={{if (not @lastChangeNumber) 'border-danger' ''}}
            id='last_change_number'
            @value={{@lastChangeNumber}}
            {{on 'input' (fn this.onChange 'lastChangeNumber')}}
          />
        </div>
      </div>
    </div>
  </template>
}
