Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2701620957B1F
 for <linux-nvdimm@lists.01.org>; Wed,  2 May 2018 08:56:46 -0700 (PDT)
References: <20180423233046.21476-1-logang@deltatee.com>
 <b8acf835-df94-9967-2327-8f0e39d88511@amd.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <805645c1-ea40-2e57-88eb-5dd34e579b2e@deltatee.com>
Date: Wed, 2 May 2018 09:56:09 -0600
MIME-Version: 1.0
In-Reply-To: <b8acf835-df94-9967-2327-8f0e39d88511@amd.com>
Content-Language: en-US
Subject: Re: [PATCH v4 00/14] Copy Offload in NVMe Fabrics with P2P PCI Memory
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
To: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alex Williamson <alex.williamson@redhat.com>, Keith Busch <keith.busch@intel.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

SGkgQ2hyaXN0aWFuLAoKT24gNS8yLzIwMTggNTo1MSBBTSwgQ2hyaXN0aWFuIEvDtm5pZyB3cm90
ZToKPiBpdCB3b3VsZCBiZSByYXRoZXIgbmljZSB0byBoYXZlIGlmIHlvdSBjb3VsZCBzZXBhcmF0
ZSBvdXQgdGhlIGZ1bmN0aW9ucyAKPiB0byBkZXRlY3QgaWYgcGVlcjJwZWVyIGlzIHBvc3NpYmxl
IGJldHdlZW4gdHdvIGRldmljZXMuCgpUaGlzIHdvdWxkIGVzc2VudGlhbGx5IGJlIHBjaV9wMnBk
bWFfZGlzdGFuY2UoKSBpbiB0aGUgZXhpc3RpbmcgCnBhdGNoc2V0LiBJdCByZXR1cm5zIHRoZSBz
dW0gb2YgdGhlIGRpc3RhbmNlIGJldHdlZW4gYSBsaXN0IG9mIGNsaWVudHMgCmFuZCBhIFAyUERN
QSBwcm92aWRlci4gSXQgcmV0dXJucyAtMSBpZiBwZWVyMnBlZXIgaXMgbm90IHBvc3NpYmxlIApi
ZXR3ZWVuIHRoZSBkZXZpY2VzIChwcmVzZW50bHkgdGhpcyBtZWFucyB0aGV5IGFyZSBub3QgYmVo
aW5kIHRoZSBzYW1lIApyb290IHBvcnQpLgoKTG9nYW4KX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1u
dmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8v
bGludXgtbnZkaW1tCg==
