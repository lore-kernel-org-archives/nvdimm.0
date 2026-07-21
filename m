Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C31E46EC61;
	Tue, 21 Jul 2026 18:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658131; cv=none; b=dXCs4eyS7xSMvdUze7S8v7ySxUwF9PPoF9A1F+87d274ENmmTBD8mbTzPi5cssvx4hed2IRyjSWvjIUaJfO2lUeIaA/7s58KrX2Xink0cR9nqcjTdfYn7+zIfgvAEYJ/lMLYn0uuziwXHbjE89GbnTUfbETpwUZbIWlSbEdmvpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658131; c=relaxed/simple;
	bh=/bfY5QB0/mTO8GfkJwfXajIWE4P96DeycS1akCwv/6c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jTqAUaITf3BMWwZbwumGf3WBsO8AKNOEjcU2uADgCyCKuoWtwX+EiupHeQ0gY+fP/MvMGmiu76t3OatU0iAdvk0cIsCQoz7l3TVDelnn3D88iZweUeRzJm287jfvMMEGHExuiccvcIxE0/5SCuNFeqU9wrLmP5ZDJBFpZFUm2eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bCsCwvWy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bCsCwvWy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C545A1F00A3A;
	Tue, 21 Jul 2026 18:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784658130;
	bh=2sV84yBJmVnSpFQDaIUWliz8wQuP4g3a7t4VN3feDXI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bCsCwvWy8fie1XYomgAiD45m4VXnIrUuo/+00ALB6Zcyhl35XA2fsGyn/rW3sO5Gb
	 EaH/Qr++dq+6ijrEktb2TW+eNnyl2ajOZQ1N3MYsu9GQ5e5VRYNuuzvZIk5wBUuIVg
	 K/L34IEqBHyRyKAA5I6Xj/aIF0ZVadPT3RvU9nJNkL8QZsW134ExiQJnOp0riqLp84
	 5ztw+nT4T1SnUVPKgywV9J1vEAMojr02Ip+icYKtn9uUdG3iLIi1lfhE/zLxw3E/Rg
	 x6NlBVIao44rpL9NdInI7npgoEN2c3dVTcznbHKh9teEIyw098wGCMlBGDVrUzE3SZ
	 puXcwfOI+8MPA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 06/36] cpuset: exclude private nodes from cpuset.mems
 (default-open)
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gregory Price" <gourry@gourry.net>
Cc: mkoutny@suse.com, hannes@cmpxchg.org, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, damon@lists.linux.dev, kvm@vger.kernel.org, tj@kernel.org
In-Reply-To: <20260720193431.3841992-7-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
 <20260720193431.3841992-7-gourry@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 21 Jul 2026 18:22:09 +0000
Message-Id: <20260721182209.C545A1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] Tasks in descendant cpusets do not have their mempolicies rebound =
when a private node is hot-unplugged.
- [High] Mempolicy creation (`mbind`, `set_mempolicy`) and page migration (=
`sys_migrate_pages`) unconditionally reject private nodes, breaking UAPI.
- [Medium] Valid private nodes are unconditionally stripped from tasks' mem=
ory policies during any unrelated cpuset update.
--

--- Patch [6]: [PATCH v5 06/36] cpuset: exclude private nodes from cpuset.m=
ems (default-open) ---
commit 9d0d11725cd4a8e139c634034823f38bcc9b8f9f
Author: Gregory Price <gourry@gourry.net>

cpuset: exclude private nodes from cpuset.mems (default-open)

This commit modifies cpuset handling to treat N_MEMORY_PRIVATE nodes as glo=
bally
accessible resources rather than partitioning them via cpuset.mems. It upda=
tes
node validation checks and hotplug logic to accommodate private nodes.

> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index dfd0f827e3b92..05468f95c10bd 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c

[ ... ]

> @@ -3922,9 +3932,12 @@ static void cpuset_handle_hotplug(void)
>  			top_cpuset.mems_allowed =3D new_mems;
>  		top_cpuset.effective_mems =3D new_mems;
>  		spin_unlock_irq(&callback_lock);
> -		cpuset_update_tasks_nodemask(&top_cpuset);
>  	}
> =20
> +	/* Rebind task mempolicies if any memory node changed state */
> +	if (mems_updated || priv_shrank)
> +		cpuset_update_tasks_nodemask(&top_cpuset);

[Severity: Medium]
When cpuset_update_tasks_nodemask() is called here, it passes=20
&cs->mems_allowed to mpol_rebind_mm():

kernel/cgroup/cpuset.c:cpuset_update_tasks_nodemask() {
    ...
    mpol_rebind_mm(mm, &cs->mems_allowed);
}

Because mems_allowed explicitly excludes private nodes, will this
inadvertently strip valid private nodes from a task's static memory policy
during completely unrelated cpuset operations?

> +
>  	mutex_unlock(&cpuset_mutex);
> =20
>  	/* if cpus or mems changed, we need to propagate to descendants */
>  	if (cpus_updated || mems_updated) {

[Severity: High]
Does this skip propagating private node hot-unplug events to descendant
cpusets?

If priv_shrank is true but mems_updated is false, this block is skipped.
Could tasks in descendant cpusets retain mempolicies pointing to the newly
offlined private node?

Additionally, if the loop does execute, cpuset_hotplug_update_tasks()=20
locally checks:

kernel/cgroup/cpuset.c:cpuset_hotplug_update_tasks() {
    ...
    mems_updated =3D !nodes_equal(new_mems, cs->effective_mems);
    if (!cpus_updated && !mems_updated)
        goto unlock;
}

Since effective_mems ignores private nodes, it appears descendant updates
would be skipped here as well.

[ ... ]

> @@ -4155,11 +4168,13 @@ nodemask_t cpuset_mems_allowed(struct task_struct=
 *tsk)
>   * cpuset_nodemask_valid_mems_allowed - check nodemask vs. current mems_=
allowed
>   * @nodemask: the nodemask to be checked
>   *
> - * Are any of the nodes in the nodemask allowed in current->mems_allowed?
> + * Are any of the nodes in the nodemask usable?  N_MEMORY nodes must be =
in
> + * current->mems_allowed, while N_MEMORY_PRIVATE nodes are always valid.
>   */
>  int cpuset_nodemask_valid_mems_allowed(const nodemask_t *nodemask)
>  {
> -	return nodes_intersects(*nodemask, current->mems_allowed);
> +	return nodes_intersects(*nodemask, current->mems_allowed) ||
> +	       nodes_intersects(*nodemask, node_states[N_MEMORY_PRIVATE]);
>  }

[Severity: High]
Are private nodes unconditionally rejected by sys_migrate_pages and mempoli=
cy
creation?

While cpuset_nodemask_valid_mems_allowed() was updated here, userspace
operations like kernel_migrate_pages() and mpol_set_nodemask() validate
against cpuset_mems_allowed(current), which is defined just above this
function.

cpuset_mems_allowed() delegates to guarantee_online_mems(), which masks
strictly against N_MEMORY.

For example, in mpol_set_nodemask():

mm/mempolicy.c:mpol_set_nodemask() {
    ...
    nodes_and(nsc->mask1, cpuset_current_mems_allowed, node_states[N_MEMORY=
]);
    ...
}

Does this mean any mbind() or set_mempolicy() targeting an N_MEMORY_PRIVATE
node will still be stripped and return -EINVAL?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720193431.3841=
992-1-gourry@gourry.net?part=3D6
