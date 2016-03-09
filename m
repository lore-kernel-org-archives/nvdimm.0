Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5009.houston.hp.com (g9t5009.houston.hp.com [15.240.92.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EC3141A1F3F
 for <linux-nvdimm@lists.01.org>; Wed,  9 Mar 2016 11:42:29 -0800 (PST)
Message-ID: <1457555691.15454.534.camel@hpe.com>
Subject: Re: [PATCH v3 0/4] Support persistent memory as reserved type in
 e820/EFI
From: Toshi Kani <toshi.kani@hpe.com>
Date: Wed, 09 Mar 2016 13:34:51 -0700
In-Reply-To: <CAPcyv4jxyDSQNC6wQDCOH3OLa-gUdeiOpKo1Pq88Av1joZqUtw@mail.gmail.com>
References: <1457552817-13938-1-git-send-email-toshi.kani@hpe.com>
 <CAPcyv4jxyDSQNC6wQDCOH3OLa-gUdeiOpKo1Pq88Av1joZqUtw@mail.gmail.com>
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Rafael J. Wysocki  <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov <bp@suse.de>, "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gV2VkLCAyMDE2LTAzLTA5IGF0IDExOjMwIC0wODAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6Cj4g
T24gV2VkLCBNYXIgOSwgMjAxNiBhdCAxMTo0NiBBTSwgVG9zaGkgS2FuaSA8dG9zaGkua2FuaUBo
cGUuY29tPiB3cm90ZToKwqA6Cj4gPiBUb3NoaSBLYW5pICg0KToKPiA+IMKgMS80IHJlc291cmNl
OiBDaGFuZ2UgX19yZXF1ZXN0X3JlZ2lvbiB0byBpbmhlcml0IGZyb20gaW1tZWRpYXRlIHBhcmVu
dAo+ID4gwqAyLzQgcmVzb3VyY2U6IEFkZCByZW1vdmVfcmVzb3VyY2UgaW50ZXJmYWNlCj4gPiDC
oDMvNCByZXNvdXJjZTogRXhwb3J0IGluc2VydF9yZXNvdXJjZSBhbmQgcmVtb3ZlX3Jlc291cmNl
Cj4gPiDCoDQvNCBBQ1BJOiBDaGFuZ2UgTkZJVCBkcml2ZXIgdG8gaW5zZXJ0IG5ldyByZXNvdXJj
ZQo+ID4gCj4gPiAtLS0KPiA+IMKgZHJpdmVycy9hY3BpL25maXQuY8KgwqDCoMKgfCA0OCArKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrCj4gPiDCoGluY2x1ZGUvbGludXgv
aW9wb3J0LmggfMKgwqAxICsKPiA+IMKga2VybmVsL3Jlc291cmNlLmPCoMKgwqDCoMKgwqB8IDYw
Cj4gPiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLQo+
ID4gwqAzIGZpbGVzIGNoYW5nZWQsIDEwMSBpbnNlcnRpb25zKCspLCA4IGRlbGV0aW9ucygtKQo+
IAo+IEhpIFRvc2hpLCB0aGlzIGxvb2tzIGdvb2QgdG8gbWUgYW5kIHBhc3NlcyBteSB0ZXN0aW5n
Lgo+IAo+IEknbGwgZ2l2ZSBpdCB1bnRpbCB0aGUgZW5kIG9mIHRoZSBkYXkgaWYgdGhlcmUgaXMg
YW55IG1vcmUgZmVlZGJhY2sKPiBhbmQgb3RoZXJ3aXNlIG1lcmdlIGl0IGludG8gdGhlIHBlbmRp
bmcgbGlibnZkaW1tIHVwZGF0ZXMgZm9yIDQuNi4KCkdyZWF0ISBUaGFua3MgRGFuIQotVG9zaGkK
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZk
aW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMu
MDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
