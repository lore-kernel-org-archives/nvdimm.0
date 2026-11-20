Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795200054;
	b=oHkSwooK+aR+KlVpDKT2IsgTqxKfgGWo4t8yXAmEn1DR6+C5ChnOwQd5goXyZs0Pegnd
	 3iSqna+Byq0MOSvQCeqNzbzgccPuu4/5C+fqykZN2DVYXM2/CHhohGhk6wwP/PuPo702M
	 G9op/ph3aDm5nzNii9pSXZWY4kFf2524mb/4FuuKEL7Sx4gmzuaaYUzvh8ZFM9DovyRG/
	 aK3KNT+60su9vkNd6mEh6ztfVu1HfKzXVT9pS6Q+QUrQsZIe5PFuJY+EHPAlKS4nIECOh
	 vSjdN8S1jp7OXO1F+G93IaJRkTKoc5Wi5zYCInl6ifX3vamVP6uu3tgS045dOpxGoYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795200054;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=3XL1JA9m8Hu+O/7B6EfoJt3MTN9vlsJ9TNi8mUkP8DI=;
	b=4G32lB8M4fgslOVjREwuwgosoYaOexAWRZ/Au4kHj2ysI+2n0BDXD24VhnbinQT+Ounu
	 VtrBDIopGfLiZKouN7nCi/UCi5nXA3kTdPID2wAUHescJukYlfwrT/yCLF9MnmYcyv7dw
	 S3gNQ3g2A8c82R0LybL271/L/7huBLdvqrCeTyAHd1cFQTX1OVtXbfS1rzvfe/WcKhbIk
	 1DyS+aHgna8XyWKLRXHw+S79kwAEZXIIzApzgv5Rmf8PipAqu0UrkLHlxYjmQkbRSYkgU
	 7SScCgtQOL2zrfHxqg0BRv0is/FoGI/QKoVHInzwDw8DAxS++OQmJvasH6IeNTr5VBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UagskxeQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 895AF60A261C;
	Fri, 20 Nov 2026 18:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UagskxeQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E79FE1F000C4;
	Fri, 20 Nov 2026 18:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795200053;
	bh=3XL1JA9m8Hu+O/7B6EfoJt3MTN9vlsJ9TNi8mUkP8DI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UagskxeQrAJFSkaJ34IdfK5BI5lCFTuVFuWtcygLyt4K0evkfCBDNV9OR605MztGX
	 kIQmI9xb3AaxApN7AUgfjiNaymYiThPCjp/GWPESowczZy0PESOMb5o0eksEmbAcvC
	 pfODz/H191ekbd+7zd+sBl7CdqYcuH6USIw5XnFyx6tiu5n4Qoj/jGWYr2Y4xmXfGQ
	 T3IfCadJSvirwNZq3p8RnT+gXxnmkFtePmmTkKQEAaHhYxuh+nl9IycoRR/MDeONGk
	 9CCj4aBlrQzbAuqzbGG5xEsIC4OEx9nrQNEbbH0kgkts7xQsk4EwPROAnvilCCgeeN
	 gLTsVFMlaIcxg==
Message-ID: <sashiko-outbox-225859@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 42/60] mm: fail private placement on exhaustion instead
 of OOM killing
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?R3JlZ29yeSBQcmljZSAoTWV0YSk=?= <gourry@gourry.net>, "Yury
 Norov" <yury.norov@gmail.com>, "Rasmus Villemoes" <linux@rasmusvillemoes.dk>, "David
 Hildenbrand" <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Michal
 Hocko" <mhocko@suse.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Oscar
 Salvador" <osalvador@suse.de>, "Johannes Weiner" <hannes@cmpxchg.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Brendan Jackman" <brendan.jackman@linux.dev>, "Zi
 Yan" <ziy@nvidia.com>, "Jonathan Corbet" <corbet@lwn.net>, "Shuah Khan" <skhan@linuxfoundation.org>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Rafael
 J. Wysocki" <rafael@kernel.org>, "Danilo Krummrich" <dakr@kernel.org>, "Johan
 Hovold" <johan@kernel.org>, "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Rakie
 Kim" <rakie.kim@sk.com>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Matthew
 Brost" <matthew.brost@intel.com>, "Byungchul Park" <byungchul@sk.com>, "Alistair
 Popple" <apopple@nvidia.com>, "SJ Park" <sj@kernel.org>, "Ingo Molnar" <mingo@redhat.com>, "Peter
 Zijlstra" <peterz@infradead.org>, "Juri Lelli" <juri.lelli@redhat.com>, "Vincent
 Guittot" <vincent.guittot@linaro.org>, "Dietmar Eggemann" <dietmar.eggemann@arm.com>, "Steven
 Rostedt" <rostedt@goodmis.org>, "Ben Segall" <bsegall@google.com>, "Mel
 Gorman" <mgorman@suse.de>, "Valentin Schneider" <vschneid@redhat.com>, "K
 Prateek Nayak" <kprateek.nayak@amd.com>, "Kees Cook" <kees@kernel.org>, "Kairui
 Song" <kasong@tencent.com>, "Barry Song" <baohua@kernel.org>, "Qi Zheng" <qi.zheng@linux.dev>, "Shakeel
 Butt" <shakeel.butt@linux.dev>, "Axel Rasmussen" <axelrasmussen@google.com>, "Yuanchu
 Xie" <yuanchu@google.com>, "Wei Xu" <weixugc@google.com>, "Baoquan He" <baoquan.he@linux.dev>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "Michal Hocko" <mhocko@kernel.org>, "David
 Rientjes" <rientjes@google.com>, "Pavel Machek" <pavel@kernel.org>, "Len
 Brown" <lenb@kernel.org>, "Nico Pache" <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Kiryl Shutsemau" <kas@kernel.org>, "Xu Xin" <xu.xin@linux.dev>, "Chengming
 Zhou" <chengming.zhou@linux.dev>, "Lorenzo Stoakes" <ljs@kernel.org>, "Pedro
 Falcato" <pfalcato@suse.de>, "Jann Horn" <jannh@google.com>, "Chris Li" <chrisl@kernel.org>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, "Nhat Pham" <nphamcs@gmail.com>, "Youngjun
 Park" <youngjun.park@lge.com>, =?utf-8?b?TWF0dGhldyBXaWxjb3ggKE9yYWNs?=
 =?utf-8?b?ZSk=?= <willy@infradead.org>, "Jan Kara" <jack@suse.cz>, "Waiman
 Long" <longman@redhat.com>, "Ridong Chen" <ridong.chen@linux.dev>, "Tejun
 Heo" <tj@kernel.org>, =?utf-8?b?TWljaGFsIEtvdXRuw70=?= <mkoutny@suse.com>, "Dan
 Williams" <djbw@kernel.org>, "Vishal Verma" <vishal.l.verma@intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, "Alison Schofield" <alison.schofield@intel.com>, "Shuah
 Khan" <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, damon@lists.linux.dev, nvdimm@lists.linux.dev
In-Reply-To: <20261120-private_nodes_v6-v1-42-74f5f9a115c2@gourry.net>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
 <20261120-private_nodes_v6-v1-42-74f5f9a115c2@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 18:40:49 +0000
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [High] mm: stale current->private_alloc_failed turns non-private OOM
  into SIGBUS
- [High] mm: private alloc failures bypassing __alloc_pages_may_oom()
  leak VM_FAULT_OOM
- [High] mm: VM_FAULT_SIGBUS on private alloc failure breaks
  FAULT_FLAG_UNSHARE callers
--

commit 7e8b136eb40856d46304f949553ac1db87e76cc8
Author: Gregory Price (Meta) <gourry@gourry.net>

mm: fail private placement on exhaustion instead of OOM killing

This commit skips the OOM killer when an allocation from a private
zonelist fails, marking the task with current->private_alloc_failed so
handle_mm_fault() converts VM_FAULT_OOM into VM_FAULT_SIGBUS.

> diff --git a/mm/memory.c b/mm/memory.c
> index 282266dd5e5df..4a8a08df28ff9 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -7003,6 +7003,7 @@ vm_fault_t handle_mm_fault(struct vm_area_struct *v=
ma, unsigned long address,
>  	}
> =20
>  	is_droppable =3D !!(vma->vm_flags & VM_DROPPABLE);
> +	current->private_alloc_failed =3D 0;
> =20
>  	/*
>  	 * Enable the memcg OOM handling for faults triggered in user
> @@ -7034,6 +7035,10 @@ vm_fault_t handle_mm_fault(struct vm_area_struct *=
vma, unsigned long address,
>  	if (is_droppable && (flags & FAULT_FLAG_USER))
>  		ret &=3D ~VM_FAULT_OOM;
> =20
> +	/* Exhausted private memory fails like an empty HugeTLB pool. */
> +	if (unlikely(current->private_alloc_failed) && (ret & VM_FAULT_OOM))
> +		ret =3D (ret & ~VM_FAULT_OOM) | VM_FAULT_SIGBUS;

[Severity: High]
Does converting VM_FAULT_OOM to VM_FAULT_SIGBUS unconditionally break
FAULT_FLAG_UNSHARE callers?

Callers passing FAULT_FLAG_UNSHARE | FAULT_FLAG_REMOTE expect allocation
failures in wp_page_copy() to return VM_FAULT_OOM and treat
VM_FAULT_SIGBUS as concurrent truncation having unmapped the page:

arch/s390/mm/gmap_helpers.c:gmap_helper_unshare_zeropages() {
	...
		fault =3D handle_mm_fault(vma, addr,
					FAULT_FLAG_UNSHARE | FAULT_FLAG_REMOTE,
					NULL);
		if (fault & VM_FAULT_OOM)
			return -ENOMEM;
		/*
		 * Even if handle_mm_fault() returns VM_FAULT_SIGBUS, we did not
		 * fail to break COW and must retry, because we experienced
		 * concurrent truncation and the page mapping was modified.
		 */
		goto retry;
}

Because the private allocation failure leaves the shared zeropage mapped
at addr, gmap_helper_unshare_zeropages() finds the same zeropage on every
walk and loops forever.  In break_ksm(), VM_FAULT_SIGBUS terminates the
loop and returns 0 instead of -ENOMEM, allowing __ksm_del_vma(),
ksm_madvise(), and unmerge_and_remove_all_rmap_items() to clear
VM_MERGEABLE or tear down KSM rmap items while KSM pages are still mapped.

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 63cc8729c41ad..ea48991ef5898 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4176,6 +4176,20 @@ __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int=
 order,
>  	 * failures more gracefully we should just bail out here.
>  	 */
> =20
> +	/*
> +	 * Private memory is a fixed pool, exhausting it fails the allocation
> +	 * rather than selecting an OOM victim. Otherwise, if there is some
> +	 * indication of progress because of a revoked request, just report
> +	 * some progress so the slowpath retries and relaxes it.
> +	 */
> +	if (ac->alloc_flags & ALLOC_ZONELIST_PRIVATE) {
> +		if (!alloc_private_reachable(gfp_mask, ac))
> +			*did_some_progress =3D 1;
> +		else
> +			current->private_alloc_failed =3D 1;
> +		goto out;
> +	}

[Severity: High]
Can current->private_alloc_failed stay set after a recoverable private
allocation failure and turn a later non-private VM_FAULT_OOM in the same
fault into VM_FAULT_SIGBUS?

handle_mm_fault() clears current->private_alloc_failed only at entry.  In
alloc_anon_folio(), trying an mTHP order in 1..PAGE_ALLOC_COSTLY_ORDER
with GFP_TRANSHUGE (when VM_HUGEPAGE is set) on a fragmented private node
reaches __alloc_pages_may_oom() and sets current->private_alloc_failed =3D 1
before falling back to order-0 folio_prealloc(), which succeeds.
Speculative swapin readahead in swap_vma_readahead() and slowpath restarts
via relax_private_alloc() at nopage: also leave
current->private_alloc_failed set after the fault continues.

If a later step in the same fault (such as mem_cgroup_charge() on the
order-0 folio or a common-memory allocation after relaxation) returns
VM_FAULT_OOM, handle_mm_fault() consumes the stale flag, reports
VM_FAULT_SIGBUS instead of OOM, and calls mem_cgroup_oom_synchronize(false)
to cancel memcg OOM handling.

[Severity: High]
What happens when a private allocation in a page fault fails without
reaching this ALLOC_ZONELIST_PRIVATE check?

Private nodes are commonly onlined only in ZONE_MOVABLE.  When a fault
cannot use ZONE_MOVABLE (for example, during FOLL_LONGTERM GUP where
PF_MEMALLOC_PIN causes current_gfp_context() to strip __GFP_MOVABLE),
first_zones_zonelist() in __alloc_pages_slowpath() finds no usable zone in
ZONELIST_PRIVATE and jumps directly to nopage:.  At nopage:,
relax_private_alloc() sees alloc_private_reachable() =3D=3D true (since it
scans up to MAX_NR_ZONES - 1) and does not relax the allocation, so
__alloc_pages_slowpath() returns NULL with current->private_alloc_failed
still 0.  The early goto out branches earlier in __alloc_pages_may_oom()
(such as PF_DUMPCORE, order > PAGE_ALLOC_COSTLY_ORDER,
__GFP_RETRY_MAYFAIL | __GFP_THISNODE, or highest_zoneidx < ZONE_NORMAL)
also bypass this block.

When that happens, handle_mm_fault() returns raw VM_FAULT_OOM without
having invoked out_of_memory(): GUP receives -ENOMEM instead of -EFAULT,
and a user page fault enters pagefault_out_of_memory() and retries the
faulting instruction in an infinite fault loop.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120-private_no=
des_v6-v1-0-74f5f9a115c2@gourry.net?part=3D42
