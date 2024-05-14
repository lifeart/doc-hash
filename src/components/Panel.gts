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
    <div class='bg-white shadow rounded-lg' ...attributes>
      <div class='px-3 py-3 sm:p-3'>
        <h2
          class='pl-4 text-lg font-semibold leading-6 text-gray-900 flex justify-between items-center'
        >
          <span class='cursor-pointer truncate' {{on 'click' this.onToggle}}>
            {{@title}}
          </span>
          {{#if this.canRemove}}
            <button
              class='ml-2 text-red-600'
              type='button'
              {{on 'click' @onRemove}}
            >
              ×
            </button>
          {{/if}}
        </h2>

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
