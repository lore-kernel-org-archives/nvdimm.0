Return-Path: <SRS0=cats=3Z=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 227C0C35247
	for <linux-nvdimm@archiver.kernel.org>; Wed,  5 Feb 2020 18:36:13 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EE7B821741
	for <linux-nvdimm@archiver.kernel.org>; Wed,  5 Feb 2020 18:36:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SE9i9hS0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EE7B821741
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 4789210FC33EF;
	Wed,  5 Feb 2020 10:39:30 -0800 (PST)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=2607:7c80:54:e::133; helo=bombadil.infradead.org; envelope-from=batv+a2b935cbc3c12af13a1b+6009+infradead.org+hch@bombadil.srs.infradead.org; receiver=<UNKNOWN> 
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 2410710FC33ED
	for <linux-nvdimm@lists.01.org>; Wed,  5 Feb 2020 10:39:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wOZCtDUg0G8yt+sIQgMP9QT09NzDhu2T37fFXWcoB9c=; b=SE9i9hS00UWQr8oEdZ5z7FN7Gn
	tKuxduysSjGf/ApVbMLPhqxxp6QnKWndbOEnRN432+HsREEc8pJVCv8RMBAAFOPLTF/RmbOBcpZ1l
	dbo8J0FRr7NJhYLIJjRaz7s9SVP/oW5mSN8jdB08ojRDa3LkBRXkuW+dk1EcsFpgxaB+1kFb8XoBf
	v0mt0aCi9F0VO82ccBqcLSuiiZ8aoyrpUHnT9If2njdO2WIyoknOIX2IWrcUgL35FPwnDuFFqsEvo
	lRn3fLA/F6DR/i6wyhXkQl/gWHxWZtrC66t8W8i8f6rO0Z7cvTIuRW84MtCw7xJNLZ0wnOp9qhN8Q
	74GcpCZQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
	id 1izPWz-0003Bc-OE; Wed, 05 Feb 2020 18:36:09 +0000
Date: Wed, 5 Feb 2020 10:36:09 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 5/5] dax,iomap: Add helper dax_iomap_zero() to zero a
 range
Message-ID: <20200205183609.GE26711@infradead.org>
References: <20200203200029.4592-1-vgoyal@redhat.com>
 <20200203200029.4592-6-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200203200029.4592-6-vgoyal@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Message-ID-Hash: LKY5YRSWFMVW2JA24FLHGLK4264HQFL7
X-Message-ID-Hash: LKY5YRSWFMVW2JA24FLHGLK4264HQFL7
X-MailFrom: BATV+a2b935cbc3c12af13a1b+6009+infradead.org+hch@bombadil.srs.infradead.org
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, hch@infradead.org, dm-devel@redhat.com
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/LKY5YRSWFMVW2JA24FLHGLK4264HQFL7/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> +int dax_iomap_zero(loff_t pos, unsigned offset, unsigned size,
> +			      struct iomap *iomap)
>  {
>  	pgoff_t pgoff;
>  	long rc, id;
> +	sector_t sector = iomap_sector(iomap, pos & PAGE_MASK);
>  
> -	rc = bdev_dax_pgoff(bdev, sector, PAGE_SIZE, &pgoff);
> +	rc = bdev_dax_pgoff(iomap->bdev, sector, PAGE_SIZE, &pgoff);
>  	if (rc)
>  		return rc;
>  
>  	id = dax_read_lock();
> -	rc = dax_zero_page_range(dax_dev, pgoff, offset, size);
> +	rc = dax_zero_page_range(iomap->dax_dev, pgoff, offset, size);
>  	dax_read_unlock(id);
>  	return rc;
>  }
> -EXPORT_SYMBOL_GPL(__dax_zero_page_range);
> +EXPORT_SYMBOL_GPL(dax_iomap_zero);

This function is only used by fs/iomap/buffered-io.c, so no need to
export it.

>  #ifdef CONFIG_FS_DAX
> -int __dax_zero_page_range(struct block_device *bdev,
> -		struct dax_device *dax_dev, sector_t sector,
> -		unsigned int offset, unsigned int length);
> +int dax_iomap_zero(loff_t pos, unsigned offset, unsigned size,
> +			      struct iomap *iomap);
>  #else
> -static inline int __dax_zero_page_range(struct block_device *bdev,
> -		struct dax_device *dax_dev, sector_t sector,
> -		unsigned int offset, unsigned int length)
> +static inline int dax_iomap_zero(loff_t pos, unsigned offset, unsigned size,
> +				 struct iomap *iomap)
>  {
>  	return -ENXIO;
>  }

Given that the only caller is under an IS_DAX() check you could just
declare the function unconditionally and let the compiler optimize
away the guaranteed dead call for the !CONFIG_FS_DAX case, like we
do with various other functions.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
