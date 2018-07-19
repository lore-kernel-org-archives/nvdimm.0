Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm04.jp.fujitsu.com (mgwkm04.jp.fujitsu.com [202.219.69.171])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8395E21BADAB2
 for <linux-nvdimm@lists.01.org>; Wed, 18 Jul 2018 18:02:18 -0700 (PDT)
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local
 (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
 by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id D8602AC01C6
 for <linux-nvdimm@lists.01.org>; Thu, 19 Jul 2018 10:02:02 +0900 (JST)
From: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Subject: RE: [ndctl PATCH v13 0/5] ndctl, monitor: add ndctl monitor daemon
Date: Thu, 19 Jul 2018 01:02:01 +0000
Message-ID: <0DEDF3B159719A448A49EF0E7B11E3223DA8BEE6@g01jpexmbkw24>
References: <20180713233350.7148-1-qi.fuli@jp.fujitsu.com>
 <1531960975.7574.162.camel@intel.com>
In-Reply-To: <1531960975.7574.162.camel@intel.com>
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
To: "'Verma, Vishal L'" <vishal.l.verma@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: "Tokunaga, Keiichirou" <tokunaga.keiich@jp.fujitsu.com>
List-ID: <linux-nvdimm@lists.01.org>

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBWZXJtYSwgVmlzaGFsIEwgW21h
aWx0bzp2aXNoYWwubC52ZXJtYUBpbnRlbC5jb21dDQo+IFNlbnQ6IFRodXJzZGF5LCBKdWx5IDE5
LCAyMDE4IDk6NDMgQU0NCj4gVG86IGxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmc7IFFpLCBGdWxp
L+aWiSDnpo/liKkgPHFpLmZ1bGlAanAuZnVqaXRzdS5jb20+DQo+IENjOiBXaWxsaWFtcywgRGFu
IEogPGRhbi5qLndpbGxpYW1zQGludGVsLmNvbT47IFRva3VuYWdhLCBLZWlpY2hpcm91L+W+s+aw
uCDlnK3kuIDpg44NCj4gPHRva3VuYWdhLmtlaWljaEBqcC5mdWppdHN1LmNvbT4NCj4gU3ViamVj
dDogUmU6IFtuZGN0bCBQQVRDSCB2MTMgMC81XSBuZGN0bCwgbW9uaXRvcjogYWRkIG5kY3RsIG1v
bml0b3IgZGFlbW9uDQo+IA0KPiANCj4gT24gU2F0LCAyMDE4LTA3LTE0IGF0IDA4OjMzICswOTAw
LCBRSSBGdWxpIHdyb3RlOg0KPiA+IFRoaXMgaXMgdGhlIHYxMyBwYXRjaCBmb3IgbmRjdGwgbW9u
aXRvciwgYSB0aW55IGRhZW1vbiB0byBtb25pdG9yDQo+ID4gdGhlIHNtYXJ0IGV2ZW50cyBvZiBu
dmRpbW0gRElNTXMuIFNpbmNlIE5WRElNTSBkb2VzIG5vdCBoYXZlIGENCj4gPiBmZWF0dXJlIGxp
a2UgbWlycm9yaW5nLCBpZiBpdCBicmVha3MgZG93biwgdGhlIGRhdGEgd2lsbCBiZQ0KPiA+IGlt
cG9zc2libGUgdG8gcmVzdG9yZS4gTmRjdGwgbW9uaXRvciBkYWVtb24gd2lsbCBjYXRjaCB0aGUg
c21hcnQNCj4gPiBldmVudHMgbm90aWZ5IGZyb20gZmlybXdhcmUgYW5kIG91dHB1dHMgbm90aWZp
Y2F0aW9uIHRvIGxvZ2ZpbGUsDQo+ID4gdGhlcmVmb3JlIHVzZXJzIGNhbiByZXBsYWNlIE5WRElN
TSBiZWZvcmUgaXQgaXMgY29tcGxldGVseSBicm9rZW4uDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5
OiBRSSBGdWxpIDxxaS5mdWxpQGpwLmZ1aml0c3UuY29tPg0KPiANCj4gSGkgUWksDQo+IA0KPiBU
aGlzIGxvb2tzIGdyZWF0LCB0aGFuayB5b3UgZm9yIGFsbCB0aGUgdXBkYXRlcyENCj4gDQo+IEkg
aGF2ZSBhcHBsaWVkIHRoZSBzZXJpZXMgdG8gbXkgbG9jYWwgdHJlZSwgYW5kIGV4cGVjdCB0byBw
dXNoIGl0IG91dA0KPiB0byB0aGUgcGVuZGluZyBicmFuY2ggc29vbi4gSSB3aWxsIGFsc28gYWRk
IHJldmlld2VkLWJ5IHRhZ3MgZm9yIERhbg0KPiAod2l0aCBoaXMgcGVybWlzc2lvbikgc2luY2Ug
aGUgaGFzIGJlZW4gaW50ZWdyYWwgdG8gdGhlIHJldmlldyBvZiB0aGlzDQo+IHNlcmllcy4NCj4g
DQo+IEknbSBhbHNvIHNlcGFyYXRlbHkgc2VuZGluZyBvdXQgdGhlIGJhc2ggY29tcGxldGlvbiB1
cGRhdGVzIGZvciB0aGUNCj4gbW9uaXRvciBjb21tYW5kLg0KPiANCj4gVGhhbmsgeW91LA0KPiAN
Cj4gCS1WaXNoYWwNCg0KSGkgVmlzaGFsLA0KDQpUaGFuayB5b3UgdmVyeSBtdWNoIGZvciBhbGwg
Y29tbWVudHMgYW5kIGFkdmljZXMuDQpJIHdvdWxkIGFwcHJlY2lhdGUgeW91ciBjb250aW51ZWQg
c3VwcG9ydC4NCg0KUWkNCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9y
ZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
