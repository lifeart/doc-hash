import { Component, tracked } from '@lifeart/gxt';
import { roles, t, type User } from './../utils/constants';
import { RoleList } from './RoleList';
import { Input } from './Input';

export class RoleForm extends Component<{
  Args: {
    users: Array<User>;
    onRemove: (user: User) => void;
    onAdd: (user: User) => void;
  };
}> {
  @tracked role = '';
  @tracked lastName = '';
  onAdd = (e: Event) => {
    e.preventDefault();
    this.args.onAdd({ role: this.role, lastName: this.lastName });
    this.role = '';
    this.lastName = '';
    requestAnimationFrame(() => {
      document.getElementById('roles-list')?.focus();
    });
  };
  setRole = (event: Event) => {
    this.role = (event.target as HTMLInputElement).value;
  };
  setLastName = (event: Event) => {
    this.lastName = (event.target as HTMLInputElement).value;
  };
  get isFormInvalid() {
    return !this.role.length || !this.lastName.length;
  }
  <template>
    <div>
      {{#if (not @users.length)}}
        <div
          class='alert alert-warning mt-4'
        >{{t.specify_role_and_surname}}</div>
      {{/if}}
      <ul role='list' class='divide-y divide-gray-200'>
        {{#each @users as |user|}}
          <RoleList @user={{user}} @onRemove={{@onRemove}} />
        {{/each}}
      </ul>

      {{! ROLE LIST }}
      <div class='py-2'>
        <form class='flex justify-between' {{on 'submit' this.onAdd}}>
          <div class='flex-col w-2/5 px-4'>
            <Input
              type='text'
              placeholder={{t.role}}
              class={{if
                (not this.role.length)
                'border-orange-200'
                'border-blue-400'
              }}
              list='roles_list'
              id='roles-list'
              @value={{this.role}}
              required={{true}}
              {{on 'input' this.setRole}}
            />
            <datalist id='roles_list'>
              {{#each roles as |role|}}
                <option value={{role.value}}>{{role.label}}</option>
              {{/each}}
            </datalist>
          </div>
          <div class='flex-col w-2/5 px-4'>
            <Input
              type='text'
              placeholder={{t.surname}}
              class={{if
                (not this.lastName.length)
                'border-orange-200'
                'border-blue-400'
              }}
              @value={{this.lastName}}
              required={{true}}
              {{on 'input' this.setLastName}}
            />
          </div>
          <div class='flex-col w-1/5 px-4'>
            <div class='d-grid'>
              <button
                class='bg-blue-500 border-2 border-blue-700 hover:bg-indigo-700 text-white font-bold p-2 rounded shadow-sm cursor-pointer transition duration-300 ease-in-out'
                class={{if this.isFormInvalid 'btn-secondary' 'btn-primary'}}
                type='submit'
              >{{t.add}}</button>
            </div>
          </div>
        </form>
      </div>
    </div>
  </template>
}
