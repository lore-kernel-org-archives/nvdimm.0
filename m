Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by ml01.01.org (Postfix) with ESMTP id 5170B1A1E5D
 for <linux-nvdimm@lists.01.org>; Sun,  5 Jun 2016 11:48:36 -0700 (PDT)
From: "Rudoff, Andy" <andy.rudoff@intel.com>
Subject: Re: [PATCH 00/13] deprecate pcommit
Date: Sun, 5 Jun 2016 18:48:15 +0000
Message-ID: <50303057-3221-4B96-BFF4-75B29BAD0D5E@intel.com>
References: <146507355220.8347.12117020810872172684.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CALCETrVfxGYjL7mD95ku5E+nPeSKXdGPj+kJjjp=BHr5_1T3dg@mail.gmail.com>
In-Reply-To: <CALCETrVfxGYjL7mD95ku5E+nPeSKXdGPj+kJjjp=BHr5_1T3dg@mail.gmail.com>
Content-Language: en-US
Content-ID: <2258A26E3751A44FA04F3DCFC25ABDBD@intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Andy Lutomirski <luto@amacapital.net>, "Williams, Dan J" <dan.j.williams@intel.com>
Cc: Xiao Guangrong <guangrong.xiao@linux.intel.com>, Josh Poimboeuf <jpoimboe@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, X86 ML <x86@kernel.org>, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, "Hunter, Adrian  <adrian.hunter@intel.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar" <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@suse.de>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Pj4gUGxhdGZvcm1zIHN1cHBvcnRpbmcgTlZESU1NcyBhcmUgbm93IHJlcXVpcmVkIHRvIHByb3Zp
ZGUgcGVyc2lzdGVuY2UNCj4+IGd1YXJhbnRlZXMgb25jZSBwbWVtIHN0b3JlcyBhcmUgYWNjZXB0
ZWQgYnkgdGhlIG1lbW9yeSBzdWJzeXN0ZW0uDQo+DQo+Q2FuIHlvdSBwb2ludCB1cyB0byBhIHBy
ZWNpc2UgZGVmaW5pdGlvbiBvZiB3aGF0IGV4YWN0bHkgY29uc3RpdHV0ZXMNCj5zdG9yZXMgYmVp
bmcgImFjY2VwdGVkIGJ5IHRoZSBtZW1vcnkgc3Vic3lzdGVtIj8gIEJhY2sgd2hlbiBwY29tbWl0
DQo+d2FzIGEgdGhpbmcgKGhhaCEpLCBpdCB3YXMgcHJlY2lzZWx5IGRvY3VtZW50ZWQgaW4gdGhl
IFNETS4NCg0KVGhlIEluc3RydWN0aW9uIFNldCBFeHRlbnNpb25zIGRvY3VtZW50IHRoYXQgZGVz
Y3JpYmVzIFBDT01NSVQNCnNheXMgaXQgYXBwbGllcyB0byBzdG9yZXMgdGhhdCB3ZXJlIGFjY2Vw
dGVkIGJ5IHRoZSBtZW1vcnkgc3Vic3lzdGVtDQpidXQgd2VyZSBzdGlsbCBwb3RlbnRpYWxseSBx
dWV1ZWQgdGhlcmUuICBTbyBEYW7igJlzIGRlc2NyaXB0aW9uIHdhcw0KYnVpbGRpbmcgb24gdGhh
dCBzYW1lIGxhbmd1YWdlLiAgQSBjb25jcmV0ZSBleGFtcGxlIG1pZ2h0IGhlbHA6DQoNCk1PViB0
byBsb2NhdGlvbiBYDQpDTFdCIFgNClNGRU5DRQ0KDQppcyB0aGUgc2VxdWVuY2UgZm9yIGZsdXNo
aW5nIGEgc3RvcmUgdG8gcG1lbS4gIEJlZm9yZSBQQ09NTUlUDQp3YXMgZGVwcmVjYXRlZCwgc29m
dHdhcmUgbmVlZGVkIHRvIHVuZGVyc3RhbmQgaWYgdGhlIHBsYXRmb3JtDQpoYWQgQURSIGFuZCBh
ZGQ6DQoNClBDT01NSVQgICAgICAgOyB0aGUgb2xkIHdheQ0KU0ZFTkNFICAgICAgICAgICAgOyB0
aGUgb2xkIHdheQ0KDQp0byB0aGUgYWJvdmUgc2VxdWVuY2UgaWYgQURSIHdhc27igJl0IHByZXNl
bnQgb24gdGhlIHBsYXRmb3JtLiAgTm93DQp0aGF0IEFEUiBpcyByZXF1aXJlZCBmb3IgYWxsIHBl
cnNpc3RlbnQgbWVtb3J5LCBhcyBpdCBhbHdheXMgaGFzDQpiZWVuIGZvciBOVkRJTU0tTiBkZXZp
Y2VzIGF2YWlsYWJsZSB0b2RheSwgdGhlIHNpbXBsZXIgcHJvZ3JhbW1pbmcNCm1vZGVsIGFscmVh
ZHkgaW4gdXNlIGZvciBOVkRJTU0tTiBpcyB1c2VkIGZvciBhbGwgcG1lbS4NCg0KPj4gaXMgdXN1
YWxseSBhY2hpZXZlZCBieSBhIHBsYXRmb3JtLWxldmVsIGZlYXR1cmUga25vd24gYXMgQURSDQo+
PiAoQXN5bmNocm9ub3VzIERSQU0gUmVmcmVzaCkgdGhhdCBmbHVzaGVzIGFueSBtZW1vcnkgc3Vi
c3lzdGVtIHdyaXRlDQo+PiBwZW5kaW5nIHF1ZXVlcyBvbiBwb3dlciBsb3NzL3NodXRkb3duLg0K
Pg0KPkJsZWNoLiAgRG9lcyB0aGlzIG1lYW4gdGhhdCB3ZSBuZWVkIHNvbWUgTk1JIGhhbmRsZXIg
b3Igc2ltaWxhciB0aGF0DQo+ZG9lcyB3YmludmQ/ICBXaWxsIENQVSBjYWNoZXMgYXV0b21hdGlj
YWxseSB3cml0ZSB0aGVtc2VsdmVzIGJhY2sgb24NCj5wb3dlciBsb3NzPyAgV2lsbCB3ZSBsb3Nl
IGRhdGEgaWYgc29tZXRoaW5nIGdvZXMgd3Jvbmcgd2l0aCBhbiBTTUkNCj5oYW5kbGVyPw0KDQpO
bywgQURSIGlzIGEgcGxhdGZvcm0tbGV2ZWwgZmVhdHVyZSB0aGF0IGZsdXNoZXMgYW55IGJ1ZmZl
cnMgaW4gdGhlIG1lbW9yeQ0Kc3Vic3lzdGVtIG9uIHBvd2VyIGxvc3MuICBObyBzb2Z0d2FyZSBp
cyBpbnZvbHZlZCBhbmQgdGhlIENQVSBjYWNoZXMgYXJlDQpub3QgdG91Y2hlZCBieSBBRFIuICBT
byBhbnkgc3RvcmVzIGZsdXNoZWQgYnkgQ0xGTFVTSCwgQ0xGTFVTSE9QVCwgQ0xXQiwNCldCSU5W
RCwgb3Igbm9uLXRlbXBvcmFsIHN0b3JlcyB0aGF0IGdvIGFyb3VuZCB0aGUgQ1BVIGNhY2hlcyBj
YW4gbm93IGJlDQpjb25zaWRlcmVkIHBlcnNpc3RlbnQgb25jZSB0aG9zZSBvcGVyYXRpb25zIGFy
ZSBjb21wbGV0ZS4NCg0KPj4gVGhlICdwY29tbWl0JyBpbnN0cnVjdGlvbiAod2hpY2ggaGFzIG5v
dCBzaGlwcGVkIG9uIGFueSBwcm9kdWN0KSBpcyBubw0KPj4gbG9uZ2VyIG5lZWRlZCBhbmQgaXMg
ZGVwcmVjYXRlZC4NCj4NCj5Eb2VzIHRoaXMgbWVhbiBpdCB3aWxsIG5ldmVyIHNoaXA/DQoNClll
cy4gIFRoZSBuZXcgaW5zdHJ1Y3Rpb25zIGxpa2UgQ0xXQiBhbmQgQ0xGTFVTSE9QVCB3aWxsIGJl
IHJvbGxlZA0KaW50byB0aGUgU0RNIGJ1dCBQQ09NTUlUIHdpbGwgYmUgcmVtb3ZlZCBmcm9tIHRo
ZSBFeHRlbnNpb25zIGRvYw0KYW5kIG5vdCByb2xsZWQgaW50byB0aGUgU0RNLg0KDQotYW5keQ0K
DQoNCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4
LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xp
c3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
