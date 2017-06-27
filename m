Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B56EB21A00AD1
 for <linux-nvdimm@lists.01.org>; Tue, 27 Jun 2017 15:03:29 -0700 (PDT)
From: "Luck, Tony" <tony.luck@intel.com>
Subject: RE: [PATCH] mm/hwpoison: Clear PRESENT bit for kernel 1:1 mappings
 of poison pages
Date: Tue, 27 Jun 2017 22:04:58 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F612E4285@ORSMSX114.amr.corp.intel.com>
References: <20170616190200.6210-1-tony.luck@intel.com>
 <20170619180147.qolal6mz2wlrjbxk@pd.tnic>
 <20170621174740.npbtg2e4o65tyrss@intel.com>
 <AT5PR84MB00823EB30BD7BF0EA3DAFF0BABD80@AT5PR84MB0082.NAMPRD84.PROD.OUTLOOK.COM>
In-Reply-To: <AT5PR84MB00823EB30BD7BF0EA3DAFF0BABD80@AT5PR84MB0082.NAMPRD84.PROD.OUTLOOK.COM>
Content-Language: en-US
MIME-Version: 1.0
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
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, Borislav Petkov <bp@suse.de>
Cc: "Hansen, Dave" <dave.hansen@intel.com>, "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Yazen Ghannam <yazen.ghannam@amd.com>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

> > > > +if (set_memory_np(decoy_addr, 1))
> > > > +pr_warn("Could not invalidate pfn=0x%lx from 1:1 map \n",
>
> Another concept to consider is mapping the page as UC rather than
> completely unmapping it.

UC would also avoid the speculative prefetch issue.  The Vol 3, Section 11.3 SDM says:

Strong Uncacheable (UC) -System memory locations are not cached. All reads and writes
appear on the system bus and are executed in program order without reordering. No speculative
memory accesses, pagetable walks, or prefetches of speculated branch targets are made.
This type of cache-control is useful for memory-mapped I/O devices. When used with normal
RAM, it greatly reduces processor performance.

But then I went and read the code for set_memory_uc() ... which calls "reserve_memtyep()"
which does all kinds of things to avoid issues with MTRRs and other stuff.  Which all looks
really more complex that we need just here.

> The uncorrectable error scope could be smaller than a page size, like:
> * memory ECC width (e.g., 8 bytes)
> * cache line size (e.g., 64 bytes)
> * block device logical block size (e.g., 512 bytes, for persistent memory)
>
> UC preserves the ability to access adjacent data within the page that
> hasn't gone bad, and is particularly useful for persistent memory.

If you want to dig into the non-poisoned pieces of the page later it might be
better to set up a new scratch UC mapping to do that.

My takeaway from Dan's comments on unpoisoning is that this isn't the context
that he wants to do that.  He'd rather wait until he has somebody overwriting the
page with fresh data.

So I think I'd like to keep the patch as-is.

-Tony
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
