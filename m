Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM03-CO1-obe.outbound.protection.outlook.com
 (mail-co1nam03on0718.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe48::718])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3AD6F1A1E01
 for <linux-nvdimm@lists.01.org>; Thu,  8 Sep 2016 06:49:43 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH v4 RESEND 0/2] Align mmap address for DAX pmd mappings
Date: Thu, 8 Sep 2016 13:49:40 +0000
Message-ID: <1473342519.2092.42.camel@hpe.com>
References: <1472497881-9323-1-git-send-email-toshi.kani@hpe.com>
 <20160829204842.GA27286@node.shutemov.name>
 <1472506310.1532.47.camel@hpe.com> <1472508000.1532.59.camel@hpe.com>
 <20160908105707.GA17331@node>
In-Reply-To: <20160908105707.GA17331@node>
Content-Language: en-US
Content-ID: <FA10C1A0FF88C44F97659DC33A368661@NAMPRD84.PROD.OUTLOOK.COM>
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

T24gVGh1LCAyMDE2LTA5LTA4IGF0IDEzOjU3ICswMzAwLCBLaXJpbGwgQS4gU2h1dGVtb3Ygd3Jv
dGU6DQo+IE9uIE1vbiwgQXVnIDI5LCAyMDE2IGF0IDEwOjAwOjQzUE0gKzAwMDAsIEthbmksIFRv
c2hpbWl0c3Ugd3JvdGU6DQo+ID4gDQo+ID4gT24gTW9uLCAyMDE2LTA4LTI5IGF0IDE1OjMxIC0w
NjAwLCBLYW5pLCBUb3NoaW1pdHN1IHdyb3RlOg0KPiA+ID4gDQo+ID4gPiBPbiBNb24sIDIwMTYt
MDgtMjkgYXQgMjM6NDggKzAzMDAsIEtpcmlsbCBBLiBTaHV0ZW1vdiB3cm90ZToNCj4gPiA+ID4g
DQrCoDoNCj4gPiBMb29raW5nIGZ1cnRoZXIsIHRoZXNlIHNobWVtX2h1Z2UgaGFuZGxpbmdzIG9u
bHkgY2hlY2sgcHJlLQ0KPiA+IGNvbmRpdGlvbnMuIMKgU28sIHdlIHNob3VsZCANCj4gPiBiZcKg
YWJsZcKgdG/CoG1ha2XCoHNobWVtX2dldF91bm1hcHBlZF9hcmVhKCkgYXMgYSB3cmFwcGVyLCB3
aGljaA0KPiA+IGNoZWNrcyBzdWNoIHNobWVtLXNwZWNpZmljIGNvbml0aW9ucywgYW5kDQo+ID4g
dGhlbsKgY2FsbMKgX190aHBfZ2V0X3VubWFwcGVkX2FyZWEoKSBmb3IgdGhlIGFjdHVhbCB3b3Jr
LiDCoEFsbCBEQVgtDQo+ID4gc3BlY2lmaWMgY2hlY2tzIGFyZSBwZXJmb3JtZWQgaW4gdGhwX2dl
dF91bm1hcHBlZF9hcmVhKCkgYXMgd2VsbC4NCj4gPiDCoFdlIGNhbiBtYWtlIMKgX190aHBfZ2V0
X3VubWFwcGVkX2FyZWEoKSBhcyBhIGNvbW1vbiBmdW5jdGlvbi4NCj4gPiANCj4gPiBJJ2QgcHJl
ZmVyIHRvIG1ha2Ugc3VjaCBjaGFuZ2UgYXMgYSBzZXBhcmF0ZSBpdGVtLA0KPiANCj4gRG8geW91
IGhhdmUgcGxhbiB0byBzdWJtaXQgc3VjaCBjaGFuZ2U/DQoNClllcywgSSB3aWxsIHN1Ym1pdCB0
aGUgY2hhbmdlIG9uY2UgSSBmaW5pc2ggdGVzdGluZy4NCg0KVGhhbmtzLA0KLVRvc2hpCl9fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBt
YWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9y
Zy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
