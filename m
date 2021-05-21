Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9027A70
	for <nvdimm@lists.linux.dev>; Fri, 21 May 2021 17:16:49 +0000 (UTC)
Received: by mail-pl1-f180.google.com with SMTP id t9so2882418ply.6
        for <nvdimm@lists.linux.dev>; Fri, 21 May 2021 10:16:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/6CTfoP+3YhIDA2Sa2Vg3MwIl/4IQc5OvLMHtpk2uwk=;
        b=YtS+x1sl0oFOxNsEeWNfG8Axl0D5hvJWCpOQ+VQT64cEBaN5pXtMW43kfTZcVo9mza
         vEwzxyQy+aKcU1Lo5rPDlGvRUqQ4g+t11bS4RSo0C19BZgfrujKAldg291ZiXBcvhCm1
         HolSNXlbHfXXMG+QUoAtg1wsaeUR49MCR2a+x0Rz6u6UrXRNmg7JEH003fv19zZQMiKq
         z5tPAmUXhS87XwMnUqkrKUNyMf/aSrEzB98XR8wDKZapQxzs8XZCiIQdlG3ehYcGWMNA
         myT/GDEdrG3NyT2D1jGHgFapBuOyuFj8md0IOAcSCodPVVpF6nFRxzd6JF8Ns2eqIAVi
         wqSQ==
X-Gm-Message-State: AOAM530tefmevSKNmjdOxs6JlvQzHXv4eBJfAVSmA8mdVTMXm/hynUXR
	NISMfLJtqB0UHW+A2TcjxTA=
X-Google-Smtp-Source: ABdhPJxtynqdEQ1F/D+2PqiHL9NmQC5jqLXgWhG+E7yzr8uLp59ObRLAPQ67LxwzZAhslkMqhOa4cA==
X-Received: by 2002:a17:90a:590d:: with SMTP id k13mr12082927pji.68.1621617409049;
        Fri, 21 May 2021 10:16:49 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id q24sm4964064pgb.19.2021.05.21.10.16.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 10:16:47 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
	id 6461E423A3; Fri, 21 May 2021 17:16:46 +0000 (UTC)
Date: Fri, 21 May 2021 17:16:46 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Geert Uytterhoeven <geert@linux-m68k.org>,
	Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	Jim Paris <jim@jtan.com>, Joshua Morris <josh.h.morris@us.ibm.com>,
	Philip Kelleher <pjk1939@linux.ibm.com>,
	Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
	Matias Bjorling <mb@lightnvm.io>, Coly Li <colyli@suse.de>,
	Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Alex Dubov <oakad@yahoo.com>, Ulf Hansson <ulf.hansson@linaro.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	linux-xtensa@linux-xtensa.org, linux-m68k@vger.kernel.org,
	linux-raid@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-s390@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-bcache@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	drbd-dev@tron.linbit.com, linuxppc-dev@lists.ozlabs.org
Subject: Re: [dm-devel] [PATCH 01/26] block: refactor device number setup in
 __device_add_disk
Message-ID: <20210521171646.GA25017@42.do-not-panic.com>
References: <20210521055116.1053587-1-hch@lst.de>
 <20210521055116.1053587-2-hch@lst.de>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210521055116.1053587-2-hch@lst.de>

On Fri, May 21, 2021 at 07:50:51AM +0200, Christoph Hellwig wrote:
> diff --git a/block/genhd.c b/block/genhd.c
> index 39ca97b0edc6..2c00bc3261d9 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -335,52 +335,22 @@ static int blk_mangle_minor(int minor)

<-- snip -->

> -int blk_alloc_devt(struct block_device *bdev, dev_t *devt)
> +int blk_alloc_ext_minor(void)
>  {
> -	struct gendisk *disk = bdev->bd_disk;
>  	int idx;
>  
> -	/* in consecutive minor range? */
> -	if (bdev->bd_partno < disk->minors) {
> -		*devt = MKDEV(disk->major, disk->first_minor + bdev->bd_partno);
> -		return 0;
> -	}
> -

It is not obviously clear to me, why this was part of add_disk()
path, and ...

> diff --git a/block/partitions/core.c b/block/partitions/core.c
> index dc60ecf46fe6..504297bdc8bf 100644
> --- a/block/partitions/core.c
> +++ b/block/partitions/core.c
> @@ -379,9 +380,15 @@ static struct block_device *add_partition(struct gendisk *disk, int partno,
>  	pdev->type = &part_type;
>  	pdev->parent = ddev;
>  
> -	err = blk_alloc_devt(bdev, &devt);
> -	if (err)
> -		goto out_put;
> +	/* in consecutive minor range? */
> +	if (bdev->bd_partno < disk->minors) {
> +		devt = MKDEV(disk->major, disk->first_minor + bdev->bd_partno);
> +	} else {
> +		err = blk_alloc_ext_minor();
> +		if (err < 0)
> +			goto out_put;
> +		devt = MKDEV(BLOCK_EXT_MAJOR, err);
> +	}
>  	pdev->devt = devt;
>  
>  	/* delay uevent until 'holders' subdir is created */

... and why we only add this here now.

Other than that, this looks like a super nice cleanup!

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>

  Luis
