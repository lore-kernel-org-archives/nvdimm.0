Return-Path: <SRS0=cats=3Z=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 828ADC35247
	for <linux-nvdimm@archiver.kernel.org>; Wed,  5 Feb 2020 18:30:56 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5AF3F20674
	for <linux-nvdimm@archiver.kernel.org>; Wed,  5 Feb 2020 18:30:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VznFrfNa"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5AF3F20674
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 8162510FC33E9;
	Wed,  5 Feb 2020 10:34:13 -0800 (PST)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=2607:7c80:54:e::133; helo=bombadil.infradead.org; envelope-from=batv+a2b935cbc3c12af13a1b+6009+infradead.org+hch@bombadil.srs.infradead.org; receiver=<UNKNOWN> 
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 053A010FC33E8
	for <linux-nvdimm@lists.01.org>; Wed,  5 Feb 2020 10:34:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ps5OmylYpbLa02TyE4cuWxYOR03LYsFUcTf4hNL0iGQ=; b=VznFrfNanQr9DZP2fRjS6RAE6P
	ywoYHK+leWqpfxekMZfHY0jES/tdrtJtLN31b/68JAZvOPWSK7A3Y//y8VnCTJjKTvt+pchcLVFK5
	saGYmEjNdhPQp1OWrZyySQmrDAIhCaqeZ/8a/ERhs2CuuMk6mthK41DLaITE8rd3TVdnCosJfynPE
	eXUXQkZWO6mqy108GM4h8ipF1HT4X/Bvo/l8fLTJ+Fv6++pRSy+9nl7o/1yYHq3ucWeVMTPk0QEG5
	S4cnIDStJFgiEzx8ZE3nX9rBd0tI7O1g3n6RztOeZbmsYE/PhZVV3H+3QurrGmEd4fC/q7rmRcRWF
	E11nwKcA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
	id 1izPRq-0001GT-Dv; Wed, 05 Feb 2020 18:30:50 +0000
Date: Wed, 5 Feb 2020 10:30:50 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 1/5] dax, pmem: Add a dax operation zero_page_range
Message-ID: <20200205183050.GA26711@infradead.org>
References: <20200203200029.4592-1-vgoyal@redhat.com>
 <20200203200029.4592-2-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200203200029.4592-2-vgoyal@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Message-ID-Hash: NJPSL476SF2TJ5FSU76LDAT4IGBYCWLP
X-Message-ID-Hash: NJPSL476SF2TJ5FSU76LDAT4IGBYCWLP
X-MailFrom: BATV+a2b935cbc3c12af13a1b+6009+infradead.org+hch@bombadil.srs.infradead.org
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, hch@infradead.org, dm-devel@redhat.com
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/NJPSL476SF2TJ5FSU76LDAT4IGBYCWLP/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> +	/*
> +	 * There are no users as of now. Once users are there, fix dm code
> +	 * to be able to split a long range across targets.
> +	 */

This comment confused me.  I think this wants to say something like:

	/*
	 * There are now callers that want to zero across a page boundary as of
	 * now.  Once there are users this check can be removed after the
	 * device mapper code has been updated to split ranges across targets.
	 */

> +static int pmem_dax_zero_page_range(struct dax_device *dax_dev, pgoff_t pgoff,
> +				    unsigned int offset, size_t len)
> +{
> +	int rc = 0;
> +	phys_addr_t phys_pos = pgoff * PAGE_SIZE + offset;

Any reason not to pass a phys_addr_t in the calling convention for the
method and maybe also for dax_zero_page_range itself?

> +	sector_start = ALIGN(phys_pos, 512)/512;
> +	sector_end = ALIGN_DOWN(phys_pos + bytes, 512)/512;

Missing whitespaces.  Also this could use DIV_ROUND_UP and
DIV_ROUND_DOWN.

> +	if (sector_end > sector_start)
> +		nr_sectors = sector_end - sector_start;
> +
> +	if (nr_sectors &&
> +	    unlikely(is_bad_pmem(&pmem->bb, sector_start,
> +				 nr_sectors * 512)))
> +		bad_pmem = true;

How could nr_sectors be zero?

> +	write_pmem(pmem_addr, page, 0, bytes);
> +	if (unlikely(bad_pmem)) {
> +		/*
> +		 * Pass block aligned offset and length. That seems
> +		 * to work as of now. Other finer grained alignment
> +		 * cases can be addressed later if need be.
> +		 */
> +		rc = pmem_clear_poison(pmem, ALIGN(pmem_off, 512),
> +				       nr_sectors * 512);
> +		write_pmem(pmem_addr, page, 0, bytes);
> +	}

This code largerly duplicates the write side of pmem_do_bvec.  I
think it might make sense to split pmem_do_bvec into a read and a write
side as a prep patch, and then reuse the write side here.

> +int generic_dax_zero_page_range(struct dax_device *dax_dev, pgoff_t pgoff,
> +				 unsigned int offset, size_t len);

This should probably go into a separare are of the header and have
comment about being a section for generic helpers for drivers.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
