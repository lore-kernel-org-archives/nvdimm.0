Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2C93B211AEA5D
 for <linux-nvdimm@lists.01.org>; Mon, 28 Jan 2019 08:50:50 -0800 (PST)
Subject: Re: [PATCH 0/5] [v4] Allow persistent memory to be used like normal
 RAM
References: <20190124231441.37A4A305@viggo.jf.intel.com>
 <20190128110958.GH26056@350D>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <3ea28fe1-1828-1017-fa0f-da626d773440@intel.com>
Date: Mon, 28 Jan 2019 08:50:49 -0800
MIME-Version: 1.0
In-Reply-To: <20190128110958.GH26056@350D>
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
To: Balbir Singh <bsingharora@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>
Cc: thomas.lendacky@amd.com, mhocko@suse.com, linux-nvdimm@lists.01.org, tiwai@suse.de, zwisler@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, jglisse@redhat.com, fengguang.wu@intel.com, baiyaowei@cmss.chinamobile.com, ying.huang@intel.com, bhelgaas@google.com, akpm@linux-foundation.org, bp@suse.de
List-ID: <linux-nvdimm@lists.01.org>

On 1/28/19 3:09 AM, Balbir Singh wrote:
>> This is intended for Intel-style NVDIMMs (aka. Intel Optane DC
>> persistent memory) NVDIMMs.  These DIMMs are physically persistent,
>> more akin to flash than traditional RAM.  They are also expected to
>> be more cost-effective than using RAM, which is why folks want this
>> set in the first place.
> What variant of NVDIMM's F/P or both?

I'd expect this to get used in any cases where the NVDIMM is
cost-effective vs. DRAM.  Today, I think that's only NVDIMM-P.  At least
from what Wikipedia tells me about F vs. P vs. N:

	https://en.wikipedia.org/wiki/NVDIMM

>> == Patch Set Overview ==
>>
>> This series adds a new "driver" to which pmem devices can be
>> attached.  Once attached, the memory "owned" by the device is
>> hot-added to the kernel and managed like any other memory.  On
>> systems with an HMAT (a new ACPI table), each socket (roughly)
>> will have a separate NUMA node for its persistent memory so
>> this newly-added memory can be selected by its unique NUMA
>> node.
> 
> NUMA is distance based topology, does HMAT solve these problems?

NUMA is no longer just distance-based.  Any memory with different
properties, like different memory-side caches or bandwidth properties
can be in its own, discrete NUMA node.

> How do we prevent fallback nodes of normal nodes being pmem nodes?

NUMA policies.

> On an unexpected crash/failure is there a scrubbing mechanism
> or do we rely on the allocator to do the right thing prior to
> reallocating any memory.

Yes, but this is not unique to persistent memory.  On a kexec-based
crash, there might be old, sensitive data in *RAM* when the kernel comes
up.  We depend on the allocator to zero things there.  We also just
plain depend on the allocator to zero things so we don't leak
information when recycling pages in the first place.

I can't think of a scenario where some kind of "leak" of old data
wouldn't also be a bug with normal, volatile RAM.

> Will frequent zero'ing hurt NVDIMM/pmem's life times?

Everybody reputable that sells things with limited endurance quantifies
the endurance.  I'd suggest that folks know what the endurance of their
media is before enabling this.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
