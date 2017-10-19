Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 793162034C0A9
 for <linux-nvdimm@lists.01.org>; Thu, 19 Oct 2017 10:01:20 -0700 (PDT)
From: jane.chu@oracle.com
Subject: what happened to byte-addressable read()/write() to character device
 DAX?
Message-ID: <efdf3c01-b91b-4b69-33a8-90cbccfe803d@oracle.com>
Date: Thu, 19 Oct 2017 10:04:52 -0700
MIME-Version: 1.0
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

SGksIERhbiwKClJlZmVycmluZyB0bwoKIMKgIGh0dHBzOi8vcGF0Y2h3b3JrLmtlcm5lbC5vcmcv
cHJvamVjdC9saW51eC1udmRpbW0vbGlzdC8/cGFnZT02CgogwqAgW1JGQywyLzJdIG1tLCBmczog
ZGF4ZmlsZSwgYW4gaW50ZXJmYWNlIGZvciBieXRlLWFkZHJlc3NhYmxlIHVwZGF0ZXMgCnRvIHBt
ZW0KCkknbSB1bmFibGUgdG8gZmluZCB0aGUgcGF0Y2ggaW4gTGludXggdXBzdHJlYW0ga2VybmVs
LCBhbmQgYW0gd29uZGVyaW5nIGlmCgp0aGVyZSBoYXMgYmVlbiBhIGNoYW5nZSBvZiBwbGFuIGZv
ciBwcm92aWRpbmcgc3VwcG9ydCB0byBieXRlIGdyYW51bGFyaXR5CgpyZWFkKCkgYW5kIHdyaXRl
KCkgdG8gY2hhcmFjdGVyIGRldmljZSAvZGV2L2RheC4KCkkndmUgYWxzbyBqdXN0IHN0YXJ0ZWQg
Zm9sbG93aW5nIHRoZSBlbWFpbCB0aHJlYWRzLCBzbyBJIG1pZ2h0IGhhdmUgCm1pc3NlZCBzb21l
IGNyaXRpY2FsCgpkaXNjdXNzaW9ucy7CoCBXb3VsZCB5b3UgbWluZCB0byBlbGFib3JhdGUgd2hh
dCdzIGhhcHBlbmluZyB0byB0aGUgCnByb3Bvc2VkIGZlYXR1cmU/CgoKVGhhbmtzIGEgbG90IQoK
ClJlZ2FyZHMsCgotamFuZQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEu
b3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
