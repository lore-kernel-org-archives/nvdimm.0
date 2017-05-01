Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3425.houston.hpe.com (g4t3425.houston.hpe.com
 [15.241.140.78])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E778321A04823
 for <linux-nvdimm@lists.01.org>; Mon,  1 May 2017 09:20:13 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH] libnvdimm: rework region badblocks clearing
Date: Mon, 1 May 2017 16:20:09 +0000
Message-ID: <1493655607.30303.19.camel@hpe.com>
References: <149355594185.9917.1577772489949690281.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1493652871.30303.15.camel@hpe.com>
 <CAPcyv4g4G_fJf6OOGpWbpyMdNioPWEFoJ2eO7+dSTcep+OerFw@mail.gmail.com>
 <CAPcyv4gxuez8BvtWwwcTXCKpzKp+oGQrRQG8+2iQ6XqRAfT_3g@mail.gmail.com>
 <1493655131.30303.17.camel@hpe.com>
 <CAPcyv4hwt8nf5+ADQyj_ahtACZq+if__SqC3dBZTCd==4OWZXA@mail.gmail.com>
In-Reply-To: <CAPcyv4hwt8nf5+ADQyj_ahtACZq+if__SqC3dBZTCd==4OWZXA@mail.gmail.com>
Content-Language: en-US
Content-ID: <256BAA58D087B34D9A286B1DECBB8088@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gTW9uLCAyMDE3LTA1LTAxIGF0IDA5OjE2IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIE1vbiwgTWF5IDEsIDIwMTcgYXQgOToxMiBBTSwgS2FuaSwgVG9zaGltaXRzdSA8dG9zaGku
a2FuaUBocGUuY29tPg0KPiB3cm90ZToNCj4gPiBPbiBNb24sIDIwMTctMDUtMDEgYXQgMDg6NTIg
LTA3MDAsIERhbiBXaWxsaWFtcyB3cm90ZToNCj4gPiA+IE9uIE1vbiwgTWF5IDEsIDIwMTcgYXQg
ODo0MyBBTSwgRGFuIFdpbGxpYW1zIDxkYW4uai53aWxsaWFtc0BpbnRlDQo+ID4gPiBsLmNvDQo+
ID4gPiBtPiB3cm90ZToNCj4gPiA+ID4gT24gTW9uLCBNYXkgMSwgMjAxNyBhdCA4OjM0IEFNLCBL
YW5pLCBUb3NoaW1pdHN1IDx0b3NoaS5rYW5pQGhwDQo+ID4gPiA+IGUuY28NCj4gPiA+ID4gbT4g
d3JvdGU6DQo+ID4gPiA+ID4gT24gU3VuLCAyMDE3LTA0LTMwIGF0IDA1OjM5IC0wNzAwLCBEYW4g
V2lsbGlhbXMgd3JvdGU6DQo+ID4gDQo+ID4gwqA6DQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gSGkg
RGFuLA0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IEkgd2FzIHRlc3RpbmcgdGhlIGNoYW5nZSB3aXRo
IENPTkZJR19ERUJVR19BVE9NSUNfU0xFRVAgc2V0DQo+ID4gPiA+ID4gdGhpcyB0aW1lLCBhbmQg
aGl0IHRoZSBmb2xsb3dpbmcgQlVHIHdpdGggQlRULsKgwqBUaGlzIGlzIGENCj4gPiA+ID4gPiBz
ZXBhcmF0ZSBpc3N1ZSAobm90IGludHJvZHVjZWQgYnkgdGhpcyBwYXRjaCksIGJ1dCBpdCBzaG93
cw0KPiA+ID4gPiA+IHRoYXQgd2UgaGF2ZSBhbiBpc3N1ZSB3aXRoIHRoZSBEU00gY2FsbCBwYXRo
IGFzIHdlbGwuDQo+ID4gPiA+IA0KPiA+ID4gPiBBaCwgZ3JlYXQgZmluZCwgdGhhbmtzISBXZSBk
b24ndCBzZWUgdGhpcyBpbiB0aGUgdW5pdCB0ZXN0cw0KPiA+ID4gPiBiZWNhdXNlIHRoZSBuZml0
X3Rlc3QgaW5mcmFzdHJ1Y3R1cmUgdGFrZXMgbm8gc2xlZXBpbmcgYWN0aW9ucw0KPiA+ID4gPiBp
biBpdHMgc2ltdWxhdGVkIERTTSBwYXRoLiBPdXRzaWRlIG9mIGNvbnZlcnRpbmcgYnR0IHRvIHVz
ZQ0KPiA+ID4gPiBzbGVlcGluZyBsb2NrcyBJJ20gbm90IHN1cmUgSSBzZWUgYSBwYXRoIGZvcndh
cmQuIEkgd29uZGVyIGhvdw0KPiA+ID4gPiBiYWQgdGhlIHBlcmZvcm1hbmNlIGltcGFjdCBvZiB0
aGF0IHdvdWxkIGJlPyBQZXJoYXBzIHdpdGgNCj4gPiA+ID4gb3Bwb3J0dW5pc3RpYyBzcGlubmlu
ZyBpdCB3b24ndCBiZSBzbyBiYWQsIGJ1dCBJIGRvbid0IHNlZQ0KPiA+ID4gPiBhbm90aGVyIGNo
b2ljZS4NCj4gPiA+IA0KPiA+ID4gSXQncyB3b3JzZSB0aGFuIHRoYXQuIFBhcnQgb2YgdGhlIHBl
cmZvcm1hbmNlIG9wdGltaXphdGlvbiBvZiBCVFQNCj4gPiA+IEkvTyB3YXMgdG8gYXZvaWQgbG9j
a2luZyBhbHRvZ2V0aGVyIHdoZW4gd2UgY291bGQgcmVseSBvbiBhIEJUVA0KPiA+ID4gbGFuZSBw
ZXJjcHUsIHNvIHRoYXQgd291bGQgYWxzbyBuZWVkIHRvIGJlIHJlbW92ZWQuDQo+ID4gDQo+ID4g
SSBkbyBub3QgaGF2ZSBhIGdvb2QgaWRlYSBlaXRoZXIsIGJ1dCBJJ2QgcmF0aGVyIGRpc2FibGUg
dGhpcw0KPiA+IGNsZWFyaW5nIGluIHRoZSByZWd1bGFyIEJUVCB3cml0ZSBwYXRoIHRoYW4gYWRk
aW5nIHNsZWVwaW5nIGxvY2tzDQo+ID4gdG8gQlRULiBDbGVhcmluZyBhIGJhZCBibG9jayBpbiB0
aGUgQlRUIHdyaXRlIHBhdGggaXMNCj4gPiBkaWZmaWN1bHQvY2hhbGxlbmdpbmcgc2luY2UgaXQg
YWxsb2NhdGVzIGEgbmV3IGJsb2NrLg0KPiANCj4gQWN0dWFsbHksIHRoYXQgbWF5IG1ha2UgdGhp
bmdzIGVhc2llci4gQ2FuIHdlIHRlYWNoIEJUVCB0byB0cmFjaw0KPiBlcnJvciBibG9ja3MgYW5k
IGNsZWFyIHRoZW0gYmVmb3JlIHRoZXkgYXJlIHJlYXNzaWduZWQ/DQoNCkkgd2FzIHRoaW5raW5n
IHRoZSBzYW1lIGFmdGVyIHNlbmRpbmcgaXQuICBJIHRoaW5rIHdlIHNob3VsZCBiZSBhYmxlIHRv
DQpkbyB0aGF0Lg0KDQpUaGFua3MsDQotVG9zaGkKX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRp
bW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGlu
dXgtbnZkaW1tCg==
