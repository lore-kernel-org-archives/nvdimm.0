Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm02.jp.fujitsu.com (mgwkm02.jp.fujitsu.com [202.219.69.169])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 63A64202E53E2
 for <linux-nvdimm@lists.01.org>; Mon,  2 Jul 2018 00:05:42 -0700 (PDT)
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local
 (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
 by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 8ED1EAC0084
 for <linux-nvdimm@lists.01.org>; Mon,  2 Jul 2018 16:05:38 +0900 (JST)
From: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Subject: RE: Question about ndctl unit tests
Date: Mon, 2 Jul 2018 07:05:36 +0000
Message-ID: <0DEDF3B159719A448A49EF0E7B11E3223D0B9B35@g01jpexmbkw01>
References: <0DEDF3B159719A448A49EF0E7B11E32237E966C2@g01jpexmbkw01>
 <CAPcyv4h7c8JU8=-H=ebWkA9Nww+gDOzptve9w42Os15yPC-YsQ@mail.gmail.com>
In-Reply-To: <CAPcyv4h7c8JU8=-H=ebWkA9Nww+gDOzptve9w42Os15yPC-YsQ@mail.gmail.com>
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
To: 'Dan Williams' <dan.j.williams@intel.com>
Cc: "Mizuma, Masayoshi" <m.mizuma@jp.fujitsu.com>, "Gotou, Yasunori  <y-goto@jp.fujitsu.com>, linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBEYW4gV2lsbGlhbXMgW21haWx0
bzpkYW4uai53aWxsaWFtc0BpbnRlbC5jb21dDQo+IFNlbnQ6IFN1bmRheSwgSnVseSAxLCAyMDE4
IDM6MTIgQU0NCj4gVG86IFFpLCBGdWxpL+aWiSDnpo/liKkgPHFpLmZ1bGlAanAuZnVqaXRzdS5j
b20+DQo+IENjOiBsaW51eC1udmRpbW1AbGlzdHMuMDEub3JnOyBWZXJtYSwgVmlzaGFsIEwgPHZp
c2hhbC5sLnZlcm1hQGludGVsLmNvbT47IE1penVtYSwNCj4gTWFzYXlvc2hpL+awtOmWkyDnkIbk
u4EgPG0ubWl6dW1hQGpwLmZ1aml0c3UuY29tPjsgR290b3UsIFlhc3Vub3JpL+S6lOWztiDlurfm
locNCj4gPHktZ290b0BqcC5mdWppdHN1LmNvbT4NCj4gU3ViamVjdDogUmU6IFF1ZXN0aW9uIGFi
b3V0IG5kY3RsIHVuaXQgdGVzdHMNCj4gDQo+IE9uIFNhdCwgSnVuIDMwLCAyMDE4IGF0IDE6MDcg
QU0sIFFpLCBGdWxpIDxxaS5mdWxpQGpwLmZ1aml0c3UuY29tPiB3cm90ZToNCj4gPiBIaSwNCj4g
Pg0KPiA+DQo+ID4NCj4gPiBXaGVuIEkgcmFuIHRoZSB1bml0IHRlc3RzLCBJIGZvdW5kICJsaWJu
ZGN0bCIgYW5kICJkc20tZmFpbCIgY2Fubm90DQo+ID4gcGFzcyB0aGUgdGVzdC4NCj4gDQo+IFll
cywgc29ycnksIHdlIHJlY2VudGx5IHJld29ya2VkIHNvbWUgdGVzdHMuIEdyYWIgb3VyIHdvcmst
aW4tcHJvZ3Jlc3Mga2VybmVsIGJyYW5jaA0KPiBoZXJlOg0KPiANCj4gICAgIGdpdDovL2dpdC5r
ZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9kamJ3L252ZGltbS5naXQNCj4gbGli
bnZkaW1tLXBlbmRpbmcNCj4gDQo+IFRoaXMgd2lsbCBtb3ZlIHRvIG52ZGltbS9udmRpbW0uZ2l0
IGxpYm52ZGltbS1mb3ItbmV4dCBpbiB0aGUgY29taW5nIHdlZWtzIGZvciA0LjE5Lg0KPiANCj4g
WW91J2xsIGFsc28gd2FudCB0byBncmFiOg0KPiANCj4gICAgIGh0dHBzOi8vcGF0Y2h3b3JrLmtl
cm5lbC5vcmcvcGF0Y2gvMTA0OTUyOTcvDQo+IA0KPiAuLi5mb3IgdGhlIGVycm9yIGhhbmRsaW5n
IHRlc3RzLiBUaGlzIHdpbGwgYXBwZWFyIG9uIGdpdGh1Yi5jb20vcG1lbS9uZGN0bCBtYXN0ZXIN
Cj4gc29vbi4NCg0KT0ssIEkgc2VlLg0KVGhhbmsgeW91IHZlcnkgbXVjaC4NClFpDQpfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFp
bGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcv
bWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
