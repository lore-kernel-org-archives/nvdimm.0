Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0C1C1802B4
 for <linux-nvdimm@lists.01.org>; Sun, 19 Mar 2017 09:35:40 -0700 (PDT)
Date: Sun, 19 Mar 2017 12:35:31 -0400
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v4 00/13] mm: sub-section memory hotplug support
Message-ID: <20170319163531.GA25835@dhcp22.suse.cz>
References: <148964440651.19438.2288075389153762985.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170316174805.GB13654@dhcp22.suse.cz>
 <CAPcyv4hMt0s7UX=MO9KwakjXG9Uff=8XGR+Uc7YoVWoLqbKeGw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4hMt0s7UX=MO9KwakjXG9Uff=8XGR+Uc7YoVWoLqbKeGw@mail.gmail.com>
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Mel Gorman <mgorman@techsingularity.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stephen Bates <stephen.bates@microsemi.com>, Linux MM <linux-mm@kvack.org>, Nicolai Stange <nicstange@gmail.com>, Alexander Potapenko <glider@google.com>, Vlastimil Babka <vbabka@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Andrew Morton <akpm@linux-foundation.org>, Dmitry Vyukov <dvyukov@google.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu 16-03-17 12:04:48, Dan Williams wrote:
> On Thu, Mar 16, 2017 at 10:48 AM, Michal Hocko <mhocko@kernel.org> wrote:
> > Hi,
> > I didn't get to look through the patch series yet and I might not be
> > able before LSF/MM. How urgent is this? I am primarily asking because
> > the memory hotplug is really convoluted right now and putting more on
> > top doesn't really sound like the thing we really want. I have tried to
> > simplify the code [1] already but this is an early stage work so I do
> > not want to impose any burden on you. So I am wondering whether this
> > is something that needs to be merged very soon or it can wait for the
> > rework and hopefully end up being much simpler in the end as well.
> >
> > What do you think?
> 
> In general, I think it's better to add new features after
> reworks/cleanup, but it's not clear to me (yet) that the problem you
> are trying to solve makes this sub-section enabling for ZONE_DEVICE
> any simpler.
> 
> > [1] http://lkml.kernel.org/r/20170315091347.GA32626@dhcp22.suse.cz
> 
> ZONE_DEVICE pages are never "online". The patch says "Instead we do
> page->zone association from move_pfn_range which is called from
> online_pages." which means the new scheme currently doesn't comprehend
> the sprinkled ZONE_DEVICE hacks in the memory hotplug code.

I hope we can get rid of those...
 
> However, that said, I might take a look at whether the hacks belong in
> the auto-online code so that we can share the delayed zone
> initialization, but still skip marking the memory online per the
> expectations of ZONE_DEVICE.

I think this should be trivial. AFAIU it should be sufficient to split
my move_pfn_range into online_pfn_range which would do the MMOP_ONLINE*
handling and the real move_pfn_range which would do the zone specific
association. Your devm_memremap_pages would then call this
move_pfn_range after arch_add_memory. Or am I overlooking something?

I would still have to addapt your changes to remove hardcoded section
aligned expectations but that shouldn't be a big problem I guess. I
still haven't looked into those deeply to fully understand them.

> I expect it would be confusing to have
> memblock devices in sysfs for ranges that can't be marked online?

Well, if their only valid_zone would be ZONE_DEVICE then I believe it
shouldn't be confusing much.
-- 
Michal Hocko
SUSE Labs
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
