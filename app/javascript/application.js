// Entry point for the build script in your package.json

// polyfills
import './shared/polyfills';

// rails
import '@hotwired/turbo-rails';
import './controllers';

// app logic


// inits
document.onreadystatechange = () => {
  if (document.readyState === 'complete') {

  }
};
