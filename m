Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 08AC22097DD14
 for <linux-nvdimm@lists.01.org>; Mon, 16 Jul 2018 14:00:22 -0700 (PDT)
Date: Mon, 16 Jul 2018 14:00:14 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v2 05/14] mm, memremap: Up-level foreach_order_pgoff()
Message-ID: <20180716210014.GA1607@bombadil.infradead.org>
References: <153176041838.12695.3365448145295112857.stgit@dwillia2-desk3.amr.corp.intel.com>
 <153176044796.12695.10692625606054072713.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <153176044796.12695.10692625606054072713.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jul 16, 2018 at 10:00:48AM -0700, Dan Williams wrote:
> The foreach_order_pgoff() helper takes advantage of the ability to
> insert multi-order entries into a radix. It is currently used by
> devm_memremap_pages() to minimize the number of entries in the pgmap
> radix. Instead of dividing a range by a constant power-of-2 sized unit
> and inserting an entry for each unit, it determines the maximum
> power-of-2 sized entry (subject to alignment offset) that can be
> inserted at each iteration.
> 
> Up-level this helper so it can be used for populating other radix
> instances. For example asynchronous-memmap-initialization-thread lookups
> arriving in a follow on change.

Hopefully by the time you're back, I'll have this code replaced with
the XArray.  Here's my proposed API:

	old = xa_store_range(xa, first, last, ptr, GFP_KERNEL);

and then you'd simply use xa_for_each() as an iterator.  You'd do one
iteration for each range in the XArray, not for each entry occupied.
So there's a difference between:

	xa_store(xa, 1, ptr, GFP_KERNEL);
	xa_store(xa, 2, ptr, GFP_KERNEL);
	xa_store(xa, 3, ptr, GFP_KERNEL);

and

	xa_store_range(xa, 1, 3, ptr, GFP_KERNEL);

	index = 0; i = 0;
	xa_for_each(xa, p, index, ULONG_MAX, XA_PRESENT)
		i++;

will return i = 3 for the first case and i = 1 for the second.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
