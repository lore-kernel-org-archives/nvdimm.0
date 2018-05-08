Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CE4D8207E53FF
 for <linux-nvdimm@lists.01.org>; Tue,  8 May 2018 09:28:26 -0700 (PDT)
References: <20180423233046.21476-1-logang@deltatee.com>
 <20180423233046.21476-5-logang@deltatee.com>
 <20180507231306.GG161390@bhelgaas-glaptop.roam.corp.google.com>
 <e58e8d27-42a5-ca69-3b68-c409a2922cd1@amd.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <0b4183ef-e720-204b-9e85-b9eaf7a4136a@deltatee.com>
Date: Tue, 8 May 2018 10:27:56 -0600
MIME-Version: 1.0
In-Reply-To: <e58e8d27-42a5-ca69-3b68-c409a2922cd1@amd.com>
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

CgpPbiAwOC8wNS8xOCAwMToxNyBBTSwgQ2hyaXN0aWFuIEvDtm5pZyB3cm90ZToKPiBBTUQgQVBV
cyBtYW5kYXRvcnkgbmVlZCB0aGUgQUNTIGZsYWcgc2V0IGZvciB0aGUgR1BVIGludGVncmF0ZWQg
aW4gdGhlIAo+IENQVSB3aGVuIElPTU1VIGlzIGVuYWJsZWQgb3Igb3RoZXJ3aXNlIHlvdSB3aWxs
IGJyZWFrIFNWTS4KCldlbGwsIGdpdmVuIHRoYXQgdGhlIGN1cnJlbnQgc2V0IG9ubHkgZGlzYWJs
ZXMgQUNTIGJpdHMgb24gYnJpZGdlcwoocHJldmlvdXMgdmVyc2lvbnMgd2VyZSBvbmx5IG9uIHN3
aXRjaGVzKSB0aGlzIHNob3VsZG4ndCBiZSBhbiBpc3N1ZSBmb3IKaW50ZWdyYXRlZCBkZXZpY2Vz
LiBXZSBkbyBub3QgZGlzYWJsZSBBQ1MgZmxhZ3MgZ2xvYmFsbHkuCgo+IEFuZCB3aGF0IGV4YWN0
bHkgaXMgdGhlIHByb2JsZW0gaGVyZT8gSSdtIGN1cnJlbnRseSB0ZXN0aW5nIFAyUCB3aXRoIAo+
IEdQVXMgaW4gZGlmZmVyZW50IElPTU1VIGRvbWFpbnMgYW5kIGF0IGxlYXN0IHdpdGggQU1EIElP
TU1VcyB0aGF0IHdvcmtzIAo+IHBlcmZlY3RseSBmaW5lLgoKSW4gYWRkaXRpb24gdG8gU3RlcGhl
bidzIGNvbW1lbnRzLCBzZWVpbmcgd2UndmUgZXN0YWJsaXNoZWQgYSBnZW5lcmFsCm5lZWQgdG8g
YXZvaWQgdGhlIHJvb3QgY29tcGxleCAodW50aWwgd2UgaGF2ZSBhIHdoaXRlbGlzdCBhdCBsZWFz
dCkgd2UKbXVzdCBoYXZlIEFDUyBkaXNhYmxlZCBhbG9uZyB0aGUgcGF0aCBiZXR3ZWVuIHRoZSBk
ZXZpY2VzLiBPdGhlcndpc2UsCmFsbCBUTFBzIHdpbGwgZ28gdGhyb3VnaCB0aGUgcm9vdCBjb21w
bGV4IGFuZCBpZiB0aGVyZSBpcyBubyBzdXBwb3J0IGl0CndpbGwgZmFpbC4KCklmIHRoZSBjb25z
ZW5zdXMgaXMgd2Ugd2FudCBhIGNvbW1hbmQgbGluZSBvcHRpb24sIHRoZW4gc28gYmUgaXQuIEJ1
dAp3ZSdsbCBoYXZlIHRvIGRlbnkgcHJldHR5IG11Y2ggYWxsIFAyUCB0cmFuc2FjdGlvbnMgdW5s
ZXNzIHRoZSB1c2VyCmNvcnJlY3RseSBkaXNhYmxlcyBBQ1MgYWxvbmcgdGhlIHBhdGggdXNpbmcg
dGhlIGNvbW1hbmQgbGluZSBvcHRpb24gYW5kCnRoaXMgaXMgcmVhbGx5IGFubm95aW5nIGZvciB1
c2VycyBvZiB0aGlzIGZ1bmN0aW9uYWxpdHkgdG8gdW5kZXJzdGFuZApob3cgdG8gZG8gdGhhdCBj
b3JyZWN0bHkuCgpMb2dhbgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5v
cmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
