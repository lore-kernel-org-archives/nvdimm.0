Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F1D3477E4E
	for <nvdimm@lists.linux.dev>; Fri,  9 Oct 2026 07:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791531421; cv=pass; b=o1xf2XWfH5na3N5bPVzhLSkCCKEBNR3Jl1EHNHGfK6e2cVCNJJlRRFXDF9X+GGu5PlhJWmB+zx5Juw8OzIHYwIc5jXNHZjiyQif2jrCEv0ehyAd44q6aBGrtrqaEyvshanHaoNamx7lmAR+De1d3pmwpOD6829dGpv4JyCJuPrA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791531421; c=relaxed/simple;
	bh=YMfKNylBb9GzxVIsFKNLxFRCTRDskPy0v9kUA3JZ0Rw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RNeDLse7wlFsdCafvQOC9o2zQdv/G66dSH7DVnog8WVVIF1lroK1DyrqkNcfCd5bCWuu3AJpnX6dY6ApUb3IWm/uVPVFoBYg1e+vD8vWL/r6XpWgBDkD5VXtorvYnNUqjG0j2kIqBaeO5yr26TTPqU/EAWXzAmZ78Vgkti5dn2k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iWa3rHM2; arc=pass smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iWa3rHM2"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6acb9c018ffso2547993a12.1
        for <nvdimm@lists.linux.dev>; Fri, 09 Oct 2026 00:36:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791531418; cv=none;
        d=google.com; s=arc-20260327;
        b=eiEs0s1QZpX9/CEJTdKSS5W8ZalqnLvXDog7RhsNlMsBE8yxuNLZMimU613kZjotjr
         zCuRas86GT4D0hO8h22Hew40fj9JAc8XHA8emk0O3YY2qZJKVOM9Isc0RhwBJ6klnMVQ
         m95m8o9iE67u/6SE30pdW5591OHtUYZLtyMtgJGlYFIRhLrKRmSGVpmTaAODavtO8l37
         PyhZnPXIO6m4o2jObdXxB6lCKlDcDYJC4ek2j5XgKImt0gCPRSWbMI/F1N2KvoHVdwB6
         Rr2pe9FcDpY3ZipLb1BKXzfYEg47Z5eCAnkg6UncJ5x75cslY6fLFzUoDA99/lQRusTe
         x93Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DhSjNxqbm4HcT9hh0RRIJr4WnJT+XPSewhpuWWrAjrI=;
        fh=yZuXTl1cgtC8OcHd7UaRNWCkFh6J2dV4gb79xGISFgA=;
        b=o4SEfEuq4ynd+Kc0sPX6LJDtOatWAKypeU5xAzXPG1PEIVkbE2AJY/FSr8OR+/qOwS
         eB+660Krw7Mr/lrWXnH8tg8wZ4lkFMCCxxGP7d8hhZB7OZPB9PuKrFn5vnLefjlQXlYl
         phObGZA4Y3oo0cCLRa412ZA8VlGDS/TFKqy8M/ba5uX/beXEaeFW6homi1Huc7UyFT0W
         yqW5BdJMf2pwgQO4PBxy1lg7oUhwdv3/TO0txxw4kxzDvikIANHlm7mbAZrfR+9qqeTb
         IoZOTPIw5kSXdQUzYJP2hD+5Mtbp9hfrkyr7Ya4n+kgiCvHEagS5q1u1eraVwVsW+PDd
         jVQQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791531418; x=1792136218; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DhSjNxqbm4HcT9hh0RRIJr4WnJT+XPSewhpuWWrAjrI=;
        b=iWa3rHM2a1NtGLJb9ZzRczEoG8FrEUn0HrdKhkHwP08QeMIrwvIBKUA5MzIJZ/dUmw
         4IcxntnFbGzoBvBHYzmhs5HgoW9M65ChZ7raKHXn15THmmtaYHhWw+o4WPKJE8gz9C3l
         mxht/qCqG3NH6tr2hkcM1pImjtNhhVRpHR9NXYoOrfGNtboUxNkXTXAC5JqkcXR4CgWD
         VEUEyxz+RjzrQiULMvL4c0UwRFElHIITGFNk42+Ynkbfw7GDnwivAFNGttur5lqqdiy6
         pczv8V7WprJWPQRpEvQOSeqCbl/QOTxQI2neAp4yGAUnB6gJS6tISZx07Oc2uXc6fPr+
         pKjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791531418; x=1792136218;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DhSjNxqbm4HcT9hh0RRIJr4WnJT+XPSewhpuWWrAjrI=;
        b=TUFds7Pkxt9uoJTDGbt2E6OHkx/U/AP4OqRbXQR+1wvcr5s4TUOhkyB3r1AZVtNCvx
         Hl4H2PsHD6jFYSzDf58WPOHDddyLQWfePkIjHtiddWChy9/VYhpxbQWRuMgfOmyALZ+Q
         lkdHhieWa8Q/cWjqeIpPWXXF/vyeGhMZwote4sO7ijSi5fmVtTCU/SNqWY/8NybUzKOo
         Qk0/yk+jY14JWamClF5emy/KyigLtbopbYqFvN3HCI8UayYZ2Ghjksf6POU5xSpyzB7q
         cNxFQtt3Ex7W7BBe/BKUC0eDEbv4TlBeS99YnDzEoZYUDNiquVmEonMqX/NVqENSd6P9
         GWnA==
X-Forwarded-Encrypted: i=1; AKwUvBwv97rV0qVw01bIhC7Z64qQ/qFiveQ0D5plyQB4hWqS7HTBfvD27ymRomrRjwh/WmVtftYCCtQ=@lists.linux.dev
X-Gm-Message-State: AFq9FYJjKhwMlL2USOvWKF9C2Ftn2XAHP/9vEQCVzyDil0aFI4ua3/Aq
	Nd41JyJBIskPTISs0NNulEfX95OhREjDOqnwTAxiswKGZvaEzwEw2IjBZeMD83FcpKXUo22wUor
	YQwHcIQ9Sikncift+fgXgT4sujv5dMB0=
X-Gm-Gg: AYBFou1nvx4OE3OCtHItWins37Ch0PKC8Yo/qQikAOiaj4UGwjCSw8ltJ5xhViB5qd3
	GPybmJ8ltQU4bS686rSLaLnIM1S3p6WUFpEelROa+IqXHpbjVfTiJtzwELRdOLF2Dd2lDq3V64l
	PR14xeyPrdz6pfdGSGoHVJjoJ0rZq2joCrZNxR8ghl1djxjpYoO+TtAnpuLzrjVQuvqQcjH/yZ8
	rkDK7n0rdRfpxaygPXtsI4npZLjW9bE+t15LTRxbD2m14XYtc4gbNHdo3+ItwxwZ5oLcJK8vdR5
	CGgvHZcm9xpuU0qIwbyGgypnYvLKptkSR7BrzwHHYI8j/u6eZsJDn5/s
X-Received: by 2002:a05:6402:5c8:b0:6ac:62aa:e3bc with SMTP id
 4fb4d7f45d1cf-6b17c2942a5mr781703a12.9.1791531417888; Fri, 09 Oct 2026
 00:36:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261008112004.1899560-1-mszeredi@redhat.com> <20261008112004.1899560-5-mszeredi@redhat.com>
In-Reply-To: <20261008112004.1899560-5-mszeredi@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 9 Oct 2026 09:36:45 +0200
X-Gm-Features: AclHuK_71_unbNtN5QAuP7E5DNG3AQphRS8x1gOfZa03ukUeAASAlNMwd4zqZhQ
Message-ID: <CAOQ4uxi5gLR5xUjmg5v_byPF1SUhzCv=iWT1xzNok3GTy09tZw@mail.gmail.com>
Subject: Re: [PATCH v4 4/9] fuse: support 64 bit, server allocated backing ID
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: fuse-devel@lists.linux.dev, John Groves <john@groves.net>, 
	"Darrick J . Wong" <djwong@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Alison Schofield <alison.schofield@intel.com>, 
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 8, 2026 at 1:20=E2=80=AFPM Miklos Szeredi <mszeredi@redhat.com>=
 wrote:
>
> Add support for server allocated 64-bit backing IDs alongside the
> existing kernel allocated 32-bit IDs.
>
> Opened with FUSE_DEV_IOC_BACKING_CREATE, the backing ID sent via
> fuse_backing_create_in.backing_id.
>
> Closed with FUSE_NOTIFY_BACKING_REMOVE.  Since close only provides the
> backing ID, not the file descriptor, it doesn't have to be done with an
> ioctl.
>
> Backing ID can take any 64 bit value other than zero.
>
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> ---
>  fs/file.c                 |   1 +
>  fs/fuse/backing.c         | 178 ++++++++++++++++++++++++++++----------
>  fs/fuse/dev.c             |  54 +++++++++---
>  fs/fuse/dev.h             |   3 +
>  fs/fuse/fuse_i.h          |  21 ++++-
>  fs/fuse/inode.c           |   8 +-
>  fs/fuse/notify.c          |  28 ++++++
>  fs/fuse/passthrough.c     |   3 +
>  include/uapi/linux/fuse.h |  22 ++++-
>  9 files changed, 252 insertions(+), 66 deletions(-)
>
[...]

>  int fuse_backing_open(struct fuse_conn *fc, struct fuse_backing_map *map=
);
>  int fuse_backing_close(struct fuse_conn *fc, int backing_id);
> +int fuse_backing_open_64(struct fuse_conn *fc, struct fuse_backing_creat=
e_in *map);
> +int fuse_backing_close_64(struct fuse_conn *fc, u64 backing_id);
>
>  int fuse_copy_one(struct fuse_copy_state *cs, void *val, unsigned size);
>  int fuse_copy_folio(struct fuse_copy_state *cs, struct folio **foliop,
> diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> index d9ec88028d7b..b1e450f096f6 100644
> --- a/fs/fuse/fuse_i.h
> +++ b/fs/fuse/fuse_i.h
> @@ -32,6 +32,7 @@
>  #include <linux/pid_namespace.h>
>  #include <linux/refcount.h>
>  #include <linux/user_namespace.h>
> +#include <linux/rhashtable-types.h>
>
>  /** Default max number of pages that can be used in a single read reques=
t */
>  #define FUSE_DEFAULT_MAX_PAGES_PER_REQ 32
> @@ -92,7 +93,8 @@ struct fuse_submount_lookup {
>  struct fuse_backing {
>         struct file *file;
>         const struct cred *cred;
> -
> +       u64 backing_id;
> +       struct rhash_head hash_node;
>         /* refcount */
>         refcount_t count;
>         struct rcu_head rcu;
> @@ -713,6 +715,9 @@ struct fuse_conn {
>         /** @passthrough: Passthrough support for read/write IO */
>         unsigned int passthrough:1;
>
> +       /** @backing_id_64: Backing ID is 64 bit and allocated by the ser=
ver */
> +       bool backing_id_64:1;
> +
>         /** @use_pages_for_kvec_io: Use pages instead of pointer for kern=
el I/O */
>         unsigned int use_pages_for_kvec_io:1;
>
> @@ -770,8 +775,14 @@ struct fuse_conn {
>         struct fuse_sync_bucket __rcu *curr_bucket;
>
>  #ifdef CONFIG_FUSE_PASSTHROUGH
> -       /** @backing_files_map: IDR for backing files ids */
> -       struct idr backing_files_map;
> +       /* Selected by backing_id_64 */
> +       union {
> +               /** @backing_files_map: IDR for backing files ids */
> +               struct idr backing_files_map;
> +
> +               /** @backing_64_ht: 64 bit ID lookup hash table */
> +               struct rhashtable backing_64_ht;
> +       };
>  #endif
>  };
>
> @@ -1270,7 +1281,7 @@ void fuse_file_release(struct inode *inode, struct =
fuse_file *ff,
>  /* backing.c */
>  #ifdef CONFIG_FUSE_PASSTHROUGH
>  void fuse_backing_put(struct fuse_backing *fb);
> -struct fuse_backing *fuse_backing_lookup(struct fuse_conn *fc, int backi=
ng_id);
> +
>  #else
>
>  static inline void fuse_backing_put(struct fuse_backing *fb)
> @@ -1278,7 +1289,9 @@ static inline void fuse_backing_put(struct fuse_bac=
king *fb)
>  }
>  #endif
>
> +struct fuse_backing *fuse_backing_lookup(struct fuse_conn *fc, u64 backi=
ng_id);
>  void fuse_backing_files_init(struct fuse_conn *fc);
> +void fuse_backing_files_init_64(struct fuse_conn *fc);
>  void fuse_backing_files_free(struct fuse_conn *fc);
>
>  /* passthrough.c */
> diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> index cbb10e19e7e8..b69c95ebb1ad 100644
> --- a/fs/fuse/inode.c
> +++ b/fs/fuse/inode.c
> @@ -1408,13 +1408,17 @@ static void process_init_reply(struct fuse_args *=
args, int error)
>                          * them together.
>                          */
>                         if (IS_ENABLED(CONFIG_FUSE_PASSTHROUGH) &&
> -                           (flags & FUSE_PASSTHROUGH) &&
> +                           (flags & (FUSE_PASSTHROUGH | FUSE_PASSTHROUGH=
_V2)) &&
>                             arg->max_stack_depth > 0 &&
>                             arg->max_stack_depth <=3D FILESYSTEM_MAX_STAC=
K_DEPTH &&
>                             !(flags & FUSE_WRITEBACK_CACHE))  {
>                                 fc->passthrough =3D 1;
>                                 fc->max_stack_depth =3D arg->max_stack_de=
pth;
>                                 fm->sb->s_stack_depth =3D arg->max_stack_=
depth;
> +                               if (flags & FUSE_PASSTHROUGH_V2) {
> +                                       fc->backing_id_64 =3D true;
> +                                       fuse_backing_files_init_64(fc);
> +                               }
>                         }
>                         if (flags & FUSE_NO_EXPORT_SUPPORT)
>                                 fm->sb->s_export_op =3D &fuse_export_fid_=
operations;

Much better, but I still think it is somewhat ugly to call
fuse_backing_files_init_64()
after fuse_backing_files_init() for an init of a union.

Don't you think this is cleaner?

Thanks,
Amir.

diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 330655af3bd0f..9abf6b1afef5d 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -996,9 +996,6 @@ void fuse_conn_init(struct fuse_conn *fc, struct
fuse_mount *fm,
        fc->max_pages_limit =3D fuse_max_pages_limit;
        fc->name_max =3D FUSE_NAME_LOW_MAX;

-       if (IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))
-               fuse_backing_files_init(fc);
-
        INIT_LIST_HEAD(&fc->mounts);
        list_add(&fm->fc_entry, &fc->mounts);
        fm->fc =3D fc;
@@ -1424,10 +1421,8 @@ static void process_init_reply(struct fuse_args
*args, int error)
                                fc->passthrough =3D 1;
                                fc->max_stack_depth =3D arg->max_stack_dept=
h;
                                fm->sb->s_stack_depth =3D arg->max_stack_de=
pth;
-                               if (flags & FUSE_PASSTHROUGH_V2) {
-                                       fc->backing_id_64 =3D true;
-                                       fuse_backing_files_init_64(fc);
-                               }
+                               fc->backing_id_64 =3D !!(flags &
FUSE_PASSTHROUGH_V2);
+                               fuse_backing_files_init(fc);
                        }
                        if (flags & FUSE_NO_EXPORT_SUPPORT)
                                fm->sb->s_export_op =3D
&fuse_export_fid_operations;
diff --git a/fs/fuse/backing.c b/fs/fuse/backing.c
index c93e4a45dd6f6..6157a18b5d554 100644
--- a/fs/fuse/backing.c
+++ b/fs/fuse/backing.c
@@ -46,11 +46,6 @@ void fuse_backing_put(struct fuse_backing *fb)
                fuse_backing_free(fb);
 }

-void fuse_backing_files_init(struct fuse_conn *fc)
-{
-       idr_init(&fc->backing_files_map);
-}
-
 static int fuse_backing_id_alloc(struct fuse_conn *fc, struct fuse_backing=
 *fb)
 {
        int id;
@@ -338,6 +333,9 @@ void fuse_backing_files_free(struct fuse_conn *fc)
        struct rhashtable_iter iter;
        struct fuse_backing *fb;

+       if (!fc->passthrough)
+               return;
+
        if (!fc->backing_id_64) {
                idr_for_each(&fc->backing_files_map,
fuse_backing_idr_free, NULL);
                idr_destroy(&fc->backing_files_map);
@@ -369,7 +367,12 @@ void fuse_backing_files_free(struct fuse_conn *fc)
        rhashtable_free_and_destroy(&fc->backing_64_ht,
fuse_backing_rht_free, NULL);
 }

-void fuse_backing_files_init_64(struct fuse_conn *fc)
+void fuse_backing_files_init(struct fuse_conn *fc)
 {
+       if (!fc->backing_id_64) {
+               idr_init(&fc->backing_files_map);
+               return;
+       }
+
        rhashtable_init(&fc->backing_64_ht, &fuse_backing_prm);
 }
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 064fed459b93c..4235b8fc669b0 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -1324,7 +1324,6 @@ struct fuse_backing *fuse_backing_lookup(struct
fuse_conn *fc, u64 backing_id);
 int fuse_backing_add_64(struct fuse_conn *fc, struct fuse_backing *fb);
 bool fuse_backing_is_dax(struct fuse_backing *fb);
 void fuse_backing_files_init(struct fuse_conn *fc);
-void fuse_backing_files_init_64(struct fuse_conn *fc);
 void fuse_backing_files_free(struct fuse_conn *fc);
