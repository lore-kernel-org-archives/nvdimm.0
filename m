Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by ml01.01.org (Postfix) with ESMTP id 059E81A1E5E
 for <linux-nvdimm@lists.01.org>; Wed,  9 Mar 2016 15:05:19 -0800 (PST)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH 0/3] nfit, libnvdimm, pmem: clear poison support
Date: Wed, 9 Mar 2016 23:05:03 +0000
Message-ID: <1457564698.4525.33.camel@intel.com>
References: <20160308224713.16298.33547.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20160308224713.16298.33547.stgit@dwillia2-desk3.jf.intel.com>
Content-Language: en-US
Content-ID: <61A8C159E16CCA4189856919446AA353@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gVHVlLCAyMDE2LTAzLTA4IGF0IDE0OjQ3IC0wODAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IEFDUEkgNi4xIGludHJvZHVjZXMgdGhlIGFiaWxpdHkgdG8gc2VuZCAiY2xlYXIgZXJyb3IiIGNv
bW1hbmRzIHRvIHRoZQ0KPiBBQ1BJMDAxMjowMCBkZXZpY2UgcmVwcmVzZW50aW5nIHRoZSByb290
IG9mIGFuICJudmRpbW0gYnVzIi4NCj4gDQo+IFNpbWlsYXIgdG8gcmVsb2NhdGluZyBhIGJhZCBi
bG9jayBvbiBhIGRpc2ssIHRoaXMgc3VwcG9ydCBjbGVhcnMNCj4gbWVkaWEgZXJyb3JzIGluIHJl
c3BvbnNlIHRvIGEgd3JpdGUuDQo+IA0KPiAtLS0NCj4gDQo+IERhbiBXaWxsaWFtcyAoMyk6DQo+
IMKgwqDCoMKgwqDCoG5maXQsIGxpYm52ZGltbTogY2xlYXIgcG9pc29uIGNvbW1hbmQgc3VwcG9y
dA0KPiDCoMKgwqDCoMKgwqBsaWJudmRpbW0sIHBtZW06IGZpeCBrbWFwX2F0b21pYygpIGxlYWsg
aW4gZXJyb3IgcGF0aA0KPiDCoMKgwqDCoMKgwqBsaWJudmRpbW0sIHBtZW06IGNsZWFyIHBvaXNv
biBvbiB3cml0ZQ0KPiANCj4gDQo+IMKgYXJjaC94ODYvaW5jbHVkZS9hc20vcG1lbS5owqDCoMKg
wqDCoMKgfMKgwqDCoMKgNSArKysNCj4gwqBkcml2ZXJzL2FjcGkvbmZpdC5jwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoHzCoMKgwqAxMiArKysrKystDQo+IMKgZHJpdmVycy9udmRpbW0vYnVz
LmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHzCoMKgwqA2NQ0KPiArKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKw0KPiDCoGRyaXZlcnMvbnZkaW1tL25kLmjCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgfMKgwqDCoMKgMiArDQo+IMKgZHJpdmVycy9udmRpbW0vcG1lbS5j
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgfMKgwqDCoDQwICsrKysrKysrKysrKysrKysrKysrLS0t
DQo+IMKgaW5jbHVkZS9saW51eC9wbWVtLmjCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHzCoMKg
wqAxOSArKysrKysrKysrKw0KPiDCoGluY2x1ZGUvdWFwaS9saW51eC9uZGN0bC5owqDCoMKgwqDC
oMKgwqB8wqDCoMKgMTMgKysrKysrKysNCj4gwqB0b29scy90ZXN0aW5nL252ZGltbS90ZXN0L25m
aXQuYyB8wqDCoMKgMjkgKysrKysrKysrKysrKysrKysNCj4gwqA4IGZpbGVzIGNoYW5nZWQsIDE3
OSBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygtKQ0KDQpFeGNlcHQgZm9yIHRoZSBvbmUgY29t
bWVudCBpbiBwYXRjaCAxLCB0aGlzIGxvb2tzIGdvb2QgdG8gbWUhDQoNCkZvciB0aGUgc2VyaWVz
LA0KUmV2aWV3ZWQtYnk6IFZpc2hhbCBWZXJtYSA8dmlzaGFsLmwudmVybWFAaW50ZWwuY29tPgpf
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRp
bW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4w
MS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
