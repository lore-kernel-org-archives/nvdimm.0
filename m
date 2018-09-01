Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9F9AC2194D3B3
 for <linux-nvdimm@lists.01.org>; Sat,  1 Sep 2018 01:24:01 -0700 (PDT)
Date: Sat, 1 Sep 2018 10:27:03 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5 01/13] PCI/P2PDMA: Support peer-to-peer memory
Message-ID: <20180901082703.GA670@lst.de>
References: <20180830185352.3369-1-logang@deltatee.com>
 <20180830185352.3369-2-logang@deltatee.com>
 <2711b3a7-f582-0dda-8ac2-530be7bda1bb@amd.com>
 <439181bb-6cd6-0ab2-bca6-fc820845166e@deltatee.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <439181bb-6cd6-0ab2-bca6-fc820845166e@deltatee.com>
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
Cc: Alex Williamson <alex.williamson@redhat.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
List-ID: <linux-nvdimm@lists.01.org>

T24gRnJpLCBBdWcgMzEsIDIwMTggYXQgMDk6NDg6NDBBTSAtMDYwMCwgTG9nYW4gR3VudGhvcnBl
IHdyb3RlOgo+IFByZXR0eSBlYXN5LiBQMlAgZGV0ZWN0aW9uIGlzIHByZXR0eSBtdWNoIGp1c3Qg
cGNpX3AycGRtYV9kaXN0YW5jZSgpICwKPiB3aGljaCBoYXMgbm90aGluZyB0byBkbyB3aXRoIHRo
ZSBaT05FX0RFVklDRSBzdXBwb3J0Lgo+IAo+IChBbmQgdGhlIGRpc3RhbmNlIGZ1bmN0aW9uIG1h
a2VzIHVzZSBvZiBhIG51bWJlciBvZiBzdGF0aWMgZnVuY3Rpb25zCj4gd2hpY2ggY291bGQgYmUg
Y29tYmluZWQgaW50byBhIHNpbXBsZXIgaW50ZXJmYWNlLCBzaG91bGQgd2UgbmVlZCBpdC4pCgpJ
J2Qg0ZVheSBsZXRzIGdldCB0aGluZ3MgbWVyZ2VkIGFzLWlzLCBzbyB0aGF0IHdlIGNhbiByZXZp
ZXcgdGhlCm5vbi1aT05FX0RFVklDRSB1c2Vycy4gIEknbSBhIGxpdHRsZSBjdXJpb3VzIGhvdyB0
aGF0IGlzIGdvaW5nIHRvIHdvcmssCnNvIGhhdmluZyBpdCBhcyBhIGZ1bGwgc2VyaWVzIHdvdWxk
IGJlIHVzZWZ1bC4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0
dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
