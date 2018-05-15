Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 887E3209603C7
 for <linux-nvdimm@lists.01.org>; Tue, 15 May 2018 09:20:23 -0700 (PDT)
Date: Tue, 15 May 2018 09:20:03 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [External]  Re: [RFC PATCH v1 0/6] use mm to manage NVDIMM
 (pmem) zone
Message-ID: <20180515162003.GA26489@bombadil.infradead.org>
References: <1525704627-30114-1-git-send-email-yehs1@lenovo.com>
 <20180507184622.GB12361@bombadil.infradead.org>
 <CAPcyv4hBJN3npXwg3Ur32JSWtKvBUZh7F8W+Exx3BB-uKWwPag@mail.gmail.com>
 <x49a7tbi8r3.fsf@segfault.boston.devel.redhat.com>
 <HK2PR03MB1684659175EB0A11E75E9B61929A0@HK2PR03MB1684.apcprd03.prod.outlook.com>
 <20180508030959.GB16338@bombadil.infradead.org>
 <HK2PR03MB16841CBB549F40F86BB8D35C92990@HK2PR03MB1684.apcprd03.prod.outlook.com>
 <20180510162742.GA30442@bombadil.infradead.org>
 <HK2PR03MB1684B34F9D1DF18A8CDE18F292930@HK2PR03MB1684.apcprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <HK2PR03MB1684B34F9D1DF18A8CDE18F292930@HK2PR03MB1684.apcprd03.prod.outlook.com>
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
To: Huaisheng HS1 Ye <yehs1@lenovo.com>
Cc: Sasha Levin <alexander.levin@verizon.com>, Michal Hocko <mhocko@suse.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, NingTing Cheng <chengnt@lenovo.com>, Ocean HY1 He <hehy1@lenovo.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "pasha.tatashin@oracle.com" <pasha.tatashin@oracle.com>, Linux MM <linux-mm@kvack.org>, Dave Hansen <dave.hansen@intel.com>, Johannes Weiner <hannes@cmpxchg.org>, "colyli@suse.de" <colyli@suse.de>, Mel Gorman <mgorman@techsingularity.net>, Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, May 15, 2018 at 04:07:28PM +0000, Huaisheng HS1 Ye wrote:
> > From: owner-linux-mm@kvack.org [mailto:owner-linux-mm@kvack.org] On Behalf Of Matthew
> > Wilcox
> > No.  In the current situation, the user knows that either the entire
> > page was written back from the pagecache or none of it was (at least
> > with a journalling filesystem).  With your proposal, we may have pages
> > splintered along cacheline boundaries, with a mix of old and new data.
> > This is completely unacceptable to most customers.
> 
> Dear Matthew,
> 
> Thanks for your great help, I really didn't consider this case.
> I want to make it a little bit clearer to me. So, correct me if anything wrong.
> 
> Is that to say this mix of old and new data in one page, which only has chance to happen when CPU failed to flush all dirty data from LLC to NVDIMM?
> But if an interrupt can be reported to CPU, and CPU successfully flush all dirty data from cache lines to NVDIMM within interrupt response function, this mix of old and new data can be avoided.

If you can keep the CPU and the memory (and all the busses between them)
alive for long enough after the power signal hs been tripped, yes.
Talk to your hardware designers about what it will take to achieve this
:-) Be sure to ask about the number of retries which may be necessary
on the CPU interconnect to flush all data to an NV-DIMM attached to a
remote CPU.

> Current X86_64 uses N-way set associative cache, and every cache line has 64 bytes.
> For 4096 bytes page, one page shall be splintered to 64 (4096/64) lines. Is it right?

That's correct.

> > > > Then there's the problem of reconnecting the page cache (which is
> > > > pointed to by ephemeral data structures like inodes and dentries) to
> > > > the new inodes.
> > > Yes, it is not easy.
> > 
> > Right ... and until we have that ability, there's no point in this patch.
> We are focusing to realize this ability.

But is it the right approach?  So far we have (I think) two parallel
activities.  The first is for local storage, using DAX to store files
directly on the pmem.  The second is a physical block cache for network
filesystems (both NAS and SAN).  You seem to be wanting to supplant the
second effort, but I think it's much harder to reconnect the logical cache
(ie the page cache) than it is the physical cache (ie the block cache).

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
