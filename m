Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2354.austin.hpe.com (g2t2354.austin.hpe.com [15.233.44.27])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D2C982195406C
 for <linux-nvdimm@lists.01.org>; Thu, 27 Apr 2017 15:25:09 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH] libnvdimm, pmem: fix badblocks notification crash
Date: Thu, 27 Apr 2017 22:25:07 +0000
Message-ID: <1493331874.30303.1.camel@hpe.com>
References: <149333101097.4714.1923436715100717938.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149333101097.4714.1923436715100717938.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
Content-ID: <421223E9121FF449B0C5ABD81595181C@NAMPRD84.PROD.OUTLOOK.COM>
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
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gVGh1LCAyMDE3LTA0LTI3IGF0IDE1OjEwIC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IFRoZSBuZF9wbWVtX25vdGlmeSgpIHJvdXRpbmUgaXMgY2FsbGVkIHdoZW5ldmVyIGFuIEFSUw0K
PiAoYWRkcmVzcy1yYW5nZS1zY3J1YikgY29tcGxldGVzIHRvIGNvbW11bmljYXRlIHJlc3VsdHMg
dG8gdGhlDQo+IHBlci1uYW1lc3BhY2UgYmFkYmxvY2tzIGluc3RhbmNlcy4NCj4gDQo+IFdoZW4g
dGhlIG5hbWVzcGFjZSBpcyBpbiBidHQgbW9kZSB3ZSBjcmFzaCBiZWNhdXNlIHdlIGRvIG5vdCBh
bGxvY2F0ZQ0KPiBhIHN0cnVjdCBwbWVtX2RldmljZSBpbnN0YW5jZSBpbiB0aGF0IGNhc2UuIFJl
c3VsdGluZyBpbiB0aGUNCj4gZm9sbG93aW5nIGNyYXNoIHNpZ25hdHVyZToNCj4gDQo+IMKgQlVH
OiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCBOVUxMIHBvaW50ZXIgZGVyZWZlcmVuY2UgYXQNCj4g
MDAwMDAwMDAwMDAwMDAzMA0KPiDCoElQOiBuZF9wbWVtX25vdGlmeSsweDMwLzB4ZjAgW25kX3Bt
ZW1dDQo+IMKgQ2FsbCBUcmFjZToNCj4gwqAgbmRfZGV2aWNlX25vdGlmeSsweDQwLzB4NTANCj4g
wqAgY2hpbGRfbm90aWZ5KzB4MTAvMHgyMA0KPiDCoCBkZXZpY2VfZm9yX2VhY2hfY2hpbGQrMHg1
MC8weDkwDQo+IMKgIG5kX3JlZ2lvbl9ub3RpZnkrMHgyMC8weDMwDQo+IMKgIG5kX2RldmljZV9u
b3RpZnkrMHg0MC8weDUwDQo+IMKgIG52ZGltbV9yZWdpb25fbm90aWZ5KzB4MjcvMHgzMA0KPiDC
oCBhY3BpX25maXRfc2NydWIrMHgzNDEvMHg1OTAgW25maXRdDQo+IMKgIHByb2Nlc3Nfb25lX3dv
cmsrMHgxOTcvMHg0NTANCj4gwqAgd29ya2VyX3RocmVhZCsweDRlLzB4NGEwDQo+IMKgIGt0aHJl
YWQrMHgxMDkvMHgxNDANCj4gDQo+IEdpdmVuIHRoYXQgd2UgZG9uJ3QgZXZlbiBwb3B1bGF0ZSB0
aGUgYnR0IGJhZGJsb2NrcyBpbnN0YW5jZSwganVzdA0KPiByZXR1cm4gZWFybHkgYW5kIHNraXAg
dGhlIGRldmljZSB0byByZWdpb24gbG9va3VwLg0KDQpXZSBwb3B1bGF0ZSB0aGUgYnR0IGJhZGJs
b2NrcyBpbnRvIG5zaW8tPmJiLCBhbmQgY2hlY2svY2xlYXIgdGhlbSBpbg0KbnNpb19yd19ieXRl
cygpLg0KDQpUaGFua3MsDQotVG9zaGkKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlz
dHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZk
aW1tCg==
