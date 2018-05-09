Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6880A20348620
 for <linux-nvdimm@lists.01.org>; Wed,  9 May 2018 08:47:28 -0700 (PDT)
Subject: Re: [PATCH v4 04/14] PCI/P2PDMA: Clear ACS P2P flags for all devices
 behind switches
References: <20180423233046.21476-1-logang@deltatee.com>
 <20180423233046.21476-5-logang@deltatee.com>
 <CAPcyv4g+5N_n03J-VhmJfrr60Sqk95ZapLKBkwSsGvV4nQ+ZRw@mail.gmail.com>
 <64C231F5-DE36-415F-B308-3A423B0BBACB@raithlin.com>
 <15433946-f7f5-f610-4e80-380fb59920e5@redhat.com>
 <3C9FB262-A93C-4C8F-B1E0-85C6D6F78BC2@raithlin.com>
 <c5f30ced-7bbf-9420-db1a-72519fc78b3a@redhat.com>
 <20180508180157.7c7b393f@w520.home>
From: Don Dutile <ddutile@redhat.com>
Message-ID: <f0d25e16-1201-1fc5-334f-4205abc95500@redhat.com>
Date: Wed, 9 May 2018 11:47:31 -0400
MIME-Version: 1.0
In-Reply-To: <20180508180157.7c7b393f@w520.home>
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
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, linux-rdma <linux-rdma@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On 05/08/2018 08:01 PM, Alex Williamson wrote:
> On Tue, 8 May 2018 19:06:17 -0400
> Don Dutile <ddutile@redhat.com> wrote:
>> On 05/08/2018 05:27 PM, Stephen  Bates wrote:
>>> As I understand it VMs need to know because VFIO passes IOMMU
>>> grouping up into the VMs. So if a IOMMU grouping changes the VM's
>>> view of its PCIe topology changes. I think we even have to be
>>> cognizant of the fact the OS running on the VM may not even support
>>> hot-plug of PCI devices.
>> Alex:
>> Really? IOMMU groups are created by the kernel, so don't know how
>> they would be passed into the VMs, unless indirectly via  PCI(e)
>> layout. At best, twiddling w/ACS enablement (emulation) would cause
>> VMs to see different IOMMU groups, but again, VMs are not the
>> security point/level, the host/HV's are.
> 
> Correct, the VM has no concept of the host's IOMMU groups, only the
> hypervisor knows about the groups, but really only to the extent of
> which device belongs to which group and whether the group is viable.
> Any runtime change to grouping though would require DMA mapping
> updates, which I don't see how we can reasonably do with drivers,
> vfio-pci or native host drivers, bound to the affected devices.  Thanks,
> 
> Alex
> 
A change in iommu groups would/could require a device remove/add cycle to get an updated DMA-mapping (yet-another-overused-term: iommu 'domain').

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
