Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80AC7522686;
	Thu,  1 Oct 2026 15:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790868611; cv=none; b=FpDn27VcyDHhYHgHw/i67JDoTPPQCiLekT1Ddu/Ex6SVmWT9W2UW+Z7Il2SD0sItUU6dMXNhguP47UOIFf+NbvxffPC1/FSxXVXsrOh0e1e5ji6eM6XnZS9IT8qn4XlezuMMli0p7hZSjloPZ6bUXV/5Z87PrX6ALwcqcp4lZ6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790868611; c=relaxed/simple;
	bh=muY0V+KUOcFQKFYcRg62vEQrsMrV5enlSvZXgBO9HLU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=RmPzqSkTxzfmQkM1519ZVgRLPDixsgLsZgPMks6OowwzcmofSNd1gwodu7N0iwK2VsW43ULVdBXZpdspQ8BVu8o/15QdG1uZr77RpdBLMZCmm03AqgfM/0S6o34o6JISNexY407haVeC2zLFtYgHO1AD+sq+36FLUi6VGfQzogM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oeN0YC3a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oeN0YC3a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A601F000FF;
	Thu,  1 Oct 2026 15:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790868610;
	bh=gC1Ts+DIWPkHLd+42gIcrwwXXQq8F7LkUy97KRMMJZM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oeN0YC3acx9VpKZOMM12kp+UjAtZa6pndjCxHKQSVlxxB+s9Oj1IdxawUeOj07lDo
	 JJlZu25EIKyy2mRfsA/qr8BBuA8ecvqiFxuvjKTgmrBl++ceDrE4t3zqzaIElci0dt
	 vxdZkpl7NNiHfL4LH1Zv+yRaMCj73oxUU8aqNC6Dlx5biCf370Chp3i3Cd9N/fzA8d
	 H7fRny5KFboRW2ktGBAHGoJZDmewowA5siRwhnYwWFp0K8Bbud3JKXUsQciG/A+nCO
	 I7uN8y13CN2M4FtbGCC6ApJR1BoAGsCmiCLrBxAQakmZfCMriJOQabT/1kHEQBrsNp
	 YkugkU13yhdjw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 5/8] fuse: add support for opening dax device as
 backing
Reply-To: sashiko-reviews@lists.linux.dev
To: "Miklos Szeredi" <mszeredi@redhat.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <20261001150935.655979-6-mszeredi@redhat.com>
References: <20261001150935.655979-1-mszeredi@redhat.com>
 <20261001150935.655979-6-mszeredi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 15:30:09 +0000
Message-Id: <20261001153009.F1A601F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:
- [High] mm: missing a_ops methods on passthrough DAX inodes
- [High] mm: uninitialized memory in fuse_backing_new for dax_error
- [High] mm: NULL pointer dereference in fuse_dax_notify_failure race
- [High] mm: virtiofs DAX cache consistency broken by IS_DAX check
- [Medium] mm: RCU data race on backing_id in fuse_backing_close_64
--

commit db1b69a7f08e8b3b4063c0a40f3bd08ae1c2dbc6
Author: Miklos Szeredi <mszeredi@redhat.com>
Subject: fuse: add support for opening dax device as backing

This commit adds support for using a DAX device as a backing file for FUSE.
It marks the inode with S_DAX when FUSE_ATTR_DAX is set during lookup, and
prepares the backing object structures and ops for DAX devices.

> --- a/fs/fuse/backing.c
> +++ b/fs/fuse/backing.c
[ ... ]
> @@ -103,39 +111,83 @@ int fuse_backing_close_64(struct fuse_conn *fc, u64=
 backing_id)

[Severity: Medium]
Could modifying fb->backing_id to 0 outside of the rhashtable lock while
lockless readers might still be inspecting it cause an RCU data race?
RCU readers could be concurrently comparing the key in rhashtable_lookup_fa=
st,
potentially leading to KCSAN warnings.

>  	return 0;
>  }
> =20
> -static struct fuse_backing *fuse_backing_new(struct fuse_conn *fc, int f=
d)
> +static int fuse_dax_notify_failure(struct dax_device *daxdev, u64 offset=
, u64 len, int mf_flags)
>  {
> -	struct fuse_backing *fb;
> -	struct super_block *backing_sb;
> -	struct file *file;
> +	struct fuse_backing *fb =3D dax_holder(daxdev);
> =20
> -	/* TODO: relax CAP_SYS_ADMIN once backing files are visible to lsof */
> -	if (!fc->passthrough || !capable(CAP_SYS_ADMIN))
> -		return ERR_PTR(-EPERM);
> +	fb->dax_error =3D true;

[Severity: High]
Does this code risk a NULL pointer dereference if it races with fs_put_dax?
If a memory failure occurs concurrently with fuse_backing_free clearing
the DAX holder data, dax_holder could return NULL. Should we verify fb
is not NULL before accessing dax_error?

> +
> +	return 0;
> +}
[ ... ]
> +static struct fuse_backing *fuse_backing_new(struct fuse_conn *fc, int f=
d)
> +{
> +	struct fuse_backing *fb __free(kfree) =3D kmalloc_obj(*fb);

[Severity: High]
Does this allocation leave fb->dax_error uninitialized? Since kmalloc_obj
does not zero memory, the adjacent union member dax_error might contain
garbage when the dax_dev is explicitly initialized for S_IFCHR later. If
subsequent patches in this series read dax_error (such as in
fuse_ext_map_iomap_begin), it could falsely trigger an error path and cause
erratic failures.

> +	int err;
> =20
> -	fb =3D kmalloc_obj(struct fuse_backing);
>  	if (!fb)
>  		return ERR_PTR(-ENOMEM);
[ ... ]
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -297,7 +297,7 @@ static int fuse_open(struct inode *inode, struct file=
 *file)
>  	if (!err) {
>  		if (is_truncate)
>  			truncate_pagecache(inode, 0);
> -		else if (!(ff->open_flags & FOPEN_KEEP_CACHE))
> +		else if (!(ff->open_flags & FOPEN_KEEP_CACHE) && !IS_DAX(inode))
>  			invalidate_inode_pages2(inode->i_mapping);

[Severity: High]
Could skipping invalidate_inode_pages2 for DAX inodes break virtiofs DAX
cache consistency? Virtiofs DAX relies on invalidate_inode_pages2 to clear
stale DAX exceptional entries from the page cache XArray. Without this
invalidation, stale mappings might remain resident and cause data corruptio=
n.

>  	}
>  out_unlock:
> --- a/fs/fuse/inode.c
> +++ b/fs/fuse/inode.c
[ ... ]
> @@ -403,6 +403,10 @@ static void fuse_init_submount_lookup(struct fuse_su=
bmount_lookup *sl,
>  	refcount_set(&sl->count, 1);
>  }
> =20
> +static const struct address_space_operations fuse_dax_aops =3D {
> +	.dirty_folio	=3D noop_dirty_folio,
> +};
> +

[Severity: High]
Is it intentional that this struct lacks read_folio and write_begin? If a
DAX-enabled inode is opened without passthrough (e.g., FOPEN_PASSTHROUGH is
missing) or direct I/O, normal non-passthrough reads might be routed to the
page cache. The VFS could then dereference mapping->a_ops->read_folio which
is NULL, potentially causing a kernel panic.

>  static void fuse_init_inode(struct inode *inode, struct fuse_attr *attr,
>  			    struct fuse_conn *fc)
>  {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001150935.6559=
79-1-mszeredi@redhat.com?part=3D5
