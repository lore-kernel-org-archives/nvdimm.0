Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 510B32110A3EC
 for <linux-nvdimm@lists.01.org>; Fri, 31 Aug 2018 08:48:52 -0700 (PDT)
References: <20180830185352.3369-1-logang@deltatee.com>
 <20180830185352.3369-2-logang@deltatee.com>
 <2711b3a7-f582-0dda-8ac2-530be7bda1bb@amd.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <439181bb-6cd6-0ab2-bca6-fc820845166e@deltatee.com>
Date: Fri, 31 Aug 2018 09:48:40 -0600
MIME-Version: 1.0
In-Reply-To: <2711b3a7-f582-0dda-8ac2-530be7bda1bb@amd.com>
Content-Language: en-US
Subject: Re: [PATCH v5 01/13] PCI/P2PDMA: Support peer-to-peer memory
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
To: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alex Williamson <alex.williamson@redhat.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

CgpPbiAzMS8wOC8xOCAwMjowNCBBTSwgQ2hyaXN0aWFuIEvDtm5pZyB3cm90ZToKPiBBbSAzMC4w
OC4yMDE4IHVtIDIwOjUzIHNjaHJpZWIgTG9nYW4gR3VudGhvcnBlOgo+PiBTb21lIFBDSSBkZXZp
Y2VzIG1heSBoYXZlIG1lbW9yeSBtYXBwZWQgaW4gYSBCQVIgc3BhY2UgdGhhdCdzCj4+IGludGVu
ZGVkIGZvciB1c2UgaW4gcGVlci10by1wZWVyIHRyYW5zYWN0aW9ucy4gSW4gb3JkZXIgdG8gZW5h
YmxlCj4+IHN1Y2ggdHJhbnNhY3Rpb25zIHRoZSBtZW1vcnkgbXVzdCBiZSByZWdpc3RlcmVkIHdp
dGggWk9ORV9ERVZJQ0UgcGFnZXMKPj4gc28gaXQgY2FuIGJlIHVzZWQgYnkgRE1BIGludGVyZmFj
ZXMgaW4gZXhpc3RpbmcgZHJpdmVycy4KPiAKPiBXZSB3YW50IHRvIHVzZSB0aGF0IGZlYXR1cmUg
d2l0aG91dCBaT05FX0RFVklDRSBwYWdlcyBmb3IgRE1BLWJ1ZiBhcyB3ZWxsLgo+IAo+IEhvdyBo
YXJkIHdvdWxkIGl0IGJlIHRvIHNlcGFyYXRlIGVuYWJsaW5nIFAyUCBkZXRlY3Rpb24gKGUuZy4g
ZGlzdGFuY2UgCj4gYmV0d2VlbiB0d28gZGV2aWNlcykgZnJvbSB0aGlzPwoKUHJldHR5IGVhc3ku
IFAyUCBkZXRlY3Rpb24gaXMgcHJldHR5IG11Y2gganVzdCBwY2lfcDJwZG1hX2Rpc3RhbmNlKCkg
LAp3aGljaCBoYXMgbm90aGluZyB0byBkbyB3aXRoIHRoZSBaT05FX0RFVklDRSBzdXBwb3J0LgoK
KEFuZCB0aGUgZGlzdGFuY2UgZnVuY3Rpb24gbWFrZXMgdXNlIG9mIGEgbnVtYmVyIG9mIHN0YXRp
YyBmdW5jdGlvbnMKd2hpY2ggY291bGQgYmUgY29tYmluZWQgaW50byBhIHNpbXBsZXIgaW50ZXJm
YWNlLCBzaG91bGQgd2UgbmVlZCBpdC4pCgpMb2dhbgpfX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52
ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9s
aW51eC1udmRpbW0K
