// polyfill for Element.closest()
import 'element-closest-polyfill';

// helpful utility: filter an object
// https://stackoverflow.com/a/37616104
Object.filter = (obj, predicate) =>
  Object.fromEntries(Object.entries(obj).filter(predicate));

// polyfill for Event constructor
// source: https://stackoverflow.com/a/26596324
(() => {
  if (typeof window.CustomEvent === 'function') return false; // If not IE

  function CustomEvent(event, params) {
    const newParams = params || {
      bubbles: false,
      cancelable: false,
      detail: undefined,
    };
    const evt = document.createEvent('CustomEvent');
    evt.initCustomEvent(
      event,
      newParams.bubbles,
      newParams.cancelable,
      newParams.detail,
    );
    return evt;
  }

  CustomEvent.prototype = window.Event.prototype;

  window.CustomEvent = CustomEvent;
  return true;
})();

// polyfill for :focus-within
// source: https://gist.github.com/aFarkas/a7e0d85450f323d5e164
((window, document) => {
  const { slice } = [];
  const removeClass = (elem) => {
    elem.classList.remove('focus-within');
  };
  const update = (() => {
    let running;
    let last;
    // eslint-disable-next-line func-names
    const action = function () {
      let element = document.activeElement;
      running = false;
      if (last !== element) {
        last = element;
        slice
          .call(document.getElementsByClassName('focus-within'))
          .forEach(removeClass);
        while (element && element.classList) {
          element.classList.add('focus-within');
          element = element.parentNode;
        }
      }
    };
    // eslint-disable-next-line func-names
    return function () {
      if (!running) {
        requestAnimationFrame(action);
        running = true;
      }
    };
  })();
  document.addEventListener('focus', update, true);
  document.addEventListener('blur', update, true);
  update();
})(window, document);
