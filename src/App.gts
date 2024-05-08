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

export default class App extends Component {
  @tracked selectedAlgo = read('algo', algos[0].value) as AlgorithmType;
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
  onDocumentFieldChange = (field: DocumentField, value: string | number) => {
    // @ts-expect-error value is string | number
    this[field] = value;
    write(field, String(value));
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
  onFileSelect = (file: File | null) => {
    this.file = file;
  };
  setFileHash = (hash: string) => {
    this.fileHash = hash;
    write('fileHash', hash);
  };
  hashEffect = (_: HTMLDivElement) => {
    return effect(() => {
      const algo = this.selectedAlgo;
      const file = this.file;

      if (file) {
        getHash(file, algo).then((hash) => {
          this.setFileHash(hash);
        });
      } else {
        new Promise((resolve) => {
          resolve('');
        }).then(() => {
          this.setFileHash('');
        });
      }
    });
  };
  get isFormInvalid() {
    return (
      !this.designation ||
      !this.documentName ||
      !this.file ||
      !this.fileHash ||
      !this.users.length ||
      !this.version ||
      !this.lastChangeNumber ||
      !this.selectedAlgo
    );
  }
  get fileName() {
    return this.file?.name ?? '';
  }
  get fileSize() {
    return this.file?.size ?? '';
  }
  get fileLastModified() {
    return this.file?.lastModified
      ? new Date(this.file.lastModified).toLocaleString('ru-RU', {
          timeZone: 'Europe/Moscow',
        })
      : '';
  }
  onPrint = () => {
    // create new window and render Print component to it
    const win = window.open('', 'printwindow');
    if (!win) return;
    renderComponent(
      new Print({
        lastChangeNumber: this.lastChangeNumber,
        version: this.version,
        documentName: this.documentName,
        designation: this.designation,
        fileHash: this.fileHash,
        selectedAlgo: this.selectedAlgo,
        fileName: this.fileName,
        fileSize: this.fileSize,
        // 20.11.2023 00:11:28
        fileLastModified: this.fileLastModified,
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
      documentDesignation: this.designation,
      productName: this.documentName,
      version: this.version,
      lastChangeNumber: this.lastChangeNumber,
      hashValue: this.fileHash,
      hashFunction: this.selectedAlgo,
      fileName: this.fileName,
      lastModified: this.fileLastModified,
      fileSize: this.fileSize,
      users: this.users,
    }).then((link) => {
      this.fileLink = link;
      write('fileLink', link);
    });
  };
  docEffect = (_: HTMLDivElement) => {
    return effect(() => {
      if (!this.isFormInvalid) {
        this.generateDocument();
      }
    });
  };
  get docFileName() {
    const fileName = this.fileName.split(' ').join('_');
    const fileVersion = this.version;
    const lastChangeNumber = this.lastChangeNumber;
    return `${t.iul}__${fileName}__v.${fileVersion}.${lastChangeNumber}.docx`;
  }
  <template>
    <div
      class='mx-auto max-w-7xl px-4 sm:px-6 lg:px-8'
      {{this.hashEffect}}
      {{this.docEffect}}
    >
      <div class='mx-auto max-w-3xl'>
        <div class='pb-5'>
          <div class='py-3'>
            <h1 class='text-center py-3 text-gray-100 text-shadow'>{{t.title}}
            </h1></div>

          <Panel @title={{t.document}}>
            <DocumentForm
              @designation={{this.designation}}
              @documentName={{this.documentName}}
              @version={{this.version}}
              @lastChangeNumber={{this.lastChangeNumber}}
              @onChange={{this.onDocumentFieldChange}}
            />
          </Panel>

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

          <Panel @title={{t.project_roles}} class='mt-4'>
            <RoleForm
              @users={{this.users}}
              @onRemove={{this.onRemoveUser}}
              @onAdd={{this.onAddUser}}
            />
          </Panel>

          <Panel @title={{t.preview}} class='mt-4 pb-6'>
            <div shadowrootmode='open'>
              <Print
                @lastChangeNumber={{this.lastChangeNumber}}
                @version={{this.version}}
                @documentName={{this.documentName}}
                @designation={{this.designation}}
                @fileHash={{this.fileHash}}
                @selectedAlgo={{this.selectedAlgo}}
                @fileName={{this.fileName}}
                @fileSize={{this.fileSize}}
                @fileLastModified={{this.fileLastModified}}
                @users={{this.users}}
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

            <a
              href={{this.fileLink}}
              class='rounded block text-center w-full bg-indigo-50 px-2 py-2 text-sm font-semibold text-indigo-600 shadow-sm hover:bg-indigo-100 mt-2'
              download={{this.docFileName}}
            >
              {{t.download_assurance_sheet}}
            </a>
          </div></div></div></div>
  </template>
}
