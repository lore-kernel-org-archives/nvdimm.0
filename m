Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C83A88032B
 for <linux-nvdimm@lists.01.org>; Wed,  8 Mar 2017 00:00:55 -0800 (PST)
Subject: Re: [PATCH v2 3/5] acpi: cleanup acpi_nfit_ctl calling xlat_status
References: <148892068983.46486.5008198419806159468.stgit@djiang5-desk3.ch.intel.com>
 <148892080835.46486.13067994980370510435.stgit@djiang5-desk3.ch.intel.com>
From: Johannes Thumshirn <jthumshirn@suse.de>
Message-ID: <8f79fbdb-0fef-0b8c-2217-9097055ab5bf@suse.de>
Date: Wed, 8 Mar 2017 09:00:54 +0100
MIME-Version: 1.0
In-Reply-To: <148892080835.46486.13067994980370510435.stgit@djiang5-desk3.ch.intel.com>
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

T24gMDMvMDcvMjAxNyAxMDowNiBQTSwgRGF2ZSBKaWFuZyB3cm90ZToKPiBNYWtlIHN1cmUgdGhh
dCB4bGF0X3N0YXR1cyBpcyB1bmNvbmRpdGlvbmFsbHkgY2FsbGVkLgo+IAo+IFNpZ25lZC1vZmYt
Ynk6IERhdmUgSmlhbmcgPGRhdmUuamlhbmdAaW50ZWwuY29tPgo+IC0tLQoKUmV2aWV3ZWQtYnk6
IEpvaGFubmVzIFRodW1zaGlybiA8anRodW1zaGlybkBzdXNlLmRlPgoKCi0tIApKb2hhbm5lcyBU
aHVtc2hpcm4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBTdG9yYWdl
Cmp0aHVtc2hpcm5Ac3VzZS5kZSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKzQ5IDkx
MSA3NDA1MyA2ODkKU1VTRSBMSU5VWCBHbWJILCBNYXhmZWxkc3RyLiA1LCA5MDQwOSBOw7xybmJl
cmcKR0Y6IEZlbGl4IEltZW5kw7ZyZmZlciwgSmFuZSBTbWl0aGFyZCwgR3JhaGFtIE5vcnRvbgpI
UkIgMjEyODQgKEFHIE7DvHJuYmVyZykKS2V5IGZpbmdlcnByaW50ID0gRUMzOCA5Q0FCIEMyQzQg
RjI1RCA4NjAwIEQwRDAgMDM5MyA5NjlEIDJENzYgMDg1MApfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4
LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5m
by9saW51eC1udmRpbW0K
