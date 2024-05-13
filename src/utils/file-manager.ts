import { tracked } from '@lifeart/gxt';
import { read, remove } from './persisted';

const fileSet: Set<FileDTO> = new Set();

export function addFilesToDto(files: FileList) {
  for (let file of files) {
    const model = new FileDTO(file);
    fileSet.add(model);
  }
  return Array.from(fileSet);
}

export function removeFile(file: FileDTO) {
  remove(file.key);
  fileSet.delete(file);
  return Array.from(fileSet);
}

export class FileDTO {
  key: string = '';
  @tracked
  designation: string = '';
  @tracked
  documentName: string = '';
  @tracked
  version: number = 1;
  @tracked
  lastChangeNumber: number = 1;
  @tracked
  file: null | File = null;
  @tracked
  hash: string = '';
  @tracked fileSize: number = 0;
  @tracked fileName: string = '';
  @tracked lastModified: number = 0;
  get fileLastModified() {
    return this.file?.lastModified
      ? new Date(this.file.lastModified).toLocaleString('ru-RU', {
          timeZone: 'Europe/Moscow',
        })
      : '';
  }
  get isInvalid() {
    return (
      !this.designation ||
      !this.documentName ||
      !this.hash ||
      !this.version ||
      !this.lastChangeNumber
    );
  }
  constructor(file: File) {
    const key = `${file.name}_${file.size}_${file.lastModified}`;
    this.key = key;
    this.fileName = file.name;
    this.fileSize = file.size;
    this.lastModified = file.lastModified;
    this.file = file;
    try {
      const meta = JSON.parse(read(key, '{}'));
      if (meta === null || typeof meta !== 'object') {
        return;
      }
      this.designation = meta.designation ?? '';
      this.version = meta.version ?? 1;
      this.documentName = meta.documentName ?? '';
      this.lastChangeNumber = meta.lastChangeNumber ?? 1;
    } catch (e) {
      // EOL
    }
  }
}
