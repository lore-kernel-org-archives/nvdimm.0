Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id B77BA1A1E85
 for <linux-nvdimm@lists.01.org>; Wed, 23 Mar 2016 09:42:38 -0700 (PDT)
Date: Wed, 23 Mar 2016 10:41:44 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 02/10] radix-tree: make 'indirect' bit available to
 exception entries.
Message-ID: <20160323164144.GA5544@linux.intel.com>
References: <1458566575-28063-1-git-send-email-jack@suse.cz>
 <1458566575-28063-3-git-send-email-jack@suse.cz>
 <20160321173458.GO23727@linux.intel.com>
 <20160322091232.GD4459@quack.suse.cz>
 <20160322092708.GV23727@linux.intel.com>
 <20160322103754.GE4459@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160322103754.GE4459@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, Wilcox,
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Mar 22, 2016 at 11:37:54AM +0100, Jan Kara wrote:
> On Tue 22-03-16 05:27:08, Matthew Wilcox wrote:
> > On Tue, Mar 22, 2016 at 10:12:32AM +0100, Jan Kara wrote:
> > > 		if (unlikely(!page))	// False since
> > > 					// RADIX_TREE_INDIRECT_PTR is set
> > > 		if (radix_tree_exception(page))	// False - no exeptional bit
> > 
> > Oops, you got confused:
> > 
> > static inline int radix_tree_exception(void *arg)
> > {
> >         return unlikely((unsigned long)arg &
> >                 (RADIX_TREE_INDIRECT_PTR | RADIX_TREE_EXCEPTIONAL_ENTRY));
> > }
> 
> Ah, I've confused radix_tree_exception() and
> radix_tree_exceptional_entry(). OK, so your code works AFAICT. But using
> RADIX_TREE_RETRY still doesn't make things clearer to me - you still need
> to check for INDIRECT bit in the retry logic to catch the
> radix_tree_extend() race as well...
> 
> As a side note I think we should do away with radix_tree_exception() - it
> isn't very useful (doesn't simplify any of its callers) and only creates
> possibility for confusion.

Perhaps it would be clearer if we explicitly enumerated the four radix tree
entry types?

#define RADIX_TREE_TYPE_MASK		3

#define	RADIX_TREE_TYPE_DATA		0
#define RADIX_TREE_TYPE_INDIRECT	1
#define	RADIX_TREE_TYPE_EXCEPTIONAL	2
#define RADIX_TREE_TYPE_LOCKED_EXC	3

This would make radix_tree_exception (which we could rename so it doesn't
get confused with "exceptional" entries):

static inline int radix_tree_non_data(void *arg)
{
        return unlikely((unsigned long)arg & RADIX_TREE_TYPE_MASK);
}

Etc?  I guess we'd have to code it up and see if the result was simpler, but
it seems like it might be.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
