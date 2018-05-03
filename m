Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM02-SN1-obe.outbound.protection.outlook.com
 (mail-sn1nam02on0086.outbound.protection.outlook.com [104.47.36.86])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C976A2063E310
 for <linux-nvdimm@lists.01.org>; Thu,  3 May 2018 02:05:40 -0700 (PDT)
Subject: Re: [PATCH v4 00/14] Copy Offload in NVMe Fabrics with P2P PCI Memory
References: <20180423233046.21476-1-logang@deltatee.com>
 <b8acf835-df94-9967-2327-8f0e39d88511@amd.com>
 <805645c1-ea40-2e57-88eb-5dd34e579b2e@deltatee.com>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <3e4e0126-f444-8d88-6793-b5eb97c61f76@amd.com>
Date: Thu, 3 May 2018 11:05:21 +0200
MIME-Version: 1.0
In-Reply-To: <805645c1-ea40-2e57-88eb-5dd34e579b2e@deltatee.com>
Content-Language: en-US
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
To: Logan Gunthorpe <logang@deltatee.com>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alex Williamson <alex.williamson@redhat.com>, Keith Busch <keith.busch@intel.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

QW0gMDIuMDUuMjAxOCB1bSAxNzo1NiBzY2hyaWViIExvZ2FuIEd1bnRob3JwZToKPiBIaSBDaHJp
c3RpYW4sCj4KPiBPbiA1LzIvMjAxOCA1OjUxIEFNLCBDaHJpc3RpYW4gS8O2bmlnIHdyb3RlOgo+
PiBpdCB3b3VsZCBiZSByYXRoZXIgbmljZSB0byBoYXZlIGlmIHlvdSBjb3VsZCBzZXBhcmF0ZSBv
dXQgdGhlIAo+PiBmdW5jdGlvbnMgdG8gZGV0ZWN0IGlmIHBlZXIycGVlciBpcyBwb3NzaWJsZSBi
ZXR3ZWVuIHR3byBkZXZpY2VzLgo+Cj4gVGhpcyB3b3VsZCBlc3NlbnRpYWxseSBiZSBwY2lfcDJw
ZG1hX2Rpc3RhbmNlKCkgaW4gdGhlIGV4aXN0aW5nIAo+IHBhdGNoc2V0LiBJdCByZXR1cm5zIHRo
ZSBzdW0gb2YgdGhlIGRpc3RhbmNlIGJldHdlZW4gYSBsaXN0IG9mIGNsaWVudHMgCj4gYW5kIGEg
UDJQRE1BIHByb3ZpZGVyLiBJdCByZXR1cm5zIC0xIGlmIHBlZXIycGVlciBpcyBub3QgcG9zc2li
bGUgCj4gYmV0d2VlbiB0aGUgZGV2aWNlcyAocHJlc2VudGx5IHRoaXMgbWVhbnMgdGhleSBhcmUg
bm90IGJlaGluZCB0aGUgc2FtZSAKPiByb290IHBvcnQpLgoKT2ssIEknbSBzdGlsbCBtaXNzaW5n
IHRoZSBiaWcgcGljdHVyZSBoZXJlLiBGaXJzdCBxdWVzdGlvbiBpcyB3aGF0IGlzIAp0aGUgUDJQ
RE1BIHByb3ZpZGVyPwoKU2Vjb25kIHF1ZXN0aW9uIGlzIGhvdyB0byB5b3Ugd2FudCB0byBoYW5k
bGUgdGhpbmdzIHdoZW4gZGV2aWNlIGFyZSBub3QgCmJlaGluZCB0aGUgc2FtZSByb290IHBvcnQg
KHdoaWNoIGlzIHBlcmZlY3RseSBwb3NzaWJsZSBpbiB0aGUgY2FzZXMgSSAKZGVhbCB3aXRoKT8K
ClRoaXJkIHF1ZXN0aW9uIHdoeSBtdWx0aXBsZSBjbGllbnRzPyBUaGF0IGZlZWxzIGEgYml0IGxp
a2UgeW91IGFyZSAKcHVzaGluZyBzb21ldGhpbmcgc3BlY2lhbCB0byB5b3VyIHVzZSBjYXNlIGlu
dG8gdGhlIGNvbW1vbiBQQ0kgCnN1YnN5c3RlbS4gU29tZXRoaW5nIHdoaWNoIHVzdWFsbHkgaXNu
J3QgYSBnb29kIGlkZWEuCgoKCkFzIGZhciBhcyBJIGNhbiBzZWUgd2UgbmVlZCBhIGZ1bmN0aW9u
IHdoaWNoIHJldHVybiB0aGUgZGlzdGFuY2UgYmV0d2VlbiAKYSBpbml0aWF0b3IgYW5kIHRhcmdl
dCBkZXZpY2UuIFRoaXMgZnVuY3Rpb24gdGhlbiByZXR1cm5zIC0xIGlmIHRoZSAKdHJhbnNhY3Rp
b24gY2FuJ3QgYmUgbWFkZSBhbmQgYSBwb3NpdGl2ZSB2YWx1ZSBvdGhlcndpc2UuCgpXZSBhbHNv
IG5lZWQgdG8gZ2l2ZSB0aGUgZGlyZWN0aW9uIG9mIHRoZSB0cmFuc2FjdGlvbiBhbmQgaGF2ZSBh
IAp3aGl0ZWxpc3Qgcm9vdCBjb21wbGV4IFBDSS1JRHMgd2hpY2ggY2FuIGhhbmRsZSBQMlAgdHJh
bnNhY3Rpb25zIGZyb20gCmRpZmZlcmVudCBwb3J0cyBmb3IgYSBjZXJ0YWluIERNQSBkaXJlY3Rp
b24uCgoKQ2hyaXN0aWFuLgoKPgo+IExvZ2FuCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGlt
bUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51
eC1udmRpbW0K
