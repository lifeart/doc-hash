import { tracked } from '@lifeart/gxt';
export class Progress {
  constructor(isActual: () => boolean, totalChunks: number) {
    this.isActual = isActual;
    this.totalChunks = totalChunks;
  }
  @tracked currentChunk = 1;
  isActual: () => boolean;
  totalChunks = 0;
  get percents() {
    const value = this.totalChunks ? (this.currentChunk / this.totalChunks) * 100 : 0;
    return value.toFixed(2);
  }
  
}
