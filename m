Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76BF112E1DC;
	Mon,  3 Aug 2026 02:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785724926; cv=none; b=TG0kz4DdvZ4LkAh4EtZQG36G9LXyYCHEsQ7FRtG+LX1kSfzOMspCDtkGygqcKLHjtSQyh3df1ciliLH5A/beliEBFvT9jH1wNMYU34QzDHu0ZO7Dpy5/jDUtD7Y6oxKJuDpkMxbo+Ttwux2xEF7yhYZnbs3/8NXSbiNUpUmIR9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785724926; c=relaxed/simple;
	bh=1THDRIIQUFybOImh78Zwi9kQ2XmthJ5ZXFzftXNShLc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ftL4gCPiiiNHz5o5KyoZ/bzqoUHaDLfr1Hxe07qojtGYeEVkZNj27XKcf9EEFLmxXkDcFsWH+GcF7DbBg67toeKKd9h06j7iAf/K0nFHkKYO2CkKjWClfPB0a/f6IkY+hpm8h9K+L9eujnI08yfhtR2hiCzBRYS7JBj5DaeqMck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JEUU+Zzl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JEUU+Zzl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E95411F00A3A;
	Mon,  3 Aug 2026 02:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785724925;
	bh=KvIG2iF+Sq/dUxNZJE4F2nk0QFyuSoWy5UnUbKRbMts=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JEUU+Zzl32jHu4ChtV4YNEed2hGs8fWmE+4+OEl1XlNaArgavmG8GGiygnYR1zLQB
	 lM0ZP8hHjoIGEgv0dAUZcp/OTJh3B51w++jUbcGjw7XMWXSf7VBd9pqN229H+qgETG
	 3jLvBt/t3p8Q1vTT4AeD0fGBOBvtnXSQbBU0QwwE/IFsei76xPRr0wmPrhei79SD5G
	 zsOvAZRo6blJjFODDPZJNDgJxCI+SFO5AT+eoIfmeIpOxgeNKlnNqdIt8Fy92zORhJ
	 qLHbpRa5DtKQgJLJ279mrfHr/4XmZufpf3+jWrWQHcD4D6V1ST7AH/Vzwarovz/S5u
	 JJKnMvNDQJhZA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V12 09/12] famfs: Register secondary daxdevs by path
 (FAMFSIOC_DAXDEV_OPEN)
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Groves" <john@jagalactic.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <0100019fc574b43d-effbc86f-dd35-4154-8c2e-17699ef0edb6-000000@email.amazonses.com>
References: <0100019fc572ca94-ec363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com>
 <20260803022940.75910-1-john@jagalactic.com>
 <0100019fc574b43d-effbc86f-dd35-4154-8c2e-17699ef0edb6-000000@email.amazonses.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 03 Aug 2026 02:42:04 +0000
Message-Id: <20260803024204.E95411F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Mixing goto-based cleanup with scope-based cleanup helpers in the s=
ame function.
--

--- Patch [9]: [PATCH V12 09/12] famfs: Register secondary daxdevs by path =
(FAMFSIOC_DAXDEV_OPEN) ---
commit 92fac6008c0bb8bb7ad31e3ae10289f93997e74b
Author: John Groves <John@Groves.net>

famfs: Register secondary daxdevs by path (FAMFSIOC_DAXDEV_OPEN)

This commit introduces the FAMFSIOC_DAXDEV_OPEN ioctl to register devdax
devices by path into the famfs mount's daxdev table. This allows files with
extents referencing these secondary devices to be mapped.

> diff --git a/fs/famfs/famfs_file.c b/fs/famfs/famfs_file.c
> --- a/fs/famfs/famfs_file.c
> +++ b/fs/famfs/famfs_file.c

[ ... ]

> +static int
> +famfs_daxdev_open(struct file *file, void __user *arg)
> +{

[ ... ]

> +	scoped_guard(rwsem_read, &fsi->devlist_sem) {
> +		if (dd.daxdev_index >=3D fsi->dax_devlist->nslots)
> +			return -EINVAL;
> +		if (fsi->dax_devlist->devlist[dd.daxdev_index].valid)
> +			return 0;
> +	}
> +
> +	if (dd.daxdev_path_len =3D=3D 0 || dd.daxdev_path_len >=3D PATH_MAX)
> +		return -EINVAL;
> +
> +	/* +1 so the terminating NUL is included within the bound */
> +	path =3D strndup_user((const char __user *)(uintptr_t)dd.daxdev_path,
> +			    dd.daxdev_path_len + 1);
> +	if (IS_ERR(path))
> +		return PTR_ERR(path);
> +
> +	rc =3D lookup_daxdev(path, &devno);
> +	if (rc)
> +		goto out;

[Severity: Low]
Does famfs_daxdev_open() mix goto-based cleanup with scope-based cleanup
helpers?

This function uses scoped_guard() earlier, but relies on a traditional goto
out label for manual memory cleanup of the path variable. The cleanup
subsystem guidelines recommend against mixing goto-based error handling and
scope-based cleanup in the same function to avoid confusing ownership
semantics.

Could path be declared with the __free() helper to eliminate the need for t=
he
goto label entirely?

> +
> +	/*
> +	 * The daxdev table is allocated at mount time (for the slot-0 primary),
> +	 * so it is always present here; no need to allocate it.
> +	 */
> +	rc =3D famfs_install_daxdev(fsi, sb, dd.daxdev_index, devno, path);
> +	if (rc)
> +		pr_debug("%s: failed to install daxdev index %llu (%s)\n",
> +		       __func__, dd.daxdev_index, path);
> +out:
> +	kfree(path);
> +	return rc;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/0100019fc572ca94-ec=
363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com?part=3D9
