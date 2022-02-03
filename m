Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8A32F27
	for <nvdimm@lists.linux.dev>; Thu,  3 Feb 2022 02:22:46 +0000 (UTC)
Received: by mail-pj1-f54.google.com with SMTP id v15-20020a17090a4ecf00b001b82db48754so1455834pjl.2
        for <nvdimm@lists.linux.dev>; Wed, 02 Feb 2022 18:22:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ajou.ac.kr; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=NvlOEPwiTOySvSflpH7AZs5v2kcze74PyHF7XC7oTMo=;
        b=Qg01IPUOpc2UNwsvikmGqrijwYrqWdI7PG7u+P8yRM5qvktW9YMsCQdD5hsIS6H4/P
         iY0IuDsLvnABUP4zG2ek0ua9YDRWDmkomB5U6nLEkcbqdkBrgfA1PSUFTumG4mWjrsQV
         Bq8KIyU2gcuej0ZfGjV4tRXTF7vIMy/9DdzBQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=NvlOEPwiTOySvSflpH7AZs5v2kcze74PyHF7XC7oTMo=;
        b=QzkgyVhohxMHMCPE5K+ieoZAHtxJkU4+6S7/OMd5NvnXkaW5GF59hVVScQ7ixfaX0K
         MuesJRALt/cWAPEMIINOmSh/JQgbma1AFB5OsKM19E++v8dWIuTvrlHoiORm6pAJaIBA
         lv7NsuUVk/+mXdca8HIHYTIPkTfFqBVTjBY0RfGZo4pFHFrwx1IjVuPKzCi2BKVyOo9z
         CJd/4re+F1FamZ4QokXo1Rv+8rWzXJz/3kdYKhqKVH8gXREUpudDlYzvpeowmq+axvnF
         axrij40QuWXEQrEG7HMY7Oju96imY41MtRuijIh0vVLjwHyGMf9tPmScN5iXpWQ/C4RO
         MbNQ==
X-Gm-Message-State: AOAM530yLk+rCkWxy7MzEe6DVDc6Drh1OtM6E2Djcb7Sb1uvAE8ukeXu
	7R74hvmcruK3zkHX/3lWvypH2A==
X-Google-Smtp-Source: ABdhPJwWcN9lNjMiT48VHCz0AQHoCAjMQCmg450nq87NqpEA+aISSjJuXUlYQtgXottab7w98kr25w==
X-Received: by 2002:a17:90b:3b42:: with SMTP id ot2mr11301188pjb.204.1643854965861;
        Wed, 02 Feb 2022 18:22:45 -0800 (PST)
Received: from swarm08 ([210.107.197.32])
        by smtp.gmail.com with ESMTPSA id l26sm34855129pgm.73.2022.02.02.18.22.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 02 Feb 2022 18:22:45 -0800 (PST)
Date: Thu, 3 Feb 2022 11:22:41 +0900
From: Jonghyeon Kim <tome01@ajou.ac.kr>
To: David Hildenbrand <david@redhat.com>
Cc: dan.j.williams@intel.com, vishal.l.verma@intel.com,
	dave.jiang@intel.com, akpm@linux-foundation.org,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 1/2] mm/memory_hotplug: Export shrink span functions for
 zone and node
Message-ID: <20220203022241.GA27120@swarm08>
References: <20220126170002.19754-1-tome01@ajou.ac.kr>
 <5d02ea0e-aca6-a64b-23de-bc9307572d17@redhat.com>
 <20220127094142.GA31409@swarm08>
 <696b782f-0b50-9861-a34d-cf750d4244bd@redhat.com>
 <20220128041959.GA20345@swarm08>
 <df613a5e-bf32-a03e-e06f-5dcb3444c3d4@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df613a5e-bf32-a03e-e06f-5dcb3444c3d4@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)

On Fri, Jan 28, 2022 at 09:10:21AM +0100, David Hildenbrand wrote:
> On 28.01.22 05:19, Jonghyeon Kim wrote:
> > On Thu, Jan 27, 2022 at 10:54:23AM +0100, David Hildenbrand wrote:
> >> On 27.01.22 10:41, Jonghyeon Kim wrote:
> >>> On Wed, Jan 26, 2022 at 06:04:50PM +0100, David Hildenbrand wrote:
> >>>> On 26.01.22 18:00, Jonghyeon Kim wrote:
> >>>>> Export shrink_zone_span() and update_pgdat_span() functions to head
> >>>>> file. We need to update real number of spanned pages for NUMA nodes and
> >>>>> zones when we add memory device node such as device dax memory.
> >>>>>
> >>>>
> >>>> Can you elaborate a bit more what you intend to fix?
> >>>>
> >>>> Memory onlining/offlining is reponsible for updating the node/zone span,
> >>>> and that's triggered when the dax/kmem mamory gets onlined/offlined.
> >>>>
> >>> Sure, sorry for the lack of explanation of the intended fix.
> >>>
> >>> Before onlining nvdimm memory using dax(devdax or fsdax), these memory belong to
> >>> cpu NUMA nodes, which extends span pages of node/zone as a ZONE_DEVICE. So there
> >>> is no problem because node/zone contain these additional non-visible memory
> >>> devices to the system.
> >>> But, if we online dax-memory, zone[ZONE_DEVICE] of CPU NUMA node is hot-plugged
> >>> to new NUMA node(but CPU-less). I think there is no need to hold
> >>> zone[ZONE_DEVICE] pages on the original node.
> >>>
> >>> Additionally, spanned pages are also used to calculate the end pfn of a node.
> >>> Thus, it is needed to maintain accurate page stats for node/zone.
> >>>
> >>> My machine contains two CPU-socket consisting of DRAM and Intel DCPMM
> >>> (DC persistent memory modules) with App-Direct mode.
> >>>
> >>> Below are my test results.
> >>>
> >>> Before memory onlining:
> >>>
> >>> 	# ndctl create-namespace --mode=devdax
> >>> 	# ndctl create-namespace --mode=devdax
> >>> 	# cat /proc/zoneinfo | grep -E "Node|spanned" | paste - -
> >>> 	Node 0, zone      DMA	        spanned  4095
> >>> 	Node 0, zone    DMA32	        spanned  1044480
> >>> 	Node 0, zone   Normal	        spanned  7864320
> >>> 	Node 0, zone  Movable	        spanned  0
> >>> 	Node 0, zone   Device	        spanned  66060288
> >>> 	Node 1, zone      DMA	        spanned  0
> >>> 	Node 1, zone    DMA32	        spanned  0
> >>> 	Node 1, zone   Normal	        spanned  8388608
> >>> 	Node 1, zone  Movable	        spanned  0
> >>> 	Node 1, zone   Device	        spanned  66060288
> >>>
> >>> After memory onlining:
> >>>
> >>> 	# daxctl reconfigure-device --mode=system-ram --no-online dax0.0
> >>> 	# daxctl reconfigure-device --mode=system-ram --no-online dax1.0
> >>>
> >>> 	# cat /proc/zoneinfo | grep -E "Node|spanned" | paste - -
> >>> 	Node 0, zone      DMA	        spanned  4095
> >>> 	Node 0, zone    DMA32	        spanned  1044480
> >>> 	Node 0, zone   Normal	        spanned  7864320
> >>> 	Node 0, zone  Movable	        spanned  0
> >>> 	Node 0, zone   Device	        spanned  66060288
> >>> 	Node 1, zone      DMA	        spanned  0
> >>> 	Node 1, zone    DMA32	        spanned  0
> >>> 	Node 1, zone   Normal	        spanned  8388608
> >>> 	Node 1, zone  Movable	        spanned  0
> >>> 	Node 1, zone   Device	        spanned  66060288
> >>> 	Node 2, zone      DMA	        spanned  0
> >>> 	Node 2, zone    DMA32	        spanned  0
> >>> 	Node 2, zone   Normal	        spanned  65011712
> >>> 	Node 2, zone  Movable	        spanned  0
> >>> 	Node 2, zone   Device	        spanned  0
> >>> 	Node 3, zone      DMA	        spanned  0
> >>> 	Node 3, zone    DMA32	        spanned  0
> >>> 	Node 3, zone   Normal	        spanned  65011712
> >>> 	Node 3, zone  Movable	        spanned  0
> >>> 	Node 3, zone   Device	        spanned  0
> >>>
> >>> As we can see, Node 0 and 1 still have zone_device pages after memory onlining.
> >>> This causes problem that Node 0 and Node 2 have same end of pfn values, also 
> >>> Node 1 and Node 3 have same problem.
> >>
> >> Thanks for the information, that makes it clearer.
> >>
> >> While this unfortunate, the node/zone span is something fairly
> >> unreliable/unusable for user space. Nodes and zones can overlap just easily.
> >>
> >> What counts are present/managed pages in the node/zone.
> >>
> >> So at least I don't count this as something that "needs fixing",
> >> it's more something that's nice to handle better if easily possible.
> >>
> >> See below.
> >>
> >>>
> >>>>> Signed-off-by: Jonghyeon Kim <tome01@ajou.ac.kr>
> >>>>> ---
> >>>>>  include/linux/memory_hotplug.h | 3 +++
> >>>>>  mm/memory_hotplug.c            | 6 ++++--
> >>>>>  2 files changed, 7 insertions(+), 2 deletions(-)
> >>>>>
> >>>>> diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
> >>>>> index be48e003a518..25c7f60c317e 100644
> >>>>> --- a/include/linux/memory_hotplug.h
> >>>>> +++ b/include/linux/memory_hotplug.h
> >>>>> @@ -337,6 +337,9 @@ extern void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
> >>>>>  extern void remove_pfn_range_from_zone(struct zone *zone,
> >>>>>  				       unsigned long start_pfn,
> >>>>>  				       unsigned long nr_pages);
> >>>>> +extern void shrink_zone_span(struct zone *zone, unsigned long start_pfn,
> >>>>> +			     unsigned long end_pfn);
> >>>>> +extern void update_pgdat_span(struct pglist_data *pgdat);
> >>>>>  extern bool is_memblock_offlined(struct memory_block *mem);
> >>>>>  extern int sparse_add_section(int nid, unsigned long pfn,
> >>>>>  		unsigned long nr_pages, struct vmem_altmap *altmap);
> >>>>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> >>>>> index 2a9627dc784c..38f46a9ef853 100644
> >>>>> --- a/mm/memory_hotplug.c
> >>>>> +++ b/mm/memory_hotplug.c
> >>>>> @@ -389,7 +389,7 @@ static unsigned long find_biggest_section_pfn(int nid, struct zone *zone,
> >>>>>  	return 0;
> >>>>>  }
> >>>>>  
> >>>>> -static void shrink_zone_span(struct zone *zone, unsigned long start_pfn,
> >>>>> +void shrink_zone_span(struct zone *zone, unsigned long start_pfn,
> >>>>>  			     unsigned long end_pfn)
> >>>>>  {
> >>>>>  	unsigned long pfn;
> >>>>> @@ -428,8 +428,9 @@ static void shrink_zone_span(struct zone *zone, unsigned long start_pfn,
> >>>>>  		}
> >>>>>  	}
> >>>>>  }
> >>>>> +EXPORT_SYMBOL_GPL(shrink_zone_span);
> >>>>
> >>>> Exporting both as symbols feels very wrong. This is memory
> >>>> onlining/offlining internal stuff.
> >>>
> >>> I agree with you that your comment. I will find another approach to avoid
> >>> directly using onlining/offlining internal stuff while updating node/zone span.
> >>
> >> IIRC, to handle what you intend to handle properly want to look into teaching
> >> remove_pfn_range_from_zone() to handle zone_is_zone_device().
> >>
> >> There is a big fat comment:
> >>
> >> 	/*
> >> 	 * Zone shrinking code cannot properly deal with ZONE_DEVICE. So
> >> 	 * we will not try to shrink the zones - which is okay as
> >> 	 * set_zone_contiguous() cannot deal with ZONE_DEVICE either way.
> >> 	 */
> >> 	if (zone_is_zone_device(zone))
> >> 		return;
> >>
> >>
> >> Similarly, try_offline_node() spells this out:
> >>
> >> 	/*
> >> 	 * If the node still spans pages (especially ZONE_DEVICE), don't
> >> 	 * offline it. A node spans memory after move_pfn_range_to_zone(),
> >> 	 * e.g., after the memory block was onlined.
> >> 	 */
> >> 	if (pgdat->node_spanned_pages)
> >> 		return;
> >>
> >>
> >> So once you handle remove_pfn_range_from_zone() cleanly, you'll cleanly handle
> >> try_offline_node() implicitly.
> >>
> >> Trying to update the node span manually without teaching node/zone shrinking code how to
> >> handle ZONE_DEVICE properly is just a hack that will only sometimes work. Especially, it
> >> won't work if the range of interest is still surrounded by other ranges.
> >>
> > 
> > Thanks for your pointing out, I missed those comments.
> > I will keep trying to handle node/zone span updating process.
> 
> The only safe thing right now for on ZONE_DEVICE in
> remove_pfn_range_from_zone() would be removing the given range from the
> start/end of the zone range, but we must not scan using the existing
> functions.
> 
> As soon as we start actual *scanning* via find_smallest...
> find_biggest... in shrink_zone_span() we would mistakenly skip other
> ZONE_DEVICE ranges and mess up.
> 
> Assume you would have a ZONE_DEVICE layout like
> 
> [  DEV 0 | Hole | DEV 1 | Hole | DEV 2 ]
> 

IIUC, you assumed situation that multiple ZONE_DEVICE in single node, and there
are holes among them, right?

> What we actually want to do when removing
> 
> * DEV 0 is scanning low->high until we find DEV 1
> * DEV 1 is doing nothing, because we cannot shrink
> * DEV 2 is scanning high -> low until we find DEV 1
> 
> 
> I assume we'd want to call in shrink_zone_span() two new functions for
> ZONE_DEVICE:
> find_smallest_zone_device_pfn
> find_biggest_zone_device_pfn
> 
> Which would be able to do exactly that scanning, eventually, using
> get_dev_pagemap() or some similar source of information.
> 

I agree with your suggestion. It might cleanly deal with ZONE_DEVICE with actual
page scanning for checking holes.

> -- 
> Thanks,
> 
> David / dhildenb
> 
