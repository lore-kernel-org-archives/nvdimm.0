Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x235.google.com (mail-ot0-x235.google.com
 [IPv6:2607:f8b0:4003:c0f::235])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4C1748029D
 for <linux-nvdimm@lists.01.org>; Thu, 16 Mar 2017 12:04:49 -0700 (PDT)
Received: by mail-ot0-x235.google.com with SMTP id o24so66763035otb.1
 for <linux-nvdimm@lists.01.org>; Thu, 16 Mar 2017 12:04:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170316174805.GB13654@dhcp22.suse.cz>
References: <148964440651.19438.2288075389153762985.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170316174805.GB13654@dhcp22.suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 16 Mar 2017 12:04:48 -0700
Message-ID: <CAPcyv4hMt0s7UX=MO9KwakjXG9Uff=8XGR+Uc7YoVWoLqbKeGw@mail.gmail.com>
Subject: Re: [PATCH v4 00/13] mm: sub-section memory hotplug support
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
To: Michal Hocko <mhocko@kernel.org>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Mel Gorman <mgorman@techsingularity.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stephen Bates <stephen.bates@microsemi.com>, Linux MM <linux-mm@kvack.org>, Nicolai Stange <nicstange@gmail.com>, Alexander Potapenko <glider@google.com>, Vlastimil Babka <vbabka@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Andrew Morton <akpm@linux-foundation.org>, Dmitry Vyukov <dvyukov@google.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 16, 2017 at 10:48 AM, Michal Hocko <mhocko@kernel.org> wrote:
> Hi,
> I didn't get to look through the patch series yet and I might not be
> able before LSF/MM. How urgent is this? I am primarily asking because
> the memory hotplug is really convoluted right now and putting more on
> top doesn't really sound like the thing we really want. I have tried to
> simplify the code [1] already but this is an early stage work so I do
> not want to impose any burden on you. So I am wondering whether this
> is something that needs to be merged very soon or it can wait for the
> rework and hopefully end up being much simpler in the end as well.
>
> What do you think?

In general, I think it's better to add new features after
reworks/cleanup, but it's not clear to me (yet) that the problem you
are trying to solve makes this sub-section enabling for ZONE_DEVICE
any simpler.

> [1] http://lkml.kernel.org/r/20170315091347.GA32626@dhcp22.suse.cz

ZONE_DEVICE pages are never "online". The patch says "Instead we do
page->zone association from move_pfn_range which is called from
online_pages." which means the new scheme currently doesn't comprehend
the sprinkled ZONE_DEVICE hacks in the memory hotplug code.

However, that said, I might take a look at whether the hacks belong in
the auto-online code so that we can share the delayed zone
initialization, but still skip marking the memory online per the
expectations of ZONE_DEVICE. I expect it would be confusing to have
memblock devices in sysfs for ranges that can't be marked online?

Thoughts?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
