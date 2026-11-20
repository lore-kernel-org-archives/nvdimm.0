Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795200399;
	b=fHgtC7/Bx+7bFiklGNoPCZYcsaVfsrwJ13wqbYRFkIyiIWWH0sE8StS1er5T+VvFglv+
	 vfAy37CmZBUqL+mk0hvQIoagxh0iVNC6GxHLPAgyTCzzyS7IWsrr/4okdV1+sSvRRpg5u
	 Gi8hy571wrEE5MMRGyOV5Z1J/qeUg2yi4p2xxlGOyETUfKLTr8AvXiqIKkQw4NFJi5mHf
	 dK474F0hcv86pa9GJoPEhmR9oVvsyxdHSk8F57qnwDXfhlQvlVrA5vzhPq39bOjIlRP/2
	 wSWJpYLINlX8FxAsAUH9q65g8frk4H0PnsiaqUh2eNJ8nLJPEPM4cjrwg34cq+Tihcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795200399;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=3ab/tweOrN+MvabFdrOgEaN20+lKttHF+RU7XMxTAZU=;
	b=J6L2+FwuPqICqVhyrt42YcFxORXtclddckIr4obrrHDYViLe2Lljl9uChFPDSu/Ukg1W
	 jN+Yw6FozS6E2WfTVRQUuwvC6ktJbTP2G+Q/xMrTyPWXwbr2X/DrB8shoqiMnAyG0QCsy
	 n/zp0JkVBBa3seGdDPAjrl5sI/2hygmSrPYJDbHxynEGHZPaFiEMd42j71deMpYRbUAhh
	 CCooHeA5VBTL8+fLdPDxE98BEXDXlKPCnHQEx2SJW4qgl/yLGSHklDlgVG4dZlQFwzDIU
	 PTCyv4oBR1iq+kXsABcJcJ3SuGbg9GPBRj3i87LgpDsR+H7ErSlruXROCjkoZKo+WLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JbiqBCMR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673B660A261B;
	Fri, 20 Nov 2026 18:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JbiqBCMR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 381CA1F000D0;
	Fri, 20 Nov 2026 18:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795200398;
	bh=3ab/tweOrN+MvabFdrOgEaN20+lKttHF+RU7XMxTAZU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JbiqBCMRN70hevS/OOua0fjhZnHdw/pmd7L8Q6ILBCKtNg5dlCJx1IVH+9Xa/33OI
	 4wYMjBzTxWLRN1SsHDQc/cl/OrAslNyOkXXKgRJep4btSzt9WhLpXnvteASXHMyRRH
	 9Aw3PcAcYf78PtDKGVIcfoCbb92Q48CIjnVMfgLFCq+uhW8bnQN/g9jo3yA8WfoinN
	 N6zDarwrL+oB4GTCngFvsxH5C8zv6EXBiELD8Tm2zewp1JXVubelyh4QFkJXxrQINn
	 l+h6q27iUnnM3XgOb4EqaZjq5CdyPVv8PKC0Yp04zoQYj05q4HDhflrr5MsWlR3sEl
	 FlqkzUokUwrCg==
Message-ID: <sashiko-outbox-225872@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 40/60] mm/page_alloc: let MM callers select the local
 private zonelist
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
In-Reply-To: <20261120-private_nodes_v6-v1-40-74f5f9a115c2@gourry.net>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
 <20261120-private_nodes_v6-v1-40-74f5f9a115c2@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 18:46:33 +0000
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] mm/page_alloc: skipped reserve retry in
  __alloc_pages_slowpath()
--

commit c7c69e6797446cf3c44127e33fd21dc6c24deefe
Author: Gregory Price (Meta) <gourry@gourry.net>

mm/page_alloc: let MM callers select the local private zonelist

This commit adds ALLOC_ZONELIST_PRIVATE to allow internal MM callers to
select the local private zonelist independently of __GFP_THISNODE, while
retaining the nodemask and cpuset filtering during reserve allocations.

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 0bd21916cea1b..a219057931c3d 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4926,16 +4926,24 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned i=
nt order,
>  		goto got_pg;
> =20
>  	reserve_flags =3D __gfp_pfmemalloc_flags(gfp_mask);
> -	if (reserve_flags)
> +	if (reserve_flags) {
> +		unsigned int keep =3D ALLOC_KSWAPD;
> +
> +		/* The cpuset still grants a private request's node. */
> +		if (ac->alloc_flags & ALLOC_ZONELIST_PRIVATE)
> +			keep |=3D ALLOC_CPUSET;
>  		alloc_flags =3D alloc_flags_cma(gfp_mask) | reserve_flags |
> -				ac->alloc_flags | (alloc_flags & ALLOC_KSWAPD);
> +				ac->alloc_flags | (alloc_flags & keep);
> +	}
> =20
>  	/*
>  	 * Reset the nodemask and zonelist iterators if memory policies can be
>  	 * ignored. These allocations are high priority and system rather than
> -	 * user oriented.
> +	 * user oriented. A private request keeps its node: private memory has
> +	 * no reserves to grant.
>  	 */
> -	if (!(alloc_flags & ALLOC_CPUSET) || reserve_flags) {
> +	if ((!(alloc_flags & ALLOC_CPUSET) || reserve_flags) &&
> +	    !(ac->alloc_flags & ALLOC_ZONELIST_PRIVATE)) {
>  		ac->nodemask =3D NULL;
>  		ac->preferred_zoneref =3D first_zones_zonelist(ac->zonelist,
>  					ac->highest_zoneidx, ac->nodemask);

[Severity: Medium]
Does gating this entire block on !(ac->alloc_flags & ALLOC_ZONELIST_PRIVATE)
skip the can_retry_reserves retry after reserve_flags updates alloc_flags?

When reserve_flags is non-zero (for example, when current has PF_MEMALLOC
set or is an OOM victim), the preceding block updates alloc_flags with
reserve_flags and clears ALLOC_NOFRAGMENT.  Skipping the block below also
skips the can_retry_reserves goto retry, so PF_MEMALLOC and
!can_direct_reclaim callers jump straight to nopage without ever calling
get_page_from_freelist() with the updated alloc_flags (and
!can_direct_reclaim callers also miss the defrag_mode ALLOC_NOFRAGMENT
retry because ALLOC_NOFRAGMENT was already cleared):

mm/page_alloc.c:__alloc_pages_slowpath() {
	...
		if (can_retry_reserves) {
			can_retry_reserves =3D false;
			goto retry;
		}
	}

	/* Caller is not willing to reclaim, we can't balance anything */
	if (!can_direct_reclaim) {
		if (defrag_mode && (alloc_flags & ALLOC_NOFRAGMENT) &&
		    !(gfp_mask & __GFP_NORETRY) &&
		    (gfp_mask & __GFP_KSWAPD_RECLAIM)) {
			alloc_flags &=3D ~ALLOC_NOFRAGMENT;
			goto retry;
		}
		goto nopage;
	}

	/* Avoid recursion of direct reclaim */
	if (current->flags & PF_MEMALLOC)
		goto nopage;
	...
}

Only the ac->nodemask and ac->preferred_zoneref reset should be skipped for
ALLOC_ZONELIST_PRIVATE when reserve_flags adjusted alloc_flags, while still
performing the can_retry_reserves retry.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120-private_no=
des_v6-v1-0-74f5f9a115c2@gourry.net?part=3D40
