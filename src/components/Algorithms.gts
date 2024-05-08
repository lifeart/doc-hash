import { Component } from '@lifeart/gxt';
import { AlgorithmType, algos } from './../utils/constants';

export class Algorithms extends Component<{
  Args: { selected: AlgorithmType; onSelect: (alg: AlgorithmType) => void };
  Element: HTMLInputElement;
}> {
  get items() {
    return algos.map((alg, i) => {
      let classNames: string[] = [];
      if (i !== 0) {
        classNames.push('-ml-px');
      }
      if (i === 0) {
        classNames.push('rounded-l-md');
      } else if (i === algos.length - 1) {
        classNames.push('rounded-r-md');
      }
      return {
        ...alg,
        class: classNames.join(' '),
      };
    });
  }
  <template>
    <div class='isolate inline-flex rounded-md shadow-sm'>
      {{#each this.items as |alg|}}
        <button
          class={{if (eq alg.value @selected) 'bg-blue-200' 'bg-white'}}
          class='relative inline-flex items-center px-3 py-2 text-sm font-semibold text-gray-900 ring-1 ring-inset ring-gray-300 hover:bg-blue-500 focus:z-10'
          class={{alg.class}}
          {{on 'click' (fn @onSelect alg.value)}}
        >
          {{alg.label}}</button>
      {{/each}}
    </div>
  </template>
}
