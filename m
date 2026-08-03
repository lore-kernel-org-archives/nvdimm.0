Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBAE9489863;
	Mon,  3 Aug 2026 02:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785724926; cv=none; b=FYnryPfguIP34f0K7KWwk/vfPZo/fnaKk/HjRQI/YJmFt3Q+5MYuS7Lr+TpSxpMhBrFAephGYC4pVEBPfnjn8qPUvuqjeL/xZvvRD6EhdBZZFrV4JsLYxke43nhNs1hIaWtaXwGBppgGE12dkbMxFBcgbluSWlhZX9chwW7ay70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785724926; c=relaxed/simple;
	bh=uTuevM6++2P/Jte5GLyPHU4O0ATR0QbutMXw9k6m3aU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=XO8eFUIJMRFJY9VTg1gN8OJqOR14TSlT49E/whT7lExdwbCL7ZV4jhPhQ1VGmJZqd5FwU0c0zTvFTzloOQs8MVl2w1Jj8QAAN2jD53vxhvDTuPSSETTz5qJJw1Q1SRv2sRnHB4oK6GiD1wn6W/egve6DFtkwkIvtpWXbuIGyUqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y2yPUS4q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y2yPUS4q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CFB71F000E9;
	Mon,  3 Aug 2026 02:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785724924;
	bh=89aNf19A0CAOk4Bc+QvFRcKxPgWvYJSbvj2eqLz+mhU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Y2yPUS4qofXgP6DgX52KIS8/+iVB283l+565Cbix3liNEwbXiqANZSmHXX2cDXb3T
	 Px+ZKwCkvdWmRX7RqGBzhH1yzuOxx8bKODn9mf3ga+ZbkDxtKtU49n0hmRMADyfiuG
	 NK4RCPHueh0wvikEJiGFdkiJ89l6zpHYSfkAVBRQi8+uA8EWPvT0vSzKrCbhl7NhOo
	 93gMxiEirbMFEKZU3WWng2hQZXGDte5HHxtOmJVJ7y4hICgpWKpQAereRyUcAoq/KK
	 QzDGWf1E9W3QqVQf7ZeTfBCP7cqTXKJtQSw3qhC4p+dSPRPni18haE0j9z8kuRQKaa
	 /sFJC0s6X5MGQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V12 10/12] famfs: Add runtime operation-permission
 (opts) framework
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Groves" <john@jagalactic.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <0100019fc574dabe-572d99fc-3bb0-421a-afec-05432de2a757-000000@email.amazonses.com>
References: <0100019fc572ca94-ec363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com>
 <20260803022950.75930-1-john@jagalactic.com>
 <0100019fc574dabe-572d99fc-3bb0-421a-afec-05432de2a757-000000@email.amazonses.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 03 Aug 2026 02:42:03 +0000
Message-Id: <20260803024204.3CFB71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] mprotect() can bypass FAMFS_OPT_WRITE restrictions because mmap on=
ly checks VM_WRITE.
- [High] rename() bypasses FAMFS_OPT_UNLINK and FAMFS_OPT_RMDIR restriction=
s for target files and directories.
--

--- Patch [10]: [PATCH V12 10/12] famfs: Add runtime operation-permission (=
opts) framework ---
commit e932914ca4460e6b742e80deb76ae5e6b7bac595
Author: John Groves <John@Groves.net>

famfs: Add runtime operation-permission (opts) framework

famfs denies most namespace, attribute and data operations by default
because the userspace log, not the kernel, is authoritative for a famfs
instance. Earlier commits already guard each such operation with a
famfs_opt_enabled(fsi, FAMFS_OPT_x) check backed by a permissive stub. This
commit defines the permission bitmap and makes those checks live.

> diff --git a/include/uapi/linux/famfs_ioctl.h b/include/uapi/linux/famfs_=
ioctl.h
> index 751d8b033c2ee..efe6ef2639759 100644
> --- a/include/uapi/linux/famfs_ioctl.h
> +++ b/include/uapi/linux/famfs_ioctl.h
> @@ -100,6 +100,48 @@ struct famfs_ioc_daxdev {
>  	__u32 flags;
>  };
> =20
> +/*
> + * Mount-wide operation permissions, queried and modified via the
> + * FAMFSIOC_{GET,SET,CLEAR}_OPTS ioctls. A set bit means the operation is
> + * permitted; a clear bit means it is rejected with -EPERM. famfs denies=
 most
> + * of these by default because the userspace log, not the kernel, is
> + * authoritative for a famfs instance.
> + */
> +#define FAMFS_OPT_CREATE	(1ULL << 0)  /* create a regular file        */
> +#define FAMFS_OPT_MKDIR		(1ULL << 1)  /* mkdir                        */
> +#define FAMFS_OPT_MKNOD		(1ULL << 2)  /* mknod a special file         */
> +#define FAMFS_OPT_SYMLINK	(1ULL << 3)  /* create a symlink             */
> +#define FAMFS_OPT_LINK		(1ULL << 4)  /* hard link                    */
> +#define FAMFS_OPT_UNLINK	(1ULL << 5)  /* unlink a mapped file         */
> +#define FAMFS_OPT_RMDIR		(1ULL << 6)  /* rmdir                        */
> +#define FAMFS_OPT_RENAME	(1ULL << 7)  /* rename                       */

[Severity: High]
Does this bypass the FAMFS_OPT_UNLINK and FAMFS_OPT_RMDIR policy restrictio=
ns
for target files and directories?

If FAMFS_OPT_RENAME is enabled but FAMFS_OPT_UNLINK is disabled, a user can
rename a file over an existing target mapped file.

In fs/famfs/famfs_inode.c:famfs_rename():

	if (!famfs_opt_enabled(fsi, FAMFS_OPT_RENAME))
		return -EPERM;

	return simple_rename(idmap, old_dir, old_dentry, new_dir, new_dentry,
			     flags);

This delegates to simple_rename(), which silently replaces the target by
calling simple_unlink() (or simple_rmdir()) on it. This directly drops the
inode link count and bypasses the filesystem's famfs_unlink() and
famfs_rmdir() hooks, completely avoiding the FAMFS_OPT_UNLINK check.

> +#define FAMFS_OPT_CHMOD		(1ULL << 8)  /* setattr ATTR_MODE            */
> +#define FAMFS_OPT_CHOWN		(1ULL << 9)  /* setattr ATTR_UID / ATTR_GID  */
> +#define FAMFS_OPT_TRUNCATE	(1ULL << 10) /* setattr ATTR_SIZE (resize)   =
*/
> +#define FAMFS_OPT_UTIMES	(1ULL << 11) /* setattr ATTR_ATIME/ATTR_MTIME*/
> +#define FAMFS_OPT_WRITE		(1ULL << 12) /* write file data              */

[Severity: High]
Does this allow mprotect() to bypass FAMFS_OPT_WRITE restrictions and obtai=
n a
writable memory mapping to a file when it should be read-only?

In fs/famfs/famfs_file.c:famfs_file_mmap():

	if ((vma->vm_flags & VM_SHARED) && (vma->vm_flags & VM_WRITE) &&
	    !famfs_opt_enabled(fsi, FAMFS_OPT_WRITE))
		return -EPERM;

The permission check only validates VM_WRITE. If a user calls mmap with
PROT_READ | MAP_SHARED, it sets VM_MAYWRITE but not VM_WRITE, bypassing the
FAMFS_OPT_WRITE check. The user could then call mprotect(PROT_WRITE) to
upgrade the mapping to writable without any filesystem callbacks.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/0100019fc572ca94-ec=
363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com?part=3D10
