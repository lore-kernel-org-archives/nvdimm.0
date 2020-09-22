Return-Path: <SRS0=pmJe=C7=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 126F4C4727D
	for <linux-nvdimm@archiver.kernel.org>; Tue, 22 Sep 2020 17:05:35 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7375920739
	for <linux-nvdimm@archiver.kernel.org>; Tue, 22 Sep 2020 17:05:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XEoWL0Et"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7375920739
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id C9C0714F278EF;
	Tue, 22 Sep 2020 10:05:33 -0700 (PDT)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=2001:8b0:10b:1236::1; helo=casper.infradead.org; envelope-from=willy@infradead.org; receiver=<UNKNOWN> 
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 0D50E14F278EC
	for <linux-nvdimm@lists.01.org>; Tue, 22 Sep 2020 10:05:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ofr4ycOkQnFAciMKQaMH/OLH5o4G6m4xVeFOeH1Pf8k=; b=XEoWL0EtfRYmAwbOKKCLbqyj3d
	aad4hP2RYYM35/Qd3cvIrLQjfc4bFUJ40ZYOCm36Y6MPZbQlM10p98SR2XAm0SC2oy65LLGSRgOhs
	e/iB335z/XX20W6Ju5qOm0WNQ3qRY9ba6/lrjphBDsd9+xJpkXgTGygfFM6l3AStrXFnQh5EMLRvC
	U4m+HyXSumF8/K5QlgI080CHAa4pBfYrvU4WWR+yEAtWyqDmzOOmlCVIGgwrVyXyFgyXcU9Ca2uOA
	i7lBTg4mLyjU2cA7xKE+3bIQCBBXhOUzFNTozSiySeeCZJTTdIakYj0tCW9GKj0ZXSo9CFg+/WNZN
	vR6PNQDA==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
	id 1kKljK-0002Na-Gp; Tue, 22 Sep 2020 17:05:26 +0000
Date: Tue, 22 Sep 2020 18:05:26 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Qian Cai <cai@redhat.com>
Subject: Re: [PATCH v2 5/9] iomap: Support arbitrarily many blocks per page
Message-ID: <20200922170526.GK32101@casper.infradead.org>
References: <20200910234707.5504-1-willy@infradead.org>
 <20200910234707.5504-6-willy@infradead.org>
 <163f852ba12fd9de5dec7c4a2d6b6c7cdb379ebc.camel@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <163f852ba12fd9de5dec7c4a2d6b6c7cdb379ebc.camel@redhat.com>
Message-ID-Hash: HCR67LJ7V5XEFWUWNXWD7NQJ2GV3T7VC
X-Message-ID-Hash: HCR67LJ7V5XEFWUWNXWD7NQJ2GV3T7VC
X-MailFrom: willy@infradead.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@infradead.org>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, Dave Chinner <dchinner@redhat.com>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/HCR67LJ7V5XEFWUWNXWD7NQJ2GV3T7VC/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Sep 22, 2020 at 12:23:45PM -0400, Qian Cai wrote:
> On Fri, 2020-09-11 at 00:47 +0100, Matthew Wilcox (Oracle) wrote:
> > Size the uptodate array dynamically to support larger pages in the
> > page cache.  With a 64kB page, we're only saving 8 bytes per page today,
> > but with a 2MB maximum page size, we'd have to allocate more than 4kB
> > per page.  Add a few debugging assertions.
> > 
> > Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> Some syscall fuzzing will trigger this on powerpc:
> 
> .config: https://gitlab.com/cailca/linux-mm/-/blob/master/powerpc.config
> 
> [ 8805.895344][T445431] WARNING: CPU: 61 PID: 445431 at fs/iomap/buffered-io.c:78 iomap_page_release+0x250/0x270

Well, I'm glad it triggered.  That warning is:
        WARN_ON_ONCE(bitmap_full(iop->uptodate, nr_blocks) !=
                        PageUptodate(page));
so there was definitely a problem of some kind.

truncate_cleanup_page() calls
do_invalidatepage() calls
iomap_invalidatepage() calls
iomap_page_release()

Is this the first warning?  I'm wondering if maybe there was an I/O error
earlier which caused PageUptodate to get cleared again.  If it's easy to
reproduce, perhaps you could try something like this?

+void dump_iomap_page(struct page *page, const char *reason)
+{
+       struct iomap_page *iop = to_iomap_page(page);
+       unsigned int nr_blocks = i_blocks_per_page(page->mapping->host, page);
+
+       dump_page(page, reason);
+       if (iop)
+               printk("iop:reads %d writes %d uptodate %*pb\n",
+                               atomic_read(&iop->read_bytes_pending),
+                               atomic_read(&iop->write_bytes_pending),
+                               nr_blocks, iop->uptodate);
+       else
+               printk("iop:none\n");
+}

and then do something like:

	if (bitmap_full(iop->uptodate, nr_blocks) != PageUptodate(page))
		dump_iomap_page(page, NULL);
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
