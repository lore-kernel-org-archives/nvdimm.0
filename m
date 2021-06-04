Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99BE670
	for <nvdimm@lists.linux.dev>; Fri,  4 Jun 2021 06:48:35 +0000 (UTC)
Received: by mail-pg1-f177.google.com with SMTP id 27so7102825pgy.3
        for <nvdimm@lists.linux.dev>; Thu, 03 Jun 2021 23:48:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fossix-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=BQWvJC5s5eM3wv6CMNUuU7NegMGtDLO5XucsEYO9Poc=;
        b=wUjAz0Q7vy0RdQQLDhtuh4NJFgjqB8kcFTgPBUeN6naahgiK8ldHsJxJEXNF/gIiLQ
         rJKa15pQLHfKHYwiPtW0BbpQefZ9Vm5fJRp4eMQ1mInOpN1ErBJ6orJv9iPKukDqGatn
         X/wvgvCBmmqxXh5hPM57uka+4yWDv7UMyn36k4Kjx2b5OwCIJGxbFvMTNGMqIpSKq7JZ
         xZF52mjhKEfmNoTTiNlS8nJJ82gxw0lFNMTUtObXCJOa4dm2I1323IkRGMmDEVsqSJyL
         YFfSlTG8/mm7Miy36u/2wTqL0zuHqhTbK+5zzD6Llw61d3FqKLjME2bVVB+b4TUy/X0Z
         BoZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=BQWvJC5s5eM3wv6CMNUuU7NegMGtDLO5XucsEYO9Poc=;
        b=t/eCzBT916L3QIIZQ+TFkOpf1BfIeSo4JG78s4yuyy/sI67GWWKug1Zoe7IIQBP0xo
         MkXm9QxksRsZAe8vDjE63jrC+FYESwbZV/5GDyAA4MlXNouQ0vp03c5bge5JDPPe+i82
         qvFvWRupLftzoZ4UzRmq/fOh095CLvt+DZxKDASd5ElafDy4PTMTx9o4G+5Ih3jRRgiE
         voR+gxY9VpLqdpzpe6VCaZW5fbDn/HcHTSv4KwhqjOj3RYrpz7XTUJHq1M/svgA2gV+z
         WZ1QhTTsrgmckKYa0FnP6ysijxN+3xQ6MRh7sm3s1rkBkDBYosnBKyM2NhXQvyEU+lTu
         w9xw==
X-Gm-Message-State: AOAM531DVu+7SVDleie4NwWVvDGrxytshxho5L77Ek4zOG4Q+Ee89QbJ
	XmtWQ2yFE+Du6uh1+dgHkWLAKA==
X-Google-Smtp-Source: ABdhPJx2UDloTP4aiPcPj38DSXAFTgLGFtShKK7vZ5nAtthJEC3mYqSS/8DwRVJOSkvzLdJ0gOJrqg==
X-Received: by 2002:a65:6884:: with SMTP id e4mr3422366pgt.71.1622789314969;
        Thu, 03 Jun 2021 23:48:34 -0700 (PDT)
Received: from localhost ([103.21.79.4])
        by smtp.gmail.com with ESMTPSA id m14sm947785pff.17.2021.06.03.23.48.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 23:48:34 -0700 (PDT)
From: Santosh Sivaraj <santosh@fossix.org>
To: Wu Bo <wubo40@huawei.com>, dan.j.williams@intel.com,
 vishal.l.verma@intel.com, dave.jiang@intel.com, ira.weiny@intel.com,
 bp@suse.de, rafael.j.wysocki@intel.com, mpe@ellerman.id.au,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
Cc: linfeilong@huawei.com, wubo40@huawei.com
Subject: Re: [PATCH] tools/testing/nvdimm: use vzalloc() instead of
 vmalloc()/memset(0)
In-Reply-To: <1622425715-146012-1-git-send-email-wubo40@huawei.com>
References: <1622425715-146012-1-git-send-email-wubo40@huawei.com>
Date: Fri, 04 Jun 2021 12:18:32 +0530
Message-ID: <87tumem8fz.fsf@desktop.fossix.local.i-did-not-set--mail-host-address--so-tickle-me>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Wu Bo <wubo40@huawei.com> writes:

> Use vzalloc() instead of vmalloc() and memset(0) to simpify
> the code.
>
> Signed-off-by: Wu Bo <wubo40@huawei.com>
> ---
>  tools/testing/nvdimm/test/nfit.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

LGTM,

Reviewed-by: Santosh S <santosh@fossix.org>

>
> diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
> index 54f367cbadae..258bba22780b 100644
> --- a/tools/testing/nvdimm/test/nfit.c
> +++ b/tools/testing/nvdimm/test/nfit.c
> @@ -1625,7 +1625,6 @@ static void *__test_alloc(struct nfit_test *t, size_t size, dma_addr_t *dma,
>  	if (rc)
>  		goto err;
>  	INIT_LIST_HEAD(&nfit_res->list);
> -	memset(buf, 0, size);
>  	nfit_res->dev = dev;
>  	nfit_res->buf = buf;
>  	nfit_res->res.start = *dma;
> @@ -1652,7 +1651,7 @@ static void *test_alloc(struct nfit_test *t, size_t size, dma_addr_t *dma)
>  	struct genpool_data_align data = {
>  		.align = SZ_128M,
>  	};
> -	void *buf = vmalloc(size);
> +	void *buf = vzalloc(size);
>  
>  	if (size >= DIMM_SIZE)
>  		*dma = gen_pool_alloc_algo(nfit_pool, size,
> -- 
> 2.30.0
