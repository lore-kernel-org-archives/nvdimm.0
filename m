Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9B33820D7B8EB
 for <linux-nvdimm@lists.01.org>; Wed, 12 Apr 2017 13:22:53 -0700 (PDT)
Date: Wed, 12 Apr 2017 22:22:38 +0200
From: Borislav Petkov <bp@suse.de>
Subject: Re: [RFC PATCH] x86, mce: change the mce notifier to 'blocking' from
 'atomic'
Message-ID: <20170412202238.5d327vmwjqvbzzop@pd.tnic>
References: <20170411224457.24777-1-vishal.l.verma@intel.com>
 <20170412091442.dwonfr4dwyta7nvx@pd.tnic>
 <20170412195903.GA29506@omniknight.lm.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170412195903.GA29506@omniknight.lm.intel.com>
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Tony Luck <tony.luck@intel.com>, linux-nvdimm@lists.01.org, x86@kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

T24gV2VkLCBBcHIgMTIsIDIwMTcgYXQgMDE6NTk6MDNQTSAtMDYwMCwgVmlzaGFsIFZlcm1hIHdy
b3RlOgo+IEkgZG9uJ3QgdGhpbmsgd2UgY2FuIGRvIGFueXRoaW5nIGFib3V0IHRoZSBwYW5pYyBw
YXRoIGVycm9ycy4KClRoZW4gdGhlIGZpeCBzaG91bGQgYmUgYSBsb3QgZWFzaWVyOgoKLS0tCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL2FjcGkvbmZpdC9tY2UuYyBiL2RyaXZlcnMvYWNwaS9uZml0L21j
ZS5jCmluZGV4IDNiYTFjMzQ3MmNmOS4uNDRjMDkyZWMyYWM5IDEwMDY0NAotLS0gYS9kcml2ZXJz
L2FjcGkvbmZpdC9tY2UuYworKysgYi9kcml2ZXJzL2FjcGkvbmZpdC9tY2UuYwpAQCAtMjUsNiAr
MjUsOSBAQCBzdGF0aWMgaW50IG5maXRfaGFuZGxlX21jZShzdHJ1Y3Qgbm90aWZpZXJfYmxvY2sg
Km5iLCB1bnNpZ25lZCBsb25nIHZhbCwKIAlzdHJ1Y3QgYWNwaV9uZml0X2Rlc2MgKmFjcGlfZGVz
YzsKIAlzdHJ1Y3QgbmZpdF9zcGEgKm5maXRfc3BhOwogCisJaWYgKGluX2F0b21pYygpKQorCQly
ZXR1cm4gTk9USUZZX0RPTkU7CisKIAkvKiBXZSBvbmx5IGNhcmUgYWJvdXQgbWVtb3J5IGVycm9y
cyAqLwogCWlmICghKG1jZS0+c3RhdHVzICYgTUNBQ09EKSkKIAkJcmV0dXJuIE5PVElGWV9ET05F
OwoKCi0tIApSZWdhcmRzL0dydXNzLAogICAgQm9yaXMuCgpTVVNFIExpbnV4IEdtYkgsIEdGOiBG
ZWxpeCBJbWVuZMO2cmZmZXIsIEphbmUgU21pdGhhcmQsIEdyYWhhbSBOb3J0b24sIEhSQiAyMTI4
NCAoQUcgTsO8cm5iZXJnKQotLSAKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMu
MDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1t
Cg==
