Return-Path: <SRS0=ZDNc=4V=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D74D0C3F2CE
	for <linux-nvdimm@archiver.kernel.org>; Wed,  4 Mar 2020 16:16:46 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9F0E421D56
	for <linux-nvdimm@archiver.kernel.org>; Wed,  4 Mar 2020 16:16:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="C8xWf5NG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9F0E421D56
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id A19AA10FC36CD;
	Wed,  4 Mar 2020 08:17:36 -0800 (PST)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=2607:7c80:54:e::133; helo=bombadil.infradead.org; envelope-from=batv+8d601d1946d93ad90af3+6037+infradead.org+hch@bombadil.srs.infradead.org; receiver=<UNKNOWN> 
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 2D55810FC36C7
	for <linux-nvdimm@lists.01.org>; Wed,  4 Mar 2020 08:17:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=p1fGfBNWSAsTiZjh+6A1Y3Vp0yNK0hm9DzZrJQURvpw=; b=C8xWf5NGbIVN9T0mcaAsK69l+J
	NLlhI7FXSixgmAPqGLg82aMXGIHqtmuWsSk7xHK7SStSA7K7R5elwfkT73SrV1YP6j1NgrhNLiIBn
	pceh4ASlFNADx9Z9+6cOUqyjtQHXHPJy7ubT1QVWKJ10UWbnsYnYXs3p7TYt0VwUJjYYTKdRMW6AP
	+o3qb7/kHiYfzlprWbPdjfUtp0zVmwsnBOr8AgOWdpEyPxpzRNgg5YFe/fdQNGKfJ/rSTBH30VM9Y
	8J6jx7iNoRsNdlUB/o509eTvX9eRhxm2zGpH4BKfiaDLN6rFmLW1Z0RIEAsQp8EfBKPlPXLUU5FXt
	q+X939zA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
	id 1j9WhJ-0005Qk-3b; Wed, 04 Mar 2020 16:16:37 +0000
Date: Wed, 4 Mar 2020 08:16:37 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Subject: Re: [PATCH v6 1/6] pmem: Add functions for reading/writing page
 to/from pmem
Message-ID: <20200304161637.GA16390@infradead.org>
References: <20200228163456.1587-1-vgoyal@redhat.com>
 <20200228163456.1587-2-vgoyal@redhat.com>
 <CAM9Jb+gJWH_bC-9fgGdeP5LaSVjJ3JgTnjBxpRJMfe6vbTPOTA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAM9Jb+gJWH_bC-9fgGdeP5LaSVjJ3JgTnjBxpRJMfe6vbTPOTA@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Message-ID-Hash: WWKG3NJST4XOHZPVQQPOZH5V7RJCBNJQ
X-Message-ID-Hash: WWKG3NJST4XOHZPVQQPOZH5V7RJCBNJQ
X-MailFrom: BATV+8d601d1946d93ad90af3+6037+infradead.org+hch@bombadil.srs.infradead.org
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, hch@infradead.org, david@fromorbit.com, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/WWKG3NJST4XOHZPVQQPOZH5V7RJCBNJQ/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, Feb 29, 2020 at 09:04:00AM +0100, Pankaj Gupta wrote:
> > +       phys_addr_t pmem_off = sector * 512 + pmem->data_offset;
> 
> minor nit,  maybe 512 is replaced by macro? Looks like its used at multiple
> places, maybe can keep at is for now.

That would be the existing SECTOR_SIZE macro.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
