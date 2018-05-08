Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM02-SN1-obe.outbound.protection.outlook.com
 (mail-sn1nam02on0079.outbound.protection.outlook.com [104.47.36.79])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 568AF207E36B0
 for <linux-nvdimm@lists.01.org>; Tue,  8 May 2018 00:18:10 -0700 (PDT)
Subject: Re: [PATCH v4 04/14] PCI/P2PDMA: Clear ACS P2P flags for all devices
 behind switches
References: <20180423233046.21476-1-logang@deltatee.com>
 <20180423233046.21476-5-logang@deltatee.com>
 <20180507231306.GG161390@bhelgaas-glaptop.roam.corp.google.com>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <e58e8d27-42a5-ca69-3b68-c409a2922cd1@amd.com>
Date: Tue, 8 May 2018 09:17:51 +0200
MIME-Version: 1.0
In-Reply-To: <20180507231306.GG161390@bhelgaas-glaptop.roam.corp.google.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Bjorn Helgaas <helgaas@kernel.org>, Logan Gunthorpe <logang@deltatee.com>, Alex Williamson <alex.williamson@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Hi Bjorn,

Am 08.05.2018 um 01:13 schrieb Bjorn Helgaas:
> [+to Alex]
>
> Alex,
>
> Are you happy with this strategy of turning off ACS based on
> CONFIG_PCI_P2PDMA?  We only check this at enumeration-time and
> I don't know if there are other places we would care?

thanks for pointing this out, I totally missed this hack.

AMD APUs mandatory need the ACS flag set for the GPU integrated in the 
CPU when IOMMU is enabled or otherwise you will break SVM.

Similar problems arise when you do this for dedicated GPU, but we 
haven't upstreamed the support for this yet.

So that is a clear NAK from my side for the approach.

And what exactly is the problem here? I'm currently testing P2P with 
GPUs in different IOMMU domains and at least with AMD IOMMUs that works 
perfectly fine.

Regards,
Christian.

>
> On Mon, Apr 23, 2018 at 05:30:36PM -0600, Logan Gunthorpe wrote:
>> For peer-to-peer transactions to work the downstream ports in each
>> switch must not have the ACS flags set. At this time there is no way
>> to dynamically change the flags and update the corresponding IOMMU
>> groups so this is done at enumeration time before the groups are
>> assigned.
>>
>> This effectively means that if CONFIG_PCI_P2PDMA is selected then
>> all devices behind any PCIe switch heirarchy will be in the same IOMMU
>> group. Which implies that individual devices behind any switch
>> heirarchy will not be able to be assigned to separate VMs because
>> there is no isolation between them. Additionally, any malicious PCIe
>> devices will be able to DMA to memory exposed by other EPs in the same
>> domain as TLPs will not be checked by the IOMMU.
>>
>> Given that the intended use case of P2P Memory is for users with
>> custom hardware designed for purpose, we do not expect distributors
>> to ever need to enable this option. Users that want to use P2P
>> must have compiled a custom kernel with this configuration option
>> and understand the implications regarding ACS. They will either
>> not require ACS or will have design the system in such a way that
>> devices that require isolation will be separate from those using P2P
>> transactions.
>>
>> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
>> ---
>>   drivers/pci/Kconfig        |  9 +++++++++
>>   drivers/pci/p2pdma.c       | 45 ++++++++++++++++++++++++++++++---------------
>>   drivers/pci/pci.c          |  6 ++++++
>>   include/linux/pci-p2pdma.h |  5 +++++
>>   4 files changed, 50 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
>> index b2396c22b53e..b6db41d4b708 100644
>> --- a/drivers/pci/Kconfig
>> +++ b/drivers/pci/Kconfig
>> @@ -139,6 +139,15 @@ config PCI_P2PDMA
>>   	  transations must be between devices behind the same root port.
>>   	  (Typically behind a network of PCIe switches).
>>   
>> +	  Enabling this option will also disable ACS on all ports behind
>> +	  any PCIe switch. This effectively puts all devices behind any
>> +	  switch heirarchy into the same IOMMU group. Which implies that
> s/heirarchy/hierarchy/ (also above in changelog)
>
>> +	  individual devices behind any switch will not be able to be
>> +	  assigned to separate VMs because there is no isolation between
>> +	  them. Additionally, any malicious PCIe devices will be able to
>> +	  DMA to memory exposed by other EPs in the same domain as TLPs
>> +	  will not be checked by the IOMMU.
>> +
>>   	  If unsure, say N.
>>   
>>   config PCI_LABEL
>> diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
>> index ed9dce8552a2..e9f43b43acac 100644
>> --- a/drivers/pci/p2pdma.c
>> +++ b/drivers/pci/p2pdma.c
>> @@ -240,27 +240,42 @@ static struct pci_dev *find_parent_pci_dev(struct device *dev)
>>   }
>>   
>>   /*
>> - * If a device is behind a switch, we try to find the upstream bridge
>> - * port of the switch. This requires two calls to pci_upstream_bridge():
>> - * one for the upstream port on the switch, one on the upstream port
>> - * for the next level in the hierarchy. Because of this, devices connected
>> - * to the root port will be rejected.
>> + * pci_p2pdma_disable_acs - disable ACS flags for all PCI bridges
>> + * @pdev: device to disable ACS flags for
>> + *
>> + * The ACS flags for P2P Request Redirect and P2P Completion Redirect need
>> + * to be disabled on any PCI bridge in order for the TLPS to not be forwarded
>> + * up to the RC which is not what we want for P2P.
> s/PCI bridge/PCIe switch/ (ACS doesn't apply to conventional PCI)
>
>> + *
>> + * This function is called when the devices are first enumerated and
>> + * will result in all devices behind any bridge to be in the same IOMMU
>> + * group. At this time, there is no way to "hotplug" IOMMU groups so we rely
>> + * on this largish hammer. If you need the devices to be in separate groups
>> + * don't enable CONFIG_PCI_P2PDMA.
>> + *
>> + * Returns 1 if the ACS bits for this device was cleared, otherwise 0.
>>    */
>> -static struct pci_dev *get_upstream_bridge_port(struct pci_dev *pdev)
>> +int pci_p2pdma_disable_acs(struct pci_dev *pdev)
>>   {
>> -	struct pci_dev *up1, *up2;
>> +	int pos;
>> +	u16 ctrl;
>>   
>> -	if (!pdev)
>> -		return NULL;
>> +	if (!pci_is_bridge(pdev))
>> +		return 0;
>>   
>> -	up1 = pci_dev_get(pci_upstream_bridge(pdev));
>> -	if (!up1)
>> -		return NULL;
>> +	pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_ACS);
>> +	if (!pos)
>> +		return 0;
>> +
>> +	pci_info(pdev, "disabling ACS flags for peer-to-peer DMA\n");
>> +
>> +	pci_read_config_word(pdev, pos + PCI_ACS_CTRL, &ctrl);
>> +
>> +	ctrl &= ~(PCI_ACS_RR | PCI_ACS_CR);
>>   
>> -	up2 = pci_dev_get(pci_upstream_bridge(up1));
>> -	pci_dev_put(up1);
>> +	pci_write_config_word(pdev, pos + PCI_ACS_CTRL, ctrl);
>>   
>> -	return up2;
>> +	return 1;
>>   }
>>   
>>   /*
>> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
>> index e597655a5643..7e2f5724ba22 100644
>> --- a/drivers/pci/pci.c
>> +++ b/drivers/pci/pci.c
>> @@ -16,6 +16,7 @@
>>   #include <linux/of.h>
>>   #include <linux/of_pci.h>
>>   #include <linux/pci.h>
>> +#include <linux/pci-p2pdma.h>
>>   #include <linux/pm.h>
>>   #include <linux/slab.h>
>>   #include <linux/module.h>
>> @@ -2835,6 +2836,11 @@ static void pci_std_enable_acs(struct pci_dev *dev)
>>    */
>>   void pci_enable_acs(struct pci_dev *dev)
>>   {
>> +#ifdef CONFIG_PCI_P2PDMA
>> +	if (pci_p2pdma_disable_acs(dev))
>> +		return;
>> +#endif
>> +
>>   	if (!pci_acs_enable)
>>   		return;
>>   
>> diff --git a/include/linux/pci-p2pdma.h b/include/linux/pci-p2pdma.h
>> index 0cde88341eeb..fcb3437a2f3c 100644
>> --- a/include/linux/pci-p2pdma.h
>> +++ b/include/linux/pci-p2pdma.h
>> @@ -18,6 +18,7 @@ struct block_device;
>>   struct scatterlist;
>>   
>>   #ifdef CONFIG_PCI_P2PDMA
>> +int pci_p2pdma_disable_acs(struct pci_dev *pdev);
>>   int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
>>   		u64 offset);
>>   int pci_p2pdma_add_client(struct list_head *head, struct device *dev);
>> @@ -40,6 +41,10 @@ int pci_p2pdma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
>>   void pci_p2pdma_unmap_sg(struct device *dev, struct scatterlist *sg, int nents,
>>   			 enum dma_data_direction dir);
>>   #else /* CONFIG_PCI_P2PDMA */
>> +static inline int pci_p2pdma_disable_acs(struct pci_dev *pdev)
>> +{
>> +	return 0;
>> +}
>>   static inline int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar,
>>   		size_t size, u64 offset)
>>   {
>> -- 
>> 2.11.0
>>

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
