Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD51C2C81
	for <nvdimm@lists.linux.dev>; Fri, 22 Oct 2021 05:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+YDMPVpxVm8p9MUlUXzErZxvxROH6gniSaBDcG7u9TY=; b=HeJKI/GV+Bphar28aSxvNfHN7F
	PLzh2q5WkuWMqVzrxjqAwTTPxYsEElxMc9Pn1mbMhzYkNtzB5c0RXFEXR8Fi5DaRlyo9x0F2RYbxM
	qeCZS+ZThU9uOKaedUc1UT1ZsvdTPQLDWj3YEXIg1dVlcKr6PjPFlhSLlydBXd5iFQgsKmj6GyOKt
	3AEA3Gwqc3oZ6ugPu97G4Nv22shMJOEnMMXUuaTH2rCt6TIIlAnl+oRmsvZBq3mcZnKMqgwR3rV6X
	Wj3/HI6mE8nEOKYDinJj9O4k7rQHMzEzzMsthVsIQyDhDEpDmoNdf+GWPgV0upMGxg79BAsY5HlgI
	jdGaySvg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mdnEI-009lYf-Qe; Fri, 22 Oct 2021 05:36:34 +0000
Date: Thu, 21 Oct 2021 22:36:34 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jane Chu <jane.chu@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"djwong@kernel.org" <djwong@kernel.org>,
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
Message-ID: <YXJN4s1HC/Y+KKg1@infradead.org>
References: <20211021001059.438843-1-jane.chu@oracle.com>
 <YXFPfEGjoUaajjL4@infradead.org>
 <e89a2b17-3f03-a43e-e0b9-5d2693c3b089@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e89a2b17-3f03-a43e-e0b9-5d2693c3b089@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Oct 22, 2021 at 01:37:28AM +0000, Jane Chu wrote:
> On 10/21/2021 4:31 AM, Christoph Hellwig wrote:
> > Looking over the series I have serious doubts that overloading the
> > slow path clear poison operation over the fast path read/write
> > path is such a great idea.
> > 
> 
> Understood, sounds like a concern on principle. But it seems to me
> that the task of recovery overlaps with the normal write operation
> on the write part. Without overloading some write operation for
> 'recovery', I guess we'll need to come up with a new userland
> command coupled with a new dax API ->clear_poison and propagate the
> new API support to each dm targets that support dax which, again,
> is an idea that sounds too bulky if I recall Dan's earlier rejection
> correctly.

When I wrote the above I mostly thought about the in-kernel API, that
is use a separate method.  But reading your mail and thinking about
this a bit more I'm actually less and less sure that overloading
pwritev2 and preadv2 with this at the syscall level makes sense either.
read/write are our I/O fast path.  We really should not overload the
core of the VFS with error recovery for a broken hardware interface.
