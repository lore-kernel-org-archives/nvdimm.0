Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7189421191F29
 for <linux-nvdimm@lists.01.org>; Tue, 27 Nov 2018 12:10:44 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
 by mx0b-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id
 wARK9sdN094004
 for <linux-nvdimm@lists.01.org>; Tue, 27 Nov 2018 15:10:43 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
 by mx0b-001b2d01.pphosted.com with ESMTP id 2p1ch98m9v-1
 (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Tue, 27 Nov 2018 15:10:43 -0500
Received: from localhost
 by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <zohar@linux.ibm.com>;
 Tue, 27 Nov 2018 20:10:41 -0000
Subject: Re: [PATCH 01/11] keys-encrypted: add nvdimm key format type to
 encrypted keys
From: Mimi Zohar <zohar@linux.ibm.com>
Date: Tue, 27 Nov 2018 15:10:35 -0500
In-Reply-To: <CAPcyv4gXYDye7VhyL4yRpPATaZciJrZxLXZqSVx47on8Ag2KpA@mail.gmail.com>
References: <154180093865.70506.6858789591063128903.stgit@djiang5-desk3.ch.intel.com>
 <154180163107.70506.6894134402057805078.stgit@djiang5-desk3.ch.intel.com>
 <CAPcyv4iKQW+zG1mS-vdbXuU1BE0bQ-zDJt1uQBo6EHkvMF5Y_Q@mail.gmail.com>
 <5c0d66c2-d628-54eb-b16e-8a6a8eb990c1@intel.com>
 <1543343054.3902.192.camel@linux.ibm.com>
 <CAPcyv4i5=tAx6=W44Vva7=0GO9A=j0w5vEEYMMv3NnC9_fMz6g@mail.gmail.com>
 <1543347302.3902.202.camel@linux.ibm.com>
 <CAPcyv4gXYDye7VhyL4yRpPATaZciJrZxLXZqSVx47on8Ag2KpA@mail.gmail.com>
Mime-Version: 1.0
Message-Id: <1543349435.3902.208.camel@linux.ibm.com>
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
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, keyrings@vger.kernel.org, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gVHVlLCAyMDE4LTExLTI3IGF0IDExOjQ4IC0wODAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6Cgo+
IEkgd2FzIHRoaW5raW5nIHRoYXQgdGhlIGdlbmVyaWMtbGVuZ3RoICppcyogdGhlIGZvcm1hdC4g
VGhpcyBkb2VzIG5vdAo+IHdvcmsgZm9yIGVjeXB0ZnMgYmVjYXVzZSBpdCBoYXMgdGhhdDoKPiAK
PiAgICAgcGF5bG9hZF9kYXRhbGVuID0gc2l6ZW9mKHN0cnVjdCBlY3J5cHRmc19hdXRoX3Rvayk7
Cj4gCj4gLi4uZGV0YWlsIHRoYXQgaXMgZWNyeXB0ZnMgc3BlY2lmaWMuIEZvciBudmRpbW0gdGhl
IG9ubHkgZGV0YWlsIG9mIHRoZQo+IGZvcm1hdCBpcyB0aGUgZGVjcnlwdGVkLWRhdGEtbGVuZ3Ro
LiAgSG93ZXZlciwgSSBnZXQgdGhlIGZlZWxpbmcgSSdtCj4gcHJvcG9zaW5nIGEgc29sdXRpb24g
dG8gYSBwcm9ibGVtIHRoYXQgZG9lcyBub3QgZXhpc3QgeWV0LiBMZXQncyBqdXN0Cj4gZ28gd2l0
aCB0aGUgIm52ZGltbSIgZm9ybWF0IGZvciBub3cuCgpBaCwgdGhhdCBtYWtlcyBtb3JlIHNlbnNl
IG5vdy4gwqBEZWZpbmluZyAiT3B0X252ZGltbSIgb3IgdGhlIGdlbmVyaWMKIk9wdF9lbmMzMiIg
aXMgZmluZS4gwqBNaXNzaW5nIGZyb20gdGhpcyBwYXRjaCBpcyB0aGUgdXBkYXRlIHRvCkRvY3Vt
ZW50YXRpb24vc2VjdXJpdHkva2V5cy90cnVzdGVkLWVuY3J5cHRlZC5yc3QuIMKgT3RoZXJ3aXNl
IHRoaXMKcGF0Y2ggbG9va3MgZmluZS4KCk1pbWkKCl9fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZk
aW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xp
bnV4LW52ZGltbQo=
