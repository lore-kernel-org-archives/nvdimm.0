Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C2E8421CF25AD
 for <linux-nvdimm@lists.01.org>; Fri,  7 Jul 2017 09:18:17 -0700 (PDT)
Subject: Re: [RFC v2 0/5] surface heterogeneous memory performance information
References: <20170706215233.11329-1-ross.zwisler@linux.intel.com>
 <1499408836.23251.3.camel@gmail.com>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <599ebf96-fc06-1478-b805-349d13a0e652@intel.com>
Date: Fri, 7 Jul 2017 09:19:49 -0700
MIME-Version: 1.0
In-Reply-To: <1499408836.23251.3.camel@gmail.com>
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
To: Balbir Singh <bsingharora@gmail.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: "Box, David E" <david.e.box@intel.com>, linux-mm@kvack.org, "Zheng, Lv  <lv.zheng@intel.com>, linux-nvdimm@lists.01.org, Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Anaczkowski,, Robert, Lukasz, "Erik  <erik.schmauss@intel.com>, Len Brown" <lenb@kernel.org>, Jerome Glisse <jglisse@redhat.com>, devel@acpica.org, "Kogut, Jaroslaw" <Jaroslaw.Kogut@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Nachimuthu, Murugasamy  <murugasamy.nachimuthu@intel.com>, Rafael J. Wysocki" <rjw@rjwysocki.net>, "Lahtinen, Joonas  <joonas.lahtinen@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Tim Chen" <tim.c.chen@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On 07/06/2017 11:27 PM, Balbir Singh wrote:
> On Thu, 2017-07-06 at 15:52 -0600, Ross Zwisler wrote:
>>   # grep . mem_tgt2/* mem_tgt2/local_init/* 2>/dev/null
>>   mem_tgt2/firmware_id:1

This is here for folks that know their platform and know exactly the
firmware ID (PXM in ACPI parlance) of a given piece of memory.  Without
this, we might be stuck with requiring the NUMA node ID that the kernel
uses to be bound 1:1 with the firmware ID.

>>   mem_tgt2/is_cached:0

This tells whether the memory is cached by some other memory.  MCDRAM is
an example of this.  It can be used as a high-bandwidth cache in front
of the lower-bandwidth DRAM.

This is referred to as "Memory Side Cache Information Structure" in the
ACPI spec: www.uefi.org/sites/default/files/resources/ACPI_6_2.pdf

>>   mem_tgt2/is_enabled:1
>>   mem_tgt2/is_isolated:0

This one is described in detail in the ACPI spec.  It's called
"Reservation hint" in there.

>>   mem_tgt2/phys_addr_base:0x0
>>   mem_tgt2/phys_length_bytes:0x800000000
>>   mem_tgt2/local_init/read_bw_MBps:30720
>>   mem_tgt2/local_init/read_lat_nsec:100
>>   mem_tgt2/local_init/write_bw_MBps:30720
>>   mem_tgt2/local_init/write_lat_nsec:100
> 
> How to these numbers compare to normal system memory?

They're made up in this instance.  But, it's safe to expect 10x swings
in bandwidth in latency, both up and down.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
