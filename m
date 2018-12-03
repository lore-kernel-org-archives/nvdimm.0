Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C133721193066
 for <linux-nvdimm@lists.01.org>; Mon,  3 Dec 2018 08:56:22 -0800 (PST)
Subject: Re: [PATCH 0/9] Allow persistent memory to be used like normal RAM
References: <20181022201317.8558C1D8@viggo.jf.intel.com>
 <ffeb6225-6d5c-099e-3158-4711c879ec23@gmail.com>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <48d78370-438d-65fa-370c-4cf61a27ed3d@intel.com>
Date: Mon, 3 Dec 2018 08:56:22 -0800
MIME-Version: 1.0
In-Reply-To: <ffeb6225-6d5c-099e-3158-4711c879ec23@gmail.com>
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
To: Brice Goglin <brice.goglin@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: thomas.lendacky@amd.com, mhocko@suse.com, linux-nvdimm@lists.01.org, ying.huang@intel.com, linux-mm@kvack.org, zwisler@kernel.org, fengguang.wu@intel.com, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

T24gMTIvMy8xOCAxOjIyIEFNLCBCcmljZSBHb2dsaW4gd3JvdGU6Cj4gTGUgMjIvMTAvMjAxOCDD
oCAyMjoxMywgRGF2ZSBIYW5zZW4gYSDDqWNyaXTCoDoKPiBXaGF0IGhhcHBlbnMgb24gc3lzdGVt
cyB3aXRob3V0IGFuIEhNQVQ/IERvZXMgdGhpcyBuZXcgbWVtb3J5IGdldCBtZXJnZWQKPiBpbnRv
IGV4aXN0aW5nIE5VTUEgbm9kZXM/CgpJdCBnZXRzIG1lcmdlZCBpbnRvIHRoZSBwZXJzaXN0ZW50
IG1lbW9yeSBkZXZpY2UncyBub2RlLCBhcyB0b2xkIGJ5IHRoZQpmaXJtd2FyZS4gIEludGVsJ3Mg
cGVyc2lzdGVudCBtZW1vcnkgc2hvdWxkIGFsd2F5cyBiZSBpbiBpdHMgb3duIG5vZGUsCnNlcGFy
YXRlIGZyb20gRFJBTS4KCj4gQWxzbywgZG8geW91IHBsYW4gdG8gaGF2ZSBhIHdheSBmb3IgYXBw
bGljYXRpb25zIHRvIGZpbmQgb3V0IHdoaWNoIE5VTUEKPiBub2RlcyBhcmUgInJlYWwgRFJBTSIg
d2hpbGUgb3RoZXJzIGFyZSAicG1lbS1iYWNrZWQiPyAoc29tZXRoaW5nIGxpa2UgYQo+IG5ldyBh
dHRyaWJ1dGUgaW4gL3N5cy9kZXZpY2VzL3N5c3RlbS9ub2RlL25vZGVYLykgT3Igc2hvdWxkIHdl
IHVzZSBITUFUCj4gcGVyZm9ybWFuY2UgYXR0cmlidXRlcyBmb3IgdGhpcz8KClRoZSBiZXN0IHdh
eSBpcyB0byB1c2UgdGhlIHN5c2ZzLWdlbmVyaWMgaW50ZXJmYWNlcyB0byB0aGUgSE1BVCB0aGF0
CktlaXRoIEJ1c2NoIGlzIHB1c2hpbmcuICBJbiB0aGUgZW5kLCB3ZSByZWFsbHkgdGhpbmsgZm9s
a3Mgd2lsbCBvbmx5CmNhcmUgYWJvdXQgdGhlIG1lbW9yeSdzIHBlcmZvcm1hbmNlIHByb3BlcnRp
ZXMgcmF0aGVyIHRoYW4gd2hldGhlciBpdCdzCiphY3R1YWxseSogcGVyc2lzdGVudCBtZW1vcnkg
b3Igbm90LgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpM
aW51eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6
Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
