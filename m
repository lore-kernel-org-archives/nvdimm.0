Return-Path: <SRS0=HRiO=GX=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F732C433E6
	for <linux-nvdimm@archiver.kernel.org>; Wed, 20 Jan 2021 21:42:58 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E11B52368A
	for <linux-nvdimm@archiver.kernel.org>; Wed, 20 Jan 2021 21:42:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E11B52368A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 80BFE100EB335;
	Wed, 20 Jan 2021 13:42:57 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=198.145.29.99; helo=mail.kernel.org; envelope-from=rppt@kernel.org; receiver=<UNKNOWN> 
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id D06C4100EBBC4
	for <linux-nvdimm@lists.01.org>; Wed, 20 Jan 2021 13:42:54 -0800 (PST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E57F23600;
	Wed, 20 Jan 2021 21:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1611178974;
	bh=ZemV/+dUIhWWETHuwU5pHRPb6MkbPLkRamXfzO/LwBk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uzb7oUqqqTl6faKktid0R1cfCdzOhvge6hefHpP1hVsOrRWHUIRjtRR24feMvviBV
	 qSPgQ0BpNLkdq1Dh3XK99XOPci+LskNVcWHz5989GtZRhQv44Gf357HRSoLSYk494t
	 IKjF5/HIb64hJBLOgZxf/YfAPKv47GTkUJBbd7DJcJTd2tSyzQVNhz0mzFh7G7vSAC
	 QsPumwQssV3QVC+8stgE0LaJa76huTme80dU3hSp8RBkxnlwydBxS3gUzVaX1cLjEk
	 zdGWVnOXpFdtYn/+WUm8E0F8/cTMAueXosEUkqwcn7jAPBJAPaxvqXgAzRBJ8CwIBD
	 wQMKvnyLvI9vA==
Date: Wed, 20 Jan 2021 23:42:39 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v15 06/11] mm: introduce memfd_secret system call to
 create "secret" memory areas
Message-ID: <20210120214239.GR1106298@kernel.org>
References: <20210120180612.1058-1-rppt@kernel.org>
 <20210120180612.1058-7-rppt@kernel.org>
 <20210120203504.GM2260413@casper.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210120203504.GM2260413@casper.infradead.org>
Message-ID-Hash: CX2YCFEIRGA2DAA55ZKGAOH2KLLMJIHP
X-Message-ID-Hash: CX2YCFEIRGA2DAA55ZKGAOH2KLLMJIHP
X-MailFrom: rppt@kernel.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>, Christopher Lameter <cl@linux.com>, Dave Hansen <dave.hansen@linux.intel.com>, David Hildenbrand <david@redhat.com>, Elena Reshetova <elena.reshetova@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, James Bottomley <jejb@linux.ibm.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, Mark Rutland <mark.rutland@arm.com>, Mike Rapoport <rppt@linux.ibm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, Peter Zijlstra <peterz@infradead.org>, Rick Edgecombe <rick.p.edgecombe@intel.com>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Tycho Andersen <tycho@tycho.ws>, Will Deacon
  <will@kernel.org>, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-nvdimm@lists.01.org, linux-riscv@lists.infradead.org, x86@kernel.org, Hagen Paul Pfeifer <hagen@jauu.net>, Palmer Dabbelt <palmerdabbelt@google.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/CX2YCFEIRGA2DAA55ZKGAOH2KLLMJIHP/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Jan 20, 2021 at 08:35:04PM +0000, Matthew Wilcox wrote:
> On Wed, Jan 20, 2021 at 08:06:07PM +0200, Mike Rapoport wrote:
> > +static struct page *secretmem_alloc_page(gfp_t gfp)
> > +{
> > +	/*
> > +	 * FIXME: use a cache of large pages to reduce the direct map
> > +	 * fragmentation
> > +	 */
> > +	return alloc_page(gfp);
> > +}
> > +
> > +static vm_fault_t secretmem_fault(struct vm_fault *vmf)
> > +{
> > +	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
> > +	struct inode *inode = file_inode(vmf->vma->vm_file);
> > +	pgoff_t offset = vmf->pgoff;
> > +	unsigned long addr;
> > +	struct page *page;
> > +	int err;
> > +
> > +	if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
> > +		return vmf_error(-EINVAL);
> > +
> > +retry:
> > +	page = find_lock_page(mapping, offset);
> > +	if (!page) {
> > +		page = secretmem_alloc_page(vmf->gfp_mask);
> > +		if (!page)
> > +			return VM_FAULT_OOM;
> > +
> > +		err = set_direct_map_invalid_noflush(page, 1);
> > +		if (err)
> > +			return vmf_error(err);
> 
> Haven't we leaked the page at this point?

Well, yes. :(

But this code is anyway changed in the next patch. Is this really so
important to fix this in the middle of the series?
 
> > +		__SetPageUptodate(page);
> > +		err = add_to_page_cache(page, mapping, offset, vmf->gfp_mask);
> 
> At this point, doesn't the page contain data from the last person to use
> the page?  ie we've leaked data to this process?  I don't see anywhere
> that we write data to the page.

The data is visible for all processes that share the file descriptor. So
no, we don't leak anything unless the file descriptor itself is leaked.

Did you have a particular scenario in mind?

-- 
Sincerely yours,
Mike.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
