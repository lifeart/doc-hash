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
    <label
      class='block text-sm font-medium leading-6 text-gray-900'
      for={{@for}}
      ...attributes
    >{{yield}}
    </label>
  </template>
}
