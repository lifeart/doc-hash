import { Component } from '@lifeart/gxt';

export class Input extends Component<{
  Args: {
    value: string | number;
  };
  Element: HTMLInputElement;
}> {
  <template>
    <input
      type='text'
      class='bg-white border-2 text-black border-sm placeholder-gray-400 w-full p-2 rounded shadow-md cursor-text transition duration-300 ease-in-out'
      ...attributes
      value={{@value}}
    />
  </template>
}
