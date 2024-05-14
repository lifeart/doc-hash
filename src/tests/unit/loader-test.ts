import { module, test } from 'qunit';
import { Progress } from '@/utils/progress';

module('Unit | functions | Progress', function () {
  test('it works', async function (assert) {
    const loader = new Progress(() => true, 1);
    assert.equal(loader.percents, '100.00');
  });
    test('it works with 0', async function (assert) {
        const loader = new Progress(() => true, 0);
        assert.equal(loader.percents, '0.00');
    });
    test('it works with 50', async function (assert) {
        const loader = new Progress(() => true, 50);
        assert.equal(loader.percents, '2.00');
    });
    test('it returns 100 if validity is false', async function (assert) {
        const loader = new Progress(() => false, 50);
        assert.equal(loader.percents, '100.00');
    });
});