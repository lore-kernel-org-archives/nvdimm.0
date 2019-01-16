Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com
 [IPv6:2607:f8b0:4864:20::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A99F9211B6C30
 for <linux-nvdimm@lists.01.org>; Wed, 16 Jan 2019 14:06:32 -0800 (PST)
Received: by mail-oi1-x241.google.com with SMTP id u18so4501968oie.10
 for <linux-nvdimm@lists.01.org>; Wed, 16 Jan 2019 14:06:32 -0800 (PST)
MIME-Version: 1.0
References: <20190116181859.D1504459@viggo.jf.intel.com>
 <20190116181905.12E102B4@viggo.jf.intel.com>
 <CAErSpo55j7odYf-B-KSoogabD9Qqt605oUGYe6td9wZdYNq_Hg@mail.gmail.com>
 <98ab9bc8-8a17-297c-da7c-2e6b5a03ef24@intel.com>
In-Reply-To: <98ab9bc8-8a17-297c-da7c-2e6b5a03ef24@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 16 Jan 2019 14:06:20 -0800
Message-ID: <CAPcyv4gD1SBksfjRWAY5Jn3uviGUu0E=dD-fw7Ti-i0QYFFnbw@mail.gmail.com>
Subject: Re: [PATCH 4/4] dax: "Hotplug" persistent memory for use like normal
 RAM
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
To: Dave Hansen <dave.hansen@intel.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, Dave Hansen <dave@sr71.net>, linux-nvdimm <linux-nvdimm@lists.01.org>, Takashi Iwai <tiwai@suse.de>, Dave Hansen <dave.hansen@linux.intel.com>, Huang Ying <ying.huang@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Michal Hocko <mhocko@suse.com>, Borislav Petkov <bp@suse.de>, Yaowei Bai <baiyaowei@cmss.chinamobile.com>, Ross Zwisler <zwisler@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, Andrew Morton <akpm@linux-foundation.org>, Wu Fengguang <fengguang.wu@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jan 16, 2019 at 1:40 PM Dave Hansen <dave.hansen@intel.com> wrote:
>
> On 1/16/19 1:16 PM, Bjorn Helgaas wrote:
> > On Wed, Jan 16, 2019 at 12:25 PM Dave Hansen
> > <dave.hansen@linux.intel.com> wrote:
> >> From: Dave Hansen <dave.hansen@linux.intel.com>
> >> Currently, a persistent memory region is "owned" by a device driver,
> >> either the "Direct DAX" or "Filesystem DAX" drivers.  These drivers
> >> allow applications to explicitly use persistent memory, generally
> >> by being modified to use special, new libraries.
> >
> > Is there any documentation about exactly what persistent memory is?
> > In Documentation/, I see references to pstore and pmem, which sound
> > sort of similar, but maybe not quite the same?
>
> One instance of persistent memory is nonvolatile DIMMS.  They're
> described in great detail here: Documentation/nvdimm/nvdimm.txt
>
> >> +config DEV_DAX_KMEM
> >> +       def_bool y
> >
> > Is "y" the right default here?  I periodically see Linus complain
> > about new things defaulting to "on", but I admit I haven't paid enough
> > attention to know whether that would apply here.
> >
> >> +       depends on DEV_DAX_PMEM   # Needs DEV_DAX_PMEM infrastructure
> >> +       depends on MEMORY_HOTPLUG # for add_memory() and friends
>
> Well, it doesn't default to "on for everyone".  It inherits the state of
> DEV_DAX_PMEM so it's only foisted on folks who have already opted in to
> generic pmem support.
>
> >> +int dev_dax_kmem_probe(struct device *dev)
> >> +{
> >> +       struct dev_dax *dev_dax = to_dev_dax(dev);
> >> +       struct resource *res = &dev_dax->region->res;
> >> +       resource_size_t kmem_start;
> >> +       resource_size_t kmem_size;
> >> +       struct resource *new_res;
> >> +       int numa_node;
> >> +       int rc;
> >> +
> >> +       /* Hotplug starting at the beginning of the next block: */
> >> +       kmem_start = ALIGN(res->start, memory_block_size_bytes());
> >> +
> >> +       kmem_size = resource_size(res);
> >> +       /* Adjust the size down to compensate for moving up kmem_start: */
> >> +        kmem_size -= kmem_start - res->start;
> >> +       /* Align the size down to cover only complete blocks: */
> >> +       kmem_size &= ~(memory_block_size_bytes() - 1);
> >> +
> >> +       new_res = devm_request_mem_region(dev, kmem_start, kmem_size,
> >> +                                         dev_name(dev));
> >> +
> >> +       if (!new_res) {
> >> +               printk("could not reserve region %016llx -> %016llx\n",
> >> +                               kmem_start, kmem_start+kmem_size);
> >
> > 1) It'd be nice to have some sort of module tag in the output that
> > ties it to this driver.
>
> Good point.  That should probably be a dev_printk().
>
> > 2) It might be nice to print the range in the same format as %pR,
> > i.e., "[mem %#010x-%#010x]" with the end included (start + size -1 ).
>
> Sure, that sounds like a sane thing to do as well.

Does %pR protect physical address disclosure to non-root by default?
At least the pmem driver is using %pR rather than manually printing
raw physical address values, but you would need to create a local
modified version of the passed in resource.

> >> +               return -EBUSY;
> >> +       }
> >> +
> >> +       /*
> >> +        * Set flags appropriate for System RAM.  Leave ..._BUSY clear
> >> +        * so that add_memory() can add a child resource.
> >> +        */
> >> +       new_res->flags = IORESOURCE_SYSTEM_RAM;
> >
> > IIUC, new_res->flags was set to "IORESOURCE_MEM | ..." in the
> > devm_request_mem_region() path.  I think you should keep at least
> > IORESOURCE_MEM so the iomem_resource tree stays consistent.
> >
> >> +       new_res->name = dev_name(dev);
> >> +
> >> +       numa_node = dev_dax->target_node;
> >> +       if (numa_node < 0) {
> >> +               pr_warn_once("bad numa_node: %d, forcing to 0\n", numa_node);
> >
> > It'd be nice to again have a module tag and an indication of what
> > range is affected, e.g., %pR of new_res.
> >
> > You don't save the new_res pointer anywhere, which I guess you intend
> > for now since there's no remove or anything else to do with this
> > resource?  I thought maybe devm_request_mem_region() would implicitly
> > save it, but it doesn't; it only saves the parent (iomem_resource, the
> > start (kmem_start), and the size (kmem_size)).
>
> Yeah, that's the intention: removal is currently not supported.  I'll
> add a comment to clarify.

I would clarify that *driver* removal is supported because there's no
Linux facility for drivers to fail removal (nothing checks the return
code from ->remove()). Instead the protection is that the resource
must remain pinned forever. In that case devm_request_mem_region() is
the wrong function to use. You want to explicitly use the non-devm
request_mem_region() and purposely leak it to keep the memory reserved
indefinitely.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
