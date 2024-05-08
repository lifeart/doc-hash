import { Component } from '@lifeart/gxt';

export class Label extends Component<{
  Args: {
    for?: string;
  };
  Element: HTMLLabelElement;
  Blocks: {
    default: [];
  };
}> {
  <template>
    <label class='w-full h-6 text-gray-600' for={{@for}} ...attributes>{{yield}}
    </label>
  </template>
}
