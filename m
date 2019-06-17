Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7E99F21295CBF
 for <linux-nvdimm@lists.01.org>; Mon, 17 Jun 2019 13:10:28 -0700 (PDT)
Date: Mon, 17 Jun 2019 22:09:57 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 08/25] memremap: move dev_pagemap callbacks into a
 separate structure
Message-ID: <20190617200957.GA20645@lst.de>
References: <20190617122733.22432-1-hch@lst.de>
 <20190617122733.22432-9-hch@lst.de>
 <d68c5e4c-b2de-95c3-0b75-1f2391b25a34@deltatee.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <d68c5e4c-b2de-95c3-0b75-1f2391b25a34@deltatee.com>
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
To: Logan Gunthorpe <logang@deltatee.com>
Cc: linux-nvdimm@lists.01.org, nouveau@lists.freedesktop.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Ben Skeggs <bskeggs@redhat.com>, linux-pci@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 17, 2019 at 02:08:14PM -0600, Logan Gunthorpe wrote:
> I just noticed this is missing a line to set pgmap->ops to
> pci_p2pdma_pagemap_ops. I must have gotten confused by the other users
> in my original review. Though I'm not sure how this compiles as the new
> struct is static and unused. However, it is rendered moot in Patch 16
> when this is all removed.

It probably was there in the original and got lost in the merge conflicts
from the rebase.  I should have dropped all the reviewed-bys for patches
with non-trivial merge resolution, sorry.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
