Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC7C2F30;
	Sat, 29 Aug 2026 17:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788024304; cv=none; b=YRQWeGU9JSEKIMX9WwQ7KFlgxTcPC1BBZzxwnNLtfUzwcg1vc2kjzqMQfYwzTZ50jp51wH0RtK0UR57faVq20lhQV1sWiVaTvRW8LTkUD3SdyjwNy9+Zy8hrHyHPXvEe54v65guZHi+fSu1ZFszh4oRTrnlxNZhdzQDHc8f+i+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788024304; c=relaxed/simple;
	bh=u0jRTuLTk6twGIPYcYuinCTWU8+Xpg0GC8kBSax1XlA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=lNF6O3bADCz8XWlE5mWldAHqkxUy8LmpzDoBU0Vh1fHsqd3WbhMuJERX35cFcyJmcgIlvPDg3oLB8WCB/9wMHSZNBZ6aSg552qDbEp+thUzxmB8vyyroygjhpyVVE3FV2Kf/W0bG8zFT4UGGEdPdoDgWyHkyqjLuNm8yq8xpCJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VLbOj8Y6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VLbOj8Y6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE7001F000E9;
	Sat, 29 Aug 2026 17:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788024303;
	bh=bqvsoEiW5Xi2s/+apvOqlQSfjbHPuuW2+udssC+a+0I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VLbOj8Y60M+kHQ6cDLzZCcyErFJHtzrrhGkorDWZty2WrfiBnngmW7hWch40KhLHu
	 RdA5HwqLGC/AUxHln4L3DoOsfzdCVPC4s6LZXFZ/qm6hRhCz3ICOsrlSXVONVJGCA+
	 eKcAzCPiRlY5Bf/6/s2GLrXufEociJpsQmOfzCYaJjmnKM2ojhunPfKxvytOsS+O/E
	 2XG5Y6Ve3sVAqjJozWvXSeiY/UPnRq6SBgGVR9g31JCYGJsRfvQwIgznlNafhJjx+I
	 bpKP7UIYevGXfwmgmQMoian5MhAi1RhbAIT0InVkIx08ay+l7uRJZdlYKxXGWJYh4e
	 GYOcfJ8kFiEEA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V14 09/12] famfs: Register secondary daxdevs by path
 (FAMFSIOC_DAXDEV_OPEN)
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Groves" <john@jagalactic.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <010001a04e828e72-7dd35d21-e02a-4233-b208-bb38a68e0356-000000@email.amazonses.com>
References: <010001a04e801a4e-8eb212cd-b263-4043-ab65-33e480d2d7d4-000000@email.amazonses.com>
 <20260829171247.7497-1-john@jagalactic.com>
 <010001a04e828e72-7dd35d21-e02a-4233-b208-bb38a68e0356-000000@email.amazonses.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 29 Aug 2026 17:25:02 +0000
Message-Id: <20260829172502.EE7001F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Lockless read of daxdev->valid lacks a read memory barrier, leadin=
g to a TOCTOU race that can yield a NULL pointer and a zero error code.
--

commit 592a1b20aa272f01a78424966dd5d63af6c63cf8
Author: John Groves <John@Groves.net>

famfs: Register secondary daxdevs by path (FAMFSIOC_DAXDEV_OPEN)

Famfs file maps (fmaps) may reference multiple daxdevs. Before passing
an fmap that references a new daxdev, the daxdev is pushed into the
kernel via FAMFSIOC_DAXDEV_OPEN). This adds daxdevs to daxdev_table for
index-based resolution from famfs extents to daxdevs.

> kernel via FAMFSIOC_DAXDEV_OPEN). This adds daxdevs to daxdev_table for

This isn't a bug, but there is an unmatched closing parenthesis after
FAMFSIOC_DAXDEV_OPEN.

> diff --git a/fs/famfs/famfs_file.c b/fs/famfs/famfs_file.c
> index 2200f168aa79d..eba80dab0562d 100644
> --- a/fs/famfs/famfs_file.c
> +++ b/fs/famfs/famfs_file.c
[ ... ]
> +static int
> +famfs_daxdev_open(struct file *file, void __user *arg)
> +{
[ ... ]
> +	/*
> +	 * The daxdev table is allocated at mount time (for the slot-0 primary),
> +	 * so it is always present here; no need to allocate it.
> +	 */
> +	rc =3D famfs_install_daxdev(fsi, sb, dd.daxdev_index, devno, path);

[Severity: High]
Does exposing famfs_install_daxdev() to concurrent execution via this ioctl
trigger a race condition in the lockless readers?

famfs_install_daxdev() uses wmb() to ensure daxdev->devp is visible before
setting daxdev->valid =3D 1:

fs/famfs/famfs_inode.c:famfs_install_daxdev() {
    ...
    wmb(); /* All other fields must be visible before valid */
    daxdev->valid =3D 1;
    ...
}

However, the readers famfs_dax_err() and famfs_daxdev_from_index() lack a
pairing smp_rmb():

fs/famfs/famfs_file.c:famfs_dax_err() {
    if (!dd->valid) {
        pr_debug("%s: daxdev=3D%s invalid\n", __func__, dd->name);
        return -EIO;
    }
    ...
}

fs/famfs/famfs_file.c:famfs_daxdev_from_index() {
    ...
    rc =3D famfs_dax_err(dd);
    if (rc) {
        *errp =3D rc;
        return NULL;
    }
    *errp =3D 0;
    return dd->devp;
}

Could the CPU or compiler reorder the loads, reading a stale NULL for devp
before reading valid =3D=3D 1, resulting in famfs_daxdev_from_index() retur=
ning
NULL with a success error code (0)?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/010001a04e801a4e-8e=
b212cd-b263-4043-ab65-33e480d2d7d4-000000@email.amazonses.com?part=3D9
