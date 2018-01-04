Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9BF1B21CB2E42
 for <linux-nvdimm@lists.01.org>; Thu,  4 Jan 2018 13:45:37 -0800 (PST)
Date: Thu, 4 Jan 2018 15:50:40 -0600
From: Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [PATCH 02/12] pci-p2p: Add sysfs group to display p2pmem stats
Message-ID: <20180104215040.GE189897@bhelgaas-glaptop.roam.corp.google.com>
References: <20180104190137.7654-1-logang@deltatee.com>
 <20180104190137.7654-3-logang@deltatee.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180104190137.7654-3-logang@deltatee.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jan 04, 2018 at 12:01:27PM -0700, Logan Gunthorpe wrote:
> Attributes display the total amount of P2P memory, the ammount available
> and whether it is published or not.

s/ammount/amount/ (also below)

> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> ---
>  Documentation/ABI/testing/sysfs-bus-pci | 25 ++++++++++++++++
>  drivers/pci/p2p.c                       | 51 +++++++++++++++++++++++++++++++++
>  2 files changed, 76 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
> index 44d4b2be92fd..7b80ea77faca 100644
> --- a/Documentation/ABI/testing/sysfs-bus-pci
> +++ b/Documentation/ABI/testing/sysfs-bus-pci
> @@ -323,3 +323,28 @@ Description:
>  
>  		This is similar to /sys/bus/pci/drivers_autoprobe, but
>  		affects only the VFs associated with a specific PF.
> +
> +What:		/sys/bus/pci/devices/.../p2pmem/available

I wonder if "p2pdma" would be a more suggestive term?  It's not really
the *memory* that is peer-to-peer; the peer-to-peer part is referring
to *access* to the memory.

> @@ -82,6 +130,9 @@ static int pci_p2pmem_setup(struct pci_dev *pdev)
>  	if (error)
>  		goto out_pool_destroy;
>  
> +	if (sysfs_create_group(&pdev->dev.kobj, &p2pmem_group))
> +		dev_warn(&pdev->dev, "failed to create p2p sysfs group\n");

Not sure the warning (by itself) is worthwhile.  If we were going to
disable the feature if sysfs_create_group() failed, that's one thing,
but we aren't doing anything except generating a warning, which the
user can't really do anything with.  If the user is looking for the
sysfs file, its absence will be obvious even without the message.

>  	pdev->p2p = p2p;
>  
>  	return 0;
> -- 
> 2.11.0
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
