Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 87E942277AF2D
 for <linux-nvdimm@lists.01.org>; Thu,  3 May 2018 11:43:45 -0700 (PDT)
References: <20180423233046.21476-1-logang@deltatee.com>
 <b8acf835-df94-9967-2327-8f0e39d88511@amd.com>
 <805645c1-ea40-2e57-88eb-5dd34e579b2e@deltatee.com>
 <3e4e0126-f444-8d88-6793-b5eb97c61f76@amd.com>
 <ce2e5351-f32a-bd80-1c77-b7fc38842175@deltatee.com>
 <38d866cf-f7b4-7118-d737-5a5dcd9f3784@amd.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <2d59aa02-f2fa-bd88-1b6c-923117a6ad28@deltatee.com>
Date: Thu, 3 May 2018 12:43:21 -0600
MIME-Version: 1.0
In-Reply-To: <38d866cf-f7b4-7118-d737-5a5dcd9f3784@amd.com>
Content-Language: en-US
Subject: Re: [PATCH v4 00/14] Copy Offload in NVMe Fabrics with P2P PCI Memory
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
Cc: Jens Axboe <axboe@kernel.dk>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alex Williamson <alex.williamson@redhat.com>, Keith Busch <keith.busch@intel.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

CgpPbiAwMy8wNS8xOCAxMToyOSBBTSwgQ2hyaXN0aWFuIEvDtm5pZyB3cm90ZToKPiBPaywgdGhh
dCBpcyB0aGUgcG9pbnQgd2hlcmUgSSdtIHN0dWNrLiBXaHkgZG8gd2UgbmVlZCB0aGF0IGluIG9u
ZSAKPiBmdW5jdGlvbiBjYWxsIGluIHRoZSBQQ0llIHN1YnN5c3RlbT8KPiAKPiBUaGUgcHJvYmxl
bSBhdCBsZWFzdCB3aXRoIEdQVXMgaXMgdGhhdCB3ZSBzZXJpb3VzbHkgZG9uJ3QgaGF2ZSB0aGF0
IAo+IGluZm9ybWF0aW9uIGhlcmUsIGNhdXNlIHRoZSBQQ0kgc3Vic3lzdGVtIG1pZ2h0IG5vdCBi
ZSBhd2FyZSBvZiBhbGwgdGhlIAo+IGludGVyY29ubmVjdGlvbnMuCj4gCj4gRm9yIGV4YW1wbGUg
aXQgaXNuJ3QgdW5jb21tb24gdG8gcHV0IG11bHRpcGxlIEdQVXMgb24gb25lIGJvYXJkLiBUbyB0
aGUgCj4gUENJIHN1YnN5c3RlbSB0aGF0IGxvb2tzIGxpa2Ugc2VwYXJhdGUgZGV2aWNlcywgYnV0
IGluIHJlYWxpdHkgYWxsIEdQVXMgCj4gYXJlIGludGVyY29ubmVjdGVkIGFuZCBjYW4gYWNjZXNz
IGVhY2ggb3RoZXJzIG1lbW9yeSBkaXJlY3RseSB3aXRob3V0IAo+IGdvaW5nIG92ZXIgdGhlIFBD
SWUgYnVzLgo+IAo+IEkgc2VyaW91c2x5IGRvbid0IHdhbnQgdG8gbW9kZWwgdGhhdCBpbiB0aGUg
UENJIHN1YnN5c3RlbSwgYnV0IHJhdGhlciAKPiB0aGUgZHJpdmVyLiBUaGF0J3Mgd2h5IGl0IGZl
ZWxzIGxpa2UgYSBtaXN0YWtlIHRvIG1lIHRvIHB1c2ggYWxsIHRoYXQgCj4gaW50byB0aGUgUENJ
IGZ1bmN0aW9uLgoKSHVoPyBJJ20gbG9zdC4gSWYgeW91IGhhdmUgYSBidW5jaCBvZiBQQ0kgZGV2
aWNlcyB5b3UgY2FuIHNlbmQgdGhlbSBhcyBhCmxpc3QgdG8gdGhpcyBBUEksIGlmIHlvdSB3YW50
LiBJZiB0aGUgZHJpdmVyIGlzIF9zdXJlXyB0aGV5IGFyZSBhbGwgdGhlCnNhbWUsIHlvdSBvbmx5
IGhhdmUgdG8gc2VuZCBvbmUuIEluIHlvdXIgdGVybWlub2xvZ3ksIHlvdSdkIGp1c3QgaGF2ZSB0
bwpjYWxsIHRoZSBpbnRlcmZhY2Ugd2l0aDoKCnBjaV9wMnBkbWFfZGlzdGFuY2UodGFyZ2V0LCBb
aW5pdGlhdG9yLCB0YXJnZXRdKQoKPiBXaHkgY2FuJ3Qgd2UgbW9kZWwgdGhhdCBhcyB0d28gc2Vw
YXJhdGUgdHJhbnNhY3Rpb25zPwoKWW91IGNvdWxkLCBidXQgdGhpcyBpcyBtb3JlIGNvbnZlbmll
bnQgZm9yIHVzZXJzIG9mIHRoZSBBUEkgdGhhdCBuZWVkIHRvCmRlYWwgd2l0aCBtdWx0aXBsZSBk
ZXZpY2VzIChhbmQgbWFuYWdlIGRldmljZXMgdGhhdCBtYXkgYmUgYWRkZWQgb3IKcmVtb3ZlZCBh
dCBhbnkgdGltZSkuCgo+IFllYWgsIHNhbWUgZm9yIG1lLiBJZiBCam9ybiBpcyBvayB3aXRoIHRo
YXQgc3BlY2lhbGl6ZWQgTlZNIGZ1bmN0aW9ucyAKPiB0aGF0IEknbSBmaW5lIHdpdGggdGhhdCBh
cyB3ZWxsLgo+IAo+IEkgdGhpbmsgaXQgd291bGQganVzdCBiZSBtb3JlIGNvbnZlbmllbnQgd2hl
biB3ZSBjYW4gY29tZSB1cCB3aXRoIAo+IGZ1bmN0aW9ucyB3aGljaCBjYW4gaGFuZGxlIGFsbCB1
c2UgY2FzZXMsIGNhdXNlIHRoZXJlIHN0aWxsIHNlZW1zIHRvIGJlIAo+IGEgbG90IG9mIHNpbWls
YXJpdGllcy4KClRoZSB3YXkgaXQncyBpbXBsZW1lbnRlZCBpcyBtb3JlIGdlbmVyYWwgYW5kIGNh
biBoYW5kbGUgYWxsIHVzZSBjYXNlcy4KWW91IGFyZSBhcmd1aW5nIGZvciBhIGZ1bmN0aW9uIHRo
YXQgY2FuIGhhbmRsZSB5b3VyIGNhc2UgKGFsYmVpdCB3aXRoIGEKYml0IG1vcmUgZnVzcykgYnV0
IGNhbid0IGhhbmRsZSBtaW5lIGFuZCBpcyB0aGVyZWZvcmUgbGVzcyBnZW5lcmFsLgpDYWxsaW5n
IG15IGludGVyZmFjZSBzcGVjaWFsaXplZCBpcyB3cm9uZy4KCkxvZ2FuCl9fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxp
c3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFu
L2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
