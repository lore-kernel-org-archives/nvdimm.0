Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from merlin.infradead.org (merlin.infradead.org
 [IPv6:2001:8b0:10b:1231::1])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EDA01223DB11D
 for <linux-nvdimm@lists.01.org>; Sun, 11 Mar 2018 04:21:35 -0700 (PDT)
Date: Sun, 11 Mar 2018 12:27:26 +0100
From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v5 08/11] wait_bit: introduce {wait_on, wake_up}_atomic_one
Message-ID: <20180311112725.GC4043@hirez.programming.kicks-ass.net>
References: <152066488891.40260.14605734226832760468.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152066493247.40260.10849841915366086021.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <152066493247.40260.10849841915366086021.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, david@fromorbit.com, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Mar 09, 2018 at 10:55:32PM -0800, Dan Williams wrote:
> Add a generic facility for awaiting an atomic_t to reach a value of 1.
> 
> Page reference counts typically need to reach 0 to be considered a
> free / inactive page. However, ZONE_DEVICE pages allocated via
> devm_memremap_pages() are never 'onlined', i.e. the put_page() typically
> done at init time to assign pages to the page allocator is skipped.
> 
> These pages will have their reference count elevated > 1 by
> get_user_pages() when they are under DMA. In order to coordinate DMA to
> these pages vs filesytem operations like hole-punch and truncate the
> filesystem-dax implementation needs to capture the DMA-idle event i.e.
> the 2 to 1 count transition).
> 
> For now, this implementation does not have functional behavior change,
> follow-on patches will add waiters for these page-idle events.

Argh, no no no.. That whole wait_for_atomic_t thing is a giant
trainwreck already and now you're making it worse still.

Please have a look here:

  https://lkml.kernel.org/r/20171101190644.chwhfpoz3ywxx2m7@hirez.programming.kicks-ass.net



_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
