Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
 [148.163.156.1])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 39D2921962301
 for <linux-nvdimm@lists.01.org>; Tue, 19 Mar 2019 17:06:58 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id
 x2JNxNhF071605
 for <linux-nvdimm@lists.01.org>; Tue, 19 Mar 2019 20:06:57 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
 by mx0a-001b2d01.pphosted.com with ESMTP id 2rb8qqmaee-1
 (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Tue, 19 Mar 2019 20:06:56 -0400
Received: from localhost
 by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <zohar@linux.ibm.com>;
 Wed, 20 Mar 2019 00:06:49 -0000
Subject: Re: [PATCH 2/6] security/keys/encrypted: Clean up
 request_trusted_key()
From: Mimi Zohar <zohar@linux.ibm.com>
Date: Tue, 19 Mar 2019 20:06:38 -0400
In-Reply-To: <155297558570.2276575.11731393787282486177.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <155297557534.2276575.16264199708584900090.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155297558570.2276575.11731393787282486177.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Message-Id: <1553040398.4899.149.camel@linux.ibm.com>
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
To: Dan Williams <dan.j.williams@intel.com>, keyrings@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>, James Bottomley <jejb@linux.ibm.com>, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

T24gTW9uLCAyMDE5LTAzLTE4IGF0IDIzOjA2IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6Cgo8
IHNuaXAgPgoKPiArLyoKPiArICogcmVxdWVzdF90cnVzdGVkX2tleSAtIHJlcXVlc3QgdGhlIHRy
dXN0ZWQga2V5Cj4gKyAqCj4gKyAqIFRydXN0ZWQga2V5cyBhcmUgc2VhbGVkIHRvIFBDUnMgYW5k
IG90aGVyIG1ldGFkYXRhLiBBbHRob3VnaCB1c2Vyc3BhY2UKPiArICogbWFuYWdlcyBib3RoIHRy
dXN0ZWQvZW5jcnlwdGVkIGtleS10eXBlcywgbGlrZSB0aGUgZW5jcnlwdGVkIGtleSB0eXBlCj4g
KyAqIGRhdGEsIHRydXN0ZWQga2V5IHR5cGUgZGF0YSBpcyBub3QgdmlzaWJsZSBkZWNyeXB0ZWQg
ZnJvbSB1c2Vyc3BhY2UuCj4gKyAqLwo+ICtzdGF0aWMgc3RydWN0IGtleSAqcmVxdWVzdF90cnVz
dGVkX2tleShjb25zdCBjaGFyICp0cnVzdGVkX2Rlc2MsCj4gKwkJCQljb25zdCB1OCAqKm1hc3Rl
cl9rZXksIHNpemVfdCAqbWFzdGVyX2tleWxlbikKPiArewo+ICsJc3RydWN0IHRydXN0ZWRfa2V5
X3BheWxvYWQgKnRwYXlsb2FkOwo+ICsJc3RydWN0IGtleV90eXBlICp0eXBlOwo+ICsJc3RydWN0
IGtleSAqdGtleTsKPiArCj4gKwl0eXBlID0ga2V5X3R5cGVfbG9va3VwKCJ0cnVzdGVkIik7CgpU
aGUgYXNzb2NpYXRlZCBrZXlfdHlwZV9wdXQoKSB3aWxsIG5lZWQgdG8gYmUgY2FsbGVkLgoKPiAr
CWlmIChJU19FUlIodHlwZSkpIHsKPiArCQl0a2V5ID0gKHN0cnVjdCBrZXkgKil0eXBlOwo+ICsJ
CWdvdG8gZXJyb3I7Cj4gKwl9Cj4gKwl0a2V5ID0gcmVxdWVzdF9rZXkodHlwZSwgdHJ1c3RlZF9k
ZXNjLCBOVUxMKTsKPiArCWlmIChJU19FUlIodGtleSkpCj4gKwkJZ290byBlcnJvcjsKPiArCj4g
Kwlkb3duX3JlYWQoJnRrZXktPnNlbSk7Cj4gKwl0cGF5bG9hZCA9IHRrZXktPnBheWxvYWQuZGF0
YVswXTsKPiArCSptYXN0ZXJfa2V5ID0gdHBheWxvYWQtPmtleTsKPiArCSptYXN0ZXJfa2V5bGVu
ID0gdHBheWxvYWQtPmtleV9sZW47Cj4gK2Vycm9yOgo+ICsJcmV0dXJuIHRrZXk7Cj4gK30KPiAr
CgoKCj4gZGlmZiAtLWdpdCBhL3NlY3VyaXR5L2tleXMva2V5LmMgYi9zZWN1cml0eS9rZXlzL2tl
eS5jCj4gaW5kZXggNjk2ZjFjMDkyYzUwLi45MDQ1YjYyYWZiMDQgMTAwNjQ0Cj4gLS0tIGEvc2Vj
dXJpdHkva2V5cy9rZXkuYwo+ICsrKyBiL3NlY3VyaXR5L2tleXMva2V5LmMKPiBAQCAtNzA2LDYg
KzcwNiw3IEBAIHN0cnVjdCBrZXlfdHlwZSAqa2V5X3R5cGVfbG9va3VwKGNvbnN0IGNoYXIgKnR5
cGUpCj4gIGZvdW5kX2tlcm5lbF90eXBlOgo+ICAJcmV0dXJuIGt0eXBlOwo+ICB9Cj4gK0VYUE9S
VF9TWU1CT0xfR1BMKGtleV90eXBlX2xvb2t1cCk7CgpPbmx5IHRoZSBrZXJuZWwgaXMgY2FsbGlu
ZyBrZXlfdHlwZV9sb29rdXAoKS4gwqBXaHkgZG9lcwprZXlfdHlwZV9sb29rdXAoKSBuZWVkIHRv
IGJlIGV4cG9ydGVkPwoKTWltaQoKPiAgCj4gIHZvaWQga2V5X3NldF90aW1lb3V0KHN0cnVjdCBr
ZXkgKmtleSwgdW5zaWduZWQgdGltZW91dCkKPiAgewo+IAoKX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51
eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGlu
Zm8vbGludXgtbnZkaW1tCg==
