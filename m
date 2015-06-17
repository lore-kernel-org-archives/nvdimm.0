Return-Path: <linux-kernel-owner@vger.kernel.org>
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH v6 07/21] libnvdimm, nfit: regions (block-data-window, persistent memory, volatile memory)
Date: Thu, 18 Jun 2015 00:03:50 +0200
Message-ID: <2337285.ixNCaGxhrS@vostro.rjw.lan>
In-Reply-To: <20150611201047.25175.43773.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150611183830.25175.51256.stgit@dwillia2-desk3.amr.corp.intel.com> <20150611201047.25175.43773.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, mingo@kernel.org, sfr@canb.auug.org.au, rafael@kernel.org, neilb@suse.de, gregkh@linuxfoundation.org, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Robert Moore <robert.moore@intel.com>, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, jmoyer@redhat.com, axboe@kernel.dk, linux-api@vger.kernel.org, akpm@linux-foundation.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

On Thursday, June 11, 2015 04:10:47 PM Dan Williams wrote:
> A "region" device represents the maximum capacity of a BLK range (mmio
> block-data-window(s)), or a PMEM range (DAX-capable persistent memory or
> volatile memory), without regard for aliasing.  Aliasing, in the
> dimm-local address space (DPA), is resolved by metadata on a dimm to
> designate which exclusive interface will access the aliased DPA ranges.
> Support for the per-dimm metadata/label arrvies is in a subsequent
> patch.
> 
> The name format of "region" devices is "regionN" where, like dimms, N is
> a global ida index assigned at discovery time.  This id is not reliable
> across reboots nor in the presence of hotplug.  Look to attributes of
> the region or static id-data of the sub-namespace to generate a
> persistent name.  However, if the platform configuration does not change
> it is reasonable to expect the same region id to be assigned at the next
> boot.
> 
> "region"s have 2 generic attributes "size", and "mapping"s where:
> - size: the BLK accessible capacity or the span of the
>   system physical address range in the case of PMEM.
> 
> - mappingN: a tuple describing a dimm's contribution to the region's
>   capacity in the format (<nmemX>,<dpa>,<size>).  For a PMEM-region
>   there will be at least one mapping per dimm in the interleave set.  For
>   a BLK-region there is only "mapping0" listing the starting DPA of the
>   BLK-region and the available DPA capacity of that space (matches "size"
>   above).
> 
> The max number of mappings per "region" is hard coded per the
> constraints of sysfs attribute groups.  That said the number of mappings
> per region should never exceed the maximum number of possible dimms in
> the system.  If the current number turns out to not be enough then the
> "mappings" attribute clarifies how many there are supposed to be. "32
> should be enough for anybody...".
> 
> Cc: Neil Brown <neilb@suse.de>
> Cc: <linux-acpi@vger.kernel.org>
> Cc: Greg KH <gregkh@linuxfoundation.org>
> Cc: Robert Moore <robert.moore@intel.com>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

For the ACPI part:

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

