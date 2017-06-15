Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2353.austin.hpe.com (g2t2353.austin.hpe.com [15.233.44.26])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0F4F721A16ECB
 for <linux-nvdimm@lists.01.org>; Wed, 14 Jun 2017 17:45:02 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH v3 02/14] dm: add ->copy_from_iter() dax operation support
Date: Thu, 15 Jun 2017 00:46:14 +0000
Message-ID: <1497487541.9288.16.camel@hpe.com>
References: <149703982465.20620.14881139332926778446.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149703983692.20620.3787021839815275819.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149703983692.20620.3787021839815275819.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
Content-ID: <BA89C42A7198D3429DA9819BC01A07AA@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: "snitzer@redhat.com" <snitzer@redhat.com>, "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "hch@lst.de" <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

T24gRnJpLCAyMDE3LTA2LTA5IGF0IDEzOjIzIC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IEFsbG93IGRldmljZS1tYXBwZXIgdG8gcm91dGUgY29weV9mcm9tX2l0ZXIgb3BlcmF0aW9ucyB0
byB0aGUNCj4gcGVyLXRhcmdldCBpbXBsZW1lbnRhdGlvbi4gSW4gb3JkZXIgZm9yIHRoZSBkZXZp
Y2Ugc3RhY2tpbmcgdG8gd29yaw0KPiB3ZQ0KPiBuZWVkIGEgZGF4X2RldiBhbmQgYSBwZ29mZiBy
ZWxhdGl2ZSB0byB0aGF0IGRldmljZS4gVGhpcyBnaXZlcyBlYWNoDQo+IGxheWVyIG9mIHRoZSBz
dGFjayB0aGUgaW5mb3JtYXRpb24gaXQgbmVlZHMgdG8gbG9vayB1cCB0aGUgb3BlcmF0aW9uDQo+
IHBvaW50ZXIgZm9yIHRoZSBuZXh0IGxldmVsLg0KPiANCj4gVGhpcyBjb25jZXB0dWFsbHkgYWxs
b3dzIGZvciBhbiBhcnJheSBvZiBtaXhlZCBkZXZpY2UgZHJpdmVycyB3aXRoDQo+IHZhcnlpbmcg
Y29weV9mcm9tX2l0ZXIgaW1wbGVtZW50YXRpb25zLg0KPiANCj4gQ2M6IFRvc2hpIEthbmkgPHRv
c2hpLmthbmlAaHBlLmNvbT4NCj4gUmV2aWV3ZWQtYnk6IE1pa2UgU25pdHplciA8c25pdHplckBy
ZWRoYXQuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBEYW4gV2lsbGlhbXMgPGRhbi5qLndpbGxpYW1z
QGludGVsLmNvbT4NCg0KSSB3YXMgd29ycmllZCBhYm91dCBwb3NzaWJsZSBvdmVyaGVhZCB3aXRo
IGFkZGl0aW9uYWwgc3R1YiBjYWxscywgYnV0DQppdCBsb29rcyBmaW5lIHdpdGggYSBzaW5nbGUg
dGhyZWFkIGZpbyB3cml0ZSB0ZXN0IHdpdGggZGlyZWN0PTEuDQoNCsKgOTIuNjIlwqDCoFtrZXJu
ZWwua2FsbHN5bXNdwqDCoMKgW2tdIF9fY29weV91c2VyX25vY2FjaGUNCsKgIDAuMDQlwqDCoFtr
ZXJuZWwua2FsbHN5bXNdwqDCoMKgW2tdIGVudHJ5X1NZU0NBTExfNjRfZmFzdHBhdGgNCsKgIDAu
MDglwqDCoGxpYnB0aHJlYWQtMi4yMi5zb8KgwqBbLl0gX19HSV9fX2xpYmNfd3JpdGUNCsKgIDAu
MDElwqDCoFtrZXJuZWwua2FsbHN5bXNdwqDCoMKgW2tdIHN5c193cml0ZQ0KwqAgMC4wMiXCoMKg
W2tlcm5lbC5rYWxsc3ltc13CoMKgwqBba10gdmZzX3dyaXRlDQrCoCAwLjAyJcKgwqBba2VybmVs
LmthbGxzeW1zXcKgwqDCoFtrXSBfX3Zmc193cml0ZQ0KwqAgMC4wMiXCoMKgW2tlcm5lbC5rYWxs
c3ltc13CoMKgwqBba10gZXh0NF9maWxlX3dyaXRlX2l0ZXINCsKgIDAuMDIlwqDCoFtrZXJuZWwu
a2FsbHN5bXNdwqDCoMKgW2tdIGRheF9pb21hcF9ydw0KwqAgMC4wMyXCoMKgW2tlcm5lbC5rYWxs
c3ltc13CoMKgwqBba10gaW9tYXBfYXBwbHkNCsKgIDAuMDQlwqDCoFtrZXJuZWwua2FsbHN5bXNd
wqDCoMKgW2tdIGRheF9pb21hcF9hY3Rvcg0KwqAgMC4wMSXCoMKgW2tlcm5lbC5rYWxsc3ltc13C
oMKgwqBba10gZGF4X2NvcHlfZnJvbV9pdGVyDQrCoCAwLjAxJcKgwqBba2VybmVsLmthbGxzeW1z
XcKgwqDCoFtrXSBkbV9kYXhfY29weV9mcm9tX2l0ZXINCsKgIDAuMDElwqDCoFtrZXJuZWwua2Fs
bHN5bXNdwqDCoMKgW2tdIGxpbmVhcl9kYXhfY29weV9mcm9tX2l0ZXINCsKgIDAuMDMlwqDCoFtr
ZXJuZWwua2FsbHN5bXNdwqDCoMKgW2tdIGNvcHlfZnJvbV9pdGVyX2ZsdXNoY2FjaGUNCsKgIDAu
MDAlwqDCoFtrZXJuZWwua2FsbHN5bXNdwqDCoMKgW2tdIHBtZW1fY29weV9mcm9tX2l0ZXINCg0K
TXVsdGktdGhyZWFkIGZpbyB0ZXN0IGhpdHMgaGFyZCBpbiBpbm9kZV9sb2NrKCksIG5vIGNvbnRl
bnRpb24gZnJvbSB0aGUNCmRtLWxheWVyLg0KDQpSZXZpZXdlZC1ieTogVG9zaGkgS2FuaSA8dG9z
aGkua2FuaUBocGUuY29tPg0KDQpUaGFua3MsDQotVG9zaGkNCg0KDQoNCg0KDQpfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGlu
ZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFp
bG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
