Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1651D555;
	Thu, 23 Jul 2026 00:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784765996; cv=none; b=ieUHiaZVSddwJnQb/0FxLi+ToTXwhgVtVqqDTdGNa1+PzM+4bVS+mXH9FPmStMavj9/9119/soGFWNlBzBSfXqmzrzv3EolYMRC8HaAUV+CfGndvtH7KNnHza8ThRhyPG2fN340BlR5sGqGPM0Nf7FoNzKV8QZ5Tbhjbm8lcLz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784765996; c=relaxed/simple;
	bh=LJrwMBFzEJfWlcNe+u3Em2s3k7Xc8/tdxZKRwTN6sgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MDI8rZSaSoy2a1MI2eL9qWQhAyYxkiULZfZUpW2PtIUP8lsYR075zwHvFdQ5IbEqllXh2domy4T92813E0I8cq6kkBP3mA93I7GkLZBTlMjhYkKAaMAVNPEycFBNhWpO6Dxde9yZ3M8fn/wLHx0G/XwKUUegyumIY1vvjCfJjJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BCF74EeS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BCF74EeS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A0F61F000E9;
	Thu, 23 Jul 2026 00:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784765994;
	bh=etGADT3O07IS+YgXI7BAorrClTolrXpqV0QzB1dZpWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BCF74EeStolbb2W/TP1soDHuWZ51DJgYsnp0HoXIhY2LV8FES9MkZRqdbEzajNcq+
	 FdLD6IqAG7VkemQlxBlzfSPOaZ9GNCpfftJx+0klLFu5BE2mkb7lN3baGG6RJOA/f+
	 OTbXbg6YqfXU+lWGMVnTAd3AXQwctqtKShgO3nYG2UgswjKxrd3j5RbvY6xNG9gaXM
	 fPUG9Bt2NyDXhqYg6+KA0IHV+/ZVkHI4krzjxQIX39zaRdwO1taH2ix1ZIoapD4CwO
	 y+KvoVgLfc1T4Hs6ON+9+dwzzQyWXFuwLTkfAhh3M+nzbYJObaTnWnCcSzHNgOzf46
	 0VqiGCD9JgaHg==
From: SJ Park <sj@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: SJ Park <sj@kernel.org>,
	arun.george@samsung.com,
	balbirs@nvidia.com,
	brendan.jackman@linux.dev,
	yuzenghui@huawei.com,
	apopple@nvidia.com,
	alucerop@amd.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	osandov@osandov.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	pbonzini@redhat.com,
	osalvador@suse.de,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	ying.huang@linux.alibaba.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kvm@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v5 14/36] mm/damon: skip private node memory in DAMON migration and pageout
Date: Wed, 22 Jul 2026 17:19:42 -0700
Message-ID: <20260723001943.95854-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <amCzmkdOr6AFv_kQ@gourry-fedora-PF4VCD3F>
References: 
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 22 Jul 2026 08:16:56 -0400 Gregory Price <gourry@gourry.net> wrote:

> On Tue, Jul 21, 2026 at 04:46:43PM -0700, SJ Park wrote:
> > On Mon, 20 Jul 2026 15:34:08 -0400 Gregory Price <gourry@gourry.net> wrote:
> > 
> > > DAMON operates on physical address ranges, which can cover private
> > > node memory. Skip private-node folios in both DAMON's migration
> > > and reclaim paths.
> > > 
> > > Signed-off-by: Gregory Price <gourry@gourry.net>
> > > ---
> > >  mm/damon/paddr.c | 9 +++++++++
> > >  1 file changed, 9 insertions(+)
> > > 
> > > diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
> > > index e4f98d67461f5..c741a94319750 100644
> > > --- a/mm/damon/paddr.c
> > > +++ b/mm/damon/paddr.c
> > > @@ -12,6 +12,7 @@
> > >  #include <linux/swap.h>
> > >  #include <linux/memory-tiers.h>
> > >  #include <linux/mm_inline.h>
> > > +#include <linux/node_private.h>
> > >  
> > >  #include "../internal.h"
> > >  #include "ops-common.h"
> > > @@ -250,6 +251,10 @@ static unsigned long damon_pa_pageout(struct damon_region *r,
> > >  			continue;
> > >  		}
> > >  
> > > +		/* private node memory is not reclaimable by default */
> > > +		if (folio_is_private_node(folio))
> > > +			goto put_folio;
> > > +
> > 
> > "by default".  Does that mean it could be reclaimable in some situations?  If
> > so, could we check if it is reclaimable?
> > 
> 
> See the damon changes in:
> 
> https://lore.kernel.org/linux-mm/al-pkvmgIxGu3LzM@gourry-fedora-PF4VCD3F/T/#mfb99303c85dd9d4c3f58832dc28fc55583a7217a

Summarizing what you want to say, quoting something from the patch, or at least
calling it "26th patch of this series" would have made reviewing much easier.
Cc-ing damon@ for only patches that toucing DAMON source files and the cover
letter of the series could also be helpful.  Please consider doing some of
these for future replies.

So, I understand later patches will make it optionally reclaimable and update
this restriction by the 26th patch?  That sounds fair.  But, could we drop "by
default" from the above comment for reducing the confusion?

> 
> > Also, what happens if we just try paging out the private node memory?  Will it
> > simply fail?  Or, make some problems?
> > 
> 
> user controls for MADV_ commands that affect private node folios would
> skip those folios - exactly same as ZONE_DEVICE folios.
> 
> Which I'm not sure damon actually handles correctly presently (zone
> device).  I remember looking around damon and thinking to myself "what
> if this is a zone device page?" and not being able to find a satisfying
> answer.
> 
> > >  		if (damos_pa_filter_out(s, folio))
> > >  			goto put_folio;
> > >  		else
> > > @@ -344,6 +349,10 @@ static unsigned long damon_pa_migrate(struct damon_region *r,
> > >  		else
> > >  			*sz_filter_passed += folio_size(folio) / addr_unit;
> > >  
> > > +		/* private nodes do not support migration by default */
> > > +		if (folio_is_private_node(folio))
> > > +			goto put_folio;
> > > +
> > 
> > Same questions.
> > 
> 
> Technically there is nothing in migration core to prevent migration
> operations, it's done on a service basis - hotunplug, reclaim/demotion,
> user numa (mbind, migrate/move_pages) etc.
> 
> Operations on private nodes/private node folioes are refused if the
> capability bit is not set.

I haven't had a chance to read the entire series, sorry about that.  So, do you
mean the above blocking is not really needed, or that will conditionally be
allowed by another later patch?


Thanks,
SJ

[...]
