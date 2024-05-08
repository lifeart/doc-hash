import { Component } from '@lifeart/gxt';
import { type DocumentField, t } from './../utils/constants';
import { Input } from './Input';
import { Label } from './Label';

export class DocumentForm extends Component<{
  Args: {
    designation: string;
    document_name: string;
    version: number;
    last_change_number: number;
    onChange: (field: DocumentField, value: string | number) => void;
  };
}> {
  onChange = (field: DocumentField, e: Event) => {
    const target = e.target as HTMLInputElement;
    if (field === 'version' || field === 'last_change_number') {
      this.args.onChange(field, target.valueAsNumber);
    } else {
      this.args.onChange(field, target.value);
    }
  };

  <template>
    <div>
      <div class='flex'>
        <div class='flex-auto'>
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
        <div class='flex-auto'>
          <Label @for='document_name'>{{t.document_name}}:</Label>
          <textarea
            id='document_name'
            value={{@document_name}}
            class={{if (not @document_name.length) 'border-danger' ''}}
            rows='3'
            {{on 'input' (fn this.onChange 'document_name')}}
          ></textarea>
        </div>
      </div>

      <div class='flex'>
        <div class='flex-auto'>
          <Label @for='version'>{{t.version}}:</Label>
          <Input
            type='number'
            id='version'
            @value={{@version}}
            class={{if (not @version) 'border-danger' ''}}
            {{on 'input' (fn this.onChange 'version')}}
          />
        </div>

        <div class='flex-auto'>
          <Label @for='last_change_number'>{{t.last_change_number}}:</Label>

          <Input
            type='number'
            class={{if (not @last_change_number) 'border-danger' ''}}
            id='last_change_number'
            @value={{@last_change_number}}
            {{on 'input' (fn this.onChange 'last_change_number')}}
          />
        </div>
      </div>
    </div>
  </template>
}
