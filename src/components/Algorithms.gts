import { Component } from '@lifeart/gxt';
import { AlgorithmType, algos } from '@/utils/constants';

function includes(items: string[], item: string) {
  return items.includes(item);
}

export class Algorithms extends Component<{
  Args: { selected: AlgorithmType[]; onSelect: (alg: AlgorithmType) => void };
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
    <div class='isolate flex rounded-md shadow-sm w-full'>
      {{#each this.items as |alg|}}
        <button
          class='relative inline-flex justify-center items-center flex-grow px-3 py-2 text font-semibold text-gray-900 ring-1 ring-inset ring-gray-300 hover:bg-blue-200 focus:z-10'
          class={{if (includes @selected alg.value) 'bg-blue-100' 'bg-white'}}
          class={{alg.class}}
          {{on 'click' (fn @onSelect alg.value)}}
        >
          {{alg.label}}
        </button>
      {{/each}}
    </div>
  </template>
}
