Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 40E85203BA4F7
 for <linux-nvdimm@lists.01.org>; Tue,  8 May 2018 16:06:20 -0700 (PDT)
Subject: Re: [PATCH v4 04/14] PCI/P2PDMA: Clear ACS P2P flags for all devices
 behind switches
References: <20180423233046.21476-1-logang@deltatee.com>
 <20180423233046.21476-5-logang@deltatee.com>
 <CAPcyv4g+5N_n03J-VhmJfrr60Sqk95ZapLKBkwSsGvV4nQ+ZRw@mail.gmail.com>
 <64C231F5-DE36-415F-B308-3A423B0BBACB@raithlin.com>
 <15433946-f7f5-f610-4e80-380fb59920e5@redhat.com>
 <3C9FB262-A93C-4C8F-B1E0-85C6D6F78BC2@raithlin.com>
From: Don Dutile <ddutile@redhat.com>
Message-ID: <c5f30ced-7bbf-9420-db1a-72519fc78b3a@redhat.com>
Date: Tue, 8 May 2018 19:06:17 -0400
MIME-Version: 1.0
In-Reply-To: <3C9FB262-A93C-4C8F-B1E0-85C6D6F78BC2@raithlin.com>
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
To: Stephen Bates <sbates@raithlin.com>, Dan Williams <dan.j.williams@intel.com>, Logan Gunthorpe <logang@deltatee.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Alex Williamson <alex.williamson@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, linux-rdma <linux-rdma@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On 05/08/2018 05:27 PM, Stephen  Bates wrote:
> Hi Don
> 
>> Well, p2p DMA is a function of a cooperating 'agent' somewhere above the two devices.
>>     That agent should 'request' to the kernel that ACS be removed/circumvented (p2p enabled) btwn two endpoints.
>>     I recommend doing so via a sysfs method.
> 
> Yes we looked at something like this in the past but it does hit the IOMMU grouping issue I discussed earlier today which is not acceptable right now. In the long term, once we get IOMMU grouping callbacks to VMs we can look at extending p2pdma in this way. But I don't think this is viable for the initial series.
> 
>      
>>             So I don't understand the comments why VMs should need to know.
> 
> As I understand it VMs need to know because VFIO passes IOMMU grouping up into the VMs. So if a IOMMU grouping changes the VM's view of its PCIe topology changes. I think we even have to be cognizant of the fact the OS running on the VM may not even support hot-plug of PCI devices.
Alex:
Really? IOMMU groups are created by the kernel, so don't know how they would be passed into the VMs, unless indirectly via  PCI(e) layout.
At best, twiddling w/ACS enablement (emulation) would cause VMs to see different IOMMU groups, but again, VMs are not the security point/level, the host/HV's are.

>      
>> Is there a thread I need to read up to explain /clear-up the thoughts above?
> 
> If you search for p2pdma you should find the previous discussions. Thanks for the input!
> 
> Stephen
>      
>      
> 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
