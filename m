Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5008.houston.hp.com (g9t5008.houston.hp.com [15.240.92.66])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5BBEB1A1ED2
 for <linux-nvdimm@lists.01.org>; Thu,  3 Mar 2016 14:56:16 -0800 (PST)
Message-ID: <1457048928.15454.117.camel@hpe.com>
Subject: Re: [PATCH v2 3/4] resource: Add device-managed
 insert/remove_resource()
From: Toshi Kani <toshi.kani@hpe.com>
Date: Thu, 03 Mar 2016 16:48:48 -0700
In-Reply-To: <CAPcyv4iBg0fsaAM-fnHaDir6mosLM-gwr+VU_doTsYU6st-yyQ@mail.gmail.com>
References: <1456959056-12316-1-git-send-email-toshi.kani@hpe.com>
 <1456959056-12316-4-git-send-email-toshi.kani@hpe.com>
 <CAPcyv4iBg0fsaAM-fnHaDir6mosLM-gwr+VU_doTsYU6st-yyQ@mail.gmail.com>
Mime-Version: 1.0
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Rafael J. Wysocki  <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov <bp@suse.de>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gVGh1LCAyMDE2LTAzLTAzIGF0IDE0OjQ1IC0wODAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6Cj4g
T24gV2VkLCBNYXIgMiwgMjAxNiBhdCAyOjUwIFBNLCBUb3NoaSBLYW5pIDx0b3NoaS5rYW5pQGhw
ZS5jb20+IHdyb3RlOgrCoDoKPiA+IAo+ID4gZGlmZiAtLWdpdCBhL2tlcm5lbC9yZXNvdXJjZS5j
IGIva2VybmVsL3Jlc291cmNlLmMKPiA+IGluZGV4IGVmZmI2ZWUuLmIxYTMzOTQgMTAwNjQ0Cj4g
PiAtLS0gYS9rZXJuZWwvcmVzb3VyY2UuYwo+ID4gKysrIGIva2VybmVsL3Jlc291cmNlLmMKPiA+
IEBAIC0xNDQ5LDYgKzE0NDksNzUgQEAgdm9pZCBfX2Rldm1fcmVsZWFzZV9yZWdpb24oc3RydWN0
IGRldmljZSAqZGV2LAo+ID4gc3RydWN0IHJlc291cmNlICpwYXJlbnQsCj4gPiDCoEVYUE9SVF9T
WU1CT0woX19kZXZtX3JlbGVhc2VfcmVnaW9uKTsKPiA+IAo+ID4gwqAvKgo+ID4gKyAqIFJlbW92
ZSBmdW5jdGlvbiBmb3IgZGV2bV9pbnNlcnRfcmVzb3VyY2UoKSBhbmQKPiA+IGRldm1fcmVtb3Zl
X3Jlc291cmNlKCkuCj4gPiArICovCj4gPiArc3RhdGljIHZvaWQgZGV2bV9yZXNvdXJjZV9yZW1v
dmUoc3RydWN0IGRldmljZSAqZGV2LCB2b2lkICpwdHIpCj4gPiArewo+ID4gK8KgwqDCoMKgwqDC
oMKgc3RydWN0IHJlc291cmNlICoqciA9IHB0cjsKPiA+ICsKPiA+ICvCoMKgwqDCoMKgwqDCoHJl
bW92ZV9yZXNvdXJjZSgqcik7Cj4gPiArfQo+ID4gKwo+IAo+IE1heWJlIGNhbGwgdGhpcyBfX2Rl
dm1fcmVtb3ZlX3Jlc291cmNlP8KgwqBJIHRoaW5rIHRoaXMgbWFrZXMgaXQgY2xlYXJlcgo+IHRo
YXQgaXQgaXMgYSBwcml2YXRlIGhlbHBlciBmdW5jdGlvbi7CoMKgSSB3YXMgaW5pdGlhbGx5IGNv
bmZ1c2VkIGFib3V0Cj4gdGhlIGRpZmZlcmVuY2UgYmV0d2VlbiBkZXZtX3Jlc291cmNlX3JlbW92
ZSBhbmQgZGV2bV9yZW1vdmVfcmVzb3VyY2UuCgpXaWxsIGRvLiDCoEkgZm9sbG93ZWQgdGhlIG5h
bWluZyBjb252ZW50aW9uIG9mIGRldm1fcmVzb3VyY2VfcmVsZWFzZSgpIGluCnRoZSBzYW1lIGZp
bGUsIGJ1dCBJIGFncmVlIHRoYXQgdGhpcyBpcyBjb25mdXNpbmcuCgpUaGFua3MsCi1Ub3NoaQpf
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRp
bW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4w
MS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
