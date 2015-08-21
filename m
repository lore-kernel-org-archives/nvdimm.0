Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
In-Reply-To: <20150815085954.GC21033@lst.de>
References: <20150813031253.36913.29580.stgit@otcpl-skl-sds-2.jf.intel.com>
	<20150813035005.36913.77364.stgit@otcpl-skl-sds-2.jf.intel.com>
	<20150814213714.GA3265@gmail.com>
	<CAPcyv4ib244VMSdhHDWHRnmCvYdteUEzT+ehTzitSY42m2Tt=w@mail.gmail.com>
	<20150815085954.GC21033@lst.de>
Date: Fri, 21 Aug 2015 08:02:51 -0700
Message-ID: <CAPcyv4jiXqcy_kUrArw7cpbySDoaQe+UF5JcvihxyGyxjsWKZw@mail.gmail.com>
Subject: Re: [RFC PATCH 1/7] x86, mm: ZONE_DEVICE for "device memory"
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: owner-linux-mm@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jerome Glisse <j.glisse@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Boaz Harrosh <boaz@plexistor.com>, Rik van Riel <riel@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Hansen <dave.hansen@linux.intel.com>, david <david@fromorbit.com>, Ingo Molnar <mingo@kernel.org>, Linux MM <linux-mm@kvack.org>, Ingo Molnar <mingo@redhat.com>, Mel Gorman <mgorman@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, David Woodhouse <dwmw2@infradead.org>
List-ID: <linux-nvdimm@lists.01.org>

[ Adding David Woodhouse ]

On Sat, Aug 15, 2015 at 1:59 AM, Christoph Hellwig <hch@lst.de> wrote:
> On Fri, Aug 14, 2015 at 02:52:15PM -0700, Dan Williams wrote:
>> The idea is that this memory is not meant to be available to the page
>> allocator and should not count as new memory capacity.  We're only
>> hotplugging it to get struct page coverage.
>
> This might need a bigger audit of the max_pfn usages.  I remember
> architectures using it as a decisions for using IOMMUs or similar.

We chatted about this at LPC yesterday.  The takeaway was that the
max_pfn checks that the IOMMU code does is for checking whether a
device needs an io-virtual mapping to reach addresses above its DMA
limit (if it can't do 64-bit DMA).  Given the capacities of persistent
memory it's likely that a device with this limitation already can't
address all of RAM let alone PMEM.   So it seems to me that updating
max_pfn for PMEM hotplug does not buy us anything except a few more
opportunities to confuse PMEM as typical RAM.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
