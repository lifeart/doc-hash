import { Component, tracked } from '@lifeart/gxt';
import { roles, t, type User } from './../utils/constants';

export class RoleForm extends Component<{
  Args: {
    users: Array<User>;
    onRemove: (user: User) => void;
    onAdd: (user: User) => void;
  };
}> {
  @tracked role = '';
  @tracked lastName = '';
  onAdd = () => {
    this.args.onAdd({ role: this.role, lastName: this.lastName });
    this.role = '';
    this.lastName = '';
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
    <div class='bg-warning bg-opacity-10 pt-3 pb-3 px-4'>
      <h3 class='py-2'>3. {{t.project_roles}}</h3>
      <div class='mb-3'>{{t.specify_role_and_surname}}</div>

      {{! ROLE LIST }}
      <ul class='list-group mb-3'>
        {{#each @users as |user|}}
          <li class='list-group-item'><div class='row'><div
                class='col-12 col-md-5 col-lg-6 d-flex align-items-center fw-bold'
              >{{user.role}}</div><div
                class='col-12 col-md-7 col-lg-6 d-flex flex-column flex-md-row align-items-stretch align-items-md-center justify-content-md-between'
              ><span>{{user.lastName}}</span><div
                  class='d-grid mt-2 mt-md-0'
                ><button
                    class='btn btn-light text-danger fw-bold'
                    {{on 'click' (fn @onRemove user)}}
                  >×</button></div></div></div></li>
        {{/each}}
      </ul>

      {{! ROLE LIST }}
      <div class='card bg-warning bg-opacity-10 border-0'><div
          class='card-body'
        ><div class='row g-2'><div class='col-12 col-md-5'><input
                type='text'
                placeholder={{t.role}}
                class='form-control'
                list='roles_list'
                value={{this.role}}
                {{on 'input' this.setRole}}
              /><datalist id='roles_list'>
                {{#each roles as |role|}}
                  <option value={{role.value}}>{{role.label}}</option>
                {{/each}}
              </datalist></div><div class='col-12 col-md-5'><input
                type='text'
                placeholder={{t.surname}}
                class='form-control'
                value={{this.lastName}}
                {{on 'input' this.setLastName}}
              /></div><div class='col-12 col-md-2'><div class='d-grid'><button
                  class='btn btn-secondary'
                  type='button'
                  disabled={{this.isFormInvalid}}
                  {{on 'click' this.onAdd}}
                >{{t.add}}</button></div></div></div></div></div>

      {{!  }}
    </div>
  </template>
}
