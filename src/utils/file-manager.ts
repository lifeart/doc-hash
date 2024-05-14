import { tracked } from '@lifeart/gxt';
import { read, remove } from './persisted';

const fileSet: Set<FileDTO> = new Set();

function keyForFile(file: File) {
  return `${file.name}_${file.size}_${file.lastModified}`;
}

export function addFilesToDto(files: FileList) {
  const existingFiles = Array.from(fileSet);
  for (let file of files) {
    const key = keyForFile(file);
    if (existingFiles.some((el) => el.key === key)) {
      continue;
    }
    const model = new FileDTO(file);
    fileSet.add(model);
  }
  return Array.from(fileSet);
}

export function removeFile(file: FileDTO) {
  remove(file.key as any);
  fileSet.delete(file);
  return Array.from(fileSet);
}

export class DocumentDTO {
  @tracked objectName: string = '';
  @tracked
  designation: string = '';
  @tracked
  documentName: string = '';
  @tracked
  serialNumber: number | '' = '';
  @tracked
  lastChangeNumber: number = 1;
  get isInvalid() {
    return (
      !this.designation ||
      !this.documentName ||
      !this.lastChangeNumber
    );
  }
  constructor() {
    this.designation = read('designation', '');
    const sn = read('serialNumber', '');
    this.serialNumber = sn ? parseInt(sn) : '';
    this.documentName = read('documentName', '');
    this.lastChangeNumber = parseInt(read('lastChangeNumber', '1'));
    this.objectName = read('objectName', '');
  }
}

export class FileDTO {
  key: string = '';
  @tracked
  file: null | File = null;
  @tracked
  hash: string = '';
  @tracked fileSize: number = 0;
  @tracked fileName: string = '';
  @tracked lastModified: number = 0;
  get formattedSize() {
    return this.fileSize.toLocaleString('ru-RU');
  }
  get fileLastModified() {
    return this.file?.lastModified
      ? new Date(this.file.lastModified).toLocaleString('ru-RU', {
          timeZone: 'Europe/Moscow',
          second: undefined,
          month: '2-digit',
          day: '2-digit',
          hour: '2-digit',
          year: 'numeric',
          minute: '2-digit',
        })
      : '';
  }
  get isInvalid() {
    return (
      !this.hash
    );
  }
  constructor(file: File) {
    const key = keyForFile(file);
    this.key = key;
    this.fileName = file.name;
    this.fileSize = file.size;
    this.lastModified = file.lastModified;
    this.file = file;
  }
}
