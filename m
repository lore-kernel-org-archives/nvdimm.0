Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C8E13FEE;
	Sat, 22 Aug 2026 00:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787357251; cv=none; b=mYoqHdiiw7JS2AAsF1GpfgHbY9BwdPvnaW1+gAY2pNMWkVrJgLI5wQxGsKYIJ/DA0ga78WNc8AU2Cq+aMPbbYEZh+gPxPF53/R+vqULBi9BBMAdA7NbeJZ31hzU8zOhXe7QO9VxOuLqNIv2Uh6wceRjSK6H1xwA5MVPEEw5RY+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787357251; c=relaxed/simple;
	bh=tARrK2DyAjg3NpJ5/1Hr+stvyBIcOV2BYYBJgq3ZyU4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=doV/gloD4cTzKwcM44eNq/cnwPVyCDzTEKy9RqDYfN1Lpw9tGeZYgTzVtLJnZYdr+NWYCc8l+O+oU3PJv/i4yzNrMntHcyANHT1xBTOiiSygRVd0WT2DlqLb47BJPKaxoP1YfTuyjbNKV3Rt9Wmm4yjKYDuspkZnZzGlvzqE0Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i1xPJdYN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i1xPJdYN"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3208E1F000E9;
	Sat, 22 Aug 2026 00:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787357249;
	bh=3BJuQNK6b1/o0xfdnlOz6xEmEgheAyv0QX/nmO/VtWk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=i1xPJdYNAtBMqUrSS1MT75ReVHUXjvcZKAHptIbd3zNc/2Kv6aOZlm5b/mwirRS7Z
	 EhxniYEq++3Havju3fM1x9V/RNCh6VwW+WlyXZ3glAWjoZhFjUepvLeRtk1af7yWOY
	 +61n/+SE6CaTpPXMvZyAkR/UDM+EuARNtBmFBnyC8xSF3ziNbw44PmFHvKsqUnI02E
	 Awhcq+pnudJ3CY/QIuXNrGLfVaTwF1uxH6m5pNtOFEwid2cjx2dMPhek96Zh6GRN0o
	 HSuXsAD/tU34adQZeAQ2D/FZf8MHA6fqdEAd0GjC9Mvid6dcL5qYAkHyzMg7acIlmo
	 EH0Ntse3Fa/RQ==
Date: Fri, 21 Aug 2026 17:07:28 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: John Groves <john@jagalactic.com>
Cc: John Groves <John@groves.net>, Miklos Szeredi <miklos@szeredi.hu>,
	Dan Williams <djbw@kernel.org>, Bernd Schubert <bschubert@ddn.com>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>,
	Jake Edge <jake@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	David Hildenbrand <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Stefan Hajnoczi <shajnocz@redhat.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Chen Linxuan <chenlinxuan@uniontech.com>,
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Shivank Garg <shivankg@amd.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Gregory Price <gourry@gourry.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ira Weiny <iweiny@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Haren Myneni <haren@linux.ibm.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Gabriel Whigham <gabewhigham@gmail.com>,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	"venkataravis@micron.com" <venkataravis@micron.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"fuse-devel@lists.linux.dev" <fuse-devel@lists.linux.dev>
Subject: Re: [PATCH v13 10/12] famfs: Add runtime operation-permission (opts)
 framework
Message-ID: <20260822000728.GB6047@frogsfrogsfrogs>
References: <0100019fed5850ec-2bdfb17a-3086-44ea-8fdd-777d3ce12a33-000000@email.amazonses.com>
 <20260810202539.96378-1-john@jagalactic.com>
 <0100019fed5a5210-a09f1bdb-c705-44fc-8108-a7e7995a7af0-000000@email.amazonses.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0100019fed5a5210-a09f1bdb-c705-44fc-8108-a7e7995a7af0-000000@email.amazonses.com>

On Mon, Aug 10, 2026 at 08:25:47PM +0000, John Groves wrote:
> From: John Groves <john@groves.net>
> 
> famfs denies most namespace, attribute and data operations by default
> because the userspace log, not the kernel, is authoritative for a famfs
> instance. Earlier commits already guard each such operation with a
> famfs_opt_enabled(fsi, FAMFS_OPT_x) check backed by a permissive stub. This
> commit defines the permission bitmap and makes those checks live.
> 
> Add:
>  - FAMFS_OPT_* (uapi): a u64 permission bitmap, one bit per gated operation
>    (create, mkdir, mknod, symlink, link, unlink, rmdir, rename, the four
>    setattr components, data write, and MAP_CREATE), plus FAMFS_OPT_ALL. The
>    FAMFS_OPT_XATTR bit is reserved - famfs has no xattr ops yet.
>  - fsi->opts: a per-mount atomic64 bitmap initialized to FAMFS_OPT_DEFAULT,
>    which sets famfs's default policy: create, mkdir, chmod, chown, utimes,
>    write and MAP_CREATE are permitted; unlink of mapped files, link,
>    symlink, mknod, rmdir, rename and truncate are denied.
>  - the real famfs_opt_enabled() (replacing the stub), so every planted gate
>    now consults fsi->opts.
>  - FAMFSIOC_{GET,SET,CLEAR}_OPTS: read the bitmap, or enable/disable the
>    bits set in a caller-supplied mask, returning the resulting bitmap.
>    SET/CLEAR require CAP_SYS_ADMIN and reject unknown bits with -EINVAL;
>    the bitmap is updated with atomic RMW so the checks stay lockless.

In a shared cxlmem environment, a program that wants to allocate some
cxlmem contacts the master node and the master creates a path, maps some
memory to the path, and writes a transaction to the log, right?

Then, each node reads the new addition to the log and (maybe) creates a
corresponding in-core path on the famfs mount, opens the file, and calls
MAP_CREATE to upload the file-to-memory mappings.  After that,
unprivileged client programs can use the file abstraction to map the cxl
memory, right?

It looks like file creation requires (a) the sysadmin to have set the
FAMFS_OPS_CREATE flag and (b) to have CAP_SYS_ADMIN.  This prevents
unprivileged programs from creating new files that point to arbitrary
(and possibly already in use) chunks of memory, right?

But what prevents a malicious program that is /not/ the famfs client
software but has CAP_SYS_ADMIN from doing that?

The one place where I think fuse-famfs has an edge over the kernel
version is that fuse-famfs both reads the metadata log and presents the
directory tree to the kernel, so it can reject creat/mknod/mkdir
requests coming from the kernel.

--D

> Signed-off-by: John Groves <john@groves.net>
> ---
>  fs/famfs/famfs_file.c            | 59 ++++++++++++++++++++++++++++++++
>  fs/famfs/famfs_inode.c           |  1 +
>  fs/famfs/famfs_internal.h        | 30 +++++++++++++---
>  include/uapi/linux/famfs_ioctl.h | 45 ++++++++++++++++++++++++
>  4 files changed, 131 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/famfs/famfs_file.c b/fs/famfs/famfs_file.c
> index 6f71805a297c..e7fa7324c374 100644
> --- a/fs/famfs/famfs_file.c
> +++ b/fs/famfs/famfs_file.c
> @@ -359,6 +359,53 @@ famfs_daxdev_open(struct file *file, void __user *arg)
>  	return rc;
>  }
>  
> +/**
> + * famfs_get_opts() - FAMFSIOC_GET_OPTS: return the permission bitmap
> + */
> +static long
> +famfs_get_opts(struct famfs_fs_info *fsi, void __user *arg)
> +{
> +	struct famfs_ioc_opts o = { .opts = atomic64_read(&fsi->opts) };
> +
> +	if (copy_to_user(arg, &o, sizeof(o)))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
> +/*
> + * famfs_modify_opts() - FAMFSIOC_SET_OPTS / FAMFSIOC_CLEAR_OPTS
> + * @set: true to enable (OR in) the requested bits, false to disable (mask out)
> + *
> + * The caller supplies a mask of FAMFS_OPT_* bits; the resulting bitmap is
> + * returned. Requires CAP_SYS_ADMIN since it changes mount-wide policy.
> + */
> +static long
> +famfs_modify_opts(
> +	struct famfs_fs_info *fsi,
> +	void __user *arg,
> +	bool set)
> +{
> +	struct famfs_ioc_opts o;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +	if (copy_from_user(&o, arg, sizeof(o)))
> +		return -EFAULT;
> +	if (o.opts & ~FAMFS_OPT_ALL)
> +		return -EINVAL;
> +
> +	if (set)
> +		o.opts = atomic64_fetch_or(o.opts, &fsi->opts) | o.opts;
> +	else
> +		o.opts = atomic64_fetch_and(~o.opts, &fsi->opts) & ~o.opts;
> +
> +	if (copy_to_user(arg, &o, sizeof(o)))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
>  /**
>   * famfs_file_ioctl() - Top-level famfs file ioctl handler
>   * @file: the file
> @@ -380,6 +427,18 @@ famfs_file_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  		rc = 0;
>  		break;
>  
> +	case FAMFSIOC_GET_OPTS:
> +		rc = famfs_get_opts(fsi, (void __user *)arg);
> +		break;
> +
> +	case FAMFSIOC_SET_OPTS:
> +		rc = famfs_modify_opts(fsi, (void __user *)arg, true);
> +		break;
> +
> +	case FAMFSIOC_CLEAR_OPTS:
> +		rc = famfs_modify_opts(fsi, (void __user *)arg, false);
> +		break;
> +
>  	case FAMFSIOC_DAXDEV_OPEN:
>  		rc = famfs_daxdev_open(file, (void __user *)arg);
>  		break;
> diff --git a/fs/famfs/famfs_inode.c b/fs/famfs/famfs_inode.c
> index 98c877a6009e..2f1938adbfbc 100644
> --- a/fs/famfs/famfs_inode.c
> +++ b/fs/famfs/famfs_inode.c
> @@ -769,6 +769,7 @@ famfs_init_fs_context(struct fs_context *fc)
>  		return -ENOMEM;
>  
>  	init_rwsem(&fsi->devlist_sem);
> +	atomic64_set(&fsi->opts, FAMFS_OPT_DEFAULT);
>  	fsi->mount_opts.mode = FAMFS_DEFAULT_MODE;
>  	fc->s_fs_info        = fsi;
>  	fc->ops              = &famfs_context_ops;
> diff --git a/fs/famfs/famfs_internal.h b/fs/famfs/famfs_internal.h
> index f17380d24f6d..5e043b5a0ddd 100644
> --- a/fs/famfs/famfs_internal.h
> +++ b/fs/famfs/famfs_internal.h
> @@ -12,11 +12,24 @@
>  #define FAMFS_INTERNAL_H
>  
>  #include <linux/rwsem.h>
> +#include <linux/atomic.h>
>  #include <linux/bits.h>
>  #include <linux/build_bug.h>
>  
>  #include <linux/famfs_ioctl.h>
>  
> +/*
> + * Default operation-permission bitmap (see FAMFS_OPT_* in the uapi header).
> + * This preserves famfs's historical behavior: file/dir creation, the fmap
> + * ioctl, data writes, and the non-resize setattr components are permitted;
> + * unlink of mapped files, link, symlink, mknod, rmdir, rename and truncate
> + * are denied until enabled via FAMFSIOC_SET_OPTS.
> + */
> +#define FAMFS_OPT_DEFAULT	(FAMFS_OPT_CREATE | FAMFS_OPT_MKDIR | \
> +				 FAMFS_OPT_CHMOD | FAMFS_OPT_CHOWN | \
> +				 FAMFS_OPT_UTIMES | FAMFS_OPT_WRITE | \
> +				 FAMFS_OPT_MAP_CREATE)
> +
>  extern const struct file_operations famfs_file_operations;
>  
>  /*
> @@ -104,6 +117,8 @@ struct famfs_dax_devlist {
>   * @famfs_fs_info
>   *
>   * @mount_opts:  The mount options
> + * @opts:        Operation-permission bitmap (FAMFS_OPT_*), adjusted at runtime
> + *               via the FAMFSIOC_{GET,SET,CLEAR}_OPTS ioctls
>   * @deverror:    True if the dax device has called our notify_failure entry
>   *               point, or if other "shutdown" conditions exist
>   * @dax_devlist: Table of backing daxdevs (slot 0 is the mount primary)
> @@ -111,16 +126,23 @@ struct famfs_dax_devlist {
>   */
>  struct famfs_fs_info {
>  	struct famfs_mount_opts   mount_opts;
> +	atomic64_t                opts;
>  	bool                      deverror;
>  	struct famfs_dax_devlist *dax_devlist;
>  	struct rw_semaphore       devlist_sem;
>  };
>  
> -/* This stub will be replaced in a later commit
> - * Note: the opt parameter is intentionally unused, and will be used by
> - * the replacement function when that commit lands
> +/*
> + * famfs_opt_enabled() - is operation permission @opt enabled for this mount?
> + *
> + * @opt is a single FAMFS_OPT_* bit; returns true if that operation is
> + * permitted. The bitmap is read locklessly (updated via atomic RMW by the
> + * FAMFSIOC_{SET,CLEAR}_OPTS ioctls).
>   */
> -#define famfs_opt_enabled(fsi, opt) (fsi != 0)
> +static inline bool famfs_opt_enabled(struct famfs_fs_info *fsi, u64 opt)
> +{
> +	return !!(atomic64_read(&fsi->opts) & opt);
> +}
>  
>  int famfs_lookup_daxdev(const char *pathname, dev_t *devno);
>  int famfs_devlist_alloc(struct famfs_fs_info *fsi);
> diff --git a/include/uapi/linux/famfs_ioctl.h b/include/uapi/linux/famfs_ioctl.h
> index 751d8b033c2e..efe6ef263975 100644
> --- a/include/uapi/linux/famfs_ioctl.h
> +++ b/include/uapi/linux/famfs_ioctl.h
> @@ -100,6 +100,48 @@ struct famfs_ioc_daxdev {
>  	__u32 flags;
>  };
>  
> +/*
> + * Mount-wide operation permissions, queried and modified via the
> + * FAMFSIOC_{GET,SET,CLEAR}_OPTS ioctls. A set bit means the operation is
> + * permitted; a clear bit means it is rejected with -EPERM. famfs denies most
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
> +#define FAMFS_OPT_CHMOD		(1ULL << 8)  /* setattr ATTR_MODE            */
> +#define FAMFS_OPT_CHOWN		(1ULL << 9)  /* setattr ATTR_UID / ATTR_GID  */
> +#define FAMFS_OPT_TRUNCATE	(1ULL << 10) /* setattr ATTR_SIZE (resize)   */
> +#define FAMFS_OPT_UTIMES	(1ULL << 11) /* setattr ATTR_ATIME/ATTR_MTIME*/
> +#define FAMFS_OPT_WRITE		(1ULL << 12) /* write file data              */
> +#define FAMFS_OPT_XATTR		(1ULL << 13) /* set/remove xattrs (reserved) */
> +#define FAMFS_OPT_MAP_CREATE	(1ULL << 14) /* attach an fmap (MAP_CREATE)  */
> +
> +#define FAMFS_OPT_ALL		(FAMFS_OPT_CREATE | FAMFS_OPT_MKDIR | \
> +				 FAMFS_OPT_MKNOD | FAMFS_OPT_SYMLINK | \
> +				 FAMFS_OPT_LINK | FAMFS_OPT_UNLINK | \
> +				 FAMFS_OPT_RMDIR | FAMFS_OPT_RENAME | \
> +				 FAMFS_OPT_CHMOD | FAMFS_OPT_CHOWN | \
> +				 FAMFS_OPT_TRUNCATE | FAMFS_OPT_UTIMES | \
> +				 FAMFS_OPT_WRITE | FAMFS_OPT_XATTR | \
> +				 FAMFS_OPT_MAP_CREATE)
> +
> +/**
> + * struct famfs_ioc_opts - operation-permission bitmap
> + * @opts: for GET, the current bitmap is returned here. For SET/CLEAR, the
> + *        caller-supplied mask of bits to enable/disable on input, and the
> + *        resulting bitmap on return.
> + */
> +struct famfs_ioc_opts {
> +	__u64 opts;
> +};
> +
>  #define FAMFSIOC_MAGIC 'u'
>  
>  /* famfs file ioctl opcodes */
> @@ -111,5 +153,8 @@ struct famfs_ioc_daxdev {
>   */
>  #define FAMFSIOC_MAP_CREATE    _IOW(FAMFSIOC_MAGIC,  0x51, struct famfs_ioc_fmap_header)
>  #define FAMFSIOC_DAXDEV_OPEN   _IOW(FAMFSIOC_MAGIC,  0x52, struct famfs_ioc_daxdev)
> +#define FAMFSIOC_GET_OPTS      _IOR(FAMFSIOC_MAGIC,  0x53, struct famfs_ioc_opts)
> +#define FAMFSIOC_SET_OPTS      _IOWR(FAMFSIOC_MAGIC, 0x54, struct famfs_ioc_opts)
> +#define FAMFSIOC_CLEAR_OPTS    _IOWR(FAMFSIOC_MAGIC, 0x55, struct famfs_ioc_opts)
>  
>  #endif /* FAMFS_IOCTL_H */
> -- 
> 2.53.0
> 
> 
> 
