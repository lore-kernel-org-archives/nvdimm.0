Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9B4AE21A0483A
 for <linux-nvdimm@lists.01.org>; Wed, 12 Apr 2017 14:13:25 -0700 (PDT)
Date: Wed, 12 Apr 2017 23:13:03 +0200
From: Borislav Petkov <bp@suse.de>
Subject: Re: [RFC PATCH] x86, mce: change the mce notifier to 'blocking' from
 'atomic'
Message-ID: <20170412211302.3d2cxe34sgiu3dag@pd.tnic>
References: <20170411224457.24777-1-vishal.l.verma@intel.com>
 <20170412091442.dwonfr4dwyta7nvx@pd.tnic>
 <20170412195903.GA29506@omniknight.lm.intel.com>
 <20170412202238.5d327vmwjqvbzzop@pd.tnic>
 <1492028744.2738.14.camel@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1492028744.2738.14.camel@intel.com>
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
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gV2VkLCBBcHIgMTIsIDIwMTcgYXQgMDg6Mjc6MDVQTSArMDAwMCwgVmVybWEsIFZpc2hhbCBM
IHdyb3RlOgo+IEJ1dCBpc24ndCB0aGUgYXRvbWljIG5vdGlmaWVyIGNhbGwgY2hhaW4gYWx3YXlz
IGNhbGxlZCBpbiBhdG9taWMKPiBjb250ZXh0PwoKTm8sIGl0IGlzbid0LiBXZSdyZSBjYWxsaW5n
IGl0IGluIG5vcm1hbCBwcm9jZXNzIGNvbnRleHQgaW4KbWNlX2dlbl9wb29sX3Byb2Nlc3MoKSB0
b28uCgpTbyB0aGlzIGVhcmx5IGV4aXQgd2lsbCBhdm9pZCBhbnkgc2xlZXBpbmcgaW4gYXRvbWlj
IGNvbnRleHQuIEFuZCBzaW5jZQp0aGVyZSdzIG5vdGhpbmcgeW91IGNhbiBkbyBhYm91dCB0aGUg
ZXJyb3JzIHJlcG9ydGVkIGluIGF0b21pYyBjb250ZXh0LAp3ZSBjYW4gYWN0dWFsbHkgdXNlIHRo
YXQgZmFjdC4KCi0tIApSZWdhcmRzL0dydXNzLAogICAgQm9yaXMuCgpTVVNFIExpbnV4IEdtYkgs
IEdGOiBGZWxpeCBJbWVuZMO2cmZmZXIsIEphbmUgU21pdGhhcmQsIEdyYWhhbSBOb3J0b24sIEhS
QiAyMTI4NCAoQUcgTsO8cm5iZXJnKQotLSAKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1A
bGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgt
bnZkaW1tCg==
