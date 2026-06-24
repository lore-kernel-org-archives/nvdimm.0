Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F7D37106A
	for <nvdimm@lists.linux.dev>; Wed, 24 Jun 2026 17:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782321747; cv=pass; b=DuyF2ziJLj2kKfVKs3ihHO0CKElTjd6R8o3HdvyiOXnjjlrDmo8t0/k+3JZUk+rdzwOR05hAwmF7i0GQ2N6v5DKLXd0cjV7wa+F8AYAcLeo4+2PqtDdiJlYBuC4n2x4lcS4eZL0kOgdrJqLvsc2OyB3Yj4Ytl3hjmaUWG6Lkl+c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782321747; c=relaxed/simple;
	bh=Oc/eY5jh1sixVZt7TvGpIpQcD6r6ROfPjIuguTla2ts=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qWaY4BxwlA7SCORVtmmD5ChW57kt9VrIidIK3Abfml7ycviUlH3FPdBFR70HDw3zZJMO2HoHP6HgVmiA8CZv1i5Aou1edpDFMdqcNEpbThvWx+xYF5+RHCvSMRIOo9QqZdDLRs4jPgkpJALVzO1PUOdLkVXEKOAMLfQxWY9K0ZA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=am2p5v/o; arc=pass smtp.client-ip=209.85.160.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="am2p5v/o"
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-447a81776e9so642584fac.0
        for <nvdimm@lists.linux.dev>; Wed, 24 Jun 2026 10:22:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782321745; cv=none;
        d=google.com; s=arc-20240605;
        b=TFh9IlI3VbbSYG/W63abgndzcqKgqDDz8qNIWJccmJPcouWpAWx7p4eeB7OMnJZ2jQ
         esG6NoNa87MX/q9dnYdWzmhP6FZkqNpCbUThsdfs0++HZPplGUPKCDNlWroYRAda/EGf
         pC458mOnFY3iTBvGqE1QOElLgOHEZQNiW2zSy4BJ0zFAI3c9Wv0p1Z9mrOSpbiJUD0jv
         Q6Ly+ID82FLhPyWc+NDSrPt6Foyfnk9sx9aUNjna07gUhoJgX6AuDSutp7R66BfCFYWd
         +5El82BHrTOHxixHvA0bnyGIBGbxGxHDNoaC/hkWXcJ6w8L42LD/IOcVcOIdm/xgaJ9W
         8bWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=2RrZQKRnOe4vqE7AGHYXjMuRZiw2LXHf5wiJxvLR544=;
        fh=cO2gTisNN3UwhSDIImYnZofJb1ep6YtCwaT1cgSL1zw=;
        b=V9IMLSn+6QEo33kCFg+k2NNiprEiF924mGCoAI9Dm9kWUFdoIFKTICRcOtxpOg8kXu
         EGwTPE3Qqq2nM2/IiQLz4adVYCPRUoLsGy6IJn2ZLrog8nkLoqLN+jIHEJKK6kt4au2k
         VP2q6NxxafNpLByDh8JTRn5ABiv/d1N3EoPFd0vNo8JuFqXJHSLtj2T3NM3NiWyxW7e8
         E/Mt5B2iIXA6aVAQevty314/Vte+HROfuMCayGss+pHX4Dea8e1QsJc6d8Fl6g//lNO1
         wKkbF9eW3T8gupTosusfrctikaN2UQnJHp5GzQ5y7LkKM6AIVkP/1QUWqe8Tuf3tir63
         55lw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782321745; x=1782926545; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2RrZQKRnOe4vqE7AGHYXjMuRZiw2LXHf5wiJxvLR544=;
        b=am2p5v/oedK5/vTFkzAqZ9xCxaO0FnxxuDGHbPO1HEiu/F3BDb24KIGueq9dWwgntT
         nNidVFnjkswA6smV0l5Sed1BLLn7yqrGA8VQyyzxshSJy6Bgu0FAD0ZkQma7dxOdrhT+
         rXdEizxzPB6vpBf7eMMpwTMyl6fjTlyiYbqSBsccabk/gsxIt7FgoRSAK+FFJYHoIr5T
         WcNpKFtCNK2xD2HQkUaNQtxoI+16NAUFGG8KN3zPuL4WWFcrTf1vP00bwQipppz9YwJv
         AnYVt2TUo6XKnHaJ+S7DHHyV22I79HZ7AF1UjWtpcPEHssY9GJ+YQrFFJFYkVHjn7XeV
         0SiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782321745; x=1782926545;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2RrZQKRnOe4vqE7AGHYXjMuRZiw2LXHf5wiJxvLR544=;
        b=qg9MVwIxdxByY6TnKsqVFFdPCa4fasFYhG2XmYrI+mggwxHf4VyHEPqIyejU4TIOvE
         4xU+nbwl+4/VB+riqWZz3X6LkvNWkRc8FVn9cxXRIG9y2oFBtBm2pB0e/dEtUyjwT/9X
         7xKteGXyy4lvS73i8i3DFwyYq2NK2THonnXFjkKqv8amgiPg2k+yIgCd9ab3UalKvS14
         NdCkwfG6aJNeDFLYf9ybcQOnaoFWvTK/vRk4LzegolIsoeeuODq3hoDOMCpNaSFjMAb+
         2hfG6O7DETVkHLJxML9zFuAmG4p4wlhMxE5vdA1LmrboHi2/Pp8UHnvsLKpx0E7QBjQ9
         z6KA==
X-Forwarded-Encrypted: i=1; AFNElJ+uU+pZ4MWQl0TrxAW58LxcjHrzJudqunbQ5UU2QNDR3N4ZcMoPaz+SKD95FQeeJOxATI6CvjQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyn+CdDDzG2zPVSQcOnR+6AhM1mZA5XMxtrLCFJDbUYxasr3gio
	dd0YD25yIqId9w0yARq+048zMzDwPLWmixLTADR0TfFAiLWKBpROR8TPQaHOh4/GHyVxb4JAF7N
	clmOA30oKqJ8DW/NrpEiGE3+psakibnI=
X-Gm-Gg: AfdE7cmF0x3Qu791Tirx7Pjh+/tsZqgRqyDrq8hrUvnzPSSqco/Ug6FFfhZ0whwx96r
	PT8FXx0xEHTKnbh8qA+r5ThnNeyMYTW435/KGnoj8Togljgl9X5z/V6e0/ORBzM3Cnk6Dzrz8VE
	ALQonyqlLEpK8vhL1QGXcjFUjRCHSgRvjMzprHZu39+0OEpIMrXCCPXOXicUC+1gzk7hev5BolM
	cdO9kySnkeHzoTlJTp/SSP6rUwdKYOFTtJmXpELMM9ZJA7WdZNbPWR/3rvjcR2alWCz1DUPAQmq
	bnhiA0wRnQ==
X-Received: by 2002:a05:6820:1525:b0:69e:89dd:175a with SMTP id
 006d021491bc7-6a114b61692mr6128235eaf.20.1782321745533; Wed, 24 Jun 2026
 10:22:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260621130246.2973254-1-me@linux.beauty> <20260621130246.2973254-5-me@linux.beauty>
In-Reply-To: <20260621130246.2973254-5-me@linux.beauty>
From: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date: Wed, 24 Jun 2026 19:22:14 +0200
X-Gm-Features: AVVi8Cf9CFjt8XRurzmaliLJiEImYmVwDzh1HgALE4ORiap4zi56uRvfI8NkH6Q
Message-ID: <CAM9Jb+gzSrobPgH_nMPs+RsbhVP8jovpAQsC5syQKoLrtqnX=A@mail.gmail.com>
Subject: Re: [PATCH v6 04/12] nvdimm: virtio_pmem: stop allocating child flush bio
To: Li Chen <me@linux.beauty>
Cc: Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Alison Schofield <alison.schofield@intel.com>, virtualization@lists.linux.dev, 
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> pmem_submit_bio() passes the parent bio to nvdimm_flush() for
> REQ_FUA. For virtio-pmem this makes async_pmem_flush() allocate
> and submit a child PREFLUSH bio chained to the parent.
>
> That child allocation is in the block submit path. Making it
> blocking with GFP_NOIO can consume the same global bio mempool that
> submit_bio() uses, while making it GFP_ATOMIC can fail under
> pressure. A forced failure of the child allocation produced:
>
> virtio_pmem: forcing child bio allocation failure for test
> Buffer I/O error on dev pmem0, logical block 0, lost sync page write
> EXT4-fs (pmem0): I/O error while writing superblock
> EXT4-fs (pmem0): mount failed
>
> Avoid the child bio completely. Flush FUA synchronously, like
> REQ_PREFLUSH, then complete the parent after the flush. Since no
> child bio can be created, async_pmem_flush() now only issues the
> virtio flush and preserves negative errno values.

Child flush is asynchronous (performs async flush to host side and returns).
Till child bio completes guest userspace waits in pending IO state.
It seems the current change will affect the behavior?

Prior RFC [1] attempted to coalesce the async FLUSH request between guest &host.
If there is interest, that approach could be revisited or integrated here?

[1] https://lore.kernel.org/all/20220111161937.56272-1-pankaj.gupta.linux@gmail.com/#t

Thanks,
Pankaj

>
> Signed-off-by: Li Chen <me@linux.beauty>
> ---
> Changes in v6:
> - Replace the child bio allocation fix with synchronous FUA flushing.
>
>  drivers/nvdimm/nd_virtio.c | 22 ++++------------------
>  drivers/nvdimm/pmem.c      |  2 +-
>  2 files changed, 5 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
> index 4176046627beb..4b2e9c47af0f5 100644
> --- a/drivers/nvdimm/nd_virtio.c
> +++ b/drivers/nvdimm/nd_virtio.c
> @@ -110,27 +110,13 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
>  /* The asynchronous flush callback function */
>  int async_pmem_flush(struct nd_region *nd_region, struct bio *bio)
>  {
> -       /*
> -        * Create child bio for asynchronous flush and chain with
> -        * parent bio. Otherwise directly call nd_region flush.
> -        */
> -       if (bio && bio->bi_iter.bi_sector != -1) {
> -               struct bio *child = bio_alloc(bio->bi_bdev, 0,
> -                                             REQ_OP_WRITE | REQ_PREFLUSH,
> -                                             GFP_ATOMIC);
> +       int err;
>
> -               if (!child)
> -                       return -ENOMEM;
> -               bio_clone_blkg_association(child, bio);
> -               child->bi_iter.bi_sector = -1;
> -               bio_chain(child, bio);
> -               submit_bio(child);
> -               return 0;
> -       }
> -       if (virtio_pmem_flush(nd_region))
> +       err = virtio_pmem_flush(nd_region);
> +       if (err > 0)
>                 return -EIO;
>
> -       return 0;
> +       return err;
>  };
>  EXPORT_SYMBOL_GPL(async_pmem_flush);
>  MODULE_DESCRIPTION("Virtio Persistent Memory Driver");
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 82ee1ddb3a445..058d2739c95a1 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -242,7 +242,7 @@ static void pmem_submit_bio(struct bio *bio)
>         }
>
>         if ((bio->bi_opf & REQ_FUA) && !bio->bi_status)
> -               ret = nvdimm_flush(nd_region, bio);
> +               ret = nvdimm_flush(nd_region, NULL);
>
>         if (ret)
>                 bio->bi_status = errno_to_blk_status(ret);
> --
> 2.52.0
