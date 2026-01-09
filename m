Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DFE9364E9B
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 18:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767982631; cv=none; b=BZibnWAsfkLJYYyhoDc1XUJDmljbr6nRvBN+L4CP0pX1/SRejTdvlpcN3bfJbquSjhsM72+NDhGlrvTOIK5XNyaJN91J3Vk5lMuU0ml60/HGkRJcpN43ACJJdgvdIgvsuKlX6WDSDqWCgCIB7hEes+khkpw8qeBT9I28uxoXMbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767982631; c=relaxed/simple;
	bh=wDQz4/9kZDqBRhEduIm0c9MYaFs+Pc7VcoLQiQYsc0Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QM87W9uSdvkQ5M8YUp4fq5xonyTS5zJkZCEh6z1mGMiw9rcGCY1Vk8MKs1B7iCsB/mQYww6MUY+u4eejcw+8TmLMTpp83XJFVe/DcicS3z8GzDVokGQcV7qqZCvqKZg73ccmgOp4Bl2lICnfmz9vTHIVPMG/gHzFaCqINfj/n7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D8t33tyt; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D8t33tyt"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4ee158187aaso47707671cf.0
        for <nvdimm@lists.linux.dev>; Fri, 09 Jan 2026 10:17:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767982628; x=1768587428; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=99Bs8S0fdZX8Ye9690VGi/t/MTR/ntJJl67b7rjD20M=;
        b=D8t33tytLToRG49BNKdH9igvjcoFoabm8lZYlrkgq5iI3bv3j7+/RqOTAD/1UYQn+m
         y/kHZgLOaOmlHeZvx/XNufuRjuOAi/4V2LJ26z+y0m7iqPNgcxUdm/zeTU/5pGnH4kj5
         L4jnhjMGCPAU7Nm8VE2Y3C66zBpB5KM1352rerSug1ux+9OwwquP938byK2Db4oEWIqN
         BsKxpbiXiYCuJ2/qfyXI965ustKXm8Y/wRJfingOhiQ0357itvOL2Te3NX7/yygMjmk9
         dFIuicJCj4W1RJmcFWY9iml+Xzs4W5xYE7ZJ6C0HOlcfdplmS95x8ZYwxVekzXdIhvpu
         FBpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767982628; x=1768587428;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=99Bs8S0fdZX8Ye9690VGi/t/MTR/ntJJl67b7rjD20M=;
        b=TW+aD7B7Ymgwr/x74UwgQMSgcx+8L8XElF0WCzv2Demkh/6G7vJBk628V8FZTEb9zn
         fGiZNFSK+BYaDsOL1Tw8/vGRdFjRmzpWPSMG9TzM9bD1/qKnF+YP5GZEb136YvQfiUdW
         kbNoZAabxdJf73TJ39VPhPOyAnxcoD0y68RNVMC8JtQd0Pm69sCC83OpHdpFDbi8ckpZ
         QaedsxyVElMB8sVjr+f6+03yib4I7VrxByo4HrnONW7oOZ6rmN1ED/pX1QLVAwkZOVh8
         SdjOefYg7fr+jaCaRiepmBmhKVnaza5U8g11WG7Y1oeLWFVLidZ3iZ6Q02j0YmfdBrRO
         dNww==
X-Forwarded-Encrypted: i=1; AJvYcCV0CZmCNVC4f054nzG0paksCb5P/s5AUXqIauqAgEQEhVc6CQ471lX/SQsIULR4hdEDYsD8Cdk=@lists.linux.dev
X-Gm-Message-State: AOJu0YzyDx2R3Aq0SsbQGX6cagf2n3MVp3zJz4YZmBDeAuSPt05xwaE6
	zt41apKTMZfHj+QwUEp3WHXehPYUeFHr5Y85N+wk7+chbtBtKY7NH9K0iKQWCwG69Z0BmrTZsRr
	//139SAhzJJIaub1gHHvgxLow+SdXibc=
X-Gm-Gg: AY/fxX4KZKLJ+M4d180o+hzaRYaRy5VC19C5eSS2MSo+EzaIedk2gDTCk4S39T4TWGX
	caQxJIqM6m82cgwsOGu3WHDiGKTayHhkSo8pZ5yf4aBPbt5pG56UTi4LtC4zKjvgqqaI7GBFyjr
	N8AW4hbqkb2mzCYSRGyidPfUTR3ZDDPJ8FZgb/dAy7+Tx99RwTKJ9nRbbY7DfWbUj2bdmJXKpKS
	rNteIFQlYAW3QAIqUJbEM8cqHyHuEp6XaAW7zlIp38vVmLXfemZOPis7QCSBmWc9jx3yRE6y8+L
	xOUd
X-Google-Smtp-Source: AGHT+IH5+xJnp1a7PuWX1AlKsiRN99ozxNGtRWQ/qZ5RJUifdmvCatdxw6dSXGDWNttKbNDhIKFCmffMgnKYpiFNkIY=
X-Received: by 2002:a05:622a:1ba9:b0:4f4:ddff:b1b3 with SMTP id
 d75a77b69052e-4ffb494e23dmr156643501cf.22.1767982627972; Fri, 09 Jan 2026
 10:17:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260107153244.64703-1-john@groves.net> <20260107153332.64727-1-john@groves.net>
 <20260107153332.64727-12-john@groves.net>
In-Reply-To: <20260107153332.64727-12-john@groves.net>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 9 Jan 2026 10:16:57 -0800
X-Gm-Features: AQt7F2ogZw-Qc2qKqJ80XJE7WwiTnLf-j6OBE6JHVL90Ak-M1koy9qRlA2GGgRc
Message-ID: <CAJnrk1ZxmryZQJhvesJET12xK8Hemir0uk6wojTty0NDvu1Xng@mail.gmail.com>
Subject: Re: [PATCH V3 11/21] famfs_fuse: Update macro s/FUSE_IS_DAX/FUSE_IS_VIRTIO_DAX/
To: John Groves <John@groves.net>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Dan Williams <dan.j.williams@intel.com>, 
	Bernd Schubert <bschubert@ddn.com>, Alison Schofield <alison.schofield@intel.com>, 
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Amir Goldstein <amir73il@gmail.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Josef Bacik <josef@toxicpanda.com>, 
	Bagas Sanjaya <bagasdotme@gmail.com>, Chen Linxuan <chenlinxuan@uniontech.com>, 
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Gregory Price <gourry@gourry.net>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, venkataravis@micron.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 7, 2026 at 7:34=E2=80=AFAM John Groves <John@groves.net> wrote:
>
> Virtio_fs now needs to determine if an inode is DAX && not famfs.

nit: it was unclear to me why this patch changed the macro to take in
a struct fuse_inode until I looked at patch 14. it might be useful
here to add a line about that

>
> Signed-off-by: John Groves <john@groves.net>
> ---
>  fs/fuse/dir.c    |  2 +-
>  fs/fuse/file.c   | 13 ++++++++-----
>  fs/fuse/fuse_i.h |  6 +++++-
>  fs/fuse/inode.c  |  4 ++--
>  fs/fuse/iomode.c |  2 +-
>  5 files changed, 17 insertions(+), 10 deletions(-)
>
> diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
> index 4b6b3d2758ff..1400c9d733ba 100644
> --- a/fs/fuse/dir.c
> +++ b/fs/fuse/dir.c
> @@ -2153,7 +2153,7 @@ int fuse_do_setattr(struct mnt_idmap *idmap, struct=
 dentry *dentry,
>                 is_truncate =3D true;
>         }
>
> -       if (FUSE_IS_DAX(inode) && is_truncate) {
> +       if (FUSE_IS_VIRTIO_DAX(fi) && is_truncate) {
>                 filemap_invalidate_lock(mapping);
>                 fault_blocked =3D true;
>                 err =3D fuse_dax_break_layouts(inode, 0, -1);
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index 01bc894e9c2b..093569033ed1 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -252,7 +252,7 @@ static int fuse_open(struct inode *inode, struct file=
 *file)
>         int err;
>         bool is_truncate =3D (file->f_flags & O_TRUNC) && fc->atomic_o_tr=
unc;
>         bool is_wb_truncate =3D is_truncate && fc->writeback_cache;
> -       bool dax_truncate =3D is_truncate && FUSE_IS_DAX(inode);
> +       bool dax_truncate =3D is_truncate && FUSE_IS_VIRTIO_DAX(fi);
>
>         if (fuse_is_bad(inode))
>                 return -EIO;
> @@ -1812,11 +1812,12 @@ static ssize_t fuse_file_read_iter(struct kiocb *=
iocb, struct iov_iter *to)
>         struct file *file =3D iocb->ki_filp;
>         struct fuse_file *ff =3D file->private_data;
>         struct inode *inode =3D file_inode(file);
> +       struct fuse_inode *fi =3D get_fuse_inode(inode);
>
>         if (fuse_is_bad(inode))
>                 return -EIO;
>
> -       if (FUSE_IS_DAX(inode))
> +       if (FUSE_IS_VIRTIO_DAX(fi))
>                 return fuse_dax_read_iter(iocb, to);
>
>         /* FOPEN_DIRECT_IO overrides FOPEN_PASSTHROUGH */
> @@ -1833,11 +1834,12 @@ static ssize_t fuse_file_write_iter(struct kiocb =
*iocb, struct iov_iter *from)
>         struct file *file =3D iocb->ki_filp;
>         struct fuse_file *ff =3D file->private_data;
>         struct inode *inode =3D file_inode(file);
> +       struct fuse_inode *fi =3D get_fuse_inode(inode);
>
>         if (fuse_is_bad(inode))
>                 return -EIO;
>
> -       if (FUSE_IS_DAX(inode))
> +       if (FUSE_IS_VIRTIO_DAX(fi))
>                 return fuse_dax_write_iter(iocb, from);
>
>         /* FOPEN_DIRECT_IO overrides FOPEN_PASSTHROUGH */
> @@ -2370,10 +2372,11 @@ static int fuse_file_mmap(struct file *file, stru=
ct vm_area_struct *vma)
>         struct fuse_file *ff =3D file->private_data;
>         struct fuse_conn *fc =3D ff->fm->fc;
>         struct inode *inode =3D file_inode(file);
> +       struct fuse_inode *fi =3D get_fuse_inode(inode);
>         int rc;
>
>         /* DAX mmap is superior to direct_io mmap */
> -       if (FUSE_IS_DAX(inode))
> +       if (FUSE_IS_VIRTIO_DAX(fi))
>                 return fuse_dax_mmap(file, vma);
>
>         /*
> @@ -2934,7 +2937,7 @@ static long fuse_file_fallocate(struct file *file, =
int mode, loff_t offset,
>                 .mode =3D mode
>         };
>         int err;
> -       bool block_faults =3D FUSE_IS_DAX(inode) &&
> +       bool block_faults =3D FUSE_IS_VIRTIO_DAX(fi) &&
>                 (!(mode & FALLOC_FL_KEEP_SIZE) ||
>                  (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_ZERO_RANGE)));
>
> diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> index 7f16049387d1..17736c0a6d2f 100644
> --- a/fs/fuse/fuse_i.h
> +++ b/fs/fuse/fuse_i.h
> @@ -1508,7 +1508,11 @@ void fuse_free_conn(struct fuse_conn *fc);
>
>  /* dax.c */
>
> -#define FUSE_IS_DAX(inode) (IS_ENABLED(CONFIG_FUSE_DAX) && IS_DAX(inode)=
)
> +/* This macro is used by virtio_fs, but now it also needs to filter for
> + * "not famfs"
> + */

Did you mean to add this comment to "patch 14/21: famfs_fuse: Plumb
the GET_FMAP message/response" instead? it seems like that's the patch
that adds the "&& !fuse_file_famfs(fuse_inode))" part to this.

Reviewed-by: Joanne Koong <joannelkoong@gmail.com>

Thanks,
Joanne
