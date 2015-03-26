Return-Path: <linux-kernel-owner@vger.kernel.org>
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 1/8] pmem: Initial version of persistent memory driver
Date: Thu, 26 Mar 2015 04:00:57 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295A84453E@G9W0745.americas.hpqcorp.net>
References: <54F82CE0.4040502@plexistor.com>
 <54F830D4.7030205@plexistor.com> <54F84420.40209@plexistor.com>
 <CALCETrXsQsoa0qfzM-o+kz6Af2EtvJR7Er6OwxjZ5JegMYxpFg@mail.gmail.com>
 <54FD901A.3030905@plexistor.com>
 <CALCETrVt9KiWsT37Z_90gBREK1NoSJ2ruT48uv-7QWumYz+TNg@mail.gmail.com>
In-Reply-To: <CALCETrVt9KiWsT37Z_90gBREK1NoSJ2ruT48uv-7QWumYz+TNg@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>, Boaz Harrosh <boaz@plexistor.com>
Cc: Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Dan Williams <dan.j.williams@intel.com>, Ingo Molnar <mingo@redhat.com>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, linux-kernel <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@infradead.org>, "Kani, Toshimitsu" <toshi.kani@hp.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogbGludXgta2VybmVsLW93
bmVyQHZnZXIua2VybmVsLm9yZyBbbWFpbHRvOmxpbnV4LWtlcm5lbC0NCj4gb3duZXJAdmdlci5r
ZXJuZWwub3JnXSBPbiBCZWhhbGYgT2YgQW5keSBMdXRvbWlyc2tpDQo+IFNlbnQ6IFdlZG5lc2Rh
eSwgTWFyY2ggMTgsIDIwMTUgMTowNyBQTQ0KPiBUbzogQm9heiBIYXJyb3NoDQo+IENjOiBNYXR0
aGV3IFdpbGNveDsgUm9zcyBad2lzbGVyOyBYODYgTUw7IFRob21hcyBHbGVpeG5lcjsgRGFuIFdp
bGxpYW1zOw0KPiBJbmdvIE1vbG5hcjsgUm9nZXIgQy4gUGFvOyBsaW51eC1udmRpbW07IGxpbnV4
LWtlcm5lbDsgSC4gUGV0ZXIgQW52aW47DQo+IENocmlzdG9waCBIZWxsd2lnDQo+IFN1YmplY3Q6
IFJlOiBbUEFUQ0ggMS84XSBwbWVtOiBJbml0aWFsIHZlcnNpb24gb2YgcGVyc2lzdGVudCBtZW1v
cnkgZHJpdmVyDQo+IA0KPiBPbiBNYXIgOSwgMjAxNSA4OjIwIEFNLCAiQm9heiBIYXJyb3NoIiA8
Ym9hekBwbGV4aXN0b3IuY29tPiB3cm90ZToNCj4gPg0KPiA+IE9uIDAzLzA2LzIwMTUgMDE6MDMg
QU0sIEFuZHkgTHV0b21pcnNraSB3cm90ZToNCj4gPiA8Pg0KPiA+ID4NCj4gPiA+IEkgdGhpbmsg
aXQgd291bGQgYmUgbmljZSB0byBoYXZlIGNvbnRyb2wgb3ZlciB0aGUgY2FjaGluZyBtb2RlLg0K
PiA+ID4gRGVwZW5kaW5nIG9uIHRoZSBhcHBsaWNhdGlvbiwgV1Qgb3IgVUMgY291bGQgbWFrZSBt
b3JlIHNlbnNlLg0KPiA+ID4NCj4gPg0KPiA+IFBhdGNoZXMgYXJlIHdlbGNvbWUuIHNheQ0KPiA+
ICAgICAgICAgbWFwPXNzc0BhYWE6V1Qsc3NzQGFhYTpDQSwgLi4uDQo+ID4NCj4gPiBCdXQgZm9y
IHVzLCB3aXRoIGRpcmVjdF9hY2Nlc3MoKSwgYWxsIGJlbmNobWFya3Mgc2hvdyBhIHNsaWdodCBh
ZHZhbnRhZ2UNCj4gPiBmb3IgdGhlIGNhY2hlZCBtb2RlLg0KPiANCj4gSSdtIHN1cmUgY2FjaGVk
IGlzIGZhc3Rlci4gIFRoZSBxdWVzdGlvbiBpczogd2hvIGZsdXNoZXMgdGhlIGNhY2hlPw0KPiAN
Cj4gLS1BbmR5DQoNCk5vYm9keS4NCg0KVGhlcmVmb3JlLCBwbWVtIGFzIGN1cnJlbnRseSBwcm9w
b3NlZCAobWFwcGluZyB0aGUgbWVtb3J5IHdpdGgNCmlvcmVtYXBfY2FjaGUsIHdoaWNoIHVzZXMg
X1BBR0VfQ0FDSEVfTU9ERV9XQikgaXMgdW5zYWZlIHVubGVzcyB0aGUNCnN5c3RlbSBpcyBkb2lu
ZyBzb21ldGhpbmcgc3BlY2lhbCB0byBlbnN1cmUgTDEsIEwyLCBhbmQgTDMgY2FjaGVzIGFyZQ0K
Zmx1c2hlZCBvbiBwb3dlciBsb3NzLg0KDQpJIHRoaW5rIHBtZW0gbmVlZHMgdG8gbWFwIHRoZSBt
ZW1vcnkgYXMgVUMgb3IgV1QgYnkgZGVmYXVsdCwgcHJvdmlkaW5nDQpXQiBhbmQgV0Mgb25seSBh
cyBhbiBvcHRpb24gZm9yIHVzZXJzIGNvbmZpZGVudCB0aGF0IHRob3NlIGF0dHJpYnV0ZXMNCmFy
ZSBzYWZlIHRvIHVzZSBpbiB0aGVpciBzeXN0ZW0uDQoNCkV2ZW4gdXNpbmcgVUMgb3IgV1QgcHJl
c3VtZXMgdGhhdCBBRFIgaXMgaW4gcGxhY2UuDQoNCg0KDQo=
