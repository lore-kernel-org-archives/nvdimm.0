Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 96EF9203BBBAA
 for <linux-nvdimm@lists.01.org>; Tue,  8 May 2018 12:34:09 -0700 (PDT)
Date: Tue, 8 May 2018 13:34:07 -0600
From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH v4 04/14] PCI/P2PDMA: Clear ACS P2P flags for all
 devices behind switches
Message-ID: <20180508133407.57a46902@w520.home>
In-Reply-To: <3584a6ac-95c7-5d23-1859-aee30605776e@deltatee.com>
References: <20180423233046.21476-1-logang@deltatee.com>
 <20180423233046.21476-5-logang@deltatee.com>
 <20180507231306.GG161390@bhelgaas-glaptop.roam.corp.google.com>
 <e58e8d27-42a5-ca69-3b68-c409a2922cd1@amd.com>
 <0b4183ef-e720-204b-9e85-b9eaf7a4136a@deltatee.com>
 <a943a92d-15cd-fb2d-21c3-5e5cfccd9eff@amd.com>
 <3584a6ac-95c7-5d23-1859-aee30605776e@deltatee.com>
MIME-Version: 1.0
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
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?UTF-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <helgaas@kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>, Christian =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>
List-ID: <linux-nvdimm@lists.01.org>

T24gVHVlLCA4IE1heSAyMDE4IDEzOjEzOjQwIC0wNjAwCkxvZ2FuIEd1bnRob3JwZSA8bG9nYW5n
QGRlbHRhdGVlLmNvbT4gd3JvdGU6Cgo+IE9uIDA4LzA1LzE4IDEwOjUwIEFNLCBDaHJpc3RpYW4g
S8O2bmlnIHdyb3RlOgo+ID4gRS5nLiB0cmFuc2FjdGlvbnMgYXJlIGluaXRpYWxseSBzZW5kIHRv
IHRoZSByb290IGNvbXBsZXggZm9yIAo+ID4gdHJhbnNsYXRpb24sIHRoYXQncyBmb3Igc3VyZS4g
QnV0IGF0IGxlYXN0IGZvciBBTUQgR1BVcyB0aGUgcm9vdCBjb21wbGV4IAo+ID4gYW5zd2VycyB3
aXRoIHRoZSB0cmFuc2xhdGVkIGFkZHJlc3Mgd2hpY2ggaXMgdGhlbiBjYWNoZWQgaW4gdGhlIGRl
dmljZS4KPiA+IAo+ID4gU28gZnVydGhlciB0cmFuc2FjdGlvbnMgZm9yIHRoZSBzYW1lIGFkZHJl
c3MgcmFuZ2UgdGhlbiBnbyBkaXJlY3RseSB0byAKPiA+IHRoZSBkZXN0aW5hdGlvbi4gIAo+IAo+
IFNvdW5kcyBsaWtlIHlvdSBhcmUgcmVmZXJyaW5nIHRvIEFkZHJlc3MgVHJhbnNsYXRpb24gU2Vy
dmljZXMgKEFUUykuCj4gVGhpcyBpcyBxdWl0ZSBzZXBhcmF0ZSBmcm9tIEFDUyBhbmQsIHRvIG15
IGtub3dsZWRnZSwgaXNuJ3Qgd2lkZWx5Cj4gc3VwcG9ydGVkIGJ5IHN3aXRjaCBoYXJkd2FyZS4K
ClRoZXkgYXJlIG5vdCBzbyB1bnJlbGF0ZWQsIHNlZSB0aGUgQUNTIERpcmVjdCBUcmFuc2xhdGVk
IFAyUApjYXBhYmlsaXR5LCB3aGljaCBpbiBmYWN0IG11c3QgYmUgaW1wbGVtZW50ZWQgYnkgc3dp
dGNoIGRvd25zdHJlYW0KcG9ydHMgaW1wbGVtZW50aW5nIEFDUyBhbmQgd29ya3Mgc3BlY2lmaWNh
bGx5IHdpdGggQVRTLiAgVGhpcyBhcHBlYXJzIHRvCmJlIHRoZSB3YXkgdGhlIFBDSSBTSUcgd291
bGQgaW50ZW5kIGZvciBQMlAgdG8gb2NjdXIgd2l0aGluIGFuIElPTU1VCm1hbmFnZWQgdG9wb2xv
Z3ksIHJvdXRpbmcgcHJlLXRyYW5zbGF0ZWQgRE1BIGRpcmVjdGx5IGJldHdlZW4gcGVlcgpkZXZp
Y2VzIHdoaWxlIHJlcXVpcmluZyBub24tdHJhbnNsYXRlZCByZXF1ZXN0cyB0byBib3VuY2UgdGhy
b3VnaCB0aGUKSU9NTVUuICBSZWFsbHksIHdoYXQncyB0aGUgdmFsdWUgb2YgaGF2aW5nIGFuIEkv
TyB2aXJ0dWFsIGFkZHJlc3Mgc3BhY2UKcHJvdmlkZWQgYnkgYW4gSU9NTVUgaWYgd2UncmUgZ29p
bmcgdG8gYWxsb3cgcGh5c2ljYWwgRE1BIGJldHdlZW4KZG93bnN0cmVhbSBkZXZpY2VzLCBjb3Vs
ZG4ndCB3ZSBqdXN0IHR1cm4gb2ZmIHRoZSBJT01NVSBhbHRvZ2V0aGVyPyAgT2YKY291cnNlIEFU
UyBpcyBub3Qgd2l0aG91dCBob2xlcyBpdHNlbGYsIGJhc2ljYWxseSB0aGF0IHdlIHRydXN0IHRo
ZQplbmRwb2ludCdzIGltcGxlbWVudGF0aW9uIG9mIEFUUyBpbXBsaWNpdGx5LiAgVGhhbmtzLAoK
QWxleApfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51
eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9s
aXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
