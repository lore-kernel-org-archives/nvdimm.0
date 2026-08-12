Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C45E37EFE4
	for <nvdimm@lists.linux.dev>; Wed, 12 Aug 2026 14:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786546207; cv=none; b=sv2BLYDIc6AJ2sKcctiwQ1QfKCAoF/Xtlt0TxB6nECqBaQNJF9C4xUUO/FZn98cjQFlVsPosKWIT4HtM2B38Sd76yDjQ0lWoDjS11a9W14azhMN9ygqXSgd8yzl6BjUJNcZk00CYrW/MjV49nv/m2NAiNFWnoKWdC4E532WQ1dE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786546207; c=relaxed/simple;
	bh=GJNzfFCXyA7QbUzI2qk0+6EWy2+CpitP1Nwr5kSDWqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hfuNOmCzky7l88ZWKH4+5Vjh5EDrE4bVBvqxEBNrAXrZTB6TharQ4AaigsWoZjpeLemAKi+bPxaBWGjGmYRBsuqHqSGW3mrtAZqgVEI7kPSo3NQPHVPGdrh2uUwGGntqAAJO1ZJiTPpBI5BIJOF4pdfZRQPRT+qjETAPS5N095A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W8+sLN0U; arc=none smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W8+sLN0U"
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7e9ecb1e13cso1248972a34.3
        for <nvdimm@lists.linux.dev>; Wed, 12 Aug 2026 07:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786546198; x=1787150998; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=m2bfz1xPNnYsmTuBu6PuVX8SO2+iE1L2/l9R4aB2xA4=;
        b=W8+sLN0U8N2HXuXyBSanNjGRMzpSBvwkmJ446xdTKwVh2QPHPEMPN2zQcsuTvx1MUA
         ILPxnNffrHiEvDVv9q02XL7cOQ2QuWG935yUoQYihMa/gB2mEIhpW34CqTy8isXfxMya
         eCXZ/R52QOPTK7mnuhJF74PmztORV5fScwL/QHojb3ualgs3XkcSUv8lPRozEy2V5dSp
         +xRjaz9ceeh/38jpozKiahrbn5/SVwASN+zOjmBHo2F+7SiFhjO1ChYsXJo0ASIZdokK
         +gYepHSulyT95Vu7xrXx9z0k949Ym+HFd0Bakv9nCLmkN7mjlmDcNW9KlXNHHZ+nGgfC
         mAzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786546198; x=1787150998;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=m2bfz1xPNnYsmTuBu6PuVX8SO2+iE1L2/l9R4aB2xA4=;
        b=YpzKmCLw3oYXh9BRK7XV/EZBrheGDGM/spumeXyNa5bJSzHEN+fHn8igIiCFQo5yfO
         XH+nDkJfV13Tk9LugO9W/ccX2ZTN3O8jELZlWQ7si0ATZavHnyjG7skz76mhktduuqTE
         rEK3g3als4IpKqfNgPY19KyN6KPVkPk0Zioue5jX0jAMWgDhONa1zrWyiySABiV6bfZZ
         8s4aW7PuXZ4ajMDTOA6Id8z3qxarC16ajMZJ57UePjkCA7fMxrp3O1sIzguVGeP94dX0
         wnNd58ZwEYCSnvWoQuVlwEI2+6mTJCJ5mFr5GGSfUsxFfTRr0nHOFGckim1/b6/1TzaV
         vNvQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq4QpZd2y32M5RLSt1aU50aCNXh9A4jZV4Dc4xtgJX3xrUJi6G+ZHDXLO+I6Xgm5jPxE3ECz5U=@lists.linux.dev
X-Gm-Message-State: AOJu0YxoE4SOS2OYAXnAa7g7N7X7z9DvYPwlVY9Iz5btgNnrNUHYsZKh
	d5Eu5kK7Dnb9E5pvlKeT8cPxSTRv9XGft+KMaWYQR8ZtNDChggwIze/o
X-Gm-Gg: AR+sD11YZURAJzoQwvXbElTgCSRWtRINw24bUqxrq2vF5QhSW+ly/rHtIHB1svSX4u9
	t74lj0XyGk7fLe/nGH//vaQS4H/GFh7mxH5SqOTwUWUIg7Actl8LUZSejRq949kHz4+MqZF4qbI
	wK/FwLJfDthRoOqjXFQgvvUIprMAes4EWeoyFR1c2PusJRFPavGGtdX61TR2jlT9g9Xebhf2w5/
	Cl0NOI26weDYcfi+ooKZur6oz7KnLwFps2qUcWHvwko4anAMQR2rhh+70TmMEV/J3GgQNWDXJDC
	psvbEIFptjJPdfM/eKwp13X5xAfrpjtYQXdSoLFLf+tDkcBBFLN90Vy4iK1PVzCjDBqxKlD8WvU
	pUGPSFofbqVHHDlIczKB6qAQj6nsgLaHXGazwrD6dUrxuqVtcAkl1heDnVqL8A90J4U0dCNGwcm
	HSFlyGe2w81AEAETKpPIUKHBF7fDvg23ygMKumokfCiL8t6C28xoa4v3a6xTEWftyWJr3Uf/KUn
	xAX1HoBMMQMU77hXvY=
X-Received: by 2002:a05:6830:2116:b0:7dc:c7aa:22bd with SMTP id 46e09a7af769-7f3b7731b94mr5693831a34.6.1786546197721;
        Wed, 12 Aug 2026 07:49:57 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:49::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f3b34266f3sm3096544a34.24.2026.08.12.07.49.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 07:49:57 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Rakie Kim <rakie.kim@sk.com>
Cc: akpm@linux-foundation.org,
	gourry@gourry.net,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	byungchul@sk.com,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	dave@stgolabs.net,
	jic23@kernel.org,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	harry@kernel.org,
	kernel_team@skhynix.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com
Subject: Re: [PATCH 0/4] mm/mempolicy: introduce package-aware weighted interleave
Date: Wed, 12 Aug 2026 07:49:55 -0700
Message-ID: <20260812144955.3310684-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260812054700.1803-1-rakie.kim@sk.com>
References: 
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Hello Joshua,
> 
> I am doing well, thank you, and I hope you are too. Thank you for
> taking the time to review this series and for following up on the
> questions from the RFC discussion.
> 
> > My first question is whether we want cross-socket allocations at all.
> > The examples you gave seem to line up with node-restricted interleave,
> > as opposed to cross-socket interleave. I think the wording that you
> > use to describe the feature in 4/4 (which I will copy below)
> > 
> > > The resolved mask is by construction a subset of the policy nodemask, which
> > > mempolicy already restricts to the task's cpuset; package mode can only
> > > narrow that set, never widen it, so cpusets and the task nodemask remain
> > > authoritative.
> > 
> > is 100% the right way to treat these package-aware (socket-aware)
> > interleaving allocations, but the example below
> > 
> > [...snip...]
> > 
> > > Applied the same way to every source, these weights give the map:
> > > 
> > >               node0  node1  node2  node3
> > > global:         2      2      1      1
> > 
> > [...snip...]
> > 
> > >               node0  node1  node2  node3
> > > from CPU 0:     2      0      1      0
> > > from CPU 1:     0      2      0      1
> > 
> > Is essentially the existing weighted interleave mechanism with a
> > nodemask/cpuset applied.
> 
> The example I gave was not explained well enough, and I can see how
> it reads as a manually applied nodemask.
> 
> A nodemask or a cpuset names a fixed set of nodes, while package mode
> expresses a rule: use the nodes of the package the allocation is
> requested from. The mask is resolved per allocation from the
> requesting CPU, so a single policy gives {0,2} to a thread on package
> 0 and {1,3} to a thread on package 1 at the same time. One nodemask
> cannot do that, since it is the same set for everyone who uses the
> policy.

Ah! I'm sorry. It seems I totally misunderstood the intent of the
series. I think that my brain short-circuted to the discussion at
LSFMMBPF from 2025, where I think we discussed having a real 2-D
grid with weights per-node, per-CPU. I think my confusion is responsible
for the examples below, which as I understand it now, are not the intent
of the series.

> There is also the question of how a user would build such a nodemask.
> The package a CXL node belongs to is not visible today: on the
> systems I tested, the firmware reports node1 as the initiator for
> both CXL nodes. The topology layer in this series is what makes that
> association available, and the read-only view under
> /sys/devices/system/package/ lets the user check it.

That makes sense. Now I really see the goal of the series and it makes
a lot more sense. Thank you for the clarification. 

> > With that said, I think a more interesting and
> > illustrative example would be if the user truly would want to allow some
> > allocations to go through cross-socket, but be able to control the
> > ratio at which these slip through.
> >
> >               node0  node1  node2  node3
> > from CPU 0:     3      1      2      0
> > from CPU 1:     0      3      1      2
> >
> > Maybe even more illustrative of the true capabilities of this series
> > would be if you have an asymmetric system where you bind some
> > host-level monitoring / logging workloads to one node (say, node0) and
> > want that to be able to cross through to the other socket, but not the
> > other way around:
> > 
> >               node0  node1  node2  node3
> > from CPU 0:     3      1      2      0
> > from CPU 1:     0      2      0      1
> > 
> > Anyways, these are just super hypothetical scenarios and I don't even
> > know if the configuration that I'm listing would really be beneficial
> > for the system. I think that coming up with some illustrative usecases
> > which are now made possible by this series could help motivate why we
> > would want to interleave across sockets.
> >
> 
> These maps are an interesting idea, and I would like to look at them
> with you.
> 
> This series only narrows the candidate nodes; the weights themselves
> stay global, so every source that reaches a node uses the same weight
> for it. Both of your maps give a node a different weight depending on
> which package the allocation comes from, so the weight table would
> have to become per source rather than a single global one.
> 
> Encoding the weights that way came up in an earlier stage of this
> work, and it was mentioned again briefly in the RFC thread. As I
> recall, the difficulty then was less the placement logic than how a
> user would drive it: weights would have to be configured for every
> source, so both the interface and the structure behind it grow
> considerably.

Yeah, I can imagine it is quite a lot of tuning that users have to do.
So I'm 100% on board for the goal of this series to make the existing
weighted interleave mechanism respect the initiator's POV. Sorry for
making you explain all of this, this confusion is just due to my
misunderstanding.

> That does not make your suggestion less interesting to me. I think it
> could work well once there are clear scenarios for it, and the
> grouping added here is what such a table would be built on, since a
> per source weight only has meaning when the kernel knows which
> package each node belongs to. What I am unsure about is folding it
> into this series, whose aim is the narrower one of raising effective
> bandwidth by keeping interleave traffic within a package. Allowing a
> controlled amount of cross-package traffic points the other way, so I
> think it is a topic we could discuss separately, with the use cases
> worked out first.

Thanks! Actually I think we can wait on this until we have real
usecases where we prefer to make cross-socket allocations.

> > I was also hoping to see what this interface looks like and maybe
> > discuss how we should relay the information to the users, since this
> > seems to be a new addition from the RFC.
> >
> 
> Sure. The toggle lives with the existing weighted interleave knobs.
> package_mode defaults to false, so nothing changes until the
> operator explicitly enables it:
> 
> /sys/kernel/mm/mempolicy/weighted_interleave
> |-- auto
> |-- node0
> |-- node1
> |-- node2
> |-- node3
> `-- package_mode -> true/false
> 
> The package topology view is read-only and lives under
> /sys/devices/system/package/. This is how it looks on the system I
> am currently using:
> 
> /sys/devices/system/package
> |-- package0
> |   |-- package_cpu_nodes -> 0
> |   |-- package_mem_only_nodes -> 2
> |   |-- package_nodes -> 0,2
> |   `-- physical_package_id -> 0
> `-- package1
>     |-- package_cpu_nodes -> 1
>     |-- package_mem_only_nodes -> 3
>     |-- package_nodes -> 1,3
>     `-- physical_package_id -> 1
> 
> package_nodes shows every node grouped into that package, and the
> cpu/mem_only files split them by type, so an operator can check how
> the kernel grouped the topology before turning package_mode on. I
> will update the documentation in the next version to describe this
> interface and how to use it.

Great, I think this would be a great addition to add to the cover
letter and also add as documentation, since it is user-facing. 

> > > Measured results:
> > > 
> > > System Configuration:
> > > - Processor: Dual-Socket Intel Xeon 6980P (Granite Rapids)
> > 
> > I think a description of this system's topology would help me understand
> > the results below a bit better : -)
> >
> 
> That is a fair point. The system used for the measurements is
> configured as follows:
> 
> - Processor:                 Dual-Socket Intel Xeon 6980P
>                              (Granite Rapids)
> - Local memory (per socket): 12 channels, DDR5-6400
> - CXL memory (per socket):   8 channels, DDR5-6400
> 
> It boots as two CPU+DRAM nodes and two CXL memory-only nodes, which
> is the topology shown in the sysfs output above. I will add this
> description to the measured results in the next version.

Thanks. Notably I wanted to see if the DDR generation was the same
across DRAM and CXL. 

> The case I had in mind is demotion and promotion target selection.
> With the package information, tiering could keep those decisions
> within a package: choosing the memory-only nodes of the task's
> package as demotion targets, and symmetrically preferring the
> package's CPU nodes when promoting, so that both hot and cold pages
> stay close to the CPUs that use them.

Yeah, I like this idea a lot.

For demotion, we would just chnage the fallback zonelist based on the
sockets.

I think we actually get promotions for free, since if this series is
doing a good job of allocating memory close to the consuming CPU, and
the demotions prevent the memory from moving cross-socket, initiators
should only promote (NUMAB2 promotion) memory that is socket-local.

> To support this, the layer already exposes per-node "preferred" node
> queries: for a CPU node it reports the nearest memory-only nodes in
> the same package, and for a memory-only node the nearest CPU nodes.
> Nothing consumes them yet; I kept them out of the placement path so
> that tiering can adopt them separately when there is a real user.
> 
> > I definitely think this series makes a lot of sense and I am
> > hoping to hear more about it. Thank you, I hope you have a great day!
> >
> > Joshua
> 
> Thank you again for the careful review and for the questions; they
> were a great help in seeing what the cover letter needs to explain
> better. I hope you have a great day too.

Thank you Rakie. I don't think the cover letter was misleading,
it was just my fault for short-circuiting and thinking the series was
about adding per-socket per-node weights, as opposed to the
restriction that you're adding to the existing weights.

If I may add one more comment, I think 2/4 is a bit hard to review.
A 1k line patch is not so easy to see the full picture, I think it would
make it less intimidating to review if it could be split up into
smaller patches. Just my 2c : -)

Thanks again. I hope you have a great day!
Joshua
