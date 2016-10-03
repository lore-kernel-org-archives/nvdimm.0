From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/6] dax: Page invalidation fixes
Date: Mon, 3 Oct 2016 15:01:44 +0200
Message-ID: <20161003130144.GS6457@quack2.suse.cz>
References: <1474994615-29553-1-git-send-email-jack@suse.cz>
 <20160930085905.GF22381@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160930085905.GF22381@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>
List-Id: linux-nvdimm@lists.01.org

On Fri 30-09-16 01:59:05, Christoph Hellwig wrote:
> On Tue, Sep 27, 2016 at 06:43:29PM +0200, Jan Kara wrote:
> > Hello,
> > 
> > these patches fix races when invalidating hole pages in DAX mappings. See
> > changelogs for details. The series is based on my patches to write-protect
> > DAX PTEs because we really need to closely track dirtiness (and cleanness!)
> > of radix tree entries in DAX mappings in order to avoid discarding valid
> > dirty bits leading to missed cache flushes on fsync(2).
> 
> Except for the VM magic I don't feel qualified to review this looks fine
> to me.  But don't we need to switch ext4 away from going through the DIO
> path first before the limited invalidation is effective there?
> Otherwise we'll still get the full range invalidation from
> generic_file_direct_write?

After patch 5/6 the additional invalidation we get from
generic_file_direct_write() for ext4 is racy but not doing any harm since
we later do a reliable invalidation directly from dax_io() which patch 6/6
takes care to update. So it will be inefficient but it will work. Once ext4
is converted we get rid of this redundancy.

BTW I have locally patches that avoid this inefficiency for ext4 but I
figured there's no point in posting them since we want to convert ext4 to
iomap interface sooner rather than later.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
