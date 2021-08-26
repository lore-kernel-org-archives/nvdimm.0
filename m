Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA8E3FCB
	for <nvdimm@lists.linux.dev>; Thu, 26 Aug 2021 14:42:21 +0000 (UTC)
Received: by mail-pj1-f52.google.com with SMTP id fz10so2389730pjb.0
        for <nvdimm@lists.linux.dev>; Thu, 26 Aug 2021 07:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ABTfU8gxdjv5n74FbYsyCDi8X7MNpO1jIxZ8zrk/JGc=;
        b=RnM+EalWmI3PqG7GROErhErzyPvDbZCl0KTyuEsZ8rvwaXbCmLGYFo0yra0yZXKsar
         gK732TMBNazrj5DR9ByMd3UdZOzjU1wCyhqFo++Dz5dnNmiau+yIflCs68+Qtk0bLvmD
         WU1qzs7I1dCdU4qAnLydv3o+dt60dwm1PpLP6xm8EaBkpVmN7pzNVF0vda5VBS3dKner
         IhF1jpU2gcPXjHxcJXA2tfQz0eUeS8yYMY+eKVIyig67TB1zvew32ziVngCOkemv3QEj
         yppNGbWtyBRoXelyhp6VliZ0pKhRgYBRfs19XpiXUpK4P59cmR42IxfV7c+kphMG8VWg
         3BCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ABTfU8gxdjv5n74FbYsyCDi8X7MNpO1jIxZ8zrk/JGc=;
        b=hsiGWhn/NVy3BRxxDUgq9KgZ7LOoDbMwBhcqihlL1+dt06BOH40x52KA4TgqSlnIHA
         2OwTjwa96thnpNE+IC76cwv/eknDt7ilqM8uKmF74uXHq5CbLx0QtryI36yZzZTRNA0W
         n6teVowKLPFX1FSKmB2mkXiJvl6WE/qci7EmiE3nMIyQSoXNyS9RBeeIMUnErQwpidqA
         dVvn4wKpSZDV/peimpq3mLWrGUcU214Z+HKpHO+OMMCcCKNJWK2BvGiDHuciXIQuT4xR
         tOU29Zuqcb/hjI+RCaUOPKK1qyYOqB4cPySJcrQHyDGnH00QRw/SmrTKlS4aYn3vD2jh
         VmxQ==
X-Gm-Message-State: AOAM533FX270gkZNVd35kmDG0K3TUcVa8N3LU93uR1EHzvFSZj0xicTC
	j0ReDcwje3nZh3fej/XalfPOwoN3b5Vk3sw/jdtGyw==
X-Google-Smtp-Source: ABdhPJzO1UFjPYxjHHDbPPyTeWuvMW2jYmROew+jJbFtaVcDFYVCU8mx/aezSMbrIMNKUs0Szwc4PU9+n1E6cYIivVo=
X-Received: by 2002:a17:902:ba90:b0:135:6709:705 with SMTP id
 k16-20020a170902ba9000b0013567090705mr3869473pls.79.1629988941096; Thu, 26
 Aug 2021 07:42:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210826135510.6293-1-hch@lst.de> <20210826135510.6293-4-hch@lst.de>
In-Reply-To: <20210826135510.6293-4-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 26 Aug 2021 07:42:10 -0700
Message-ID: <CAPcyv4ieXdjgxE+PkcUjuL7vdcnQfXhb_1aG2YeLtX9BZWVQfQ@mail.gmail.com>
Subject: Re: [PATCH 3/9] dm: use fs_dax_get_by_bdev instead of dax_get_by_host
To: Christoph Hellwig <hch@lst.de>
Cc: Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Mike Snitzer <snitzer@redhat.com>, Matthew Wilcox <willy@infradead.org>, 
	linux-xfs <linux-xfs@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, Aug 26, 2021 at 6:59 AM Christoph Hellwig <hch@lst.de> wrote:
>
> There is no point in trying to finding the dax device if the DAX flag is
> not set on the queue as none of the users of the device mapper exported
> block devices could make use of the DAX capability.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/md/dm.c | 2 +-

Mike, any objections to me taking this through a dax branch?

>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 2c5f9e585211..465714341300 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -650,7 +650,7 @@ static int open_table_device(struct table_device *td, dev_t dev,
>         }
>
>         td->dm_dev.bdev = bdev;
> -       td->dm_dev.dax_dev = dax_get_by_host(bdev->bd_disk->disk_name);
> +       td->dm_dev.dax_dev = fs_dax_get_by_bdev(bdev);
>         return 0;
>  }
>
> --
> 2.30.2
>
