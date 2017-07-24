Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0ABF72193B82B
 for <linux-nvdimm@lists.01.org>; Sun, 23 Jul 2017 19:44:44 -0700 (PDT)
Date: Mon, 24 Jul 2017 10:46:27 +0800
From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH -mm -v2 00/12] mm, THP, swap: Delay splitting THP after
 swapped out
Message-ID: <20170724024622.GB12871@ming.t460p>
References: <20170623071303.13469-1-ying.huang@intel.com>
 <20170721162129.077f7d9b4c77c8593e47aed9@linux-foundation.org>
 <874lu2ircj.fsf@yhuang-dev.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <874lu2ircj.fsf@yhuang-dev.intel.com>
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
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>, linux-nvdimm@lists.01.org, Minchan Kim <minchan@kernel.org>, Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org, Michal Hocko <mhocko@kernel.org>, Jens Axboe <axboe@fb.com>, linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, Shaohua Li <shli@kernel.org>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jul 24, 2017 at 08:57:48AM +0800, Huang, Ying wrote:
> Andrew Morton <akpm@linux-foundation.org> writes:
> 
> > On Fri, 23 Jun 2017 15:12:51 +0800 "Huang, Ying" <ying.huang@intel.com> wrote:
> >
> >> From: Huang Ying <ying.huang@intel.com>
> >> 
> >> Hi, Andrew, could you help me to check whether the overall design is
> >> reasonable?
> >> 
> >> Hi, Johannes and Minchan, Thanks a lot for your review to the first
> >> step of the THP swap optimization!  Could you help me to review the
> >> second step in this patchset?
> >> 
> >> Hi, Hugh, Shaohua, Minchan and Rik, could you help me to review the
> >> swap part of the patchset?  Especially [01/12], [02/12], [03/12],
> >> [04/12], [11/12], and [12/12].
> >> 
> >> Hi, Andrea and Kirill, could you help me to review the THP part of the
> >> patchset?  Especially [01/12], [03/12], [07/12], [08/12], [09/12],
> >> [11/12].
> >> 
> >> Hi, Johannes, Michal, could you help me to review the cgroup part of
> >> the patchset?  Especially [08/12], [09/12], and [10/12].
> >> 
> >> And for all, Any comment is welcome!
> >
> > I guess it's time for a resend.  Folks, could we please get some more
> > review&test going here?
> 
> Sure.  Will resend it ASAP.  And Thanks for reminding!
> 
> >> Because the THP swap writing support patch [06/12] needs to be rebased
> >> on multipage bvec patchset which hasn't been merged yet.  The [06/12]
> >> in this patchset is just a test patch and will be rewritten later.
> >> The patchset depends on multipage bvec patchset too.
> >
> > Are these dependency issues any simpler now?
> 
> Ming Lei has sent the v2 of multipage bvec patchset on June 26th.  Jens
> Axboe thinks the patchset will target v4.14.
> 
> https://lkml.org/lkml/2017/6/26/538

I will rebase the patchset against v4.13-rcX and send v3 out later.


Thanks,
Ming
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
