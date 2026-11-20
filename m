Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795199896;
	b=4oUtM6G6xbaLfXI6Ett4XGmApT0/DLQuv7RU++3D53GD2Pm4bkcrLOrd2vSPuSYykMFR
	 1PpGk3IjSaHXrplVcNgoweWdHIFmk53t2Ij8LMPPrEGyT7Jg1mjFpjQM+sIZ4ldbh11rh
	 cVJ4VyiRZnSMhch7KA+dNsEAAZXQLF76T3u99q7nAxmrb4wvIJB3n6EIFfV87lHZlR/Zw
	 i5LpyG9is6brOKV65EysqWxBPhEkKXuern+TJTNdwhMaTOzwDTi+EfsTzDNmpNKahfxkY
	 /k6WUKagXv8AwRsnb4iv8++qYYxbl+yLj+S47CofLyiS9ZXlJ3pkhCQE0XFUD3twkEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795199896;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=OC6u8FUNDb9skPF8bwHcuWsI0fKZNl0GsKhVj1fKpos=;
	b=kdkZS8/P+cNChh+lGenGg1BitVyYmUyvMlu+G+T3pV01pHbUawWDnvQYyCzzuGjiuctM
	 WJOmeg2dVdpNYyMEub2b6fmUxVUdCZCo/hMyImqf48/42l4u169uFC1ZTFneCDxhKBHel
	 YQHROgfTFDqSpXnuLfaHTiAt0vBurNo5KXiDxaEj2Usas4y99exQFwddtd/uLEkpIQEVq
	 VYpBNVpPIMqY59X9i0e2zQZ+qfdFnsJsfZ/Fu5P9UW9GXkaNPyXbYC9AkX52f8jWEcnxF
	 08Z63gOHggf5rKLBPt50KdABeAPajwZBBW19Q54d3ufCcgSOfHuTCsSgXd26/Hq+Rpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OTxFvX90;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25EC960A2601;
	Fri, 20 Nov 2026 18:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OTxFvX90
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 090C31F000C6;
	Fri, 20 Nov 2026 18:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795199895;
	bh=OC6u8FUNDb9skPF8bwHcuWsI0fKZNl0GsKhVj1fKpos=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OTxFvX905xe7bss35dFIdgPICr+TkeCNLnz1tY7PgOthvCCQdB+9sqcIGTu+Wy5pS
	 HkBpOFfpXoD+HucByiQzVE+aBo7AovBjavAg7/msZ85IMZH4QQDGPXMTyN7Cal2912
	 J7ehcIKITYZLl9JqBdbQLVZRf3drctZ5aDNtav2rqs59lHt7Ll2dnpP061wWLfmvVN
	 wiRz6BgGJ1hun+tk9TsveUnuZ7FSIHPlyo3eAYh+Mqa9BpNcTvBh40sAPRCfEZ1qbY
	 7IEGpQFnS+Wes4yuCAB9nixzU2oz03NmMpBaWI9/UBCGxR0iFWCTxakXrAd4zM9E5Z
	 jvK6Gx+8MChjg==
Message-ID: <sashiko-outbox-225854@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 47/60] mm/vmscan: restrict reclaim to N_MEMORY_RECLAIM
 instead of N_MEMORY_COMMON
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
In-Reply-To: <20261120-private_nodes_v6-v1-47-74f5f9a115c2@gourry.net>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
 <20261120-private_nodes_v6-v1-47-74f5f9a115c2@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 18:38:11 +0000
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
- [High] mm/vmscan: lru_gen_age_node() triggers global OOM kill from
  private kswapd
--

commit 5d53d0a1dd37bac1ef5e22f989ac592e04dac809
Author: Gregory Price (Meta) <gourry@gourry.net>

mm/vmscan: restrict reclaim to N_MEMORY_RECLAIM instead of N_MEMORY_COMMON

This commit updates kswapd startup, zone watermark setup, MGLRU debugfs
iteration, and proactive reclaim to check N_MEMORY_RECLAIM instead of
N_MEMORY_COMMON so private nodes that opt into reclaim are served by
reclaim and kswapd.

[ ... ]

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 3e934135e8052..03d0919d11bee 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c

[ ... ]

> @@ -7907,7 +7907,7 @@ static int __init kswapd_init(void)
>  {
>  	int nid;
> =20
> -	for_each_node_state(nid, N_MEMORY_COMMON)
> +	for_each_node_state(nid, N_MEMORY_RECLAIM)
>   		kswapd_run(nid);
>  	register_sysctl_init("vm", vmscan_sysctl_table);
>  	return 0;

[Severity: High]
Can starting kswapd on a private N_MEMORY_RECLAIM node trigger a global
OOM kill when MGLRU min_ttl_ms is set?

When kswapd runs balance_pgdat() -> kswapd_age_node() ->
lru_gen_age_node() and every generation on the private node is younger
than lru_gen_min_ttl (or all lruvecs on the node are too small or below
memory.min), lru_gen_age_node() invokes out_of_memory() with an
unconstrained oom_control:

mm/vmscan.c:lru_gen_age_node() {
	...
	if (!reclaimable && mutex_trylock(&oom_lock)) {
		struct oom_control oc =3D {
			.gfp_mask =3D sc->gfp_mask,
		};

		out_of_memory(&oc);

		mutex_unlock(&oom_lock);
	}
}

Because oc.zonelist and oc.nodemask are NULL, out_of_memory() selects the
highest-scoring process across the entire system, even if that process
only uses common memory and holds no pages on the private node.  Should
the out_of_memory() block in lru_gen_age_node() be restricted to
N_MEMORY_COMMON nodes?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120-private_no=
des_v6-v1-0-74f5f9a115c2@gourry.net?part=3D47
