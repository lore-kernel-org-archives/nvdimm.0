Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ZXSHCAS01.zhaoxin.com (unknown [180.169.121.82])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7202E1A2073
 for <linux-nvdimm@lists.01.org>; Wed, 13 Apr 2016 19:03:00 -0700 (PDT)
From: Eric Shang <EricShang@zhaoxin.com>
Subject: =?utf-8?B?562U5aSNOiBleHQ0IGVycm9y?=
Date: Thu, 14 Apr 2016 02:02:18 +0000
Message-ID: <0255994B402DE243B1DFC1057A00655201AE84@ZXSHMBX02.zhaoxin.com>
References: <0255994B402DE243B1DFC1057A00655201AC6F@ZXSHMBX02.zhaoxin.com>
 <1460556627.24985.28.camel@hpe.com>
In-Reply-To: <1460556627.24985.28.camel@hpe.com>
Content-Language: zh-CN
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
To: Toshi Kani <toshi.kani@hpe.com>, Matthew Wilcox <willy@linux.intel.com>
Cc: "jack@suse.cz" <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "david@fromorbit.com" <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>, "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "tytso@mit.edu" <tytso@mit.edu>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>
List-ID: <linux-nvdimm@lists.01.org>

SGkgVG9zaGk6DQoJVGhhbmtzISBJIHRoaW5rIHRoaXMgbm90IHJlbGF0ZSB0byBEQVggYW5kIGRh
eF9nZXRfdW5tYXBwZWRfYXJlYSwgSSBhbSBhIGp1bmlvciBrZXJuZWwgbWFpbnRhaW5lciBmb3Ig
b3VyIGNvbXBhbnkuIFRoaXMgaXNzdWUgYm90aGVyIG1lIGxvbmcgdGltZSwgbG9va3MgbGlrZSBr
ZXJuZWwgZXh0NCBpc3N1ZSBvciBvdXIgZW1tYyBkcml2ZXIgaXNzdWUsIEkgd2lsbCBkaWcgaXQg
b3V0LCBUaGFua3MhDQoNCkJlc3QgUmVnYXJkcw0KRXJpY1NoYW5nDQoNCg0KLS0tLS3pgq7ku7bl
jp/ku7YtLS0tLQ0K5Y+R5Lu25Lq6OiBUb3NoaSBLYW5pIFttYWlsdG86dG9zaGkua2FuaUBocGUu
Y29tXSANCuWPkemAgeaXtumXtDogMjAxNuW5tDTmnIgxM+aXpSAyMjoxMA0K5pS25Lu25Lq6OiBF
cmljIFNoYW5nOyBNYXR0aGV3IFdpbGNveA0K5oqE6YCBOiBha3BtQGxpbnV4LWZvdW5kYXRpb24u
b3JnOyBkYW4uai53aWxsaWFtc0BpbnRlbC5jb207IHZpcm9AemVuaXYubGludXgub3JnLnVrOyBy
b3NzLnp3aXNsZXJAbGludXguaW50ZWwuY29tOyBraXJpbGwuc2h1dGVtb3ZAbGludXguaW50ZWwu
Y29tOyBkYXZpZEBmcm9tb3JiaXQuY29tOyBqYWNrQHN1c2UuY3o7IHR5dHNvQG1pdC5lZHU7IGFk
aWxnZXIua2VybmVsQGRpbGdlci5jYTsgbGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZzsgbGludXgt
ZnNkZXZlbEB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWV4dDRAdmdlci5rZXJuZWwub3JnOyB4ZnNA
b3NzLnNnaS5jb207IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCuS4u+mimDogUmU6IGV4
dDQgZXJyb3INCg0KT24gV2VkLCAyMDE2LTA0LTEzIGF0IDEzOjQ0ICswMDAwLCBFcmljIFNoYW5n
IHdyb3RlOg0KPiBISSBBbGw6DQo+IMKgIEkgbWVldCBhbiBleHQ0IGVycm9yLCBmb2xsb3dpbmcg
aXMgdGhlIGVycm9yIGxvZy4gQWZ0ZXIgcGFuaWMsIEkgDQo+IGNoZWNrIHRoZSBlbW1jIGJ5IHRo
ZSB0b29sIGRlYnVmcywgdGhlIGlub2RlIDY5ODc4IGlfbmxpbmsgaXMgbm90IA0KPiB6ZXJvLiBB
bmQgdGhpcyBpbm9kZSBkb24ndCBiZWxvbmcgdG8gcGFyZW50IGRpciA2OTg3LCBpdCBiZWxvbmcg
dG8gDQo+IG90aGVyIGZpbGUodGhpcyBpbm9kZSBiZWxvbmcgdG8gdHdvIGZpbGVzIHdoZW4gY2hl
Y2sgYnkgZGVidWdmcyANCj4gbmNoZWNrKSwgSSBndWVzcyB0aGFuIHRoaXMgaW5vZGUgaGFzIGJl
ZWQgZGVsZXRlZCBpbiBtZW1vcnkgYW5kIA0KPiBhbHJlYWR5IHVzZWQgYnkgb3RoZXIgZmlsZS4g
QnV0IHRoZSBwYXJlbnQgZGVudHJ5IGJ1ZmZfaGVhZCBub3QgZmx1c2ggDQo+IHRvIGVtbWMuIEJ1
dCB3aGVuIGxvb2t1cCB0aGlzIGRlbnRyeSBjYW4ndCBmaW5kIGl0JyBpbiBkZW50cnkgY2FjaGUs
IA0KPiBhbmQgdGhlbiBsb29rdXBfcmVhbCwgcmVhZCB0aGUgZGVudHJ5IGZyb20gZW1tYywgZ2V0
IHRoZSBmaWxlIGlub2RlIHdoaWNoIGFscmVhZHkgYmUgZGVsZXRlZC4NCj4gwqAgQ2FuIGFueSBn
aXZlIG1lIHNvbWUgaGVscCBob3cgdG8gY2hlY2sgdGhpcyBpc3N1ZS4gTXkga2VybmVsIHZlcnNp
b24gDQo+IGlzIDMuMTggZm9ybSBBbmRyb2lkIC4gSSB0aGlua3Mgc29tZXRoaW5nIHdyb25nIHdp
dGggZGVudHJ5IGNhY2hlIA0KPiBmbHVzaCBhbmQgZGlydHkgYnVmZl9oZWFkIGZsdXNoIHRvIGVt
bWMuIFRoYW5rcyBhbGwhDQoNCkFyZSB5b3Ugc29tZWhvdyB1c2luZyBEQVggYW5kIG15IGRheF9n
ZXRfdW5tYXBwZWRfYXJlYSBwYXRjaGVzIGluIHlvdXIgQW5kcm9pZA0KMy4xOCBrZXJuZWw/IEkg
ZG91YnQgdGhpcyBpcyB0aGUgY2FzZSwgYnV0IEkgdGhvdWdodCBJIHNob3VsZCBjaGVjayBzaW5j
ZSB5b3UgcmVwb3J0ZWQgaXQgdG8gbWUgYW5kIE1hdHRoZXcgd2l0aCB0aGUgc2FtZSBjYyBsaXN0
Lg0KDQpJZiB5b3UgYXJlIHNpbXBseSB1c2luZyBhIGRpc3RyaWJ1dGVkIEFuZHJvaWQga2VybmVs
LCB5b3Ugc2hvdWxkIHJlcG9ydCBpdCB0byBBbmRyb2lkIGVtYWlsIGxpc3Qgb3IgYnVnIHRyYWNr
ZXIuDQoNCi1Ub3NoaQ0KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3Jn
Cmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
