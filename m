Return-Path: <SRS0=0oYS=B2=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 565FBC433E1
	for <linux-nvdimm@archiver.kernel.org>; Sun, 16 Aug 2020 01:49:02 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1E9E020708
	for <linux-nvdimm@archiver.kernel.org>; Sun, 16 Aug 2020 01:49:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CEeNyYKw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1E9E020708
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id C5CEB133153AE;
	Sat, 15 Aug 2020 18:49:01 -0700 (PDT)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=2001:8b0:10b:1236::1; helo=casper.infradead.org; envelope-from=willy@infradead.org; receiver=<UNKNOWN> 
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id DCA3F133153AA
	for <linux-nvdimm@lists.01.org>; Sat, 15 Aug 2020 18:48:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+qGvMQP3F82XWnhA2Z0T5CGUcknqttuEfe3H274ZaXQ=; b=CEeNyYKwgEXWghcU5/lmXcskC1
	4qrkVEYZ3nbXyRaVYgl2LFNKtufwOIsuNfGK5Xkjxekt+0kt+vUJT0qwN4NOzv3wwSoQ+PXE3mO9g
	0mFH2hQZOcJ00GxxF6hft10Nu1Yus1ncZNlq6dR0uGPYz/AVbIzyqBYy10OZSTxkG7dzm1G3mQhXj
	Yx7op7Bq0pmGzcUQGUgm8DI9/R5BzsnUJNELgbeTbQnCPZbXeuhC6dq52cE7b1hcA6V9C2aF93hjE
	0VWcUOYC41e6aI+FjEuQfeRsOaIQcxVAWuhnwLjvuLRgsUbvmDoYTpTyucQ8y7+G8dq8XcHMDK3DL
	pEIakH1g==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
	id 1k77n1-0002qj-M5; Sun, 16 Aug 2020 01:48:51 +0000
Date: Sun, 16 Aug 2020 02:48:51 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH 1/4] mm: Introduce and use page_cache_empty
Message-ID: <20200816014851.GE17456@casper.infradead.org>
References: <20200804161755.10100-1-willy@infradead.org>
 <20200804161755.10100-2-willy@infradead.org>
 <20200806232400.s7nhmnoi3tkk7p2r@box>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200806232400.s7nhmnoi3tkk7p2r@box>
Message-ID-Hash: MOQGW4X7A6WWJAFUTSFVUX35SY5Y5IPK
X-Message-ID-Hash: MOQGW4X7A6WWJAFUTSFVUX35SY5Y5IPK
X-MailFrom: willy@infradead.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/MOQGW4X7A6WWJAFUTSFVUX35SY5Y5IPK/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Aug 07, 2020 at 02:24:00AM +0300, Kirill A. Shutemov wrote:
> On Tue, Aug 04, 2020 at 05:17:52PM +0100, Matthew Wilcox (Oracle) wrote:
> > diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> > index 484a36185bb5..a474a92a2a72 100644
> > --- a/include/linux/pagemap.h
> > +++ b/include/linux/pagemap.h
> > @@ -18,6 +18,11 @@
> >  
> >  struct pagevec;
> >  
> > +static inline bool page_cache_empty(struct address_space *mapping)
> > +{
> > +	return xa_empty(&mapping->i_pages);
> 
> What about something like
> 
> 	bool empty = xa_empty(&mapping->i_pages);
> 	VM_BUG_ON(empty && mapping->nrpages);
> 	return empty;

I tried this and it's triggered by generic/418.  The problem
is that it's called when the pagecache lock isn't held (by
invalidate_inode_pages2_range), so it's possible for xa_empty() to
return true, then a page be added to the page cache, and mapping->pages
be incremented to 1.  That seems to be what's happened here:

(gdb) p/x *(struct address_space *)0xffff88804b21b360
$2 = {host = 0xffff88804b21b200, i_pages = {xa_lock = {{rlock = {raw_lock = {{
              val = {counter = 0x0}, {locked = 0x0, pending = 0x0}, {
                locked_pending = 0x0, tail = 0x0}}}}}}, xa_flags = 0x21, 
*  xa_head = 0xffffea0001e187c0}, gfp_mask = 0x100c4a, i_mmap_writable = {
    counter = 0x0}, nr_thps = {counter = 0x0}, i_mmap = {rb_root = {
      rb_node = 0x0}, rb_leftmost = 0x0}, i_mmap_rwsem = {count = {
      counter = 0x0}, owner = {counter = 0x0}, osq = {tail = {counter = 0x0}}, 
    wait_lock = {raw_lock = {{val = {counter = 0x0}, {locked = 0x0, 
            pending = 0x0}, {locked_pending = 0x0, tail = 0x0}}}}, 
    wait_list = {next = 0xffff88804b21b3b0, prev = 0xffff88804b21b3b0}}, 
* nrpages = 0x1, writeback_index = 0x0, a_ops = 0xffffffff81c2ed60, 
  flags = 0x40, wb_err = 0x0, private_lock = {{rlock = {raw_lock = {{val = {
              counter = 0x0}, {locked = 0x0, pending = 0x0}, {
              locked_pending = 0x0, tail = 0x0}}}}}}, private_list = {
    next = 0xffff88804b21b3e8, prev = 0xffff88804b21b3e8}, private_data = 0x0}

(marked the critical lines with *)
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
