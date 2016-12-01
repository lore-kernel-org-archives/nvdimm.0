Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0244981F19
 for <linux-nvdimm@lists.01.org>; Thu,  1 Dec 2016 08:33:46 -0800 (PST)
Date: Thu, 1 Dec 2016 17:33:40 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 2/6] dax: remove leading space from labels
Message-ID: <20161201163340.GA18212@quack2.suse.cz>
References: <1480549533-29038-1-git-send-email-ross.zwisler@linux.intel.com>
 <1480549533-29038-3-git-send-email-ross.zwisler@linux.intel.com>
 <20161201081144.GC12804@quack2.suse.cz>
 <20161201152619.GA5160@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20161201152619.GA5160@linux.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, Dave Chinner <david@fromorbit.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu 01-12-16 08:26:19, Ross Zwisler wrote:
> On Thu, Dec 01, 2016 at 09:11:44AM +0100, Jan Kara wrote:
> > On Wed 30-11-16 16:45:29, Ross Zwisler wrote:
> > > No functional change.
> > > 
> > > As of this commit:
> > > 
> > > commit 218dd85887da (".gitattributes: set git diff driver for C source code
> > > files")
> > > 
> > > git-diff and git-format-patch both generate diffs whose hunks are correctly
> > > prefixed by function names instead of labels, even if those labels aren't
> > > indented with spaces.
> > > 
> > > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > 
> > Didn't we agree do leave this for a bit later?
> 
> Sorry, I thought you just asked to not have to edit your "Page invalidation
> fixes" series because of this change.  This series is based on a tree that
> already includes your page invalidation work, so it shouldn't cause you any
> thrash.

Ah, I see, I didn't notice. Then it's fine :). Thanks.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
