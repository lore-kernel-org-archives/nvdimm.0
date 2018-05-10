Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F0BA221CB74B5
 for <linux-nvdimm@lists.01.org>; Thu, 10 May 2018 09:27:55 -0700 (PDT)
Date: Thu, 10 May 2018 09:27:42 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [External]  Re: [RFC PATCH v1 0/6] use mm to manage NVDIMM
 (pmem) zone
Message-ID: <20180510162742.GA30442@bombadil.infradead.org>
References: <1525704627-30114-1-git-send-email-yehs1@lenovo.com>
 <20180507184622.GB12361@bombadil.infradead.org>
 <CAPcyv4hBJN3npXwg3Ur32JSWtKvBUZh7F8W+Exx3BB-uKWwPag@mail.gmail.com>
 <x49a7tbi8r3.fsf@segfault.boston.devel.redhat.com>
 <HK2PR03MB1684659175EB0A11E75E9B61929A0@HK2PR03MB1684.apcprd03.prod.outlook.com>
 <20180508030959.GB16338@bombadil.infradead.org>
 <HK2PR03MB16841CBB549F40F86BB8D35C92990@HK2PR03MB1684.apcprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <HK2PR03MB16841CBB549F40F86BB8D35C92990@HK2PR03MB1684.apcprd03.prod.outlook.com>
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
Cc: Sasha Levin <alexander.levin@verizon.com>, Michal Hocko <mhocko@suse.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, NingTing Cheng <chengnt@lenovo.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "pasha.tatashin@oracle.com" <pasha.tatashin@oracle.com>, Linux MM <linux-mm@kvack.org>, Dave Hansen <dave.hansen@intel.com>, Johannes Weiner <hannes@cmpxchg.org>, "colyli@suse.de" <colyli@suse.de>, Mel Gorman <mgorman@techsingularity.net>, Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, May 09, 2018 at 04:47:54AM +0000, Huaisheng HS1 Ye wrote:
> > On Tue, May 08, 2018 at 02:59:40AM +0000, Huaisheng HS1 Ye wrote:
> > > Currently in our mind, an ideal use scenario is that, we put all page caches to
> > > zone_nvm, without any doubt, page cache is an efficient and common cache
> > > implement, but it has a disadvantage that all dirty data within it would has risk
> > > to be missed by power failure or system crash. If we put all page caches to NVDIMMs,
> > > all dirty data will be safe.
> > 
> > That's a common misconception.  Some dirty data will still be in the
> > CPU caches.  Are you planning on building servers which have enough
> > capacitance to allow the CPU to flush all dirty data from LLC to NV-DIMM?
> > 
> Sorry for not being clear.
> For CPU caches if there is a power failure, NVDIMM has ADR to guarantee an interrupt will be reported to CPU, an interrupt response function should be responsible to flush all dirty data to NVDIMM.
> If there is a system crush, perhaps CPU couldn't have chance to execute this response.
> 
> It is hard to make sure everything is safe, what we can do is just to save the dirty data which is already stored to Pagecache, but not in CPU cache.
> Is this an improvement than current?

No.  In the current situation, the user knows that either the entire
page was written back from the pagecache or none of it was (at least
with a journalling filesystem).  With your proposal, we may have pages
splintered along cacheline boundaries, with a mix of old and new data.
This is completely unacceptable to most customers.

> > Then there's the problem of reconnecting the page cache (which is
> > pointed to by ephemeral data structures like inodes and dentries) to
> > the new inodes.
> Yes, it is not easy.

Right ... and until we have that ability, there's no point in this patch.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
