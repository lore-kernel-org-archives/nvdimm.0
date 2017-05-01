Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5008.houston.hpe.com (g9t5008.houston.hpe.com [15.241.48.72])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 88E2121A04823
 for <linux-nvdimm@lists.01.org>; Mon,  1 May 2017 09:45:42 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH] libnvdimm: rework region badblocks clearing
Date: Mon, 1 May 2017 16:45:37 +0000
Message-ID: <1493657135.30303.22.camel@hpe.com>
References: <149355594185.9917.1577772489949690281.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1493652871.30303.15.camel@hpe.com>
 <CAPcyv4g4G_fJf6OOGpWbpyMdNioPWEFoJ2eO7+dSTcep+OerFw@mail.gmail.com>
 <CAPcyv4gxuez8BvtWwwcTXCKpzKp+oGQrRQG8+2iQ6XqRAfT_3g@mail.gmail.com>
 <1493655131.30303.17.camel@hpe.com>
 <CAPcyv4hwt8nf5+ADQyj_ahtACZq+if__SqC3dBZTCd==4OWZXA@mail.gmail.com>
 <1493655607.30303.19.camel@hpe.com>
 <CAPcyv4gLND=U9OUa7yFYDNDgmfk_Fx-pgdbxZpsaxhH8KU4xsA@mail.gmail.com>
 <1493656965.4424.0.camel@intel.com>
In-Reply-To: <1493656965.4424.0.camel@intel.com>
Content-Language: en-US
Content-ID: <B1C2E150494C1042AB51F77872EBC734@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gTW9uLCAyMDE3LTA1LTAxIGF0IDE2OjQyICswMDAwLCBWZXJtYSwgVmlzaGFsIEwgd3JvdGU6
DQo+IE9uIE1vbiwgMjAxNy0wNS0wMSBhdCAwOTozOCAtMDcwMCwgRGFuIFdpbGxpYW1zIHdyb3Rl
Og0KPiA+IE9uIE1vbiwgTWF5IDEsIDIwMTcgYXQgOToyMCBBTSwgS2FuaSwgVG9zaGltaXRzdQ0K
PiA+IDx0b3NoaS5rYW5pQGhwZS5jb20+DQogOg0KPiA+ID4gPiA+ID4gPiA+IEhpIERhbiwNCj4g
PiA+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+ID4gPiBJIHdhcyB0ZXN0aW5nIHRoZSBjaGFuZ2Ug
d2l0aCBDT05GSUdfREVCVUdfQVRPTUlDX1NMRUVQDQo+ID4gPiA+ID4gPiA+ID4gc2V0IHRoaXMg
dGltZSwgYW5kIGhpdCB0aGUgZm9sbG93aW5nIEJVRyB3aXRoDQo+ID4gPiA+ID4gPiA+ID4gQlRU
LsKgwqBUaGlzIGlzIGEgc2VwYXJhdGUgaXNzdWUgKG5vdCBpbnRyb2R1Y2VkIGJ5IHRoaXMNCj4g
PiA+ID4gPiA+ID4gPiBwYXRjaCksIGJ1dCBpdCBzaG93cyB0aGF0IHdlIGhhdmUgYW4gaXNzdWUg
d2l0aCB0aGUgRFNNDQo+ID4gPiA+ID4gPiA+ID4gY2FsbCBwYXRoIGFzIHdlbGwuDQo+ID4gPiA+
ID4gPiA+IA0KPiA+ID4gPiA+ID4gPiBBaCwgZ3JlYXQgZmluZCwgdGhhbmtzISBXZSBkb24ndCBz
ZWUgdGhpcyBpbiB0aGUgdW5pdA0KPiA+ID4gPiA+ID4gPiB0ZXN0cyBiZWNhdXNlIHRoZSBuZml0
X3Rlc3QgaW5mcmFzdHJ1Y3R1cmUgdGFrZXMgbm8NCj4gPiA+ID4gPiA+ID4gc2xlZXBpbmcgYWN0
aW9ucyBpbiBpdHMgc2ltdWxhdGVkIERTTSBwYXRoLiBPdXRzaWRlIG9mDQo+ID4gPiA+ID4gPiA+
IGNvbnZlcnRpbmcgYnR0IHRvIHVzZSBzbGVlcGluZyBsb2NrcyBJJ20gbm90IHN1cmUgSSBzZWUg
YQ0KPiA+ID4gPiA+ID4gPiBwYXRoIGZvcndhcmQuIEkgd29uZGVyIGhvdyBiYWQgdGhlIHBlcmZv
cm1hbmNlIGltcGFjdCBvZg0KPiA+ID4gPiA+ID4gPiB0aGF0IHdvdWxkIGJlPyBQZXJoYXBzIHdp
dGggb3Bwb3J0dW5pc3RpYyBzcGlubmluZyBpdA0KPiA+ID4gPiA+ID4gPiB3b24ndCBiZSBzbyBi
YWQsIGJ1dCBJIGRvbid0IHNlZSBhbm90aGVyIGNob2ljZS4NCj4gPiA+ID4gPiA+IA0KPiA+ID4g
PiA+ID4gSXQncyB3b3JzZSB0aGFuIHRoYXQuIFBhcnQgb2YgdGhlIHBlcmZvcm1hbmNlIG9wdGlt
aXphdGlvbg0KPiA+ID4gPiA+ID4gb2YgQlRUIEkvTyB3YXMgdG8gYXZvaWQgbG9ja2luZyBhbHRv
Z2V0aGVyIHdoZW4gd2UgY291bGQNCj4gPiA+ID4gPiA+IHJlbHkgb24gYSBCVFQgbGFuZSBwZXJj
cHUsIHNvIHRoYXQgd291bGQgYWxzbyBuZWVkIHRvIGJlDQo+ID4gPiA+ID4gPiByZW1vdmVkLg0K
PiA+ID4gPiA+IA0KPiA+ID4gPiA+IEkgZG8gbm90IGhhdmUgYSBnb29kIGlkZWEgZWl0aGVyLCBi
dXQgSSdkIHJhdGhlciBkaXNhYmxlIHRoaXMNCj4gPiA+ID4gPiBjbGVhcmluZyBpbiB0aGUgcmVn
dWxhciBCVFQgd3JpdGUgcGF0aCB0aGFuIGFkZGluZyBzbGVlcGluZw0KPiA+ID4gPiA+IGxvY2tz
IHRvIEJUVC4gQ2xlYXJpbmcgYSBiYWQgYmxvY2sgaW4gdGhlIEJUVCB3cml0ZSBwYXRoIGlzDQo+
ID4gPiA+ID4gZGlmZmljdWx0L2NoYWxsZW5naW5nIHNpbmNlIGl0IGFsbG9jYXRlcyBhIG5ldyBi
bG9jay4NCj4gPiA+ID4gDQo+ID4gPiA+IEFjdHVhbGx5LCB0aGF0IG1heSBtYWtlIHRoaW5ncyBl
YXNpZXIuIENhbiB3ZSB0ZWFjaCBCVFQgdG8NCj4gPiA+ID4gdHJhY2sgZXJyb3IgYmxvY2tzIGFu
ZCBjbGVhciB0aGVtIGJlZm9yZSB0aGV5IGFyZSByZWFzc2lnbmVkPw0KPiA+ID4gDQo+ID4gPiBJ
IHdhcyB0aGlua2luZyB0aGUgc2FtZSBhZnRlciBzZW5kaW5nIGl0LsKgwqBJIHRoaW5rIHdlIHNo
b3VsZCBiZQ0KPiA+ID4gYWJsZSB0byBkbyB0aGF0Lg0KPiA+IA0KPiA+IE9rLCBidXQgd2Ugb2J2
aW91c2x5IGNhbid0IGRldmVsb3Agc29tZXRoaW5nIHRoYXQgZGV0YWlsZWQgd2hpbGUNCj4gPiB0
aGUgbWVyZ2Ugd2luZG93IGlzIG9wZW4sIHNvIEkgdGhpbmsgdGhhdCBtZWFucyB3ZSBuZWVkIHRv
IHJldmVydA0KPiA+IGNvbW1pdCBlODhkYTc5OThkN2QgIlJldmVydCAnbGlibnZkaW1tOiBiYW5k
IGFpZCBidHQgdnMgY2xlYXINCj4gPiBwb2lzb24gbG9ja2luZyciIGFuZCBsZWF2ZSBCVFQgSS9P
LWVycm9yLWNsZWFyaW5nIGRpc2FibGVkIGZvciB0aGlzDQo+ID4gY3ljbGUgYW5kIHRyeSBhZ2Fp
biBmb3IgNC4xMy4NCj4gDQo+IEFncmVlZCwgSSdsbCB3b3JrIG9uIHNvbWV0aGluZyB0byB0cmFj
ayBiYWRibG9ja3MgYW5kIGNsZWFyIHRoZW0NCj4gb3V0c2lkZSB0aGUgSU8gcGF0aC4NCg0KR3Jl
YXQhICBUaGFua3MgVmlzaGFsIQ0KLVRvc2hpDQpfX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGlt
bUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51
eC1udmRpbW0K
