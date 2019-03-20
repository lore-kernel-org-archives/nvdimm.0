Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1B9892194EB70
 for <linux-nvdimm@lists.01.org>; Wed, 20 Mar 2019 05:06:38 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
 by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id
 x2KC0m9F081440
 for <linux-nvdimm@lists.01.org>; Wed, 20 Mar 2019 08:06:37 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
 by mx0b-001b2d01.pphosted.com with ESMTP id 2rbkx4v5np-1
 (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Wed, 20 Mar 2019 08:06:37 -0400
Received: from localhost
 by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <zohar@linux.ibm.com>;
 Wed, 20 Mar 2019 12:06:34 -0000
Subject: Re: [PATCH 2/6] security/keys/encrypted: Clean up
 request_trusted_key()
From: Mimi Zohar <zohar@linux.ibm.com>
Date: Wed, 20 Mar 2019 08:06:19 -0400
In-Reply-To: <CAPcyv4gySHayfwtp1PgxEoM-T_s_1A4RTcnXefx5iRLn9g=D5w@mail.gmail.com>
References: <155297557534.2276575.16264199708584900090.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155297558570.2276575.11731393787282486177.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1553040398.4899.149.camel@linux.ibm.com>
 <CAPcyv4heLwdJR+xKZfvx5TAvqsKr3sNCda_ovivguLKbiXhyYg@mail.gmail.com>
 <1553049331.4899.177.camel@linux.ibm.com>
 <CAPcyv4gySHayfwtp1PgxEoM-T_s_1A4RTcnXefx5iRLn9g=D5w@mail.gmail.com>
Mime-Version: 1.0
Message-Id: <1553083579.4899.239.camel@linux.ibm.com>
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
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, James Bottomley <jejb@linux.ibm.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

T24gVHVlLCAyMDE5LTAzLTE5IGF0IDIyOjQ4IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6Cj4g
T24gVHVlLCBNYXIgMTksIDIwMTkgYXQgNzozNiBQTSBNaW1pIFpvaGFyIDx6b2hhckBsaW51eC5p
Ym0uY29tPiB3cm90ZToKPiA+Cj4gPiBPbiBUdWUsIDIwMTktMDMtMTkgYXQgMTc6MjAgLTA3MDAs
IERhbiBXaWxsaWFtcyB3cm90ZToKPiA+ID4gT24gVHVlLCBNYXIgMTksIDIwMTkgYXQgNTowNyBQ
TSBNaW1pIFpvaGFyIDx6b2hhckBsaW51eC5pYm0uY29tPiB3cm90ZToKPiA+ID4gPgo+ID4gPiA+
IE9uIE1vbiwgMjAxOS0wMy0xOCBhdCAyMzowNiAtMDcwMCwgRGFuIFdpbGxpYW1zIHdyb3RlOgo+
ID4gPiA+Cj4gPiA+ID4gPCBzbmlwID4KPiA+ID4gPgo+ID4gPiA+ID4gKy8qCj4gPiA+ID4gPiAr
ICogcmVxdWVzdF90cnVzdGVkX2tleSAtIHJlcXVlc3QgdGhlIHRydXN0ZWQga2V5Cj4gPiA+ID4g
PiArICoKPiA+ID4gPiA+ICsgKiBUcnVzdGVkIGtleXMgYXJlIHNlYWxlZCB0byBQQ1JzIGFuZCBv
dGhlciBtZXRhZGF0YS4gQWx0aG91Z2ggdXNlcnNwYWNlCj4gPiA+ID4gPiArICogbWFuYWdlcyBi
b3RoIHRydXN0ZWQvZW5jcnlwdGVkIGtleS10eXBlcywgbGlrZSB0aGUgZW5jcnlwdGVkIGtleSB0
eXBlCj4gPiA+ID4gPiArICogZGF0YSwgdHJ1c3RlZCBrZXkgdHlwZSBkYXRhIGlzIG5vdCB2aXNp
YmxlIGRlY3J5cHRlZCBmcm9tIHVzZXJzcGFjZS4KPiA+ID4gPiA+ICsgKi8KPiA+ID4gPiA+ICtz
dGF0aWMgc3RydWN0IGtleSAqcmVxdWVzdF90cnVzdGVkX2tleShjb25zdCBjaGFyICp0cnVzdGVk
X2Rlc2MsCj4gPiA+ID4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICBjb25zdCB1OCAq
Km1hc3Rlcl9rZXksIHNpemVfdCAqbWFzdGVyX2tleWxlbikKPiA+ID4gPiA+ICt7Cj4gPiA+ID4g
PiArICAgICBzdHJ1Y3QgdHJ1c3RlZF9rZXlfcGF5bG9hZCAqdHBheWxvYWQ7Cj4gPiA+ID4gPiAr
ICAgICBzdHJ1Y3Qga2V5X3R5cGUgKnR5cGU7Cj4gPiA+ID4gPiArICAgICBzdHJ1Y3Qga2V5ICp0
a2V5Owo+ID4gPiA+ID4gKwo+ID4gPiA+ID4gKyAgICAgdHlwZSA9IGtleV90eXBlX2xvb2t1cCgi
dHJ1c3RlZCIpOwo+ID4gPiA+Cj4gPiA+ID4gVGhlIGFzc29jaWF0ZWQga2V5X3R5cGVfcHV0KCkg
d2lsbCBuZWVkIHRvIGJlIGNhbGxlZC4KPiA+ID4KPiA+ID4gWWVzLgo+ID4KPiA+IEkgZG9uJ3Qg
a25vdyBpZiBkZWZpbmluZyBhIGtleV90eXBlX2xvb2t1cCgpIHdyYXBwZXIsIHBlcmhhcHMgbmFt
ZWQKPiA+IGlzX2tleV90eXBlX2F2YWlsYWJsZSgpLCB3b3VsZCBoZWxwLiAgQm90aCBrZXlfdHlw
ZV9sb29rdXAoKSBhbmQKPiA+IGtleV90eXBlX3B1dCgpIHdvdWxkIGJlIGNhbGxlZC4gIFRoZSBl
eGlzdGluZyBjb2RlIGNvdWxkIHRoZW4gcmVtYWluCj4gPiB0aGUgc2FtZS4KPiA+Cj4gCj4gTWF5
YmUsIGJ1dCBzb21ldGhpbmcgc3RpbGwgbmVlZHMgdG8gcGluIHRoZSBob3N0aW5nIG1vZHVsZS4g
SSB0aGluawo+IHRoaXMgbWVhbnMgdGhhdCB0aGUgZmlyc3QgY2FsbCB0byBrZXlfdHlwZS0+aW5z
dGFudGlhdGUoKSBwaW5zIHRoZQo+IGhvc3RpbmcgbW9kdWxlLCBhbmQgdGhlIC0+ZGVzdHJveSgp
IG9mIHRoZSBsYXN0IGtleSBmb3IgdGhlIGtleV90eXBlCj4gdW5waW5zIHRoZSBtb2R1bGUuIEl0
IGRvZXMgbWVhbiB0aGF0IHRoZSAtPmRlc3Ryb3koKSBtZXRob2QgaXMgbm8KPiBsb25nZXIgb3B0
aW9uYWwuCgpUaGlzIHNvdW5kcyBsaWtlIGl0IGlzbid0IGEgbmV3IHByb2JsZW0uIMKgQm90aCBp
c3N1ZXMgbmVlZCB0byBiZQphZGRyZXNzZWQsIGJ1dCBJIHRoaW5rIHdlIHNob3VsZCBkaWZmZXJl
bnRpYXRlIGJldHdlZW4gdGhlbSBhbmQKYWRkcmVzcyB0aGVtIHNlcGFyYXRlbHkuCgpJbiB0ZXJt
cyBvZiB0aGUgb3JpZ2luYWwgbnZkaW1tIGVuY3J5cHRlZC90cnVzdGVkIGtleSBwcm9ibGVtLCB0
aGUKYWJvdmUgc3VnZ2VzdGlvbiByZXF1aXJlcyB0aGUgbGVhc3QgYW1vdW50IG9mIGNoYW5nZS4g
wqBGb3IgdjUuMiwgSQp3b3VsZCByZXBsYWNlIGl0IHdpdGggdGhlIGZ1bGwgdXBkYXRlZCBwYXRj
aCBzZXQuCgpNaW1pCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcK
aHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
