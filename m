Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795199716;
	b=uSd7zS/9IOoKx2oA1qgibkbP9eYRLNvCuAFPI6wxjPzaboSIyup9IgOgEimNRMn2K3nr
	 sxRimza2c8rlk1At1N1jjaBYg3GglYLYe9jWDFppgz8kxPaFATXL9yU/DPqHmiY/agbLc
	 gUYsccux9BacU+I/px/54b7XQl6jTTZn3gfWAUhCfrD5XZMzV0zjs6RIGai6rX1Q2EvA9
	 vYtWXtkTepzXecF+AbrAi8dISPGty/JS8Y/Z/MyMJoXNGpVRYfDhhY9i4D7zBZF7YUi5Y
	 aVtl4Y3N2aOWiwZX4N6k474Y2uIRMyaQAvHQuf/Ud2i5039Q5Vdb0Fi0BQHtoCGRdRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795199716;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=bIIG4zl8TPynaHSoT/O3ZoKJ4B6crfr5G2QFKKsC6Lk=;
	b=F/SPrg9Rk29baPPWRKKiFhCD/BeCNjvo+ujOPAmVw8hNaYudGAc7vi7xaJANyOAZ2VXg
	 rAvauuR+PcFJUupOzPsDtab4o0pGzRZLpaf1Dwgugta2GePQB0CVRmfKN8sqH8Qo2mBBs
	 ex9wDlcy71Id9i24iSbiTRA7Xtpn5nHpY9v/229vAKkLFpPdo7v7qLqnYNdSrifVfhdOB
	 RN3oNF2HPxCW9wqCThPg20UGC0PxGZ3Xk1OSXidAcqmAvsPkeKDm/3FYHkIHyGUbmunIv
	 R+zqBQFgX6IBJXyyEib2+ub8tH4Pt1bTDwdeNHof/58BhV+ah2rCk5ZF0+y1U6uh44A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IZ4SaAZ3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3829C60A261C;
	Fri, 20 Nov 2026 18:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IZ4SaAZ3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA14E1F000C4;
	Fri, 20 Nov 2026 18:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795199715;
	bh=bIIG4zl8TPynaHSoT/O3ZoKJ4B6crfr5G2QFKKsC6Lk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IZ4SaAZ3xCf9fmTzel7z2Tk9TIFRfoUGZSYfC98iVbTeiiyblv4aoaef4r+xwtRVO
	 hr8lvDMwLdArT5DPO89KcmvYqzd2RAC0i9MxQYF5nrlX2LgRoPgNs8u7Nqm1LK6S+N
	 1akWRflhMNPGcsxRoSBIJCmgk3+OdoOiVcFQMQlR7tzbD2g00JM81GXtoqVrGt9ThA
	 u/UsasALhuwwYALzSlsje+JOrdGzsRW2mHN1ySOdF7Fo8zfmEmHHZELgU4a70worZk
	 Bk9O4BUe3w8OQZuX+ARs60ZjwbBHLFG6PuGDW9cPWEfvy3X7ICNYeaotlqi78nr5/a
	 VOI5jPwkAyOYA==
Message-ID: <sashiko-outbox-225846@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 59/60] selftests/dax: test cpuset interaction with
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
In-Reply-To: <20261120-private_nodes_v6-v1-59-74f5f9a115c2@gourry.net>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
 <20261120-private_nodes_v6-v1-59-74f5f9a115c2@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 18:35:11 +0000
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
- [Low] selftests/dax: stage desync and wait hang in
  run_private_transitions()
--

commit 86268e0cbec65176c860c84e90fc221fb5d0e80c
Author: Gregory Price (Meta) <gourry@gourry.net>

selftests/dax: test cpuset interaction with private nodes

This commit adds selftests and a C helper tool to verify cgroup-v2 cpuset
interactions with private kmem nodes across cpuset.mems changes, task
attachment, and node hotplug/retyping.

> diff --git a/tools/testing/selftests/dax/kmem_private_rebind.sh b/tools/t=
esting/selftests/dax/kmem_private_rebind.sh
> new file mode 100755
> index 0000000000000..5d39be04f1795
> --- /dev/null
> +++ b/tools/testing/selftests/dax/kmem_private_rebind.sh
> @@ -0,0 +1,301 @@

[ ... ]

> +run_private_transitions()
> +{
> +	local mode=3D$1 label=3D$2 action=3D${3:-reshape}
> +	local stage mask title cg=3D
> +	local titles=3D("keeps private pages and placement while the node stays=
 allowed"
> +		"evacuates private pages and uses common placement when access is revo=
ked"
> +		"restores the original private request when access returns")
> +
> +	echo "${COMMON[0]},$PN" > "$CG/cpuset.mems"
> +	if [ "$action" =3D attach ]; then
> +		echo "${COMMON[1]},$PN" > "$CG/cpuset.mems"
> +	fi
> +	# Shared-policy parents and task-attachment tools start at the root.
> +	if [ "$mode" =3D private-anon ] && [ "$action" =3D reshape ]; then
> +		cg=3D$CG
> +	fi
> +	if ! start_tool "$mode" "$cg"; then
> +		ktap_print_msg "tool setup failed"
> +		for title in "${titles[@]}"; do
> +			ktap_test_fail "$label $title"
> +		done
> +		stop_tool
> +		return
> +	fi
> +	if [ "$mode" =3D private-shared ] && [ "$action" =3D reshape ]; then
> +		echo "$TARGET" > "$CG/cgroup.procs"
> +	fi
> +	for stage in 0 1 2; do
> +		mask=3D${COMMON[1]}
> +		[ "$stage" =3D 1 ] || mask+=3D",$PN"
> +		if ! transition_cpuset "$action" "$stage" "$mask"; then
> +			ktap_print_msg "cannot change the cpuset"
> +			ktap_test_fail "$label ${titles[$stage]}"
> +			continue
> +		fi
> +		report_stage "$stage" "$label ${titles[$stage]}"
> +	done
> +	wait "$CHILD"
> +	CHILD=3D
> +	TARGET=3D
> +}

[Severity: Low]
Does continuing on a transition_cpuset() failure desynchronize the stage
loop from kmem_private_rebind_tool and leave wait "$CHILD" blocked until
the 60-second timeout expires?

In private_rebind(), the helper tool loops for stage =3D 0, 1, 2 and blocks
in sigwait() for one SIGUSR1 per stage.  Skipping report_stage() with
continue omits sending SIGUSR1 for the failed stage, so subsequent
iterations wait for a stage number the tool has not reached yet, and after
the loop the tool remains blocked in sigwait() because it received fewer
than three signals.  Handling this like run_private_retype() by tracking
tool readiness and calling stop_tool at the end would avoid the hang.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120-private_no=
des_v6-v1-0-74f5f9a115c2@gourry.net?part=3D59
