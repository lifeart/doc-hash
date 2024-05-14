import { Component, tracked, effect, renderComponent } from '@lifeart/gxt';

import { Algorithms } from './components/Algorithms';
import { RoleForm } from './components/RoleForm';
import { FileForm } from './components/FileForm';
import { DocumentForm } from './components/DocumentForm';
import { Print } from '@/components/Print';
import { Panel } from '@/components/Panel';
import {
  AlgorithmType,
  algos,
  type User,
  getHash,
  type DocumentField,
} from '@/utils/constants';
import { createAssuranceSheet } from '@/utils/document-creator';
import { read, write } from '@/utils/persisted';
import { t } from '@/utils/t';
import { concat } from '@/utils/helpers';
import { addFilesToDto, FileDTO, removeFile } from './utils/file-manager';

export default class App extends Component {
  @tracked selectedAlgo = read('algo', algos[0].value) as AlgorithmType;
  get selectedAlgoName() {
    const active = this.selectedAlgo;
    return algos.find((algo) => active === algo.value)!.label;
  }
  @tracked
  users: User[] = JSON.parse(
    read(
      'users',
      JSON.stringify([
        { lastName: 'Иванов Иван Иванович', role: 'Эксперт' },
        { lastName: 'Петров Петр Петрович', role: 'Эксперт' },
        { lastName: 'Сидоров Сидор Сидорович', role: 'Эксперт' },
      ]),
    ),
  ) as User[];
  @tracked file: null | File = null;
  @tracked
  designation: string = read('designation', '');
  @tracked
  documentName: string = read('documentName', '');
  @tracked
  version: number = parseInt(read('version', '1'), 10);
  @tracked
  lastChangeNumber: number = parseInt(read('lastChangeNumber', '1'), 10);
  @tracked
  fileHash: string = read('fileHash', '');
  @tracked
  fileLink: string = read('fileLink', '');
  @tracked
  models: FileDTO[] = [];
  onDocumentFieldChange = (
    dto: FileDTO,
    field: DocumentField,
    value: string | number,
  ) => {
    // @ts-expect-error value is string | number
    dto[field] = value;
    this.saveModel(dto);
  };
  selectAlgo = (name: AlgorithmType) => {
    this.selectedAlgo = name;
    write('algo', name);
  };
  onRemoveUser = (user: User) => {
    this.users = this.users.filter((u) => u !== user);
    write('users', this.users);
  };
  onAddUser = (user: User) => {
    this.users = [...this.users, user];
    write('users', this.users);
  };
  onFileSelect = (fileList: FileList) => {
    this.models = addFilesToDto(fileList);
  };
  setFileHash = (hash: string) => {
    this.fileHash = hash;
    write('fileHash', hash);
  };

  get isFormInvalid() {
    return (
      !this.models.length ||
      !this.users.length ||
      !this.selectedAlgo ||
      this.models.some((model) => {
        return model.isInvalid;
      })
    );
  }
  get fileName() {
    return this.file?.name ?? '';
  }
  get fileSize() {
    return this.file?.size ?? '';
  }
  onRemoveFile = (model: FileDTO) => {
    this.models = removeFile(model);
  };
  setFileLink = (link: string) => {
    this.fileLink = link;
    write('fileLink', link);
  };
  onPrint = () => {
    // create new window and render Print component to it
    const win = window.open('', 'printwindow');
    if (!win) return;
    win.document.title = t.iul;
    renderComponent(
      new Print({
        selectedAlgo: this.selectedAlgoName,
        files: this.models,
        users: this.users,
      }) as any,
      win.document.body,
    );
    // win.document.write(printLink);
    win.document.body.addEventListener('click', () => {
      win.print();
      win.close();
    });
    win.document.close();
    win.focus();
  };
  generateDocument = () => {
    createAssuranceSheet({
      hashFunction: this.selectedAlgoName,
      users: this.users,
      files: this.models,
    }).then((link) => {
      this.setFileLink(link);
    });
  };
  get docFileName() {
    const totalFileSize = this.models.reduce((acc, item) => {
      return acc + item.fileSize;
    }, 0);
    return `${t.iul}_${new Date()
      .toLocaleString('ru-RU', {
        timeZone: 'Europe/Moscow',
        dateStyle: 'short',
        timeStyle: 'short',
      })
      .replace(',', '_')}_${totalFileSize}b.docx`;
  }
  get currentDateTime() {
    return;
  }
  cleanup = (_: HTMLDivElement) => {
    return () => {
      this.effects.forEach((destructor) => {
        destructor();
      });
    };
  };
  async calcFileHashes(models: FileDTO[], algo: AlgorithmType) {
    for (let model of models) {
      const file = model.file;
      if (!file) {
        continue;
      }
      const hash = await getHash(file, algo);
      model.hash = hash;
    }
    this.persistFiles();
  }
  saveModel(model: FileDTO) {
    write(
      model.key,
      JSON.stringify({
        designation: model.designation,
        documentName: model.documentName,
        version: model.version,
        lastChangeNumber: model.lastChangeNumber,
      }),
    );
  }
  persistFiles() {
    for (const model of this.models) {
      this.saveModel(model);
    }
  }
  effects = [
    effect(() => {
      if (!this.isFormInvalid) {
        this.generateDocument();
      } else {
        this.setFileLink('');
      }
    }),
    effect(() => {
      const algo = this.selectedAlgo;
      const models = this.models;
      this.calcFileHashes(models, algo);
    }),
  ];
  <template>
    <div class='mx-auto max-w-7xl px-4 sm:px-6 lg:px-8' {{this.cleanup}}>
      <div class='mx-auto max-w-3xl'>
        <div class='pb-5'>
          <div class='py-3'>
            <h1 class='text-center py-3 text-gray-100 text-shadow'>{{t.title}}
            </h1></div>

          <Panel @title={{t.file}} class='mt-4'>
            <FileForm @onFileSelect={{this.onFileSelect}}>
              <div class='flex'>
                <div class='flex-auto'>
                  <Algorithms
                    @selected={{this.selectedAlgo}}
                    @onSelect={{this.selectAlgo}}
                  />
                </div>
                <div class='flex-auto'>
                  <pre
                    class='pt-2 font-weight-bold text-sm overflow-hidden p-2'
                  >{{this.fileHash}}</pre>
                </div>
              </div>
            </FileForm>
          </Panel>

          {{#each this.models as |file|}}
            <Panel
              class='mt-2'
              @title={{concat t.document file.fileName}}
              @onRemove={{fn this.onRemoveFile file}}
            >
              <DocumentForm
                @designation={{file.designation}}
                @documentName={{file.documentName}}
                @version={{file.version}}
                @lastChangeNumber={{file.lastChangeNumber}}
                @onChange={{fn this.onDocumentFieldChange file}}
              />
            </Panel>
          {{/each}}

          <Panel @title={{t.project_roles}} class='mt-4'>
            <RoleForm
              @users={{this.users}}
              @onRemove={{this.onRemoveUser}}
              @onAdd={{this.onAddUser}}
            />
          </Panel>

          <Panel @title={{t.preview}} class='mt-4 pb-6'>
            <div shadowrootmode='open' style.font-size='12px'>
              <Print
                @files={{this.models}}
                @users={{this.users}}
                @selectedAlgo={{this.selectedAlgoName}}
                @hidePrintButton={{true}}
              />
            </div>

          </Panel>

          <div class='mt-3 mb-3'><button
              class='rounded w-full bg-indigo-600 px-2 py-2 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600'
              class={{if this.isFormInvalid 'btn-danger' 'btn-success'}}
              type='button'
              target='_blank'
              rel='noreferrer'
              {{on 'click' this.onPrint}}
            >
              {{t.print}}
            </button>

            {{#if this.fileLink}}
              <a
                href={{this.fileLink}}
                class='rounded block text-center w-full bg-indigo-50 px-2 py-2 text-sm font-semibold text-indigo-600 shadow-sm hover:bg-indigo-100 mt-2'
                download={{this.docFileName}}
              >
                {{t.download_assurance_sheet}}
              </a>
            {{/if}}
          </div></div></div></div>
  </template>
}
