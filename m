Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C789B222EDCEC
 for <linux-nvdimm@lists.01.org>; Thu,  4 Jan 2018 17:04:51 -0800 (PST)
From: Logan Gunthorpe <logang@deltatee.com>
References: <20180104190137.7654-1-logang@deltatee.com>
 <20180104190137.7654-5-logang@deltatee.com>
 <20180104215721.GF189897@bhelgaas-glaptop.roam.corp.google.com>
 <20180104153551.3118f71b@t450s.home>
 <20fdb5bb-0236-c093-ed53-e12664022f53@deltatee.com>
Message-ID: <99420cc9-48fd-5692-8426-bd5c2ec0dcf7@deltatee.com>
Date: Thu, 4 Jan 2018 18:09:43 -0700
MIME-Version: 1.0
In-Reply-To: <20fdb5bb-0236-c093-ed53-e12664022f53@deltatee.com>
Content-Language: en-US
Subject: Re: [PATCH 04/12] pci-p2p: Clear ACS P2P flags for all client devices
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
To: Alex Williamson <alex.williamson@redhat.com>, Bjorn Helgaas <helgaas@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, Keith Busch <keith.busch@intel.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

CgpPbiAwNC8wMS8xOCAwNTowMCBQTSwgTG9nYW4gR3VudGhvcnBlIHdyb3RlOgo+IAo+IAo+IE9u
IDA0LzAxLzE4IDAzOjM1IFBNLCBBbGV4IFdpbGxpYW1zb24gd3JvdGU6Cj4+IFllcCwgZmxpcHBp
bmcgdGhlc2UgQUNTIGJpdHMgaW52YWxpZGF0ZXMgYW55IElPTU1VIGdyb3VwcyB0aGF0IGRlcGVu
ZAo+PiBvbiB0aGUgaXNvbGF0aW9uIG9mIHRoYXQgZG93bnN0cmVhbSBwb3J0IGFuZCBJIHN1c3Bl
Y3QgYWxzbyBhbnkgcGVlcnMKPj4gd2l0aGluIHRoZSBzYW1lIFBDSSBzbG90IG9mIHRoYXQgcG9y
dCBhbmQgdGhlaXIgZG93bnN0cmVhbSBkZXZpY2VzLsKgIFRoZQo+PiBlbnRpcmUgc3ViLWhpZXJh
cmNoeSBncm91cGluZyBuZWVkcyB0byBiZSByZS1ldmFsdWF0ZWQuwqAgVGhpcwo+PiBwb3RlbnRp
YWxseSBhZmZlY3RzIHJ1bm5pbmcgZGV2aWNlcyB0aGF0IGRlcGVuZCBvbiB0aGF0IGlzb2xhdGlv
biwgc28KPj4gSSdtIG5vdCBzdXJlIGhvdyB0aGF0IGhhcHBlbnMgZHluYW1pY2FsbHkuwqAgQSBi
b290IG9wdGlvbiBtaWdodCBiZQo+PiBlYXNpZXIuwqAgVGhhbmtzLAo+IAoKQWxzbywgY29uc2lk
ZXJpbmcgdGhpcyBmdXJ0aGVyOiBpZiB5b3UgY2FuIHBvaW50IG1lIHRvIGEgd2F5IHRvIHRlbGwg
aWYKYSBkZXZpY2UgaXMgaW4gYW4gSU9NTVUgZ3JvdXAgaXQgc2hvdWxkIGJlIHByZXR0eSBlYXN5
IHRvIGRpc2FsbG93IGEKZGV2aWNlIHRoYXQgaGFzIGJlZW4gYXNzaWduZWQgdG8gYSBncm91cCBm
cm9tIGJlaW5nIHVzZWQgaW4gUDJQCnRyYW5zYWN0aW9ucy4KCkxvZ2FuCl9fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxp
c3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFu
L2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
