Return-Path: <SRS0=zDE3=4G=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96A57C34026
	for <linux-nvdimm@archiver.kernel.org>; Tue, 18 Feb 2020 17:07:59 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 56BB220801
	for <linux-nvdimm@archiver.kernel.org>; Tue, 18 Feb 2020 17:07:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="o7sf60WW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 56BB220801
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id C2F3E10FC33E7;
	Tue, 18 Feb 2020 09:08:40 -0800 (PST)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=2607:7c80:54:e::133; helo=bombadil.infradead.org; envelope-from=batv+407f53ceaa3a8fe198ff+6022+infradead.org+hch@bombadil.srs.infradead.org; receiver=<UNKNOWN> 
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id A5F341007B16F
	for <linux-nvdimm@lists.01.org>; Tue, 18 Feb 2020 09:08:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=j2WGs4C1vLnL8fc/aOtqeG9qe3lmQcu+zgjxzRT1RuI=; b=o7sf60WWlvof4jYu7ttN+64LOc
	B+2H+zPtYs9lptGsjPwxiQoOkSAgMncfULRPJ0VtVJxFfgt21bu3pShHZfSg8YI4YEjzviRHj0Yx/
	V6J6E7hwYzztsnUsxyh9x9gfuflCIvFFnGJMLFnaFNKowbbUs2s4LyE6k4xP4XM9IBrVqI0+B09Iw
	U2Kg9seWWADNhL6ODYe/u/N7R6D1GVZgOWXZ2I37zVC3+Utc2z/N13gMs3nUe1VccOjuDTs+HsRUU
	mPD41sLA2JutnlUO/Sc6jaN4E0ci/WxL8mdm4uIHv9xovvhu6o1v5Q/EJ7cZS07cKOSF7E2y726ok
	IKgd5L5A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
	id 1j46LX-00083T-4i; Tue, 18 Feb 2020 17:07:43 +0000
Date: Tue, 18 Feb 2020 09:07:43 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [dm-devel] [PATCH v4 1/7] pmem: Add functions for
 reading/writing page to/from pmem
Message-ID: <20200218170743.GA30766@infradead.org>
References: <20200217181653.4706-1-vgoyal@redhat.com>
 <20200217181653.4706-2-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200217181653.4706-2-vgoyal@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Message-ID-Hash: 4U6BPJUAYQRLR4HLAVL5DWP6Y7HH5NLS
X-Message-ID-Hash: 4U6BPJUAYQRLR4HLAVL5DWP6Y7HH5NLS
X-MailFrom: BATV+407f53ceaa3a8fe198ff+6022+infradead.org+hch@bombadil.srs.infradead.org
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, hch@infradead.org, dm-devel@redhat.com
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/4U6BPJUAYQRLR4HLAVL5DWP6Y7HH5NLS/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Feb 17, 2020 at 01:16:47PM -0500, Vivek Goyal wrote:
> This splits pmem_do_bvec() into pmem_do_read() and pmem_do_write().
> pmem_do_write() will be used by pmem zero_page_range() as well. Hence
> sharing the same code.
> 
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
