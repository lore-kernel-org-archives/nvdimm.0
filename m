Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B20DC54705C
	for <nvdimm@lists.linux.dev>; Sun, 11 Oct 2026 07:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791702578; cv=none; b=t/04So8/AkZ3+aB2y7fQf82uoquFE2uvoAXEMGAuEuwZROLIzFrakihEC2YxleRit97Jhz9wMIubt4Gr1AwSzv5uQPHiQQO8MUhX8r0CTsDW07ZmoSdRSsB27VT4rmQjdKdmjztAzObtR72mLa0+oy8CfjzkBi14jpugHSQQ6c0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791702578; c=relaxed/simple;
	bh=MWsjA+EVLS0GYEfsaHPA6ktCxdD0y1bKUh9XjKwJlxM=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=iU7ibYdNjMdgUlDvg+lXV91PRNvihl42ZjFtp/TBASDnzpRPVmR5p7aoSKd/1e9mCVnkLNO+872Up7HODc1pUhOzyVyaGjDoaZlKAjtSNFH5K70YQrxskNGiVxu6Y1R1KscYt+9Gchxo0oYCpKcjznPzIvWItN7B153PRqDdDpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KJYz2mKc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KJYz2mKc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E1F21F0089B;
	Sun, 11 Oct 2026 07:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791702577;
	bh=tKymKV+kBfA0RmAVVOU0KycdYaaNKSYxcczCUrYpFIk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KJYz2mKcqpCRnTaQEvZNntT96rw8DyTKkEvWMVg8S7Au3uwzIce4iWfuoJdPujpKb
	 bva04ZGc/6rEHgbfauRiXRH/U7lNhAzhDb1TLAPKQA3iB/gupoHRTl80CyZKtHYWDH
	 eL2nbq11FwISrdVSK0yHGzbyAy5D6v0MIIugZWb9NXpB74TOx+h0U5+E7omMCJWRvy
	 JimzvuayiB5cK1QQK7bp3E3Hg7H+7yNJl35H0k2TuMdjR2B9M+/fOQ6upC9SeCH1vy
	 q1Z+QWfpbV5wNa4DkMXtyJpRRDXvHbLS9n0s6FbNPjVzcv8CSzizMyZaeK9w294QdF
	 T1S4jyaUrF/Hg==
Message-ID: <sashiko-outbox-167100@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] dax: fix dax_range_compare_iter() to use correct
 size and address offset
Reply-To: sashiko-reviews@lists.linux.dev
To: jianyungao89@gmail.com
Cc: nvdimm@lists.linux.dev
In-Reply-To: <20261011064840.1296-1-jianyungao89@gmail.com>
References: <20261011064840.1296-1-jianyungao89@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 11 Oct 2026 07:09:36 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] fs/dax: memcmp on IOMAP_UNWRITTEN exposes uninitialized PMEM data =
via dedupe
- [High] fsdax: CPU soft lockup due to unbounded memcmp in dedupe
- [High] fs/dax: dax_dedupe_file_range_compare() drops error and returns fa=
lse dedup success
--

commit 035a3cbae242fa7d9d78dcd078b21ab3eeaecc67
Author: Jianyun Gao <jianyungao89@gmail.com>

dax: fix dax_range_compare_iter() to use correct size and address offset

This patch fixes two bugs in dax_range_compare_iter() when calling
dax_iomap_direct_access(). It corrects the size argument to use a length
rather than an absolute file offset, and it adds the page-in-page offset to
the source and destination addresses before comparing them with memcmp().

> diff --git a/fs/dax.c b/fs/dax.c
> index 08adeaed2baf1..7bee4314f905b 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -2190,6 +2190,7 @@ static int dax_range_compare_iter(struct iomap_iter=
 *it_src,
>  	const struct iomap *dmap =3D &it_dest->iomap;
>  	loff_t pos1 =3D it_src->pos, pos2 =3D it_dest->pos;
>  	void *saddr, *daddr;
> +	size_t size1, size2;
>  	int id, ret;
> =20
>  	len =3D min(len, min(smap->length, dmap->length));

[ ... ]

> @@ -2205,17 +2206,18 @@ static int dax_range_compare_iter(struct iomap_it=
er *it_src,
>  	}
> =20
>  	id =3D dax_read_lock();
> -	ret =3D dax_iomap_direct_access(smap, pos1, ALIGN(pos1 + len, PAGE_SIZE=
),
> -				      &saddr, NULL);
> +	size1 =3D ALIGN(len + offset_in_page(pos1), PAGE_SIZE);
> +	ret =3D dax_iomap_direct_access(smap, pos1, size1, &saddr, NULL);
>  	if (ret < 0)
>  		goto out_unlock;

[Severity: High]
If dax_iomap_direct_access() fails here (e.g., from an I/O error or a size
issue) and returns a negative error code, does the upstream caller
dax_dedupe_file_range_compare() incorrectly mask the failure and report fal=
se
success?

When this function returns a negative error code,
dax_dedupe_file_range_compare() handles it like this:

fs/dax.c:dax_dedupe_file_range_compare() {
    ...
		status =3D dax_range_compare_iter(&src_iter, &dst_iter,
				min(src_iter.len, dst_iter.len), same);
		if (status < 0)
			return ret;
    ...
}

Because ret holds a positive bytes count from the loop's earlier iomap_iter=
()
call, a positive value is propagated back to vfs_dedupe_file_range().=20

The VFS intercepts the positive return as a success flag, bypasses block
remapping, and reports a successful deduplication result to userspace even
though the remapping aborted early.

> =20
> -	ret =3D dax_iomap_direct_access(dmap, pos2, ALIGN(pos2 + len, PAGE_SIZE=
),
> -				      &daddr, NULL);
> +	size2 =3D ALIGN(len + offset_in_page(pos2), PAGE_SIZE);
> +	ret =3D dax_iomap_direct_access(dmap, pos2, size2, &daddr, NULL);
>  	if (ret < 0)
>  		goto out_unlock;
> =20
> -	*same =3D !memcmp(saddr, daddr, len);
> +	*same =3D !memcmp(saddr + offset_in_page(pos1),
> +			daddr + offset_in_page(pos2), len);

[Severity: High]
Does this code expose uninitialized PMEM data if the extent is
IOMAP_UNWRITTEN?

While dax_range_compare_iter() explicitly checks for and skips IOMAP_HOLE
earlier in the function, it fails to check for IOMAP_UNWRITTEN.

As a result, the physical PMEM blocks for unwritten extents (e.g., from
fallocate) are mapped by dax_iomap_direct_access() without zero-filling
them.

This memcmp() then directly compares this uninitialized data against the
target extent.

Since early-exit from memcmp() is measurable, could this be used as a
timing side-channel to extract previous persistent memory contents, as well
as causing functional deduplication failures when comparing logically-zero
unwritten extents?

[Severity: High]
Can this memcmp() cause a CPU soft lockup and RCU stall?

When called via the FIDEDUPERANGE ioctl, vfs_dedupe_file_range() can cap the
deduplication length to 1GB.

Because DAX/PMEM mappings can be contiguous for gigabytes, this length could
be passed directly to a single synchronous memcmp() call here without any
cond_resched() yielding points.

>  	if (!*same)
>  		len =3D 0;
>  	dax_read_unlock(id);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261011064840.1296=
-1-jianyungao89@gmail.com?part=3D1
