import { Component } from '@lifeart/gxt';

export class Panel extends Component<{
  Args: {
    title: string;
  };
  Element: HTMLDivElement;
  Blocks: {
    default: [];
  };
}> {
  <template>
    <div class='bg-white shadow sm:rounded-lg' ...attributes>
      <div class='px-4 py-5 sm:p-6'>
        <h3
          class='text-base font-semibold leading-6 text-gray-900'
        >{{@title}}</h3>
        <div class='mt-5'>
          {{yield}}
        </div>
      </div>
    </div>
  </template>
}
