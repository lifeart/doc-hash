import { Component, tracked } from '@lifeart/gxt';

import { Algorithms } from './components/Algorithms';
import { RoleForm } from './components/RoleForm';
import { FileForm } from './components/FileForm';
import { DocumentForm } from './components/DocumentForm';
import { AlgorithmType, algos, type User } from './utils/constants';

export default class App extends Component {
  @tracked selectedAlgo = algos[0].value;
  selectAlgo = (name: AlgorithmType) => {
    this.selectedAlgo = name;
  };
  @tracked
  users: User[] = [
      { lastName: 'Иванов Иван Иванович', role: 'Эксперт' },
      { lastName: 'Петров Петр Петрович', role: 'Эксперт' },
      { lastName: 'Сидоров Сидор Сидорович', role: 'Эксперт' },
    ];
  onRemoveUser = (user: User) => {
    this.users = this.users.filter((u) => u !== user);
  };
  onAddUser = (user: User) => {
    this.users = [...this.users, user];
  };
  <template>
    <div class='container py-2'>
      <div class='row justify-content-center'><div
          class='col-12 col-md-10 col-lg-8 bg-white pb-5 rounded-3'
        ><div
            class='d-flex flex-column justify-content-center align-items-center py-3'
          ><h1
              class='text-center py-3'
              style='font-size: 16px; font-weight: 500;'
            >Конструктор информационно-удостоверяющих листов<br />для
              экспертизы. [GXT]</h1></div>
          <DocumentForm />

          <FileForm>
            <Algorithms
              @selected={{this.selectedAlgo}}
              @onSelect={{this.selectAlgo}}
            />
          </FileForm>

          <RoleForm 
            @users={{this.users}}
            @onRemove={{this.onRemoveUser}}
            @onAdd={{this.onAddUser}}
          />
          <div class='mt-3 mb-3 d-grid'><button
              disabled=''
              class='btn btn-lg btn-success'
            >Создать
            </button></div></div></div></div>
  </template>
}
