Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44FF946E012;
	Tue, 21 Jul 2026 18:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658827; cv=none; b=lhHKAdCXMSEEtVtUk7LK5RVwQPYioXd3GgwYbkwVVaNFzXUVQ1xS+6x/sl1Fb8W9SbfxmxGCWf5teGVkVLQxx+b6ftyJFf2NorLaCQUz9vPg/SI5S9zpoMBS+aVYzF5NlX8iD8x7dAAU9RLMKXeRuLh9/xKNBD9P8EaKxS14/00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658827; c=relaxed/simple;
	bh=QUAjjDsCjNFS7Y7Rk3+ilOh0/Y3fgWeXx5kGZc4z6K8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=og3sVIcXRLApslDqp+x/gYr9jMU2f1l5mqzKTgeq1OHbaGnL1PfQdLOvzRoJOCJdhXkKp3upmpheRNvMkWsaJha5ryABktG26dlUYLN8R+ZrEdbDOBT+i989ySIs8C/BlNs5Hfr8RZbKVAeNBikJbvU/JISQ0e7NWvwMWpRH9dU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nw2XMJ4f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nw2XMJ4f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A94F1F00A3A;
	Tue, 21 Jul 2026 18:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784658825;
	bh=qk7BsPv25KzN+RWDTkd6cmriou77M/FCOWrxsgl9Wmw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Nw2XMJ4f+OImOfprkjW/ww7WTq3GSm8b2ByO3HRF9hd2wamN6vYweHVe/lUnGgh7d
	 tB41b1icEWLVPgK8cpNmZTXg5UhSuc6ErqCemVvzFQmgazhlAHRrSKcIbujgelXMBz
	 wqcMClVooyFPQZefhmprKc1Z3ExH4k5LivQmt9OnXf+F6ltG3QxDDG10ZwSO/GH5xh
	 XVFQ7FsazIHxEHMoS7efzBss0Sa+hjwWISxMhsFonQk0aG9oYJC05zIFm1F0jDihmt
	 wwM7Aa3p468JDzdLkr2nI9uEiq3+a5soY/Wo1YcM5QbqKyOwkgejHse64gM4Hb2t2t
	 EWo6xLCqjxcHw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 25/36] mm/memory_hotplug: support N_MEMORY_PRIVATE
 node hotplug
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gregory Price" <gourry@gourry.net>
Cc: mkoutny@suse.com, nvdimm@lists.linux.dev, tj@kernel.org, kvm@vger.kernel.org, damon@lists.linux.dev, hannes@cmpxchg.org, linux-cxl@vger.kernel.org
In-Reply-To: <20260720193431.3841992-26-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
 <20260720193431.3841992-26-gourry@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 21 Jul 2026 18:33:45 +0000
Message-Id: <20260721183345.6A94F1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] Private node registration and unregistration incorrectly rely on N=
_MEMORY and N_MEMORY_PRIVATE states, which only track online memory, causin=
g isolation breakage and hijacking of normal memory nodes.
- [High] A TOCTOU race condition exists between memory unplug and private n=
ode registration due to lock ordering.
- [Medium] Direct access of __rcu pointer in pgdat_is_private() without usi=
ng rcu_access_pointer().
--

--- Patch [25]: [PATCH v5 25/36] mm/memory_hotplug: support N_MEMORY_PRIVAT=
E node hotplug ---
commit 976d363a06939b47fdc2d106fc8f3ec46359abd3
Author: Gregory Price <gourry@gourry.net>
Subject: mm/memory_hotplug: support N_MEMORY_PRIVATE node hotplug

This commit introduces add_private_memory_driver_managed() to allow
modules to hotplug memory into an N_MEMORY_PRIVATE node. It introduces
logic to register node ownership and opts these private nodes out of
reclaim/compaction by default.

> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 2b9c0830821e6..be230ac9efe5a 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c

[ ... ]

> @@ -1204,13 +1204,20 @@ int online_pages(unsigned long pfn, unsigned long=
 nr_pages,
>  	online_pages_range(pfn, nr_pages);
>  	adjust_present_page_count(pfn_to_page(pfn), group, nr_pages);
> =20
> +	/*
> +	 * N_MEMORY and N_MEMORY_PRIVATE are mutually exclusive, determine
> +	 * which is correct based on whether the pgdat->private is set.
> +	 */
>  	if (node_arg.nid >=3D 0)
> -		node_set_state(nid, N_MEMORY);
> +		node_set_state(nid, pgdat_is_private(NODE_DATA(nid)) ?
> +				    N_MEMORY_PRIVATE : N_MEMORY);

[Severity: Medium]
Does pgdat_is_private() directly evaluate the __rcu annotated
pgdat->node_private pointer without using rcu_access_pointer()? A direct
boolean evaluation of an __rcu pointer can result in compiler load tearing.

[ ... ]

> @@ -1688,6 +1702,19 @@ int __add_memory_driver_managed(int nid, u64 start=
, u64 size,
>  	if (online_type < MMOP_OFFLINE || online_type > MMOP_ONLINE_MOVABLE)
>  		return -EINVAL;
> =20
> +	/* Register a private-node owner before adding memory. */
> +	if (np) {
> +		if (mhp_flags & MHP_NID_IS_MGID) {
> +			group =3D memory_group_find_by_id(nid);
> +			if (!group)
> +				return -EINVAL;
> +			real_nid =3D group->nid;
> +		}
> +		rc =3D node_private_register(real_nid, np);
> +		if (rc)
> +			return rc;
> +	}
> +
>  	lock_device_hotplug();

[Severity: High]
Is there a race condition here since node_private_register() is called befo=
re
acquiring device_hotplug_lock?=20

If Thread A drops the lock in offline_and_remove_memory_ranges() before
calling node_private_unregister(), Thread B could successfully register
the node here. Thread B then blocks on device_hotplug_lock, allowing Thread=
 A
to clear the registration, which might cause Thread B to online its newly
added private memory incorrectly as normal system RAM.

[ ... ]

> @@ -1702,10 +1729,41 @@ int __add_memory_driver_managed(int nid, u64 star=
t, u64 size,
> =20
>  out_unlock:
>  	unlock_device_hotplug();
> +	if (rc < 0 && np)
> +		node_private_unregister(real_nid);
>  	return rc;
>  }

[Severity: High]
If this error path is hit, does node_private_unregister() unconditionally
drop the private node registration based only on the online state, ignoring
offline memory blocks on the same node? This could break previously added
offline blocks on this node.

[ ... ]

> @@ -2535,6 +2610,10 @@ int offline_and_remove_memory_ranges(const struct =
range *ranges,
>  out_unlock:
>  	unlock_device_hotplug();
> =20
> +	/* Drop private node registration if they are now memoryless */
> +	for_each_node_mask(nid, nodes)
> +		node_private_unregister(nid);
> +
>  	kfree(online_types);
>  	return rc;
>  }

[Severity: High]
Could node_private_unregister() blindly clear pgdat->node_private here
if it only checks the online N_MEMORY state instead of present memory?=20
If remaining memblocks on the node are offline, they might become normal
system RAM when later onlined.

Additionally, because device_hotplug_lock is dropped before unregistering
the private nodes, does this open a race window where a concurrent=20
add_private_memory_driver_managed() could have its state wiped out?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720193431.3841=
992-1-gourry@gourry.net?part=3D25
