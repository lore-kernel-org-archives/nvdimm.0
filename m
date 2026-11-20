Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795199720;
	b=05nILMvfb1r2jTGwX7H5BtH8WoKN7Kk38kBFTFxPZiWyqudwzCWmpHjHjJRYzTW6NSMc
	 5M+gmCW+iU5DJmIVMX4ei+iehQ7oL5i3pTGAWz0KDlDmE4TKNECcmkOWGdP7EjDGL3ZhD
	 +J54Qyiq9m8Zqiq9EXPQ3iPIyA3GG+lkz8jmClGzZ1He23hDfRoWgtKjruouBlfqb13Es
	 +DM8fyDFRyrkbyNccA0r5DTDPGQwgZl/2D4+ajsFdTbG3jFC/nU0VUOLiUqpemtT1n8jE
	 HGI1z9XTtU7vI1QVM3rKKn+IroSPqbDgTh+Zde+v1qWz9nfvpqWAmEk1SKsvh+NrJSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795199720;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=9i7EBLWiLY+Ax+szjOTrErjeUkWZA+e5Jk/kHB2fTnM=;
	b=mLnq+14kgpDI7h3B41o03k2Sdl9SW0Cd67NYCAIpz/wRvOBFBtvbf7B8jdaPfy/DdUZ4
	 ZJpbJShVUQ3ZHMlxSBofxei5VyO9yXjGkqODqTVbLSZq2dVUQvxm8QbcAxNDYU/nSiFIP
	 8YJ2PxUZaPPB3QTLGwz/ziXTj8VcWhk6u09ENIDQtyyjQJ/97iRx7iXw3A5qINRRIfkRS
	 Jgqrs7xsYOJ4IsaGNaRq7qHTO6UitpT+Q+oMrUKRh34r7V0opxQs3NNsL4+0UVegCwzqt
	 II0U6E44RPCMzC73qIrmuW50vwuDJBC6FV90f38AfvjFTMx/YyYWdxfOaqcw5A/lhtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hGnVxSpJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D5E60A2620;
	Fri, 20 Nov 2026 18:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hGnVxSpJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37B9F1F00A03;
	Fri, 20 Nov 2026 18:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795199720;
	bh=9i7EBLWiLY+Ax+szjOTrErjeUkWZA+e5Jk/kHB2fTnM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hGnVxSpJ97jRelrIDpBEeoCAz9DdKg+K4WDztt2Qh2dV7u04H+j3/tDRMMG4IOG8M
	 RxxlIx9iSqG9HlgwOS5hj6DXh4Asq+yz0rOgg81LQELzo5cE/pjnQBqWpEqCqwnwOe
	 g0QyeLFtJq2weIGX8bCivqiVgN5Ocp8vzj1MxdcKGRlJwN8Z8A4SCAtyWmd/40Ttr4
	 z9uYk9u8MPceZH9f6nWh5By8yRNux2WZNL6fqAXOorjmOaP0U+naK4eFrZsKa2b8bG
	 1GDe17P+olC0crZjKZLqdbnbhOc3jOxxt+2eTAfpmCfZjk4TVEuW3NVVGcD/rRHe+I
	 Oa5btytoKzgPQ==
Message-ID: <sashiko-outbox-225847@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 58/60] selftests/dax: test memory policy on private
 nodes
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
In-Reply-To: <20261120-private_nodes_v6-v1-58-74f5f9a115c2@gourry.net>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
 <20261120-private_nodes_v6-v1-58-74f5f9a115c2@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 18:35:15 +0000
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
- [Medium] selftests/dax: common_policy() resets task policy before
  faulting pages
--

commit 2c509a362d5823231bce734e3d872af08303fbb5
Author: Gregory Price (Meta) <gourry@gourry.net>

selftests/dax: test memory policy on private nodes

This commit adds a selftest tool and wrapper script to verify memory policy,
migration, reclaim, and exhaustion behavior on private memory nodes.

> diff --git a/tools/testing/selftests/dax/kmem_private_policy_tool.c b/too=
ls/testing/selftests/dax/kmem_private_policy_tool.c
> new file mode 100644
> index 0000000000000..0769436b6068e
> --- /dev/null
> +++ b/tools/testing/selftests/dax/kmem_private_policy_tool.c

[ ... ]

> +/*
> + * A relative or static policy whose mask names the private node must st=
ill
> + * place memory on common nodes, and keep the user's mask.
> + */
> +static int common_policy(void *addr, size_t len, int nid, int requested_=
mode,
> +			 unsigned long mask, int task_policy)
> +{
> +	unsigned long reported =3D 0;
> +	int mode =3D 0;
> +	long rc;
> +
> +	if (task_policy) {
> +		if (syscall(SYS_mbind, addr, len, MPOL_DEFAULT, NULL, 0UL, 0UL))
> +			return FAIL;
> +		rc =3D syscall(SYS_set_mempolicy, requested_mode, &mask, MAXNODE);
> +	} else {
> +		rc =3D mbind_mask(addr, len, requested_mode, mask);
> +	}
> +	if (rc)
> +		return FAIL;
> +
> +	rc =3D syscall(SYS_get_mempolicy, &mode, &reported, MAXNODE,
> +		     task_policy ? NULL : addr, task_policy ? 0 : MPOL_F_ADDR);
> +	if (task_policy)
> +		syscall(SYS_set_mempolicy, MPOL_DEFAULT, NULL, 0UL);
> +	if (rc || mode !=3D requested_mode || reported !=3D mask ||
> +	    madvise(addr, len, MADV_DONTNEED))
> +		return FAIL;
> +	memset(addr, PATTERN, len);
> +	return pages_on_node(addr, NR_PAGES, nid) =3D=3D 0 ? PASS : FAIL;
> +}

[Severity: Medium]
Does resetting the task policy to MPOL_DEFAULT before madvise(MADV_DONTNEED)
and memset() prevent the task_policy cases from testing page placement under
requested_mode?  When task_policy is set, both the VMA policy and the task
policy are back to MPOL_DEFAULT by the time memset() faults the pages in, so
the relative and static task policy tests always allocate under MPOL_DEFAUL=
T.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120-private_no=
des_v6-v1-0-74f5f9a115c2@gourry.net?part=3D58
