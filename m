Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x243.google.com (mail-oi0-x243.google.com
 [IPv6:2607:f8b0:4003:c06::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9724E22212BE0
 for <linux-nvdimm@lists.01.org>; Sun, 17 Dec 2017 10:47:12 -0800 (PST)
Received: by mail-oi0-x243.google.com with SMTP id l6so9285837oih.11
 for <linux-nvdimm@lists.01.org>; Sun, 17 Dec 2017 10:51:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171215140947.26075-17-hch@lst.de>
References: <20171215140947.26075-1-hch@lst.de>
 <20171215140947.26075-17-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 17 Dec 2017 10:51:56 -0800
Message-ID: <CAPcyv4ixo=A949dN4c=LVc6x+Bdk67ERSO8xR5FQwHnL9mxQAw@mail.gmail.com>
Subject: Re: [PATCH 16/17] memremap: change devm_memremap_pages interface to
 use struct dev_pagemap
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Christoph Hellwig <hch@lst.de>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Dec 15, 2017 at 6:09 AM, Christoph Hellwig <hch@lst.de> wrote:
> From: Logan Gunthorpe <logang@deltatee.com>
>
> This new interface is similar to how struct device (and many others)
> work. The caller initializes a 'struct dev_pagemap' as required
> and calls 'devm_memremap_pages'. This allows the pagemap structure to
> be embedded in another structure and thus container_of can be used. In
> this way application specific members can be stored in a containing
> struct.
>
> This will be used by the P2P infrastructure and HMM could probably
> be cleaned up to use it as well (instead of having it's own, similar
> 'hmm_devmem_pages_create' function).
>
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good, I notice that this does not initialize pgmap->type to
MEMORY_DEVICE_HOST, but since that value is zero and likely won't
change we're ok.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
