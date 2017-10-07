Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x230.google.com (mail-oi0-x230.google.com
 [IPv6:2607:f8b0:4003:c06::230])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 26AC521FC749B
 for <linux-nvdimm@lists.01.org>; Sat,  7 Oct 2017 16:30:11 -0700 (PDT)
Received: by mail-oi0-x230.google.com with SMTP id j126so11034268oib.8
 for <linux-nvdimm@lists.01.org>; Sat, 07 Oct 2017 16:33:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1507374524.25529.13.camel@infradead.org>
References: <150732931273.22363.8436792888326501071.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150732935473.22363.1853399637339625023.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1507329939.29211.434.camel@infradead.org>
 <CAPcyv4jLj2WOgPA+B5eYME0uZyuoy3gp35w+4rCa_EZxm-QSKA@mail.gmail.com>
 <1507331434.29211.439.camel@infradead.org>
 <CAPcyv4j0gbXtyviEA00ktav_-VwZUpd1+BgBNfzBqFA9XOqXBw@mail.gmail.com>
 <1507374524.25529.13.camel@infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 7 Oct 2017 16:33:36 -0700
Message-ID: <CAPcyv4gJY6AJX99V49eo_dY0Ov45xYtq1SDEBnnsz=6caJvo0w@mail.gmail.com>
Subject: Re: [PATCH v7 07/12] dma-mapping: introduce dma_has_iommu()
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
To: David Woodhouse <dwmw2@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Ashok Raj <ashok.raj@intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-rdma@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Joerg Roedel <joro@8bytes.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>, Marek Szyprowski <m.szyprowski@samsung.com>
List-ID: <linux-nvdimm@lists.01.org>

T24gU2F0LCBPY3QgNywgMjAxNyBhdCA0OjA4IEFNLCBEYXZpZCBXb29kaG91c2UgPGR3bXcyQGlu
ZnJhZGVhZC5vcmc+IHdyb3RlOgo+IE9uIEZyaSwgMjAxNy0xMC0wNiBhdCAxNjoxNSAtMDcwMCwg
RGFuIFdpbGxpYW1zIHdyb3RlOgo+Pgo+PiBSaWdodCwgY3Jvc3NlZCBtYWlscy4gVGhlIHNlbWFu
dGljIEkgd2FudCBpcyB0aGF0IHRoZSBJT1ZBIGlzCj4+IGludmFsaWRhdGVkIC8gc3RhcnRzIHRo
cm93aW5nIGVycm9ycyB0byB0aGUgZGV2aWNlIGJlY2F1c2UgdGhlIGFkZHJlc3MKPj4gaXQgdGhv
dWdodCBpdCB3YXMgdGFsa2luZyB0byBoYXMgYmVlbiByZW1hcHBlZCBpbiB0aGUgZmlsZS4gT25j
ZQo+PiB1c2Vyc3BhY2Ugd2FrZXMgdXAgYW5kIHJlc3BvbmRzIHRvIHRoaXMgaW52YWxpZGF0aW9u
IGV2ZW50IGl0IGNhbiBkbwo+PiB0aGUgYWN0dWFsIHVubWFwIHRvIG1ha2UgdGhlIElPVkEgcmV1
c2FibGUgYWdhaW4uCj4KPiBTbyBiYXNpY2FsbHkgeW91IHdhbnQgdG8gdW5tYXAgaXQgYnkgcmVt
b3ZpbmcgaXQgZnJvbSB0aGUgcGFnZSB0YWJsZXMKPiBhbmQgZmx1c2hpbmcgdGhlIElPVExCLCBi
dXQgeW91IHdhbnQgdGhlIElPVkEgdG8gc3RpbGwgYmUgcmVzZXJ2ZWQuCj4KPiBUaGUgbm9ybWFs
IGRldmljZS1mYWNpbmcgRE1BIEFQSSBkb2Vzbid0IGdpdmUgeW91IHRoYXQgdG9kYXkuIFlvdSBj
b3VsZAo+IGRvIGl0IHdpdGggdGhlIElPTU1VIEFQSSB0aG91Z2gg4oCUIHRoYXQgb25lIGRvZXMg
bGV0IHlvdSBtYW5hZ2UgdGhlIElPVkEKPiBzcGFjZSB5b3Vyc2VsZi4gWW91IGRvbid0IHdhbnQg
dGhhdCBJT1ZBIHVzZWQgYWdhaW4/IFdlbGwgZG9uJ3QgdXNlIGl0Cj4gYXMgdGhlIElPVkEgaW4g
YSBzdWJzZXF1ZW50IGlvbW11X21hcCgpIGNhbGwgdGhlbiA6KQoKQWgsIG5pY2UuIFNvIEkgdGhp
bmsgSSdsbCBqdXN0IGFkZCBhIGRtYV9nZXRfaW9tbXVfZG9tYWluKCkgc28gdGhlCmRtYV9vcHMg
aW1wbGVtZW50YXRpb24gY2FuIGV4Y2x1ZGUgaWRlbnRpdHktbWFwcGVkIGRldmljZXMsIGFuZCB0
aGVuCmlvbW11X3VubWFwKCkgZG9lcyB0aGUgcmVzdC4gVGhhbmtzIGZvciB0aGUgcG9pbnRlci4K
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZk
aW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMu
MDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
