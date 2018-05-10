Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM03-DM3-obe.outbound.protection.outlook.com
 (mail-dm3nam03on0089.outbound.protection.outlook.com [104.47.41.89])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6BE6520965DE8
 for <linux-nvdimm@lists.01.org>; Thu, 10 May 2018 05:53:09 -0700 (PDT)
Subject: Re: [PATCH v4 04/14] PCI/P2PDMA: Clear ACS P2P flags for all devices
 behind switches
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
 <4e0d0b96-ab02-2662-adf3-fa956efd294c@deltatee.com>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <2fc61d29-9eb4-d168-a3e5-955c36e5d821@amd.com>
Date: Thu, 10 May 2018 14:52:46 +0200
MIME-Version: 1.0
In-Reply-To: <4e0d0b96-ab02-2662-adf3-fa956efd294c@deltatee.com>
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
To: Logan Gunthorpe <logang@deltatee.com>, Stephen Bates <sbates@raithlin.com>, Jerome Glisse <jglisse@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Alex Williamson <alex.williamson@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <helgaas@kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

QW0gMDkuMDUuMjAxOCB1bSAxODo0NSBzY2hyaWViIExvZ2FuIEd1bnRob3JwZToKPgo+IE9uIDA5
LzA1LzE4IDA3OjQwIEFNLCBDaHJpc3RpYW4gS8O2bmlnIHdyb3RlOgo+PiBUaGUga2V5IHRha2Vh
d2F5IGlzIHRoYXQgd2hlbiBhbnkgZGV2aWNlIGhhcyBBVFMgZW5hYmxlZCB5b3UgY2FuJ3QKPj4g
ZGlzYWJsZSBBQ1Mgd2l0aG91dCBicmVha2luZyBpdCAoZXZlbiBpZiB5b3UgdW5wbHVnIGFuZCBy
ZXBsdWcgaXQpLgo+IEkgZG9uJ3QgZm9sbG93IGhvdyB5b3UgY2FtZSB0byB0aGlzIGNvbmNsdXNp
b24uLi4KPiAgIFRoZSBBQ1MgYml0cyB3ZSdkIGJlIHR1cm5pbmcgb2ZmIGFyZSB0aGUgb25lcyB0
aGF0IGZvcmNlIFRMUHMgYWRkcmVzc2VkCj4gYXQgYSBwZWVyIHRvIGdvIHRvIHRoZSBSQy4gSG93
ZXZlciwgQVRTIHRyYW5zbGF0aW9uIHBhY2tldHMgd2lsbCBiZQo+IGFkZHJlc3NlZCB0byBhbiB1
bnRyYW5zbGF0ZWQgYWRkcmVzcyB3aGljaCBhIHN3aXRjaCB3aWxsIG5vdCBpZGVudGlmeSBhcwo+
IGEgcGVlciBhZGRyZXNzIHNvIGl0IHNob3VsZCBzZW5kIHVwc3RyZWFtIHJlZ2FyZGxlc3MgdGhl
IHN0YXRlIG9mIHRoZQo+IEFDUyBSZXEvQ29tcCByZWRpcmVjdCBiaXRzLgoKV2h5IHdvdWxkIGEg
c3dpdGNoIG5vdCBpZGVudGlmeSB0aGF0IGFzIGEgcGVlciBhZGRyZXNzPyBXZSB1c2UgdGhlIFBB
U0lEIAp0b2dldGhlciB3aXRoIEFUUyB0byBpZGVudGlmeSB0aGUgYWRkcmVzcyBzcGFjZSB3aGlj
aCBhIHRyYW5zYWN0aW9uIApzaG91bGQgdXNlLgoKSWYgSSdtIG5vdCBjb21wbGV0ZWx5IG1pc3Rh
a2VuIHdoZW4geW91IGRpc2FibGUgQUNTIGl0IGlzIHBlcmZlY3RseSAKcG9zc2libGUgdGhhdCBh
IGJyaWRnZSBpZGVudGlmaWVzIGEgdHJhbnNhY3Rpb24gYXMgYmVsb25naW5nIHRvIGEgcGVlciAK
YWRkcmVzcywgd2hpY2ggaXNuJ3Qgd2hhdCB3ZSB3YW50IGhlcmUuCgpDaHJpc3RpYW4uCgo+Cj4g
T25jZSB0aGUgdHJhbnNsYXRpb24gY29tZXMgYmFjaywgdGhlIEFUUyBlbmRwb2ludCBzaG91bGQg
c2VuZCB0aGUgVExQIHRvCj4gdGhlIHBlZXIgYWRkcmVzcyB3aXRoIHRoZSBBVCBwYWNrZXQgdHlw
ZSBhbmQgaXQgd2lsbCBiZSBkaXJlY3RlZCB0byB0aGUKPiBwZWVyIHByb3ZpZGVkIHRoZSBEaXJl
Y3QgVHJhbnNsYXRlZCBiaXQgaXMgc2V0IChvciB0aGUgcmVkaXJlY3QgYml0cyBhcmUKPiB1bnNl
dCkuCj4KPiBJIGNhbid0IHNlZSBob3cgdHVybmluZyBvZmYgdGhlIFJlcS9Db21wIHJlZGlyZWN0
IGJpdHMgY291bGQgYnJlYWsKPiBhbnl0aGluZyBleGNlcHQgZm9yIHRoZSBpc29sYXRpb24gdGhl
eSBwcm92aWRlLgo+Cj4gTG9nYW4KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3Rz
LjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGlt
bQo=
