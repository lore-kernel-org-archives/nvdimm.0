Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D83D02117AE75
 for <linux-nvdimm@lists.01.org>; Sun, 11 Nov 2018 12:09:52 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
 by mx0b-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id
 wABK8c0O101225
 for <linux-nvdimm@lists.01.org>; Sun, 11 Nov 2018 15:09:51 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
 by mx0b-001b2d01.pphosted.com with ESMTP id 2npdvs9k35-1
 (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Sun, 11 Nov 2018 15:09:51 -0500
Received: from localhost
 by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <zohar@linux.ibm.com>;
 Sun, 11 Nov 2018 20:09:50 -0000
Subject: Re: [PATCH 02/11] libnvdimm/security: change clear text nvdimm keys
 to encrypted keys
From: Mimi Zohar <zohar@linux.ibm.com>
Date: Sun, 11 Nov 2018 15:09:35 -0500
In-Reply-To: <CAPcyv4jMPDap8L6jTo9NGnrJGCjUY_BvSBuPge8NL4QS2Ku0CQ@mail.gmail.com>
References: <154180093865.70506.6858789591063128903.stgit@djiang5-desk3.ch.intel.com>
 <154180163666.70506.8805433934495072699.stgit@djiang5-desk3.ch.intel.com>
 <1541957268.3734.53.camel@linux.ibm.com>
 <CAPcyv4jMPDap8L6jTo9NGnrJGCjUY_BvSBuPge8NL4QS2Ku0CQ@mail.gmail.com>
Mime-Version: 1.0
Message-Id: <1541966975.3734.78.camel@linux.ibm.com>
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
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, keyrings@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

PiA+IFRyYWRpdGlvbmFsbHkgdGhlcmUgaXMgYSBzaW5nbGUgbWFzdGVyIGtleSBmb3IgdGhlIHN5
c3RlbSwgd2hpY2ggd291bGQKPiA+IGJlIHNlYWxlZCB0byBhIHNldCBvZiBib290IHRpbWUgUENS
IHZhbHVlcy4gIEFmdGVyIGRlY3J5cHRpbmcgYWxsIG9mCj4gPiB0aGUgZW5jcnlwdGVkIGtleXMs
IHRoZSBtYXN0ZXIga2V5IHdvdWxkIGJlIHJlbW92ZWQgZnJvbSB0aGUga2V5cmluZwo+ID4gYW5k
IGEgUENSIGV4dGVuZGVkLiAgRXh0ZW5kaW5nIGEgUENSIHdvdWxkIHByZXZlbnQgdGhlIG1hc3Rl
ciBrZXkgZnJvbQo+ID4gYmVpbmcgdW5zZWFsZWQgYWdhaW4gYW5kIHVzZWQgdG8gZGVjcnlwdCBl
bmNyeXB0ZWQga2V5cywgd2l0aG91dAo+ID4gcmVib290aW5nIHRoZSBzeXN0ZW0uICBOb3JtYWxs
eSB0aGlzIHdvdWxkIGJlIGRvbmUgYmVmb3JlIHBpdm90aW5nCj4gPiByb290Lgo+ID4KPiA+IElm
IHlvdSdyZSBub3QgcmVmZXJyaW5nIHRvIHRoZSBzeXN0ZW0gbWFzdGVyIGtleSBhbmQgYXJlIGlu
dGVudGlvbmFsbHkKPiA+IGxpbWl0aW5nIHVzYWdlIHRvIFRQTSAyLjAsIG1vcmUgZGV0YWlscyBv
biB0aGUgbWFzdGVyIGtleSBzZWN1cml0eQo+ID4gcmVxdWlyZW1lbnRzIHNob3VsZCBiZSBpbmNs
dWRlZC4KPiAKPiBPaCwgaW50ZXJlc3RpbmcgcG9pbnQuIEkgdGhpbmsgd2UgaGFkIGJlZW4gYXNz
dW1pbmcgYSBsb2NhbCArCj4gdW5zZWFsZWQtYXQtcnVudGltZSBudmRpbW0gbWFzdGVyIGtleSBy
YXRoZXIgdGhhbiBhIHN5c3RlbS13aWRlIG1hc3Rlcgo+IGtleS4gWWVzLCB3ZSBuZWVkIHRvIHJl
dGhpbmsgdGhpcyBpbiB0ZXJtcyBvZiBzdXBwb3J0aW5nIGEgc2VhbGVkCj4gc3lzdGVtLWtleS4g
VGhpcyB3b3VsZCBzZWVtIHRvIGxpbWl0IHNlY3VyaXR5IGFjdGlvbnMsIG91dHNpZGUgb2YKPiB1
bmxvY2ssIHRvIGFsd2F5cyByZXF1aXJpbmcgYSByZWJvb3QuIEkuZS4gdGhlIG5vbWluYWwgY2Fz
ZSBpcyB0aGF0IHdlCj4gYm9vdCB1cCBhbmQgdW5sb2NrIHRoZSBESU1NcywgYnV0IGFueSBzdWJz
ZXF1ZW50IHNlY3VyaXR5IG9wZXJhdGlvbgo+IGxpa2UgZXJhc2UsIG9yIGNoYW5nZS1wYXNzcGhy
YXNlIHdvdWxkIHJlcXVpcmUgcmVib290aW5nIGludG8gYW4KPiBlbnZpcm9ubWVudCB3aGVyZSB0
aGUgc3lzdGVtLW1hc3RlciBrZXkgaXMgdW5zZWFsZWQuIEkgZG8gdGhpbmsKPiByZS1wcm92aXNp
b25pbmcga2V5cyBhbmQgZXJhc2luZyBESU1NIGNvbnRlbnRzIGFyZSBzdWZmaWNpZW50bHkKPiBl
eGNlcHRpb25hbCBldmVudHMgdGhhdCBhIHJlYm9vdCByZXF1aXJlbWVudCBpcyB0b2xlcmFibGUu
Cgo+IElzIHRoZXJlIGFscmVhZHkgZXhpc3RpbmcgdG9vbGluZyBhcm91bmQgdGhpcyB0byBiZSBh
YmxlIHRvIHNjaGVkdWxlCj4gbWFzdGVyLWtleSByZWxhdGVkIGFjdGlvbnMgdG8gYmUgZGVmZXJy
ZWQgdG8gYW4gaW5pdHJkIGVudmlyb25tZW50PwoKVGhlcmUncyB0aGUgb3JpZ2luYWwgZHJhY3V0
IHN1cHBvcnQgZm9yIGxvYWRpbmcgYSBtYXN0ZXJrZXksIHdoaWNoIGlzCnVzZWQgYnkgdGhlIEVW
TSBhbmQgZWNyeXB0ZnMgZHJhY3V0IG1vZHVsZXMuIMKgQWZ0ZXIgdGhlIGxhc3QgdXNhZ2UsCnRo
ZSBtYXN0ZXJrZXkgbmVlZHMgdG8gYmUgcmVtb3ZlZCBmcm9tIHRoZSBrZXlyaW5nLgoKRGlmZmVy
ZW50IHBlb3BsZSBvdmVyIHRoZSB5ZWFycyBoYXZlIHdhbnRlZCB0byBhZGQgc3VwcG9ydCBmb3IK
Y2FsY3VsYXRpbmcgdGhlIGJvb3QgdGltZSBleHBlY3RlZCBQQ1JzIHZhbHVlcyBpbiBvcmRlciB0
byByZXNlYWwga2V5cwoodHJ1c3RlZCBrZXkgdXBkYXRlKSwgYnV0IEkgaGF2ZW4ndCBsb29rZWQg
dG8gc2VlIGlmIHRoZXJlIGFyZSBhbnkKb3BlbiBzb3VyY2UgdG9vbHMgYXZhaWxhYmxlLgoKTWlt
aQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgt
bnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlz
dHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
