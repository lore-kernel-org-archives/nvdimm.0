Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8A6AD211CC3B3
 for <linux-nvdimm@lists.01.org>; Mon, 25 Feb 2019 14:56:29 -0800 (PST)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH 5/5] dax: "Hotplug" persistent memory for use like
 normal RAM
Date: Mon, 25 Feb 2019 22:56:27 +0000
Message-ID: <68f1da72779fcbb8b0cab8ab5927b918c3ea9711.camel@intel.com>
References: <20190225185727.BCBD768C@viggo.jf.intel.com>
 <20190225185740.8660866F@viggo.jf.intel.com>
In-Reply-To: <20190225185740.8660866F@viggo.jf.intel.com>
Content-Language: en-US
Content-ID: <E0D2C7A58BCF55448C6199F41E0F97E9@intel.com>
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
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Cc: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "mhocko@suse.com" <mhocko@suse.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "tiwai@suse.de" <tiwai@suse.de>, "Huang, " Ying" <ying.huang@intel.com>, "linux-mm@kvack.org, " <linux-mm@kvack.org>, jglisse@redhat.com" <jglisse@redhat.com>, "Wu, Fengguang  <fengguang.wu@intel.com>, baiyaowei@cmss.chinamobile.com" <baiyaowei@cmss.chinamobile.com>, "zwisler@kernel.org" <zwisler@kernel.org>, "bhelgaas@google.com" <bhelgaas@google.com>, "bp@suse.de" <bp@suse.de>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>


On Mon, 2019-02-25 at 10:57 -0800, Dave Hansen wrote:
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> This is intended for use with NVDIMMs that are physically persistent
> (physically like flash) so that they can be used as a cost-effective
> RAM replacement.  Intel Optane DC persistent memory is one
> implementation of this kind of NVDIMM.
> 
> Currently, a persistent memory region is "owned" by a device driver,
> either the "Direct DAX" or "Filesystem DAX" drivers.  These drivers
> allow applications to explicitly use persistent memory, generally
> by being modified to use special, new libraries. (DIMM-based
> persistent memory hardware/software is described in great detail
> here: Documentation/nvdimm/nvdimm.txt).
> 
> However, this limits persistent memory use to applications which
> *have* been modified.  To make it more broadly usable, this driver
> "hotplugs" memory into the kernel, to be managed and used just like
> normal RAM would be.
> 
> To make this work, management software must remove the device from
> being controlled by the "Device DAX" infrastructure:
> 
> 	echo dax0.0 > /sys/bus/dax/drivers/device_dax/unbind
> 
> and then tell the new driver that it can bind to the device:
> 
> 	echo dax0.0 > /sys/bus/dax/drivers/kmem/new_id
> 
> After this, there will be a number of new memory sections visible
> in sysfs that can be onlined, or that may get onlined by existing
> udev-initiated memory hotplug rules.
> 
> This rebinding procedure is currently a one-way trip.  Once memory
> is bound to "kmem", it's there permanently and can not be
> unbound and assigned back to device_dax.
> 
> The kmem driver will never bind to a dax device unless the device
> is *explicitly* bound to the driver.  There are two reasons for
> this: One, since it is a one-way trip, it can not be undone if
> bound incorrectly.  Two, the kmem driver destroys data on the
> device.  Think of if you had good data on a pmem device.  It
> would be catastrophic if you compile-in "kmem", but leave out
> the "device_dax" driver.  kmem would take over the device and
> write volatile data all over your good data.
> 
> This inherits any existing NUMA information for the newly-added
> memory from the persistent memory device that came from the
> firmware.  On Intel platforms, the firmware has guarantees that
> require each socket's persistent memory to be in a separate
> memory-only NUMA node.  That means that this patch is not expected
> to create NUMA nodes, but will simply hotplug memory into existing
> nodes.
> 
> Because NUMA nodes are created, the existing NUMA APIs and tools
> are sufficient to create policies for applications or memory areas
> to have affinity for or an aversion to using this memory.
> 
> There is currently some metadata at the beginning of pmem regions.
> The section-size memory hotplug restrictions, plus this small
> reserved area can cause the "loss" of a section or two of capacity.
> This should be fixable in follow-on patches.  But, as a first step,
> losing 256MB of memory (worst case) out of hundreds of gigabytes
> is a good tradeoff vs. the required code to fix this up precisely.
> This calculation is also the reason we export
> memory_block_size_bytes().
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> Reviewed-by: Keith Busch <keith.busch@intel.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Ross Zwisler <zwisler@kernel.org>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: linux-nvdimm@lists.01.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: Huang Ying <ying.huang@intel.com>
> Cc: Fengguang Wu <fengguang.wu@intel.com>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
> Cc: Takashi Iwai <tiwai@suse.de>
> Cc: Jerome Glisse <jglisse@redhat.com>
> ---
> 
>  b/drivers/base/memory.c |    1 
>  b/drivers/dax/Kconfig   |   16 +++++++
>  b/drivers/dax/Makefile  |    1 
>  b/drivers/dax/kmem.c    |  108 ++++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 126 insertions(+)

Looks good,
Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
