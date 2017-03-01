From: "Verma, Vishal L" <vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [ndctl PATCH v2 2/3] ndctl: add a BTT check utility
Date: Wed, 1 Mar 2017 20:27:24 +0000
Message-ID: <1488399969.4873.20.camel@intel.com>
References: <20170222224724.7696-1-vishal.l.verma@intel.com>
 <20170222224724.7696-3-vishal.l.verma@intel.com>
 <x49a89610mr.fsf@segfault.boston.devel.redhat.com>
 <1488321002.4873.17.camel@intel.com>
 <x49inntt4z6.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4g+UfCR2x3KwWB+yu6fRh5UcVRvdAdrx3ri8bpJx+r8YQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAPcyv4g+UfCR2x3KwWB+yu6fRh5UcVRvdAdrx3ri8bpJx+r8YQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Content-ID: <F655E8D589940648B3CF4B132711C622-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: "Williams, Dan J" <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org" <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

T24gV2VkLCAyMDE3LTAzLTAxIGF0IDA3OjU0IC0wODAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIFdlZCwgTWFyIDEsIDIwMTcgYXQgNzowMiBBTSwgSmVmZiBNb3llciA8am1veWVyQHJlZGhh
dC5jb20+IHdyb3RlOg0KPiA+ICJWZXJtYSwgVmlzaGFsIEwiIDx2aXNoYWwubC52ZXJtYUBpbnRl
bC5jb20+IHdyaXRlczoNCj4gPiANCj4gPiA+ID4gLSBEaWZmZXJlbnRpYXRlIHRoZSB1c2Ugb2Zm
IEJUVF9QR19TSVpFLCBzeXNjb25mKF9TQ19QQUdFU0laRSksDQo+ID4gPiA+IGFuZA0KPiA+ID4g
PiBTWl80Sw0KPiA+ID4gPiDCoCAoZm9yIHRoZSBmaXhlZCBzdGFydCBvZmZzZXQpIGluIHRoZSBk
aWZmZXJlbnQgcGxhY2VzIHRoZXkncmUNCj4gPiA+ID4gdXNlZA0KPiA+ID4gPiAoSmVmZikNCj4g
PiA+ID4gDQo+ID4gPiA+IEkgdGhpbmsgeW91IGNvdWxkIGdvIGV2ZW4gZnVydGhlciB3aXRoIHRo
aXMuwqDCoEZvciBleGFtcGxlLCB5b3UNCj4gPiA+ID4gY291ZA0KPiA+ID4gPiB1c2UNCj4gPiA+
ID4gQlRUX1NUQVJUX09GRlNFVCBmb3IgdGhlIGluaXRpYWwgb2Zmc2V0IGZyb20gdGhlIGJlZ2lu
bmluZyBvZg0KPiA+ID4gPiB0aGUgcmF3DQo+ID4gPiA+IG5hbWVzcGFjZSB0byB0aGUgZmlyc3Qg
YnR0IGluZm8gYmxvY2suwqDCoFVzaW5nIHRoZSBwYWdlIHNpemUgZm9yDQo+ID4gPiA+IHRoZQ0K
PiA+ID4gPiBzaXplDQo+ID4gPiA+IG9mIHRoZSBpbmZvIGJsb2NrIGlzIGFsc28gbGVzcyBpbmZv
cm1hdGl2ZSB0aGFuIGl0IGNvdWxkDQo+ID4gPiA+IGJlLsKgwqBJbnN0ZWFkLA0KPiA+ID4gPiBj
b25zaWRlciBhZGRpbmcgQlRUX0lORk9fU0laRS7CoMKgQWZ0ZXIgdGhhdCwgYWxsIG9mIHlvdXIg
bWF0aA0KPiA+ID4gPiBzdGFydHMgdG8NCj4gPiA+ID4gbG9vayBhIGJpdCBtb3JlIHJlYWRhYmxl
IHRvIG15IGV5ZS4NCj4gPiA+IA0KPiA+ID4gSSB0aG91Z2h0IG9mIHNvbWV0aGluZyBhbG9uZyB0
aGVzZSBsaW5lcywgYnV0IGVuZGVkIHVwIG5vdCBkb2luZw0KPiA+ID4gdGhpcyB0bw0KPiA+ID4g
c3RheSBjb25zaXN0ZW50IHdpdGggdGhlICdCVFRfUEdfU0laRScgdXNhZ2UgaW4gdGhlIGtlcm5l
bC4gQnV0DQo+ID4gPiBtYXliZQ0KPiA+ID4gdGhlIGtlcm5lbCBjb3VsZCB1c2Ugc29tZSBjbGVh
bmluZyB1cCBpbiB0aGlzIHJlZ2FyZCA6KQ0KPiA+IA0KPiA+IEkgb2J2aW91c2x5IHRoaW5rIGl0
IHdvdWxkIGxvb2sgbmljZXIuwqDCoDstKcKgwqBBbnl3YXksIGl0J3Mgbm90IGENCj4gPiBibG9j
a2VyDQo+ID4gdG8gZ2V0IHRoaXMgc2VyaWVzIGluLg0KPiANCj4gU28sIG15IGZlZWRiYWNrIHdh
cyB0byBzdG9yZSB0aGUgb2Zmc2V0IGluIHRoZSBidHRjIGNvbnRleHQgc28gaXQncw0KPiBqdXN0
IGEgcHJvcGVydHkgd2UgY2FycnkgYW5kIGFkZCB1bmNvbmRpdGlvbmFsbHksIGl0IGp1c3QgbWln
aHQgYmUNCj4gemVybyBzb21ldGltZXMuIERvZXMgdGhhdCBtYWtlIHRoaW5ncyBhbnkgY2xlYW5l
cj8NCg0KVGhhdCdzIGEgZ29vZCBpZGVhIC0gSSdsbCB3b3JrIG9uIHRoYXQuDQpfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGlu
ZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFp
bG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
