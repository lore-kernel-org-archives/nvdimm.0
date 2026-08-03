Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A96EA489863;
	Mon,  3 Aug 2026 02:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785724948; cv=none; b=QMrGNXbDcTrMyD0H/+Qshy1JEUC2wXjTMfZszEw7v+YgFrcLNXimzVReAnqDq6yJFob1h5ICD48ZRiic4bN+FZsoLbHipRBC1ToMQcUmMIQ8WJMOWkvKnMqZlyShuZhcmt9n7OyyU7Pcn3ImD7s5PO89kcnD0cpFKTunY+9wY7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785724948; c=relaxed/simple;
	bh=/YlxFiDd7qje9I2Vve6riq0/H07cjyuMTrSrTUIacd8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=A8nQR3eEGciXveHUQ7Wka2FB55bDL4WMCyJLrn9XXTgwtNkivOkwOwQyKSPQmuFuTrtDP/tqV/vbDYCh/O2/L7GBdpWVt6IAx2LhE/pCtof1z9XHBc6tW1P8cYZlo76n5OXXG7gRkvxpdhjOhB8GUPtQBlBeRjVr9FhX+QnOtfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oR4uSUl5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oR4uSUl5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6339E1F000E9;
	Mon,  3 Aug 2026 02:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785724946;
	bh=yP2j+e2N2yPfdrd9FVEc3cKWa7u5ZTfbu9IfhWcNNBU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oR4uSUl5hcBaQFvLlt0D6om4f/7fJmSagPONyKZ79W0OZR0aEhXbxHmUfpFZvFsZG
	 BY6HikKtUco8FF/DB52Qp+FDiMuWgiM3xtU7FZC+q/erdIrVOjnx5Ean52XjJnL1jc
	 nmBt+JRNj16y515fDjRiOTRDLb3LQwfuwjbrdFtJxEx7oQv+aPXLWFQfg4UuV00z5l
	 M30RXcPWSu+hR6vlpZZabIAY4VWXaBJ8ED2jsWgKhw9nQR67ix0yLxnchc7ce24sPD
	 A7UeZl6qpTK3VB55bE9nysV3YV2GXrUOv76RXjmUE1hdxsxVeVRePQ2rdvzBbeIgHW
	 kCh2bSBpr3IeQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V12 07/12] famfs: MAP_CREATE ioctl and fmap ingest (ABI
 44)
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Groves" <john@jagalactic.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <0100019fc5746312-6cfe9a07-a658-4aba-b1e9-5233b0ddfcf4-000000@email.amazonses.com>
References: <0100019fc572ca94-ec363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com>
 <20260803022919.75875-1-john@jagalactic.com>
 <0100019fc5746312-6cfe9a07-a658-4aba-b1e9-5233b0ddfcf4-000000@email.amazonses.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 03 Aug 2026 02:42:26 +0000
Message-Id: <20260803024226.6339E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 7 potential issue(=
s) to consider:

New issues:
- [Critical] The FAMFSIOC_MAP_CREATE ioctl lacks a privilege check, allowin=
g unprivileged users to map arbitrary physical DAX memory.
- [High] 64-bit file size and extent lengths are silently truncated to size=
_t on 32-bit architectures.
- [High] Missing overflow checks on extent lengths and physical offsets.
- [High] Race condition in state publication leads to permanent file corrup=
tion (Denial of Service).
- [High] Persistent memory allocations for file metadata lack __GFP_ACCOUNT=
, bypassing memcg limits.
- [Low] Format string type mismatch for size_t arguments causes compiler wa=
rnings.

Pre-existing issues:
- [High] NULL pointer dereference in famfs_meta_to_dax_offset_interleaved.
--

--- Patch [7]: [PATCH V12 07/12] famfs: MAP_CREATE ioctl and fmap ingest (A=
BI 44) ---
commit 7c28fdf850baa1b17b165378da6b0515248fad98
Author: John Groves <John@Groves.net>

famfs: MAP_CREATE ioctl and fmap ingest (ABI 44)

This commit adds the famfs file ioctl handler, including the
FAMFSIOC_MAP_CREATE ioctl to ingest user-provided mapping extent messages.
It parses both simple and interleaved wire formats into a famfs_file_meta
structure that is published on the inode.

> diff --git a/fs/famfs/famfs_internal.h b/fs/famfs/famfs_internal.h
> --- a/fs/famfs/famfs_internal.h
> +++ b/fs/famfs/famfs_internal.h
> @@ -15,8 +15,52 @@
>  #include <linux/bits.h>
>  #include <linux/build_bug.h>
> =20
> +#include <linux/famfs_ioctl.h>
> +
>  extern const struct file_operations famfs_file_operations;
[ ... ]
> +struct famfs_file_meta {
> +	bool                   error;
> +	enum famfs_file_type   file_type;
> +	size_t                 file_size;

[Severity: High]
Will this type choice truncate the 64-bit file size to 32 bits on 32-bit
architectures? If fmh.file_size exceeds 4GB, the upper 32 bits will be
lost, which could silently corrupt the file size and allow validation
checks to be bypassed.

> +	enum famfs_ioc_ext_type fm_extent_type;
> +	u64                    dev_bitmap; /* referenced daxdev indices */
> +	union { /* This will make code a bit more readable */
> +		struct {
> +			size_t         fm_nextents;
> +			struct famfs_meta_simple_ext  *se;
> +		};
> +		struct {
> +			size_t         fm_niext;
> +			struct famfs_meta_interleaved_ext *ie;
> +		};
> +	};
> +};

> diff --git a/fs/famfs/famfs_file.c b/fs/famfs/famfs_file.c
> --- a/fs/famfs/famfs_file.c
> +++ b/fs/famfs/famfs_file.c
[ ... ]
> @@ -60,6 +81,250 @@
> +static int
> +famfs_file_init_dax(struct file *file, void __user *arg)
> +{
[ ... ]
> +	fmap_buf =3D kvmalloc(fmh.fmap_size, GFP_KERNEL);

[Severity: High]
Should these metadata allocations use the __GFP_ACCOUNT flag?
This allocation scales with user input. Without __GFP_ACCOUNT, an
unprivileged user mapping up to 4MB of metadata per file could bypass
memory cgroup limits and potentially trigger a host-wide out-of-memory
condition.

> +	if (!fmap_buf)
> +		return -ENOMEM;
> +
> +	if (copy_from_user(fmap_buf, arg, fmh.fmap_size)) {
> +		rc =3D -EFAULT;
> +		goto out;
> +	}
> +	next_offset =3D sizeof(fmh);	/* start of the extent list */
> +
> +	meta =3D kzalloc_obj(*meta, GFP_KERNEL);
> +	if (!meta) {
> +		rc =3D -ENOMEM;
> +		goto out;
> +	}
> +
> +	meta->error =3D false;
> +	meta->file_type =3D fmh.file_type;
> +	meta->file_size =3D fmh.file_size;
> +	meta->fm_extent_type =3D fmh.ext_type;
> +
> +	switch (fmh.ext_type) {
> +	case FAMFS_IOC_EXT_SIMPLE: {
> +		struct famfs_ioc_simple_ext *se_in =3D fmap_buf + next_offset;
[ ... ]
> +		for (i =3D 0; i < fmh.nextents; i++) {
> +			meta->se[i].dev_index  =3D se_in[i].se_devindex;
> +			meta->se[i].ext_offset =3D se_in[i].se_offset;
> +			meta->se[i].ext_len    =3D se_in[i].se_len;
> +
> +			if (meta->se[i].dev_index >=3D FAMFS_MAX_DAXDEVS) {
> +				rc =3D -EINVAL;
> +				goto out;
> +			}
> +			meta->dev_bitmap |=3D BIT_ULL(meta->se[i].dev_index);
> +			errs +=3D famfs_check_ext_alignment(&meta->se[i]);
> +			extent_total +=3D meta->se[i].ext_len;

[Severity: High]
Is there a potential integer overflow when accumulating extent_total here?
If the sum of ext_len wraps around, it might pass the extent_total check be=
low
even if the extents do not actually cover the file size. Could ext_offset +
ext_len also overflow U64_MAX and cause out-of-bounds physical memory
accesses when constructing the iomap?

> +		}
> +		break;
> +	}
[ ... ]
> +	/* Publish the famfs metadata on inode->i_private */
> +	inode_lock(inode);
> +	if (inode->i_private) {
> +		rc =3D -EEXIST; /* file already has famfs metadata */
> +	} else {
> +		inode->i_private =3D meta;
> +		i_size_write(inode, meta->file_size);

[Severity: High]
Could a concurrent reader observe the published metadata but a stale i_size?
Because inode->i_private is assigned before i_size_write(), a lockless
reader could call famfs_file_invalid() in the middle of this window. It
would see a size mismatch and incorrectly set meta->error =3D true, which
permanently marks the file as corrupted.

> +		inode->i_flags |=3D S_DAX;
> +		meta =3D NULL; /* owned by the inode now */
> +		rc =3D 0;
> +	}
> +	inode_unlock(inode);
> +
> +out:
> +	kvfree(fmap_buf);
> +	if (meta)
> +		famfs_meta_free(meta);
> +	return rc;
> +}
> +
> +/**
> + * famfs_file_ioctl() - Top-level famfs file ioctl handler
> + * @file: the file
> + * @cmd:  ioctl opcode
> + * @arg:  ioctl opcode argument (if any)
> + */
> +static long
> +famfs_file_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> +{
> +	struct inode *inode =3D file_inode(file);
> +	struct famfs_fs_info *fsi =3D inode->i_sb->s_fs_info;
> +	long rc;
> +
> +	if (fsi->deverror && (cmd !=3D FAMFSIOC_NOP))
> +		return -ENODEV;
> +
> +	switch (cmd) {
> +	case FAMFSIOC_NOP:
> +		rc =3D 0;
> +		break;
> +
> +	case FAMFSIOC_MAP_CREATE:
> +		rc =3D famfs_file_init_dax(file, (void __user *)arg);

[Severity: Critical]
Does this ioctl command require a privilege check like capable(CAP_SYS_ADMI=
N)?
Without it, it appears any unprivileged user who can open the file could map
arbitrary physical DAX memory directly into their processes.

> +		break;
> +
> +	default:
> +		rc =3D -ENOTTY;
> +		break;
> +	}
> +
> +	return rc;
> +}
[ ... ]
> @@ -93,9 +397,25 @@ const struct vm_operations_struct famfs_file_vm_ops =
=3D {
>  static ssize_t
>  famfs_file_invalid(struct inode *inode)
>  {
> +	struct famfs_file_meta *meta =3D inode->i_private;
> +	size_t i_size =3D i_size_read(inode);
> +
> +	if (!meta) {
> +		pr_debug("%s: un-initialized famfs file\n", __func__);
> +		return -EIO;
> +	}
> +	if (meta->error) {
> +		pr_debug("%s: previously detected metadata errors\n", __func__);
> +		return -EIO;
> +	}
> +	if (i_size !=3D meta->file_size) {
> +		pr_warn("%s: i_size overwritten from %ld to %ld\n",
> +		       __func__, meta->file_size, i_size);

[Severity: Low]
Should this format string use %zu instead of %ld for size_t variables?
This can cause compiler warnings and misformatted logs on 32-bit platforms.

> +		meta->error =3D true;
> +		return -ENXIO;
> +	}

[ ... ]

[Severity: High]
This is a pre-existing issue, but can famfs_meta_to_dax_offset_interleaved()
dereference a NULL pointer if called on an uninitialized file?

fs/famfs/famfs_file.c:famfs_meta_to_dax_offset_interleaved() {
    ...
    struct famfs_file_meta *meta =3D inode->i_private;
    ...
    if (meta->fm_extent_type !=3D FAMFS_IOC_EXT_INTERLEAVE) {
        pr_debug("%s: bad extent type\n", __func__);
        goto err_out;
    }

    if (fsi->deverror || famfs_file_invalid(inode))
        goto err_out;
    ...
}

The meta pointer is dereferenced to check fm_extent_type before the call to
famfs_file_invalid(), which is where the check for a NULL meta pointer
actually happens. If the file is uninitialized (inode->i_private is NULL),
this will cause a panic.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/0100019fc572ca94-ec=
363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com?part=3D7
