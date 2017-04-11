Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5008.houston.hpe.com (g9t5008.houston.hpe.com [15.241.48.72])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 452DB21A18AAB
 for <linux-nvdimm@lists.01.org>; Tue, 11 Apr 2017 08:15:22 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH v3] x86, pmem: fix broken __copy_user_nocache cache-bypass
 assumptions
Date: Tue, 11 Apr 2017 15:15:16 +0000
Message-ID: <1491923701.9118.34.camel@hpe.com>
References: <149187075199.40875.9829505688202257056.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149187075199.40875.9829505688202257056.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
Content-ID: <811AD640C00A03489F50834542E5B8AF@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: "jack@suse.cz" <jack@suse.cz>, "mawilcox@microsoft.com" <mawilcox@microsoft.com>, "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "hpa@zytor.com" <hpa@zytor.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "hch@lst.de" <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

T24gTW9uLCAyMDE3LTA0LTEwIGF0IDE3OjM1IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IEJlZm9yZSB3ZSByZXdvcmsgdGhlICJwbWVtIGFwaSIgdG8gc3RvcCBhYnVzaW5nIF9fY29weV91
c2VyX25vY2FjaGUoKQ0KPiBmb3IgbWVtY3B5X3RvX3BtZW0oKSB3ZSBuZWVkIHRvIGZpeCBjYXNl
cyB3aGVyZSB3ZSBtYXkgc3RyYW5kIGRpcnR5DQo+IGRhdGEgaW4gdGhlIGNwdSBjYWNoZS4gVGhl
IHByb2JsZW0gb2NjdXJzIHdoZW4gY29weV9mcm9tX2l0ZXJfcG1lbSgpDQo+IGlzIHVzZWQgZm9y
IGFyYml0cmFyeSBkYXRhIHRyYW5zZmVycyBmcm9tIHVzZXJzcGFjZS4gVGhlcmUgaXMgbm8NCj4g
Z3VhcmFudGVlIHRoYXQgdGhlc2UgdHJhbnNmZXJzLCBwZXJmb3JtZWQgYnkgZGF4X2lvbWFwX2Fj
dG9yKCksIHdpbGwNCj4gaGF2ZSBhbGlnbmVkIGRlc3RpbmF0aW9ucyBvciBhbGlnbmVkIHRyYW5z
ZmVyIGxlbmd0aHMuIEJhY2tzdG9wIHRoZQ0KPiB1c2FnZSBfX2NvcHlfdXNlcl9ub2NhY2hlKCkg
d2l0aCBleHBsaWNpdCBjYWNoZSBtYW5hZ2VtZW50IGluIHRoZXNlDQo+IHVuYWxpZ25lZCBjYXNl
cy4NCj4gDQo+IFllcywgY29weV9mcm9tX2l0ZXJfcG1lbSgpIGlzIG5vdyB0b28gYmlnIGZvciBh
biBpbmxpbmUsIGJ1dA0KPiBhZGRyZXNzaW5nIHRoYXQgaXMgc2F2ZWQgZm9yIGEgbGF0ZXIgcGF0
Y2ggdGhhdCBtb3ZlcyB0aGUgZW50aXJldHkgb2YNCj4gdGhlICJwbWVtIGFwaSIgaW50byB0aGUg
cG1lbSBkcml2ZXIgZGlyZWN0bHkuDQo+IA0KPiBGaXhlczogNWRlNDkwZGFlYzhiICgicG1lbTog
YWRkIGNvcHlfZnJvbV9pdGVyX3BtZW0oKSBhbmQNCj4gY2xlYXJfcG1lbSgpIikNCj4gQ2M6IDxz
dGFibGVAdmdlci5rZXJuZWwub3JnPg0KPiBDYzogPHg4NkBrZXJuZWwub3JnPg0KPiBDYzogSmFu
IEthcmEgPGphY2tAc3VzZS5jej4NCj4gQ2M6IEplZmYgTW95ZXIgPGptb3llckByZWRoYXQuY29t
Pg0KPiBDYzogSW5nbyBNb2xuYXIgPG1pbmdvQHJlZGhhdC5jb20+DQo+IENjOiBDaHJpc3RvcGgg
SGVsbHdpZyA8aGNoQGxzdC5kZT4NCj4gQ2M6ICJILiBQZXRlciBBbnZpbiIgPGhwYUB6eXRvci5j
b20+DQo+IENjOiBBbCBWaXJvIDx2aXJvQHplbml2LmxpbnV4Lm9yZy51az4NCj4gQ2M6IFRob21h
cyBHbGVpeG5lciA8dGdseEBsaW51dHJvbml4LmRlPg0KPiBDYzogTWF0dGhldyBXaWxjb3ggPG1h
d2lsY294QG1pY3Jvc29mdC5jb20+DQo+IENjOiBSb3NzIFp3aXNsZXIgPHJvc3Muendpc2xlckBs
aW51eC5pbnRlbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFRvc2hpIEthbmkgPHRvc2hpLmthbmlA
aHBlLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogRGFuIFdpbGxpYW1zIDxkYW4uai53aWxsaWFtc0Bp
bnRlbC5jb20+DQo+IC0tLQ0KPiBDaGFuZ2VzIGluIHYzOg0KPiAqIG1hdGNoIHRoZSBpbXBsZW1l
bnRhdGlvbiB0byB0aGUgbm90ZXMgYXQgdGhlIHRvcCBvZg0KPiDCoCBfX2NvcHlfdXNlcl9ub2Nh
Y2hlIChUb3NoaSkNCj4gDQo+ICogU3dpdGNoIHRvIHVzaW5nIHRoZSBJU19BTElHTkVEKCkgbWFj
cm8gdG8gbWFrZSBhbGlnbm1lbnQgY2hlY2tzDQo+IGVhc2llciB0byByZWFkIGFuZCBoYXJkZXIg
dG8gZ2V0IHdyb25nIGxpa2UgdGhleSB3ZXJlIGluIHYyLiAoVG9zaGksDQo+IERhbikNCg0KVGhh
bmtzIERhbiEgIEl0IGxvb2tzIGdvb2QuDQotVG9zaGkKX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1u
dmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8v
bGludXgtbnZkaW1tCg==
