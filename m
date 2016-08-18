Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7AA321A1E08
 for <linux-nvdimm@lists.01.org>; Thu, 18 Aug 2016 07:15:55 -0700 (PDT)
Date: Thu, 18 Aug 2016 16:15:50 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 5/7] dax: lock based on slot instead of [mapping, index]
Message-ID: <20160818141550.GA2382@quack2.suse.cz>
References: <20160815190918.20672-1-ross.zwisler@linux.intel.com>
 <20160815190918.20672-6-ross.zwisler@linux.intel.com>
 <20160816092816.GE27284@quack2.suse.cz>
 <20160817202556.GA13009@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160817202556.GA13009@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed 17-08-16 14:25:56, Ross Zwisler wrote:
> On Tue, Aug 16, 2016 at 11:28:16AM +0200, Jan Kara wrote:
> > On Mon 15-08-16 13:09:16, Ross Zwisler wrote:
> > > DAX radix tree locking currently locks entries based on the unique
> > > combination of the 'mapping' pointer and the pgoff_t 'index' for the entry.
> > > This works for PTEs, but as we move to PMDs we will need to have all the
> > > offsets within the range covered by the PMD to map to the same bit lock.
> > > To accomplish this, lock based on the 'slot' pointer in the radix tree
> > > instead of [mapping, index].
> > 
> > I'm not convinced this is safe. What makes the slot pointer still valid
> > after you drop tree_lock? At least radix_tree_shrink() or
> > radix_tree_expand() could move your slot without letting the waiter know
> > and he would be never woken.
> > 
> > 								Honza
> 
> Yep, you're right, thanks for catching that.
> 
> Given that we can't rely on 'slot' being stable, my next idea is to use a
> combination of [mapping, index], but tweak 'index' so that it's always the
> beginning of the entry.  So for 4k entries we'd leave it alone, but for 2MiB
> entries we'd mask it down to the appropriate 2MiB barrier.
> 
> Let me hack on that for a bit, unless you've a better idea.

No, that's what I'd do as well.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
