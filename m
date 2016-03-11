Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id 4BF561A1EF5
 for <linux-nvdimm@lists.01.org>; Thu, 10 Mar 2016 17:17:50 -0800 (PST)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH 1/3] ndctl: fix ndctl_bus_cmd_new_ars_status()
 input validation
Date: Fri, 11 Mar 2016 01:17:32 +0000
Message-ID: <1457659048.4525.37.camel@intel.com>
References: <20160311004511.27582.63304.stgit@dwillia2-desk3.jf.intel.com>
 <20160311004516.27582.37530.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20160311004516.27582.37530.stgit@dwillia2-desk3.jf.intel.com>
Content-Language: en-US
Content-ID: <2D24ECB6EBFC8B4D9032F63F73342FDE@intel.com>
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
List-ID: <linux-nvdimm@lists.01.org>

T24gVGh1LCAyMDE2LTAzLTEwIGF0IDE2OjQ1IC0wODAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IENoZWNrIHRoYXQgYXJzX3N0YXR1cywgcmF0aGVyIHRoYW4gYXJzX2NhcCwgY29tbWFuZHMgYXJl
IHN1cHBvcnRlZCBhbmQNCj4gdmFsaWRhdGUgdGhhdCB0aGUgcmVmZXJlbmNlIGFyc19jYXAgcGFz
c2VkIGluIGlzIGluZGVlZCBhbmQgYXJzX2NhcA0KDQpzL2FuZC9hbi8NCg0KPiBjb21tYW5kLg0K
PiANCj4gQ2M6IFZpc2hhbCBWZXJtYSA8dmlzaGFsLmwudmVybWFAaW50ZWwuY29tPg0KPiBTaWdu
ZWQtb2ZmLWJ5OiBEYW4gV2lsbGlhbXMgPGRhbi5qLndpbGxpYW1zQGludGVsLmNvbT4NCj4gLS0t
DQo+IMKgbGliL2xpYm5kY3RsLWFycy5jIHzCoMKgwqDCoDYgKysrLS0tDQo+IMKgMSBmaWxlIGNo
YW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQg
YS9saWIvbGlibmRjdGwtYXJzLmMgYi9saWIvbGlibmRjdGwtYXJzLmMNCj4gaW5kZXggYWQ4NTE5
MTg5OGQ0Li42M2QwZTU1NDRhMzYgMTAwNjQ0DQo+IC0tLSBhL2xpYi9saWJuZGN0bC1hcnMuYw0K
PiArKysgYi9saWIvbGlibmRjdGwtYXJzLmMNCj4gQEAgLTU1LDcgKzU1LDcgQEAgTkRDVExfRVhQ
T1JUIHN0cnVjdCBuZGN0bF9jbWQNCj4gKm5kY3RsX2J1c19jbWRfbmV3X2Fyc19zdGFydChzdHJ1
Y3QgbmRjdGxfY21kICphcnMNCj4gwqAJCWRiZyhjdHgsICJ1bnN1cHBvcnRlZCBjbWRcbiIpOw0K
PiDCoAkJcmV0dXJuIE5VTEw7DQo+IMKgCX0NCj4gLQlpZiAoYXJzX2NhcC0+c3RhdHVzICE9IDAp
IHsNCj4gKwlpZiAoYXJzX2NhcC0+dHlwZSAhPSBORF9DTURfQVJTX0NBUCB8fCBhcnNfY2FwLT5z
dGF0dXMgIT0gMCkNCj4gew0KPiDCoAkJZGJnKGN0eCwgImV4cGVjdGVkIHN1Y2Vzc2Z1bGx5IGNv
bXBsZXRlZCBhcnNfY2FwDQo+IGNvbW1hbmRcbiIpOw0KPiDCoAkJcmV0dXJuIE5VTEw7DQo+IMKg
CX0NCj4gQEAgLTk0LDExICs5NCwxMSBAQCBORENUTF9FWFBPUlQgc3RydWN0IG5kY3RsX2NtZA0K
PiAqbmRjdGxfYnVzX2NtZF9uZXdfYXJzX3N0YXR1cyhzdHJ1Y3QgbmRjdGxfY21kICphcg0KPiDC
oAlzdHJ1Y3QgbmRjdGxfY21kICpjbWQ7DQo+IMKgCXNpemVfdCBzaXplOw0KPiDCoA0KPiAtCWlm
ICghbmRjdGxfYnVzX2lzX2NtZF9zdXBwb3J0ZWQoYnVzLCBORF9DTURfQVJTX0NBUCkpIHsNCj4g
KwlpZiAoIW5kY3RsX2J1c19pc19jbWRfc3VwcG9ydGVkKGJ1cywgTkRfQ01EX0FSU19TVEFUVVMp
KSB7DQoNCkdvb2QgY2F0Y2ggOikNCg0KPiDCoAkJZGJnKGN0eCwgInVuc3VwcG9ydGVkIGNtZFxu
Iik7DQo+IMKgCQlyZXR1cm4gTlVMTDsNCj4gwqAJfQ0KPiAtCWlmIChhcnNfY2FwLT5zdGF0dXMg
IT0gMCkgew0KPiArCWlmIChhcnNfY2FwLT50eXBlICE9IE5EX0NNRF9BUlNfQ0FQIHx8IGFyc19j
YXAtPnN0YXR1cyAhPSAwKQ0KPiB7DQo+IMKgCQlkYmcoY3R4LCAiZXhwZWN0ZWQgc3VjZXNzZnVs
bHkgY29tcGxldGVkIGFyc19jYXANCj4gY29tbWFuZFxuIik7DQo+IMKgCQlyZXR1cm4gTlVMTDsN
Cj4gwqAJfQ0KPiANCg0KUmV2aWV3ZWQtYnk6IFZpc2hhbCBWZXJtYSA8dmlzaGFsLmwudmVybWFA
aW50ZWwuY29tPgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
XwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0
cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
