import { Component } from '@lifeart/gxt';
import { AlgorithmType, algos } from './../utils/constants';

export class Algorithms extends Component<{
  Args: { selected: AlgorithmType; onSelect: (alg: AlgorithmType) => void };
  Element: HTMLInputElement;
}> {
  <template>
    <div class='btn-group'>
      {{#each algos as |alg|}}
        <button
          class={{if (eq alg.value @selected) 'btn btn-dark' 'btn btn-light'}}
          {{on 'click' (fn @onSelect alg.value)}}
        >
          {{alg.label}}</button>
      {{/each}}
    </div>
  </template>
}
