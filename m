Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0EB42203BBBAA
 for <linux-nvdimm@lists.01.org>; Tue,  8 May 2018 12:14:08 -0700 (PDT)
References: <20180423233046.21476-1-logang@deltatee.com>
 <20180423233046.21476-5-logang@deltatee.com>
 <20180507231306.GG161390@bhelgaas-glaptop.roam.corp.google.com>
 <e58e8d27-42a5-ca69-3b68-c409a2922cd1@amd.com>
 <0b4183ef-e720-204b-9e85-b9eaf7a4136a@deltatee.com>
 <a943a92d-15cd-fb2d-21c3-5e5cfccd9eff@amd.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <3584a6ac-95c7-5d23-1859-aee30605776e@deltatee.com>
Date: Tue, 8 May 2018 13:13:40 -0600
MIME-Version: 1.0
In-Reply-To: <a943a92d-15cd-fb2d-21c3-5e5cfccd9eff@amd.com>
Content-Language: en-US
Subject: Re: [PATCH v4 04/14] PCI/P2PDMA: Clear ACS P2P flags for all devices
 behind switches
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
To: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>, Bjorn Helgaas <helgaas@kernel.org>, Alex Williamson <alex.williamson@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

CgpPbiAwOC8wNS8xOCAxMDo1MCBBTSwgQ2hyaXN0aWFuIEvDtm5pZyB3cm90ZToKPiBFLmcuIHRy
YW5zYWN0aW9ucyBhcmUgaW5pdGlhbGx5IHNlbmQgdG8gdGhlIHJvb3QgY29tcGxleCBmb3IgCj4g
dHJhbnNsYXRpb24sIHRoYXQncyBmb3Igc3VyZS4gQnV0IGF0IGxlYXN0IGZvciBBTUQgR1BVcyB0
aGUgcm9vdCBjb21wbGV4IAo+IGFuc3dlcnMgd2l0aCB0aGUgdHJhbnNsYXRlZCBhZGRyZXNzIHdo
aWNoIGlzIHRoZW4gY2FjaGVkIGluIHRoZSBkZXZpY2UuCj4gCj4gU28gZnVydGhlciB0cmFuc2Fj
dGlvbnMgZm9yIHRoZSBzYW1lIGFkZHJlc3MgcmFuZ2UgdGhlbiBnbyBkaXJlY3RseSB0byAKPiB0
aGUgZGVzdGluYXRpb24uCgpTb3VuZHMgbGlrZSB5b3UgYXJlIHJlZmVycmluZyB0byBBZGRyZXNz
IFRyYW5zbGF0aW9uIFNlcnZpY2VzIChBVFMpLgpUaGlzIGlzIHF1aXRlIHNlcGFyYXRlIGZyb20g
QUNTIGFuZCwgdG8gbXkga25vd2xlZGdlLCBpc24ndCB3aWRlbHkKc3VwcG9ydGVkIGJ5IHN3aXRj
aCBoYXJkd2FyZS4KCkxvZ2FuCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAx
Lm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
