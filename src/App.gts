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
  CHUNK_SIZE,
} from '@/utils/constants';
import { createAssuranceSheet } from '@/utils/document-creator';
import { read, write } from '@/utils/persisted';
import { t } from '@/utils/t';
import {
  addFilesToDto,
  DocumentDTO,
  FileDTO,
  removeFile,
} from './utils/file-manager';
import { Progress } from './utils/progress';
import { delay } from './utils/timers';

export default class App extends Component {
  epoch = 0;
  @tracked doc = new DocumentDTO();
  @tracked selectedAlgo = read('algo', algos[0].value) as AlgorithmType;
  get selectedAlgoName() {
    const active = this.selectedAlgo;
    return algos.find((algo) => active === algo.value)!.label;
  }
  @tracked
  users: User[] = JSON.parse(
    read(
      'users',
      JSON.stringify([{ lastName: 'Иванов Иван Иванович', role: 'Эксперт' }]),
    ),
  ) as User[];
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
    write(field, value as string);
  };
  selectAlgo = (name: AlgorithmType) => {
    this.epoch++;
    this.selectedAlgo = name;
    for (let model of this.models) {
      model.hash = '';
    }
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

  get isFormInvalid() {
    const hasDocuments = this.models.length;
    const hasUsers = this.users.length;
    const hasAlgo = this.selectedAlgo;
    const isInvalid =
      this.models.filter((model) => {
        const isInvalid = model.isInvalid;
        const hasInvalidAlgo = model.algo !== hasAlgo;
        return hasInvalidAlgo || isInvalid;
      }).length > 0;
    if (!hasDocuments) {
      console.log('No documents');
    } else if (!hasUsers) {
      console.log('No users');
    } else if (!hasAlgo) {
      console.log('No algo');
    } else if (isInvalid) {
      console.log('Invalid files');
    }

    return !hasDocuments || !hasUsers || !hasAlgo || isInvalid;
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
        doc: this.doc,
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
  generateDocument = (epoch: number) => {
    createAssuranceSheet({
      hashFunction: this.selectedAlgoName,
      users: this.users,
      files: this.models,
      doc: this.doc,
    }).then((link) => {
      if (this.epoch !== epoch) {
        this.setFileLink('');
        return;
      }
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
  cleanup = (_: HTMLDivElement) => {
    return () => {
      this.effects.forEach((destructor) => {
        destructor();
      });
    };
  };
  async calcFileHashes(models: FileDTO[], algo: AlgorithmType, epoch: number) {
    while (this.progress) {
      await delay(100);
    }
    if (this.epoch !== epoch) {
      return;
    }
    const modelsToProcess = models.filter(
      (model) => model.file && (!model.hash || model.algo !== algo),
    );
    let chunksToProcess = modelsToProcess.reduce((acc, model) => {
      return acc + (Math.floor(model.file!.size / CHUNK_SIZE) || 1);
    }, 0);
    let processedChunks = 0;
    for (let model of modelsToProcess) {
      if (this.epoch !== epoch) {
        return;
      }
      const file = model.file!;
      const chunksForFile = Math.floor(file.size / CHUNK_SIZE) || 1;
      const progress = new Progress(
        () => this.epoch === epoch,
        chunksToProcess,
        processedChunks,
      );

      try {
        this.progress = progress;
        const hash = await getHash(file, algo, progress);
        model.hash = hash;
        model.algo = algo;
        console.log('Hash', hash);
      } catch (e) {
        throw e;
      } finally {
        processedChunks += chunksForFile;
        if (this.progress === progress) {
          this.progress = null;
        }
        if (!progress.isActual()) {
          return;
        }
      }
    }
    this.progress = null;
  }
  @tracked progress: null | Progress = null;
  effects = [
    effect(() => {
      const { isFormInvalid } = this;
      Promise.resolve().then(() => {
        this.setFileLink('');
        if (!isFormInvalid) {
          this.generateDocument(this.epoch);
        }
      });
    }),
    effect(() => {
      const algo = this.selectedAlgo;
      const models = this.models;
      const epoch = this.epoch;
      Promise.resolve().then(() => {
        this.calcFileHashes(models, algo, epoch);
      });
    }),
  ];
  get progressWidth() {
    return `${this.progress?.percents ?? 100}%`;
  }
  <template>
    <div class='mx-auto max-w-7xl px-4 sm:px-6 lg:px-8' {{this.cleanup}}>
      <div class='mx-auto max-w-3xl'>
        <div class='pb-5'>
          <div class='py-3'>
            <h1
              class='text-center font-bold text-xl py-3 text-gray-100 drop-shadow'
            >{{t.title}}
            </h1></div>
          <Panel @title={{t.document}} class='mt-4'>
            <DocumentForm
              @designation={{this.doc.designation}}
              @documentName={{this.doc.documentName}}
              @objectName={{this.doc.objectName}}
              @serialNumber={{this.doc.serialNumber}}
              @lastChangeNumber={{this.doc.lastChangeNumber}}
              @onChange={{fn this.onDocumentFieldChange this.doc}}
            />
          </Panel>

          <Panel @title={{t.files}} class='mt-4'>
            <FileForm @onFileSelect={{this.onFileSelect}}>
              <div class='flex'>
                <div class='flex-auto'>
                  <Algorithms
                    @selected={{this.selectedAlgo}}
                    @onSelect={{this.selectAlgo}}
                  />
                </div>
              </div>
            </FileForm>
          </Panel>

          {{#each this.models as |file|}}
            <Panel
              class='mt-2'
              @title={{file.fileName}}
              @onRemove={{fn this.onRemoveFile file}}
            />
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
                @doc={{this.doc}}
                @selectedAlgo={{this.selectedAlgoName}}
                @hidePrintButton={{true}}
              />
            </div>

          </Panel>

          <div class='mt-3 mb-3'>
            {{#if this.progress}}
              <div
                title={{t.hashing_files}}
                class='w-full bg-gray-200 cursor-progress rounded-full h-2.5 dark:bg-gray-700'
              >
                <div
                  class='bg-yellow-500 h-2.5 rounded-full'
                  style.width={{this.progressWidth}}
                ></div>
              </div>
              <div>
              </div>
            {{else}}
              <button
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
            {{/if}}

          </div></div></div></div>
    <footer>
      <div class='text-center text-gray-100 text-shadow pb-2'>
        <p class='text-sm'>
          <a
            href='https://t.me/ilifeart'
            title={{t.footer_title}}
          >{{t.footer}}</a>
        </p>
      </div>
    </footer>
  </template>
}
