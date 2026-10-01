Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E1E5304C9;
	Thu,  1 Oct 2026 15:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790868390; cv=none; b=FsZZ+pOV0gkLUBdQAEo/T7iX9WKb75ampMbeqv2Js3cMQn5J9Q7w6CtmbFBXzJHlu8g4rFpgl+ev/syvF0wtloEO0g3/sizzt7sny8vZDJJx1wparhn+4Gi9dmgCvR8hJ2xH0FRsnbfb4fXiGSSCFvFK0yP157blLDwst8juS5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790868390; c=relaxed/simple;
	bh=/zmhTRFI3agC/+L9uMXo395TxFMBOdfKgsdk5jmfj84=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=N6HbO5lJEYFOBZTnslfcsGoRLmCxT4dYsJJCjKrcSY+QPZZ9GFBtL7B6lRL1sHHvnVsNmljLhVFqYyS53y8LE6JeplRXkxLInS4CAgHFW1BpDHb2turHxWHqqqc4ox4PmM6tpUsWLWk1YCzefqFf2hmooqxgBo/qS+uN17P3V44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mtSVTv/w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mtSVTv/w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7BD51F000FF;
	Thu,  1 Oct 2026 15:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790868389;
	bh=W9/I1HM6jPG/yJ7PaA7QVmKiMjVBdvOycYNOislFwRc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mtSVTv/w/637JFOpULYNEZJjWEEJBNmmuo5dgTS9xml5Nlkk4wLrtt0XO6CDClB4B
	 GwNFavQbdS0UIdQOzbXUs14r7HnM+RXlid4GzXE6p9E3GvYVrEBhf0c7RM09H4I/w9
	 Jwhkj467AcNKi+E6+A+1S6ykI9ZKnxb4TCVIXlMk5ZLjePM6JZ8pXvEtM/fPUtemVP
	 eaM+WLFctXg1eP+T5qH4MPcxqrS3i8exQ25cxhu3l+o2iNIuy53g+DQ7UxM8qs4a7k
	 mJ7LZy+opakX7EVTzheUjbKuQAMvaYVq7H9wuH0m9i4NZ1rUOi27hjB7+Slznbjda3
	 plzPMhiOE2U2Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 3/8] fuse: support 64 bit, server allocated backing
 ID
Reply-To: sashiko-reviews@lists.linux.dev
To: "Miklos Szeredi" <mszeredi@redhat.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <20261001150935.655979-4-mszeredi@redhat.com>
References: <20261001150935.655979-1-mszeredi@redhat.com>
 <20261001150935.655979-4-mszeredi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 15:26:28 +0000
Message-Id: <20261001152628.D7BD51F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] fuse: unchecked rhashtable_init() return leads to NULL dereference
- [High] fuse: race between process_init_reply() and ioctl corrupts IDR/rha=
shtable union
- [Medium] fuse: duplicate 64-bit backing IDs lead to memory leaks
--

commit 4b1027b3a4203f8caa807855de45ddb14b02bbb9
Author: Miklos Szeredi <mszeredi@redhat.com>

fuse: support 64 bit, server allocated backing ID

This commit adds support for server allocated 64-bit backing IDs
alongside the existing kernel allocated 32-bit IDs. It introduces
FUSE_DEV_IOC_BACKING_CREATE and FUSE_NOTIFY_BACKING_REMOVE for
managing the 64-bit backing IDs.

> diff --git a/fs/fuse/backing.c b/fs/fuse/backing.c
> index 433fa3098d71f..3c879df7989c9 100644
> --- a/fs/fuse/backing.c
> +++ b/fs/fuse/backing.c
[ ... ]
> +static int fuse_backing_add_64(struct fuse_conn *fc, struct fuse_backing=
 *fb)
> +{
> +	return rhashtable_insert_fast(&fc->backing_64_ht, &fb->hash_node, fuse_=
backing_prm);
>  }

[Severity: Medium]
Does this allow duplicate backing IDs, leading to a memory leak?

rhashtable_insert_fast() does not check for duplicate keys. If a user
invokes FUSE_DEV_IOC_BACKING_CREATE multiple times with the exact same
64-bit map->backing_id, they will all be inserted.

When removing via fuse_backing_close_64(), rhashtable_remove_fast() will
only retrieve and delete one instance, leaving the duplicates orphaned and
leaking the struct fuse_backing objects.

[ ... ]
> +void fuse_backing_files_init_64(struct fuse_conn *fc)
> +{
> +	rhashtable_init(&fc->backing_64_ht, &fuse_backing_prm);
> +	fc->backing_id_64 =3D true;
>  }

[Severity: High]
What happens if rhashtable_init() fails here due to memory pressure?

Since the return value is ignored, fc->backing_id_64 =3D true is set
unconditionally. If rhashtable_init() returns an error, the hash table
remains uninitialized.

A subsequent ioctl triggering fuse_backing_open_64() would call
rhashtable_insert_fast(), which dereferences the NULL ht->tbl, resulting
in a kernel panic.

> diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> index 2a1aadc08e2a8..9b65543c6cc79 100644
> --- a/fs/fuse/fuse_i.h
> +++ b/fs/fuse/fuse_i.h
[ ... ]
> @@ -770,8 +775,14 @@ struct fuse_conn {
>  	struct fuse_sync_bucket __rcu *curr_bucket;
> =20
>  #ifdef CONFIG_FUSE_PASSTHROUGH
> -	/** @backing_files_map: IDR for backing files ids */
> -	struct idr backing_files_map;
> +	/* Selected by backing_id_64 */
> +	union {
> +		/** @backing_files_map: IDR for backing files ids */
> +		struct idr backing_files_map;
> +
> +		/** @backing_64_ht: 64 bit ID lookup hash table */
> +		struct rhashtable backing_64_ht;
> +	};
>  #endif
>  };
> =20
> diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> index cbb10e19e7e86..bb76bddfc2417 100644
> --- a/fs/fuse/inode.c
> +++ b/fs/fuse/inode.c
[ ... ]
> @@ -1408,13 +1408,15 @@ static void process_init_reply(struct fuse_args *=
args, int error)
>  			 * them together.
>  			 */
>  			if (IS_ENABLED(CONFIG_FUSE_PASSTHROUGH) &&
> -			    (flags & FUSE_PASSTHROUGH) &&
> +			    (flags & (FUSE_PASSTHROUGH | FUSE_PASSTHROUGH_V2)) &&
>  			    arg->max_stack_depth > 0 &&
>  			    arg->max_stack_depth <=3D FILESYSTEM_MAX_STACK_DEPTH &&
>  			    !(flags & FUSE_WRITEBACK_CACHE))  {
>  				fc->passthrough =3D 1;
>  				fc->max_stack_depth =3D arg->max_stack_depth;
>  				fm->sb->s_stack_depth =3D arg->max_stack_depth;
> +				if (flags & FUSE_PASSTHROUGH_V2)
> +					fuse_backing_files_init_64(fc);

[Severity: High]
Can this sequence cause memory corruption in the union?

If fc->passthrough =3D 1 is set locklessly before fuse_backing_files_init_6=
4(fc)
completes, a concurrent FUSE_DEV_IOC_BACKING_OPEN ioctl in fuse_backing_ope=
n()
could see fc->passthrough =3D=3D 1 and fc->backing_id_64 =3D=3D 0.

It would proceed to call fuse_backing_id_alloc(), modifying the 32-bit
backing_files_map IDR. Meanwhile, fuse_backing_files_init_64() executes
rhashtable_init(&fc->backing_64_ht), which would blindly overwrite the very
same memory union, corrupting the IDR state.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001150935.6559=
79-1-mszeredi@redhat.com?part=3D3
