Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 93E0D21148ED7
 for <linux-nvdimm@lists.01.org>; Thu, 20 Sep 2018 15:38:30 -0700 (PDT)
Date: Thu, 20 Sep 2018 17:38:29 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [PATCH v6 01/13] PCI/P2PDMA: Support peer-to-peer memory
Message-ID: <20180920223829.GD224714@bhelgaas-glaptop.roam.corp.google.com>
References: <20180913001156.4115-1-logang@deltatee.com>
 <20180913001156.4115-2-logang@deltatee.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180913001156.4115-2-logang@deltatee.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, Alex Williamson <alex.williamson@redhat.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Sep 12, 2018 at 06:11:44PM -0600, Logan Gunthorpe wrote:
> Some PCI devices may have memory mapped in a BAR space that's
> intended for use in peer-to-peer transactions. In order to enable
> such transactions the memory must be registered with ZONE_DEVICE pages
> so it can be used by DMA interfaces in existing drivers.
> 
> Add an interface for other subsystems to find and allocate chunks of P2P
> memory as necessary to facilitate transfers between two PCI peers:
> 
> int pci_p2pdma_add_client();
> struct pci_dev *pci_p2pmem_find();
> void *pci_alloc_p2pmem();
> 
> The new interface requires a driver to collect a list of client devices
> involved in the transaction with the pci_p2pmem_add_client*() functions
> then call pci_p2pmem_find() to obtain any suitable P2P memory. Once
> this is done the list is bound to the memory and the calling driver is
> free to add and remove clients as necessary (adding incompatible clients
> will fail). With a suitable p2pmem device, memory can then be
> allocated with pci_alloc_p2pmem() for use in DMA transactions.
> 
> Depending on hardware, using peer-to-peer memory may reduce the bandwidth
> of the transfer but can significantly reduce pressure on system memory.
> This may be desirable in many cases: for example a system could be designed
> with a small CPU connected to a PCIe switch by a small number of lanes
> which would maximize the number of lanes available to connect to NVMe
> devices.
> 
> The code is designed to only utilize the p2pmem device if all the devices
> involved in a transfer are behind the same PCI bridge. This is because we
> have no way of knowing whether peer-to-peer routing between PCIe Root Ports
> is supported (PCIe r4.0, sec 1.3.1). Additionally, the benefits of P2P
> transfers that go through the RC is limited to only reducing DRAM usage
> and, in some cases, coding convenience. The PCI-SIG may be exploring
> adding a new capability bit to advertise whether this is possible for
> future hardware.
> 
> This commit includes significant rework and feedback from Christoph
> Hellwig.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>  # PCI pieces

Mostly trivial comments below.  Thanks for persevering with this!

> ---
>  drivers/pci/Kconfig        |  17 +
>  drivers/pci/Makefile       |   1 +
>  drivers/pci/p2pdma.c       | 761 +++++++++++++++++++++++++++++++++++++
>  include/linux/memremap.h   |   5 +
>  include/linux/mm.h         |  18 +
>  include/linux/pci-p2pdma.h | 102 +++++
>  include/linux/pci.h        |   4 +
>  7 files changed, 908 insertions(+)
>  create mode 100644 drivers/pci/p2pdma.c
>  create mode 100644 include/linux/pci-p2pdma.h

> +#define pr_fmt(fmt) "pci-p2pdma: " fmt

Is pr_fmt() actually used anywhere?

> + * Check if a PCI bridge has it's ACS redirection bits set to redirect P2P

s/it's/its/

> + * TLPs upstream via ACS. Returns 1 if the packets will be redirected
> + * upstream, 0 otherwise.
> + */
> +static int pci_bridge_has_acs_redir(struct pci_dev *dev)

Most of your code uses "pdev" for a struct pci_dev *.

> +static void seq_buf_print_bus_devfn(struct seq_buf *buf, struct pci_dev *dev)
> +{
> +	if (!buf)
> +		return;
> +
> +	seq_buf_printf(buf, "%04x:%02x:%02x.%x;", pci_domain_nr(dev->bus),
> +		       dev->bus->number, PCI_SLOT(dev->devfn),
> +		       PCI_FUNC(dev->devfn));

dev vs pdev?
I think you could use pci_name() here (see pci_setup_device()).

> + * In the case where two devices are connected to different PCIe switches,
> + * this function will still return a positive distance as long as both
> + * switches evenutally have a common upstream bridge. Note this covers

s/evenutally/eventually/

> +static int upstream_bridge_distance_warn(struct pci_dev *provider,
> +					 struct pci_dev *client)
> +{
> +	struct seq_buf acs_list;
> +	int ret;
> +
> +	seq_buf_init(&acs_list, kmalloc(PAGE_SIZE, GFP_KERNEL), PAGE_SIZE);

Check for kmalloc() failure here?  Failure would mean acs_list->buffer is
NULL, but I gave up following the chain to see how that would be handled.

> +
> +	ret = upstream_bridge_distance(provider, client, &acs_list);
> +	if (ret == -2) {
> +		pci_warn(client, "cannot be used for peer-to-peer DMA as ACS redirect is set between the client and provider\n");

Maybe include pci_name(provider) in these messages?

> +		/* Drop final semicolon */
> +		acs_list.buffer[acs_list.len-1] = 0;
> +		pci_warn(client, "to disable ACS redirect for this path, add the kernel parameter: pci=disable_acs_redir=%s\n",
> +			 acs_list.buffer);
> +
> +	} else if (ret < 0) {
> +		pci_warn(client, "cannot be used for peer-to-peer DMA as the client and provider do not share an upstream bridge\n");

> + * pci_p2pdma_assign_provider - Check compatibily (as per pci_p2pdma_distance)

s/compatibily/compatibility/

> +struct pci_dev *pci_p2pmem_find(struct list_head *clients)
> +{
> +	struct pci_dev *pdev = NULL;
> +	struct pci_p2pdma_client *pos;
> +	int distance;
> +	int closest_distance = INT_MAX;
> +	struct pci_dev **closest_pdevs;
> +	int dev_cnt = 0;
> +	const int max_devs = PAGE_SIZE / sizeof(*closest_pdevs);
> +	int i;
> +
> +	closest_pdevs = kmalloc(PAGE_SIZE, GFP_KERNEL);

Check for kmalloc() failure?

> +++ b/include/linux/pci-p2pdma.h
> @@ -0,0 +1,102 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * PCI Peer 2 Peer DMA support.
> + *
> + * Copyright (c) 2016-2018, Logan Gunthorpe
> + * Copyright (c) 2016-2017, Microsemi Corporation
> + * Copyright (c) 2017, Christoph Hellwig
> + * Copyright (c) 2018, Eideticom Inc.
> + *

Spurious blank line.

> + */
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
