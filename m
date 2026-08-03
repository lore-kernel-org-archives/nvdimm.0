Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1843B2F5A13;
	Mon,  3 Aug 2026 02:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785725087; cv=none; b=uImbk+beP86NZSbffTph+ujpTDYjQow+GpiVly1L6ELDFsH3sRbF07yzIkc0nz38X0zrl4VmE+FZCgz8BATTRbAQrdjGTy0pxaNF8WfOFZHL1r1nJ+8+9NDzs+TbrGLGThDHrwbJdlf0Ia3Fseu7jvypdzI+RuwPwL6908sKE8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785725087; c=relaxed/simple;
	bh=I9Vh24zeiceGYuh2eZ09ZnRO9kTqIc8ltRon+wKv5Lo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=PwxaeitQNNzKbG9KF6h+LN+o9ED1yEn+ua9+223/3prhYhwSVI9HimthudlwH/+1Cv+a3qPJYYjgdB1Cn7Ey652vmEcPRYQMEK/BTwN/0/bDXPpSc3ttWo8uyjoeYQlO7U4awjXfQMjgP1GjUi9yBxOQ70Qh0cQs8trEa40JZW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZKh0CZd1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZKh0CZd1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DC561F000E9;
	Mon,  3 Aug 2026 02:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785725085;
	bh=9CMbcCPc9eM/FaSXoPpytxXC+QE2HbXU5nW+AD8cW8E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZKh0CZd1BqT74vjAIfbbJkkMQn7sWEHGWDrOWqucmJ4Kd7Fmo4aoDqTTyO1JSPdZZ
	 9GSwjGK04ZxUHe7nURbsiZTOVM0FJ3mKIY6TDgRZmRAfCjSuQYP5bFdakuMoDRHZ/9
	 ekpqOGm/bNXo007D/cpZMniJt5rRlrpW7tIEvNjg/s/IqZRBYDsMZ7+xU95ChgRAQ1
	 7kzDm1zoKKwQ3QlPdrrLtm7w96yEREmwpzZJAN02dxihkIDEG9CzZMHx9WIN+sjxRx
	 xFXjJV9pZ0jSM+YalBFPfW1vfCQoaF/L9fI9lBEwjnl0uBC9SkL5jwO0KDZmURND19
	 F8Nn1u2u5RMhA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V12 08/12] famfs: iomap_begin and file-to-dax offset
 resolution
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Groves" <john@jagalactic.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <0100019fc5748c1e-45cb66a3-f847-4c3e-8a89-a04c89d24b32-000000@email.amazonses.com>
References: <0100019fc572ca94-ec363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com>
 <20260803022929.75893-1-john@jagalactic.com>
 <0100019fc5748c1e-45cb66a3-f847-4c3e-8a89-a04c89d24b32-000000@email.amazonses.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 03 Aug 2026 02:44:45 +0000
Message-Id: <20260803024445.7DC561F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 8 potential issue(=
s) to consider:

New issues:
- [Critical] Missing read memory barrier (`smp_rmb()`) in `famfs_daxdev_fro=
m_index` allows returning an uninitialized pointer, causing the DAX core to=
 use an uninitialized iomap structure.
- [Critical] The iomap_begin handlers mistakenly assign the input operation=
 `flags` to the output `iomap->flags`, unintentionally setting `IOMAP_F_NEW=
` during writes and causing data corruption.
- [High] The `len` parameter in `famfs_meta_to_dax_offset` and `famfs_meta_=
to_dax_offset_interleaved` is incorrectly typed as `off_t` instead of `loff=
_t`, causing integer truncation on 32-bit architectures.
- [High] In `famfs_meta_to_dax_offset_interleaved`, `iomap->length` is not =
bounded by the end of the interleaved extent, causing out-of-bounds physica=
l mappings.
- [High] Time-Of-Check to Time-Of-Use (TOCTOU) race condition in `famfs_met=
a_to_dax_offset` allows a NULL pointer dereference when evaluating `inode->=
i_private`.
- [Low] 64-bit integer division and modulo operations in `famfs_meta_to_dax=
_offset_interleaved` cause unresolved symbol errors during linking on 32-bi=
t architectures.

Pre-existing issues:
- [Critical] The `FAMFSIOC_MAP_CREATE` ioctl lacks privilege checks, allowi=
ng any user with write access to a file to map and access arbitrary physica=
l memory on any registered DAX device.
- [High] `famfs_dax_write_iter` bypasses standard VFS write checks, failing=
 to clear setuid/setgid bits and update file times upon modification.
--

--- Patch [8]: [PATCH V12 08/12] famfs: iomap_begin and file-to-dax offset =
resolution ---
commit b4e4f3f2df1ac1714b2f127455834eca42345a35
Author: John Groves <John@Groves.net>
Subject: famfs: iomap_begin and file-to-dax offset resolution

Add the iomap resolver that maps a file offset to a (daxdev, offset) pair:
famfs_meta_to_dax_offset() for simple extent lists and
famfs_meta_to_dax_offset_interleaved() for striped files, backed by the
per-daxdev health check (famfs_dax_err) and table lookup
(famfs_daxdev_for_index), plus famfs_iomap_begin() and famfs_iomap_ops.

> diff --git a/fs/famfs/famfs_file.c b/fs/famfs/famfs_file.c
> index d710c8a0c923c..e7f271ce6d03d 100644
> --- a/fs/famfs/famfs_file.c
> +++ b/fs/famfs/famfs_file.c
> @@ -320,6 +320,298 @@ famfs_file_ioctl(struct file *file, unsigned int cm=
d, unsigned long arg)
[ ... ]
> +static struct dax_device *
> +famfs_daxdev_from_index(struct famfs_fs_info *fsi, u64 dev_index, int *e=
rrp)
> +{
> +	struct famfs_dax_devlist *devlist =3D fsi->dax_devlist;
> +	struct famfs_daxdev *dd;
> +	int rc;
> +
> +	if (!devlist || dev_index >=3D devlist->nslots) {
> +		pr_debug("%s: dev_index %llu out of range\n",
> +			__func__, dev_index);
> +		*errp =3D -EIO;
> +		return NULL;
> +	}
> +	dd =3D &devlist->devlist[dev_index];
> +	rc =3D famfs_dax_err(dd);
> +	if (rc) {
> +		*errp =3D rc;
> +		return NULL;
> +	}
> +	*errp =3D 0;
> +	return dd->devp;
> +}

[Severity: Critical]
Does this code need a read memory barrier?

In famfs_daxdev_from_index(), dd->valid is read via famfs_dax_err(), and
then dd->devp is returned without an smp_rmb(). If a concurrent page fault
occurs while a DAX device is being installed via famfs_install_daxdev(),
CPU reordering could cause this to see valid =3D=3D 1 but return a NULL dev=
ice
pointer.

[ ... ]
> +static int
> +famfs_meta_to_dax_offset_interleaved(struct inode *inode, struct iomap *=
iomap,
> +			 loff_t file_offset, off_t len, unsigned int flags)

[Severity: High]
Can this cause integer truncation on 32-bit architectures?

The len parameter is typed as off_t (which is 32-bit signed on 32-bit
architectures) instead of loff_t. A large I/O request could result in a
negative value, which is then sign-extended back to a 64-bit value in
min_t(loff_t, len, ...), resulting in a massive iomap->length and causing
out-of-bounds mappings. Should this match the iomap_begin signature with
loff_t?

[ ... ]
> +		/* Is the data is in this striped extent? */
> +		if (local_offset < ext_size) {
> +			u64 chunk_num       =3D local_offset / chunk_size;
> +			u64 chunk_offset    =3D local_offset % chunk_size;
> +			u64 stripe_num      =3D chunk_num / nstrips;
> +			u64 strip_num       =3D chunk_num % nstrips;

[Severity: Low]
Could these 64-bit integer division and modulo operations cause unresolved
symbol errors during linking on 32-bit architectures?

The code uses standard / and % operators on 64-bit integers (local_offset,
chunk_size, chunk_num), which emits calls to __divdi3 and __umoddi3. Should
this use the kernel division helpers like div64_u64() or do_div()?

[ ... ]
> +			iomap->addr    =3D strip->ext_offset + strip_offset;
> +			iomap->offset  =3D file_offset;
> +			iomap->length  =3D min_t(loff_t, len, chunk_remainder);
> +			iomap->length  =3D min_t(loff_t, iomap->length,
> +					       strip->ext_len - strip_offset);

[Severity: High]
Does this properly bound the physical mapping length?

The calculation restricts iomap->length to chunk_remainder and the strip's
length, but fails to restrict it to ext_size - local_offset. If a read/write
operation happens near the end of an interleaved extent where ext_size is n=
ot
a perfect multiple of the chunk size, the returned length could physically
exceed the logical boundaries of the extent.

> +			iomap->dax_dev =3D daxdev;
> +			iomap->type    =3D IOMAP_MAPPED;
> +			iomap->flags   =3D flags;

[Severity: Critical]
Does assigning the input operational flags directly to the output mapping
flags overwrite valid data?

The flags argument to iomap_begin contains input flags (e.g., IOMAP_WRITE
which is 1 << 0). In the iomap output namespace, 1 << 0 is IOMAP_F_NEW.
Setting IOMAP_F_NEW tells the DAX core that the memory was newly allocated
and requires zeroing on partial writes, overwriting valid existing data with
zeroes.

[ ... ]
> +static int
> +famfs_meta_to_dax_offset(struct inode *inode, struct iomap *iomap,
> +			 loff_t file_offset, off_t len, unsigned int flags)

[Severity: High]
Can this cause integer truncation on 32-bit architectures?

The len parameter is typed as off_t (which is 32-bit signed on 32-bit
architectures) instead of loff_t. A large I/O request could result in a
negative value, which is then sign-extended back to a 64-bit value in
min_t(loff_t, len, ...), resulting in a massive iomap->length and causing
out-of-bounds mappings. Should this match the iomap_begin signature with
loff_t?

> +{
> +	struct famfs_fs_info  *fsi =3D inode->i_sb->s_fs_info;
> +	struct famfs_file_meta *meta =3D inode->i_private;
> +	loff_t local_offset =3D file_offset;
> +	int rc;
> +	int i;
> +
> +	if (fsi->deverror || famfs_file_invalid(inode))
> +		goto err_out;
> +
> +	if (meta->fm_extent_type =3D=3D FAMFS_IOC_EXT_INTERLEAVE)

[Severity: High]
Is there a Time-Of-Check to Time-Of-Use (TOCTOU) race condition here?

The local meta pointer is fetched from inode->i_private locklessly. It then
calls famfs_file_invalid(inode), which re-fetches inode->i_private. If
another thread initialized the file in between via FAMFSIOC_MAP_CREATE,
famfs_file_invalid() sees the new metadata and returns 0 (success). The fir=
st
thread then proceeds to dereference its locally cached meta pointer (which =
is
still NULL), crashing the kernel.

[ ... ]
> +		if (local_offset < dax_ext_len) {
> +			loff_t ext_len_remainder =3D dax_ext_len - local_offset;
> +			struct dax_device *daxdev;
> +
> +			daxdev =3D famfs_daxdev_from_index(fsi,
> +						meta->se[i].dev_index, &rc);
> +			if (!daxdev) {
> +				meta->error =3D true;
> +				return rc;
> +			}

[Severity: Critical]
Are we returning an uninitialized iomap structure here?

Because famfs_daxdev_from_index() returns a 0 error code when valid =3D=3D =
1,
famfs_meta_to_dax_offset() treats a NULL daxdev as a success (rc =3D 0) but
bails out early, returning 0 without initializing iomap->addr or
iomap->length. The DAX core would then operate on garbage physical addresse=
s.

[ ... ]
> +			iomap->addr    =3D dax_ext_offset + local_offset;
> +			iomap->offset  =3D file_offset;
> +			iomap->length  =3D min_t(loff_t, len, ext_len_remainder);
> +			iomap->dax_dev =3D daxdev;
> +			iomap->type    =3D IOMAP_MAPPED;
> +			iomap->flags   =3D flags;

[Severity: Critical]
Does assigning the input operational flags directly to the output mapping
flags overwrite valid data?

The flags argument to iomap_begin contains input flags (e.g., IOMAP_WRITE
which is 1 << 0). In the iomap output namespace, 1 << 0 is IOMAP_F_NEW.
Setting IOMAP_F_NEW tells the DAX core that the memory was newly allocated
and requires zeroing on partial writes, overwriting valid existing data with
zeroes.

[ ... ]
> @@ -501,7 +793,7 @@ famfs_dax_write_iter(struct kiocb *iocb, struct iov_i=
ter *from)
>  		return rc;
>  	}
> =20
> -	rc =3D dax_iomap_rw(iocb, from, NULL /*&famfs_iomap_ops*/);
> +	rc =3D dax_iomap_rw(iocb, from, &famfs_iomap_ops);
>  	inode_unlock(inode);
>  	return rc;
>  }

[Severity: High]
This is a pre-existing issue, but does famfs_dax_write_iter() bypass standa=
rd
VFS write checks?

It calls dax_iomap_rw() directly without invoking generic_write_checks() or
file_update_time(). This allows users to modify the contents of a setuid
binary without stripping the setuid bit, which is a classic privilege
escalation vector.


[Severity: Critical]
This is a pre-existing issue, but does FAMFSIOC_MAP_CREATE lack a privilege
check?

In famfs_file_init_dax() in fs/famfs/famfs_file.c:

	if (!famfs_opt_enabled(fsi, FAMFS_OPT_MAP_CREATE))
		return -EPERM;

Any unprivileged user with write access to a file could map and access
arbitrary physical memory on any registered DAX device. Should there be a
capable(CAP_SYS_ADMIN) or CAP_SYS_RAWIO check before parsing arbitrary phys=
ical
memory offsets? With the introduction of the iomap operations in this patch,
this allows the DAX core to perform I/O against unvalidated offsets.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/0100019fc572ca94-ec=
363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com?part=3D8
