Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 566BE21E08281
 for <linux-nvdimm@lists.01.org>; Mon,  5 Mar 2018 12:07:28 -0800 (PST)
References: <20180228234006.21093-1-logang@deltatee.com>
 <20180228234006.21093-8-logang@deltatee.com>
 <CAOSf1CEj1vmLLd27-642=XSnL9ODkpEC0qLHA2_W5_7rV5+4Pg@mail.gmail.com>
 <20180305160004.GA30975@localhost.localdomain>
 <36c78987-006a-a97f-1d18-b0a08cbea9d4@grimberg.me>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <e3ca6482-d68c-0e10-dde9-7ccb702d3ac2@deltatee.com>
Date: Mon, 5 Mar 2018 13:13:20 -0700
MIME-Version: 1.0
In-Reply-To: <36c78987-006a-a97f-1d18-b0a08cbea9d4@grimberg.me>
Content-Language: en-US
Subject: Re: [PATCH v2 07/10] nvme-pci: Use PCI p2pmem subsystem to manage the
 CMB
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
To: Sagi Grimberg <sagi@grimberg.me>, Keith Busch <keith.busch@intel.com>, Oliver <oohall@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

CgpPbiAwNS8wMy8xOCAxMjo1NyBQTSwgU2FnaSBHcmltYmVyZyB3cm90ZToKPiBLZWl0aCwgd2hp
bGUgd2UncmUgb24gdGhpcywgcmVnYXJkbGVzcyBvZiBjbWIsIGlzIFNRRSBtZW1jb3B5IGFuZCBE
QiAKPiB1cGRhdGUgb3JkZXJpbmcgYWx3YXlzIGd1YXJhbnRlZWQ/Cj4gCj4gSWYgeW91IGxvb2sg
YXQgbWx4NCAocmRtYSBkZXZpY2UgZHJpdmVyKSB0aGF0IHdvcmtzIGV4YWN0bHkgdGhlIHNhbWUg
YXMKPiBudm1lIHlvdSB3aWxsIGZpbmQ6Cj4gLS0gCj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBxcC0+c3EuaGVhZCArPSBucmVxOwo+IAo+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgLyoKPiAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKiBNYWtlIHN1
cmUgdGhhdCBkZXNjcmlwdG9ycyBhcmUgd3JpdHRlbiBiZWZvcmUKPiAgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgKiBkb29yYmVsbCByZWNvcmQuCj4gIMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgICovCj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB3bWIo
KTsKPiAKPiAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHdyaXRlbChxcC0+ZG9vcmJl
bGxfcXBuLAo+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB0
b19tZGV2KGlicXAtPmRldmljZSktPnVhcl9tYXAgKyAKPiBNTFg0X1NFTkRfRE9PUkJFTEwpOwo+
IAo+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgLyoKPiAgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgKiBNYWtlIHN1cmUgZG9vcmJlbGxzIGRvbid0IGxlYWsgb3V0IG9m
IFNRIHNwaW5sb2NrCj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICogYW5kIHJl
YWNoIHRoZSBIQ0Egb3V0IG9mIG9yZGVyLgo+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCAqLwo+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbW1pb3diKCk7Cj4gLS0g
CgpUbyBtZSwgaXQgbG9va3MgbGlrZSB0aGUgd21iKCkgaXMgcmVkdW5kYW50IGFzIHdyaXRlbCBz
aG91bGQgZ3VhcmFudGVlIAp0aGUgb3JkZXIuIChJbmRlZWQsIHBlciBTaW5hbidzIGNvbW1lbnQs
IHdyaXRlbCBvbiBhcm02NCBzdGFydHMgd2l0aCBhIAp3bWIoKSB3aGljaCBtZWFucywgb24gdGhh
dCBwbGF0Zm9ybSwgdGhlcmUgYXJlIHR3byB3bWIoKSBjYWxscyBpbiBhIHJvdy4pCgpUaGUgbW1p
b3diKCkgY2FsbCwgb24gdGhlIG90aGVyIGhhbmQsIGxvb2tzIGNvcnJlY3QgcGVyIG15IHVuZGVy
c3RhbmRpbmcgCm9mIGl0J3MgcHVycG9zZSB3aXRoIHJlc3BlY3QgdG8gdGhlIHNwaW5sb2NrLgoK
TG9nYW4KCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpM
aW51eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6
Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
