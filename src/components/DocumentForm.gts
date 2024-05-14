import { Component } from '@lifeart/gxt';
import { type DocumentField } from '@/utils/constants';
import { Input } from '@/components/Input';
import { Label } from '@/components/Label';
import { t } from '@/utils/t';

export class DocumentForm extends Component<{
  Args: {
    designation: string;
    documentName: string;
    serialNumber: number | string;
    objectName: string;
    lastChangeNumber: number;
    onChange: (field: DocumentField, value: string | number) => void;
  };
}> {
  onChange = (field: DocumentField, e: Event) => {
    const target = e.target as HTMLInputElement;
    if (field === 'serialNumber') {
      const v = target.valueAsNumber;
      if (isNaN(v)) {
        this.args.onChange(field, '');
        return;
      } else {
        this.args.onChange(field, v);
        return;
      }
    } else if (field === 'lastChangeNumber') {
      this.args.onChange(field, target.valueAsNumber);
    } else {
      this.args.onChange(field, target.value);
    }
  };

  <template>
    <div>
      <div class='flex'>
        <div class='flex-auto p-4'>
          <Label @for='object-name'>{{t.object_name}}:</Label>
          <Input
            type='text'
            id='object-name'
            @value={{@objectName}}
            class={{if (not @objectName.length) 'border-danger' ''}}
            {{on 'input' (fn this.onChange 'objectName')}}
          />
        </div>
      </div>
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
          <Label @for='document-name'>{{t.document_name}}:</Label>
          <textarea
            id='document-name'
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
          <Label @for='version'>{{t.serial_number}}:</Label>
          <Input
            type='number'
            min='0'
            max='99999999'
            step='1'
            id='version'
            @value={{@serialNumber}}
            class={{if (not @serialNumber) 'border-danger' ''}}
            {{on 'input' (fn this.onChange 'serialNumber')}}
          />
        </div>

        <div class='flex-auto p-4'>
          <Label @for='last-change-number'>{{t.last_change_number}}:</Label>

          <Input
            type='number'
            min='1'
            max='9999'
            step='1'
            class={{if (not @lastChangeNumber) 'border-danger' ''}}
            id='last-change-number'
            @value={{@lastChangeNumber}}
            {{on 'input' (fn this.onChange 'lastChangeNumber')}}
          />
        </div>
      </div>
    </div>
  </template>
}
