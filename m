Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A863C210E0F81
 for <linux-nvdimm@lists.01.org>; Fri, 11 May 2018 15:55:34 -0700 (PDT)
References: <20180423233046.21476-5-logang@deltatee.com>
 <3584a6ac-95c7-5d23-1859-aee30605776e@deltatee.com>
 <20180508133407.57a46902@w520.home>
 <5fc9b1c1-9208-06cc-0ec5-1f54c2520494@deltatee.com>
 <20180508141331.7cd737cb@w520.home>
 <d70cf286-f7b7-99a5-1042-022506298fed@deltatee.com>
 <20180508205005.GC15608@redhat.com>
 <7FFB9603-DF9F-4441-82E9-46037CB6C0DE@raithlin.com>
 <a1a36f88-fbfb-b5ee-6dcb-5c5bb96132dd@amd.com>
 <4e0d0b96-ab02-2662-adf3-fa956efd294c@deltatee.com>
 <2fc61d29-9eb4-d168-a3e5-955c36e5d821@amd.com>
 <94C8FE12-7FC3-48BD-9DCA-E6A427E71810@raithlin.com>
 <f0101988-cf82-7ffb-2aca-d3b8d2f4b504@deltatee.com>
 <868B49CE-4F0E-4A48-BE78-12149F85F1A4@raithlin.com>
 <8113cba8-62b9-1801-7a77-f82be223b183@deltatee.com>
 <cf2b92c9-7c5b-f19c-b5b1-2f2d435296d1@amd.com>
 <53fa38ce-40dd-6bc1-9b83-c6ccf228b755@deltatee.com>
 <A50EA568-81E7-4AD7-8C1B-1029FEA92F49@raithlin.com>
 <YTXPR0101MB2045DC0248A9B125CA276969AA9F0@YTXPR0101MB2045.CANPRD01.PROD.OUTLOOK.COM>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <fe1e1d66-9764-768a-a2da-73845d319b4e@deltatee.com>
Date: Fri, 11 May 2018 16:55:11 -0600
MIME-Version: 1.0
In-Reply-To: <YTXPR0101MB2045DC0248A9B125CA276969AA9F0@YTXPR0101MB2045.CANPRD01.PROD.OUTLOOK.COM>
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Stephen Bates <sbates@raithlin.com>, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>, Jerome Glisse <jglisse@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Keith Busch <keith.busch@intel.com>, Alex Williamson <alex.williamson@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <helgaas@kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

T24gNS8xMS8yMDE4IDQ6MjQgUE0sIFN0ZXBoZW4gIEJhdGVzIHdyb3RlOgo+IEFsbAo+IAo+PiAg
wqBBbGV4IChvciBhbnlvbmUgZWxzZSkgY2FuIHlvdSBwb2ludCB0byB3aGVyZSBJT1ZBIGFkZHJl
c3NlcyBhcmUgZ2VuZXJhdGVkPwo+IAo+IEEgY2FzZSBvZiBSVEZNIHBlcmhhcHMgKHRob3VnaCBh
IHBvaW50ZXIgdG8gdGhlIGNvZGUgd291bGQgc3RpbGwgYmUgYXBwcmVjaWF0ZWQpLgo+IAo+IGh0
dHBzOi8vd3d3Lmtlcm5lbC5vcmcvZG9jL0RvY3VtZW50YXRpb24vSW50ZWwtSU9NTVUudHh0Cj4g
Cj4gU29tZSBleGNlcHRpb25zIHRvIElPVkEKPiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQo+IElu
dGVycnVwdCByYW5nZXMgYXJlIG5vdCBhZGRyZXNzIHRyYW5zbGF0ZWQsICgweGZlZTAwMDAwIC0g
MHhmZWVmZmZmZikuCj4gVGhlIHNhbWUgaXMgdHJ1ZSBmb3IgcGVlciB0byBwZWVyIHRyYW5zYWN0
aW9ucy4gSGVuY2Ugd2UgcmVzZXJ2ZSB0aGUKPiBhZGRyZXNzIGZyb20gUENJIE1NSU8gcmFuZ2Vz
IHNvIHRoZXkgYXJlIG5vdCBhbGxvY2F0ZWQgZm9yIElPVkEgYWRkcmVzc2VzLgoKSG1tLCBleGNl
cHQgSSdtIG5vdCBzdXJlIGhvdyB0byBpbnRlcnByZXQgdGhhdC4gSXQgc291bmRzIGxpa2UgdGhl
cmUgCmNhbid0IGJlIGFuIElPVkEgYWRkcmVzcyB0aGF0IG92ZXJsYXBzIHdpdGggdGhlIFBDSSBN
TUlPIHJhbmdlIHdoaWNoIGlzIApnb29kIGFuZCB3aGF0IEknZCBleHBlY3QuCgpCdXQgZm9yIHBl
ZXIgdG8gcGVlciB0aGV5IHNheSB0aGV5IGRvbid0IHRyYW5zbGF0ZSB0aGUgYWRkcmVzcyB3aGlj
aCAKaW1wbGllcyB0byBtZSB0aGF0IHRoZSBpbnRlbnRpb24gaXMgZm9yIGEgcGVlciB0byBwZWVy
IGFkZHJlc3MgdG8gbm90IGJlIAptYXBwZWQgaW4gdGhlIHNhbWUgd2F5IHVzaW5nIHRoZSBkbWFf
bWFwIGludGVyZmFjZSAob2YgY291cnNlIHRob3VnaCBpZiAKeW91IHdlcmUgdXNpbmcgQVRTIHlv
dSdkIHdhbnQgdGhpcyBmb3Igc3VyZSkuIFVubGVzcyB0aGUgZXhpc3RpbmcgCmRtYV9tYXAgY29t
bWFuZCdzIG5vdGljZSBhIFBDSSBNTUlPIGFkZHJlc3MgYW5kIGhhbmRsZSB0aGVtIGRpZmZlcmVu
dGx5LCAKYnV0IEkgZG9uJ3Qgc2VlIGhvdy4KCkxvZ2FuCgpfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4
LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5m
by9saW51eC1udmRpbW0K
