Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B62AA22352283
 for <linux-nvdimm@lists.01.org>; Thu,  1 Mar 2018 11:27:59 -0800 (PST)
References: <20180228234006.21093-1-logang@deltatee.com>
 <90b658d9-da8a-af36-ad8f-a72ef0c6e3c1@grimberg.me>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <112b6d99-8aac-3d45-486e-ebea62fb8670@deltatee.com>
Date: Thu, 1 Mar 2018 12:33:59 -0700
MIME-Version: 1.0
In-Reply-To: <90b658d9-da8a-af36-ad8f-a72ef0c6e3c1@grimberg.me>
Content-Language: en-US
Subject: Re: [PATCH v2 00/10] Copy Offload in NVMe Fabrics with P2P PCI Memory
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Sagi Grimberg <sagi@grimberg.me>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alex Williamson <alex.williamson@redhat.com>, Keith Busch <keith.busch@intel.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

CgpPbiAwMS8wMy8xOCAwMzozMSBBTSwgU2FnaSBHcmltYmVyZyB3cm90ZToKPj4gKiBXZSBhbHNv
IHJlamVjdCB1c2luZyBkZXZpY2VzIHRoYXQgZW1wbG95ICdkbWFfdmlydF9vcHMnIHdoaWNoIHNo
b3VsZAo+PiDCoMKgIGZhaXJseSBzaW1wbHkgaGFuZGxlIEphc29uJ3MgY29uY2VybnMgdGhhdCB0
aGlzIHdvcmsgbWlnaHQgYnJlYWsgd2l0aAo+PiDCoMKgIHRoZSBIRkksIFFJQiBhbmQgcnhlIGRy
aXZlcnMgdGhhdCB1c2UgdGhlIHZpcnR1YWwgb3BzIHRvIGltcGxlbWVudAo+PiDCoMKgIHRoZWly
IG93biBzcGVjaWFsIERNQSBvcGVyYXRpb25zLgo+IAo+IFRoYXQncyBnb29kLCBidXQgd2hhdCB3
b3VsZCBoYXBwZW4gZm9yIHRoZXNlIGRldmljZXM/IHNpbXBseSBmYWlsIHRoZQo+IG1hcHBpbmcg
Y2F1c2luZyB0aGUgdWxwIHRvIGZhaWwgaXRzIHJkbWEgb3BlcmF0aW9uPyBJIHdvdWxkIHRoaW5r
Cj4gdGhhdCB3ZSBuZWVkIGEgY2FwYWJpbGl0eSBmbGFnIGZvciBkZXZpY2VzIHRoYXQgc3VwcG9y
dCBpdC4KCnBjaV9wMnBtZW1fZmluZCgpIHdpbGwgc2ltcGx5IG5vdCByZXR1cm4gYW55IGRldmlj
ZXMgd2hlbiBhbnkgY2xpZW50IAp0aGF0IHVzZXMgZG1hX3ZpcnRfb3BzLiBTbyBpbiB0aGUgTlZN
ZSB0YXJnZXQgY2FzZSBpdCBzaW1wbHkgd2lsbCBub3QgCnVzZSBQMlAgbWVtb3J5LgoKQW5kIGp1
c3QgaW4gY2FzZSwgcGNpX3AycGRtYV9tYXBfc2coKSB3aWxsIGFsc28gcmV0dXJuIDAgaWYgdGhl
IGRldmljZSAKcGFzc2VkIHRvIGl0IHVzZXMgZG1hX3ZpcnRfb3BzIGFzIHdlbGwuIFNvIGlmIHNv
bWVvbmUgYnlwYXNzZXMgCnBjaV9wMnBtZW1fZmluZCgpIHRoZXkgd2lsbCBnZXQgYSBmYWlsdXJl
IGR1cmluZyBtYXAuCgpMb2dhbgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4w
MS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
