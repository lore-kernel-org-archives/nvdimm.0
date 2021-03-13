Return-Path: <SRS0=dRnh=IL=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FF8EC433DB
	for <linux-nvdimm@archiver.kernel.org>; Sat, 13 Mar 2021 02:35:42 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DADF064F48
	for <linux-nvdimm@archiver.kernel.org>; Sat, 13 Mar 2021 02:35:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DADF064F48
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 6C6DB100EC1E7;
	Fri, 12 Mar 2021 18:35:41 -0800 (PST)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=2001:8b0:10b:1236::1; helo=casper.infradead.org; envelope-from=willy@infradead.org; receiver=<UNKNOWN> 
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 9D51C100EC1CD
	for <linux-nvdimm@lists.01.org>; Fri, 12 Mar 2021 18:35:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4QdtxG0hSq/IIvCfi+gr9son1T9syNKPmuqqjfe6uS4=; b=Xs2F87UU5qSNJGluefg+EQlHCw
	VWctJEFYCDH8CIeeIgqkkiIOhBJI5tXiz5SC/ROPvop9funPRzNVhpJJZcK4FZ3vXwNJECHfwEbu3
	2diC4nMy+htV6IyCHy7InnsVjMM2+TNvGchkxksN7rYYw5vPXImSi7MD0HmCl86nXG50gon+pjhUz
	MPL/dgf4Uj2YEAIbk9EMNyur2pEyKUnuE4JE+WB4yHzDWxmOjx6d87XalDgI31DfGCW71Z4Z1Y8jf
	9Zgvf5YievILvzY03SaeIvCZbGCPfOd+7cZUOAeWTS7RpBjezGvuU6mAIYiSToQ5JtarJyDRQ/0ti
	PJLxnvDg==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
	id 1lKu7d-00CctL-AK; Sat, 13 Mar 2021 02:35:25 +0000
Date: Sat, 13 Mar 2021 02:35:21 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH v2 0/4] Remove nrexceptional tracking
Message-ID: <20210313023521.GG2577561@casper.infradead.org>
References: <20201026151849.24232-1-willy@infradead.org>
 <20210121184334.GA4127393@casper.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210121184334.GA4127393@casper.infradead.org>
Message-ID-Hash: ZG6UBVZC2KOHHJFOVQNU4Q7EWHJQLQW2
X-Message-ID-Hash: ZG6UBVZC2KOHHJFOVQNU4Q7EWHJQLQW2
X-MailFrom: willy@infradead.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/ZG6UBVZC2KOHHJFOVQNU4Q7EWHJQLQW2/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Ping?

On Thu, Jan 21, 2021 at 06:43:34PM +0000, Matthew Wilcox wrote:
> Ping?  These patches still apply to next-20210121.
> 
> On Mon, Oct 26, 2020 at 03:18:45PM +0000, Matthew Wilcox (Oracle) wrote:
> > We actually use nrexceptional for very little these days.  It's a minor
> > pain to keep in sync with nrpages, but the pain becomes much bigger
> > with the THP patches because we don't know how many indices a shadow
> > entry occupies.  It's easier to just remove it than keep it accurate.
> > 
> > Also, we save 8 bytes per inode which is nothing to sneeze at; on my
> > laptop, it would improve shmem_inode_cache from 22 to 23 objects per
> > 16kB, and inode_cache from 26 to 27 objects.  Combined, that saves
> > a megabyte of memory from a combined usage of 25MB for both caches.
> > Unfortunately, ext4 doesn't cross a magic boundary, so it doesn't save
> > any memory for ext4.
> > 
> > Matthew Wilcox (Oracle) (4):
> >   mm: Introduce and use mapping_empty
> >   mm: Stop accounting shadow entries
> >   dax: Account DAX entries as nrpages
> >   mm: Remove nrexceptional from inode
> > 
> >  fs/block_dev.c          |  2 +-
> >  fs/dax.c                |  8 ++++----
> >  fs/gfs2/glock.c         |  3 +--
> >  fs/inode.c              |  2 +-
> >  include/linux/fs.h      |  2 --
> >  include/linux/pagemap.h |  5 +++++
> >  mm/filemap.c            | 16 ----------------
> >  mm/swap_state.c         |  4 ----
> >  mm/truncate.c           | 19 +++----------------
> >  mm/workingset.c         |  1 -
> >  10 files changed, 15 insertions(+), 47 deletions(-)
> > 
> > -- 
> > 2.28.0
> > 
> 
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
