From: Matthew Wilcox <mawilcox@microsoft.com>
Subject: RE: [PATCH 00/13] dax, pmem: move cpu cache maintenance to     libnvdimm
Date: Sun, 22 Jan 2017 18:19:24 +0000
Message-ID: <BY2PR21MB00368E95CBB533D4C761C882CB730@BY2PR21MB0036.namprd21.prod.outlook.com>
References: <148488421301.37913.12835362165895864897.stgit@dwillia2-desk3.amr.corp.intel.com>
 <BY2PR21MB0036C7BBC487D7C101F36DCFCB700@BY2PR21MB0036.namprd21.prod.outlook.com>
 <20170121175212.GA28180@lst.de>
 <BY2PR21MB00367799FE7B7E8302A99260CB730@BY2PR21MB0036.namprd21.prod.outlook.com>
 <20170122162910.GA5267@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170122162910.GA5267@lst.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Brian Boylston <brian.boylston@hpe.com>, Tony Luck <tony.luck@intel.com>, Jan Kara <jack@suse.cz>, Toshi Kani <toshi.kani@hpe.com>, Mike Snitzer <snitzer@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Jens Axboe <axboe@fb.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Ross Zwisler <ross.zwisler@linux.intel.com>
List-Id: linux-nvdimm@lists.01.org

RnJvbTogQ2hyaXN0b3BoIEhlbGx3aWcgW21haWx0bzpoY2hAbHN0LmRlXQ0KPiBPbiBTdW4sIEph
biAyMiwgMjAxNyBhdCAwMzo0MzowOVBNICswMDAwLCBNYXR0aGV3IFdpbGNveCB3cm90ZToNCj4g
PiBJbiB0aGUgY2FzZSBvZiBhIG5ldHdvcmsgZmlsZXN5c3RlbSBiZWluZyB1c2VkIHRvIGNvbW11
bmljYXRlIHdpdGgNCj4gPiBhIGRpZmZlcmVudCBWTSBvbiB0aGUgc2FtZSBwaHlzaWNhbCBtYWNo
aW5lLCB0aGVyZSBpcyBubyBiYWNraW5nDQo+ID4gZGV2aWNlLCBqdXN0IGEgbmV0d29yayBwcm90
b2NvbC4NCj4gDQo+IEFnYWluLCBkbyB5b3UgbWVhbiBibG9jayBkZXZpY2U/ICBGb3IgYSBmaWxl
c3lzdGVtIHRoYXQgZG9lcyBub3QgZG8gYW55DQo+IHBhZ2VjYWNoZSB3cml0ZWJhY2sgd2UgYWxy
ZWFkeSBkb24ndCBuZWVkIGEgYmFja2luZyBkZXZpY2UsIHNvIEkgZG9uJ3QNCj4gcmVhbGx5IHNl
ZSBhbiBpc3N1ZSB0aGVyZSB0byBzdGFydCB3aXRoLg0KDQpObywgSSBtZWFuIGEgbmV0d29yayBm
aWxlc3lzdGVtIGxpa2UgOXAgb3IgY2lmcyBvciBuZnMuICBJZiB0aGUgbWVtY3B5IGlzIHN1cHBv
c2VkIHRvIGJlIHBlcmZvcm1lZCBieSB0aGUgYmFja2luZyBkZXZpY2UgYW5kIHRoZXJlIGlzIG5v
IGJhY2tpbmcgZGV2aWNlLCB0aGVuIGl0J3MgZ29pbmcgdG8gbmVlZCB0byBiZSBkb25lIGJ5IHRo
ZSBuZXR3b3JrIGZpbGVzeXN0ZW0uDQoNCihBbHNvLCB0aGUgbmV0d29yayBmaWxlc3lzdGVtIG1p
Z2h0IGhhdmUgYSBjb21tYW5kLCBsaWtlIFJETUEgaGFzL3dpbGwgaGF2ZSwgdG8gZW5zdXJlIHRo
YXQgdGhlIHdyaXRlIGhhcyByZWFjaGVkIHBlcnNpc3RlbmNlKQ0K
