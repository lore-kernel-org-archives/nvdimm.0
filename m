Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7F58B21B02820
 for <linux-nvdimm@lists.01.org>; Thu,  7 Dec 2017 10:29:46 -0800 (PST)
References: <20171207150840.28409-1-hch@lst.de>
 <20171207150840.28409-2-hch@lst.de>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <ee51c0c0-b92a-e504-6d8f-fc6156a382c3@deltatee.com>
Date: Thu, 7 Dec 2017 11:34:15 -0700
MIME-Version: 1.0
In-Reply-To: <20171207150840.28409-2-hch@lst.de>
Content-Language: en-US
Subject: Re: [PATCH 01/14] mm: move get_dev_pagemap out of line
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
To: Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>
Cc: linux-mm@kvack.org, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

CgpPbiAwNy8xMi8xNyAwODowOCBBTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6Cj4gVGhpcyBp
cyBhIHByZXR0eSBiaWcgZnVuY3Rpb24sIHdoaWNoIHNob3VsZCBiZSBvdXQgb2YgbGluZSBpbiBn
ZW5lcmFsLAo+IGFuZCBhIG5vLW9wIHN0dWIgaWYgQ09ORklHX1pPTkVfREVWSUPQlSBpcyBub3Qg
c2V0Lgo+IAo+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPgoK
UmV2aWV3ZWQtYnk6IExvZ2FuIEd1bnRob3JwZSA8bG9nYW5nQGRlbHRhdGVlLmNvbT4KX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1h
aWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3Jn
L21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
