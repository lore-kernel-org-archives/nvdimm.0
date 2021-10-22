Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5945C2C81
	for <nvdimm@lists.linux.dev>; Fri, 22 Oct 2021 05:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=joQSPE1jf42K9iGwtLp9ug4KvVxpkMDtCEtS/1k1vQs=; b=jpz74NF63z9Xx79gxcWJoLwz/A
	piNaP7v1tEooFSBcu8kxM7mBbUWzsoeD+UW7lVE73ZJdXIJuxYCJuwJ78e6E+6QmPWP/KmL4EeqXS
	2slRXyqI/CVBgh8MCxe6+Or75SfRoVW/Jc3zfBEfXmxwpwol+L0R7CHTU9bEfc3GETUBSG4KeZ0ii
	B77KRbiJ3NS6xTy8bVDD2B/ujpplso5cB9C1Ze6Mai377gQ59FDIb6DJ4Qlid9ICuLCmRbDawEUTE
	Rcd49rL8fcfyxLPtVCZTzQPPUP2TxjFptZTRfCg3eePEEWSyM6+BRXrDk4Q+c7E8boGbHY1+rVcI6
	C3yjGJkw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mdnFg-009lbb-Bd; Fri, 22 Oct 2021 05:38:00 +0000
Date: Thu, 21 Oct 2021 22:38:00 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Jane Chu <jane.chu@oracle.com>, Christoph Hellwig <hch@infradead.org>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>,
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
Message-ID: <YXJOOFqK6dGsP+bI@infradead.org>
References: <20211021001059.438843-1-jane.chu@oracle.com>
 <YXFPfEGjoUaajjL4@infradead.org>
 <e89a2b17-3f03-a43e-e0b9-5d2693c3b089@oracle.com>
 <20211022015817.GY24307@magnolia>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211022015817.GY24307@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Oct 21, 2021 at 06:58:17PM -0700, Darrick J. Wong wrote:
> On Fri, Oct 22, 2021 at 01:37:28AM +0000, Jane Chu wrote:
> > On 10/21/2021 4:31 AM, Christoph Hellwig wrote:
> > > Looking over the series I have serious doubts that overloading the
> > > slow path clear poison operation over the fast path read/write
> > > path is such a great idea.
> 
> Why would data recovery after a media error ever be considered a
> fast/hot path?

Not sure what you're replying to (the text is from me, the mail you are
repling to is fom Jane), but my point is that the read/write
got path should not be overloaded with data recovery.

> A normal read/write to a fsdax file would not pass the
> flag, which skips the poison checking with whatever MCE consequences
> that has, right?

Exactly!

> pwritev2(..., RWF_RECOVER_DATA) should be infrequent enough that
> carefully stepping around dax_direct_access only has to be faster than
> restoring from backup, I hope?

Yes.  And thus be kept as separate as possible.
