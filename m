Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1970221107474
 for <linux-nvdimm@lists.01.org>; Fri, 31 Aug 2018 09:19:26 -0700 (PDT)
Date: Fri, 31 Aug 2018 17:19:06 +0100
From: Jonathan Cameron <jonathan.cameron@huawei.com>
Subject: Re: [PATCH v5 01/13] PCI/P2PDMA: Support peer-to-peer memory
Message-ID: <20180831171906.00002751@huawei.com>
In-Reply-To: <20180830185352.3369-2-logang@deltatee.com>
References: <20180830185352.3369-1-logang@deltatee.com>
 <20180830185352.3369-2-logang@deltatee.com>
MIME-Version: 1.0
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
Cc: Alex Williamson <alex.williamson@redhat.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?ISO-8859-1?Q?J=E9r=F4me?= Glisse <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Christian =?ISO-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 30 Aug 2018 12:53:40 -0600
Logan Gunthorpe <logang@deltatee.com> wrote:

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

Apologies for being a late entrant to this conversation so I may be asking
about a topic that has been covered in detail in earlier patches!
> ---
...

> +/*
> + * Find the distance through the nearest common upstream bridge between
> + * two PCI devices.
> + *
> + * If the two devices are the same device then 0 will be returned.
> + *
> + * If there are two virtual functions of the same device behind the same
> + * bridge port then 2 will be returned (one step down to the PCIe switch,
> + * then one step back to the same device).
> + *
> + * In the case where two devices are connected to the same PCIe switch, the
> + * value 4 will be returned. This corresponds to the following PCI tree:
> + *
> + *     -+  Root Port
> + *      \+ Switch Upstream Port
> + *       +-+ Switch Downstream Port
> + *       + \- Device A
> + *       \-+ Switch Downstream Port
> + *         \- Device B
> + *
> + * The distance is 4 because we traverse from Device A through the downstream
> + * port of the switch, to the common upstream port, back up to the second
> + * downstream port and then to Device B.
> + *
> + * Any two devices that don't have a common upstream bridge will return -1.
> + * In this way devices on separate PCIe root ports will be rejected, which
> + * is what we want for peer-to-peer seeing each PCIe root port defines a
> + * separate hierarchy domain and there's no way to determine whether the root
> + * complex supports forwarding between them.
> + *
> + * In the case where two devices are connected to different PCIe switches,
> + * this function will still return a positive distance as long as both
> + * switches evenutally have a common upstream bridge. Note this covers
> + * the case of using multiple PCIe switches to achieve a desired level of
> + * fan-out from a root port. The exact distance will be a function of the
> + * number of switches between Device A and Device B.

This feels like a somewhat simplistic starting point rather than a
generally correct estimate to use.  Should we be taking the bandwidth of
those links into account for example, or any discoverable latencies?
Not all PCIe switches are alike - particularly when it comes to P2P.

I guess that can be a topic for future development if it turns out people
have horrible mixed systems.

> + *
> + * If a bridge which has any ACS redirection bits set is in the path
> + * then this functions will return -2. This is so we reject any
> + * cases where the TLPs are forwarded up into the root complex.
> + * In this case, a list of all infringing bridge addresses will be
> + * populated in acs_list (assuming it's non-null) for printk purposes.
> + */

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
