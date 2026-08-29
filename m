Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE29F175A74;
	Sat, 29 Aug 2026 17:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788024325; cv=none; b=swW6QqOScU7374b8X0wDGArTdYOKb4VvtTWggz7k7nZavNsB9PKGj018kIkTzX3kkOVf1y4MbsNm6q1YWPvlqC2eNTrkHCZKr7xnsFo3E+BNa8qHSPAlQ+/GGyloy6zfvPS/BE1pqIann3sUzv9oNZooviP0VnDE2YG4IuZjbAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788024325; c=relaxed/simple;
	bh=FSBbSvoH6ye9U4N7RZ/jfxl//U3gfzeGEgG1+rcsOhU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=C25T7p5oyWJoavZhvVfCdfG8+Q7Yo+VLKh8/fe9c+ufPEO4UnyiirUWeb7ZE1ja5tKYmJvkReIZQ3D4/GA+0WCSfkEvtS8M7gdgcIZgaVNyX6ISqmlxHwyrvUHrerZpjRxpIrsM70knVTOB/hEGL9FUyqv/p38gOCXA1eyHwRR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oJTCUkwj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oJTCUkwj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E0751F000E9;
	Sat, 29 Aug 2026 17:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788024323;
	bh=H6i3QZEbLkcbYiJZ3nwKYGKx5jqjuWo376cjhhLURSQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oJTCUkwj/eveR8BTSjuipa2VgZs2YgYilNPekLrq+L91sHTZoE3JfBcBJ/gYkn5tZ
	 XquosP927fSzM65rZkvvA9DmLuhkMg2gBXKrY+wuQYRO7W6ZgmMHCIpb3M1vtJ0v3/
	 vH6mLsHL7CTZt16O+7W0YiA+WxjfVZUWAxmL29v4APr2B1K1S4zG82JtL27x+2NWwb
	 oSI7UZTRHrxL2CtXQ76qmYyZ7ivfVHrC6Gbj6HKkTNAyzweY6Lb/hEW077081Xl/Fu
	 Kfp93TVhIY8R1qE5TvmIufVglVeOrlEh2ut0s7OFYYf7wSedG44pvxBr5ZKIy2C8ED
	 yIb+o3GHe6jag==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V14 05/12] famfs: Introduce file_operations read/write
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Groves" <john@jagalactic.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <010001a04e815fe0-2d476878-af01-41a0-81bc-7bd5a97c154b-000000@email.amazonses.com>
References: <010001a04e801a4e-8eb212cd-b263-4043-ab65-33e480d2d7d4-000000@email.amazonses.com>
 <20260829171125.7424-1-john@jagalactic.com>
 <010001a04e815fe0-2d476878-af01-41a0-81bc-7bd5a97c154b-000000@email.amazonses.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 29 Aug 2026 17:25:23 +0000
Message-Id: <20260829172523.9E0751F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:
- [High] Ignored return value of kiocb_modified() in famfs_dax_write_iter b=
ypasses security state updates.
- [High] Bypass of generic_write_checks() breaks O_APPEND semantics and inc=
orrectly returns 0 on EOF, causing infinite write loops.
- [High] 64-bit file size is truncated to 32-bit size_t, breaking I/O opera=
tions on files larger than 4GB on 32-bit platforms.
- [Medium] famfs_dax_read_iter() and famfs_dax_write_iter() ignore IOCB_NOW=
AIT and use blocking lock acquisitions.
- [Medium] Kernel pointer leak via pr_debug by intentionally bypassing poin=
ter hashing.
--

commit 31958b8d418a1061bd63bd9bed3ba0558707e229
Author: John Groves <john@groves.net>

    famfs: Introduce file_operations read/write

This commit introduces fs/famfs/famfs_file.c and the famfs
file_operations for read/write.

> diff --git a/fs/famfs/famfs_file.c b/fs/famfs/famfs_file.c
> new file mode 100644
> index 0000000000000..1369fe1824bc8
> --- /dev/null
> +++ b/fs/famfs/famfs_file.c
> @@ -0,0 +1,141 @@

[ ... ]

> +/* Reject I/O to files that aren't in a valid state */
> +static ssize_t
> +famfs_file_invalid(struct inode *inode)
> +{
> +	if (!IS_DAX(inode)) {
> +		pr_debug("%s: inode %llx IS_DAX is false\n",
> +			 __func__, (u64)inode);

[Severity: Medium]
Does this cast to u64 and %llx format specifier bypass the kernel's pointer
hashing mechanism, potentially leaking raw kernel memory addresses?

> +		return -ENXIO;
> +	}
> +	return 0;
> +}
> +
> +static ssize_t
> +famfs_rw_prep(struct kiocb *iocb, struct iov_iter *ubuf)
> +{
> +	struct inode *inode =3D iocb->ki_filp->f_mapping->host;
> +	struct super_block *sb =3D inode->i_sb;
> +	struct famfs_fs_info *fsi =3D sb->s_fs_info;
> +	size_t i_size =3D i_size_read(inode);

[Severity: High]
Does truncating the 64-bit loff_t returned by i_size_read() into a 32-bit
size_t variable break I/O operations for files larger than 4GB on 32-bit
platforms?

> +	size_t count =3D iov_iter_count(ubuf);
> +	size_t max_count;
> +	ssize_t rc;
> +
> +	if (fsi->deverror)
> +		return -ENODEV;
> +
> +	rc =3D famfs_file_invalid(inode);
> +	if (rc)
> +		return rc;
> +
> +	/* Avoid unsigned underflow if position is past EOF */
> +	if (iocb->ki_pos >=3D i_size)
> +		max_count =3D 0;
> +	else
> +		max_count =3D i_size - iocb->ki_pos;
> +
> +	if (count > max_count)
> +		iov_iter_truncate(ubuf, max_count);
> +
> +	if (!iov_iter_count(ubuf))
> +		return 0;

[Severity: High]
When a write hits the end of the file, this logic returns 0 instead of a
proper error code like -ENOSPC or -EFBIG.  Can this cause infinite write
loops in standard userspace tools?

> +
> +	return rc;
> +}
> +
> +static ssize_t
> +famfs_dax_read_iter(struct kiocb *iocb, struct iov_iter	*to)
> +{
> +	struct inode *inode =3D iocb->ki_filp->f_mapping->host;
> +	ssize_t rc;
> +
> +	/* dax_iomap_rw() requires i_rwsem held (shared for read) */
> +	inode_lock_shared(inode);

[Severity: Medium]
Does this unconditional blocking lock acquisition ignore the IOCB_NOWAIT
flag, potentially stalling asynchronous I/O frameworks like io_uring?

> +	rc =3D famfs_rw_prep(iocb, to);
> +	if (rc || !iov_iter_count(to)) {
> +		inode_unlock_shared(inode);
> +		return rc;
> +	}
> +
> +	rc =3D dax_iomap_rw(iocb, to, NULL /*&famfs_iomap_ops */);
> +	inode_unlock_shared(inode);
> +
> +	if (rc > 0)
> +		file_accessed(iocb->ki_filp);
> +	return rc;
> +}
> +
> +/**
> + * famfs_dax_write_iter()
> + *
> + * We need our own write-iter in order to prevent append
> + *
> + * @iocb:
> + * @from: iterator describing the user memory source for the write
> + */
> +static ssize_t
> +famfs_dax_write_iter(struct kiocb *iocb, struct iov_iter *from)
> +{
> +	struct inode *inode =3D iocb->ki_filp->f_mapping->host;
> +	struct famfs_fs_info *fsi =3D inode->i_sb->s_fs_info;
> +	ssize_t rc;
> +
> +	if (!famfs_opt_enabled(fsi, FAMFS_OPT_WRITE))
> +		return -EPERM;
> +
> +	/* dax_iomap_rw() requires i_rwsem held (exclusive for write) */
> +	inode_lock(inode);

[Severity: Medium]
Similar to famfs_dax_read_iter(), does this unconditional blocking lock
acquisition ignore the IOCB_NOWAIT flag, potentially stalling asynchronous
I/O frameworks?

> +	rc =3D famfs_rw_prep(iocb, from);

[Severity: High]
Does the bypass of generic_write_checks() here break O_APPEND semantics?
It appears iocb->ki_pos is not updated to EOF, causing the write to
overwrite existing data instead of appending.

> +	if (rc || !iov_iter_count(from)) {
> +		inode_unlock(inode);
> +		return rc;
> +	}
> +
> +	kiocb_modified(iocb); /* mtime/ctime + strip set[e]uid */

[Severity: High]
Does ignoring the return value of kiocb_modified() bypass error checking?
If stripping the setuid/setgid bit fails, could this allow a malicious
user to retain privileges on a file while modifying its contents?

> +
> +	rc =3D dax_iomap_rw(iocb, from, NULL /*&famfs_iomap_ops*/);
> +	inode_unlock(inode);
> +	return rc;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/010001a04e801a4e-8e=
b212cd-b263-4043-ab65-33e480d2d7d4-000000@email.amazonses.com?part=3D5
