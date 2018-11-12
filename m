Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0AEBA2118F357
 for <linux-nvdimm@lists.01.org>; Mon, 12 Nov 2018 11:04:07 -0800 (PST)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
 by mx0b-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id
 wACJ461V084916
 for <linux-nvdimm@lists.01.org>; Mon, 12 Nov 2018 14:04:07 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
 by mx0b-001b2d01.pphosted.com with ESMTP id 2nqe1juerm-1
 (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Mon, 12 Nov 2018 14:04:06 -0500
Received: from localhost
 by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <zohar@linux.ibm.com>;
 Mon, 12 Nov 2018 19:04:05 -0000
Subject: Re: [PATCH 02/11] libnvdimm/security: change clear text nvdimm keys
 to encrypted keys
From: Mimi Zohar <zohar@linux.ibm.com>
Date: Mon, 12 Nov 2018 14:04:00 -0500
In-Reply-To: <1cc6edd6-8926-1be1-04f3-85ce59bfdfb4@intel.com>
References: <154180093865.70506.6858789591063128903.stgit@djiang5-desk3.ch.intel.com>
 <154180163666.70506.8805433934495072699.stgit@djiang5-desk3.ch.intel.com>
 <1541957268.3734.53.camel@linux.ibm.com>
 <1cc6edd6-8926-1be1-04f3-85ce59bfdfb4@intel.com>
Mime-Version: 1.0
Message-Id: <1542049440.3769.132.camel@linux.ibm.com>
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
To: Dave Jiang <dave.jiang@intel.com>, dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

T24gTW9uLCAyMDE4LTExLTEyIGF0IDA4OjQ1IC0wNzAwLCBEYXZlIEppYW5nIHdyb3RlOgoKPiA+
IFVzaW5nIHRydXN0ZWQga2V5cyB0aGF0IGFyZSBlbmNyeXB0ZWQvZGVjcnlwdGVkIHVzaW5nIGEg
dXNlciBrZXkKPiA+IHNob3VsZCByZWFsbHkgYmUgbGltaXRlZCB0byB0ZXN0aW5nIGVudmlyb25t
ZW50cy4KPiAKPiBEbyB5b3UgaGF2ZSBhbnkgcmVjb21tZW5kYXRpb24gZm9yIHN5c3RlbXMgdGhh
dCBkbyBub3Qgc3VwcG9ydCBUUE0/CgpUaGUgVFBNIHByb3ZpZGVzIGNlcnRhaW4gc2VjdXJpdHkg
Z3VhcmFudGVlcywgd2hpY2ggInVzZXIiIHR5cGUga2V5cwpkbyBub3QuIMKgSWYgdGhlIHN5c3Rl
bSBkb2Vzbid0IHByb3ZpZGUgZWl0aGVyIGEgZGlzY3JldGUgb3IgZmlybXdhcmUKVFBNLCB1c2Ug
YSBzb2Z0d2FyZSBUUE0uCgpNaW1pCiLCoAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1A
bGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgt
bnZkaW1tCg==
