Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B483211
	for <nvdimm@lists.linux.dev>; Wed, 21 Sep 2022 12:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663762584;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lRz/z/AXpEruTQsHU4EAQEPc0Y+Waw+jrJW7+kWECyI=;
	b=HC1WaawmTydvuc2LUpWkM8stA646rPW9rVnWDrInzSOEHFSiILBF18jfAL1GdizbpJQK/u
	ATYiFKN3pCjg/fZXJm+VhXq52z3jAgSGoFIvFDX3jQGZPePiTamidNb9XxlYWvBvFDOQrg
	c6o/b/+e4R6BXmQK9oHEDomgVU9bwx0=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-640-qi508fXuMVedKd2mzLgsZQ-1; Wed, 21 Sep 2022 08:16:23 -0400
X-MC-Unique: qi508fXuMVedKd2mzLgsZQ-1
Received: by mail-pf1-f200.google.com with SMTP id k19-20020a056a00135300b0054096343fc6so3484282pfu.10
        for <nvdimm@lists.linux.dev>; Wed, 21 Sep 2022 05:16:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=lRz/z/AXpEruTQsHU4EAQEPc0Y+Waw+jrJW7+kWECyI=;
        b=m5VwCGMqW9QOelhwYYOJi+9pvwsbWu4F4hXT3A8alwcJRRWRohuJGEFi3BFpYHhgYO
         E3QRjN0DZg93su2u3n3Usw5TE/tsU/0NpkI5WA/08vvnvCSp8hNgVk8ReaLRFKLYCKsA
         1DcJHHqBGu8QKH5GIHKeGR7Kx+l7wEnPYokEB/7mQbZsMfu3ZBkxunNjd6YKNuSqCXV3
         +6TK9sebyOzs4NeWg5tlFz2ZELKIBdGBlw4c/ySHIUvM4meTy2IRf0ta2Qh5vO5hiSss
         vXK8PA2ENnlF6k/F725hMRDmwViZgRbttnIS1DwRA9QW+ETdOk2cH+V11bP4FwQwAHmo
         6KfA==
X-Gm-Message-State: ACrzQf2PuFBlksg+laI9HAiBvwaB76QKmFYJRkCvfCc+Ou9DKIBYQhrw
	j1uj0QEP80/qAMa5NMG7cHH4N6d1dSIzvi1JNzTZgranxHQvPm06UeyHawCi3fi4sRClofjPt+l
	46iWqnGla48AwlZ9RiyX9yKveNWua6mV4
X-Received: by 2002:a05:6a00:114c:b0:528:2c7a:6302 with SMTP id b12-20020a056a00114c00b005282c7a6302mr28503659pfm.37.1663762582639;
        Wed, 21 Sep 2022 05:16:22 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5r/ijjU2c5rOZiLzk/NojDFwRsD3xgDKZQeggVJqltBvK5luALhPFt8HfhxhdtEdOtWZNDc8CkV8CGgvipPTc=
X-Received: by 2002:a05:6a00:114c:b0:528:2c7a:6302 with SMTP id
 b12-20020a056a00114c00b005282c7a6302mr28503640pfm.37.1663762582408; Wed, 21
 Sep 2022 05:16:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220721121152.4180-1-colyli@suse.de> <20220721121152.4180-2-colyli@suse.de>
In-Reply-To: <20220721121152.4180-2-colyli@suse.de>
From: Xiao Ni <xni@redhat.com>
Date: Wed, 21 Sep 2022 20:16:11 +0800
Message-ID: <CALTww2_raNwb3j9evCWi4LD3FqBpW9+hugKw9-OEU+0LG25DBA@mail.gmail.com>
Subject: Re: [PATCH v6 1/7] badblocks: add more helper structure and routines
 in badblocks.h
To: Coly Li <colyli@suse.de>
Cc: linux-block@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-raid <linux-raid@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>, 
	Geliang Tang <geliang.tang@suse.com>, Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>, 
	NeilBrown <neilb@suse.de>, Vishal L Verma <vishal.l.verma@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"

On Thu, Jul 21, 2022 at 8:12 PM Coly Li <colyli@suse.de> wrote:
>
> This patch adds the following helper structure and routines into
> badblocks.h,
> - struct badblocks_context
>   This structure is used in improved badblocks code for bad table
>   iteration.
> - BB_END()
>   The macro to calculate end LBA of a bad range record from bad
>   table.
> - badblocks_full() and badblocks_empty()
>   The inline routines to check whether bad table is full or empty.
> - set_changed() and clear_changed()
>   The inline routines to set and clear 'changed' tag from struct
>   badblocks.
>
> These new helper structure and routines can help to make the code more
> clear, they will be used in the improved badblocks code in following
> patches.
>
> Signed-off-by: Coly Li <colyli@suse.de>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Geliang Tang <geliang.tang@suse.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: NeilBrown <neilb@suse.de>
> Cc: Vishal L Verma <vishal.l.verma@intel.com>
> Cc: Xiao Ni <xni@redhat.com>
> ---
>  include/linux/badblocks.h | 30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
>
> diff --git a/include/linux/badblocks.h b/include/linux/badblocks.h
> index 2426276b9bd3..670f2dae692f 100644
> --- a/include/linux/badblocks.h
> +++ b/include/linux/badblocks.h
> @@ -15,6 +15,7 @@
>  #define BB_OFFSET(x)   (((x) & BB_OFFSET_MASK) >> 9)
>  #define BB_LEN(x)      (((x) & BB_LEN_MASK) + 1)
>  #define BB_ACK(x)      (!!((x) & BB_ACK_MASK))
> +#define BB_END(x)      (BB_OFFSET(x) + BB_LEN(x))
>  #define BB_MAKE(a, l, ack) (((a)<<9) | ((l)-1) | ((u64)(!!(ack)) << 63))
>
>  /* Bad block numbers are stored sorted in a single page.
> @@ -41,6 +42,12 @@ struct badblocks {
>         sector_t size;          /* in sectors */
>  };
>
> +struct badblocks_context {
> +       sector_t        start;
> +       sector_t        len;
> +       int             ack;
> +};
> +
>  int badblocks_check(struct badblocks *bb, sector_t s, int sectors,
>                    sector_t *first_bad, int *bad_sectors);
>  int badblocks_set(struct badblocks *bb, sector_t s, int sectors,
> @@ -63,4 +70,27 @@ static inline void devm_exit_badblocks(struct device *dev, struct badblocks *bb)
>         }
>         badblocks_exit(bb);
>  }
> +
> +static inline int badblocks_full(struct badblocks *bb)
> +{
> +       return (bb->count >= MAX_BADBLOCKS);
> +}
> +
> +static inline int badblocks_empty(struct badblocks *bb)
> +{
> +       return (bb->count == 0);
> +}
> +
> +static inline void set_changed(struct badblocks *bb)
> +{
> +       if (bb->changed != 1)
> +               bb->changed = 1;
> +}
> +
> +static inline void clear_changed(struct badblocks *bb)
> +{
> +       if (bb->changed != 0)
> +               bb->changed = 0;
> +}
> +
>  #endif
> --
> 2.35.3
>

Reviewed-by: Xiao Ni <xni@redhat.com>

