Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF6B15CD
	for <nvdimm@lists.linux.dev>; Fri, 28 Apr 2023 02:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/xYyM2/2fZUrV7AGHMUU/V2Uxg54bIXQhTCl/g3j+5Q=; b=bb0NWY/niB+va5+6SUnPBr7MTD
	0GNjerPbZuqTQYKebB32VcTwKMcWGV5jfs7RCjv4ZNdvAVzA3h/S70daX9uofpUSQ/GCS7/QwUMAY
	KxrAurqgj9uX1Z7XwhKmtqLr8eUTmSHSRka6LCt53RjdIWdtEXjpg7t4PMnKgVsrH2j1p2qe4LX+R
	OPfwuHP3MH2/lFhaB6dQ+ZV4iuhPAwZgud6icdZhZBRaxpGKXf6wWDHGy3cK/qbKeKwBdfi/4wWr+
	Cxhkr/S8nnn3AyYjznZcPN21RQgOUJeIA4LFPvOgRfSNetyKp9Hq8JmEwhvZ2mapaxXXrAdVs7+Z5
	78oRl9hA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1psECD-004Bcp-3V; Fri, 28 Apr 2023 02:50:53 +0000
Date: Fri, 28 Apr 2023 03:50:53 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jane Chu <jane.chu@oracle.com>, vishal.l.verma@intel.com,
	dave.jiang@intel.com, ira.weiny@intel.com, viro@zeniv.linux.org.uk,
	brauner@kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2] dax: enable dax fault handler to report
 VM_FAULT_HWPOISON
Message-ID: <ZEs0jSYkMobnFxXg@casper.infradead.org>
References: <20230406230127.716716-1-jane.chu@oracle.com>
 <644aeadcba13b_2028294c9@dwillia2-xfh.jf.intel.com.notmuch>
 <a3c1bef3-4226-7c24-905a-d58bd67b89f1@oracle.com>
 <644b22fddc18c_1b6629488@dwillia2-xfh.jf.intel.com.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <644b22fddc18c_1b6629488@dwillia2-xfh.jf.intel.com.notmuch>

On Thu, Apr 27, 2023 at 06:35:57PM -0700, Dan Williams wrote:
> Jane Chu wrote:
> > Hi, Dan,
> > 
> > On 4/27/2023 2:36 PM, Dan Williams wrote:
> > > Jane Chu wrote:
> > >> When dax fault handler fails to provision the fault page due to
> > >> hwpoison, it returns VM_FAULT_SIGBUS which lead to a sigbus delivered
> > >> to userspace with .si_code BUS_ADRERR.  Channel dax backend driver's
> > >> detection on hwpoison to the filesystem to provide the precise reason
> > >> for the fault.
> > > 
> > > It's not yet clear to me by this description why this is an improvement
> > > or will not cause other confusion. In this case the reason for the
> > > SIGBUS is because the driver wants to prevent access to poison, not that
> > > the CPU consumed poison. Can you clarify what is lost by *not* making
> > > this change?
> > 
> > Elsewhere when hwpoison is detected by page fault handler and helpers as 
> > the direct cause to failure, VM_FAULT_HWPOISON or 
> > VM_FAULT_HWPOISON_LARGE is flagged to ensure accurate SIGBUS payload is 
> > produced, such as wp_page_copy() in COW case, do_swap_page() from 
> > handle_pte_fault(), hugetlb_fault() in hugetlb page fault case where the 
> > huge fault size would be indicated in the payload.
> > 
> > But dax fault has been an exception in that the SIGBUS payload does not 
> > indicate poison, nor fault size.  I don't see why it should be though,
> > recall an internal user expressing confusion regarding the different 
> > SIGBUS payloads.
> 
> ...but again this the typical behavior with block devices. If a block
> device has badblock that causes page cache page not to be populated
> that's a SIGBUS without hwpoison information. If the page cache is
> properly populated and then the CPU consumes poison that's a SIGBUS with
> the additional hwpoison information.

I'm not sure that's true when we mmap().  Yes, it's not consistent with
-EIO from read(), but we have additional information here, and it's worth
providing it.  You can think of it as *in this instance*, the error is
found "in the page cache", because that's effectively where the error
is from the point of view of the application?
