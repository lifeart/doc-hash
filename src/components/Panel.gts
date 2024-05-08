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
      <div class='px-3 py-3 sm:p-3'>
        <h3
          class='pl-4 text-base font-semibold leading-6 text-gray-900'
        >{{@title}}</h3>
        <div class='mt-2'>
          {{yield}}
        </div>
      </div>
    </div>
  </template>
}
