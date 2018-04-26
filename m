Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm02.jp.fujitsu.com (mgwkm02.jp.fujitsu.com [202.219.69.169])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 288C8202E5EEC
 for <linux-nvdimm@lists.01.org>; Wed, 25 Apr 2018 17:25:11 -0700 (PDT)
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local
 (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
 by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 41604AC0238
 for <linux-nvdimm@lists.01.org>; Thu, 26 Apr 2018 09:25:07 +0900 (JST)
From: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Subject: RE: [PATCH] ndctl, filter: fix "keyword 'all' is ignored" in
 util_<obj>_filter()
Date: Thu, 26 Apr 2018 00:25:03 +0000
Message-ID: <0DEDF3B159719A448A49EF0E7B11E3222764F252@g01jpexmbkw01>
References: <20180425073843.19900-1-qi.fuli@jp.fujitsu.com>
 <CAPcyv4iEQdcH8CUfWbT03s90MDDkMcyrA93cQRogW7X_4yY=pw@mail.gmail.com>
In-Reply-To: <CAPcyv4iEQdcH8CUfWbT03s90MDDkMcyrA93cQRogW7X_4yY=pw@mail.gmail.com>
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
YWlsdG86ZGFuLmoud2lsbGlhbXNAaW50ZWwuY29tXQ0KPiBTZW50OiBXZWRuZXNkYXksIEFwcmls
IDI1LCAyMDE4IDExOjExIFBNDQo+IFRvOiBRaSwgRnVsaS/mlokg56aP5YipIDxxaS5mdWxpQGpw
LmZ1aml0c3UuY29tPg0KPiBDYzogbGludXgtbnZkaW1tIDxsaW51eC1udmRpbW1AbGlzdHMuMDEu
b3JnPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIXSBuZGN0bCwgZmlsdGVyOiBmaXggImtleXdvcmQg
J2FsbCcgaXMgaWdub3JlZCIgaW4gdXRpbF88b2JqPl9maWx0ZXIoKQ0KPiANCj4gT24gV2VkLCBB
cHIgMjUsIDIwMTggYXQgMTI6MzggQU0sIFFJIEZ1bGkgPHFpLmZ1bGlAanAuZnVqaXRzdS5jb20+
IHdyb3RlOg0KPiA+IFRoaXMgaXMgYSBmb2xsb3cgdXAgcGF0Y2ggZm9yIGNvbW1pdCBjNzBhZGMz
Y2Y2YmYgKCJuZGN0bCwgZmlsdGVyOg0KPiA+IHJlZmFjdG9yDQo+ID4gdXRpbF88b2JqPl9maWx0
ZXIoKSB0byBzdXBwb3J0IG11bHRpcGxlIHNwYWNlLXNlcGVyYXRlZCBhcmd1bWVudHMiKQ0KPiA+
IHJlZmFjdG9yZWQgdXRpbF88b2JqPl9maWx0ZXIoKSB0byBzdXBwb3J0IG11bHRpcGxlIHNwYWNl
LXNlcGVyYXRlZCBhcmd1bWVudHMuDQo+ID4gQnV0LCB3aGVuIHRoZSBrZXl3b3JkICJhbGwiIGlz
IGluY2x1ZGVkIGluIHNwYWNlLXNlcGVyYXRlZCBhcmd1bWVudHMsDQo+ID4gaXQgd2lsbCBiZSB0
cmVhZGVkIGFzIDxvYmplY3Q+J3MgbmFtZS4gVGhpcyBwYXRjaCBmaXhlcyBpdC4NCj4gPg0KPiA+
IFNpZ25lZC1vZmYtYnk6IFFJIEZ1bGkgPHFpLmZ1bGlAanAuZnVqaXRzdS5jb20+DQo+ID4gLS0t
DQo+ID4gIHV0aWwvZmlsdGVyLmMgfCAxMiArKysrKysrKysrKysNCj4gPiAgMSBmaWxlIGNoYW5n
ZWQsIDEyIGluc2VydGlvbnMoKykNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS91dGlsL2ZpbHRlci5j
IGIvdXRpbC9maWx0ZXIuYyBpbmRleCAwZDNjYzAyLi45MDgxYTZkDQo+ID4gMTAwNjQ0DQo+ID4g
LS0tIGEvdXRpbC9maWx0ZXIuYw0KPiA+ICsrKyBiL3V0aWwvZmlsdGVyLmMNCj4gPiBAQCAtNDAs
NiArNDAsOSBAQCBzdHJ1Y3QgbmRjdGxfYnVzICp1dGlsX2J1c19maWx0ZXIoc3RydWN0IG5kY3Rs
X2J1cw0KPiA+ICpidXMsIGNvbnN0IGNoYXIgKl9faWRlbnQpDQo+ID4NCj4gPiAgICAgICAgIGZv
ciAobmFtZSA9IHN0cnRva19yKGlkZW50LCAiICIsICZzYXZlKTsgbmFtZTsNCj4gPiAgICAgICAg
ICAgICAgICAgICAgICAgICBuYW1lID0gc3RydG9rX3IoTlVMTCwgIiAiLCAmc2F2ZSkpIHsNCj4g
PiArICAgICAgICAgICAgICAgaWYgKHN0cmNtcChpZGVudCwgImFsbCIpID09IDApDQo+ID4gKyAg
ICAgICAgICAgICAgICAgICAgICAgYnJlYWs7DQo+ID4gKw0KPiANCj4gTGV0J3MgYWxzbyByZW1v
dmUgdGhlIHN0cmNtcChfX2lkZW50LCAiYWxsIikgYXQgdGhlIHRvcCBvZiBlYWNoIG9mIHRoZXNl
IHJvdXRpbmVzIHRvDQo+IGtlZXAgdGhlIGNoZWNrIGZvciAiYWxsIiBjZW50cmFsaXplZC4NCj4g
DQpPSywgVGhhbmsgeW91IQ0KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEu
b3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
