import ReactOnRails from 'react-on-rails';
import Promise from 'es6-promise';
import React from 'react';
import ReactDOM from 'react-dom';
Promise.polyfill();

import OnboardingTopBar from './OnboardingTopBarApp';
import OnboardingGuideApp from './OnboardingGuideApp';
import TopbarApp from './TopbarApp';

ReactOnRails.register({
  OnboardingGuideApp,
  OnboardingTopBar,
  TopbarApp,
});

ReactOnRails.registerStore({
});

if (typeof window !== 'undefined') {
  window.React = React;
  window.ReactDOM = ReactDOM;
}
