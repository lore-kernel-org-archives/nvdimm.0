Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM03-DM3-obe.outbound.protection.outlook.com
 (mail-dm3nam03on0729.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe49::729])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 58F121A1DEF
 for <linux-nvdimm@lists.01.org>; Mon, 29 Aug 2016 15:00:46 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH v4 RESEND 0/2] Align mmap address for DAX pmd mappings
Date: Mon, 29 Aug 2016 22:00:43 +0000
Message-ID: <1472508000.1532.59.camel@hpe.com>
References: <1472497881-9323-1-git-send-email-toshi.kani@hpe.com>
 <20160829204842.GA27286@node.shutemov.name>
 <1472506310.1532.47.camel@hpe.com>
In-Reply-To: <1472506310.1532.47.camel@hpe.com>
Content-Language: en-US
Content-ID: <7A35FDC77690ED41A514F00658A38AA0@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "kirill@shutemov.name" <kirill@shutemov.name>
Cc: "tytso@mit.edu" <tytso@mit.edu>, "mawilcox@microsoft.com" <mawilcox@microsoft.com>, "david@fromorbit.com" <david@fromorbit.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "hughd@google.com" <hughd@google.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "jack@suse.cz" <jack@suse.cz>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>, "mike.kravetz@oracle.com" <mike.kravetz@oracle.com>
List-ID: <linux-nvdimm@lists.01.org>

T24gTW9uLCAyMDE2LTA4LTI5IGF0IDE1OjMxIC0wNjAwLCBLYW5pLCBUb3NoaW1pdHN1IHdyb3Rl
Og0KPiBPbiBNb24sIDIwMTYtMDgtMjkgYXQgMjM6NDggKzAzMDAsIEtpcmlsbCBBLiBTaHV0ZW1v
diB3cm90ZToNCj4gPiANCj4gPiBPbiBNb24sIEF1ZyAyOSwgMjAxNiBhdCAwMToxMToxOVBNIC0w
NjAwLCBUb3NoaSBLYW5pIHdyb3RlOg0KPiA+ID4gDQo+ID4gPiANCj4gPiA+IFdoZW4gQ09ORklH
X0ZTX0RBWF9QTUQgaXMgc2V0LCBEQVggc3VwcG9ydHMgbW1hcCgpIHVzaW5nIHBtZCBwYWdlDQo+
ID4gPiBzaXplLsKgwqBUaGlzIGZlYXR1cmUgcmVsaWVzIG9uIGJvdGggbW1hcCB2aXJ0dWFsIGFk
ZHJlc3MgYW5kIEZTDQo+ID4gPiBibG9jayAoaS5lLiBwaHlzaWNhbCBhZGRyZXNzKSB0byBiZSBh
bGlnbmVkIGJ5IHRoZSBwbWQgcGFnZSBzaXplLg0KPiA+ID4gVXNlcnMgY2FuIHVzZSBta2ZzIG9w
dGlvbnMgdG8gc3BlY2lmeSBGUyB0byBhbGlnbiBibG9jaw0KPiA+ID4gYWxsb2NhdGlvbnMuIEhv
d2V2ZXIsIGFsaWduaW5nIG1tYXAgYWRkcmVzcyByZXF1aXJlcyBjb2RlIGNoYW5nZXMNCj4gPiA+
IHRvIGV4aXN0aW5nIGFwcGxpY2F0aW9ucyBmb3IgcHJvdmlkaW5nIGEgcG1kLWFsaWduZWQgYWRk
cmVzcyB0bw0KPiA+ID4gbW1hcCgpLg0KPiA+ID4gDQo+ID4gPiBGb3IgaW5zdGFuY2UsIGZpbyB3
aXRoICJpb2VuZ2luZT1tbWFwIiBwZXJmb3JtcyBJL09zIHdpdGggbW1hcCgpDQo+ID4gPiBbMV0u
IEl0IGNhbGxzIG1tYXAoKSB3aXRoIGEgTlVMTCBhZGRyZXNzLCB3aGljaCBuZWVkcyB0byBiZQ0K
PiA+ID4gY2hhbmdlZCB0byBwcm92aWRlIGEgcG1kLWFsaWduZWQgYWRkcmVzcyBmb3IgdGVzdGlu
ZyB3aXRoIERBWCBwbWQNCj4gPiA+IG1hcHBpbmdzLiBDaGFuZ2luZyBhbGwgYXBwbGljYXRpb25z
IHRoYXQgY2FsbCBtbWFwKCkgd2l0aCBOVUxMIGlzDQo+ID4gPiB1bmRlc2lyYWJsZS4NCj4gPiA+
IA0KPiA+ID4gVGhpcyBwYXRjaC1zZXQgZXh0ZW5kcyBmaWxlc3lzdGVtcyB0byBhbGlnbiBhbiBt
bWFwIGFkZHJlc3MgZm9yDQo+ID4gPiBhIERBWCBmaWxlIHNvIHRoYXQgdW5tb2RpZmllZCBhcHBs
aWNhdGlvbnMgY2FuIHVzZSBEQVggcG1kDQo+ID4gPiBtYXBwaW5ncy4NCj4gPiANCj4gPiArSHVn
aA0KPiA+IA0KPiA+IENhbiB3ZSBnZXQgaXQgdXNlZCBmb3Igc2htZW0vdG1wZnMgdG9vPw0KPiA+
IEkgZG9uJ3QgdGhpbmsgd2Ugc2hvdWxkIGR1cGxpY2F0ZSBlc3NlbnRpYWxseSB0aGUgc2FtZQ0K
PiA+IGZ1bmN0aW9uYWxpdHkgaW4gbXVsdGlwbGUgcGxhY2VzLg0KPiANCj4gSGVyZSBpcyBteSBi
cmllZiBhbmFseXNpcyB3aGVuIEkgaGFkIGxvb2tlZCBhdCB0aGUgSHVnaCdzIHBhdGNoIGxhc3QN
Cj4gdGltZSAoYmVmb3JlwqBzaG1lbV9nZXRfdW5tYXBwZWRfYXJlYSgpIHdhcyBhY2NlcHRlZCku
DQo+IGh0dHBzOi8vcGF0Y2h3b3JrLmtlcm5lbC5vcmcvcGF0Y2gvODkxNjc0MS8NCj4gDQo+IEJl
c2lkZXMgc29tZSBkaWZmZXJlbmNlcyBpbiB0aGUgbG9naWMsIGV4LiBzaG1lbV9nZXRfdW5tYXBw
ZWRfYXJlYSgpDQo+IGFsd2F5cyBjYWxsc8KgY3VycmVudC0+bW0tPmdldF91bm1hcHBlZF9hcmVh
IHR3aWNlLCB5ZXMsIHRoZXkNCj4gYmFzaWNhbGx5IHByb3ZpZGUgdGhlIHNhbWUgZnVuY3Rpb25h
bGl0eS4NCj4gDQo+IEkgdGhpbmsgb25lIGlzc3VlIGlzIHRoYXQgc2htZW1fZ2V0X3VubWFwcGVk
X2FyZWEoKSBjaGVja3Mgd2l0aCBpdHMNCj4gc3RhdGljIGZsYWcgJ3NobWVtX2h1Z2UnLCBhbmQg
YWRkaXRpbmFsbHkgZGVhbHMgd2l0aCBTSE1FTV9IVUdFX0RFTlkNCj4gYW5kwqBTSE1FTV9IVUdF
X0ZPUkNFIGNhc2VzLiDCoEl0IGFsc28gaGFuZGxlcyBub24tZmlsZSBjYXNlIGZvcg0KPiAhU0hN
RU1fSFVHRV9GT1JDRS4NCg0KTG9va2luZyBmdXJ0aGVyLCB0aGVzZSBzaG1lbV9odWdlIGhhbmRs
aW5ncyBvbmx5IGNoZWNrIHByZS1jb25kaXRpb25zLg0KwqBTbywgd2Ugc2hvdWxkIGJlIGFibGUg
dG8gbWFrZSBzaG1lbV9nZXRfdW5tYXBwZWRfYXJlYSgpIGFzIGEgd3JhcHBlciwNCndoaWNoIGNo
ZWNrcyBzdWNoIHNobWVtLXNwZWNpZmljIGNvbml0aW9ucywgYW5kIHRoZW4NCmNhbGzCoF9fdGhw
X2dldF91bm1hcHBlZF9hcmVhKCkgZm9yIHRoZSBhY3R1YWwgd29yay4gwqBBbGwgREFYLXNwZWNp
ZmljDQpjaGVja3MgYXJlIHBlcmZvcm1lZCBpbiB0aHBfZ2V0X3VubWFwcGVkX2FyZWEoKSBhcyB3
ZWxsLiDCoFdlIGNhbiBtYWtlDQrCoF9fdGhwX2dldF91bm1hcHBlZF9hcmVhKCkgYXMgYSBjb21t
b24gZnVuY3Rpb24uDQoNCkknZCBwcmVmZXIgdG8gbWFrZSBzdWNoIGNoYW5nZSBhcyBhIHNlcGFy
YXRlIGl0ZW0sIGJ1dCBJIGNhbiBpbmNsdWRlIGl0DQp0byB0aGlzIHBhdGNoIHNlcmllcyBpZiBu
ZWVkZWQuwqANCg0KVGhhbmtzLA0KLVRvc2hpDQpfX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGlt
bUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51
eC1udmRpbW0K
