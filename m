Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C266018871F;
	Mon, 20 Jul 2026 04:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784520255; cv=none; b=ogxGnq01xscaq6RlVAQKQ0QJOVYEfYc/+qNaVf7NYAiVkwxnmQwqG5UsaU1eqIdmmduBXdTm4EOxWlG/CTt2cc9JyHECn27pHlA5BZtvo1YvKSWUJrBvYsedBVH0pUn0JL2PlCGLfG0lg7btRH+kRdNKWfct7u1XX8L3/wUv93g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784520255; c=relaxed/simple;
	bh=aTdv4WFSDVCDU7SdtI2kduRvdbw24JzLqHEszbFv6mM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=fnSbPdz3isANg04fj/QzfHvkEmUEvOU832DlEj9muV8qSbYAlb7/0NqydqPRAYS/Oe0unvMtxFVSfFDws4FEexIy00h0pvt2iZLLZEYoCAjWlHqac3UfSxOuKs8K1moC8jodUrxCZDhhTFdYWG1UlF9+yrJkOZEdAAeK8Rpp9B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L/GcuwiD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L/GcuwiD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9B4F1F000E9;
	Mon, 20 Jul 2026 04:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784520253;
	bh=HPijJS//sFCDVvJG6O8u5zlCFoiXFZy9iA9TcGmc5Rs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=L/GcuwiD/7AxQWNCnYbNUIFBh5k9PQUnKG3mcThi1CpIFHMx5nbvJt3lVeno2g1Z4
	 R+/gWto77+/lUzgI5MZxfzJmyIrC/3aGR8tijOZd/RPB2pDmISGNLxR4gDilgEPpDG
	 2v30YU5qkyGiVE8JC7w5jA0XH9E5AfBuGd3gf5E9uq0Z3Wpucq6pVLvdXaJrlfDQWb
	 XpL2Q6s6fka9qOObvOWJaGkO8g/OD6nVZ/uegg70nSTkpUfOTzDIC4XfKA8Rcz84/h
	 kczaO5s4b0E+iHNqUVI+Tk+xTB4smwq8ZuWoQKM+9ACaID1h1mZHkrY+m6EFH4hrW8
	 925pMy29/zobQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V11 8/9] famfs_fuse: Add DAX address_space_operations
 with noop_dirty_folio
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Groves" <john@jagalactic.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <0100019f7da22a52-50f1e51d-e030-47e8-ad9d-cda5a2a47682-000000@email.amazonses.com>
References: <0100019f7d9fbe81-6cb16662-2522-47ea-a152-fab0ee3d9b35-000000@email.amazonses.com>
 <20260720034638.68877-1-john@jagalactic.com>
 <0100019f7da22a52-50f1e51d-e030-47e8-ad9d-cda5a2a47682-000000@email.amazonses.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 20 Jul 2026 04:04:12 +0000
Message-Id: <20260720040412.B9B4F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:
- [High] AB-BA self-deadlock on inode_lock(inode) in fuse_open() when openi=
ng a famfs file with O_TRUNC and writeback caching enabled.
- [High] Dynamic transition of an inode to DAX via S_DAX reassignment witho=
ut page cache invalidation violates DAX invariants.
- [High] Premature publication of fi->famfs_meta allows a concurrent open()=
 to return early and issue I/O before the inode's DAX state is initialized,=
 causing spurious -ENXIO or SIGBUS.
- [High] Unvalidated dev_index from untrusted FUSE server causes Undefined =
Behavior via BIT_ULL() shift.
- [Medium] famfs_dax_aops is missing the .direct_IO callback, which will ca=
use open() with O_DIRECT to fail with -EINVAL.
- [Medium] Data race on meta->error inside famfs_file_bad().
--

--- Patch [8]: [PATCH V11 8/9] famfs_fuse: Add DAX address_space_operations=
 with noop_dirty_folio ---
commit f34b116803453f431c8f566dd550b747920ca217
Author: John Groves <John@Groves.net>

famfs_fuse: Add DAX address_space_operations with noop_dirty_folio

This commit adds a DAX-specific address_space_operations struct for famfs
using noop_dirty_folio. Since famfs is memory-backed and has no writeback,
these operations are assigned to the inode during DAX initialization.

> diff --git a/fs/fuse/famfs.c b/fs/fuse/famfs.c
> index 8d13282e8949f..aea0bceef774f 100644
> --- a/fs/fuse/famfs.c
> +++ b/fs/fuse/famfs.c

[ ... ]

> +/*
> + * DAX address_space_operations for famfs.
> + * famfs doesn't need dirty tracking - writes go directly to
> + * memory with no writeback required.
> + */
> +static const struct address_space_operations famfs_dax_aops =3D {
> +	.dirty_folio	=3D noop_dirty_folio,
> +};

[Severity: Medium]
Is it intentional to omit the .direct_IO callback here?

If applications attempt to open a DAX or memory-backed file with O_DIRECT,
VFS do_dentry_open() checks f_mapping->a_ops->direct_IO. Since it is
missing, will this cause the open to fail with -EINVAL and break
expected API functionality?

Should this include a .direct_IO callback, such as noop_direct_IO?

>  /***********************************************************************=
******/
> =20
>  /*
> @@ -564,6 +574,7 @@ famfs_file_init_dax(
>  	if (famfs_meta_set(fi, meta) =3D=3D NULL) {

[Severity: High]
Does publishing the metadata here allow a concurrent open to return early
before the inode's DAX state is fully initialized?

If Thread A executes famfs_file_init_dax(), publishes fi->famfs_meta via
cmpxchg here, and is preempted before setting S_DAX, Thread B could
concurrently open the same file.

Thread B would locklessly see fi->famfs_meta !=3D NULL in fuse_get_fmap(),
return 0 immediately, and execute I/O before S_DAX is set. Would this
trigger the IS_DAX() checks in the I/O paths, resulting in spurious -ENXIO
errors or SIGBUS crashes for the application?

[Severity: High]
Can this lead to an AB-BA self-deadlock during truncation?

When opening a famfs file with O_TRUNC and writeback caching enabled,
fuse_open() evaluates is_wb_truncate to true and acquires the non-recursive
inode_lock(inode).

It then calls fuse_get_fmap(), which invokes famfs_file_init_dax().
In famfs_file_init_dax(), it unconditionally attempts to acquire
inode_lock(inode) again before we reach this point. Will this cause the
thread to self-deadlock?

>  		i_size_write(inode, meta->file_size);
>  		inode->i_flags |=3D S_DAX;

[Severity: High]
Does transitioning the inode to DAX mode here violate core DAX invariants if
the page cache is not invalidated?

If a file is opened with O_CREAT, it bypasses DAX initialization and writes
populate the standard page cache. If the file is subsequently reopened with=
out
O_CREAT, it routes to fuse_open() and famfs_file_init_dax(), dynamically
setting S_DAX here.

Since fuse_open() explicitly skips page cache invalidation for famfs files,
does this leave stale, dirty pages in the VFS page cache? Could this lead
to kernel crashes or data corruption upon subsequent accesses or writeback?

> +		inode->i_data.a_ops =3D &famfs_dax_aops;
>  	} else {
>  		pr_debug("%s: file already had metadata\n", __func__);
>  		__famfs_meta_free(meta);

I also have a couple of questions about related functions:

[Severity: High]
Does this code overflow when shifting with an untrusted index?

In famfs_fuse_meta_alloc(), the dev_index from the FUSE server is used
directly in a bitwise shift:

fs/fuse/famfs.c:famfs_fuse_meta_alloc() {
    ...
    /* Record bitmap of referenced daxdev indices */
    meta->dev_bitmap |=3D BIT_ULL(meta->se[i].dev_index);
    ...
}

If a malicious FUSE server returns an fmap_buf with a dev_index of 64 or
greater, this will shift a 64-bit integer by 64 or more before any bounds
validation occurs. Can this cause undefined behavior and trigger a kernel
panic in kernels compiled with UBSAN?

[Severity: Medium]
Is there a data race when updating the error state locklessly?

When multiple threads perform concurrent I/O, famfs_file_bad() can
detect an i_size mismatch and update the state:

fs/fuse/famfs.c:famfs_file_bad() {
    ...
    meta->error =3D true;
    ...
}

Since this is a concurrent read and write of the shared boolean variable
without proper synchronization, will this violate the memory model and
trigger KCSAN warnings?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/0100019f7d9fbe81-6c=
b16662-2522-47ea-a152-fab0ee3d9b35-000000@email.amazonses.com?part=3D8
