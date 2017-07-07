Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf0-x241.google.com (mail-pf0-x241.google.com
 [IPv6:2607:f8b0:400e:c00::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1F8E821C9E7B4
 for <linux-nvdimm@lists.01.org>; Thu,  6 Jul 2017 23:26:51 -0700 (PDT)
Received: by mail-pf0-x241.google.com with SMTP id q85so3289353pfq.2
 for <linux-nvdimm@lists.01.org>; Thu, 06 Jul 2017 23:28:32 -0700 (PDT)
Message-ID: <1499408836.23251.3.camel@gmail.com>
Subject: Re: [RFC v2 0/5] surface heterogeneous memory performance information
From: Balbir Singh <bsingharora@gmail.com>
Date: Fri, 07 Jul 2017 16:27:16 +1000
In-Reply-To: <20170706215233.11329-1-ross.zwisler@linux.intel.com>
References: <20170706215233.11329-1-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: "Box, David E" <david.e.box@intel.com>, Dave Hansen <dave.hansen@intel.com>, "Zheng, Lv" <lv.zheng@intel.com>, linux-nvdimm@lists.01.org, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Anaczkowski,, Robert, Lukasz, "Erik  <erik.schmauss@intel.com>, Len Brown" <lenb@kernel.org>, Jerome Glisse <jglisse@redhat.com>, devel@acpica.org, "Kogut, Jaroslaw" <Jaroslaw.Kogut@intel.com>, linux-mm@kvack.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Nachimuthu, Murugasamy" <murugasamy.nachimuthu@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "Lahtinen, Joonas  <joonas.lahtinen@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Tim Chen" <tim.c.chen@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 2017-07-06 at 15:52 -0600, Ross Zwisler wrote:
> ==== Quick Summary ====
> 
> Platforms in the very near future will have multiple types of memory
> attached to a single CPU.  These disparate memory ranges will have some
> characteristics in common, such as CPU cache coherence, but they can have
> wide ranges of performance both in terms of latency and bandwidth.
> 
> For example, consider a system that contains persistent memory, standard
> DDR memory and High Bandwidth Memory (HBM), all attached to the same CPU.
> There could potentially be an order of magnitude or more difference in
> performance between the slowest and fastest memory attached to that CPU.
> 
> With the current Linux code NUMA nodes are CPU-centric, so all the memory
> attached to a given CPU will be lumped into the same NUMA node.  This makes
> it very difficult for userspace applications to understand the performance
> of different memory ranges on a given CPU.
> 
> We solve this issue by providing userspace with performance information on
> individual memory ranges.  This performance information is exposed via
> sysfs:
> 
>   # grep . mem_tgt2/* mem_tgt2/local_init/* 2>/dev/null
>   mem_tgt2/firmware_id:1
>   mem_tgt2/is_cached:0
>   mem_tgt2/is_enabled:1
>   mem_tgt2/is_isolated:0

Could you please explain these charactersitics, are they in the patches
to follow?

>   mem_tgt2/phys_addr_base:0x0
>   mem_tgt2/phys_length_bytes:0x800000000
>   mem_tgt2/local_init/read_bw_MBps:30720
>   mem_tgt2/local_init/read_lat_nsec:100
>   mem_tgt2/local_init/write_bw_MBps:30720
>   mem_tgt2/local_init/write_lat_nsec:100
>

How to these numbers compare to normal system memory?
 
> This allows applications to easily find the memory that they want to use.
> We expect that the existing NUMA APIs will be enhanced to use this new
> information so that applications can continue to use them to select their
> desired memory.
> 
> This series is built upon acpica-1705:
> 
> https://github.com/zetalog/linux/commits/acpica-1705
> 
> And you can find a working tree here:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/zwisler/linux.git/log/?h=hmem_sysfs
> 
> ==== Lots of Details ====
> 
> This patch set is only concerned with CPU-addressable memory types, not
> on-device memory like what we have with Jerome Glisse's HMM series:
> 
> https://lwn.net/Articles/726691/
> 
> This patch set works by enabling the new Heterogeneous Memory Attribute
> Table (HMAT) table, newly defined in ACPI 6.2. One major conceptual change
> in ACPI 6.2 related to this work is that proximity domains no longer need
> to contain a processor.  We can now have memory-only proximity domains,
> which means that we can now have memory-only Linux NUMA nodes.
> 
> Here is an example configuration where we have a single processor, one
> range of regular memory and one range of HBM:
> 
>   +---------------+   +----------------+
>   | Processor     |   | Memory         |
>   | prox domain 0 +---+ prox domain 1  |
>   | NUMA node 1   |   | NUMA node 2    |
>   +-------+-------+   +----------------+
>           |
>   +-------+----------+
>   | HBM              |
>   | prox domain 2    |
>   | NUMA node 0      |
>   +------------------+
> 
> This gives us one initiator (the processor) and two targets (the two memory
> ranges).  Each of these three has its own ACPI proximity domain and
> associated Linux NUMA node.  Note also that while there is a 1:1 mapping
> from each proximity domain to each NUMA node, the numbers don't necessarily
> match up.  Additionally we can have extra NUMA nodes that don't map back to
> ACPI proximity domains.

Could you expand on proximity domains, are they the same as node distance
or is this ACPI terminology for something more?

> 
> The above configuration could also have the processor and one of the two
> memory ranges sharing a proximity domain and NUMA node, but for the
> purposes of the HMAT the two memory ranges will always need to be
> separated.
> 
> The overall goal of this series and of the HMAT is to allow users to
> identify memory using its performance characteristics.  This can broadly be
> done in one of two ways:
> 
> Option 1: Provide the user with a way to map between proximity domains and
> NUMA nodes and a way to access the HMAT directly (probably via
> /sys/firmware/acpi/tables).  Then, through possibly a library and a daemon,
> provide an API so that applications can either request information about
> memory ranges, or request memory allocations that meet a given set of
> performance characteristics.
> 
> Option 2: Provide the user with HMAT performance data directly in sysfs,
> allowing applications to directly access it without the need for the
> library and daemon.
> 
> The kernel work for option 1 is started by patches 1-3.  These just surface
> the minimal amount of information in sysfs to allow userspace to map
> between proximity domains and NUMA nodes so that the raw data in the HMAT
> table can be understood.
> 
> Patches 4 and 5 enable option 2, adding performance information from the
> HMAT to sysfs.  The second option is complicated by the amount of HMAT data
> that could be present in very large systems, so in this series we only
> surface performance information for local (initiator,target) pairings.  The
> changelog for patch 5 discusses this in detail.
> 
> The naming collision between Jerome's "Heterogeneous Memory Management
> (HMM)" and this "Heterogeneous Memory (HMEM)" series is unfortunate, but I
> was trying to stick with the word "Heterogeneous" because of the naming of
> the ACPI 6.2 Heterogeneous Memory Attribute Table table.  Suggestions for
> better naming are welcome.
>

Balbir Singh. 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
