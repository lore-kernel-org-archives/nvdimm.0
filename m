Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 261F0218E91;
	Mon, 20 Jul 2026 04:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784520587; cv=none; b=A3gi7hNkHAY1S2PbxBaEp/Hgm4mWnRSdM0rB/iSifYcSZyozEi/a3Df+kTHL8JWYFDSQIt9ACDf/xbW0mwz2u4GPiItxZKXeMnrtKYlwz9ZgRKc2yM5NemfLgPAhu3onkWMxP+qVr0R6UhGNemsNBYoyqq4f113Fm354OTwDck0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784520587; c=relaxed/simple;
	bh=SLZCnrnZlyAZf57OqArkCQvUPkUjZPskLmCp2q5MeCY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=J7VnphUcGRdf/EFSLB5ANFo9IiNVkYn/5Z5gRf8cPSAUq+H2ohJukklIRtBrXf+zw8p89cc0DU3C8M/NASf7+14FV7z9fDUt6wDAwMROFFxpvNpeXc4/WN8i01VVmVfwAZXvc4wW5AiQ6jC5MTTNDLVsIIo6OsPYB6ahI7eJmoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GL4JY82s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GL4JY82s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 978FB1F000E9;
	Mon, 20 Jul 2026 04:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784520585;
	bh=g83tuhJMVHq5P3C+QjSOV83y2rf15U5oXi2F3mAkTVY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GL4JY82sNpfMMedMAc3MAZfdA6VcpJgj/ovxqCXPmjDX6h5SnojIUAClII7Fby7lM
	 3nNImMjwDzS7fNkPTK57gJHP1BG+v6vnYDb0TfDhUBpoTZrhwoJYRN8qK+tRY+Z60n
	 1Ll/i50LweHwz0SF6PmFuRNFaLA7KgjuXh5xmjEFZLgbhe/fDZpWVO2tKpWGyICmE4
	 VucT1Uegypz641DWWpeSCRpegd+23r/e8UqRIuwAS13nvRh/Ee7addKBrV4o203eYb
	 WcImGa51HBA5trxs8CYRdJhmoQ5WL+0U2XlPXxpFpPjTX9QT4RHgQ2lV0tl7/4W0Ar
	 GwU49b3DKWzKg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V11 9/9] famfs_fuse: Add documentation
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Groves" <john@jagalactic.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <0100019f7da26385-94d6fb3e-9702-47b4-bad1-9529eb7c4b5b-000000@email.amazonses.com>
References: <0100019f7d9fbe81-6cb16662-2522-47ea-a152-fab0ee3d9b35-000000@email.amazonses.com>
 <20260720034650.68894-1-john@jagalactic.com>
 <0100019f7da26385-94d6fb3e-9702-47b4-bad1-9529eb7c4b5b-000000@email.amazonses.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 20 Jul 2026 04:09:45 +0000
Message-Id: <20260720040945.978FB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] The DAX notify_failure callback dereferences a NULL or freed fuse_=
conn pointer due to a lack of synchronization with fs_put_dax().
- [Medium] Casting a u64 pointer to unsigned long * for for_each_set_bit() =
breaks on 32-bit big-endian architectures.
--

--- Patch [9]: [PATCH V11 9/9] famfs_fuse: Add documentation ---
commit ad461f8692da789ab34a9eaac4a65cb121d91c61
Author: John Groves <john@groves.net>

famfs_fuse: Add documentation

This patch series implements the famfs dax file system, which provides a
mechanism for multiple hosts to concurrently access data in shared memory v=
ia
a fuse interface. It adds memory error handling via dax_holder_operations,
plumbs dax iomap operations, and introduces the required fuse messages. This
commit specifically adds the documentation and MAINTAINERS entries.

> diff --git a/fs/fuse/famfs.c b/fs/fuse/famfs.c
> new file mode 100644
> index 0000000000000..aea0bceef774f
> --- /dev/null
> +++ b/fs/fuse/famfs.c
> @@ -0,0 +1,1066 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * famfs - dax file system for shared fabric-attached memory

[ ... ]

> +static int
> +famfs_dax_notify_failure(struct dax_device *dax_devp, u64 offset,
> +			u64 len, int mf_flags)
> +{
> +	struct fuse_conn *fc =3D dax_holder(dax_devp);
> +
> +	famfs_set_daxdev_err(fc, dax_devp);

[Severity: High]
Can this sequence cause a NULL pointer dereference or use-after-free?

If fs_put_dax() clears dax_dev->holder_data to NULL without waiting for SRCU
readers, and a concurrent memory failure notification runs
dax_holder_notify_failure(), dax_holder() could return NULL here.

Additionally, even if a valid pointer is read before it's cleared, couldn't
fuse_conn_put() free the fuse_conn via call_rcu() without waiting for the
SRCU grace period used by dax_holder_notify_failure()?

> +
> +	return 0;
> +}

[ ... ]

> +static int
> +famfs_check_daxdev_table(
> +	struct fuse_mount *fm,
> +	const struct famfs_file_meta *meta)
> +{
> +	struct fuse_conn *fc =3D fm->fc;
> +	int nmissing =3D 0;
> +	int err;
> +
> +	err =3D famfs_devlist_alloc(fc);
> +	if (err)
> +		return err;
> +
> +	/* Count missing daxdevs while holding the reader lock */
> +	scoped_guard(rwsem_read, &fc->famfs_devlist_sem) {
> +		unsigned long i;
> +
> +		for_each_set_bit(i, (unsigned long *)&meta->dev_bitmap,
> +				 MAX_DAXDEVS) {

[Severity: Medium]
Does this cast break on 32-bit big-endian architectures?

When casting a u64 pointer to an unsigned long pointer on these architectur=
es,
it points to the high 32 bits of the u64. Since MAX_DAXDEVS is 24, all valid
bits are stored in the low 32 bits.

Won't the loop scan the all-zero high 32 bits and completely skip the requi=
red
daxdev validation for the file?

> +			struct famfs_daxdev *dd =3D &fc->dax_devlist->devlist[i];
> +
> +			/*
> +			 * Skip daxdevs already installed (valid) or already
> +			 * known to be unusable (dax_err). Re-fetching either
> +			 * just thrashes on GET_DAXDEV and fs_dax_get().
> +			 */
> +			if (!dd->valid && !dd->dax_err)
> +				nmissing++;
> +		}
> +	}

[ ... ]

> +static void
> +famfs_set_daxdev_err(
> +	struct fuse_conn *fc,
> +	struct dax_device *dax_devp)
> +{
> +	int i;
> +
> +	/*
> +	 * Search the list by dax_devp under the write lock: we set dd->error,
> +	 * and it serializes against famfs_teardown() clearing the table.
> +	 */
> +	scoped_guard(rwsem_write, &fc->famfs_devlist_sem) {

[Severity: High]
Is a NULL check for fc needed here? As mentioned above, if fc is passed in =
as
NULL from famfs_dax_notify_failure(), this will immediately dereference it.

> +		if (!fc->dax_devlist)
> +			return;
> +		for (i =3D 0; i < fc->dax_devlist->nslots; i++) {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/0100019f7d9fbe81-6c=
b16662-2522-47ea-a152-fab0ee3d9b35-000000@email.amazonses.com?part=3D9
