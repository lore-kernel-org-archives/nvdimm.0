Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM02-BL2-obe.outbound.protection.outlook.com
 (mail-eopbgr750079.outbound.protection.outlook.com [40.107.75.79])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EA1B9212AAB9F
 for <linux-nvdimm@lists.01.org>; Tue,  2 Jul 2019 14:44:02 -0700 (PDT)
From: "Kuehling, Felix" <Felix.Kuehling@amd.com>
Subject: Re: [PATCH 19/22] mm: always return EBUSY for invalid ranges in
 hmm_range_{fault,snapshot}
Date: Tue, 2 Jul 2019 21:43:58 +0000
Message-ID: <fedf75d4-4ce2-e0cc-3c77-73ba31bed653@amd.com>
References: <20190701062020.19239-1-hch@lst.de>
 <20190701062020.19239-20-hch@lst.de>
In-Reply-To: <20190701062020.19239-20-hch@lst.de>
Content-Language: en-US
Content-ID: <30B65ABE32E43E43B44DF7426B589C07@namprd12.prod.outlook.com>
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
To: Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, =?utf-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Ben Skeggs <bskeggs@redhat.com>, "Yang, Philip" <Philip.Yang@amd.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gMjAxOS0wNy0wMSAyOjIwIGEubS4sIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOg0KPiBXZSBz
aG91bGQgbm90IGhhdmUgdHdvIGRpZmZlcmVudCBlcnJvciBjb2RlcyBmb3IgdGhlIHNhbWUgY29u
ZGl0aW9uLiAgSW4NCj4gYWRkaXRpb24gdGhpcyByZWFsbHkgY29tcGxpY2F0ZXMgdGhlIGNvZGUg
ZHVlIHRvIHRoZSBzcGVjaWFsIGhhbmRsaW5nIG9mDQo+IEVBR0FJTiB0aGF0IGRyb3BzIHRoZSBt
bWFwX3NlbSBkdWUgdG8gdGhlIEZBVUxUX0ZMQUdfQUxMT1dfUkVUUlkgbG9naWMNCj4gaW4gdGhl
IGNvcmUgdm0uDQoNCkkgdGhpbmsgdGhlIGNvbW1lbnQgYWJvdmUgaG1tX3JhbmdlX3NuYXBzaG90
IG5lZWRzIGFuIHVwZGF0ZS4gQWxzbyANCkRvY3VtZW50YXRpb24vdm0vaG1tLnJzdCBzaG93cyBz
b21lIGV4YW1wbGUgY29kZSB1c2luZyANCmhtbV9yYW5nZV9zbmFwc2hvdCB0aGF0IHJldHJpZXMg
b24gLUVBR0FJTi4gVGhhdCB3b3VsZCBuZWVkIHRvIGJlIA0KdXBkYXRlZCB0byB1c2UgLUVCVVNZ
IG9yIHJlbW92ZSB0aGUgcmV0cnkgbG9naWMgYWx0b2dldGhlci4NCg0KT3RoZXIgdGhhbiB0aGF0
LCB0aGlzIHBhdGNoIGlzIFJldmlld2VkLWJ5OiBGZWxpeCBLdWVobGluZyANCjxGZWxpeC5LdWVo
bGluZ0BhbWQuY29tPg0KDQpQaGlsaXAsIHRoaXMgbWVhbnMgd2Ugc2hvdWxkIHJlbW92ZSBvdXIg
cmV0cnkgbG9naWMgYWdhaW4gaW4gDQphbWRncHVfdHRtX3R0X2dldF91c2VyX3BhZ2VzLiBBY2Nv
cmRpbmcgdG8gdGhlIGNvbW1lbnQgYWJvdmUgDQpobW1fcmFuZ2VfZmF1bHQsIGl0IGNhbiBvbmx5
IHJldHVybiAtRUFHQUlOIGlmIHRoZSBibG9jayBwYXJhbWV0ZXIgaXMgDQpmYWxzZS4gSSB0aGlu
ayB0aGlzIHN0YXRlbWVudCBpcyBub3cgYWN0dWFsbHkgdHJ1ZS4gV2Ugc2V0IGJsb2NrPXRydWUs
IA0Kc28gd2UgY2FuJ3QgZ2V0IC1FQUdBSU4uIE9uIC1FQlVTWSB3ZSBjYW4gbGV0IA0KYW1kZ3B1
X2FtZGtmZF9yZXN0b3JlX3VzZXJwdHJfd29ya2VyIHNjaGVkdWxlIHRoZSByZXRyeSAod2hpY2gg
aXQgZG9lcyANCmFscmVhZHkgYW55d2F5KS4NCg0KUmVnYXJkcywNCiDCoCBGZWxpeA0KDQoNCj4N
Cj4gU2lnbmVkLW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+DQo+IC0tLQ0K
PiAgIG1tL2htbS5jIHwgOCArKystLS0tLQ0KPiAgIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlv
bnMoKyksIDUgZGVsZXRpb25zKC0pDQo+DQo+IGRpZmYgLS1naXQgYS9tbS9obW0uYyBiL21tL2ht
bS5jDQo+IGluZGV4IGM4NWVkN2Q0ZTJjZS4uZDEyNWRmNjk4ZTJiIDEwMDY0NA0KPiAtLS0gYS9t
bS9obW0uYw0KPiArKysgYi9tbS9obW0uYw0KPiBAQCAtOTc0LDcgKzk3NCw3IEBAIGxvbmcgaG1t
X3JhbmdlX3NuYXBzaG90KHN0cnVjdCBobW1fcmFuZ2UgKnJhbmdlKQ0KPiAgIAlkbyB7DQo+ICAg
CQkvKiBJZiByYW5nZSBpcyBubyBsb25nZXIgdmFsaWQgZm9yY2UgcmV0cnkuICovDQo+ICAgCQlp
ZiAoIXJhbmdlLT52YWxpZCkNCj4gLQkJCXJldHVybiAtRUFHQUlOOw0KPiArCQkJcmV0dXJuIC1F
QlVTWTsNCj4gICANCj4gICAJCXZtYSA9IGZpbmRfdm1hKGhtbS0+bW0sIHN0YXJ0KTsNCj4gICAJ
CWlmICh2bWEgPT0gTlVMTCB8fCAodm1hLT52bV9mbGFncyAmIGRldmljZV92bWEpKQ0KPiBAQCAt
MTA2OSwxMCArMTA2OSw4IEBAIGxvbmcgaG1tX3JhbmdlX2ZhdWx0KHN0cnVjdCBobW1fcmFuZ2Ug
KnJhbmdlLCBib29sIGJsb2NrKQ0KPiAgIA0KPiAgIAlkbyB7DQo+ICAgCQkvKiBJZiByYW5nZSBp
cyBubyBsb25nZXIgdmFsaWQgZm9yY2UgcmV0cnkuICovDQo+IC0JCWlmICghcmFuZ2UtPnZhbGlk
KSB7DQo+IC0JCQl1cF9yZWFkKCZobW0tPm1tLT5tbWFwX3NlbSk7DQo+IC0JCQlyZXR1cm4gLUVB
R0FJTjsNCj4gLQkJfQ0KPiArCQlpZiAoIXJhbmdlLT52YWxpZCkNCj4gKwkJCXJldHVybiAtRUJV
U1k7DQo+ICAgDQo+ICAgCQl2bWEgPSBmaW5kX3ZtYShobW0tPm1tLCBzdGFydCk7DQo+ICAgCQlp
ZiAodm1hID09IE5VTEwgfHwgKHZtYS0+dm1fZmxhZ3MgJiBkZXZpY2Vfdm1hKSkNCl9fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWls
aW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9t
YWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
