import { Component, tracked, effect } from '@lifeart/gxt';

import { Algorithms } from './components/Algorithms';
import { RoleForm } from './components/RoleForm';
import { FileForm } from './components/FileForm';
import { DocumentForm } from './components/DocumentForm';
import { AlgorithmType, algos, type User, getHash } from './utils/constants';

export default class App extends Component {
  @tracked selectedAlgo = algos[0].value;
  @tracked
  users: User[] = [
    { lastName: 'Иванов Иван Иванович', role: 'Эксперт' },
    { lastName: 'Петров Петр Петрович', role: 'Эксперт' },
    { lastName: 'Сидоров Сидор Сидорович', role: 'Эксперт' },
  ];
  @tracked file: null | File = null;
  @tracked
  designation: string = '';
  @tracked
  document_name: string = '';
  @tracked
  version: number = 1;
  @tracked
  last_change_number: number = 1;
  @tracked
  fileHash: string = '';
  onDocumentFieldChange = (field: string, value: string | number) => {
    this[field] = value;
  };
  selectAlgo = (name: AlgorithmType) => {
    this.selectedAlgo = name;
  };
  onRemoveUser = (user: User) => {
    this.users = this.users.filter((u) => u !== user);
  };
  onAddUser = (user: User) => {
    this.users = [...this.users, user];
  };
  onFileSelect = (file: File) => {
    this.file = file;
  };
  hashEffect = () => {
    return effect(() => {
      console.log('hashEffect');
      const algo = this.selectedAlgo;
      const file = this.file;
      
      if (file) {
        getHash(file, algo).then((hash) => {
          console.log('hash', hash);
          this.fileHash = hash;
        });
      } else {
        new Promise((resolve) => {
          resolve('');
        }).then((hash) => {
          this.fileHash = '';
        });
      }
    })
  }
  get isFormInvalid() {
    return !this.designation || !this.document_name || !this.file || !this.fileHash || !this.users.length || !this.version || !this.last_change_number || !this.selectedAlgo;
  }
  <template>
    <div class='container py-2' {{this.hashEffect}}>
      <div class='row justify-content-center'><div
          class='col-12 col-md-10 col-lg-8 bg-white pb-5 rounded-3'
        ><div
            class='d-flex flex-column justify-content-center align-items-center py-3'
          ><h1
              class='text-center py-3'
              style='font-size: 16px; font-weight: 500;'
            >Конструктор информационно-удостоверяющих листов<br />для
              экспертизы. [GXT] {{this.fileHash}}</h1></div>
          <DocumentForm
            @designation={{this.designation}}
            @document_name={{this.document_name}}
            @version={{this.version}}
            @last_change_number={{this.last_change_number}}
            @onChange={{this.onDocumentFieldChange}}
          />

          <FileForm
            @onFileSelect={{this.onFileSelect}}
          >
          <div class="container">
            <div class="row">
              <div class="col-4">
                <Algorithms
                  @selected={{this.selectedAlgo}}
                  @onSelect={{this.selectAlgo}}
                />
              </div>
              <div class="col-8">
                <pre class="pt-2 font-weight-bold">{{this.fileHash}}</pre>
              </div>
            </div>
            </div>
          </FileForm>

          <RoleForm
            @users={{this.users}}
            @onRemove={{this.onRemoveUser}}
            @onAdd={{this.onAddUser}}
          />
          <div class='mt-3 mb-3 d-grid'><button
              class='btn btn-lg'
              class={{if this.isFormInvalid 'btn-danger' 'btn-success'}}
            >Создать
            </button></div></div></div></div>
  </template>
}
