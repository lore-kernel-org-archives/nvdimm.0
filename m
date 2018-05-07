Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm01.jp.fujitsu.com (mgwkm01.jp.fujitsu.com [202.219.69.168])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DB87E20946094
 for <linux-nvdimm@lists.01.org>; Sun,  6 May 2018 18:51:04 -0700 (PDT)
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local
 (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
 by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id D9F91AC0068
 for <linux-nvdimm@lists.01.org>; Mon,  7 May 2018 10:50:56 +0900 (JST)
From: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Subject: RE: [PATCH v5 1/4] ndctl, util: add OPTION_FILENAME to parse_opt_type
Date: Mon, 7 May 2018 01:50:54 +0000
Message-ID: <0DEDF3B159719A448A49EF0E7B11E32227660437@g01jpexmbkw01>
References: <20180426113050.11424-1-qi.fuli@jp.fujitsu.com>
 <20180426113050.11424-2-qi.fuli@jp.fujitsu.com>
 <CAPcyv4jPkp9acqfs57b4rTQkDSy4a3hm=02WGQLOMnmgxBKWzg@mail.gmail.com>
In-Reply-To: <CAPcyv4jPkp9acqfs57b4rTQkDSy4a3hm=02WGQLOMnmgxBKWzg@mail.gmail.com>
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
To: 'Dan Williams' <dan.j.williams@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRGFuIFdpbGxpYW1zIFtt
YWlsdG86ZGFuLmoud2lsbGlhbXNAaW50ZWwuY29tXQ0KPiBTZW50OiBGcmlkYXksIE1heSA0LCAy
MDE4IDEyOjI2IFBNDQo+IFRvOiBRaSwgRnVsaS/mlokg56aP5YipIDxxaS5mdWxpQGpwLmZ1aml0
c3UuY29tPg0KPiBDYzogbGludXgtbnZkaW1tIDxsaW51eC1udmRpbW1AbGlzdHMuMDEub3JnPg0K
PiBTdWJqZWN0OiBSZTogW1BBVENIIHY1IDEvNF0gbmRjdGwsIHV0aWw6IGFkZCBPUFRJT05fRklM
RU5BTUUgdG8gcGFyc2Vfb3B0X3R5cGUNCj4gDQo+IE9uIFRodSwgQXByIDI2LCAyMDE4IGF0IDQ6
MzAgQU0sIFFJIEZ1bGkgPHFpLmZ1bGlAanAuZnVqaXRzdS5jb20+IHdyb3RlOg0KPiA+IFRoaXMg
cGF0Y2ggYm9ycm93cyB0aGUgT1BUSU9OX0ZJTEVOQU1FIGZyb20gZ2l0IHRvIG5kY3RsIHRvIG1h
a2Ugc3VyZQ0KPiA+IGZpbGVuYW1lIGlzIGNvcnJlY3QuIFNvbWUgcmVsYXRlZCByZWZhY3Rvcmlu
ZyBpcyBhbHNvIGluY2x1ZGVkOg0KPiA+ICAgLSBhZGRzIHBhcnNlX29wdGlvbnNfcHJlZml4KCkg
aW50ZXJmYWNlDQo+ID4gICAtIG1vdmVzIGlzX2Fic29sdXRlIGZyb20gdXRpbC9oZWxwLmMgdG8g
dXRpbC91dGlsLmMNCj4gPiAgIC0gYWRkcyBhIG5ldyBmaWxlIHV0aWwvYWJzcGF0aC5jDQo+ID4N
Cj4gPiBTaWduZWQtb2ZmLWJ5OiBRSSBGdWxpIDxxaS5mdWxpQGpwLmZ1aml0c3UuY29tPg0KPiA+
DQo+IFsuLl0NCj4gPiBkaWZmIC0tZ2l0IGEvdXRpbC9hYnNwYXRoLmMgYi91dGlsL2Fic3BhdGgu
YyBuZXcgZmlsZSBtb2RlIDEwMDY0NA0KPiA+IGluZGV4IDAwMDAwMDAuLmZkZjQwOTANCj4gPiAt
LS0gL2Rldi9udWxsDQo+ID4gKysrIGIvdXRpbC9hYnNwYXRoLmMNCj4gPiBAQCAtMCwwICsxLDI4
IEBADQo+ID4gKy8qIG9yaWdpbmFsbHkgY29waWVkIGZyb20gZ2l0ICovDQo+IA0KPiBMZXRzIHNh
eSB0aGUgc291cmNlIGZpbGUgbmFtZSB0aGF0IGl0IGNhbWUgZnJvbSBpbiBhbmQgZ2V0IGFuZCBh
ZGQgdGhlIGxpY2Vuc2UuDQo+IA0KPiAvKiBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIu
MCAqLw0KPiAvKiBvcmlnaW5hbGx5IGNvcGllZCBmcm9tIGdpdC9hYnNwYXRoLmMgKi8NCj4gDQo+
IE90aGVyd2lzZSwgdGhpcyBwYXRjaCBsb29rcyBnb29kIHRvIG1lLg0KPiANClRoYW5rIHlvdSBm
b3IgeW91ciBjb21tZW50Lg0KSSB3aWxsIG1ha2UgYSBuZXcgdmVyc2lvbiBhbmQgYWRkIHRoZSBs
aWNlbnNlLg0KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18K
TGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBz
Oi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
