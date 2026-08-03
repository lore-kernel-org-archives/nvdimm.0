Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 153122931F9;
	Mon,  3 Aug 2026 02:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785725355; cv=none; b=oJv+WH0Df+OApxpy60pfO/W9qz744wLoIR1eZdXFg6bEov3vrdjGQDHBBwdXirheWhHj2hINWS/UY3VTFhXZ+CZh4x706aQqSbiMTu0afh5pg5S3JrvyEDNuJ69RCvHUlFl79g8A9D+5QQRqfL7gE7Do8hz4In/DabcnrCacmfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785725355; c=relaxed/simple;
	bh=r0v0eDWwOU0IwiLnYX7C4dZn0nFgzqvz2KCA6u/ihaU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=E+QOCqLQ8SpLfC75IO89dTV8FplHn01LnwBRu0n8Fmrtm8UtIjDtqvq98677bInujy/L4B5jkUa5ANViof6j1mawg97L8fN+ogaUnz3HjB5yB6V+QUn8SS1LWwRbmr4TEQEw0zlfK9kJr8rGmz0tRSLMgclu0Z1xz//qOyRVwjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Shj0oLIP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Shj0oLIP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FE8A1F000E9;
	Mon,  3 Aug 2026 02:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785725353;
	bh=CxH+YvIiyNZ0Z6AxD1nrll69RItE17aa+Dx/ZOQzsfw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Shj0oLIPb5NSE/eyk1jikRPj5mtj+zXmz/AwxMYtY0fjuVLr0UvgYUeCt+62c2u69
	 WAqsWyNm7L60rbKqzJ5m/VBpsGg31NTB2QWKsPBwhSzSjDsEwaHRfahpJRefCj6iJa
	 ywOl9RQL1Zbk//iKVRk+jUKlntjY9qEuThskPi+Zh/dliUus9AMW/56F8SGCo/PSOQ
	 NrEghQGiT+0XazLUEgkArAoaCiCZSlTVK9/ihjPUCXRZqtoK7gOKI9nm+a8+oyul/T
	 HKQderan1zGkr6mr5WR7VOY+7LqreWqtTO5W2n3kvAfejsQJP6yrSkZo9HeaGoOW8q
	 KbZE9DqW4CSeg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V12 02/12] famfs: Module operations, fs_context, and
 mount
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Groves" <john@jagalactic.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <0100019fc5739e5d-bc002300-eede-4c40-9ca8-a277b754496e-000000@email.amazonses.com>
References: <0100019fc572ca94-ec363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com>
 <20260803022828.75776-1-john@jagalactic.com>
 <0100019fc5739e5d-bc002300-eede-4c40-9ca8-a277b754496e-000000@email.amazonses.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 03 Aug 2026 02:49:13 +0000
Message-Id: <20260803024913.6FE8A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:
- [High] Missing `.owner =3D THIS_MODULE` in `famfs_fs_type`.
- [High] Missing DAX device validation and reference counting risks Use-Aft=
er-Free and TOCTOU races.
- [Medium] Silent ignoring of unrecognized and invalid mount parameters in =
`famfs_parse_param()`.
- [Medium] Bypassing MAC and DAC permission checks on the character device =
node during mount.
- [Low] Global symbol `lookup_daxdev` lacks a subsystem prefix.
--

--- Patch [2]: [PATCH V12 02/12] famfs: Module operations, fs_context, and =
mount ---
commit fdda77a79254c638517e00787a7301ff9eaab82f
Author: John Groves <john@groves.net>

famfs: Module operations, fs_context, and mount

Start building up from the famfs module operations. Register as a file
system, parse mount parameters, allocate superblock via famfs_get_tree(),
and lookup the host dax device.

> diff --git a/fs/famfs/famfs_inode.c b/fs/famfs/famfs_inode.c
> new file mode 100644
> index 0000000000000..c299a90912a5c
> --- /dev/null
> +++ b/fs/famfs/famfs_inode.c

[ ... ]

> +static void
> +famfs_fill_super(struct super_block *sb, struct fs_context *fc)
> +{
> +	sb->s_maxbytes		=3D MAX_LFS_FILESIZE;
> +	sb->s_blocksize		=3D PAGE_SIZE;
> +	sb->s_blocksize_bits	=3D PAGE_SHIFT;
> +	sb->s_magic		=3D FAMFS_SUPER_MAGIC;
> +	sb->s_op		=3D NULL /* famfs_super_ops */;
> +	sb->s_time_gran		=3D 1;
> +}
> +
> +int
> +lookup_daxdev(const char *pathname, dev_t *devno)

[Severity: Low]
Should this globally visible function have a subsystem-specific prefix like
famfs_lookup_daxdev to avoid polluting the global namespace?

> +{
> +	struct inode *inode;
> +	struct path path;
> +	int err;
> +
> +	if (!pathname || !*pathname)
> +		return -EINVAL;
> +
> +	err =3D kern_path(pathname, LOOKUP_FOLLOW, &path);
> +	if (err)
> +		return err;
> +
> +	inode =3D d_backing_inode(path.dentry);
> +	if (!S_ISCHR(inode->i_mode)) {
> +		err =3D -EINVAL;
> +		goto out_path_put;
> +	}
> +
> +	if (!may_open_dev(&path)) {
> +		err =3D -EACCES;
> +		goto out_path_put;
> +	}

[Severity: Medium]
Does this bypass MAC and DAC permission checks on the character device node?

By only resolving the path with kern_path() and checking may_open_dev(),
the code skips the actual file open operation. Would this allow a user with
mount capabilities to bypass security policies that restrict access to the
underlying device?

> +
> +	/* i_rdev is the char dev_t; fs_dax_get() confirms it is dax later */
> +	*devno =3D inode->i_rdev;

[Severity: High]
Is the underlying DAX device structure pinned to prevent it from being free=
d?

The comment mentions fs_dax_get() will confirm it is DAX later, but it
doesn't appear to be called anywhere in the codebase to acquire the
device. Could this allow the backing driver to be unloaded or hot-unplugged
while the filesystem is mounted, resulting in a use-after-free on
subsequent access?

> +
> +out_path_put:
> +	path_put(&path);
> +	return err;
> +}

[ ... ]

> +static int famfs_parse_param(struct fs_context *fc, struct fs_parameter =
*param)
> +{
> +	struct famfs_fs_info *fsi =3D fc->s_fs_info;
> +	struct fs_parse_result result;
> +	int opt;
> +
> +	opt =3D fs_parse(fc, famfs_fs_parameters, param, &result);
> +	if (opt =3D=3D -ENOPARAM) {
> +		opt =3D vfs_parse_fs_param_source(fc, param);
> +		if (opt !=3D -ENOPARAM)
> +			return opt;
> +
> +		return 0;
> +	}

[Severity: Medium]
Does returning 0 here silently ignore unrecognized mount parameters?

The VFS layer relies on fs_parse() returning -ENOPARAM to indicate an
unhandled parameter so it can alert the user. Does catching the error and
returning 0 hide misconfigurations from userspace?

> +	if (opt < 0)
> +		return opt;
> +
> +	switch (opt) {
> +	case Opt_mode:
> +		fsi->mount_opts.mode =3D result.uint_32 & S_IALLUGO;
> +		break;
> +	case Opt_dax:
> +		if (strcmp(param->string, "always"))
> +			pr_debug("%s: invalid dax mode %s\n",
> +				  __func__, param->string);
> +		break;

[Severity: Medium]
Should this return an error code instead of breaking and eventually
returning 0 when an invalid DAX mode is provided?

> +	}
> +
> +	return 0;
> +}

[ ... ]

> +static void famfs_kill_sb(struct super_block *sb)
> +{
> +	struct famfs_fs_info *fsi =3D sb->s_fs_info;
> +
> +	kill_char_super(sb);
> +
> +	kfree(fsi);
> +	sb->s_fs_info =3D NULL;
> +}
> +
> +#define MODULE_NAME "famfs"
> +static struct file_system_type famfs_fs_type =3D {
> +	.name		  =3D MODULE_NAME,
> +	.init_fs_context  =3D famfs_init_fs_context,
> +	.parameters	  =3D famfs_fs_parameters,
> +	.kill_sb	  =3D famfs_kill_sb,
> +	.fs_flags	  =3D FS_REQUIRES_DEV,
> +};

[Severity: High]
Is the .owner field missing from this file_system_type structure?

Without .owner =3D THIS_MODULE, the VFS will not increment the module
reference count when a famfs filesystem is mounted. Could this allow the
module to be unexpectedly unloaded via rmmod while active superblocks and
inodes are still in use, leading to a kernel oops and use-after-free
vulnerabilities?

> +
> +/***********************************************************************=
*******
> + * Module stuff
> + */

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/0100019fc572ca94-ec=
363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com?part=3D2
