From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 5/6] mm: Invalidate DAX radix tree entries only if
 appropriate
Date: Mon, 3 Oct 2016 14:56:43 +0200
Message-ID: <20161003125643.GR6457@quack2.suse.cz>
References: <1474994615-29553-1-git-send-email-jack@suse.cz>
 <1474994615-29553-6-git-send-email-jack@suse.cz>
 <20160930085714.GE22381@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160930085714.GE22381@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>
List-Id: linux-nvdimm@lists.01.org

On Fri 30-09-16 01:57:14, Christoph Hellwig wrote:
> On Tue, Sep 27, 2016 at 06:43:34PM +0200, Jan Kara wrote:
> > Currently invalidate_inode_pages2_range() and invalidate_mapping_pages()
> > just delete all exceptional radix tree entries they find. For DAX this
> > is not desirable as we track cache dirtiness in these entries and when
> > they are evicted, we may not flush caches although it is necessary. This
> > can for example manifest when we write to the same block both via mmap
> > and via write(2) (to different offsets) and fsync(2) then does not
> > properly flush CPU caches when modification via write(2) was the last
> > one.
> 
> Can you come up with an xfstests test case for these data loss cases?

I'm not sure how to easily do this. For DAX to be enabled, we need
memory-like storage so there's no easy way to intercept writes that may be
only in CPU caches but not in the persistent memory. Eventually we may want
to write a DAX flush testing driver - something like ramdisk but that would
keep "cached" and "persistent" version of each page and on wb_cache_pmem()
copy one version to the other. We'd also need to hook into
copy_from_iter_nocache() and stuff to make cache-avoiding writes behave as
expected but all in all it should be doable...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
