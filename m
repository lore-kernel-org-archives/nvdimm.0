Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6811881D97
 for <linux-nvdimm@lists.01.org>; Thu,  1 Dec 2016 07:26:20 -0800 (PST)
Date: Thu, 1 Dec 2016 08:26:19 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v2 2/6] dax: remove leading space from labels
Message-ID: <20161201152619.GA5160@linux.intel.com>
References: <1480549533-29038-1-git-send-email-ross.zwisler@linux.intel.com>
 <1480549533-29038-3-git-send-email-ross.zwisler@linux.intel.com>
 <20161201081144.GC12804@quack2.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20161201081144.GC12804@quack2.suse.cz>
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
Cc: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, Christoph Hellwig <hch@lst.de>, linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Dec 01, 2016 at 09:11:44AM +0100, Jan Kara wrote:
> On Wed 30-11-16 16:45:29, Ross Zwisler wrote:
> > No functional change.
> > 
> > As of this commit:
> > 
> > commit 218dd85887da (".gitattributes: set git diff driver for C source code
> > files")
> > 
> > git-diff and git-format-patch both generate diffs whose hunks are correctly
> > prefixed by function names instead of labels, even if those labels aren't
> > indented with spaces.
> > 
> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> 
> Didn't we agree do leave this for a bit later?

Sorry, I thought you just asked to not have to edit your "Page invalidation
fixes" series because of this change.  This series is based on a tree that
already includes your page invalidation work, so it shouldn't cause you any
thrash.

I'll pull it out of the next version of this series.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
