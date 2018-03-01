Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A41DF224E6926
 for <linux-nvdimm@lists.01.org>; Thu,  1 Mar 2018 09:10:39 -0800 (PST)
References: <20180228234006.21093-1-logang@deltatee.com>
 <20180228234006.21093-7-logang@deltatee.com>
 <72e90cc2-c05a-3ed8-42c7-e4d7a0d535d8@grimberg.me>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <3527faf1-3f3a-88d0-caa8-d94d75437d73@deltatee.com>
Date: Thu, 1 Mar 2018 10:16:24 -0700
MIME-Version: 1.0
In-Reply-To: <72e90cc2-c05a-3ed8-42c7-e4d7a0d535d8@grimberg.me>
Content-Language: en-US
Subject: Re: [PATCH v2 06/10] IB/core: Add optional PCI P2P flag to
 rdma_rw_ctx_[init|destroy]()
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
To: Sagi Grimberg <sagi@grimberg.me>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alex Williamson <alex.williamson@redhat.com>, Keith Busch <keith.busch@intel.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

SGV5IFNhZ2ksCgpUaGFua3MgZm9yIHRoZSByZXZpZXchCgoKT24gMDEvMDMvMTggMDM6MzIgQU0s
IFNhZ2kgR3JpbWJlcmcgd3JvdGU6Cj4+IMKgIGludCByZG1hX3J3X2N0eF9pbml0KHN0cnVjdCBy
ZG1hX3J3X2N0eCAqY3R4LCBzdHJ1Y3QgaWJfcXAgKnFwLCB1OCAKPj4gcG9ydF9udW0sCj4+IMKg
wqDCoMKgwqDCoMKgwqDCoCBzdHJ1Y3Qgc2NhdHRlcmxpc3QgKnNnLCB1MzIgc2dfY250LCB1MzIg
c2dfb2Zmc2V0LAo+PiAtwqDCoMKgwqDCoMKgwqAgdTY0IHJlbW90ZV9hZGRyLCB1MzIgcmtleSwg
ZW51bSBkbWFfZGF0YV9kaXJlY3Rpb24gZGlyKQo+PiArwqDCoMKgwqDCoMKgwqAgdTY0IHJlbW90
ZV9hZGRyLCB1MzIgcmtleSwgZW51bSBkbWFfZGF0YV9kaXJlY3Rpb24gZGlyLAo+PiArwqDCoMKg
wqDCoMKgwqAgdW5zaWduZWQgaW50IGZsYWdzKQo+PiDCoCB7Cj4+IMKgwqDCoMKgwqAgc3RydWN0
IGliX2RldmljZSAqZGV2ID0gcXAtPnBkLT5kZXZpY2U7Cj4+IMKgwqDCoMKgwqAgaW50IHJldDsK
Pj4gLcKgwqDCoCByZXQgPSBpYl9kbWFfbWFwX3NnKGRldiwgc2csIHNnX2NudCwgZGlyKTsKPj4g
K8KgwqDCoCBpZiAoZmxhZ3MgJiBSRE1BX1JXX0NUWF9GTEFHX1BDSV9QMlBETUEpCj4+ICvCoMKg
wqDCoMKgwqDCoCByZXQgPSBwY2lfcDJwZG1hX21hcF9zZyhkZXYtPmRtYV9kZXZpY2UsIHNnLCBz
Z19jbnQsIGRpcik7Cj4+ICvCoMKgwqAgZWxzZQo+PiArwqDCoMKgwqDCoMKgwqAgcmV0ID0gaWJf
ZG1hX21hcF9zZyhkZXYsIHNnLCBzZ19jbnQsIGRpcik7Cj4+ICsKPiAKPiBXaHkgbm90IHVzZSBp
c19wY2lfcDJwZG1hX3BhZ2Uoc2cpIGluc3RlYWQgb2YgYSBmbGFnPyBJdCB3b3VsZCBiZSBzbwo+
IG11Y2ggY2xlYW5lci4uLgoKWWVzLCB0aGF0IHNvdW5kcyBsaWtlIGEgZ29vZCBpZGVhLiBXZSBj
YW4gbWFrZSB0aGF0IGNoYW5nZSBmb3IgdjMuCgpMb2dhbgpfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4
LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5m
by9saW51eC1udmRpbW0K
