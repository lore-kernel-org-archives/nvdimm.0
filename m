Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 68C431A1E56
 for <linux-nvdimm@lists.01.org>; Wed, 19 Oct 2016 11:25:27 -0700 (PDT)
Date: Wed, 19 Oct 2016 12:25:25 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 18/20] dax: Make cache flushing protected by entry lock
Message-ID: <20161019182525.GA27720@linux.intel.com>
References: <1474992504-20133-1-git-send-email-jack@suse.cz>
 <1474992504-20133-19-git-send-email-jack@suse.cz>
 <20161018192013.GE7796@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20161018192013.GE7796@linux.intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, Dan Williams <dan.j.williams@intel.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Jean Delvare <jdelvare@suse.de>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Oct 18, 2016 at 01:20:13PM -0600, Ross Zwisler wrote:
> On Tue, Sep 27, 2016 at 06:08:22PM +0200, Jan Kara wrote:
> > Currently, flushing of caches for DAX mappings was ignoring entry lock.
> > So far this was ok (modulo a bug that a difference in entry lock could
> > cause cache flushing to be mistakenly skipped) but in the following
> > patches we will write-protect PTEs on cache flushing and clear dirty
> > tags. For that we will need more exclusion. So do cache flushing under
> > an entry lock. This allows us to remove one lock-unlock pair of
> > mapping->tree_lock as a bonus.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> > @@ -716,15 +736,13 @@ static int dax_writeback_one(struct block_device *bdev,
> >  	}
> >  
> >  	wb_cache_pmem(dax.addr, dax.size);
> > -
> > -	spin_lock_irq(&mapping->tree_lock);
> > -	radix_tree_tag_clear(page_tree, index, PAGECACHE_TAG_TOWRITE);
> > -	spin_unlock_irq(&mapping->tree_lock);
> > - unmap:
> > +unmap:
> >  	dax_unmap_atomic(bdev, &dax);
> > +	put_locked_mapping_entry(mapping, index, entry);
> >  	return ret;
> >  
> > - unlock:
> > +put_unlock:
> 
> I know there's an ongoing debate about this, but can you please stick a space
> in front of the labels to make the patches pretty & to be consistent with the
> rest of the DAX code?

Never mind, it looks like the need for labels has been fixed with this commit:

commit 218dd85887da (".gitattributes: set git diff driver for C source code
files")

With this, my git at least generates diffs that don't use labels in the chunk
start, even without spaces.

Feel free to leave out the spaces, and we can remove the stragglers from
fs/dax.c at some point.

Thanks, Jean, for fixing this!
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
