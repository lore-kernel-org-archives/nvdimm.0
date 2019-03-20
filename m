Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
 [148.163.156.1])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 71F0C21962301
 for <linux-nvdimm@lists.01.org>; Tue, 19 Mar 2019 19:35:51 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id
 x2K2Y0tO060559
 for <linux-nvdimm@lists.01.org>; Tue, 19 Mar 2019 22:35:50 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
 by mx0a-001b2d01.pphosted.com with ESMTP id 2rbakuwb04-1
 (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Tue, 19 Mar 2019 22:35:49 -0400
Received: from localhost
 by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <zohar@linux.ibm.com>;
 Wed, 20 Mar 2019 02:35:47 -0000
Subject: Re: [PATCH 2/6] security/keys/encrypted: Clean up
 request_trusted_key()
From: Mimi Zohar <zohar@linux.ibm.com>
Date: Tue, 19 Mar 2019 22:35:31 -0400
In-Reply-To: <CAPcyv4heLwdJR+xKZfvx5TAvqsKr3sNCda_ovivguLKbiXhyYg@mail.gmail.com>
References: <155297557534.2276575.16264199708584900090.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155297558570.2276575.11731393787282486177.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1553040398.4899.149.camel@linux.ibm.com>
 <CAPcyv4heLwdJR+xKZfvx5TAvqsKr3sNCda_ovivguLKbiXhyYg@mail.gmail.com>
Mime-Version: 1.0
Message-Id: <1553049331.4899.177.camel@linux.ibm.com>
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

T24gVHVlLCAyMDE5LTAzLTE5IGF0IDE3OjIwIC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6Cj4g
T24gVHVlLCBNYXIgMTksIDIwMTkgYXQgNTowNyBQTSBNaW1pIFpvaGFyIDx6b2hhckBsaW51eC5p
Ym0uY29tPiB3cm90ZToKPiA+Cj4gPiBPbiBNb24sIDIwMTktMDMtMTggYXQgMjM6MDYgLTA3MDAs
IERhbiBXaWxsaWFtcyB3cm90ZToKPiA+Cj4gPiA8IHNuaXAgPgo+ID4KPiA+ID4gKy8qCj4gPiA+
ICsgKiByZXF1ZXN0X3RydXN0ZWRfa2V5IC0gcmVxdWVzdCB0aGUgdHJ1c3RlZCBrZXkKPiA+ID4g
KyAqCj4gPiA+ICsgKiBUcnVzdGVkIGtleXMgYXJlIHNlYWxlZCB0byBQQ1JzIGFuZCBvdGhlciBt
ZXRhZGF0YS4gQWx0aG91Z2ggdXNlcnNwYWNlCj4gPiA+ICsgKiBtYW5hZ2VzIGJvdGggdHJ1c3Rl
ZC9lbmNyeXB0ZWQga2V5LXR5cGVzLCBsaWtlIHRoZSBlbmNyeXB0ZWQga2V5IHR5cGUKPiA+ID4g
KyAqIGRhdGEsIHRydXN0ZWQga2V5IHR5cGUgZGF0YSBpcyBub3QgdmlzaWJsZSBkZWNyeXB0ZWQg
ZnJvbSB1c2Vyc3BhY2UuCj4gPiA+ICsgKi8KPiA+ID4gK3N0YXRpYyBzdHJ1Y3Qga2V5ICpyZXF1
ZXN0X3RydXN0ZWRfa2V5KGNvbnN0IGNoYXIgKnRydXN0ZWRfZGVzYywKPiA+ID4gKyAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgY29uc3QgdTggKiptYXN0ZXJfa2V5LCBzaXplX3QgKm1hc3Rl
cl9rZXlsZW4pCj4gPiA+ICt7Cj4gPiA+ICsgICAgIHN0cnVjdCB0cnVzdGVkX2tleV9wYXlsb2Fk
ICp0cGF5bG9hZDsKPiA+ID4gKyAgICAgc3RydWN0IGtleV90eXBlICp0eXBlOwo+ID4gPiArICAg
ICBzdHJ1Y3Qga2V5ICp0a2V5Owo+ID4gPiArCj4gPiA+ICsgICAgIHR5cGUgPSBrZXlfdHlwZV9s
b29rdXAoInRydXN0ZWQiKTsKPiA+Cj4gPiBUaGUgYXNzb2NpYXRlZCBrZXlfdHlwZV9wdXQoKSB3
aWxsIG5lZWQgdG8gYmUgY2FsbGVkLgo+IAo+IFllcy4KCkkgZG9uJ3Qga25vdyBpZiBkZWZpbmlu
ZyBhIGtleV90eXBlX2xvb2t1cCgpIHdyYXBwZXIsIHBlcmhhcHMgbmFtZWQKaXNfa2V5X3R5cGVf
YXZhaWxhYmxlKCksIHdvdWxkIGhlbHAuIMKgQm90aCBrZXlfdHlwZV9sb29rdXAoKSBhbmQKa2V5
X3R5cGVfcHV0KCkgd291bGQgYmUgY2FsbGVkLiDCoFRoZSBleGlzdGluZyBjb2RlIGNvdWxkIHRo
ZW4gcmVtYWluCnRoZSBzYW1lLgoKTWltaQoKPiAKPiA+Cj4gPiA+ICsgICAgIGlmIChJU19FUlIo
dHlwZSkpIHsKPiA+ID4gKyAgICAgICAgICAgICB0a2V5ID0gKHN0cnVjdCBrZXkgKil0eXBlOwo+
ID4gPiArICAgICAgICAgICAgIGdvdG8gZXJyb3I7Cj4gPiA+ICsgICAgIH0KPiA+ID4gKyAgICAg
dGtleSA9IHJlcXVlc3Rfa2V5KHR5cGUsIHRydXN0ZWRfZGVzYywgTlVMTCk7Cj4gPiA+ICsgICAg
IGlmIChJU19FUlIodGtleSkpCj4gPiA+ICsgICAgICAgICAgICAgZ290byBlcnJvcjsKPiA+ID4g
Kwo+ID4gPiArICAgICBkb3duX3JlYWQoJnRrZXktPnNlbSk7Cj4gPiA+ICsgICAgIHRwYXlsb2Fk
ID0gdGtleS0+cGF5bG9hZC5kYXRhWzBdOwo+ID4gPiArICAgICAqbWFzdGVyX2tleSA9IHRwYXls
b2FkLT5rZXk7Cj4gPiA+ICsgICAgICptYXN0ZXJfa2V5bGVuID0gdHBheWxvYWQtPmtleV9sZW47
Cj4gPiA+ICtlcnJvcjoKPiA+ID4gKyAgICAgcmV0dXJuIHRrZXk7Cj4gPiA+ICt9Cj4gPiA+ICsK
PiA+CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51
eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9s
aXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
