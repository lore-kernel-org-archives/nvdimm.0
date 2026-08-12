Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD71B438FE4
	for <nvdimm@lists.linux.dev>; Wed, 12 Aug 2026 12:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786536089; cv=pass; b=sq6fvfarlajHkUa7FdSCTjv2JocrpXUUSHXtJEwFJQFG2EzMcXtV9l8H/vK9iKI3UcnHXyRjCKPfwavmP1qMGPPnmVHuCxLGaljhRxBS0DbcHRL2FFSJWVqYNyzaZRRxxpsxWHcyicugZSDfzp0577dhTw0iRFpzMWJz7gcgG8I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786536089; c=relaxed/simple;
	bh=LgGPpLftEwp0CnLEsD7pM/5eKNjoUz7B2czhXXSfOZ0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rBpD4+rA7Wl4priixbVuKH41K3KdiaMy1QqlK1XERfnOjQk+SsR3sVHTgGr3fZT/OAf6ZratBGcGf8uxcEaoN9fHkSxDjoLHwR65AB6usXCYqLD6uxoT1ZxvYMAtqwoIqZve3Z5nlAhsYzLbdlLP8O8NyoFqPegQZTEYzdPhoPA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mShZraG0; arc=pass smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mShZraG0"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-cbe6295f05bso1523019a12.1
        for <nvdimm@lists.linux.dev>; Wed, 12 Aug 2026 05:01:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786536085; cv=none;
        d=google.com; s=arc-20260327;
        b=RHvAg++3VaVo5YpP3+Look8rZtXll/qxzR9QLkKhCY6V7eJdoK7iNsrJs928yQCoan
         HzIdtmAUXl8UeK53gqgCXRWSLy1Nn0AxoR0sDHCYAdT/LHtXrUTgOerhQRgTMfY+u3uw
         NGknysbQX6TPjl+4lqd22oMIDV7jG/JUQzfhHTjs1n56E6ZD+3QpSJbSVGDnI4m+v13o
         G4A85kn76R1fQtYXFLYXtGhwN+c8lzT90x21MmZqO2EeFmQhsghmi7M8fHUymq89IAFu
         PJYRM88+EkS5LdXL8F78kkn3rTNR1IrGW2lVniD051C4BfvrKGA+4KeaIcvPUjU3J0iJ
         AUcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=GOsPf91w/kfhBgskarY7eMlVxP/pJcwod3Z/QymaRC0=;
        fh=Q4i+QrJsNlM7FmA2d3yyM7g+EGoykrcoeMi+3BPI7rQ=;
        b=PifGuoncWvm64Kq+k/ELF/t0hlOEE40P93qxu3JxMAVdsv+vPAO0DWfWj4mMnwQGGr
         HH0z+afFIynSD8APEo53Gws2puCa0SeJJEnznq0jtu/SjB2+lwJcGZKFRFB8hrUg19li
         vtUdtWZfCz8JPzAJalrIhg2y1u41DO80ZKKB0f7j7dFALdDpQ9VEvSRiz5Wo2femeuI3
         yHjDWLZCD5OHDTPpGUoKyFATYXC6nAHRfpIZ/rLOSIikoEjsl4i/Ff7sev1lC+71AXsD
         n/lM5NMI+9ltv1gdkdxHY6XGTefCPxOEcQRMBUV8QLqQGxobMlppw9mhnalms4DKbYMJ
         BUtg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786536085; x=1787140885; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GOsPf91w/kfhBgskarY7eMlVxP/pJcwod3Z/QymaRC0=;
        b=mShZraG0G3uje8y0lthDdRS6gJwwWOssvj9qyynY1wpUMvhezokQtTtt6k3Auf2PxZ
         oxXcbVXlklIentU8i0o+qC2gzY+twFJMhI27qKiFuExQbLpOjIzio7ImNqu2ipyFJhWr
         gZoUtalk/XZPULE+wI5yH/dEEGPkFz0Kd1TFEb6YqFBVY2J7iuFh34FxvH6Q3BaadmAH
         hYbUd11kHalHr/wmFwrzWkKbp7zsrVo/536ZWMlHHBlNXXmkye+t+d+m0/GjKpXn/c4S
         aUJwIX9UozFwXRfWGPb/drQvNH0O3bKXHYnTCbwa20cbryu5/QHtei2OsKv0pb3NMHWb
         y+8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786536085; x=1787140885;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=GOsPf91w/kfhBgskarY7eMlVxP/pJcwod3Z/QymaRC0=;
        b=j0JVA3VnIUI8Ur/bbRtZc36DG6YjclmFc1jGnN7c/iWGs8D8IulImXBnU+d1OMl0Vy
         YWSrQDSFrFxXWdmL1FMI/NSNwgJaoPbYaIHc3kNV4YBVNLTOvmrdXiCGFxapM0xrt/MA
         r5iDdfR/WvEhiHCmZWY+8gBuhWCgu8ySP5Fbw8psTTgQ1Mh9yXsQzzkwBMHCRGRxG/Ig
         On9q28B1a6ePgReU7E8TpawS/XBKttbTADPZQRqjPR4lk3eVwqlMJx9Aq6fOJFx1MAfZ
         e8ocUJ6j/bgXYa1P4Oa02dNixXSIASkBymPna6P73RTV4669yvy6sow/zIlwzTOZFlmr
         hXBA==
X-Forwarded-Encrypted: i=1; AHgh+Rpookow4gBpJ+gazFoYppXuV2Taff0+/lHlvB4qB6zCjx14R4wn/PegA3ttEQXKSbbv22eDsRs=@lists.linux.dev
X-Gm-Message-State: AOJu0YzkJXb/AUSSZWmba9mn5FwlKOgzbk443iWoibGWnVXMTKTPEsDD
	dD4sEyzpZU2avY2vdvj/xYqdngp3nJ4TbtI43ppEvU7XaybFiUukUYKLYe7wnDOXhSDr8/E6vpj
	KSZTBBguq2QMJ6zxtJ8XusAlp/9DLA9s=
X-Gm-Gg: AR+sD131uTlvte26GL9gDpvSrmrD6HD2MtCRftrOdzrIJhS5Mt9xEbK9Jhtw58v8LG7
	Zc0+JwlWeutgUD3E+vGvDbxg0rUSm9yvWtByMAMmFYMeDTn7MpKWP+b9Kuc6I9skL5ANyhF3BFa
	CvBQgXqA+NARMly0EldVOwp+XTCCpAgJRy8vl0h0wgZAh1BO48W3BsdlePzmGAps48omkH7tN5D
	In0PytEj4yuL5Sb8l3mant6glzsbk6nGEPSNIgRaHQJDavGV0GTwpFrRRzvwGnrLYg8VZE3ukQA
	aA6xOLgKYZ2uDWQZ9VyJdtOB5RcovxAQPY4nzDKXKR96C29SdSF5
X-Received: by 2002:a05:6a20:d81b:b0:3bf:651d:fee0 with SMTP id
 adf61e73a8af0-3cc3fa20d1cmr4666814637.19.1786536084468; Wed, 12 Aug 2026
 05:01:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260720193431.3841992-1-gourry@gourry.net>
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
From: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date: Wed, 12 Aug 2026 14:01:12 +0200
X-Gm-Features: AUfX_mwwL_kriQoTkS4BnDtMaCMg2_eZ1egK5NczE9N__8UNhYyuzTpRyjpcQH8
Message-ID: <CAM9Jb+jpJ-Ui4qDHxsp2WiERiv8gmrQfKQ8Z0BmabefeQ6pg4A@mail.gmail.com>
Subject: Re: [PATCH v5 00/36] Private Memory NUMA Nodes
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, Zhigang.Luo@amd.com, arun.george@samsung.com, 
	balbirs@nvidia.com, brendan.jackman@linux.dev, yuzenghui@huawei.com, 
	apopple@nvidia.com, alucerop@amd.com, matthew.brost@intel.com, 
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, corbet@lwn.net, skhan@linuxfoundation.org, 
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org, 
	djbw@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com, 
	alison.schofield@intel.com, osandov@osandov.com, jannh@google.com, 
	pfalcato@suse.de, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, 
	pbonzini@redhat.com, osalvador@suse.de, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, yury.norov@gmail.com, linux@rasmusvillemoes.dk, 
	longman@redhat.com, ridong.chen@linux.dev, tj@kernel.org, mkoutny@suse.com, 
	sj@kernel.org, jgg@ziepe.ca, jhubbard@nvidia.com, peterx@redhat.com, 
	baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, lance.yang@linux.dev, usama.arif@linux.dev, 
	xu.xin16@zte.com.cn, chengming.zhou@linux.dev, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, driver-core@lists.linux.dev, 
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	linux-debuggers@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	kvm@vger.kernel.org, cgroups@vger.kernel.org, damon@lists.linux.dev, 
	linux-kselftest@vger.kernel.org, kernel-team@meta.com, 
	"Gupta, Pankaj" <pankaj.gupta@amd.com>
Content-Type: text/plain; charset="UTF-8"

Hi Gregory,

>
> This series introduces the concept of "Private Memory Nodes", which
> are opted into two basic functionalities by default:
>   - page allocation (mm/page_alloc.c)
>   - OOM killing
>
> All other features of mm/ are opted out of managing these NUMA
> nodes and its memory.  Then we add capability bits to allow node
> owners to opt back into those services (if supported).
>
> NUMA-hosted memory is presently a most-privilege system (any memory on
> any node, except ZONE_DEVICE, is 100% fungible and accessible). We
> then slap restrictions on top of it (cpuset, mempolicy, ZONE type,
> page/folio flags, etc).
>
> The goal here is to flip that dynamic, isolate by default and then
> opt-in to specific services that the device says is safe.
>
> Isolation at the NUMA/Zonelist layer provides a powerful mechanism for
> memory hosted on accelerators - re-use of the kernel mm/ code.
>
>  - Accelerators (GPUs) can use demotion, numactl, and reclaim.
>  - Special memory devices (Compressed RAM) with special access controls
>    (promote-on-write) can have generic services written for them.
>  - Network devices with large memory regions intended for ring buffers
>    can use the buddy and standard networking stack.
>  - Slow, disaggregated memory pools which aren't suitable as general
>    purpose memory get cleaner interfaces (no need to re-write the buddy
>    in userland, can use migration interface, etc).
>  - Per-workload dedicated memory nodes (disaggregated VM memory)
>
> And more use cases I have collected over the past few years.
>
> Not included here is a dax-extension [1] that exposes all the internal
> bits as userland controls for testing - along with a pile of selftests
> that prove correctness.
>
> Changes Since V4
> ================
>  - Massive reduction in complexity.
>      - no ops struct
>      - no callback functions
>      - no __GFP_PRIVATE
>      - no __GFP_THISNODE requirement
>      - no task flags (no PF_MEMALLOC_* in the alloc path)
>  - isolation via a dedicated zonelist:
>      - private nodes are omitted from FALLBACK/NOFALLBACK
>      - added ZONELIST_PRIVATE(_NOFALLBACK)
>  - ALLOC_ZONELIST_PRIVATE alloc_flag
>      - on top of Brendan Jackman's recent mm/page_alloc.h work [3]
>      - Zonelist selection rides the allocator's alloc_flags
>  - rename OPS -> CAPS (capabilities)
>  - split base functionality (isolation) from opt-ins (CAPS)
>      - first half of series can be merged without CAPS
>  - dropped compressed ram example from series
>      - will submit separately if this moves forward
>  - Added KVM as first primary in-tree user (mempolicy / CAP_USER_NUMA)
>  - fully functional dax-kmem extension and huge suite of selftests
>    located at my github, to be discussed separately [1]
>
> Patch Layout
> ============
> The series is broken into two sections:
>
> 1) N_MEMORY_PRIVATE Introduction.
>    Introduce the node state.
>    Opt those nodes out of mm/ services.
>
> 2) NODE_PRIVATE_CAP_* features
>    A set of mm/ service opt-in flags that augment private
>    nodes to make them more useful (i.e. reclaim = overcommit).
>
>    NODE_PRIVATE_CAP_LTPIN for private node folio pinning
>    NODE_PRIVATE_CAP_NUMA_BALANCING for private-node NUMA balancing
>    NODE_PRIVATE_CAP_DEMOTION for private-node tiering demotion
>    NODE_PRIVATE_CAP_HOTUNPLUG for opted-in private nodes
>    NODE_PRIVATE_CAP_USER_NUMA for userland numa controls
>    NODE_PRIVATE_CAP_RECLAIM for opted-in private node reclaim
>
> My hope is to merge at least #1 pulled ahead while #2 is debated.
>
> Allocation Isolation
> ====================
> page_alloc presently controls whether a node's memory can be allocated
> on a given call by 4 things (in order of authority)
>
>   1) ZONELIST membership
>      If a node is not in the walked zonelist, it's unreachable.
>
>   2) __GFP_THISNODE
>      If this flag is set and the only node in the ZONELIST is the
>      singular preferred node (or the local node, for -1)
>
>   3) cpuset.mems membership
>      cpuset trims any node in its allowed list
>
>   4) mempolicy nodemask
>      the allocator will skip any node not in the nodemask.
>
> Except for #1 (Zonelist membership) there are all kinds of weird corner
> conditions in which 2-4 can be completely ignored (interrupt context,
> empty set because cpuset doesn't intersect mempolicy, shared vma, ...)
>
> But ZONELIST membership is *absolute*.  If a zone is not in the
> zonelist being walked, IT CANNOT BE ALLOCATED FROM. PERIOD.
>
> The existing zonelists are constructed like so:
>   ZONELIST_FALLBACK    : All N_MEMORY nodes
>   ZONELIST_NOFALLBACK  : A singleton N_MEMORY node
>
> Private node isolation is implemented via ZONELIST isolation:
>   ZONELIST_PRIVATE            : The private node + N_MEMORY
>   ZONELIST_PRIVATE_NOFALLBACK : The private node alone.
>
> (mirrors exactly the fallback/nofallback for __GFP_THISNODE)
>
> Private nodes:
>   1) Never appear in any ZONELIST_FALLBACK
>   2) Have an empty ZONELIST_NOFALLBACK
>   3) Only appear in their own ZONELIST_PRIVATE(_NOFALLBACK)
>
> 1 & 2 mean all existing in-tree callers to page_alloc can NEVER
> accidentally allocate from a private node.
>
> An allocation must explicitly ask via a zonelist and a nodemask.
>
>   alloc_flags |= ALLOC_ZONELIST_PRIVATE; /* use ZONELIST_PRIVATE */
>   __alloc_pages(..., nodemask);     /* with the private node set */
>
> The page allocator keeps all its original interfaces which only
> ever touch the default zonelists - avoiding churn.
>
> Making it accessible via Mempolicy: MPOL_F_PRIVATE and page_alloc
> =================================================================
> The vast majority of the kernel will never need to know about
> ZONELIST_PRIVATE, because we add MPOL_F_PRIVATE to mempolicy.
>
> When a mempolicy has MPOL_F_PRIVATE, the alloc_mpol() interfaces
> do the zonelist selection for the source of the allocation.
>
> That really is the whole explanation of the mechanism:
>
>   alloc_flags = mpol_alloc_flags(pol);
>   page = __alloc_frozen_pages_noprof(..., alloc_flags);
>
> On mm-new this rides the allocator's existing alloc_flags plumbing:
> ALLOC_ZONELIST_PRIVATE is just another alloc_flag, so no new
> parameter, enum, or alloc_context change is required.
>
> For modules that want to implement their own special handling, they
> get the _private variants for the page allocator.  This lets modules
> re-use the buddy instead of rewriting it.
>
>    - alloc_pages_node_private_noprof()
>    - folio_alloc_node_private_noprof()
>
> This keeps ALLOC_ flags mm/ internal (these functions add the flags).
>
> Isolating private node folios from kernel services
> ==================================================
> We implement filter points in mm/ to prevent operations on
> private node memory.  Where possible, we even re-use existing
> filter points from ZONE_DEVICE.
>
> Most filter points are one or two lines of code:
>
> Combining ZONE_DEVICE and N_MEMORY_PRIVATE opt-out spots:
>   -     if (folio_is_zone_device(folio))
>   +     if (unlikely(folio_is_private_managed(folio)))
>
> Disabling a service:
>   +  if (!node_is_private(nid)) {
>   +      kswapd_run(nid);
>   +      kcompactd_run(nid);
>   +  }
>
> Disallowing a uapi interaction:
>   +  if (node_state(nid, N_MEMORY_PRIVATE))
>   +      return -EINVAL;
>
> In the second half of the series, we replace blanket N_MEMORY_PRIVATE
> filters with NODE_PRIVATE_CAP_* filters to opt those nodes into that
> interaction if CAP is set.
>
> We abstract this with a nice clean interface to make it really clear
> what is happening (nodes have features!)
>
>   -  if (node_state(pgdat->node_id, N_MEMORY_PRIVATE))
>   +  if (!node_allows_reclaim(pgdat->node_id))
>
> NODE_PRIVATE_CAP_* features
> ===========================
> This series of commits opts private nodes into various mm/ services.
>
> Capabilities:
>   NODE_PRIVATE_CAP_RECLAIM       - direct and kswapd reclaim
>   NODE_PRIVATE_CAP_USER_NUMA     - userland numa controls
>   NODE_PRIVATE_CAP_DEMOTION      - node is a demotion target
>   NODE_PRIVATE_CAP_HOTUNPLUG     - hotunplug may migrate
>   NODE_PRIVATE_CAP_NUMA_BALANCING - NUMAB may target node folios
>   NODE_PRIVATE_CAP_LTPIN         - Longterm pin operates normally
>
> Some opt-in support is more intensive than others, so these features
> are broken out in a way that we can defer them as future work streams.
>
> NODE_PRIVATE_CAP_RECLAIM:
>   Enabling reclaim for these nodes is actually surprisingly trivial.
>
>   Without CAP_RECLAIM, when an allocation failure occurs, the system
>   will not attempt to swap the memory - and instead will OOM (typically
>   whatever task is using the most memory on *that* private node).
>
>   This capability consists of:
>     1) enabling kswapd and kcompactd for that node at hotplug time.
>     2) formalizing opt-out hooks to node_allows_reclaim() opt-in hooks.
>     3) Sets normal watermarks for these nodes.
>     4) Allow madvise operations on that node (PAGEOUT).
>     5) A small tweak to how LRU decides which zones to visit.
>
> NODE_PRIVATE_CAP_USER_NUMA
>   Enables the following userland interfaces to accept the node:
>     mbind()
>     set_mempolicy()
>     set_mempolicy_home_node()
>     move_pages()
>     migrate_pages()
>
>   example:
>      buf = mmap(..., MAP_ANON);
>      mbind(buf, ..., {private_node});
>      buf[0] = 0xDEADBEEF; /* Page faults onto the private node */
>
>   Later - the KVM example shows how in-kernel mempolicies can
>   also be bound by CAP_USER_NUMA.
>
>   Otherwise, that's it - it's just a mempolicy with MPOL_F_PRIVATE.
>
> NODE_PRIVATE_CAP_HOTUNPLUG
>   This is simple: allow hotunplug to migrate this nodes folios.
>
>   Some devices may not be able to tolerate unexpected migrations,
>   so we prevent hotunplug from engaging in migration by default.
>
>   Some devices may have an mmu_notifier in their driver that can
>   manage the migration and subsequent refault.
>
>   CAP_HOTUNPLUG allows memory_hotplug.c to migrate normally.
>
> NODE_PRIVATE_CAP_DEMOTION
>   This adds the private node as a valid demotion target, and allows
>   reclaim to demote memory from a private node to a demotion target.
>
>   Requires:  NODE_PRIVATE_CAP_RECLAIM
>
> NODE_PRIVATE_CAP_NUMA_BALANCING
>   This enables numa balancing to inject prot_none on private node
>   folio mappings and promote them when faults are taken.
>
> NODE_PRIVATE_CAP_LTPIN
>   This allows GUP Longterm Pinning to operate normally.
>
>   Normally, longterm pinning determines folio eligibility based
>   on its ZONE_* membership (among other things).
>
>   ZONE_NORMAL is eligible, while ZONE_MOVABLE folios require
>   migration to ZONE_NORMAL before pinning.
>
>   Neither operation is preferable by default on a private node,
>   so the base behavior of FOLL_LONGTERM is to FAIL.
>
>   This capability allows longterm pinning to operate normally
>   based on the ZONE membership.  Private node memory may be
>   hotplugged as either ZONE_NORMAL or ZONE_MOVABLE.
>
> In-tree User: KVM
> =================
> Dave Jiang proposed [2] dax-backed guest_memfd() memory as a way of
> enabling disaggregated memory pools to host dedicated KVM memory.
>
> With private nodes, this is trivial (with a bit of basic plumbing):
>
> static int kvm_gmem_bind_node(struct inode *inode, int node)
> {
> ...
>   /* Bind to a private node - gated on CAP_USER_NUMA */
>   pol = mpol_bind_node(node);
>   if (IS_ERR(pol))
>     return PTR_ERR(pol);
>
>   /* Set the shared policy */
>   err = mpol_set_shared_policy_range(&GMEM_I(inode)->policy, ..., pol);
> ...
> }
>
> KVM doesn't even need to know about private nodes at all, all it
> does is ask mempolicy whether the requested node is a valid bind.
>
> mm/ component testing with dax driver
> =====================================
> The dax driver extensions[1] implements a simple interface to create
> a private node from a dax device created by any source.
>
> I left the dax driver extensions out of this feature set because
> it locks in the CAP_ bits before anyone has input.  It's there
> primarily for testing at this point.
>
> The simplest way to get a dax device is with the memmap= boot arg.
>    e.g.: "memmap=0x40000000!0x140000000"
>
> The dax driver extension has the following sysfs entries:
>   dax0.0/private         - set the node to private
>   dax0.0/dax_file        - make /dev/dax0.0 mmap'able in kmem mode
>   dax0.0/adistance       - dictate memory_tierN membership
>   dax0.0/reclaim         - CAP_RECLAIM
>   dax0.0/demotion        - CAP_DEMOTION
>   dax0.0/user_numa       - CAP_USER_NUMA
>   dax0.0/hotunplug       - CAP_HOTUNPLUG
>   dax0.0/numa_balancing  - CAP_NUMA_BALANCING
>   dax0.0/ltpin           - CAP_LTPIN
>
> Now consider the following...
>
> Single node reclaim + mbind support:
>   echo 1 > dax0.0/private
>   echo 1 > dax0.0/reclaim
>   echo 1 > dax0.0/user_numa
>   echo online_movable > dax0.0/state
>
> Test program:
>    /* node1: 1GB Private Memory Node, 4GB swap */
>    buf = mmap(NULL, TWO_GB, PROT_READ | PROT_WRITE,
>               MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>    sys_mbind(p, len, MPOL_BIND, mask, MAXNODE, MPOL_MF_STRICT);
>    memset(buf, 0xff, TWO_GB);
>
> We can *guarantee* the ONLY reclaiming tasks are exactly:
>   - kswapdN (in theory we can even make this optional!)
>   - the memset task faulting pages in
>
> This also means these are the only tasks capable of becoming
> locked up and OOMing (as long as it is not under pressure).
>
> The rest of the system remains entirely functional for debugging.
>
> It now becomes possible to micro-benchmark and A/B test reclaim
> changes with different scenarios (number of tasks, amount of
> memory, watermark targets, etc), because we have hard controls
> over exactly which tasks can access that node memory and how.
>
> If we broke CAP_RECLAIM into subflags:
>   - CAP_RECLAIM_KSWAPD
>   - CAP_RECLAIM_DIRECT
>   - CAP_COMPACTION_KCOMPACTD
>   - CAP_COMPACTION_DIRECT
>
> We can actually test the efficacy of each of these mechanisms in
> isolation to each other - something that is strictly impossible today.
>
> Bonus Configuration: HBM device memory tiering
> ==============================================
> echo 1 > dax0.0/private       # make the node private
> echo 0 > dax0.0/adistance     # highest tier
> echo 1 > dax0.0/reclaim       # reclaim active
> echo 1 > dax0.0/demotion      # may demote from the node
> echo 1 > dax0.0/user_numa     # mbind()
> echo online_movable > dax0.0/state
> echo 1 > numa/demotion_enabled

I am bit confused by the HBM device example being discovered as a DAX
device. Is it to
only to showcase the use-case? Or we see HBM device is actually
expected to be discovered as
DAX device with N_MEMORY_PRIVATE?

Thanks,
Pankaj

>
> This is an HBM device which is treated as the top-tier in the
> system but for which memory can only enter via explicit mbind().
>
> It can be overcommitted because it can be reclaimed (demotions
> go to CPU DRAM, and reclaim can swap from it).
>
> If the HBM is managed by an accelerator (GPU), the mmu_notifier
> allows it to know when reclaim is moving memory out to do
> device-mmu invalidation prior to migration.
>
> Prereqs, base commit, references
> ================================
> akpm/mm-new - for Brendan Jackman's mm/page_alloc.h work[3]
>
> Prereqs (all already in akpm/mm-new; listed for out-of-tree application):
>
> page_alloc.h split + alloc_flags plumbing this series rides on:
> commit e81fae43cd69 ("mm: split out internal page_alloc.h")
> commit b4ff3b6d0a1d ("mm: replace __GFP_NO_CODETAG with ALLOC_NO_CODETAG")
>
> dax atomic whole-device hotplug (used by the dax extension [1]):
> commit d7aa81b9a919 ("mm/memory: add memory_block_aligned_range() helper")
> commit 3b2f402a1754 ("dax/kmem: add sysfs interface for atomic whole-device hotplug")
>
> [1] https://github.com/gourryinverse/linux/tree/scratch/gourry/managed_nodes/dax_private-mm-new
> [2] https://lore.kernel.org/all/20260423170219.281618-1-dave.jiang@intel.com/
> [3] https://lore.kernel.org/all/20260702-alloc-trylock-v4-0-0af8ff387e80@google.com/
>
> base-commit: c872b70f5d6c742ad34b8e838c92af81c8920b3e
>
> Gregory Price (36):
>   mm: refactor find_next_best_node to find_next_best_node_in
>   mm/page_alloc: refactor build_node_zonelist() out of build_zonelists()
>   mm/page_alloc: let the bulk and folio allocators carry alloc_flags
>   numa: introduce N_MEMORY_PRIVATE
>   mm: add ZONELIST_PRIVATE(_NOFALLBACK) for N_MEMORY_PRIVATE nodes.
>   cpuset: exclude private nodes from cpuset.mems (default-open)
>   mm/memory_hotplug: disallow migration-driven private node hotunplug
>   mm/mempolicy: skip private node folios when queueing for migration
>   mm/migrate: disallow userland driven migration for private nodes
>   mm/madvise: disallow madvise operations on private node folios
>   mm/compaction: disallow compaction on private nodes
>   mm/page_alloc: clear private node watermarks and system reserves
>   mm/mempolicy: disallow NUMA Balancing prot_none on private nodes
>   mm/damon: skip private node memory in DAMON migration and pageout
>   mm/ksm: skip KSM for managed-memory folios
>   mm/khugepaged: skip private node folios when trying to collapse.
>   mm/vmscan: disallow reclaim of private node memory
>   mm/gup: disallow longterm pin of private node folios
>   proc: include N_MEMORY_PRIVATE nodes in numa_maps output
>   mm/memcontrol: account private-node memory in per-node stats
>   proc/kcore: include private-node RAM in the kcore RAM map
>   mm/mempolicy: add MPOL_F_PRIVATE and zonelist selection
>   mm/mempolicy: apply policy at the kernel zone for private-node binds
>   mm/mempolicy: add in-kernel MPOL_BIND interfaces for drivers/services
>   mm/memory_hotplug: support N_MEMORY_PRIVATE node hotplug
>   mm: add NODE_PRIVATE_CAP_RECLAIM for opted-in private node reclaim
>   mm: add NODE_PRIVATE_CAP_USER_NUMA for userland numa controls
>   mm: add NODE_PRIVATE_CAP_HOTUNPLUG for opted-in private nodes
>   mm: add NODE_PRIVATE_CAP_DEMOTION for private-node tiering demotion
>   mm: add NODE_PRIVATE_CAP_NUMA_BALANCING for private-node NUMA
>     balancing
>   mm: add NODE_PRIVATE_CAP_LTPIN for private node folio pinning
>   mm/khugepaged: base private node collapse eligiblity on actor/cap bits
>   Documentation/mm: describe private (N_MEMORY_PRIVATE) memory nodes
>   mm/mempolicy: add mpol_set_shared_policy_range()
>   KVM: guest_memfd: bind backing memory to a NUMA node at creation
>   KVM: selftests: add a guest_memfd FLAG_BIND_NODE test
>
>  Documentation/ABI/stable/sysfs-devices-node   |  10 +
>  Documentation/mm/index.rst                    |   1 +
>  Documentation/mm/numa_private_nodes.rst       | 160 ++++++++++
>  drivers/base/node.c                           | 118 +++++++
>  drivers/dax/kmem.c                            |   2 +-
>  fs/proc/kcore.c                               |   5 +-
>  fs/proc/task_mmu.c                            |  10 +-
>  include/linux/gfp.h                           |  22 +-
>  include/linux/kvm_host.h                      |   3 +
>  include/linux/memory_hotplug.h                |   5 +-
>  include/linux/mempolicy.h                     |  16 +
>  include/linux/mmzone.h                        |  26 +-
>  include/linux/node_private.h                  | 262 ++++++++++++++++
>  include/linux/nodemask.h                      |   7 +-
>  include/uapi/linux/kvm.h                      |   5 +-
>  include/uapi/linux/mempolicy.h                |   1 +
>  kernel/cgroup/cpuset.c                        |  26 +-
>  mm/compaction.c                               |  13 +
>  mm/damon/paddr.c                              |   9 +
>  mm/gup.c                                      |  28 +-
>  mm/huge_memory.c                              |   5 +
>  mm/internal.h                                 |  97 +++++-
>  mm/khugepaged.c                               |  18 +-
>  mm/ksm.c                                      |   8 +-
>  mm/madvise.c                                  |   8 +-
>  mm/memcontrol-v1.c                            |   8 +-
>  mm/memcontrol.c                               |  13 +-
>  mm/memory-tiers.c                             |  40 ++-
>  mm/memory_hotplug.c                           | 119 +++++++-
>  mm/mempolicy.c                                | 288 +++++++++++++++---
>  mm/migrate.c                                  |  19 +-
>  mm/mm_init.c                                  |   2 +-
>  mm/page_alloc.c                               | 189 +++++++++---
>  mm/page_alloc.h                               |  34 +++
>  mm/vmscan.c                                   |  57 +++-
>  tools/testing/selftests/kvm/Makefile.kvm      |   2 +
>  .../kvm/guest_memfd_bind_node_test.c          | 213 +++++++++++++
>  virt/kvm/guest_memfd.c                        |  39 ++-
>  38 files changed, 1728 insertions(+), 160 deletions(-)
>  create mode 100644 Documentation/mm/numa_private_nodes.rst
>  create mode 100644 include/linux/node_private.h
>  create mode 100644 tools/testing/selftests/kvm/guest_memfd_bind_node_test.c
>
> --
> 2.53.0-Meta
>
>
