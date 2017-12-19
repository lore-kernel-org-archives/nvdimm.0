Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0B17F2035BA04
 for <linux-nvdimm@lists.01.org>; Tue, 19 Dec 2017 06:58:47 -0800 (PST)
Date: Tue, 19 Dec 2017 16:03:32 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 14/17] memremap: simplify duplicate region handling in
 devm_memremap_pages
Message-ID: <20171219150332.GB13124@lst.de>
References: <20171215140947.26075-1-hch@lst.de>
 <20171215140947.26075-15-hch@lst.de>
 <CAPcyv4i2naLJjWzm+q0ORRfyHkT0f5dFBFKutuaXE3OgPcHX5g@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4i2naLJjWzm+q0ORRfyHkT0f5dFBFKutuaXE3OgPcHX5g@mail.gmail.com>
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

T24gU3VuLCBEZWMgMTcsIDIwMTcgYXQgMDk6MzQ6MTFBTSAtMDgwMCwgRGFuIFdpbGxpYW1zIHdy
b3RlOgo+IFRoaXMgaXMgbm90IHJhY3ksIHdlJ2xsIGNhdGNoIHRoZSBlcnJvciBvbiBpbnNlcnQs
IGFuZCBJIHRoaW5rIHRoZQo+IGV4dHJhIGRlYnVnIGluZm9ybWF0aW9uIGlzIHVzZWZ1bCBmb3Ig
ZGVidWdnaW5nIGEgYnJva2VuIG1lbW9yeSBtYXAgb3IKPiBhbGlnbm1lbnQgbWF0aC4KCldlIGNh
biBjaGVjayBmb3IgLdCVRVhJU1QgYW5kIHByaW50IHRoZSB3YXJuaW5nLCBidXQgaXQncyBhIHdl
aXJkIHBhdHRlcm4KZm9yIHN1cmUuCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3Rz
LjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGlt
bQo=
