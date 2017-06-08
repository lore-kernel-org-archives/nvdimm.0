Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6352220945529
 for <linux-nvdimm@lists.01.org>; Thu,  8 Jun 2017 01:01:04 -0700 (PDT)
Subject: Re: [PATCH 3/3] libnvdimm: New ACPI 6.2 DSM functions
References: <cover.1496852665.git.jerry.hoemann@hpe.com>
 <1fa949387694a4b6200309d592e78f435f065f75.1496852665.git.jerry.hoemann@hpe.com>
From: Johannes Thumshirn <jthumshirn@suse.de>
Message-ID: <f9c399bb-7ef7-7a95-cbf4-5937a8737b92@suse.de>
Date: Thu, 8 Jun 2017 10:02:10 +0200
MIME-Version: 1.0
In-Reply-To: <1fa949387694a4b6200309d592e78f435f065f75.1496852665.git.jerry.hoemann@hpe.com>
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
To: Jerry Hoemann <jerry.hoemann@hpe.com>, dan.j.williams@intel.com
Cc: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

T24gMDYvMDcvMjAxNyAwNzowNCBQTSwgSmVycnkgSG9lbWFubiB3cm90ZToKPiBAQCAtMTc5LDYg
KzIxNywxMCBAQCBzdGF0aWMgaW5saW5lIGNvbnN0IGNoYXIgKm52ZGltbV9idXNfY21kX25hbWUo
dW5zaWduZWQgY21kKQo+ICAJCVtORF9DTURfQVJTX1NUQVJUXSA9ICJhcnNfc3RhcnQiLAo+ICAJ
CVtORF9DTURfQVJTX1NUQVRVU10gPSAiYXJzX3N0YXR1cyIsCj4gIAkJW05EX0NNRF9DTEVBUl9F
UlJPUl0gPSAiY2xlYXJfZXJyb3IiLAo+ICsJCVs1XSA9ICJ0cmFuc19zcGEiLAo+ICsJCVs3XSA9
ICJhcnNfZXJyX2luaiIsCj4gKwkJWzhdID0gImFyc19lcnJfaW5qX2NsciIsCj4gKwkJWzldID0g
ImFyc19lcnJfaW5qX3N0YXQiLAo+ICAJCVtORF9DTURfQ0FMTF0gPSAiY21kX2NhbGwiLAo+ICAJ
fTsKCkNhbiB5b3UgcGxlYXNlIGFkZCB0aGUgbmV3IHZhbHVlcyB0byB0aGUgZW51bSBpbiB1YXBp
L25kY3RsLmg/IEkgZG9uJ3QKcmVhbGx5IGxpa2UgdGhlIG1hZ2ljIG51bWJlcnMgaGVyZS4KCi0t
IApKb2hhbm5lcyBUaHVtc2hpcm4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICBTdG9yYWdlCmp0aHVtc2hpcm5Ac3VzZS5kZSAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgKzQ5IDkxMSA3NDA1MyA2ODkKU1VTRSBMSU5VWCBHbWJILCBNYXhmZWxkc3RyLiA1LCA5
MDQwOSBOw7xybmJlcmcKR0Y6IEZlbGl4IEltZW5kw7ZyZmZlciwgSmFuZSBTbWl0aGFyZCwgR3Jh
aGFtIE5vcnRvbgpIUkIgMjEyODQgKEFHIE7DvHJuYmVyZykKS2V5IGZpbmdlcnByaW50ID0gRUMz
OCA5Q0FCIEMyQzQgRjI1RCA4NjAwIEQwRDAgMDM5MyA5NjlEIDJENzYgMDg1MApfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGlu
ZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFp
bG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
