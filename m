Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 96AAF2112E02B
 for <linux-nvdimm@lists.01.org>; Fri, 21 Sep 2018 09:41:27 -0700 (PDT)
Date: Fri, 21 Sep 2018 11:41:26 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [PATCH v6 06/13] PCI/P2PDMA: Add P2P DMA driver writer's
 documentation
Message-ID: <20180921164126.GI224714@bhelgaas-glaptop.roam.corp.google.com>
References: <20180913001156.4115-1-logang@deltatee.com>
 <20180913001156.4115-7-logang@deltatee.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180913001156.4115-7-logang@deltatee.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, Alex Williamson <alex.williamson@redhat.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Sep 12, 2018 at 06:11:49PM -0600, Logan Gunthorpe wrote:
> Add a restructured text file describing how to write drivers
> with support for P2P DMA transactions. The document describes
> how to use the APIs that were added in the previous few
> commits.
> 
> Also adds an index for the PCI documentation tree even though this
> is the only PCI document that has been converted to restructured text
> at this time.
> 
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

> +With the client list in hand, the orchestrator may then call
> +:c:func:`pci_p2pmem_find()` to obtain a published P2P memory provider
> +that is supported (behind the same root port) as all the clients. If more
> +than one provider is supported, the one nearest to all the clients will
> +be chosen first. If there are more than one provider is an equal distance

s/If there are more/If more/

> +away, the one returned will be chosen at random. This function returns the PCI

s/the one returned will be chosen at random/one will be chosen
arbitrarily/ ?  (I doubt it's really random)

> +device to use for the provider with a reference taken and therefore
> +when it's no longer needed it should be returned with pci_dev_put().

> +Struct Page Caveats
> +-------------------
> +
> +Driver writers should be very careful about not passing these special
> +struct pages to code that isn't prepared for it. At this time, the kernel
> +interfaces do not have any checks for ensuring this. This obviously
> +precludes passing these pages to userspace.

Sounds like landmines here since the reader probably can't translate
"code that isn't prepared for it" into a list of interfaces that are
off-limits.  But that's a VM issue that is above my pay grade, so I'm
not suggesting any change; just pointing out something that makes me
wonder "hmmm..., how would I act on this?"

> +P2P memory is also technically IO memory but should never have any side
> +effects behind it. Thus, the order of loads and stores should not be important
> +and ioreadX(), iowriteX() and friends should not be necessary.
> +However, as the memory is not cache coherent, if access ever needs to
> +be protected by a spinlock then :c:func:`mmiowb()` must be used before
> +unlocking the lock. (See ACQUIRES VS I/O ACCESSES in
> +Documentation/memory-barriers.txt)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
