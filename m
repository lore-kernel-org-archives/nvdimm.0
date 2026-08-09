Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A912437A840
	for <nvdimm@lists.linux.dev>; Sun,  9 Aug 2026 18:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786301094; cv=none; b=P4BspnB47+AQmwkLNlbBjzdwz4zt2Me7JXIT1jHWrdVSjcPtTUFa4wykBDAEPUtmSEWiikD+AedIybYkzuE31VAF37BuBN74YfUqcJsNSS7EtgxCJx4Yt662Hq4h9DJh+VE+XF9hZuot1Ij8ZeznVxVFqQNcZcjv+U9b1l3uMBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786301094; c=relaxed/simple;
	bh=BNaF1FxrfVE5DgErd6x3hDq1Tb4LvSvGwRlscJ8SaLo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=F27+NsgrZC6O2vug6I3HGRRPC5WsCj/SFfjmznJ0a80UboYardvd+Ozr19CtR71amZlWgemfImBtxBYnKzeI+t6uZRV07+dRFJUc4GGtuI9dr7uu5STc45rCVfwpCNgPGzqvyr58o6N/fZBSBRGTFBiw6QN/b1DE/M2qNJvQWmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eKZA6PHl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eKZA6PHl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14B9B1F00A3A;
	Sun,  9 Aug 2026 18:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786301093;
	bh=f2Ph6cWE1E2ebXrfPD+OQ4qq/lXHkSSgmsZrnriYdvU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eKZA6PHlcxnXCYXD7WRjCZhiH8D3t0oWtqA3RmJujmRAJa1avfvDr71jbzy109qjN
	 p+d0UsU7tMDA2KeGnZq2Cv5Ql8JdSf77ufhYCN/kgaUlL148Id2ZBYM+XnuJEF//tF
	 bkp+/YRGW2QQjwuLY2rRCjaz4nw72Z/YXKb2K6jqDmyNcTVLu5IU2rFKm/tN2Zq6Jm
	 D4ZMGLBydolXmGSV6f9/jO2/jb0pSrSXtzdcUiNY4MAUgc5Un2/a4tbvI0n5wNwrSi
	 ncRRmY3uxY/zAn3tgxEhBIOb3p67n9sPVzorNWhFy4g8NczMfpkOtxDuVHHHt6w40J
	 iLEvs+ID3kfCg==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 11/12] virtio: expose device memory buffer occupancy
 over debugfs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexander Graf" <graf@amazon.com>
Cc: dri-devel@lists.freedesktop.org, nvdimm@lists.linux.dev
In-Reply-To: <20260809182010.32931-12-graf@amazon.com>
References: <20260809182010.32931-1-graf@amazon.com>
 <20260809182010.32931-12-graf@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 09 Aug 2026 18:44:52 +0000
Message-Id: <20260809184453.14B9B1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] `virtio_dmb_hiwater_set` contains a TOCTOU race with `virtio_dmb=
_inc_used` that can cause the high-water mark to be permanently set lower t=
han the current total usage.
--

--- Patch [11]: [RFC PATCH 11/12] virtio: expose device memory buffer occup=
ancy over debugfs ---
commit 821ee4cbeac917d62e62a95c88f58236d2f6db9c
Author: Alexander Graf <graf@amazon.com>

virtio: expose device memory buffer occupancy over debugfs

This commit adds debugfs files to expose the memory occupancy of virtio
device memory buffers when CONFIG_VIRTIO_DEBUG is enabled. It introduces
counters for total allocated pages, allocation failures, and a high-water
mark to track peak usage.

> diff --git a/drivers/virtio/virtio_dmb.c b/drivers/virtio/virtio_dmb.c
> index 42126f928bc06..fe556d585f244 100644
> --- a/drivers/virtio/virtio_dmb.c
> +++ b/drivers/virtio/virtio_dmb.c

[ ... ]

> +static int virtio_dmb_hiwater_set(void *data, u64 val)
> +{
> +	struct virtio_dmb *dmb =3D data;
> +
> +	/* Restarting the measurement is the only meaningful write. */
> +	if (val)
> +		return -EINVAL;
> +
> +	/*
> +	 * Restart from what is allocated now rather than from zero, so that
> +	 * the file never reports a peak below the occupancy it is read
> +	 * alongside.
> +	 */
> +	atomic_long_set(&dmb->used_hiwater,
> +			atomic_long_read(&dmb->total_used));

[Severity: Medium]
Can this sequence result in the high-water mark being set lower than the
current total usage due to a race condition?

If a write to the debugfs used_pages_hiwater file occurs concurrently with
new allocations, could we see the following sequence:

Thread A reads total_used (e.g., 10) in virtio_dmb_hiwater_set().

Thread B allocates memory in virtio_dmb_inc_used(), increasing both
total_used and used_hiwater (e.g., to 110).

Thread A then blindly overwrites used_hiwater with the stale value (10)
using atomic_long_set().

This seems to contradict the comment above it, leaving used_hiwater
substantially lower than total_used. Is there a way to safely read and
update this to avoid a time-of-check to time-of-use race?

> +
> +	return 0;
> +}
> +DEFINE_DEBUGFS_ATTRIBUTE(virtio_dmb_hiwater_fops, virtio_dmb_hiwater_get,
> +			 virtio_dmb_hiwater_set, "%llu\n");

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260809182010.3293=
1-1-graf@amazon.com?part=3D11
