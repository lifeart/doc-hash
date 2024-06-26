import 'decorator-transforms/globals'; // workaround for test bundling
import { tracked } from '@lifeart/gxt';
export class Progress {
  constructor(isActual: () => boolean, totalChunks: number, processedChunks = 0) {
    this.isActual = isActual;
    this.totalChunks = totalChunks;
    this.currentChunk = processedChunks;
  }
  @tracked currentChunk = 1;
  isActual: () => boolean;
  totalChunks = 0;
  get percents() {
    const value = this.totalChunks ? (this.currentChunk / this.totalChunks) * 100 : 0;
    if (!this.isActual() || value >= 100) return '100.00';
    return value.toFixed(2);
  }
  
}
