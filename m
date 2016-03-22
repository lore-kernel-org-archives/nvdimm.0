Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B83891A1E4F
 for <linux-nvdimm@lists.01.org>; Tue, 22 Mar 2016 03:37:53 -0700 (PDT)
Date: Tue, 22 Mar 2016 11:37:54 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 02/10] radix-tree: make 'indirect' bit available to
 exception entries.
Message-ID: <20160322103754.GE4459@quack.suse.cz>
References: <1458566575-28063-1-git-send-email-jack@suse.cz>
 <1458566575-28063-3-git-send-email-jack@suse.cz>
 <20160321173458.GO23727@linux.intel.com>
 <20160322091232.GD4459@quack.suse.cz>
 <20160322092708.GV23727@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160322092708.GV23727@linux.intel.com>
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
To: Matthew Wilcox <willy@linux.intel.com>
Cc: linux-fsdevel@vger.kernel.org, "Wilcox, Matthew R  <matthew.r.wilcox@intel.com>, Jan Kara <jack@suse.cz>, NeilBrown" <neilb@suse.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue 22-03-16 05:27:08, Matthew Wilcox wrote:
> On Tue, Mar 22, 2016 at 10:12:32AM +0100, Jan Kara wrote:
> > 		if (unlikely(!page))	// False since
> > 					// RADIX_TREE_INDIRECT_PTR is set
> > 		if (radix_tree_exception(page))	// False - no exeptional bit
> 
> Oops, you got confused:
> 
> static inline int radix_tree_exception(void *arg)
> {
>         return unlikely((unsigned long)arg &
>                 (RADIX_TREE_INDIRECT_PTR | RADIX_TREE_EXCEPTIONAL_ENTRY));
> }

Ah, I've confused radix_tree_exception() and
radix_tree_exceptional_entry(). OK, so your code works AFAICT. But using
RADIX_TREE_RETRY still doesn't make things clearer to me - you still need
to check for INDIRECT bit in the retry logic to catch the
radix_tree_extend() race as well...

As a side note I think we should do away with radix_tree_exception() - it
isn't very useful (doesn't simplify any of its callers) and only creates
possibility for confusion.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
