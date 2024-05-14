import { tracked } from '@lifeart/gxt';

export class Progress {
  constructor(isActual: () => boolean) {
    this.isActual = isActual;
  }
  @tracked currentChunk = 0;
  isActual: () => boolean;
  @tracked totalChunks = 0;
  @tracked startTime = Date.now();
  get timeElapsed() {
    return Date.now() - this.startTime;
  }
  get msRemaining() {
    return (
      (this.timeElapsed / this.currentChunk) *
      (this.totalChunks - this.currentChunk)
    );
  }
  get secondsRemaining() {
    const result =  Math.floor(this.msRemaining / 1000);
    if (isNaN(result)) {
      return 0;
    } else {
      return result;
    }
  }
}
