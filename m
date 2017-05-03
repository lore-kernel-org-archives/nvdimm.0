Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5009.houston.hpe.com (g9t5009.houston.hpe.com [15.241.48.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 66FF321A13493
 for <linux-nvdimm@lists.01.org>; Wed,  3 May 2017 16:25:42 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [RFC PATCH] dax: add badblocks check to Device DAX
Date: Wed, 3 May 2017 23:25:38 +0000
Message-ID: <1493853934.30303.51.camel@hpe.com>
References: <20170503153103.30756-1-toshi.kani@hpe.com>
 <CAPcyv4hu9iW-EEaggOj4ax_P6=Y28adi5Hb7Rp1Q1xBTWenJuQ@mail.gmail.com>
 <1493827750.30303.44.camel@hpe.com>
 <CAPcyv4gthc8Gc7SUyxqecDrd+dtOfOzY19bs5sY1qMepQKh=kQ@mail.gmail.com>
 <1493837209.30303.47.camel@hpe.com>
 <CAPcyv4ifW-tpo=WzhL8W4pxfv6XWw=QSxCApXtcXnhbK3Nf6YQ@mail.gmail.com>
 <1493851282.30303.49.camel@hpe.com>
 <CAPcyv4hj3Ynm06LTJwDYKTWmWSnvjUgVQSWpVWMXQCU+tUj0fQ@mail.gmail.com>
 <CAPcyv4g4-H76AMYv2TUtwmFZSc_p58UeiqVmKpJJbOY3g26FwA@mail.gmail.com>
In-Reply-To: <CAPcyv4g4-H76AMYv2TUtwmFZSc_p58UeiqVmKpJJbOY3g26FwA@mail.gmail.com>
Content-Language: en-US
Content-ID: <47247DBBE082184CB7A91395628534BC@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gV2VkLCAyMDE3LTA1LTAzIGF0IDE2OjA4IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIFdlZCwgTWF5IDMsIDIwMTcgYXQgMzo1MSBQTSwgRGFuIFdpbGxpYW1zIDxkYW4uai53aWxs
aWFtc0BpbnRlbC5jbw0KPiBtPiB3cm90ZToNCj4gPiBPbiBXZWQsIE1heSAzLCAyMDE3IGF0IDM6
NDEgUE0sIEthbmksIFRvc2hpbWl0c3UgPHRvc2hpLmthbmlAaHBlLmNvDQo+ID4gbT4gd3JvdGU6
DQo+ID4gPiBPbiBXZWQsIDIwMTctMDUtMDMgYXQgMTQ6NDggLTA3MDAsIERhbiBXaWxsaWFtcyB3
cm90ZToNCiA6DQo+ID4gDQo+ID4gSSBiZWxpZXZlIHdlIGFscmVhZHkgaGF2ZSBhbGwgdGhlIGRh
dGEgbmVlZGVkIHRvIGNhbGN1bGF0ZSB0aGUgZGF0YQ0KPiA+IG9mZnNldC4gR2l2ZW4gdGhlIGZv
bGxvd2luZyBzeXNmcyBwYXRoOg0KPiA+IA0KPiA+IMKgwqDCoMKgL3N5cy9kZXZpY2VzL0xOWFNZ
U1RNOjAwL0xOWFNZQlVTOjAwL0FDUEkwMDEyOjAwL25kYnVzMC9yZWdpb24xDQo+ID4gL2RheDEu
MS9kYXgvZGF4MS4wDQo+ID4gDQo+ID4gLi4ud2UgY2FuIGZpbmQgdGhlIGFzc29jaWF0ZWQgbmFt
ZXNwYWNlIGRldmljZSBmcm9tIHRoYXQgZGF4MS4xLg0KPiA+IEZyb20NCj4gPiB0aGVyZSB3ZSBo
YXZlIHRoZSBiYXNlIGFkZHJlc3Mgb2YgdGhlIG5hbWVzcGFjZSBhbmQgdGhlIHNpemUNCj4gPiBk
ZXZpY2UtZGF4IGluc3RhbmNlLg0KPiA+IA0KPiA+IMKgwqDCoMKgZGV2aWNlX2RheF9kYXRhX29m
ZnNldCA9PSBuYW1lc3BhY2VfYmFzZSArIG5hbWVzcGFjZV9zaXplIC0NCj4gPiBkZXZpY2VfZGF4
X3NpemUNCj4gDQo+IERhdmUgcmVtaW5kcyBtZSB0aGF0IHdlIGRvIGhhdmUgdGhlIGRhdGEgb2Zm
c2V0IG9mIHRoZSBkZXZpY2UtZGF4DQo+IGluc3RhbmNlIGF0IHRoZSBsaWJudmRpbW0gbGV2ZWw6
DQo+IA0KPiDCoMKgwqDCoC9zeXMvZGV2aWNlcy9MTlhTWVNUTTowMC9MTlhTWUJVUzowMC9BQ1BJ
MDAxMjowMC9uZGJ1czAvcmVnaW9uMS9kDQo+IGF4MS4xL3Jlc291cmNlDQo+IA0KPiAuLi5pbiB0
aGlzIGV4YW1wbGUsIHdoaWNoIG1hcHMgdG8gbmRjdGxfZGF4X2dldF9yZXNvdXJjZSgpLg0KDQpU
aGFua3MgZm9yIHRoZSBpbmZvISAgSSBub3RpY2VkIHdoeSBJIGRpZCBub3QgY2F0Y2ggdGhpcyBp
bmZvIGJlZm9yZS4NCg0KIyBsbCAvZGV2L2RheCoNCmNydy0tLS0tLS0gMSByb290IHJvb3QgMjUx
LCAzIE1hecKgwqAzIDA0OjI4IC9kZXYvZGF4MC4wDQoNCiMgcHdkDQovc3lzL2RldmljZXMvTE5Y
U1lTVE06MDAvTE5YU1lCVVM6MDAvQUNQSTAwMTI6MDAvbmRidXMwL3JlZ2lvbjAvZGF4MC4wDQoN
CiMgZ3JlcCAuICoNCmFsaWduOjIwOTcxNTINCmRldnR5cGU6bmRfZGF4DQptb2RhbGlhczpuZDp0
Nw0KbW9kZTpub25lDQpudW1hX25vZGU6MA0KZ3JlcDogcG93ZXI6IElzIGEgZGlyZWN0b3J5DQpn
cmVwOiByZXNvdXJjZTogTm8gc3VjaCBkZXZpY2Ugb3IgYWRkcmVzcw0KZ3JlcDogc2l6ZTogTm8g
c3VjaCBkZXZpY2Ugb3IgYWRkcmVzcw0KZ3JlcDogc3Vic3lzdGVtOiBJcyBhIGRpcmVjdG9yeQ0K
dWV2ZW50OkRFVlRZUEU9bmRfZGF4DQp1ZXZlbnQ6TU9EQUxJQVM9bmQ6dDcNCg0KQnV0IEkgbm90
aWNlZCB0aGF0ICJyZXNvdXJjZSIgYW5kICJzaXplIiB0aGF0IGFyZSB1bmRlcg0KIi4uLi9yZWdp
b24wL2RheDAuMSIgd29yay4gIElzIHRoaXMgaW50ZW5kZWQ/DQoNCi1Ub3NoaQ0KDQpfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFp
bGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcv
bWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
