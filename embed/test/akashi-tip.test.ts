import { html } from 'lit';
import { fixture, expect } from '@open-wc/testing';
import { AkashiTip } from '../src/AkashiTip.js';
import '../src/akashi-tip.js';

describe('AkashiTip', () => {
  it('has a default header "Hey there" and counter 5', async () => {
    const el = await fixture<AkashiTip>(html`<akashi-tip></akashi-tip>`);

    expect(el.header).to.equal('Hey there');
    expect(el.counter).to.equal(5);
  });

  it('increases the counter on button click', async () => {
    const el = await fixture<AkashiTip>(html`<akashi-tip></akashi-tip>`);
    el.shadowRoot!.querySelector('button')!.click();

    expect(el.counter).to.equal(6);
  });

  it('can override the header via attribute', async () => {
    const el = await fixture<AkashiTip>(
      html`<akashi-tip header="attribute header"></akashi-tip>`
    );

    expect(el.header).to.equal('attribute header');
  });

  it('passes the a11y audit', async () => {
    const el = await fixture<AkashiTip>(html`<akashi-tip></akashi-tip>`);

    await expect(el).shadowDom.to.be.accessible();
  });
});
