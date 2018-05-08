Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2FEB220945D8F
 for <linux-nvdimm@lists.01.org>; Tue,  8 May 2018 14:04:04 -0700 (PDT)
Subject: Re: [PATCH v4 04/14] PCI/P2PDMA: Clear ACS P2P flags for all devices
 behind switches
References: <20180423233046.21476-1-logang@deltatee.com>
 <20180423233046.21476-5-logang@deltatee.com>
 <CAPcyv4g+5N_n03J-VhmJfrr60Sqk95ZapLKBkwSsGvV4nQ+ZRw@mail.gmail.com>
 <64C231F5-DE36-415F-B308-3A423B0BBACB@raithlin.com>
From: Don Dutile <ddutile@redhat.com>
Message-ID: <15433946-f7f5-f610-4e80-380fb59920e5@redhat.com>
Date: Tue, 8 May 2018 17:04:01 -0400
MIME-Version: 1.0
In-Reply-To: <64C231F5-DE36-415F-B308-3A423B0BBACB@raithlin.com>
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

On 05/08/2018 10:44 AM, Stephen  Bates wrote:
> Hi Dan
> 
>>     It seems unwieldy that this is a compile time option and not a runtime
>>     option. Can't we have a kernel command line option to opt-in to this
>>     behavior rather than require a wholly separate kernel image?
>    
> I think because of the security implications associated with p2pdma and ACS we wanted to make it very clear people were choosing one (p2pdma) or the other (IOMMU groupings and isolation). However personally I would prefer including the option of a run-time kernel parameter too. In fact a few months ago I proposed a small patch that did just that [1]. It never really went anywhere but if people were open to the idea we could look at adding it to the series.
> 
It is clear if it is a kernel command-line option or a CONFIG option.
One does not have access to the kernel command-line w/o a few privs.
A CONFIG option prevents a distribution to have a default, locked-down kernel _and_ the ability to be 'unlocked' if the customer/site is 'secure' via other means.
A run/boot-time option is more flexible and achieves the best of both.
    
>> Why is this text added in a follow on patch and not the patch that
>>   introduced the config option?
> 
> Because the ACS section was added later in the series and this information is associated with that additional functionality.
>      
>> I'm also wondering if that command line option can take a 'bus device
>> function' address of a switch to limit the scope of where ACS is
>> disabled.
> 
Well, p2p DMA is a function of a cooperating 'agent' somewhere above the two devices.
That agent should 'request' to the kernel that ACS be removed/circumvented (p2p enabled) btwn two endpoints.
I recommend doing so via a sysfs method.

That way, the system can limit the 'unsecure' space btwn two devices, likely configured on a separate switch, from the rest of the still-secured/ACS-enabled PCIe tree.
PCIe is pt-to-pt, effectively; maybe one would have multiple nics/fabrics p2p to/from NVME, but one could look at it as a list of pairs (nic1<->nvme1; nic2<->nvme2; ....).
A pair-listing would be optimal, allowing the kernel to figure out the ACS path, and not making it endpoint-switch-switch...-switch-endpt error-entry prone.
Additionally, systems that can/prefer to do so via a RP's IOMMU, albeit not optimal, but better then all the way to/from memory, and a security/iova-check possible,
can modify the pt-to-pt ACS algorithm to accomodate over time (e.g., cap bits be they hw or device-driver/extension/quirk defined for each bridge/RP in a PCI domain).

Kernels that never want to support P2P could build w/o it enabled.... cmdline option is moot.
Kernels built with it on, *still* need cmdline option, to be blunt that the kernel is enabling a feature that could render the entire (IO sub)system unsecure.

> By this you mean the address for either a RP, DSP, USP or MF EP below which we disable ACS? We could do that but I don't think it avoids the issue of changes in IOMMU groupings as devices are added/removed. It simply changes the problem from affecting and entire PCI domain to a sub-set of the domain. We can already handle this by doing p2pdma on one RP and normal IOMMU isolation on the other RPs in the system.
> 
as devices are added, they start in ACS-enabled, secured mode.
As sysfs entry modifies p2p ability, IOMMU group is modified as well.


btw -- IOMMU grouping is a host/HV control issue, not a VM control/knowledge issue.
        So I don't understand the comments why VMs should need to know.
        -- configure p2p _before_ assigning devices to VMs. ... iommu groups are checked at assignment time.
           -- so even if hot-add, separate iommu group, then enable p2p, becomes same IOMMU group, then can only assign to same VM.
        -- VMs don't know IOMMU's & ACS are involved now, and won't later, even if device's dynamically added/removed

Is there a thread I need to read up to explain /clear-up the thoughts above?

> Stephen
> 
> [1] https://marc.info/?l=linux-doc&m=150907188310838&w=2
>      
> 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
