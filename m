Return-Path: <owner-linux-mm@kvack.org>
Date: Mon, 11 Sep 2017 13:10:30 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCH v8 2/2] mm: introduce MAP_SHARED_VALIDATE, a
	mechanism to safely define new mmap flags
Message-ID: <20170911111030.GA20127@lst.de>
References: <150489930202.29460.5141541423730649272.stgit@dwillia2-desk3.amr.corp.intel.com> <150489931339.29460.8760855724603300792.stgit@dwillia2-desk3.amr.corp.intel.com> <20170911094714.GD8503@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170911094714.GD8503@quack2.suse.cz>
Sender: owner-linux-mm@kvack.org
To: Jan Kara <jack@suse.cz>
Cc: Dan Williams <dan.j.williams@intel.com>, torvalds@linux-foundation.org, Arnd Bergmann <arnd@arndb.de>, linux-nvdimm@lists.01.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Sep 11, 2017 at 11:47:14AM +0200, Jan Kara wrote:
> On Fri 08-09-17 12:35:13, Dan Williams wrote:
> > The mmap(2) syscall suffers from the ABI anti-pattern of not validating
> > unknown flags. However, proposals like MAP_SYNC and MAP_DIRECT need a
> > mechanism to define new behavior that is known to fail on older kernels
> > without the support. Define a new MAP_SHARED_VALIDATE flag pattern that
> > is guaranteed to fail on all legacy mmap implementations.
> > 
> > With this in place new flags can be defined as:
> > 
> >     #define MAP_new (MAP_SHARED_VALIDATE | val)
> 
> Is this changelog stale? Given MAP_SHARED_VALIDATE will be new mapping
> type, I'd expect we define new flags just as any other mapping flags...
> I see no reason why MAP_SHARED_VALIDATE should be or'ed to that.

Btw, I still think it should be a new hidden flag and not a new mapping
type.  I brought this up last time, so maybe I missed the answer
to my concern.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
