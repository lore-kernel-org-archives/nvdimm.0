Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
In-Reply-To: <20160126060028.GB2053@sudip-laptop>
References: <20160126000639.358.89668.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20160126060028.GB2053@sudip-laptop>
Date: Tue, 26 Jan 2016 09:07:02 -0800
Message-ID: <CAPcyv4hZadT=e_=yeegZeKPc-M-prBPZXEfZ97wnO4oi0DWndw@mail.gmail.com>
Subject: Re: [RFC PATCH] mm: support CONFIG_ZONE_DEVICE + CONFIG_ZONE_DMA
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: owner-linux-mm@kvack.org
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Mark <markk@clara.co.uk>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Hansen <dave.hansen@linux.intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Linux MM <linux-mm@kvack.org>, Ingo Molnar <mingo@redhat.com>, Mel Gorman <mgorman@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, Jerome Glisse <j.glisse@gmail.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jan 25, 2016 at 10:00 PM, Sudip Mukherjee
<sudipm.mukherjee@gmail.com> wrote:
> On Mon, Jan 25, 2016 at 04:06:40PM -0800, Dan Williams wrote:
>> It appears devices requiring ZONE_DMA are still prevalent (see link
>> below).  For this reason the proposal to require turning off ZONE_DMA to
>> enable ZONE_DEVICE is untenable in the short term.  We want a single
>> kernel image to be able to support legacy devices as well as next
>> generation persistent memory platforms.
>>
>> Towards this end, alias ZONE_DMA and ZONE_DEVICE to work around needing
>> to maintain a unique zone number for ZONE_DEVICE.  Record the geometry
>> of ZONE_DMA at init (->init_spanned_pages) and use that information in
>> is_zone_device_page() to differentiate pages allocated via
>> devm_memremap_pages() vs true ZONE_DMA pages.  Otherwise, use the
>> simpler definition of is_zone_device_page() when ZONE_DMA is turned off.
>>
>> Note that this also teaches the memory hot remove path that the zone may
>> not have sections for all pfn spans (->zone_dyn_start_pfn).
>>
>> A user visible implication of this change is potentially an unexpectedly
>> high "spanned" value in /proc/zoneinfo for the DMA zone.
>>
>> Cc: H. Peter Anvin <hpa@zytor.com>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: Rik van Riel <riel@redhat.com>
>> Cc: Mel Gorman <mgorman@suse.de>
>> Cc: Jerome Glisse <j.glisse@gmail.com>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: Dave Hansen <dave.hansen@linux.intel.com>
>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=110931
>> Fixes: 033fbae988fc ("mm: ZONE_DEVICE for "device memory"")
>> Reported-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
>
> It should actually be Reported-by: Mark <markk@clara.co.uk>
>
> Hi Mark,
> Can you please test this patch available at https://patchwork.kernel.org/patch/8116991/
> in your setup..

Note this patch is on top of 4.5-rc1 and is likely not a suitable for
-stable backport to 4.3/4.4.  For 4.3 and 4.4, distributions that want
to support legacy devices should leave ZONE_DEVICE disabled as it is
by default.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
