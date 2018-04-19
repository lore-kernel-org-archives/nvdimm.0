Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm03.jp.fujitsu.com (mgwkm03.jp.fujitsu.com [202.219.69.170])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8F57922684797
 for <linux-nvdimm@lists.01.org>; Wed, 18 Apr 2018 19:19:02 -0700 (PDT)
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local
 (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
 by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 54EDDAC00AC
 for <linux-nvdimm@lists.01.org>; Thu, 19 Apr 2018 11:18:56 +0900 (JST)
From: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Subject: RE: [PATCH 1/2] ndctl, util: add OPT_STRING_LIST to parse_option
Date: Thu, 19 Apr 2018 02:18:54 +0000
Message-ID: <0DEDF3B159719A448A49EF0E7B11E3222764E285@g01jpexmbkw01>
References: <20180417063848.5585-1-qi.fuli@jp.fujitsu.com>
 <20180417063848.5585-2-qi.fuli@jp.fujitsu.com>
 <CAPcyv4g16niVJ+X73nSB9vHn3kNdc_X3ydZ1wy22AwVEp-1Rdw@mail.gmail.com>
 <0DEDF3B159719A448A49EF0E7B11E3222764DF5B@g01jpexmbkw01>
 <CAPcyv4hc5OYNSJT2PpsCH-QcjtBFkMoc-D3TKvAL5UyB9ZZYHQ@mail.gmail.com>
 <0DEDF3B159719A448A49EF0E7B11E3222764E0C7@g01jpexmbkw01>
 <CAPcyv4iZUv-q1SVhqmtsNRgCBj=C3rZqjmMEGZjNbc1xVhvCaQ@mail.gmail.com>
 <0DEDF3B159719A448A49EF0E7B11E3222764E251@g01jpexmbkw01>
 <CAPcyv4j4mirvPkfjiM94P+X+tNpw5LuEUt-7brcOSk8tzd_vcQ@mail.gmail.com>
In-Reply-To: <CAPcyv4j4mirvPkfjiM94P+X+tNpw5LuEUt-7brcOSk8tzd_vcQ@mail.gmail.com>
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

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBEYW4gV2lsbGlhbXMgW21haWx0
bzpkYW4uai53aWxsaWFtc0BpbnRlbC5jb21dDQo+IFNlbnQ6IFRodXJzZGF5LCBBcHJpbCAxOSwg
MjAxOCAxMToxMCBBTQ0KPiBUbzogUWksIEZ1bGkv5paJIOemj+WIqSA8cWkuZnVsaUBqcC5mdWpp
dHN1LmNvbT4NCj4gQ2M6IGxpbnV4LW52ZGltbSA8bGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZz4N
Cj4gU3ViamVjdDogUmU6IFtQQVRDSCAxLzJdIG5kY3RsLCB1dGlsOiBhZGQgT1BUX1NUUklOR19M
SVNUIHRvIHBhcnNlX29wdGlvbg0KPiANCj4gT24gV2VkLCBBcHIgMTgsIDIwMTggYXQgNzowNiBQ
TSwgUWksIEZ1bGkgPHFpLmZ1bGlAanAuZnVqaXRzdS5jb20+IHdyb3RlOg0KPiA+PiA+IFRoYW5r
IHlvdSB2ZXJ5IG11Y2gsIEkgbWFkZSBhIHYyIHBhdGNoIGJ5IHJlZmVycmluZyB0byB5b3VyIHNh
bXBsZSBwYXRjaC4NCj4gPj4gPg0KPiA+PiA+IEdvaW5nIGJhY2sgdG8gdGhlIE9QVF9TVFJJTkdf
TElTVCwgSSB0aGluayBpdCBpcyBuZWNlc3NhcnkgZm9yIG5kY3RsLg0KPiA+PiA+IEJlY2F1c2Ug
dGhlIG90aGVyIG9wdGlvbnMgaW4gbW9uaXRvciBsaWtlIC0tZGltbS1ldmVudCwgLS1idXMtZXZl
bnQNCj4gPj4gPiBhbHNvIG5lZWQgdG8gc3VwcG9ydCBtdWx0aXBsZSBzcGFjZS1zZXBhcmF0ZWQg
YXJndW1lbnRzLCB0aGVzZSBvcHRpb25zDQo+ID4+ID4gc2hvdWxkIGJlIG1hZGUgYXMgYSBzdHJp
bmdfbGlzdC4NCj4gPj4NCj4gPj4gT2ssIHllcywgbGV0cyBicmluZyBpbiBzdHJpbmdfbGlzdCBm
b3IgdGhhdCBjYXNlLg0KPiA+Pg0KPiA+DQo+ID4gQ291bGQgeW91IG1lcmdlIHRoZSBPUFRfU1RS
SU5HX0xJU1QgZmlyc3Q/DQo+IA0KPiBPaCwgSSB3YXMgYXNzdW1pbmcgd2hlbiB5b3Ugc2FpZCBz
dHJpbmdfbGlzdCB0aGF0IHlvdSB3b3VsZCByZWRvIHRoZQ0KPiBwYXRjaCB0byBicmluZyBpbiB0
aGUgc3RydWN0IHN0cmluZ19saXN0IGltcGxlbWVudGF0aW9uIGZyb20gZ2l0LCBhbmQNCj4gbm90
IHVzZSB0aGUgc3RydG9rKCkgYXBwcm9hY2guIEknZCBsaWtlIHRvIG5vdCBkaXZlcmdlIGZyb20g
dGhhdA0KPiBpbXBsZW1lbnRhdGlvbi4NCj4gDQpPaywgSSBzZWUuIEkgd2lsbCByZWRvIHRoZSBw
YXRjaCB0byBicmluZyBpbiB0aGUgc3RydWN0IHN0cmluZ19saXN0IGZyb20gZ2l0Lg0KVGhhbmsg
eW91Lg0KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGlu
dXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8v
bGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
