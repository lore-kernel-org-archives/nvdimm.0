Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 34BFE20965DDE
 for <linux-nvdimm@lists.01.org>; Wed,  9 May 2018 09:45:41 -0700 (PDT)
References: <20180423233046.21476-5-logang@deltatee.com>
 <20180507231306.GG161390@bhelgaas-glaptop.roam.corp.google.com>
 <e58e8d27-42a5-ca69-3b68-c409a2922cd1@amd.com>
 <0b4183ef-e720-204b-9e85-b9eaf7a4136a@deltatee.com>
 <a943a92d-15cd-fb2d-21c3-5e5cfccd9eff@amd.com>
 <3584a6ac-95c7-5d23-1859-aee30605776e@deltatee.com>
 <20180508133407.57a46902@w520.home>
 <5fc9b1c1-9208-06cc-0ec5-1f54c2520494@deltatee.com>
 <20180508141331.7cd737cb@w520.home>
 <d70cf286-f7b7-99a5-1042-022506298fed@deltatee.com>
 <20180508205005.GC15608@redhat.com>
 <7FFB9603-DF9F-4441-82E9-46037CB6C0DE@raithlin.com>
 <a1a36f88-fbfb-b5ee-6dcb-5c5bb96132dd@amd.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <4e0d0b96-ab02-2662-adf3-fa956efd294c@deltatee.com>
Date: Wed, 9 May 2018 10:45:16 -0600
MIME-Version: 1.0
In-Reply-To: <a1a36f88-fbfb-b5ee-6dcb-5c5bb96132dd@amd.com>
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
To: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>, Stephen Bates <sbates@raithlin.com>, Jerome Glisse <jglisse@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Alex Williamson <alex.williamson@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <helgaas@kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

CgpPbiAwOS8wNS8xOCAwNzo0MCBBTSwgQ2hyaXN0aWFuIEvDtm5pZyB3cm90ZToKPiBUaGUga2V5
IHRha2Vhd2F5IGlzIHRoYXQgd2hlbiBhbnkgZGV2aWNlIGhhcyBBVFMgZW5hYmxlZCB5b3UgY2Fu
J3QgCj4gZGlzYWJsZSBBQ1Mgd2l0aG91dCBicmVha2luZyBpdCAoZXZlbiBpZiB5b3UgdW5wbHVn
IGFuZCByZXBsdWcgaXQpLgoKSSBkb24ndCBmb2xsb3cgaG93IHlvdSBjYW1lIHRvIHRoaXMgY29u
Y2x1c2lvbi4uLgogVGhlIEFDUyBiaXRzIHdlJ2QgYmUgdHVybmluZyBvZmYgYXJlIHRoZSBvbmVz
IHRoYXQgZm9yY2UgVExQcyBhZGRyZXNzZWQKYXQgYSBwZWVyIHRvIGdvIHRvIHRoZSBSQy4gSG93
ZXZlciwgQVRTIHRyYW5zbGF0aW9uIHBhY2tldHMgd2lsbCBiZQphZGRyZXNzZWQgdG8gYW4gdW50
cmFuc2xhdGVkIGFkZHJlc3Mgd2hpY2ggYSBzd2l0Y2ggd2lsbCBub3QgaWRlbnRpZnkgYXMKYSBw
ZWVyIGFkZHJlc3Mgc28gaXQgc2hvdWxkIHNlbmQgdXBzdHJlYW0gcmVnYXJkbGVzcyB0aGUgc3Rh
dGUgb2YgdGhlCkFDUyBSZXEvQ29tcCByZWRpcmVjdCBiaXRzLgoKT25jZSB0aGUgdHJhbnNsYXRp
b24gY29tZXMgYmFjaywgdGhlIEFUUyBlbmRwb2ludCBzaG91bGQgc2VuZCB0aGUgVExQIHRvCnRo
ZSBwZWVyIGFkZHJlc3Mgd2l0aCB0aGUgQVQgcGFja2V0IHR5cGUgYW5kIGl0IHdpbGwgYmUgZGly
ZWN0ZWQgdG8gdGhlCnBlZXIgcHJvdmlkZWQgdGhlIERpcmVjdCBUcmFuc2xhdGVkIGJpdCBpcyBz
ZXQgKG9yIHRoZSByZWRpcmVjdCBiaXRzIGFyZQp1bnNldCkuCgpJIGNhbid0IHNlZSBob3cgdHVy
bmluZyBvZmYgdGhlIFJlcS9Db21wIHJlZGlyZWN0IGJpdHMgY291bGQgYnJlYWsKYW55dGhpbmcg
ZXhjZXB0IGZvciB0aGUgaXNvbGF0aW9uIHRoZXkgcHJvdmlkZS4KCkxvZ2FuCl9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5n
IGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWls
bWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
