Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795200166;
	b=Fs9umWRqs3Pb5vNLlrtdbW+aFxSPRXbY/+jn3x7+LPAmbXFgxAwLEcyuRbhnGFRZbtFJ
	 Wa90qEsU6Q3DgpH0ZQSl2rmTcE1XKiWVBEXdF1AP9H9Yz6psX5nav8gliVLQj8bs8pPgq
	 1Ih91dqDna/LWvAA4/3Mtt0O3NHe2GZGroG1Wk5vq4V/XU+aBDpt8G/hTREZeL61zOYng
	 fKroQ7reCPXXkLlJ6O1S3FcxSmKob0Tdu57CXLQeaBpk4ZgwEtz6owhMWdWQ/dBm1HPHV
	 jVDnT7FUF82G3v5+uwGCPk6ZV4hFcOmh8bV3NSUrGKXisOpOuT00KiB1oze6Bx9tpcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795200166;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=z1zh3TJUF2LHvTsPDLhOKm9aAKGeAr+Rv7zEz9ub0Ss=;
	b=h61f/M+NEARqeaMy+swOBsY05ji/amPKv5idXoFJBh1b7xhb5Ivg+w+14+4ffpRgVXfA
	 JreBSQqpMkf3sy1yzjOdEw+UUHLOBxHpXDMs6qR40pvi9IWTFvYjMyFm0dI2qGjpNGaAS
	 karVQOiZUbo6EMwHrCmFVSIdsBNwg27Boiaye/53RmIVcfS5HZWo5KBOijYyJgyNqa/Nk
	 UGMZLzMpJlF8xzn/GtuVjvuvNeRqJTubb+/q6KC4Q+BxRuYkqnPxYXMb62h9jW22nBX4j
	 RnkzMB8gSI8/CdsiJGziYTnw23l46VHR3FXTjdWCxRuaSDGazMiznLyU0PGFI9zyhLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EB7YZSaM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C421960A261F;
	Fri, 20 Nov 2026 18:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EB7YZSaM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FD9D1F000CA;
	Fri, 20 Nov 2026 18:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795200166;
	bh=z1zh3TJUF2LHvTsPDLhOKm9aAKGeAr+Rv7zEz9ub0Ss=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EB7YZSaMQhKNHJn5T5hQ26qddBeIY3gRxU8BqrEnzFRly9bd8/QfANR/QM+PrZN8j
	 HEdpRKyjfXWoLsOom2cTj/G+6Y/X/2VfUfyOmKEF1qhibbWjfP6CypNWnhIqJE30ww
	 Kqr8gVQ/x84u7IxYLXoDUYfAV1MrcIwnoOwB32IbLc0q4jPtz2m9GLkB4uJmhxrwBu
	 Auv9aNSYSh/qleHQaAQtj6318u9uu7OhXKo7sWZzhFHmy2igbCl/InZOJ2UG9ph9bM
	 AagsRCpkif6kZtl0iFwX5ViUxHYj0NGAsStGOoW+GmKEhJ2bZ4ngt2cNtTENzI7hsD
	 8MS+YgDdBRkDw==
Message-ID: <sashiko-outbox-225860@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 57/60] selftests/dax: test private kmem devices and
 services
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
In-Reply-To: <20261120-private_nodes_v6-v1-57-74f5f9a115c2@gourry.net>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
 <20261120-private_nodes_v6-v1-57-74f5f9a115c2@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 18:42:42 +0000
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
- [Medium] selftests/dax: kmem bind in pn_online_private() without
  offline policy
--

commit 92dda1f7387efcfeae9e63aee96816a2f4e187f1
Author: Gregory Price (Meta) <gourry@gourry.net>

selftests/dax: test private kmem devices and services

This commit adds kselftests exercising the dax/kmem private sysfs
attribute across memory hotplug and verifying which MM services run on a
private kmem node.

> diff --git a/tools/testing/selftests/dax/private_node_common.sh b/tools/t=
esting/selftests/dax/private_node_common.sh
> new file mode 100644
> index 0000000000000..57c5231e768b8
> --- /dev/null
> +++ b/tools/testing/selftests/dax/private_node_common.sh
> @@ -0,0 +1,208 @@
[ ... ]
> +# Move device $1 from driver $2 to kmem and online it as private memory =
on
> +# node $3.
> +pn_online_private()
> +{
> +	local dev=3D$1 driver=3D$2 nid=3D$3 name
> +
> +	name=3D$(basename "$dev")
> +	if [ "$driver" =3D kmem ]; then
> +		echo unplugged > "$dev/state" || return 1
> +	elif [ -n "$driver" ]; then
> +		echo "$name" > "/sys/bus/dax/drivers/$driver/unbind" || return 1
> +	fi
> +	# A private node holds the memory of this device only.
> +	if pn_node_in "$nid" has_memory; then
> +		return 1
> +	fi
> +	if [ "$driver" !=3D kmem ]; then
> +		echo "$name" > /sys/bus/dax/drivers/kmem/new_id || return 1
> +		PN_NEW_ID=3D1
> +	fi
> +	echo unplugged > "$dev/state" &&
> +		echo 1 > "$dev/private" &&
> +		echo online_movable > "$dev/state" &&
> +		pn_node_is_private "$nid"
> +}

[Severity: Medium]
Can binding a non-kmem device via /sys/bus/dax/drivers/kmem/new_id wedge
the device as online common memory when
/sys/devices/system/memory/auto_online_blocks is set to online or
online_kernel?

dev_dax_kmem_probe() hotplugs the device at bind time with private=3Dfalse
and online_type =3D mhp_get_default_online_type().  If auto_online_blocks
onlines the blocks into a common kernel zone during probe, unmovable
kernel allocations can cause "echo unplugged > $dev/state" to fail with
-EBUSY before private=3D1 can be set.  When pn_unbind_kmem_private() runs
on that failure, the unplug attempt fails at the same point after PN_DEV
is cleared, returning early without removing $name via
/sys/bus/dax/drivers/kmem/remove_id or rebinding the original driver.

Should pn_online_private() temporarily set
/sys/devices/system/memory/auto_online_blocks to offline around the
new_id bind, the way dax-kmem-hotplug.sh does?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120-private_no=
des_v6-v1-0-74f5f9a115c2@gourry.net?part=3D57
