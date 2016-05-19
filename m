Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 08D7F1A1FDB
 for <linux-nvdimm@lists.01.org>; Thu, 19 May 2016 02:27:11 -0700 (PDT)
Date: Thu, 19 May 2016 11:27:02 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 5/7] dax: New fault locking
Message-ID: <20160519092702.GB19697@quack2.suse.cz>
References: <1463070560-1979-1-git-send-email-jack@suse.cz>
 <1463070560-1979-6-git-send-email-jack@suse.cz>
 <20160512193624.GA20719@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160512193624.GA20719@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Ted Tso <tytso@mit.edu>, linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

T24gVGh1IDEyLTA1LTE2IDEzOjM2OjI0LCBSb3NzIFp3aXNsZXIgd3JvdGU6Cj4gT24gVGh1LCBN
YXkgMTIsIDIwMTYgYXQgMDY6Mjk6MThQTSArMDIwMCwgSmFuIEthcmEgd3JvdGU6Cj4gPiBAQCAt
ODk3LDEzICsxMTY2LDEwIEBAIGludCBfX2RheF9wbWRfZmF1bHQoc3RydWN0IHZtX2FyZWFfc3Ry
dWN0ICp2bWEsIHVuc2lnbmVkIGxvbmcgYWRkcmVzcywKPiA+ICAJCSAqIHRoZSB3cml0ZSB0byBp
bnNlcnQgYSBkaXJ0eSBlbnRyeS4KPiA+ICAJCSAqLwo+ID4gIAkJaWYgKHdyaXRlKSB7Cj4gPiAt
CQkJZXJyb3IgPSBkYXhfcmFkaXhfZW50cnkobWFwcGluZywgcGdvZmYsIGRheC5zZWN0b3IsCj4g
PiAtCQkJCQl0cnVlLCB0cnVlKTsKPiA+IC0JCQlpZiAoZXJyb3IpIHsKPiA+IC0JCQkJZGF4X3Bt
ZF9kYmcoJmJoLCBhZGRyZXNzLAo+ID4gLQkJCQkJCSJQTUQgcmFkaXggaW5zZXJ0aW9uIGZhaWxl
ZCIpOwo+ID4gLQkJCQlnb3RvIGZhbGxiYWNrOwo+ID4gLQkJCX0KPiA+ICsJCQkvKgo+ID4gKwkJ
CSAqIFdlIHNob3VsZCBpbnNlcnQgcmFkaXgtdHJlZSBlbnRyeSBhbmQgZGlydHkgaXQgaGVyZS4K
PiA+ICsJCQkgKiBGb3Igbm93IHRoaXMgaXMgYnJva2VuLi4uCj4gPiArCQkJICovCj4gCj4gV2l0
aCB0aGlzIGNoYW5nZSB0aGUgJ2Vycm9yJyB2YXJpYWJsZSBpbiBfX2RheF9wbWRfZmF1bHQoKSBp
cyBub3cgdW51c2VkLAo+IHJlc3VsdGluZyBpbiBhIGNvbXBpbGVyIHdhcm5pbmcuCj4gCj4gZnMv
ZGF4LmM6IEluIGZ1bmN0aW9uIOKAmF9fZGF4X3BtZF9mYXVsdOKAmToKPiBmcy9kYXguYzoxMDE5
OjY6IHdhcm5pbmc6IHVudXNlZCB2YXJpYWJsZSDigJhlcnJvcuKAmSBbLVd1bnVzZWQtdmFyaWFi
bGVdCj4gICBpbnQgZXJyb3IsIHJlc3VsdCA9IDA7Cj4gICAgICAgICBeCgpJIGRpZG4ndCB3YW50
IHRvIHJlc3BpbiB0aGUgcGF0Y2ggc2V0IGJlY2F1c2Ugb2YgdGhpcyBidXQgSSdsbCBzZW5kIGEg
Zml4dXAKcGF0Y2ggZm9yIGl0LgoKCQkJCQkJCQlIb256YQotLSAKSmFuIEthcmEgPGphY2tAc3Vz
ZS5jb20+ClNVU0UgTGFicywgQ1IKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMu
MDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1t
Cg==
