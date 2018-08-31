Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5516321106C9D
 for <linux-nvdimm@lists.01.org>; Fri, 31 Aug 2018 12:12:10 -0700 (PDT)
References: <20180830185352.3369-1-logang@deltatee.com>
 <20180830185352.3369-7-logang@deltatee.com>
 <98bff500-4e4c-3a34-6762-16ef4b076d90@amd.com>
 <6820d451-9591-1979-00bf-60c65fc4f136@deltatee.com>
 <30411655-9b90-749e-857f-318dac7cccbf@amd.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <9452ee6c-e989-d178-cd51-f29782ad9b31@deltatee.com>
Date: Fri, 31 Aug 2018 13:11:48 -0600
MIME-Version: 1.0
In-Reply-To: <30411655-9b90-749e-857f-318dac7cccbf@amd.com>
Content-Language: en-US
Subject: Re: [PATCH v5 06/13] PCI/P2PDMA: Add P2P DMA driver writer's
 documentation
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
Cc: Jonathan Corbet <corbet@lwn.net>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alex Williamson <alex.williamson@redhat.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

CgpPbiAzMS8wOC8xOCAxMTozOCBBTSwgQ2hyaXN0aWFuIEvDtm5pZyB3cm90ZToKPiBJZiB5b3Ug
Y2FuIHNlcGFyYXRlIG91dCBhZGRpbmcgdGhlIGRldGVjdGlvbiBJIGNhbiB0YWtlIGEgbG9vayBh
ZGRpbmcgCj4gdGhpcyB3aXRoIG15IERNQS1idWYgUDJQIGVmZm9ydHMuCgpPaCwgbWF5YmUgbXkg
cHJldmlvdXMgZW1haWwgd2Fzbid0IGNsZWFyLCBidXQgSSdkIHNheSB0aGF0IGRldGVjdGlvbiBp
cwphbHJlYWR5IHNlcGFyYXRlIGZyb20gWk9ORV9ERVZJQ0UuIE5vdGhpbmcgcmVhbGx5IG5lZWRz
IHRvIGJlIGNoYW5nZWQuCkkganVzdCB0aGluayB5b3UnbGwgcHJvYmFibHkgd2FudCB0byB3cml0
ZSB5b3UncmUgb3duIGZ1bmN0aW9uIHNpbWlsYXIKdG8gcGNpX3AycGRtYV9kaXN0YW5jZSB0aGF0
IHBlcmhhcHMganVzdCB0YWtlcyB0d28gcGNpX2RldnMgaW5zdGVhZCBvZgp0aGUgbGlzdCBvZiBj
bGllbnRzIGFzIGlzIG5lZWRlZCBieSBudm1lLW9mLWxpa2UgdXNlcnMuCgpUbyBlbmFibGUgYSB3
aGl0ZWxpc3Qgd2UganVzdCBoYXZlIHRvIGhhbmRsZSB0aGUgY2FzZSB3aGVyZQp1cHN0cmVhbV9i
cmlkZ2VfZGlzdGFuY2UoKSByZXR1cm5zIC0xIGFuZCBjaGVjayBpZiB0aGUgZGV2aWNlcyBhcmUg
aW4KdGhlIHNhbWUgcm9vdCBjb21wbGV4IHdpdGggc3VwcG9ydGVkIHJvb3QgcG9ydHMgYmVmb3Jl
IGRlY2lkaW5nIHRoZQp0cmFuc2FjdGlvbiBpcyBub3Qgc3VwcG9ydGVkLgoKTG9nYW4KX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1h
aWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3Jn
L21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
