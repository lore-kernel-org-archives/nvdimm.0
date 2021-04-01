Return-Path: <SRS0=1mFQ=I6=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.2 required=3.0 tests=BAYES_50,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7FAAC433ED
	for <linux-nvdimm@archiver.kernel.org>; Thu,  1 Apr 2021 17:06:33 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7536A61220
	for <linux-nvdimm@archiver.kernel.org>; Thu,  1 Apr 2021 17:06:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7536A61220
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 3D236100F225F;
	Thu,  1 Apr 2021 10:06:33 -0700 (PDT)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=2001:8b0:10b:1236::1; helo=casper.infradead.org; envelope-from=willy@infradead.org; receiver=<UNKNOWN> 
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 9EF4A100F224F
	for <linux-nvdimm@lists.01.org>; Thu,  1 Apr 2021 10:06:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=iCMEzATsTfKSllJ0qHxWkotIZ1LmTIaj9wA1MfQzBRo=; b=mN+K+tNl7VN1Zh9vGb6RBIGpcG
	URsI4ncd1qpZarWtFWlRAuRNMmA4vxy7ER+6UfyJh91G4FWy3JDQJovHDoLobLdF++cwQE3ixv75u
	/IpLjAFNZj+qdihlzk21Vt0dXA1rLWBj8S+3sH6KGWY4VF85iEnryKOjm9UL/vAdQqynMq6Q5kEox
	eNkMRVdwDGqWKaMrPiuEfzUa1aVuZMfSIqyuMRB/tpt0JhwrSc7aukHcJSUTbkxFVJ2Adz5qMYZAG
	Luv5Z3aHjdby3V6GOV7WPfj/gHcPy8wStsVn0PMG7jk8TY3zmwKa1amIZvDRJodtacJLlETBSOCxU
	dQkiQCAA==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
	id 1lS0lr-006OYt-NL; Thu, 01 Apr 2021 17:06:17 +0000
Date: Thu, 1 Apr 2021 18:06:15 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Hugh Dickins <hughd@google.com>
Subject: Re: BUG_ON(!mapping_empty(&inode->i_data))
Message-ID: <20210401170615.GH351017@casper.infradead.org>
References: <alpine.LSU.2.11.2103301654520.2648@eggly.anvils>
 <20210331024913.GS351017@casper.infradead.org>
 <alpine.LSU.2.11.2103311413560.1201@eggly.anvils>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.2103311413560.1201@eggly.anvils>
Message-ID-Hash: IDP2736AZQ4LWGEDORGTLSTAYUONIUKH
X-Message-ID-Hash: IDP2736AZQ4LWGEDORGTLSTAYUONIUKH
X-MailFrom: willy@infradead.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/IDP2736AZQ4LWGEDORGTLSTAYUONIUKH/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Mar 31, 2021 at 02:58:12PM -0700, Hugh Dickins wrote:
> I suspect there's a bug in the XArray handling in collapse_file(),
> which sometimes leaves empty nodes behind.

Urp, yes, that can easily happen.

        /* This will be less messy when we use multi-index entries */
        do {
                xas_lock_irq(&xas);
                xas_create_range(&xas);
                if (!xas_error(&xas))
                        break;
                if (!xas_nomem(&xas, GFP_KERNEL)) {
                        result = SCAN_FAIL;
                        goto out;
                }

xas_create_range() can absolutely create nodes with zero entries.
So if we create m/n nodes and then it runs out of memory (or cgroup
denies it), we can leave nodes in the tree with zero entries.

There are three options for fixing it ...
 - Switch to using multi-index entries.  We need to do this anyway, but
   I don't yet have a handle on the bugs that you found last time I
   pushed this into linux-next.  At -rc5 seems like a late stage to be
   trying this solution.
 - Add an xas_prune_range() that gets called on failure.  Should be
   straightforward to write, but will be obsolete as soon as we do the
   above and it's a pain for the callers.
 - Change how xas_create_range() works to merely preallocate the xa_nodes
   and not insert them into the tree until we're trying to insert data into
   them.  I favour this option, and this scenario is amenable to writing
   a test that will simulate failure halfway through.

I'm going to start on option 3 now.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
