Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333EC43BDAF
	for <nvdimm@lists.linux.dev>; Wed, 22 Jul 2026 15:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784734817; cv=none; b=qDjUTNf6b7f0RTSacBEi58QetGlgnN8bhMg0LvnPkNunMrp+UcSPdCyrW2euQlS5bgSir3bRjteUGKof/dAmJyEOhRR2YvlM+fLn5YNzbtBu2OzxIkbLlaBCJl3gwaLKpNWnpLE0LD7CzRLAfzwqSMJ7uezUPvs69RNPN4LU5gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784734817; c=relaxed/simple;
	bh=Yr9xb70jqiacZC5C3W2M/iYWSqCrqiufBDUWljNiIj8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pu8+dqpi3o6hieAukamsQj8k/1fmXqh/f6+fx3yIxgXtdhsTv7yf6TMMc2d32c/wbncjpb2m79wBCAzVhkB64K/Z8pFmu0qP4XvaPou01TAKdtwanFcgeqkpgGNjcNlSgkhd/x1/uzlDJVqQIkpTzTa5X59EXKQkDxHxfNhNqFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=iRkOzYv3; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="iRkOzYv3"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-92e85499ffbso747115285a.0
        for <nvdimm@lists.linux.dev>; Wed, 22 Jul 2026 08:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784734813; x=1785339613; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Z9WM+2MFVnedGDWLPttsIf94o07ITbEUNNq93LWWdyQ=;
        b=iRkOzYv3X9o0d581DAElSFL97A8qHMsndBeqbfkwtvMWzkpJBUuAfYokGDfL1az/sC
         /riz3AQMDh/EryEK0t3Wry/34trGzISWv+yx94KQZfruKf2w/K0lcIz4mcmkGI7jvak7
         bsbk3JtLzSTn34kS25nJmWySAvcDZsUtKq9lZxS6eGvPPcOIe7euVvtwyOO1Z1hWw65X
         y1imbr2Nb4Hp8QXHFfSSlKIoOhCKjWs9ToCpROrVw0+q0NtE3qOot+GUjmqO5MSt9ZMK
         KB2dUbt41bKA/QiTNNS1vheq9fHUE6KX2zSTUaVcJ1+OuA9Ru4Z6EulzaznDoBRFjYX1
         SR4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784734813; x=1785339613;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Z9WM+2MFVnedGDWLPttsIf94o07ITbEUNNq93LWWdyQ=;
        b=Gi+HFmJlEyRBqKEKZg7xajQNKofS/uwa3QF94OFVStE0SF0QYTsVVRqt/CDPyopNp/
         GLIJSGMkh2fU4XfqXzF+MW4uWlrwBBrH+Ccv1V6TrJ9a0EawrWeVuyFj+vY7dKO6rN34
         fYhClgu2mzmnGYbnYooKwRGfpdH1hFfbfWG0c8iWXPdqKWrJnb012zv7LhtDmbjd2O9k
         +Xl4Q8abo7pyAOrrr5pDj1ZBfCUamEiNjWYjES0I9isI5X9WsEVAGXjN/LgB0SXrqf/g
         SYl9zInexooq9Br4Tj6TA3dc9rckmI6orFLX1Di7AMyaCDZOI4rgr7E2WXXzFc3O7N/I
         y/nQ==
X-Forwarded-Encrypted: i=1; AHgh+RrUUI2bMwEW8pm5u6dceVOq44Bl3pVbdeFEz50JSE9bKOTq3tiWvCMKju8e13K+0ZH8qsZjw1s=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz2Pkg0ouReLt1trB7z3vUrlIOyYR1UfZhbKmF1MqQyCfAmScWX
	MLRRoAzW9zfPiaS2QnARN1B35WOtDajnjnMN3xZn//e129S/Fi1q1mZms5YWQcRCOjE=
X-Gm-Gg: AR+sD11QMNnCGNOvKr4YdfNMJSKGjQriZwQmPqBOp4vrYED3do8FW+d3w5K4dudMf7r
	OwXEP7vhjtWm++faYkJKD8nDdXL00ZftNnwRqUIqWJE+hrLY/zguEIhY10H7SXhAKwa4ky/Ip8k
	bKVZ9vAM1y4qI2HV3gZmWksh7wR3R/SyIR2a/yBcf3hhzhbyxGltrbTc6H2UQ3+aSXXfiIt3b8g
	iQCZEbSakxNJRBDxG/k/u5eZwTyuDurXgbyQVt3a7ISN5J8Bz0QtxyzOLYDjMsU6GuRRVIKnXO6
	it9pvAjgUeTmfMR124ZMx62Wpizai9dKP1U6QUGItpdol+AIJFZtmdgtnniiQopoGzB7dEd9tip
	blzlX2Zy4fTKqGRFvzXPmnKcdngb9/9I+BvfKXZ7+1SSzT5kfdAx+pm4BFXDoov7dEZQLkFRP4H
	jgeOSE/jQzPGMgDxTygD38l3bAqjBTHxQdBnr0NdpyO02aM9MHLAnZw5HFpw==
X-Received: by 2002:a05:620a:371d:b0:92b:6805:9175 with SMTP id af79cd13be357-930b419d330mr2368159885a.61.1784734812726;
        Wed, 22 Jul 2026 08:40:12 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930f68a9c76sm190317885a.13.2026.07.22.08.40.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 08:40:12 -0700 (PDT)
Date: Wed, 22 Jul 2026 11:40:06 -0400
From: Gregory Price <gourry@gourry.net>
To: Richard Cheng <icheng@nvidia.com>
Cc: linux-mm@kvack.org, Zhigang.Luo@amd.com, arun.george@samsung.com, 
	balbirs@nvidia.com, brendan.jackman@linux.dev, yuzenghui@huawei.com, 
	apopple@nvidia.com, alucerop@amd.com, matthew.brost@intel.com, 
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	corbet@lwn.net, skhan@linuxfoundation.org, gregkh@linuxfoundation.org, 
	rafael@kernel.org, dakr@kernel.org, djbw@kernel.org, vishal.l.verma@intel.com, 
	dave.jiang@intel.com, alison.schofield@intel.com, osandov@osandov.com, 
	jannh@google.com, pfalcato@suse.de, jackmanb@google.com, hannes@cmpxchg.org, 
	ziy@nvidia.com, pbonzini@redhat.com, osalvador@suse.de, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev, baohua@kernel.org, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, yury.norov@gmail.com, 
	linux@rasmusvillemoes.dk, longman@redhat.com, ridong.chen@linux.dev, tj@kernel.org, 
	mkoutny@suse.com, sj@kernel.org, jgg@ziepe.ca, jhubbard@nvidia.com, 
	peterx@redhat.com, baolin.wang@linux.alibaba.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev, usama.arif@linux.dev, 
	xu.xin16@zte.com.cn, chengming.zhou@linux.dev, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	driver-core@lists.linux.dev, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	linux-debuggers@vger.kernel.org, linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev, linux-kselftest@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v5 00/36] Private Memory NUMA Nodes
Message-ID: <amDVQopyvolxfX8K@gourry-fedora-PF4VCD3F>
References: <20260720193431.3841992-1-gourry@gourry.net>
 <amDL80BSEP6u9XfE@MWDK4CY14F>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amDL80BSEP6u9XfE@MWDK4CY14F>

On Wed, Jul 22, 2026 at 10:20:00PM +0800, Richard Cheng wrote:
> On Mon, Jul 20, 2026 at 03:33:54PM +0800, Gregory Price wrote:
> Hi Gregory,
> 
> I applied your series on mm-next and give a quick review,
> not thoroughly, still I have some questions below regarding the design.
>  

Hi Richard,

Thank you for the read.

Just a heads up, this was based on mm-new because of some recent work
on Brendan's page_alloc.h cleanup, but if you managed to get it applied
then maybe that's made its way forward already.

> > The goal here is to flip that dynamic, isolate by default and then
> > opt-in to specific services that the device says is safe.
> > 
> > Isolation at the NUMA/Zonelist layer provides a powerful mechanism for
> > memory hosted on accelerators - re-use of the kernel mm/ code.
> > 
> >  - Accelerators (GPUs) can use demotion, numactl, and reclaim.
> >  - Special memory devices (Compressed RAM) with special access controls
> >    (promote-on-write) can have generic services written for them.
> >  - Network devices with large memory regions intended for ring buffers
> >    can use the buddy and standard networking stack.
> >  - Slow, disaggregated memory pools which aren't suitable as general
> >    purpose memory get cleaner interfaces (no need to re-write the buddy
> >    in userland, can use migration interface, etc).
> >  - Per-workload dedicated memory nodes (disaggregated VM memory)
> > 
> 
> For accelerator part, take CXL Type-2 as example, it has its own protocol
> CXL.cache, CXL.mem which is the rule they need to obey during memory transaction,
> Adding more rules for them since they are NUMA node confused me, I wonder the reason ?
> 

CXL protocols simply state how to do the memory transaction at a
physical / transport level.  It does not make any statement on how the
operating systems are to make sense of these devices or what constructs
/ abstractions to build to actually manage the devices themselves.

This series is not necessarily attached to CXL in particular, you could
just as easily carve out memory from the general pool onto a private
node to ensure it only gets used for a particular use.

In fact, that is how I have been testing this with dax/kmem:
https://github.com/gourryinverse/linux/commit/f279e741d9c3643597525bfab916b29b95cb635b

> Because NUMA node, at least for me, representing topology/locality rather than
> something with ownership or capability or rules.
> 

The NUMA abstraction representing topology/locality is a construct we
(the OS developers) have decided on historically - but there's nothing
that dictates we can never create new useful abstractions with it.

Consider:
    N_NORMAL_MEMORY,        /* The node has regular memory */
    N_HIGH_MEMORY,          /* The node has regular or high memory */

These have nothing to do with topology or locality, they are node states
that only have meaning in the context of linux mm/.


To make something clear - there is no *requirement* for any particular
device to use this abstraction.  It simply enables a cleaner way for
devices carrying memory to re-utilize mm/ services while ensuring their
memory does not silently get used under system pressure (or some vagrant
in userspace doing `numactl --interleave all`).

Ignoring all the CAP bits entirely, if you just took the base series
your driver could re-use the buddy allocator without any special logic
AND have confidence that your driver is the only possible user of that
memory (barring some truly obscene bug).

> >  - isolation via a dedicated zonelist:
> >      - private nodes are omitted from FALLBACK/NOFALLBACK
> >      - added ZONELIST_PRIVATE(_NOFALLBACK)
> 
> I saw the reply in patch 5, so in fact there's not only one
> dedicate zonelist, but numerous ?
> I raise the question because zonelist was supposed to be a
> global, unbypasssable thing in MM design, but now what you
> are trying to do is to seperate the whole global list into several
> parts ?
> 
> Can you explain why in current design you don't consider to support
> something like ZONELIST_PRIVATE[n]={0, .. ,n-1} ? that's my imagination
> of what a global zonelist should look like, no matter private or non.
> 

First let me say that there's nothing that prevents us from doing this,
and we *could* make this the default case - but this decision was
intentional by me.

Having them all present in each-other's zonelists by default creates a
number of implicit opt-ins that are unclear:

  - any direct zonelist iterator now iterates all zones on all private
    nodes, even those nodes do not opt into the same services

    e.g. zonelist iteration in reclaim that targets Private Node A would
    attempt to reclaim Private Node B as well.  That would require and
    extra explicit filter.

    I ask: Why do this? Just isolate in the zonelist, and if there is
           a desire for intersections - make it explicit, not implicit.

  - fallback allocations can now occur across private nodes, even
    if those nodes are intended for different purposes.

    Obviously you can use nodemask to tighten the allocation target, but
    I use `numactl --interleave --all` as an example of a clear case
    where intersected nodelists may not give you the behavior you want.


So for consistency - everything including zonelists have full isolation.
This way all interactions with a private node must be explicit - always.


This is actually one of the problems with ZONE_DEVICE - and you can see
it in this patch set.  Some of the hooks in mm/ for zone_device only
apply to PTE cases, and are absent from PMD cases - only because PMD
mappings in ZONE_DEVICE aren't supported.

That kind of implicit behavior is quite bad.

That said, future improvements could include something like:

for_reclaimable_zone(ZONELIST_PRIVATE) {}

where we loosen this isolation, and formalize a filter, but I would
like to see the usecase for it first.  Loosening the isolation defeats
the entire purpose of the series, so there should be a strong reason to
do so.

> > Allocation Isolation
> > ====================
> > page_alloc presently controls whether a node's memory can be allocated
> > on a given call by 4 things (in order of authority)
> > 
> >   1) ZONELIST membership
> >      If a node is not in the walked zonelist, it's unreachable.
> >
> 
> So a device gets hotplugged in the system will get a dedicated zonelist here ?

Yes.

> And make sure it obeys the device's own protocol if it has one ?
> 

I'm not sure i follow this question, can you help me understand?

If by protocol you mean the CAP bits (opting into reclaim, demotion,
etc), then yes.  If you mean something else (CXL) then I think that's
orthogonal and unrelated.

> > Private nodes:
> >   1) Never appear in any ZONELIST_FALLBACK
> >   2) Have an empty ZONELIST_NOFALLBACK
> >   3) Only appear in their own ZONELIST_PRIVATE(_NOFALLBACK)
> > 
> > 1 & 2 mean all existing in-tree callers to page_alloc can NEVER
> > accidentally allocate from a private node.
> > 
> > An allocation must explicitly ask via a zonelist and a nodemask.
> > 
> >   alloc_flags |= ALLOC_ZONELIST_PRIVATE; /* use ZONELIST_PRIVATE */
> >   __alloc_pages(..., nodemask);     /* with the private node set */
> > 
> 
> As I stated above, NUMA concept was quite naive at first glance for my
> limited knowledge.
> 
> This is quite alot to add for NUMA node concept, I'll want to see
> more explanation in v6 and learn from it, thanks.
> 

Sure, I can expand on it.  I think it's not as much to add as you think
though - it's simply adding the concept of isolation to a NUMA node.

Some more explanation below, but if you think there is something i
should explicit spell out in v6 cover, please let me know.

---

I agree that NUMA as a concept was best-effort for, comically enough,
somewhat *Uniform* memory access - instead of *Non*-Uniform memory access.

The current abstraction quite nicely handles the case where all memory
on the system is roughly of the same calibre (DDR4, DDR5, etc) and
roughly for the same purpose (general system memory).

But it is quite incapable of handling truly heterogeneous memory systems
(precious HBM attached to the CPU, GPU's with HBM over a coherent link,
hardware-compressed memory expansion, network devices w/ memory, etc).

If you look at the history of ZONE_DEVICE, what it fundamentally does is
slaps an isolation mechanism on top of NUMA nodes because the NUMA
abstraction doesn't provide one. 

The problem with that approach is now you have to reason about a node
having both fungible and non-fungible memory.  It creates the need for
something like migrate_device.c when a properly isolated NUMA node could
just use migrate.c directly (with a coherent link).


One example of what isolation on the node enables:

A Private Node can hotplug memory in ZONE_NORMAL - which means it
can be GUP pinned.  That means driver support for GPU direct storage
is simply `alloc_pages_node() + pin()`. The driver doesn't have to
worry about something like SLAB accidentally using that same memory.

All without having to rewrite a bunch of mm/ in a driver, and with
having to do some kind of heroics with ZONE_DEVICE that causes even
more special mm/ interactions.

That only comes from adding an isolation primitive to a NUMA node.


> > Isolating private node folios from kernel services
> > ==================================================
> > We implement filter points in mm/ to prevent operations on
> > private node memory.  Where possible, we even re-use existing
> > filter points from ZONE_DEVICE.
> > 
> > Most filter points are one or two lines of code:
> > 
> > Combining ZONE_DEVICE and N_MEMORY_PRIVATE opt-out spots:
> >   -     if (folio_is_zone_device(folio))
> >   +     if (unlikely(folio_is_private_managed(folio)))
> > 
> > Disabling a service:
> >   +  if (!node_is_private(nid)) {
> >   +      kswapd_run(nid);
> >   +      kcompactd_run(nid);
> >   +  }
> > 
> > Disallowing a uapi interaction:
> >   +  if (node_state(nid, N_MEMORY_PRIVATE))
> >   +      return -EINVAL;
> > 
> 
> I'm not sure of why do we re-implement more filter and basically
> doing the same thing ? Any unavoidable scenario ?
> 
> re-using the exisintg filter would be nice if that's possible.
> 

We re-use (combine) existing filters where possible.

We add new ones where ZONE_DEVICE did not implement filters due to some
*implicit* filter already existing.

Two clear examples:
   - reclaim does not target ZONE_DEVICE
   - ZONE_DEVICE does not support PMD

Both cases result in private-node filters that otherwise would have to
exist for ZONE_DEVICE (and if ZONE_DEVICE ever grows PMD support, those
filters will have to be added).

> > Bonus Configuration: HBM device memory tiering
> > ==============================================
> > echo 1 > dax0.0/private       # make the node private
> > echo 0 > dax0.0/adistance     # highest tier
> > echo 1 > dax0.0/reclaim       # reclaim active
> > echo 1 > dax0.0/demotion      # may demote from the node
> > echo 1 > dax0.0/user_numa     # mbind()
> > echo online_movable > dax0.0/state
> > echo 1 > numa/demotion_enabled
> > 
> > This is an HBM device which is treated as the top-tier in the
> > system but for which memory can only enter via explicit mbind().
> > 
> > It can be overcommitted because it can be reclaimed (demotions
> > go to CPU DRAM, and reclaim can swap from it).
> > 
> > If the HBM is managed by an accelerator (GPU), the mmu_notifier
> > allows it to know when reclaim is moving memory out to do
> > device-mmu invalidation prior to migration.
> > 
> > Prereqs, base commit, references
> > ================================
> > akpm/mm-new - for Brendan Jackman's mm/page_alloc.h work[3]
> > 
> 
> Still thanks for the work, I learn alot from your work as well, thanks.
> 

Of course, and thank you for reading.

If nothing else I hope this series helps folks understand the page
allocator better (it certainly has helped me).  If there is anything
you think I can improve or better explain, I am happy to discuss.

I am planning a larger publication of all my research sometime in the
future, but I think code is more impactful and useful - so I am
prioritizing that for now :].

~Gregory
