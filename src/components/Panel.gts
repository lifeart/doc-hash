import { Component, tracked } from '@lifeart/gxt';

export class Panel extends Component<{
  Args: {
    title: string;
    onRemove?: () => void;
    isInnitiallyExpanded?: boolean;
  };
  Element: HTMLDivElement;
  Blocks: {
    default: [];
  };
}> {
  get canRemove() {
    return typeof this.args.onRemove === 'function';
  }
  @tracked isExpanded = this.args.isInnitiallyExpanded ?? true;
  onToggle = () => {
    this.isExpanded = !this.isExpanded;
  };
  <template>
    <div class='bg-white shadow sm:rounded-lg' ...attributes>
      <div class='px-3 py-3 sm:p-3'>
        <h3 class='pl-4 text-base font-semibold leading-6 text-gray-900'><small
            class='cursor-pointer'
            {{on 'click' this.onToggle}}
          >{{@title}}</small>
          {{#if this.canRemove}}
            <button
              class='ml-2 text-red-600 text-right'
              type='button'
              {{on 'click' @onRemove}}
            >x</button>
          {{/if}}

        </h3>
        {{#if (has-block 'default')}}
          {{#if this.isExpanded}}
            <div class='mt-2'>
              {{yield}}
            </div>
          {{/if}}
        {{/if}}
      </div>
    </div>
  </template>
}
