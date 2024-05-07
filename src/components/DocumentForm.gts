import { Component } from '@lifeart/gxt';
import { type DocumentField, t } from './../utils/constants';

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
      <div>
        <label for='formOboz' class='form-label'>{{t.designation}}:</label>
        <input
          type='text'
          class='form-control'
          id='formOboz'
          value={{@designation}}
          class={{if (not @designation.length) 'border-danger' ''}}
          {{on 'input' (fn this.onChange 'designation')}}
        />
      </div>

      <div class='mt-3'>
        <label for='formNaim' class='form-label'>{{t.document_name}}:</label>
        <textarea
          class='form-control'
          id='formNaim'
          value={{@document_name}}
          class={{if (not @document_name.length) 'border-danger' ''}}
          rows='3'
          {{on 'input' (fn this.onChange 'document_name')}}
        ></textarea>
      </div>

      <div class='row'>
        <div class='mt-3 col-6 col-md-6 col-lg-6'>
          <label for='formVer' class='form-label'>{{t.version}}:</label>
          <input
            type='number'
            class='form-control'
            id='formVer'
            value={{@version}}
            class={{if (not @version) 'border-danger' ''}}
            {{on 'input' (fn this.onChange 'version')}}
          />
        </div>

        <div class='mt-3 col-6 col-md-6 col-lg-6'>
          <label
            for='formNum'
            class='form-label'
          >{{t.last_change_number}}:</label>
          <input
            type='number'
            class='form-control'
            class={{if (not @last_change_number) 'border-danger' ''}}
            id='formNum'
            value={{@last_change_number}}
            {{on 'input' (fn this.onChange 'last_change_number')}}
          />
        </div>
      </div>
    </div>
  </template>
}
