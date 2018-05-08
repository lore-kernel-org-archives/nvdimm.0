Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM02-BL2-obe.outbound.protection.outlook.com
 (mail-bl2nam02on0048.outbound.protection.outlook.com [104.47.38.48])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1E347207E540E
 for <linux-nvdimm@lists.01.org>; Tue,  8 May 2018 09:50:41 -0700 (PDT)
Subject: Re: [PATCH v4 04/14] PCI/P2PDMA: Clear ACS P2P flags for all devices
 behind switches
References: <20180423233046.21476-1-logang@deltatee.com>
 <20180423233046.21476-5-logang@deltatee.com>
 <20180507231306.GG161390@bhelgaas-glaptop.roam.corp.google.com>
 <e58e8d27-42a5-ca69-3b68-c409a2922cd1@amd.com>
 <0b4183ef-e720-204b-9e85-b9eaf7a4136a@deltatee.com>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <a943a92d-15cd-fb2d-21c3-5e5cfccd9eff@amd.com>
Date: Tue, 8 May 2018 18:50:25 +0200
MIME-Version: 1.0
In-Reply-To: <0b4183ef-e720-204b-9e85-b9eaf7a4136a@deltatee.com>
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
To: Logan Gunthorpe <logang@deltatee.com>, Bjorn Helgaas <helgaas@kernel.org>, Alex Williamson <alex.williamson@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

QW0gMDguMDUuMjAxOCB1bSAxODoyNyBzY2hyaWViIExvZ2FuIEd1bnRob3JwZToKPgo+IE9uIDA4
LzA1LzE4IDAxOjE3IEFNLCBDaHJpc3RpYW4gS8O2bmlnIHdyb3RlOgo+PiBBTUQgQVBVcyBtYW5k
YXRvcnkgbmVlZCB0aGUgQUNTIGZsYWcgc2V0IGZvciB0aGUgR1BVIGludGVncmF0ZWQgaW4gdGhl
Cj4+IENQVSB3aGVuIElPTU1VIGlzIGVuYWJsZWQgb3Igb3RoZXJ3aXNlIHlvdSB3aWxsIGJyZWFr
IFNWTS4KPiBXZWxsLCBnaXZlbiB0aGF0IHRoZSBjdXJyZW50IHNldCBvbmx5IGRpc2FibGVzIEFD
UyBiaXRzIG9uIGJyaWRnZXMKPiAocHJldmlvdXMgdmVyc2lvbnMgd2VyZSBvbmx5IG9uIHN3aXRj
aGVzKSB0aGlzIHNob3VsZG4ndCBiZSBhbiBpc3N1ZSBmb3IKPiBpbnRlZ3JhdGVkIGRldmljZXMu
IFdlIGRvIG5vdCBkaXNhYmxlIEFDUyBmbGFncyBnbG9iYWxseS4KCk9rLCB0aGF0IGlzIGF0IGxl
YXN0IGEgc3RlcCBpbiB0aGUgcmlnaHQgZGlyZWN0aW9uLiBCdXQgSSB0aGluayB3ZSAKc2VyaW91
c2x5IG5lZWQgdG8gdGVzdCB0aGF0IGZvciBzaWRlIGVmZmVjdHMuCgo+Cj4+IEFuZCB3aGF0IGV4
YWN0bHkgaXMgdGhlIHByb2JsZW0gaGVyZT8gSSdtIGN1cnJlbnRseSB0ZXN0aW5nIFAyUCB3aXRo
Cj4+IEdQVXMgaW4gZGlmZmVyZW50IElPTU1VIGRvbWFpbnMgYW5kIGF0IGxlYXN0IHdpdGggQU1E
IElPTU1VcyB0aGF0IHdvcmtzCj4+IHBlcmZlY3RseSBmaW5lLgo+IEluIGFkZGl0aW9uIHRvIFN0
ZXBoZW4ncyBjb21tZW50cywgc2VlaW5nIHdlJ3ZlIGVzdGFibGlzaGVkIGEgZ2VuZXJhbAo+IG5l
ZWQgdG8gYXZvaWQgdGhlIHJvb3QgY29tcGxleCAodW50aWwgd2UgaGF2ZSBhIHdoaXRlbGlzdCBh
dCBsZWFzdCkgd2UKPiBtdXN0IGhhdmUgQUNTIGRpc2FibGVkIGFsb25nIHRoZSBwYXRoIGJldHdl
ZW4gdGhlIGRldmljZXMuIE90aGVyd2lzZSwKPiBhbGwgVExQcyB3aWxsIGdvIHRocm91Z2ggdGhl
IHJvb3QgY29tcGxleCBhbmQgaWYgdGhlcmUgaXMgbm8gc3VwcG9ydCBpdAo+IHdpbGwgZmFpbC4K
CldlbGwgSSdtIG5vdCBhbiBleHBlcnQgb24gdGhpcywgYnV0IGlmIEknbSBub3QgY29tcGxldGVs
eSBtaXN0YWtlbiB0aGF0IAppcyBub3QgY29ycmVjdC4KCkUuZy4gdHJhbnNhY3Rpb25zIGFyZSBp
bml0aWFsbHkgc2VuZCB0byB0aGUgcm9vdCBjb21wbGV4IGZvciAKdHJhbnNsYXRpb24sIHRoYXQn
cyBmb3Igc3VyZS4gQnV0IGF0IGxlYXN0IGZvciBBTUQgR1BVcyB0aGUgcm9vdCBjb21wbGV4IAph
bnN3ZXJzIHdpdGggdGhlIHRyYW5zbGF0ZWQgYWRkcmVzcyB3aGljaCBpcyB0aGVuIGNhY2hlZCBp
biB0aGUgZGV2aWNlLgoKU28gZnVydGhlciB0cmFuc2FjdGlvbnMgZm9yIHRoZSBzYW1lIGFkZHJl
c3MgcmFuZ2UgdGhlbiBnbyBkaXJlY3RseSB0byAKdGhlIGRlc3RpbmF0aW9uLgoKV2hhdCB5b3Ug
ZG9uJ3Qgd2FudCBpcyBkZXZpY2UgaXNvbGF0aW9uLCBjYXVzZSBpbiB0aGlzIGNhc2UgdGhlIHJv
b3QgCmNvbXBsZXggaGFuZGxlcyB0aGUgdHJhbnNhY3Rpb24gdGhlbXNlbHZlcy4gSUlSQyB0aGVy
ZSB3aGVyZSBhbHNvIApzb21ldGhpbmcgbGlrZSAiZm9yY2VfaXNvbGF0aW9uIiBhbmQgIm5vYnlw
YXNzIiBwYXJhbWV0ZXJzIGZvciB0aGUgSU9NTVUgCnRvIGNvbnRyb2wgdGhhdCBiZWhhdmlvci4K
Ckl0J3MgYWxyZWFkeSBsYXRlIGhlcmUsIGJ1dCBnb2luZyB0byBkaWcgdXAgdGhlIGRvY3VtZW50
YXRpb24gZm9yIHRoYXQgCnRvbW9ycm93IGFuZC9vciBjb250YWN0IGEgaGFyZHdhcmUgZW5naW5l
ZXIgaW52b2x2ZWQgaW4gdGhlIEFDUyBzcGVjLgoKUmVnYXJkcywKQ2hyaXN0aWFuLgoKPgo+IElm
IHRoZSBjb25zZW5zdXMgaXMgd2Ugd2FudCBhIGNvbW1hbmQgbGluZSBvcHRpb24sIHRoZW4gc28g
YmUgaXQuIEJ1dAo+IHdlJ2xsIGhhdmUgdG8gZGVueSBwcmV0dHkgbXVjaCBhbGwgUDJQIHRyYW5z
YWN0aW9ucyB1bmxlc3MgdGhlIHVzZXIKPiBjb3JyZWN0bHkgZGlzYWJsZXMgQUNTIGFsb25nIHRo
ZSBwYXRoIHVzaW5nIHRoZSBjb21tYW5kIGxpbmUgb3B0aW9uIGFuZAo+IHRoaXMgaXMgcmVhbGx5
IGFubm95aW5nIGZvciB1c2VycyBvZiB0aGlzIGZ1bmN0aW9uYWxpdHkgdG8gdW5kZXJzdGFuZAo+
IGhvdyB0byBkbyB0aGF0IGNvcnJlY3RseS4KPgo+IExvZ2FuCgpfX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0Ckxp
bnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0
aW5mby9saW51eC1udmRpbW0K
