Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com
 [IPv6:2607:f8b0:4864:20::741])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8452221959CB2
 for <linux-nvdimm@lists.01.org>; Mon, 12 Nov 2018 12:37:43 -0800 (PST)
Received: by mail-qk1-x741.google.com with SMTP id r71so15722589qkr.10
 for <linux-nvdimm@lists.01.org>; Mon, 12 Nov 2018 12:37:43 -0800 (PST)
Date: Mon, 12 Nov 2018 20:37:37 +0000
From: Pavel Tatashin <pasha.tatashin@soleen.com>
Subject: Re: [mm PATCH v5 0/7] Deferred page init improvements
Message-ID: <20181112203737.e4jnsp4rxpie4trr@soleen.tm1wkky2jk1uhgkn0ivaxijq1c.bx.internal.cloudapp.net>
References: <20181109211521.5ospn33pp552k2xv@xakep.localdomain>
 <18b6634b912af7b4ec01396a2b0f3b31737c9ea2.camel@linux.intel.com>
 <20181110000006.tmcfnzynelaznn7u@xakep.localdomain>
 <0d8782742d016565870c578848138aaedf873a7c.camel@linux.intel.com>
 <20181110011652.2wozbvfimcnhogfj@xakep.localdomain>
 <CAKgT0UdDYC5RvZ1XgLTamFpBe3foPMs+SV_kSUVNDWLvxSC_1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAKgT0UdDYC5RvZ1XgLTamFpBe3foPMs+SV_kSUVNDWLvxSC_1Q@mail.gmail.com>
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
To: Alexander Duyck <alexander.duyck@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, pavel.tatashin@microsoft.com, rppt@linux.vnet.ibm.com, Michal Hocko <mhocko@suse.com>, linux-nvdimm@lists.01.org, LKML <linux-kernel@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>, Daniel Jordan <daniel.m.jordan@oracle.com>, linux-mm <linux-mm@kvack.org>, khalid.aziz@oracle.com, David Miller <davem@davemloft.net>, Vlastimil Babka <vbabka@suse.cz>, sparclinux@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, ldufour@linux.vnet.ibm.com, Mel Gorman <mgorman@techsingularity.net>, alexander.h.duyck@linux.intel.com, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On 18-11-12 11:10:35, Alexander Duyck wrote:
> 
> The point I was trying to make is that it doesn't. You say it is an
> order of magnitude better but it is essentially 3.5x vs 3.8x and to
> achieve the 3.8x you are using a ton of system resources. My approach
> is meant to do more with less, while this approach will throw a
> quarter of the system at  page initialization.

3.8x is a bug, that is going to be fixed before ktasks are accepted. The
final results will be close to time/nthreads.
Using more resources to initialize pages is fine, because other CPUs are
idling during this time in boot.

Lets wait for what Daniel finds out after Linux Plumber. And we can
continue this discussion in ktask thread.

> 
> An added advantage to my approach is that it speeds up things
> regardless of the number of cores used, whereas the scaling approach

Yes, I agree, I like your approach. It is clean, simplifies, and
improves the performance. I have tested it on both ARM and x86, and
verified the performance improvements. So:

Tested-by: Pavel Tatashin <pasha.tatashin@soleen.com>


> requires that there be more cores available to use. So for example on
> some of the new AMD Zen stuff I am not sure the benefit would be all
> that great since if I am not mistaken each tile is only 8 processors
> so at most you are only doubling the processing power applied to the
> initialization. In such a case it is likely that my approach would
> fare much better then this approach since I don't require additional
> cores to achieve the same results.
> 
> Anyway there are tradeoffs we have to take into account.
> 
> I will go over the changes you suggested after Plumbers. I just need
> to figure out if I am doing incremental changes, or if Andrew wants me
> to just resubmit the whole set. I can probably deal with these changes
> either way since most of them are pretty small.

Send the full series again, Andrew is very good at taking only
incremental  changes once a new version is posted of something
that is already in mm-tree.

Thank you,
Pasha
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
