Return-Path: <owner-linux-mm@kvack.org>
From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH v3 0/3] create sysfs representation of ACPI HMAT
In-Reply-To: <20171220181937.GB12236@bombadil.infradead.org>
References: <20171214021019.13579-1-ross.zwisler@linux.intel.com> <20171214130032.GK16951@dhcp22.suse.cz> <20171218203547.GA2366@linux.intel.com> <20171220181937.GB12236@bombadil.infradead.org>
Date: Thu, 21 Dec 2017 23:50:40 +1100
Message-ID: <87mv2cfdnj.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: owner-linux-mm@kvack.org
To: Matthew Wilcox <willy@infradead.org>, Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Michal Hocko <mhocko@kernel.org>, "Box, David E" <david.e.box@intel.com>, Dave Hansen <dave.hansen@intel.com>, "Zheng, Lv" <lv.zheng@intel.com>, linux-nvdimm@lists.01.org, "Verma, Vishal L" <vishal.l.verma@intel.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Anaczkowski,, Robert, Lukasz, Erik, Jaroslaw, Marcin, Murugasamy, Artur, Joonas
List-ID: <linux-nvdimm@lists.01.org>

Matthew Wilcox <willy@infradead.org> writes:

> On Mon, Dec 18, 2017 at 01:35:47PM -0700, Ross Zwisler wrote:
>> What I'm hoping to do with this series is to just provide a sysfs
>> representation of the HMAT so that applications can know which NUMA nodes to
>> select with existing utilities like numactl.  This series does not currently
>> alter any kernel behavior, it only provides a sysfs interface.
>> 
>> Say for example you had a system with some high bandwidth memory (HBM), and
>> you wanted to use it for a specific application.  You could use the sysfs
>> representation of the HMAT to figure out which memory target held your HBM.
>> You could do this by looking at the local bandwidth values for the various
>> memory targets, so:
>> 
>> 	# grep . /sys/devices/system/hmat/mem_tgt*/local_init/write_bw_MBps
>> 	/sys/devices/system/hmat/mem_tgt2/local_init/write_bw_MBps:81920
>> 	/sys/devices/system/hmat/mem_tgt3/local_init/write_bw_MBps:40960
>> 	/sys/devices/system/hmat/mem_tgt4/local_init/write_bw_MBps:40960
>> 	/sys/devices/system/hmat/mem_tgt5/local_init/write_bw_MBps:40960
>> 
>> and look for the one that corresponds to your HBM speed. (These numbers are
>> made up, but you get the idea.)
>
> Presumably ACPI-based platforms will not be the only ones who have the
> ability to expose different bandwidth memories in the future.  I think
> we need a platform-agnostic way ... right, PowerPC people?

Yes!

I don't have any detail at hand but will try and rustle something up.

cheers

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
