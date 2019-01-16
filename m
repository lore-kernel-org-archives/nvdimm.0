Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ACE57211B818E
 for <linux-nvdimm@lists.01.org>; Wed, 16 Jan 2019 13:40:49 -0800 (PST)
Subject: Re: [PATCH 4/4] dax: "Hotplug" persistent memory for use like normal
 RAM
References: <20190116181859.D1504459@viggo.jf.intel.com>
 <20190116181905.12E102B4@viggo.jf.intel.com>
 <CAErSpo55j7odYf-B-KSoogabD9Qqt605oUGYe6td9wZdYNq_Hg@mail.gmail.com>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <98ab9bc8-8a17-297c-da7c-2e6b5a03ef24@intel.com>
Date: Wed, 16 Jan 2019 13:40:48 -0800
MIME-Version: 1.0
In-Reply-To: <CAErSpo55j7odYf-B-KSoogabD9Qqt605oUGYe6td9wZdYNq_Hg@mail.gmail.com>
Content-Language: en-US
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
To: Bjorn Helgaas <bhelgaas@google.com>, Dave Hansen <dave.hansen@linux.intel.com>
Cc: thomas.lendacky@amd.com, dave@sr71.net, linux-nvdimm@lists.01.org, Takashi Iwai <tiwai@suse.de>, Huang Ying <ying.huang@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, mhocko@suse.com, Borislav Petkov <bp@suse.de>, baiyaowei@cmss.chinamobile.com, zwisler@kernel.org, Wu Fengguang <fengguang.wu@intel.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On 1/16/19 1:16 PM, Bjorn Helgaas wrote:
> On Wed, Jan 16, 2019 at 12:25 PM Dave Hansen
> <dave.hansen@linux.intel.com> wrote:
>> From: Dave Hansen <dave.hansen@linux.intel.com>
>> Currently, a persistent memory region is "owned" by a device driver,
>> either the "Direct DAX" or "Filesystem DAX" drivers.  These drivers
>> allow applications to explicitly use persistent memory, generally
>> by being modified to use special, new libraries.
> 
> Is there any documentation about exactly what persistent memory is?
> In Documentation/, I see references to pstore and pmem, which sound
> sort of similar, but maybe not quite the same?

One instance of persistent memory is nonvolatile DIMMS.  They're
described in great detail here: Documentation/nvdimm/nvdimm.txt

>> +config DEV_DAX_KMEM
>> +       def_bool y
> 
> Is "y" the right default here?  I periodically see Linus complain
> about new things defaulting to "on", but I admit I haven't paid enough
> attention to know whether that would apply here.
> 
>> +       depends on DEV_DAX_PMEM   # Needs DEV_DAX_PMEM infrastructure
>> +       depends on MEMORY_HOTPLUG # for add_memory() and friends

Well, it doesn't default to "on for everyone".  It inherits the state of
DEV_DAX_PMEM so it's only foisted on folks who have already opted in to
generic pmem support.

>> +int dev_dax_kmem_probe(struct device *dev)
>> +{
>> +       struct dev_dax *dev_dax = to_dev_dax(dev);
>> +       struct resource *res = &dev_dax->region->res;
>> +       resource_size_t kmem_start;
>> +       resource_size_t kmem_size;
>> +       struct resource *new_res;
>> +       int numa_node;
>> +       int rc;
>> +
>> +       /* Hotplug starting at the beginning of the next block: */
>> +       kmem_start = ALIGN(res->start, memory_block_size_bytes());
>> +
>> +       kmem_size = resource_size(res);
>> +       /* Adjust the size down to compensate for moving up kmem_start: */
>> +        kmem_size -= kmem_start - res->start;
>> +       /* Align the size down to cover only complete blocks: */
>> +       kmem_size &= ~(memory_block_size_bytes() - 1);
>> +
>> +       new_res = devm_request_mem_region(dev, kmem_start, kmem_size,
>> +                                         dev_name(dev));
>> +
>> +       if (!new_res) {
>> +               printk("could not reserve region %016llx -> %016llx\n",
>> +                               kmem_start, kmem_start+kmem_size);
> 
> 1) It'd be nice to have some sort of module tag in the output that
> ties it to this driver.

Good point.  That should probably be a dev_printk().

> 2) It might be nice to print the range in the same format as %pR,
> i.e., "[mem %#010x-%#010x]" with the end included (start + size -1 ).

Sure, that sounds like a sane thing to do as well.

>> +               return -EBUSY;
>> +       }
>> +
>> +       /*
>> +        * Set flags appropriate for System RAM.  Leave ..._BUSY clear
>> +        * so that add_memory() can add a child resource.
>> +        */
>> +       new_res->flags = IORESOURCE_SYSTEM_RAM;
> 
> IIUC, new_res->flags was set to "IORESOURCE_MEM | ..." in the
> devm_request_mem_region() path.  I think you should keep at least
> IORESOURCE_MEM so the iomem_resource tree stays consistent.
> 
>> +       new_res->name = dev_name(dev);
>> +
>> +       numa_node = dev_dax->target_node;
>> +       if (numa_node < 0) {
>> +               pr_warn_once("bad numa_node: %d, forcing to 0\n", numa_node);
> 
> It'd be nice to again have a module tag and an indication of what
> range is affected, e.g., %pR of new_res.
> 
> You don't save the new_res pointer anywhere, which I guess you intend
> for now since there's no remove or anything else to do with this
> resource?  I thought maybe devm_request_mem_region() would implicitly
> save it, but it doesn't; it only saves the parent (iomem_resource, the
> start (kmem_start), and the size (kmem_size)).

Yeah, that's the intention: removal is currently not supported.  I'll
add a comment to clarify.

>> +               numa_node = 0;
>> +       }
>> +
>> +       rc = add_memory(numa_node, new_res->start, resource_size(new_res));
>> +       if (rc)
>> +               return rc;
>> +
>> +       return 0;
> 
> Doesn't this mean "return rc" or even just "return add_memory(...)"?

Yeah, all of those are equivalent.  I guess I just prefer the explicit
error handling path.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
