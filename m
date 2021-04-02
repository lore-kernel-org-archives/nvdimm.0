Return-Path: <SRS0=K2gx=I7=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.2 required=3.0 tests=BAYES_50,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ED3BC433ED
	for <linux-nvdimm@archiver.kernel.org>; Fri,  2 Apr 2021 13:27:50 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EF21F6112E
	for <linux-nvdimm@archiver.kernel.org>; Fri,  2 Apr 2021 13:27:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EF21F6112E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 951DE100EAB54;
	Fri,  2 Apr 2021 06:27:49 -0700 (PDT)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=2001:8b0:10b:1236::1; helo=casper.infradead.org; envelope-from=willy@infradead.org; receiver=<UNKNOWN> 
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 0351A100ED4BA
	for <linux-nvdimm@lists.01.org>; Fri,  2 Apr 2021 06:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Quv+d5ruToqASsYHkDYyM+RNKRKLkPKY2MzE/OEcBCc=; b=Hn4p16U0Xxhq5upbBRvlz8n2ox
	zWm3vcPITR6WIgIRjEtrgfbpywR54mfRiOw1cS0cS9diYxrum7asLMiUvNEtR/bUQa9suts9rquNt
	6h5DAKJQR8mxrMOT6YRTTRA2o9i73/i4wO3P43uXwZ/0kXaIRnEjeWSgQwXrfi/N/LUHpJalqporl
	HfQAdmqsnJh/m1SlQtGsDDjmv81jNN5D6vhUhWLtxaZyNq1MxY3XN5tDgMXYqNBQBTO9ljSjUqaFY
	pP5P053z76nhNadrx0wLL6GPQXV/dEzbk9NmQ68ylZ8oFQW2QYwjZRVpLURl9rRZnVeP4iXMTBLn+
	cRrcvYcA==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
	id 1lSJpM-007gLj-Br; Fri, 02 Apr 2021 13:27:14 +0000
Date: Fri, 2 Apr 2021 14:27:08 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Hugh Dickins <hughd@google.com>
Subject: Re: BUG_ON(!mapping_empty(&inode->i_data))
Message-ID: <20210402132708.GM351017@casper.infradead.org>
References: <alpine.LSU.2.11.2103301654520.2648@eggly.anvils>
 <20210331024913.GS351017@casper.infradead.org>
 <alpine.LSU.2.11.2103311413560.1201@eggly.anvils>
 <20210401170615.GH351017@casper.infradead.org>
 <20210402031305.GK351017@casper.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210402031305.GK351017@casper.infradead.org>
Message-ID-Hash: EPNTRALRZSMGCTR5NRHN5SM2UQPPO57T
X-Message-ID-Hash: EPNTRALRZSMGCTR5NRHN5SM2UQPPO57T
X-MailFrom: willy@infradead.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/EPNTRALRZSMGCTR5NRHN5SM2UQPPO57T/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Apr 02, 2021 at 04:13:05AM +0100, Matthew Wilcox wrote:
> +	for (;;) {
> +		xas_load(xas);
> +		if (!xas_is_node(xas))
> +			break;
> +		xas_delete_node(xas);
> +		xas->xa_index -= XA_CHUNK_SIZE;
> +		if (xas->xa_index < index)
> +			break;

That's a bug.  index can be 0, so the condition would never be true.
It should be:

		if (xas->xa_index <= (index | XA_CHUNK_MASK))
			break;
		xas->xa_index -= XA_CHUNK_SIZE;

The test doesn't notice this bug because the tree is otherwise empty,
and the !xas_is_node(xas) condition is hit first.  The next test will
notice this.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
