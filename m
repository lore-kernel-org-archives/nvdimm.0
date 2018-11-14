Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 25DC521190710
 for <linux-nvdimm@lists.01.org>; Wed, 14 Nov 2018 13:35:04 -0800 (PST)
Date: Wed, 14 Nov 2018 22:35:00 +0100
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [mm PATCH v5 0/7] Deferred page init improvements
Message-ID: <20181114213500.GF23419@dhcp22.suse.cz>
References: <154145268025.30046.11742652345962594283.stgit@ahduyck-desk1.jf.intel.com>
 <20181114150742.GZ23419@dhcp22.suse.cz>
 <20181114191253.rpwm4d23yeahnavw@soleen.tm1wkky2jk1uhgkn0ivaxijq1c.bx.internal.cloudapp.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20181114191253.rpwm4d23yeahnavw@soleen.tm1wkky2jk1uhgkn0ivaxijq1c.bx.internal.cloudapp.net>
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
To: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: mingo@kernel.org, pavel.tatashin@microsoft.com, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, willy@infradead.org, davem@davemloft.net, linux-mm@kvack.org, khalid.aziz@oracle.com, rppt@linux.vnet.ibm.com, vbabka@suse.cz, sparclinux@vger.kernel.org, Alexander Duyck <alexander.h.duyck@linux.intel.com>, ldufour@linux.vnet.ibm.com, mgorman@techsingularity.net, akpm@linux-foundation.org, kirill.shutemov@linux.intel.com
List-ID: <linux-nvdimm@lists.01.org>

On Wed 14-11-18 19:12:53, Pavel Tatashin wrote:
> On 18-11-14 16:07:42, Michal Hocko wrote:
> > On Mon 05-11-18 13:19:25, Alexander Duyck wrote:
> > > This patchset is essentially a refactor of the page initialization logic
> > > that is meant to provide for better code reuse while providing a
> > > significant improvement in deferred page initialization performance.
> > > 
> > > In my testing on an x86_64 system with 384GB of RAM and 3TB of persistent
> > > memory per node I have seen the following. In the case of regular memory
> > > initialization the deferred init time was decreased from 3.75s to 1.06s on
> > > average. For the persistent memory the initialization time dropped from
> > > 24.17s to 19.12s on average. This amounts to a 253% improvement for the
> > > deferred memory initialization performance, and a 26% improvement in the
> > > persistent memory initialization performance.
> > > 
> > > I have called out the improvement observed with each patch.
> > 
> > I have only glanced through the code (there is a lot of the code to look
> > at here). And I do not like the code duplication and the way how you
> > make the hotplug special. There shouldn't be any real reason for that
> > IMHO (e.g. why do we init pfn-at-a-time in early init while we do
> > pageblock-at-a-time for hotplug). I might be wrong here and the code
> > reuse might be really hard to achieve though.
> 
> I do not like having __init_single_page() to be done differently for
> hotplug. I think, if that is fixed, there is almost no more code
> duplication, the rest looks alright to me.

There is still that zone device special casing which I have brought up
previously but I reckon this is out of scope of this series.

> > I am also not impressed by new iterators because this api is quite
> > complex already. But this is mostly a detail.
> 
> I have reviewed all the patches in this series, and at first was also
> worried about the new iterators. But, after diving deeper, they actually
> make sense, and new memblock iterators look alright to me. The only
> iterator, that I would like to see improved is
> for_each_deferred_pfn_valid_range(), because it is very hard to
> understand it.
> 
> This series is an impressive performance improvement, and I have
> confirmed it on both arm, and x86. It is also should be compatible with
> ktasks.

I see the performance argument. I also do see the maintenance burden
argument. Recent bootmem removal has shown how big and hard to follow
the whole API is. And this should be considered. I am not saying the
current series is a nogo though. Maybe changelogs should be more clear
to spell out advantages to do a per-pageblock initialization that brings
a lot of new code in. As I've said I have basically glanced through
the comulative diff and changelogs to get an impression so it is not
entirely clear to me.  Especially when the per block init does per pfn
within the block init anyway.

That being said, I belive changelogs should be much more specific and
I hope to see this to be a much more modest in the added code. If that
is not possible, then fair enough, but I would like to see it tried.
And please let's not build on top of cargocult and rather get rid of
pointless stuff (e.g. PageReserved) rather than go around it.
-- 
Michal Hocko
SUSE Labs
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
