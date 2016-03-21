Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by ml01.01.org (Postfix) with ESMTP id 9A0ED1A1FD8
 for <linux-nvdimm@lists.01.org>; Mon, 21 Mar 2016 16:45:16 -0700 (PDT)
Resent-Message-ID: <20160321234534.GT23727@linux.intel.com>
Resent-To: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
 linux-nvdimm@lists.01.org, NeilBrown <neilb@suse.com>,
 "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
 "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Date: Mon, 21 Mar 2016 13:41:03 -0400
From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [RFC v2] [PATCH 0/10] DAX page fault locking
Message-ID: <20160321174103.GP23727@linux.intel.com>
References: <1458566575-28063-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1458566575-28063-1-git-send-email-jack@suse.cz>
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
Cc: linux-fsdevel@vger.kernel.org, "Wilcox, Matthew R  <matthew.r.wilcox@intel.com>, NeilBrown <neilb@suse.com>, Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Mar 21, 2016 at 02:22:45PM +0100, Jan Kara wrote:
> The basic idea is that we use a bit in an exceptional radix tree entry as
> a lock bit and use it similarly to how page lock is used for normal faults.
> That way we fix races between hole instantiation and read faults of the
> same index. For now I have disabled PMD faults since there the issues with
> page fault locking are even worse. Now that Matthew's multi-order radix tree
> has landed, I can have a look into using that for proper locking of PMD faults
> but first I want normal pages sorted out.

FYI, the multi-order radix tree code that landed is unusably buggy.
Ross and I have been working like madmen for the past three weeks to fix
all of the bugs we've found and not introduce new ones.  The radix tree
test suite has been enormously helpful in this regard, but we're still
finding corner cases (thanks, RCU! ;-)

Our current best effort can be found hiding in
http://git.infradead.org/users/willy/linux-dax.git/shortlog/refs/heads/radix-fixes-2016-03-15
but it's for sure not ready for review yet.  I just don't want other
people trying to use the facility and wasting their time.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
