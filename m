Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym02.jp.fujitsu.com (mgwym02.jp.fujitsu.com [211.128.242.41])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DA6DC21F2E0F2
 for <linux-nvdimm@lists.01.org>; Wed, 18 Apr 2018 19:10:34 -0700 (PDT)
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local
 (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
 by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 69968AC00A5
 for <linux-nvdimm@lists.01.org>; Thu, 19 Apr 2018 11:10:07 +0900 (JST)
From: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Subject: RE: [PATCH v2] ndctl, filter: refacor util_<obj>_filter() to
 support multiple space-seperated arguments
Date: Thu, 19 Apr 2018 02:10:05 +0000
Message-ID: <0DEDF3B159719A448A49EF0E7B11E3222764E26B@g01jpexmbkw01>
References: <20180418063242.9221-1-qi.fuli@jp.fujitsu.com>
 <CAPcyv4gb0JVRtW8QQy_TkJyZmpteGveOgzAPt66Otx0sftyrHw@mail.gmail.com>
 <1524067583.6010.7.camel@intel.com>
In-Reply-To: <1524067583.6010.7.camel@intel.com>
Content-Language: ja-JP
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

PiBGcm9tOiBWZXJtYSwgVmlzaGFsIEwgW21haWx0bzp2aXNoYWwubC52ZXJtYUBpbnRlbC5jb21d
DQo+IFNlbnQ6IFRodXJzZGF5LCBBcHJpbCAxOSwgMjAxOCAxOjA2IEFNDQo+IFRvOiBXaWxsaWFt
cywgRGFuIEogPGRhbi5qLndpbGxpYW1zQGludGVsLmNvbT47IFFpLCBGdWxpL+aWiSDnpo/liKkN
Cj4gPHFpLmZ1bGlAanAuZnVqaXRzdS5jb20+DQo+IENjOiBsaW51eC1udmRpbW1AbGlzdHMuMDEu
b3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjJdIG5kY3RsLCBmaWx0ZXI6IHJlZmFjb3IgdXRp
bF88b2JqPl9maWx0ZXIoKSB0byBzdXBwb3J0IG11bHRpcGxlDQo+IHNwYWNlLXNlcGVyYXRlZCBh
cmd1bWVudHMNCj4gDQo+IE9uIFdlZCwgMjAxOC0wNC0xOCBhdCAwNzozMSAtMDcwMCwgRGFuIFdp
bGxpYW1zIHdyb3RlOg0KPiA+IE9uIFR1ZSwgQXByIDE3LCAyMDE4IGF0IDExOjMyIFBNLCBRSSBG
dWxpIDxxaS5mdWxpQGpwLmZ1aml0c3UuY29tPiB3cm90ZToNCj4gPiA+IFRoaXMgcGF0Y2ggcmVm
YWN0b3JzIHV0aWxfPG9iaj5fZmlsdGVyIHRvIHN1cHBvcnQgbXVsdGlwbGUgc3BhY2UtDQo+ID4g
PiBzZXBlcmF0ZWQgYXJndW1lbnRzLiBDdXJyZW50bHksIG9ubHkgb25lIDxvYmplY3Q+IGNhbiBi
ZSBmaWx0ZXJlZCBieQ0KPiA+ID4gPG9iamVjdD4ncyBuYW1lIGluIHV0aWxfPG9iaj5fZmlsdGVy
KCkuIEFzIGEgcmVzdWx0LCB3aGVuIHVzZXJzIHdhbnQNCj4gPiA+IHRvIG1vbmlvdHIgbXVsdGlw
bGUgZGltbXMsIHRoZXkgaGF2ZSB0byBydW4gbXVsdGlwbGUgbW9uaXRvcg0KPiA+ID4gcHJvY2Vz
c2VzLiBUaGlzIGZlYXR1cmUgdGVhY2hzIHRoZQ0KPiA+ID4gdXRpbF9kaW1tX2ZpbHRlcigpIHRo
YXQgdGhlICJpZGVudCIgYXJndW1lbnQgbWF5YmUgYSBzcGFjZS1zZXBlcmF0ZA0KPiA+ID4gc3Ry
aW5nIHdoaWNoIGluY2x1ZGVzIG11bHRpcGxlIGRpbW1fbmFtZXMuIFRoZXJlZm9yZSB0aGUgbW9u
aXRvciBjYW4NCj4gPiA+IGZpbHRlciBtdWx0aXBsZSBkaW1tcyBpbiBvbmUgcHJvY2Vzcy4NCj4g
PiA+DQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBRSSBGdWxpIDxxaS5mdWxpQGpwLmZ1aml0c3UuY29t
Pg0KPiA+ID4gU2lnbmVkLW9mZi1ieTogRGFuIFdpbGxpYW1zIDxkYW4uai53aWxsaWFtc0BpbnRl
bC5jb20+DQo+IA0KPiBJJ2xsIGZpeCB1cCB0aGUgdGFncyBsaWtlIHNvOg0KPiANCj4gQmFzZWQt
b24tYS1wYXRjaC1ieTogRGFuIFdpbGxpYW1zIDxkYW4uai53aWxsaWFtc0BpbnRlbC5jb20+DQo+
IFJldmlld2VkLWJ5OiBEYW4gV2lsbGlhbXMgPGRhbi5qLndpbGxpYW1zQGludGVsLmNvbT4NCj4g
U2lnbmVkLW9mZi1ieTogUUkgRnVsaSA8cWkuZnVsaUBqcC5mdWppdHN1LmNvbT4NCj4gDQo+IA0K
PiBUaGFua3MsDQo+IAktVmlzaGFsDQo+IA0KPiA+ID4NCj4gPiA+IENoYW5nZSBsb2cgc2luY2Ug
djE6DQo+ID4gPiAgIC0gUmVtb3ZpbmcgT1BUX1NUUklOR19MSVNUIGZyb20gcGFyc2Utb3B0aW9u
DQo+ID4NCj4gPiBMb29rcyBnb29kOg0KPiA+DQo+ID4gUmV2aWV3ZWQtYnk6IERhbiBXaWxsaWFt
cyA8ZGFuLmoud2lsbGlhbXNAaW50ZWwuY29tPg0KDQpUaGFuayB5b3UgdmVyeSBtdWNoLg0KIC0g
UWkNCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4
LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xp
c3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
