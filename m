Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795199601;
	b=BTencnIZvCggsFcBl8syKerPPHoV8o/Su3yXJMvSl3NTwTMk1v7GNO0ym7mDkC0i056H
	 T+MAlxQSMIkq2OiyAVcrI5UFwZPMPN9Q971Qp9OXzXWVyCMHB5WN7wDt3t60MZ6LlRgBw
	 AS8Yv2oYvqYAnvlXgI+HlTM/aqal4fSuHnET+AvFJ4qMfmlv80zBWibl4JIE2jZMx6iUL
	 8ufqkYrL4HXpWm9zpTxYlicZ31NM97BzLOf/TgYscgySd4tg763RyBPyKlRWQ2EIMGCJS
	 Swv89A38EAVVRVejQ9cM7U4l0YW/Nv8aWPfqkdlBBQFBRbeyZqLxlfUBuqYjksqFPVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795199601;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=/QjdGr8du1+0/up5L/FeJ50rChwbRYbU49k9UAYdf/g=;
	b=ihDGPbgfV9/uIAEUz8cNwqkSwrYs4NeUF1wlTkL3j/14nOA1tevIiBdGqV3YfanJZbT5
	 h3UySZbBZhm4lpmXYFEpEmZfT7voqnACqcZzrQZYxhhsAdId5wAVE2WD36qj/s3k+amE+
	 6N0k0DHk0b+IELoYZkk0+XKpbge7cmXSl1XJb4mXVeeQfvfmzeDh2dEli/z68+o8wLKLj
	 0v4QTeKSlanYRuTxw1dxtZhBwxJ14HiKG5pZoqwq/if3Ivh8DvxgHua2bP9wEASCEK7TX
	 zR4iQNNSml6/CfxF6ytiT78AEtAFmpqBrxml/OX0Pv7m8lrsph4X+DC7iS36OA1Uk5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QEcfJdaB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B213260A2602;
	Fri, 20 Nov 2026 18:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QEcfJdaB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D911F000D2;
	Fri, 20 Nov 2026 18:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795199601;
	bh=/QjdGr8du1+0/up5L/FeJ50rChwbRYbU49k9UAYdf/g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QEcfJdaBXR3W+/1J/7PCuYdI5Ic5+u6GSCUqnnD/ezVDlOQmmQZuhmOsWA1zd/1+y
	 a/VC65utOlVHSk0Ii0AJPHU0b22J+KTgAZDPez8Fq0scTn3qKwWehZwpYuezFS8zDu
	 H8JAdT0jJ9LgLe9KjPQkVKjeAxfKMDbn9yXUFXGLFAWa8zVs86wjv76fFu4gkUrMno
	 l042nFUH9mvNFE8IboO7yL85h2zNRzSZSmNdU+QiO4r+ue3XHFppLHS5gIOwN73Pa9
	 riUpfyMMq5b05pVKNTlrrgUm061QQsYcgZV3GN2LZnnspHqyivw/54SqNZdAZXQ6GH
	 Sx87cnBZQPuvQ==
Message-ID: <sashiko-outbox-225840@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 30/60] mm/memory_hotplug: keep private memory out of the
 auto-movable ratio
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
In-Reply-To: <20261120-private_nodes_v6-v1-30-74f5f9a115c2@gourry.net>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
 <20261120-private_nodes_v6-v1-30-74f5f9a115c2@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 18:33:15 +0000
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
- [Medium] mm/memory_hotplug: broken auto-movable accounting on private
  nodes
--

commit 6d04c084f583deb362f04abc899f0521e026dbfc
Author: Gregory Price (Meta) <gourry@gourry.net>

mm/memory_hotplug: keep private memory out of the auto-movable ratio

This commit skips nodes with N_MEMORY_PRIVATE set in
auto_movable_stats_account_zone() and auto_movable_stats_account_group()
when computing statistics for the auto-movable online policy.

> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index b4d94021d46ef..d7ce60c6815f8 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -782,6 +782,10 @@ struct auto_movable_stats {
>  static void auto_movable_stats_account_zone(struct auto_movable_stats *s=
tats,
>  					    struct zone *zone)
>  {
> +	/* Private memory is outside the movable:kernel balance. */
> +	if (node_state(zone_to_nid(zone), N_MEMORY_PRIVATE))
> +		return;
> +
>  	if (zone_idx(zone) =3D=3D ZONE_MOVABLE) {
>  		stats->movable_pages +=3D zone->present_pages;
>  	} else {
> @@ -808,6 +812,10 @@ static int auto_movable_stats_account_group(struct m=
emory_group *group,
>  	struct auto_movable_group_stats *stats =3D arg;
>  	long pages;
> =20
> +	/* private memory is outside the movable:kernel balance. */
> +	if (node_state(group->nid, N_MEMORY_PRIVATE))
> +		return 0;
> +
>  	/*
>  	 * We don't support modifying the config while the auto-movable online
>  	 * policy is already enabled. Just avoid the division by zero below.

[Severity: Medium]
Does skipping N_MEMORY_PRIVATE here without updating
auto_movable_can_online_movable() and auto_movable_zone_for_pfn() break
auto-movable accounting when onlining memory on private nodes?

In auto_movable_can_online_movable(), walk_dynamic_memory_groups() excludes
the target group being onlined, so auto_movable_stats_account_group() only
runs for other groups.  For the target group itself,
auto_movable_can_online_movable() relies on
auto_movable_stats_account_zone() having counted its present_movable_pages
in stats.movable_pages, and then directly adds group->present_kernel_pages:

mm/memory_hotplug.c:auto_movable_can_online_movable() {
	...
	walk_dynamic_memory_groups(nid, auto_movable_stats_account_group,
				   group, &group_stats);
	if (kernel_early_pages <=3D group_stats.req_kernel_early_pages)
		return false;
	kernel_early_pages -=3D group_stats.req_kernel_early_pages;
	movable_pages -=3D group_stats.movable_pages;

	if (group && group->is_dynamic)
		kernel_early_pages +=3D group->present_kernel_pages;
	...
}

Because auto_movable_stats_account_zone() now skips N_MEMORY_PRIVATE nodes,
a dynamic memory group on a private node still adds its
present_kernel_pages to kernel_early_pages in the NUMA_NO_NODE check while
its present_movable_pages are omitted from movable_pages.

In addition, auto_movable_zone_for_pfn() computes
nr_pages =3D max_pages - online_pages assuming online_pages were already
counted in stats.movable_pages by auto_movable_stats_account_zone(), which
no longer holds once the first block on a private node is onlined and sets
N_MEMORY_PRIVATE.  When auto_movable_numa_aware is disabled, skipping
ZONE_MOVABLE on private nodes also allows unbounded ZONE_MOVABLE memory to
be onlined on private nodes without counting against the movable budget,
whereas when auto_movable_numa_aware is enabled, the per-node
auto_movable_can_online_movable(nid, ...) check sees kernel_early_pages =3D=
=3D 0
and group_stats.req_kernel_early_pages =3D=3D 0 and always returns false.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120-private_no=
des_v6-v1-0-74f5f9a115c2@gourry.net?part=3D30
