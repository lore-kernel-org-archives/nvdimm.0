Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795200200;
	b=uCy/t5E668aECyPQ4jxIRFbO92+rn9n+OQpaObypxpDEZa+Bwwx6W8yAo22SaSbqd3Ax
	 vSnA3lkL4y+5uT+GrPeCSveVjcfsobYvxC6n1BnMrKNnS863e9ZPIsljgmK9Tx38VQIE+
	 DGj/gILyNcKP0NxPDeQ7OEcgte/NyfjxhQlqFsr+ldl2JWBCSqCOBzXsR97JOuWCr040W
	 stYe2oUkqpp1QdjOyrmFGLCq1Stv3UvqJRAOHfXNYCRoeC6wv1U6d1/aU2pQQh5DLP4BH
	 +nInWho7CnzmYEKNCjZRc7LofgzC79HwEkg5Sms4D/CksX09dMw9oUv82LwkO12DU0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795200200;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Ma7DY6hP0RTDlPx1qLll5//wsGyPi+yFvpPbcWX/bJQ=;
	b=vcYTu1E8xcx7NVM6UYRp+GR0HHra3R9WDO1eEHAhMOcDYHNYlNpEh3YyyW/Ro162Kw7F
	 nuyWQeZXjehFxuIZjsIHQSX8mVEYMUgzwVgK4M8PSD5MdluicDNwsOWlstgc8Hlnw7L+J
	 g5xU5QchNKE8OnSXOiZOhWTP+jsKGxI8keIvlVqTxlM/x1JNmisuQHwVJkzcDzeJwdWnO
	 kFPrhaKA6aLqwNSgZJ8nrblGcXDrsq2ZdzKBVlGA28+neWKnS6HIcrsT0cjfb2bw+g5QV
	 TcEUtK8zEPRUVYSO85J83/IcAwNxMElYEQB9Z54aOAj4vwzeHpQL3b8ltfvMWBgicWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="P431dF/g";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D52F9606A339;
	Fri, 20 Nov 2026 18:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P431dF/g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6FD61F000CF;
	Fri, 20 Nov 2026 18:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795200200;
	bh=Ma7DY6hP0RTDlPx1qLll5//wsGyPi+yFvpPbcWX/bJQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=P431dF/g9aF994R3Rk3du20W0kJQtM8y0AiqkByuWrIa6nn7OdhDBTMdiM6tSVitM
	 bA7V3TIWopIndYe4TIFVJd6QTLzAD+no6Rs+mkinFe/2BgqQE8ee7X9umqH3wV9qgo
	 P84wxhyEMs9MAqcXWRG0QzbefNnxk3tNoV/iQNNBXjsRUPynOx15S1nD0YaV3GSwT9
	 AkZjL+nOiwX3xNMx43cBWa3+8WluRqVh0AMzhGrLPMK4Y6JF68TdEfhLZNxKQsPlaB
	 sOB+SWJhQTTdtn0CvFKLlInviHGTZ7c+qwWR3NGfsYpsSdThK29l5Ep6cKVDSvyGrr
	 dzgTYMUC8017g==
Message-ID: <sashiko-outbox-225864@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 31/60] cgroup/cpuset: inherit common memory when a
 nodemask is private only
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
In-Reply-To: <20261120-private_nodes_v6-v1-31-74f5f9a115c2@gourry.net>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
 <20261120-private_nodes_v6-v1-31-74f5f9a115c2@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 18:43:14 +0000
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
- [Medium] cgroup/cpuset: private nodes in mwork->from skew
  do_migrate_pages() remap
--

commit a812b8d4e921d8df891074bca9a3aa4014ffe723
Author: Gregory Price (Meta) <gourry@gourry.net>

cgroup/cpuset: inherit common memory when a nodemask is private only

This commit updates cpuset nodemask calculation and validation so that a
cpuset.mems mask containing only private memory nodes inherits common
memory nodes from its parent in v2 or is rejected in v1, and excludes
private memory nodes from automatic page migration destinations.

> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index db32d330cfbc2..6802ca13c46b7 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c

[ ... ]

> @@ -2667,6 +2687,8 @@ static void cpuset_migrate_mm_workfn(struct work_st=
ruct *work)
>  	struct cpuset_migrate_mm_work *mwork =3D
>  		container_of(work, struct cpuset_migrate_mm_work, work);
> =20
> +	/* Private nodes are never migration destinations. */
> +	nodes_andnot(mwork->to, mwork->to, node_states[N_MEMORY_PRIVATE]);
>  	/* on a wq worker, no need to worry about %current's mems_allowed */
>  	do_migrate_pages(mwork->mm, &mwork->from, &mwork->to, MPOL_MF_MOVE_ALL);
>  	mmput(mwork->mm);

[Severity: Medium]
Does stripping N_MEMORY_PRIVATE only from mwork->to while leaving private
nodes in mwork->from skew the node remapping in do_migrate_pages()?

mm/mempolicy.c:do_migrate_pages() {
    ...
			if ((nodes_weight(*from) !=3D nodes_weight(*to)) &&
						(node_isset(s, *to)))
				continue;

			d =3D node_remap(s, *from, *to);
    ...
}

Both mwork->from (from cs->old_mems_allowed) and mwork->to come from
guarantee_online_mems(), which includes all N_MEMORY nodes.  For example,
with common nodes C0 and C1 and private node P2, if effective_mems changes
from {C1, P2} to {C0, C1, P2} (or {C0, C1}), mwork->from is {C1, P2} and
mwork->to becomes {C0, C1}.  Because both masks have weight 2,
do_migrate_pages() does not skip C1 even though it is still set in
mwork->to, and node_remap() maps ordinal 0 of mwork->from (C1) to ordinal
0 of mwork->to (C0), migrating pages off C1 onto C0 even though C1
remained allowed.

Also, because cpuset_migrate_mm() checks nodes_equal(*from, *to) before
private nodes are stripped, adding or removing only a private node (e.g.
{C0} -> {C0, P2}) still queues migration work and runs
do_migrate_pages() -> lru_cache_disable() when the common node masks are
unchanged.  Later in this series, commit "mm: restrict explicit migration
to N_MEMORY_MEMPOLICY" strips retained private nodes (mwork->to &
node_states[N_MEMORY_PRIVATE]) from mwork->from, but private nodes present
only in mwork->from remain set and still skew nodes_weight(*from) and
node_remap() when common nodes change at the same time.  Filtering
N_MEMORY_PRIVATE from both *from and *to in cpuset_migrate_mm() before the
nodes_equal() check would avoid both issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120-private_no=
des_v6-v1-0-74f5f9a115c2@gourry.net?part=3D31
