Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm03.jp.fujitsu.com (mgwkm03.jp.fujitsu.com [202.219.69.170])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 783C1212ACEDC
 for <linux-nvdimm@lists.01.org>; Tue, 12 Jun 2018 16:52:01 -0700 (PDT)
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local
 (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
 by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id D73E4AC0189
 for <linux-nvdimm@lists.01.org>; Wed, 13 Jun 2018 08:51:54 +0900 (JST)
From: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Subject: RE: [PATCH v6 1/4] ndctl, util: add OPTION_FILENAME to parse_opt_type
Date: Tue, 12 Jun 2018 23:51:52 +0000
Message-ID: <0DEDF3B159719A448A49EF0E7B11E3222768E735@g01jpexmbkw01>
References: <20180507050926.17243-1-qi.fuli@jp.fujitsu.com>
 <20180507050926.17243-2-qi.fuli@jp.fujitsu.com>
 <CAPcyv4hcq4jbsP=tSHJ2NqDVAFepmT0UQj-xJVt3KjauHw3ZVA@mail.gmail.com>
 <0DEDF3B159719A448A49EF0E7B11E3222766C70A@g01jpexmbkw01>
 <1528843507.4998.8.camel@intel.com>
In-Reply-To: <1528843507.4998.8.camel@intel.com>
Content-Language: en-US
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
To: "'Verma, Vishal L'" <vishal.l.verma@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBWZXJtYSwgVmlzaGFsIEwgW21h
aWx0bzp2aXNoYWwubC52ZXJtYUBpbnRlbC5jb21dDQo+IFNlbnQ6IFdlZG5lc2RheSwgSnVuZSAx
MywgMjAxOCA3OjQ1IEFNDQo+IFRvOiBXaWxsaWFtcywgRGFuIEogPGRhbi5qLndpbGxpYW1zQGlu
dGVsLmNvbT47IFFpLCBGdWxpL+aWiSDnpo/liKkNCj4gPHFpLmZ1bGlAanAuZnVqaXRzdS5jb20+
DQo+IENjOiBsaW51eC1udmRpbW1AbGlzdHMuMDEub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0gg
djYgMS80XSBuZGN0bCwgdXRpbDogYWRkIE9QVElPTl9GSUxFTkFNRSB0bw0KPiBwYXJzZV9vcHRf
dHlwZQ0KPiANCj4gT24gV2VkLCAyMDE4LTA1LTE2IGF0IDAyOjQyICswMDAwLCBRaSwgRnVsaSB3
cm90ZToNCj4gPiA+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gPiBGcm9tOiBEYW4g
V2lsbGlhbXMgW21haWx0bzpkYW4uai53aWxsaWFtc0BpbnRlbC5jb21dDQo+ID4gPiBTZW50OiBT
YXR1cmRheSwgTWF5IDEyLCAyMDE4IDE6NDIgQU0NCj4gPiA+IFRvOiBRaSwgRnVsaS/mlokg56aP
5YipIDxxaS5mdWxpQGpwLmZ1aml0c3UuY29tPg0KPiA+ID4gQ2M6IGxpbnV4LW52ZGltbSA8bGlu
dXgtbnZkaW1tQGxpc3RzLjAxLm9yZz4NCj4gPiA+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjYgMS80
XSBuZGN0bCwgdXRpbDogYWRkIE9QVElPTl9GSUxFTkFNRSB0bw0KPiA+ID4gcGFyc2Vfb3B0X3R5
cGUNCj4gPiA+DQo+ID4gPiBPbiBTdW4sIE1heSA2LCAyMDE4IGF0IDEwOjA5IFBNLCBRSSBGdWxp
IDxxaS5mdWxpQGpwLmZ1aml0c3UuY29tPg0KPiA+ID4gd3JvdGU6DQo+ID4gPiA+IFRoaXMgcGF0
Y2ggYm9ycm93cyB0aGUgT1BUSU9OX0ZJTEVOQU1FIGZyb20gZ2l0IHRvIG5kY3RsIHRvIG1ha2UN
Cj4gPiA+ID4gc3VyZSBmaWxlbmFtZSBpcyBjb3JyZWN0LiBTb21lIHJlbGF0ZWQgcmVmYWN0b3Jp
bmcgaXMgYWxzbyBpbmNsdWRlZDoNCj4gPiA+ID4gICAtIGFkZHMgcGFyc2Vfb3B0aW9uc19wcmVm
aXgoKSBpbnRlcmZhY2UNCj4gPiA+ID4gICAtIG1vdmVzIGlzX2Fic29sdXRlIGZyb20gdXRpbC9o
ZWxwLmMgdG8gdXRpbC91dGlsLmMNCj4gPiA+ID4gICAtIGFkZHMgYSBuZXcgZmlsZSB1dGlsL2Fi
c3BhdGguYw0KPiA+ID4gPg0KPiA+ID4gPiBTaWduZWQtb2ZmLWJ5OiBRSSBGdWxpIDxxaS5mdWxp
QGpwLmZ1aml0c3UuY29tPg0KPiA+ID4NCj4gPiA+IFJldmlld2VkLWJ5OiBEYW4gV2lsbGlhbXMg
PGRhbi5qLndpbGxpYW1zQGludGVsLmNvbT4NCj4gPiA+DQo+ID4NCj4gPiBTaW5jZSB0aGlzIHBh
dGNoIGlzIGluZGVwZW5kZW50IGZyb20gdGhlIG90aGVycywgY291bGQgeW91IHBsZWFzZQ0KPiA+
IG1lcmdlIHRoaXMgb25lIGZpcnN0Pw0KPiANCj4gSGkgUWksDQo+IA0KPiBZZXMgSSBoYXZlIGFw
cGxpZWQgdGhlIGZpcnN0IHBhdGNoLCBhbmQgaXQgaXMgbm93IGluIHRoZSBwZW5kaW5nIGJyYW5j
aC4NCj4gDQo+IFRoYW5rcywNCj4gCS1WaXNoYWwNCg0KVGhhbmsgeW91IHZlcnkgbXVjaC4NCg0K
UWkNCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4
LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xp
c3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
