From: Matthew Wilcox <mawilcox@microsoft.com>
Subject: RE: [PATCH 00/13] dax, pmem: move cpu cache maintenance to     libnvdimm
Date: Mon, 23 Jan 2017 06:37:18 +0000
Message-ID: <BY2PR21MB0036CA85562DDD21814C0B27CB720@BY2PR21MB0036.namprd21.prod.outlook.com>
References: <148488421301.37913.12835362165895864897.stgit@dwillia2-desk3.amr.corp.intel.com>
 <BY2PR21MB0036C7BBC487D7C101F36DCFCB700@BY2PR21MB0036.namprd21.prod.outlook.com>
 <20170121175212.GA28180@lst.de>
 <BY2PR21MB00367799FE7B7E8302A99260CB730@BY2PR21MB0036.namprd21.prod.outlook.com>
 <20170122162910.GA5267@lst.de>
 <BY2PR21MB00368E95CBB533D4C761C882CB730@BY2PR21MB0036.namprd21.prod.outlook.com>
 <20170122183046.GA7359@lst.de>
 <BY2PR21MB0036CC7935BFE438EA001763CB730@BY2PR21MB0036.namprd21.prod.outlook.com>
 <20170122184439.GA7603@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170122184439.GA7603@lst.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Tony Luck <tony.luck@intel.com>, Jan Kara <jack@suse.cz>, Toshi Kani <toshi.kani@hpe.com>, Mike Snitzer <snitzer@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Jens Axboe <axboe@fb.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Ross Zwisler <ross.zwisler@linux.intel.com>
List-Id: linux-nvdimm@lists.01.org

RnJvbTogQ2hyaXN0b3BoIEhlbGx3aWcgW21haWx0bzpoY2hAbHN0LmRlXQ0KPiBPbiBTdW4sIEph
biAyMiwgMjAxNyBhdCAwNjozOToyOFBNICswMDAwLCBNYXR0aGV3IFdpbGNveCB3cm90ZToNCj4g
PiBUd28gZ3Vlc3RzIG9uIHRoZSBzYW1lIHBoeXNpY2FsIG1hY2hpbmUgKG9yIGEgZ3Vlc3QgYW5k
IGEgaG9zdCkgaGF2ZSBhY2Nlc3MNCj4gPiB0byB0aGUgc2FtZSBzZXQgb2YgcGh5c2ljYWwgYWRk
cmVzc2VzLiAgVGhpcyBtaWdodCBiZSBhbiBOVi1ESU1NLCBvciBpdCBtaWdodA0KPiA+IGp1c3Qg
YmUgRFJBTSAoZm9yIHRoZSBwdXJwb3NlcyBvZiByZWR1Y2luZyBndWVzdCBvdmVyaGVhZCkuICBU
aGUgbmV0d29yaw0KPiA+IGZpbGVzeXN0ZW0gaGFzIGJlZW4gZW5oYW5jZWQgd2l0aCBhIGNhbGwg
dG8gYWxsb3cgdGhlIGNsaWVudCB0byBhc2sgdGhlIHNlcnZlcg0KPiA+ICJXaGF0IGlzIHRoZSBw
aHlzaWNhbCBhZGRyZXNzIGZvciB0aGlzIHJhbmdlIG9mIGJ5dGVzIGluIHRoaXMgZmlsZT8iDQo+
ID4NCj4gPiBXZSBkb24ndCB3YW50IHRvIHVzZSB0aGUgZ3Vlc3QgcGFnZWNhY2hlIGhlcmUuICBU
aGF0J3MgYW50aXRoZXRpY2FsIHRvIHRoZQ0KPiA+IHNlY29uZCB1c2FnZSwgYW5kIGl0J3MgaW5l
ZmZpY2llbnQgZm9yIHRoZSBmaXJzdCB1c2FnZS4NCj4gDQo+IEFuZCB0aGUgYW5zd2VyIGlzIHRo
YXQgeW91IG5lZWQgYSBkYXggZGV2aWNlIGZvciB3aGF0ZXZlciBtZW1vZXJ5IGV4cG9zZWQNCj4g
aW4gdGhpcyB3YXksIGFzIGl0IG5lZWRzIHRvIHNob3cgdXAgaW4gdGhlIG1lbW9yeSBtYXAgZm9y
IGV4YW1wbGUuDQoNCldvdywgREFYIGRldmljZXMgbG9vayBwYWluZnVsIGFuZCBhd2Z1bC4gIEkg
Y2VydGFpbmx5IGRvbid0IHdhbnQgdG8gYmUgZXhwb3NpbmcgdGhlIG1lbW9yeSBmcm9udGVkIGJ5
IG15IG5ldHdvcmsgZmlsZXN5c3RlbSB0byB1c2Vyc3BhY2UgdG8gYWNjZXNzLiAgVGhhdCBqdXN0
IHNlZW1zIGxpa2UgYSB3b3JsZCBvZiBwYWluIGFuZCBiYWQgZXhwZXJpZW5jZXMuICBBYnNvbHV0
ZWx5IHRoZSBmaWxlc3lzdGVtIChvciBwZXJoYXBzIGJldHRlciwgdGhlIEFDUEkgdGFibGVzKSBu
ZWVkIHRvIG1hcmsgdGhhdCBjaHVuayBvZiBtZW1vcnkgYXMgcmVzZXJ2ZWQsIGJ1dCBpdCdzIGRl
ZmluaXRlbHkgbm90IGF2YWlsYWJsZSBmb3IgYW55b25lIHRvIGFjY2VzcyB3aXRob3V0IHRoZSBm
aWxlc3lzdGVtIGJlaW5nIGF3YXJlLg0KDQpFdmVuIGlmIHdlIGxldCB0aGUgZmlsZXN5c3RlbSBj
cmVhdGUgYSBEQVggZGV2aWNlIHRoYXQgZG9lc24ndCBzaG93IHVwIGluIC9kZXYgKGZvciBleGFt
cGxlKSwgRGFuJ3MgcGF0Y2hlcyBkb24ndCBnaXZlIHVzIGEgd2F5IHRvIGdvIGZyb20gYSBmaWxl
IG9uIHRoZSBmaWxlc3lzdGVtIHRvIGEgc2V0IG9mIGRheF9vcHMuICBBbmQgaXQgZG9lcyBuZWVk
IHRvIGJlIGEgcGVyLWZpbGUgb3BlcmF0aW9uLCBlZyB0byBzdXBwb3J0IGEgZmlsZSBvbiBhbiBY
RlMgdm9sdW1lIHdoaWNoIG1pZ2h0IGJlIG9uIGEgUlQgZGV2aWNlIG9yIGEgbm9ybWFsIGRldmlj
ZS4gIFRoYXQgd2FzIHdoeSBJIGxlYW5lZCB0b3dhcmRzIGFuIGFkZHJlc3Nfc3BhY2Ugb3BlcmF0
aW9uLCBidXQgSSdkIGJlIGhhcHB5IHRvIHNlZSBhbiBpbm9kZV9vcGVyYXRpb24gaW5zdGVhZC4g
DQo=
