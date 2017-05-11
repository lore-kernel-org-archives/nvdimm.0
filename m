Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8ADE221A04E1D
 for <linux-nvdimm@lists.01.org>; Thu, 11 May 2017 04:38:11 -0700 (PDT)
Message-ID: <1494502687.6967.2.camel@linux.intel.com>
Subject: Re: [PATCH 03/16] uuid: rename uuid types
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Thu, 11 May 2017 14:38:07 +0300
In-Reply-To: <2612.1494440436@warthog.procyon.org.uk>
References: <20170510180214.16852-4-hch@lst.de>
 <20170510180214.16852-1-hch@lst.de>
 <2612.1494440436@warthog.procyon.org.uk>
Mime-Version: 1.0
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
To: David Howells <dhowells@redhat.com>, Christoph Hellwig <hch@lst.de>
Cc: linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, Shaohua Li <shli@kernel.org>, Amir Goldstein <amir73il@gmail.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Mimi Zohar <zohar@linux.vnet.ibm.com>, Steven Whitehouse <swhiteho@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

T24gV2VkLCAyMDE3LTA1LTEwIGF0IDE5OjIwICswMTAwLCBEYXZpZCBIb3dlbGxzIHdyb3RlOgo+
IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPiB3cm90ZToKPiAKPiA+IC0jZGVmaW5lIE5V
TExfVVVJRF9MRQkJCQkJCQo+ID4gCVwKPiA+IC0JVVVJRF9MRSgweDAwMDAwMDAwLCAweDAwMDAs
IDB4MDAwMCwgMHgwMCwgMHgwMCwgMHgwMCwgMHgwMCwKPiA+IAlcCj4gPiAtCQkweDAwLCAweDAw
LCAweDAwLCAweDAwKQo+ID4gKyNkZWZpbmUgTlVMTF9HVUlECQkJCQkJCQo+ID4gXAo+ID4gKwlH
VUlEKDB4MDAwMDAwMDAsIDB4MDAwMCwgMHgwMDAwLCAweDAwLCAweDAwLCAweDAwLCAweDAwLAkK
PiA+IFwKPiA+ICsJwqDCoMKgwqDCoDB4MDAsIDB4MDAsIDB4MDAsIDB4MDApCj4gPiDCoAo+ID4g
LSNkZWZpbmUgTlVMTF9VVUlEX0JFCQkJCQkJCj4gPiAJXAo+ID4gLQlVVUlEX0JFKDB4MDAwMDAw
MDAsIDB4MDAwMCwgMHgwMDAwLCAweDAwLCAweDAwLCAweDAwLCAweDAwLAo+ID4gCVwKPiA+IC0J
CTB4MDAsIDB4MDAsIDB4MDAsIDB4MDApCj4gPiArI2RlZmluZSBOVUxMX1VVSUQJCQkJCQkJCj4g
PiBcCj4gPiArCVVVSUQoMHgwMDAwMDAwMCwgMHgwMDAwLCAweDAwMDAsIDB4MDAsIDB4MDAsIDB4
MDAsIDB4MDAsCQo+ID4gXAo+ID4gKwnCoMKgwqDCoMKgMHgwMCwgMHgwMCwgMHgwMCwgMHgwMCkK
PiAKPiBUaGVzZSBhcmUgVUFQSSBhbmQgb3VnaHQgbm90IHRvIGJlIHJlbmFtZWQuCj4gCgpHb29k
IHBvaW50LiBJIHNlZSBpbiB0aGUgYnJhbmNoIGl0J3MgYWxyZWFkeSBmaXhlZC4KCgotLSAKQW5k
eSBTaGV2Y2hlbmtvIDxhbmRyaXkuc2hldmNoZW5rb0BsaW51eC5pbnRlbC5jb20+CkludGVsIEZp
bmxhbmQgT3kKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18K
TGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBz
Oi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
