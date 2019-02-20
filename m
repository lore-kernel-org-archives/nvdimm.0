Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F24D1211CBD14
 for <linux-nvdimm@lists.01.org>; Wed, 20 Feb 2019 09:21:53 -0800 (PST)
Subject: Re: [PATCH] acpi/nfit: Fix bus command validation
References: <154958385172.3932544.193235520333886200.stgit@dwillia2-desk3.amr.corp.intel.com>
 <x49lg2bql2v.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4iiZS_zfroRtmS-zD-cCDj1yQonBsWM23utR9m9kiBizA@mail.gmail.com>
 <b1f73551-5c11-3651-dc6f-5cdcf815e0d0@suse.de>
 <CAPcyv4hZXJbrLc9f3xsOTPs_RYVH9vhuxSxHj-4L56ZNi+ZRZg@mail.gmail.com>
From: Johannes Thumshirn <jthumshirn@suse.de>
Message-ID: <fcbf4a2c-a4c4-556e-f2dc-c22663997de5@suse.de>
Date: Wed, 20 Feb 2019 18:21:50 +0100
MIME-Version: 1.0
In-Reply-To: <CAPcyv4hZXJbrLc9f3xsOTPs_RYVH9vhuxSxHj-4L56ZNi+ZRZg@mail.gmail.com>
Content-Language: en-US
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
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>, Vishal Verma <vishal.verma@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

T24gMjAvMDIvMjAxOSAxNzoxNSwgRGFuIFdpbGxpYW1zIHdyb3RlOj4gSSB3b3VsZG4ndCBiZSBv
cHBvc2VkIHRvCnN5emthbGxlciBmdXp6aW5nIHRoZSBudmRpbW0taW9jdGwgcGF0aC4KQXMgYSBo
ZWFkcyB1cCwgSSd2ZSBzdGFydGVkIGFkZGluZyB0aGUgaW9jdGwoKSBkZWZpbml0aW9ucyB0byBz
eXpjYWxsZXIuCkp1c3Qgc28gd2UgZG9uJ3QgZHVwbGljYXRlIGFueSBlZmZvcnRzLgoKQnl0ZSwK
CUpvaGFubmVzCi0tIApKb2hhbm5lcyBUaHVtc2hpcm4gICAgICAgICAgICAgICAgICAgICAgICAg
ICAgU1VTRSBMYWJzIEZpbGVzeXN0ZW1zCmp0aHVtc2hpcm5Ac3VzZS5kZSAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgKzQ5IDkxMSA3NDA1MyA2ODkKU1VTRSBMSU5VWCBHbWJILCBNYXhm
ZWxkc3RyLiA1LCA5MDQwOSBOw7xybmJlcmcKR0Y6IEZlbGl4IEltZW5kw7ZyZmZlciwgSmFuZSBT
bWl0aGFyZCwgR3JhaGFtIE5vcnRvbgpIUkIgMjEyODQgKEFHIE7DvHJuYmVyZykKS2V5IGZpbmdl
cnByaW50ID0gRUMzOCA5Q0FCIEMyQzQgRjI1RCA4NjAwIEQwRDAgMDM5MyA5NjlEIDJENzYgMDg1
MApfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1u
dmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0
cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
