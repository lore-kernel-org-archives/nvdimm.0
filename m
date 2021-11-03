Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F072C98
	for <nvdimm@lists.linux.dev>; Wed,  3 Nov 2021 16:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=OlZDjSjQL2PENkut3+Y0kHOKrNMRwIS4kL/V7VGLrlw=; b=TIz3Ai4DKmZIG9fZGTDqeAEcYz
	mEgFA3weDd0OsDcFx+ocxMmDGWZCwwjzFbPgtk4VUbLHj4aTUsQVkgtKwqDFyuKLq9J3XHmIneUkY
	O8wqQlMnH7i2EJE/dy4Fn/cN6C0XlxmMLtADP/tCLzod6JJysS6RL/ftRMPn/fO8A5XPGhSZISUR9
	RkLIMYjsjeHUy9Ti3B0WQe/0wHuaJ2aBVKQcz0QB6rJgGtU2uH/DrBJFpvH/B9SBlkGP3tigv27LA
	gWOuGX/EmnRVAe0zdbSwl3hIoPfbPGfoGZnyG3xrT0OEVsRVf+Ib6Mt366T9lE3DvgZxthuA9+dL0
	S99QMEdQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1miJam-005shC-K2; Wed, 03 Nov 2021 16:58:28 +0000
Date: Wed, 3 Nov 2021 09:58:28 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Jane Chu <jane.chu@oracle.com>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
	"dave.jiang@intel.com" <dave.jiang@intel.com>,
	"agk@redhat.com" <agk@redhat.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"ira.weiny@intel.com" <ira.weiny@intel.com>,
	"willy@infradead.org" <willy@infradead.org>,
	"vgoyal@redhat.com" <vgoyal@redhat.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [dm-devel] [PATCH 0/6] dax poison recovery with
 RWF_RECOVERY_DATA flag
Message-ID: <YYK/tGfpG0CnVIO4@infradead.org>
References: <20211021001059.438843-1-jane.chu@oracle.com>
 <YXFPfEGjoUaajjL4@infradead.org>
 <e89a2b17-3f03-a43e-e0b9-5d2693c3b089@oracle.com>
 <YXJN4s1HC/Y+KKg1@infradead.org>
 <2102a2e6-c543-2557-28a2-8b0bdc470855@oracle.com>
 <YXj2lwrxRxHdr4hb@infradead.org>
 <20211028002451.GB2237511@magnolia>
 <YYDYUCCiEPXhZEw0@infradead.org>
 <CAPcyv4j8snuGpy=z6BAXogQkP5HmTbqzd6e22qyERoNBvFKROw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4j8snuGpy=z6BAXogQkP5HmTbqzd6e22qyERoNBvFKROw@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Nov 02, 2021 at 12:57:10PM -0700, Dan Williams wrote:
> This goes back to one of the original DAX concerns of wanting a kernel
> library for coordinating PMEM mmap I/O vs leaving userspace to wrap
> PMEM semantics on top of a DAX mapping. The problem is that mmap-I/O
> has this error-handling-API issue whether it is a DAX mapping or not.

Semantics of writes through shared mmaps are a nightmare.  Agreed,
including agreeing that this is neither new nor pmem specific.  But
it also has absolutely nothing to do with the new RWF_ flag.

> CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE implies that processes will
> receive SIGBUS + BUS_MCEERR_A{R,O} when memory failure is signalled
> and then rely on readv(2)/writev(2) to recover. Do you see a readily
> available way to improve upon that model without CPU instruction
> changes? Even with CPU instructions changes, do you think it could
> improve much upon the model of interrupting the process when a load
> instruction aborts?

The "only" think we need is something like the exception table we
use in the kernel for the uaccess helpers (and the new _nofault
kernel access helper).  But I suspect refitting that into userspace
environments is probably non-trivial.

> I do agree with you that DAX needs to separate itself from block, but
> I don't think it follows that DAX also needs to separate itself from
> readv/writev for when a kernel slow-path needs to get involved because
> mmap I/O (just CPU instructions) does not have the proper semantics.
> Even if you got one of the ARCH_SUPPORTS_MEMORY_FAILURE to implement
> those semantics in new / augmented CPU instructions you will likely
> not get all of them to move and certainly not in any near term
> timeframe, so the kernel path will be around indefinitely.

I think you misunderstood me.  I don't think pmem needs to be
decoupled from the read/write path.  But I'm very skeptical of adding
a new flag to the common read/write path for the special workaround
that a plain old write will not actually clear errors unlike every
other store interfac.

> Meanwhile, I think RWF_RECOVER_DATA is generically useful for other
> storage besides PMEM and helps storage-drivers do better than large
> blast radius "I/O error" completions with no other recourse.

How?
