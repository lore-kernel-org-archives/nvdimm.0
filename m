Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com
 [IPv6:2607:f8b0:4864:20::341])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8BE1C2117B57A
 for <linux-nvdimm@lists.01.org>; Thu, 25 Oct 2018 22:43:12 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id r10so6050997otk.1
 for <linux-nvdimm@lists.01.org>; Thu, 25 Oct 2018 22:43:12 -0700 (PDT)
Subject: Re: [PATCH 0/9] Allow persistent memory to be used like normal RAM
References: <20181022201317.8558C1D8@viggo.jf.intel.com>
From: Xishi Qiu <qiuxishi@gmail.com>
Message-ID: <debe98dd-39f3-18d5-aeb4-fe94519aa0c9@gmail.com>
Date: Fri, 26 Oct 2018 13:42:43 +0800
MIME-Version: 1.0
In-Reply-To: <20181022201317.8558C1D8@viggo.jf.intel.com>
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
To: Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: thomas.lendacky@amd.com, mhocko@suse.com, Xishi Qiu <qiuxishi@linux.alibaba.com>, linux-nvdimm@lists.01.org, ying.huang@intel.com, linux-mm@kvack.org, zy107165@alibaba-inc.com, zwisler@kernel.org, fengguang.wu@intel.com, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

Hi Dave,

This patchset hotadd a pmem and use it like a normal DRAM, I
have some questions here, and I think my production line may
also concerned.

1) How to set the AEP (Apache Pass) usage percentage for one
process (or a vma)?
e.g. there are two vms from two customers, they pay different
money for the vm. So if we alloc and convert AEP/DRAM by global,
the high load vm may get 100% DRAM, and the low load vm may get
100% AEP, this is unfair. The low load is compared to another
one, for himself, the actual low load maybe is high load.

2) I find page idle only check the access bit, _PAGE_BIT_ACCESSED,
as we know AEP read performance is much higher than write, so I
think we should also check the dirty bit, _PAGE_BIT_DIRTY. Test
and clear dirty bit is safe for anon page, but unsafe for file
page, e.g. should call clear_page_dirty_for_io first, right?

3) I think we should manage the AEP memory separately instead
of together with the DRAM. Manage them together maybe change less
code, but it will cause some problems at high priority DRAM
allocation if there is no DRAM, then should convert (steal DRAM)
from another one, it takes much time.
How about create a new zone, e.g. ZONE_AEP, and use madvise
to set a new flag VM_AEP, which will enable the vma to alloc AEP
memory in page fault later, then use vma_rss_stat(like mm_rss_stat)
to control the AEP usage percentage for a vma.

4) I am interesting about the conversion mechanism betweent AEP
and DRAM. I think numa balancing will cause page fault, this is
unacceptable for some apps, it cause performance jitter. And the
kswapd is not precise enough. So use a daemon kernel thread
(like khugepaged) maybe a good solution, add the AEP used processes
to a list, then scan the VM_AEP marked vmas, get the access state,
and do the conversion.

Thanks,
Xishi Qiu
On 2018/10/23 04:13, Dave Hansen wrote:
> Persistent memory is cool.  But, currently, you have to rewrite
> your applications to use it.  Wouldn't it be cool if you could
> just have it show up in your system like normal RAM and get to
> it like a slow blob of memory?  Well... have I got the patch
> series for you!
> 
> This series adds a new "driver" to which pmem devices can be
> attached.  Once attached, the memory "owned" by the device is
> hot-added to the kernel and managed like any other memory.  On
> systems with an HMAT (a new ACPI table), each socket (roughly)
> will have a separate NUMA node for its persistent memory so
> this newly-added memory can be selected by its unique NUMA
> node.
> 
> This is highly RFC, and I really want the feedback from the
> nvdimm/pmem folks about whether this is a viable long-term
> perversion of their code and device mode.  It's insufficiently
> documented and probably not bisectable either.
> 
> Todo:
> 1. The device re-binding hacks are ham-fisted at best.  We
>    need a better way of doing this, especially so the kmem
>    driver does not get in the way of normal pmem devices.
> 2. When the device has no proper node, we default it to
>    NUMA node 0.  Is that OK?
> 3. We muck with the 'struct resource' code quite a bit. It
>    definitely needs a once-over from folks more familiar
>    with it than I.
> 4. Is there a better way to do this than starting with a
>    copy of pmem.c?
> 
> Here's how I set up a system to test this thing:
> 
> 1. Boot qemu with lots of memory: "-m 4096", for instance
> 2. Reserve 512MB of physical memory.  Reserving a spot a 2GB
>    physical seems to work: memmap=512M!0x0000000080000000
>    This will end up looking like a pmem device at boot.
> 3. When booted, convert fsdax device to "device dax":
> 	ndctl create-namespace -fe namespace0.0 -m dax
> 4. In the background, the kmem driver will probably bind to the
>    new device.
> 5. Now, online the new memory sections.  Perhaps:
> 
> grep ^MemTotal /proc/meminfo
> for f in `grep -vl online /sys/devices/system/memory/*/state`; do
> 	echo $f: `cat $f`
> 	echo online > $f
> 	grep ^MemTotal /proc/meminfo
> done
> 
> Cc: Dan Williams <dan.j.williams@intel.com>
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
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
