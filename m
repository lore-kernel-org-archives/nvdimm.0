From: "Kani, Toshimitsu" <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
Subject: Re: [PATCH v3 3/4] dm: add infrastructure for DAX support
Date: Fri, 24 Jun 2016 15:40:24 +0000
Message-ID: <1466782822.3504.391.camel@hpe.com>
References: <1466715953-40692-1-git-send-email-snitzer@redhat.com>
 <1466715953-40692-4-git-send-email-snitzer@redhat.com>
 <1466724984.3504.380.camel@hpe.com> <20160624014930.GA10540@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20160624014930.GA10540-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Content-ID: <18CC78150207B44888EC52FD807E6F55-mmYPd6ayCNGroOM5E8FhRbjFIynDaujOfM0AETQt39g@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: "snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org" <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org" <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org" <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

T24gVGh1LCAyMDE2LTA2LTIzIGF0IDIxOjQ5IC0wNDAwLCBNaWtlIFNuaXR6ZXIgd3JvdGU6DQo+
IE9uIFRodSwgSnVuIDIzIDIwMTYgYXTCoMKgNzozNnBtIC0wNDAwLA0KPiBLYW5pLCBUb3NoaW1p
dHN1IDx0b3NoaS5rYW5pQGhwZS5jb20+IHdyb3RlOg0KwqA6DQo+ID4gVGhhbmtzIGZvciB0aGUg
dXBkYXRlLiDCoEkgaGF2ZSBhIHF1ZXN0aW9uIGFib3V0IHRoZSBhYm92ZSBjaGFuZ2UuIMKgVGFy
Z2V0cw0KPiA+IG1heSBoYXZlIHRoZWlyIG93biBwYXJhbWV0ZXJzLiDCoEZvciBpbnN0YW5jZSwg
ZG0tc3RyaXBlIGhhcyAnY2h1bmtfc2l6ZScsDQo+ID4gd2hpY2ggaXMgY2hlY2tlZCBpbiBzdHJp
cGVfY3RyKCkuIMKgREFYIGFkZHMgYWRkaXRpb25hbCByZXN0cmljdGlvbiB0aGF0DQo+ID4gY2h1
bmtfc2l6ZSBuZWVkcyB0byBiZSBhbGlnbmVkIGJ5IHBhZ2Ugc2l6ZS4gwqBTbywgSSB0aGluayB3
ZSBuZWVkIHRvIGtlZXANCj4gPiB0YXJnZXQgcmVzcG9uc2libGUgdG8gdmVyaWZ5IGlmIERBWCBj
YW4gYmUgc3VwcG9ydGVkLiDCoFdoYXQgZG8geW91IHRoaW5rPw0KPg0KPiBXZSd2ZSBuZXZlciBo
YWQgdG8gY29uY2VybiB0aGUgZG0tc3RyaXBlIHRhcmdldCB3aXRoIGhhcmR3YXJlDQo+IHNwZWNp
ZmljIGNodW5rX3NpemUgdmFsaWRhdGlvbi7CoMKgVGhlIHVzZXIgaXMgYWJsZSB0byBzcGVjaWZ5
IHRoZQ0KPiBjaHVua19zaXplIHZpYSBsdm0yJ3MgbHZjcmVhdGUgLUkgYXJndW1lbnQuwqDCoFll
cyB0aGlzIGdpdmVzIHVzZXJzIGVub3VnaA0KPiByb3BlIHRvIGhhbmcgdGhlbXNlbHZlcyBidXQg
aXQgaXMgdmVyeSBlYXN5IHRvIGNvbmZpZ3VyZSBhIGRtLXN0cmlwZQ0KPiBkZXZpY2Ugd2l0aCB0
aGUgYXBwcm9wcmlhdGUgY2h1bmsgc2l6ZSAoUEFHRV9TSVpFKSBmcm9tIHVzZXJzcGFjZS4NCj4g
DQo+IEJ1dCBsdm0yIGNvdWxkIGV2ZW4gYmUgdHJhaW5lZCB0byBtYWtlIHN1cmUgdGhlIGNodW5r
X3NpemUgaXMgYSBmYWN0b3INCj4gb2YgcGh5c2ljYWxfYmxvY2tfc2l6ZSAoUEFHRV9TSVpFIGlu
IHRoZSBjYXNlIG9mIHBtZW0pIGlmIHRoZSB1bmRlcmx5aW5nDQo+IGRldmljZXMgZXhwb3J0IHF1
ZXVlL2RheD0xDQoNCmx2Y3JlYXRlwqAtSSBvbmx5IGFsbG93cyBtdWx0aXBsZSBvZiBwYWdlIHNp
emUsIHNvIHdlIGFyZSBPSyB3aXRoIGx2bTIuIMKgSSB3YXMNCndvbmRlcmluZyBpZiB0aGUgY2hl
Y2sgaW4gbHZtMiBpcyBlbm91Z2guIMKgQXJlIHRoZXJlIGFueSBvdGhlciB0b29scyB0aGF0IG1h
eQ0KYmUgdXNlZCB0byBjb25maWd1cmUgc3RyaXBlIHNpemU/IMKgQ2FuIHdlIHRydXN0IHVzZXJz
cGFjZSBvbiB0aGlzPw0KDQpUaGFua3MsDQotVG9zaGkKX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1u
dmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8v
bGludXgtbnZkaW1tCg==
