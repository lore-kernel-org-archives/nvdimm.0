Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM02-CY1-obe.outbound.protection.outlook.com
 (mail-cys01nam02on0080.outbound.protection.outlook.com [104.47.37.80])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3A8A22194D3B3
 for <linux-nvdimm@lists.01.org>; Fri, 31 Aug 2018 10:39:10 -0700 (PDT)
Subject: Re: [PATCH v5 06/13] PCI/P2PDMA: Add P2P DMA driver writer's
 documentation
References: <20180830185352.3369-1-logang@deltatee.com>
 <20180830185352.3369-7-logang@deltatee.com>
 <98bff500-4e4c-3a34-6762-16ef4b076d90@amd.com>
 <6820d451-9591-1979-00bf-60c65fc4f136@deltatee.com>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <30411655-9b90-749e-857f-318dac7cccbf@amd.com>
Date: Fri, 31 Aug 2018 19:38:50 +0200
MIME-Version: 1.0
In-Reply-To: <6820d451-9591-1979-00bf-60c65fc4f136@deltatee.com>
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
To: Logan Gunthorpe <logang@deltatee.com>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alex Williamson <alex.williamson@redhat.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

QW0gMzEuMDguMjAxOCB1bSAxNzo1MSBzY2hyaWViIExvZ2FuIEd1bnRob3JwZToKPgo+IE9uIDMx
LzA4LzE4IDAyOjA4IEFNLCBDaHJpc3RpYW4gS8O2bmlnIHdyb3RlOgo+Pj4gK09uZSBvZiB0aGUg
YmlnZ2VzdCBpc3N1ZXMgaXMgdGhhdCBQQ0kgZG9lc24ndCByZXF1aXJlIGZvcndhcmRpbmcKPj4+
ICt0cmFuc2FjdGlvbnMgYmV0d2VlbiBoaWVyYXJjaHkgZG9tYWlucywgYW5kIGluIFBDSWUsIGVh
Y2ggUm9vdCBQb3J0Cj4+PiArZGVmaW5lcyBhIHNlcGFyYXRlIGhpZXJhcmNoeSBkb21haW4uIFRv
IG1ha2UgdGhpbmdzIHdvcnNlLCB0aGVyZSBpcyBubwo+Pj4gK3NpbXBsZSB3YXkgdG8gZGV0ZXJt
aW5lIGlmIGEgZ2l2ZW4gUm9vdCBDb21wbGV4IHN1cHBvcnRzIHRoaXMgb3Igbm90Lgo+Pj4gKyhT
ZWUgUENJZSByNC4wLCBzZWMgMS4zLjEpLiBUaGVyZWZvcmUsIGFzIG9mIHRoaXMgd3JpdGluZywg
dGhlIGtlcm5lbAo+Pj4gK29ubHkgc3VwcG9ydHMgZG9pbmcgUDJQIHdoZW4gdGhlIGVuZHBvaW50
cyBpbnZvbHZlZCBhcmUgYWxsIGJlaGluZCB0aGUKPj4+ICtzYW1lIFBDSSBicmlkZ2UsIGFzIHN1
Y2ggZGV2aWNlcyBhcmUgYWxsIGluIHRoZSBzYW1lIFBDSSBoaWVyYXJjaHkKPj4+ICtkb21haW4s
IGFuZCB0aGUgc3BlYyBndWFyYW50ZWVzIHRoYXQgYWxsIHRyYW5zYWNhdGlvbnMgd2l0aGluIHRo
ZQo+Pj4gK2hpZXJhcmNoeSB3aWxsIGJlIHJvdXRhYmxlLCBidXQgaXQgZG9lcyBub3QgcmVxdWly
ZSByb3V0aW5nCj4+PiArYmV0d2VlbiBoaWVyYXJjaGllcy4KPj4gQ2FuIHdlIGFkZCBhIGtlcm5l
bCBjb21tYW5kIGxpbmUgc3dpdGNoIGFuZCBhIHdoaXRlbGlzdCB0byBlbmFibGUgUDJQCj4+IGJl
dHdlZW4gc2VwYXJhdGUgaGllcmFyY2hpZXM/Cj4gSW4gZnV0dXJlIHdvcmssIHllcy4gQnV0IG5v
dCBmb3IgdGhpcyBwYXRjaHNldC4gVGhpcyBpcyBkZWZpbml0ZWx5IHRoZQo+IHdheSBJIHNlZSB0
aGluZ3MgZ29pbmcsIGJ1dCB3ZSd2ZSBjaG9zZW4gdG8gc3RhcnQgd2l0aCB3aGF0IHdlJ3ZlIHBy
ZXNlbnRlZC4KClNvdW5kcyBsaWtlIGEgcGxhbiB0byBtZS4KCklmIHlvdSBjYW4gc2VwYXJhdGUg
b3V0IGFkZGluZyB0aGUgZGV0ZWN0aW9uIEkgY2FuIHRha2UgYSBsb29rIGFkZGluZyAKdGhpcyB3
aXRoIG15IERNQS1idWYgUDJQIGVmZm9ydHMuCgpDaHJpc3RpYW4uCgo+Cj4gTG9nYW4KCl9fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBt
YWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9y
Zy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
