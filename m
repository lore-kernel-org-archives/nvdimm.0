Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 (mail-eopbgr150082.outbound.protection.outlook.com [40.107.15.82])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B748220218C2D
 for <linux-nvdimm@lists.01.org>; Sun,  1 Sep 2019 23:23:50 -0700 (PDT)
From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH v3] libnvdimm: Enable unit test infrastructure compile
 checks
Date: Mon, 2 Sep 2019 06:22:23 +0000
Message-ID: <20190902062221.GK24116@mellanox.com>
References: <156727753022.2310789.16427613406082399871.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <156727753022.2310789.16427613406082399871.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
Content-ID: <634D885666AECA4FA4FA998A909DB5AF@eurprd05.prod.outlook.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, =?utf-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Christoph Hellwig <hch@lst.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gU2F0LCBBdWcgMzEsIDIwMTkgYXQgMTE6NTI6NDdBTSAtMDcwMCwgRGFuIFdpbGxpYW1zIHdy
b3RlOg0KPiBUaGUgaW5mcmFzdHJ1Y3R1cmUgdG8gbW9jayBjb3JlIGxpYm52ZGltbSByb3V0aW5l
cyBmb3IgdW5pdCB0ZXN0aW5nDQo+IHB1cnBvc2VzIGlzIHByb25lIHRvIGJpdHJvdCByZWxhdGl2
ZSB0byByZWZhY3RvcmluZyBvZiB0aGF0IGNvcmUuDQo+IEFycmFuZ2UgZm9yIHRoZSB1bml0IHRl
c3QgY29yZSB0byBiZSBidWlsdCB3aGVuIENPTkZJR19DT01QSUxFX1RFU1Q9eS4NCj4gVGhpcyBk
b2VzIG5vdCByZXN1bHQgaW4gYSBmdW5jdGlvbmFsIHVuaXQgdGVzdCBlbnZpcm9ubWVudCwgaXQg
aXMgb25seSBhDQo+IGhlbHBlciBmb3IgMGRheSB0byBjYXRjaCB1bml0IHRlc3QgYnVpbGQgcmVn
cmVzc2lvbnMuDQo+IA0KPiBOb3RlIHRoYXQgdGhlcmUgYXJlIGEgZmV3IHg4NmlzbXMgaW4gdGhl
IGltcGxlbWVudGF0aW9uLCBzbyB0aGlzIGRvZXMNCj4gbm90IGJvdGhlciBjb21waWxlIHRlc3Rp
bmcgdGhpcyBhcmNoaXRlY3R1cmVzIG90aGVyIHRoYW4gNjQtYml0IHg4Ni4NCj4gDQo+IENjOiBK
w6lyw7RtZSBHbGlzc2UgPGpnbGlzc2VAcmVkaGF0LmNvbT4NCj4gQ2M6IEphc29uIEd1bnRob3Jw
ZSA8amdnQG1lbGxhbm94LmNvbT4NCj4gUmVwb3J0ZWQtYnk6IENocmlzdG9waCBIZWxsd2lnIDxo
Y2hAbHN0LmRlPg0KPiBTaWduZWQtb2ZmLWJ5OiBEYW4gV2lsbGlhbXMgPGRhbi5qLndpbGxpYW1z
QGludGVsLmNvbT4NCj4gTGluazogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvci8xNTYwOTcyMjQy
MzIuMTA4Njg0Ny45NDYzODYxOTI0NjgzMzcyNzQxLnN0Z2l0QGR3aWxsaWEyLWRlc2szLmFtci5j
b3JwLmludGVsLmNvbQ0KPiBDaGFuZ2VzIHNpbmNlIHYyOg0KPiAtIEZpeGVkIGEgMGRheSByZXBv
cnQgd2hlbiB0aGUgdW5pdCB0ZXN0IGluZnJhc3RydWN0dXJlIGlzIGJ1aWx0LWluLg0KPiAgIEFy
cmFuZ2UgZm9yIGl0IHRvIG9ubHkgY29tcGlsZSBhcyBhIG1vZHVsZS4gVGhpcyBoYXMgcmVjZWl2
ZWQgYSBidWlsZA0KPiAgIHN1Y2Nlc3Mgbm90aWZjYXRpb24gZnJvbSB0aGUgcm9ib3Qgb3ZlciAx
NDIgY29uZmlncy4NCj4gDQo+IEhpIEphc29uLA0KPiANCj4gQXMgd2UgZGlzY3Vzc2VkIHByZXZp
b3VzbHkgcGxlYXNlIHRha2UgdGhpcyB0aHJvdWdoIHRoZSBobW0gdHJlZSB0byBnaXZlDQo+IGNv
bXBpbGUgY292ZXJhZ2UgZm9yIGRldm1fbWVtcmVtYXBfcGFnZXMoKSB1cGRhdGVzLg0KDQpPa2F5
LCBhcHBsaWVkIGFnYWluIGFuZCAwLWRheSBwYXNzZWQNCg0KVGhhbmtzLA0KSmFzb24NCl9fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBt
YWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9y
Zy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
