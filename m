Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795200171;
	b=ahKDzmlWfFWrJA65OHc8kDtObX6CNFLMKAlxeb5JAy96EQoNxfrTcuRhzROFZNUFmmQG
	 s1vWLqMZNJeDJ5D5peugeX2+ZBXFjgOmOSr45yF/FdDYrSBGZPhP6m3URBjlrDYBUVs1m
	 RAFCMNK0ppe6QrMkPQdVVdt9F1bv3W2p+En/LliunLCLtojxUp6NaTcVtR7rgm94FeWlv
	 Qexu/hgFzuCll1XPCVSFjSQpP0xNrU60sfctfww+iSm3SpW3qpwIlGgK1KCkEam4YegNt
	 0q0thObC9TbLJvWtC202k8RWvZdPJjHeorYQmweskTRsixh04rk5vApYgnWBWpPtbMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795200171;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=y9Ozc/vyn7RySaeVKc2C5lg/xFQMgUpBnP9tdHlREPY=;
	b=CDvguhtaq58Pw5FGvBX2OjvGNZr9RXssrVc0Vm30/cAHBhh3G37lkQP57uTc4H5biyMM
	 ZJ5ZnduTuZHK1sQR/e4sEwSSrP/li7FEkrgrBj9OVtup0Vif3F9X+I9E2Ta78P2rboUD1
	 eeabDXQXjuvnnfhJ3bXjyB9NBuXYFGaOPIYQeI1mHjlMpZeEPFQ8iDC3/M8hb+FGesDb0
	 dFkI+wHWfpA5WWgw5atAk3NX+1l70mS1pBRXWrLizIJ/mjRuDzF0i4BxxTA8H8sAgSoQb
	 07n2SIAsPmcdT/J0DCwusP304hvbX3kjY3Zgia+goUTLSYR2dqqHGrX3sCIMldQzGTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aNS4yN8W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1630460A262A;
	Fri, 20 Nov 2026 18:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aNS4yN8W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 225661F000CA;
	Fri, 20 Nov 2026 18:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795200170;
	bh=y9Ozc/vyn7RySaeVKc2C5lg/xFQMgUpBnP9tdHlREPY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aNS4yN8WEpXWTabD3hYouluOLl2waSA6+zhE9QzQ+lvUBa0+6LyNQ00WDLkY3U6Qe
	 +O4fmxQE7oVBgIgsFy7fM7WXho8sew8qw2QuWIaVx+2PkOIzdiInFEYMxpV9b7h6SD
	 N/ZofWLmNj7em5KG46/WtsXQDY23YceB88TmzaLWMFi8Sbm0qxrUivFkOf3oEuvfyK
	 6dLZbAuP9Xym9/gzSzZFt+Yhqw2DCTmQ53Gi/uXHtRJ+Gqhg+uGNt1P8s2PFk70mYr
	 EvYOZHzEreWOK77ywVLdCmu0lC4y+9VthhGlyBZAXA1VTSznZJeVnm1A48UZoqmGpv
	 33zdIDyNGOX1g==
Message-ID: <sashiko-outbox-225861@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 54/60] mm/migrate: route explicit NUMA migration to
 private nodes
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
In-Reply-To: <20261120-private_nodes_v6-v1-54-74f5f9a115c2@gourry.net>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
 <20261120-private_nodes_v6-v1-54-74f5f9a115c2@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 18:42:46 +0000
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
- [High] mm/migrate: call to undeclared __folio_alloc_flags() in
  alloc_migration_target()
--

commit ca3cf1708bab40e7c2c443ad00cbc882e2163cee
Author: Gregory Price (Meta) <gourry@gourry.net>

mm/migrate: route explicit NUMA migration to private nodes

This commit routes move_pages(2) and migrate_pages(2) allocations for
N_MEMORY_MEMPOLICY private destination nodes through the node's private
zonelist by passing ALLOC_ZONELIST_PRIVATE via migration_target_control.

> diff --git a/mm/migrate.c b/mm/migrate.c
> index 6791834f14fe1..eda961d43df0e 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -2250,6 +2250,9 @@ struct folio *alloc_migration_target(struct folio *=
src, unsigned long private)
>  	if (is_highmem_idx(zidx) || zidx =3D=3D ZONE_MOVABLE)
>  		gfp_mask |=3D __GFP_HIGHMEM;
> =20
> +	if (mtc->alloc_flags)
> +		return __folio_alloc_flags(gfp_mask, order, nid, mtc->nmask,
> +					   mtc->alloc_flags);
>  	return __folio_alloc(gfp_mask, order, nid, mtc->nmask);
>  }

[Severity: High]
Where is __folio_alloc_flags() declared?  Neither include/linux/gfp.h nor
mm/page_alloc.c defines __folio_alloc_flags() or
__folio_alloc_flags_noprof(), so building mm/migrate.c with
CONFIG_MIGRATION=3Dy fails with an implicit function declaration error.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120-private_no=
des_v6-v1-0-74f5f9a115c2@gourry.net?part=3D54
