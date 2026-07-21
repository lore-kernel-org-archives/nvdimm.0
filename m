Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B44438FEE;
	Tue, 21 Jul 2026 21:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668311; cv=none; b=np8sROuxbg9fTh5ExoQQkBu9d0drklYza94K+oESlXaBJTcWHnuGx+NXMcbjEp1RgwWDuO8jEwF0Z6B+BhevSKLUQdEmnzbNJVRLwOLSfXiAAE3VfsYVnjhZAO4OqVWbFqxYxLNGBc5LXe2YCrdAAHbSx5JTaxhbzQg0ZTPES6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668311; c=relaxed/simple;
	bh=BBovP7uQEcUFuM2YToFEW7eq26PAwEujsS0dB000+SY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=WJRxIb4SPswa98NRUvunqd0rwCSXRqCxUj3fNd5gjztxuQ8PGz4q/nzmDEZuLcvhC/LDCC6lgCtjWB2/JlHkDH087nKOrjIK8b5CeNRU4gL+ueS72HGDsoubMgcwYTylca4S2NtRp5ZPt9fOOPRdPdAaIS+q7MeCF2z8e1mzr4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LhSkTS8z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LhSkTS8z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14DC91F000E9;
	Tue, 21 Jul 2026 21:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784668310;
	bh=BuqYyagB9bD8nuWvoZFsdPW7RJYIGN82fvrgTmXEuJs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LhSkTS8zIcMKGMJkJv3pr87Ri4YrqulXgtIFGis2Pa+53dEEx+hYj2W3OrhyqnE4R
	 KN7A3/XGzCFIXDVr1KH7NvCQD5KGgd8u5pMYbAt5GRu4PpaYeCBDFSychpatZpn8Go
	 W1jiRK+aP0A6I6M+kxKn//STMLSnFafAMRzEnmNYPuyWJv21KQVYs/KMyrddC2JUdV
	 3mg1RzZwWq9H8zCYrMNcfOzinvcmaCuJGYnp1Ee4UyYtl6W3jSJTI0w/SbpLqM1bGk
	 c7mg82RwuOm+1mrof4roADUQCiMDqHlGKQ1tK5rWCwsTF1PPy1BYsS32ux+keUHkt/
	 KLufuk51ZgCNw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 35/36] KVM: guest_memfd: bind backing memory to a
 NUMA node at creation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gregory Price" <gourry@gourry.net>
Cc: mkoutny@suse.com, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, damon@lists.linux.dev, tj@kernel.org, hannes@cmpxchg.org, kvm@vger.kernel.org
In-Reply-To: <20260720193431.3841992-36-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
 <20260720193431.3841992-36-gourry@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 21 Jul 2026 21:11:49 +0000
Message-Id: <20260721211150.14DC91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] Unconditional validation of flag-gated syscall parameters outs=
ide their flag scope breaks ABI compatibility for existing userspace.
- [Medium] Missing lock when calling `mpol_set_nodemask` leads to data race=
 and torn read of `current->mems_allowed`.
--

--- Patch [35]: [PATCH v5 35/36] KVM: guest_memfd: bind backing memory to a=
 NUMA node at creation ---
commit 45130876f6e87292f19cee2648796441ea4622ce
Author: Gregory Price <gourry@gourry.net>

KVM: guest_memfd: bind backing memory to a NUMA node at creation

guest_memfd presently allocates its page-cache folios through a per-inode
shared mempolicy. This patch adds GUEST_MEMFD_FLAG_BIND_NODE to set an
MPOL_BIND policy for the requested node and install it over the whole
inode's shared policy.

> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index f0e5da4908660..de320df08e0ff 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c

[ ... ]

> @@ -456,6 +456,26 @@ static struct mempolicy *kvm_gmem_get_policy(struct =
vm_area_struct *vma,
>  	 */
>  	return mpol_shared_policy_lookup(&GMEM_I(inode)->policy, pgoff);
>  }
> +
> +static int kvm_gmem_bind_node(struct inode *inode, int node)
> +{
> +	struct mempolicy *pol;
> +	int err;
> +
> +	pol =3D mpol_bind_node(node);

[Severity: Medium]
Can calling mpol_bind_node() here without holding task_lock(current)
cause a data race?

Looking at mpol_bind_node(), it calls __mpol_bind_node() which then calls
mpol_set_nodemask(). This accesses current->mems_allowed locklessly.

If a task's cpuset is concurrently modified, this could lead to a torn read
of current->mems_allowed on systems with >64 NUMA nodes, potentially
failing or creating a policy with an incorrect or empty nodemask.

> +	if (IS_ERR(pol))
> +		return PTR_ERR(pol);
> +
> +	err =3D mpol_set_shared_policy_range(&GMEM_I(inode)->policy, 0,
> +					  MAX_LFS_FILESIZE >> PAGE_SHIFT, pol);
> +	mpol_put(pol);
> +	return err;
> +}

[ ... ]

> @@ -630,6 +656,7 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_creat=
e_guest_memfd *args)
>  {
>  	loff_t size =3D args->size;
>  	u64 flags =3D args->flags;
> +	int node =3D NUMA_NO_NODE;
> =20
>  	if (flags & ~kvm_gmem_get_supported_flags(kvm))
>  		return -EINVAL;
> @@ -637,7 +664,15 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_crea=
te_guest_memfd *args)
>  	if (size <=3D 0 || !PAGE_ALIGNED(size))
>  		return -EINVAL;
> =20
> -	return __kvm_gmem_create(kvm, size, flags);
> +	if (flags & GUEST_MEMFD_FLAG_BIND_NODE) {
> +		if (args->pad || args->node >=3D MAX_NUMNODES)
> +			return -EINVAL;
> +		node =3D args->node;
> +	} else if (args->node || args->pad) {

[Severity: Critical]
Does unconditionally checking args->node and args->pad when the
GUEST_MEMFD_FLAG_BIND_NODE flag is absent break ABI compatibility?

Since these fields were previously part of the unused reserved[] array,
existing userspace binaries might allocate struct kvm_create_guest_memfd
on the stack without zeroing them.=20

If an older binary calls the ioctl without the new flag, and the stack
garbage happens to be non-zero, this will now fail with -EINVAL.

> +		return -EINVAL;
> +	}
> +
> +	return __kvm_gmem_create(kvm, size, flags, node);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720193431.3841=
992-1-gourry@gourry.net?part=3D35
