Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1DBF3537C8
	for <nvdimm@lists.linux.dev>; Thu, 13 Aug 2026 03:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=166.125.252.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786592292; cv=none; b=uQdCR9KVZKBcqbTZbbpH3z0G/4RfeiWbd+2yHMHz1UPYpMD4WSJSzd2RreGaPmO37s7T8XyjE0BWBDh3kZ0jBO8ySeU+hPIsij/l0Gl0OMz04WWdIRupHidm1RmBvFaar3cSsbf5ROCiwEG+latbMfpXAKawOl7h1qWtXu9GnUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786592292; c=relaxed/simple;
	bh=lHJFHU4OgkTwU9yXKLhFcUfquqYWmn0M4jdfiM9/qVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vAIpMIW2JFp+zcfAlizm8Vu9gmdUKz/+EnQisHVlWlavC9ip3f3e+GVvy0i6kfJkRemeRGyjZNW9eZPl57mVv1wMyjGKEsaWdikgZkDNRgyM2ytCr0wVBMQMee0bTNKg5N8DetOQ7qqpznSk6BQHXncSSBjhu9nWj9IVd4Q1oPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sk.com; spf=pass smtp.mailfrom=sk.com; arc=none smtp.client-ip=166.125.252.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sk.com
X-AuditID: a67dfc5b-c45ff70000001609-63-6a7d3c1c4cf9
From: Rakie Kim <rakie.kim@sk.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
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
	yunjeong.mun@sk.com,
	Rakie Kim <rakie.kim@sk.com>
Subject: Re: [PATCH 0/4] mm/mempolicy: introduce package-aware weighted interleave
Date: Thu, 13 Aug 2026 12:37:59 +0900
Message-ID: <20260813033802.1838-1-rakie.kim@sk.com>
X-Mailer: git-send-email 2.52.0.windows.1
In-Reply-To: <20260812144955.3310684-1-joshua.hahnjy@gmail.com>
References: 
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsXC9ZZnka6sTW2WwYm7jBZz1q9hs7j7+AKb
	xa4bIRYnbjayWay+uYbR4vnWX4wWP+8eZ7e4fmslo8X+p89ZLB40rWKyOL51HrvFulOH2CzO
	zzrFYnF51xw2i3tr/rNavHnsZvGtT9rifp+Dxcoff1gtjqzfzmQx+dICNouOl/dZLG5NOMZk
	sXpNhsXso/fYHSQ9ds66y+6xYFOpR3fbZXaPzSu0PBbvecnksWlVJ5vHpk+T2D1OzPjN4rHz
	oaXHi80zGT16m9+xeUydXe+xfstVFo/Pm+QC+KK4bFJSczLLUov07RK4Mp5fXcZW0JZYsWvf
	JsYGxlmeXYycHBICJhK/F59hgrFvr3vO2MXIwcEmoCRxbG8MSFhEQFPiROsk5i5GLg5mgQ2s
	EqdOv2UGSQgLBEl0TYeoZxFQldh3WRUkzAs0ZtaKZmaIkZoS6zbeYgGxOQXsJS53vGcHsYUE
	eCRebdjPCFEvKHFy5hOwGmYBeYnmrbPBdkkIfGWXeLuriQ1ikKTEwRU3WCYw8s9C0jMLSc8C
	RqZVjEKZeWW5iZk5JnoZlXmZFXrJ+bmbGIGRuqz2T/QOxk8Xgg8xCnAwKvHwZjTXZAmxJpYV
	V+YeYpTgYFYS4a1eVZUlxJuSWFmVWpQfX1Sak1p8iFGag0VJnNfoW3mKkEB6YklqdmpqQWoR
	TJaJg1OqgbHvQp/Wx2Iu0Zcpf/ffarDqaQnI+CG2/8FWdW27KSVn95xwq5vqfsKhIvtXtVxg
	yea3p7L2bWpbGeURrby59YhTywzHwsw7k8t+Vv2S33PrytQ1ZrOqvLV0mK5LC06Xcl2hcO3I
	swm153v21l+rEg6Kz+5lXq6+RzQhZd4W/f1iZYYz/HkPqiuxFGckGmoxFxUnAgDugx2j0AIA
	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02RbUhTYQCFeXfv7r0bjm5L8KZhtDDRUrMPeA0pwag3oagohTB06MVN55RN
	ZZqSNTJbJWZGuqkIhsy51KbTFFNY5WeoNSw/WCqam+UqcommYC4J/Hc4z8P5cyhM2Il7U1J5
	BquQi2Uigo/zy/xjg/aE5yUf1i8FwopGIwFtsyME7Bi7AodKdQTsG79FwPpxI4B28x8AV229
	JPw0UQfg0vw3DHZ/seNw+raBA3vNVSR8XdnPhQ0DFgIOawdwaO2oIOBn4wYXLs6egctFPnCq
	KALWraxzoeWjnQvfNLZx4OMP1QQsXJjC4URxDwfWGyVwrVVPQN3bz2SEL2rX2khUbcpE9wus
	JGrWB6KazgUOMhnuEcj0q4REfWVrOGqfCUOO5nKAHqq/E2h5EqEax08OeqK7iRpbRnG0ZPK9
	SF/jhyeyMmkWqwg5Gc+X2EdrifQCsaqjywTygfacBvAohj7GTDbYgQZQFEGLmJ5Xse7akw5g
	+u6UYBrApzC6icsMDDoxN9hFX2Y0T7d8nPZjuqx+7lqwOaPVq7GtyQCm4cUE7s48+hRjLfxB
	urOQ9mC+NnWDLX8n018+98/B6L2M2qzDioGHdhvSbkPVgGMAnlJ5VqpYKjserEyRZMulquCE
	tFQT2Py0Nm/90Uvgsp61AJoCIg+BRJ2bLOSKs5TZqRbAUJjIU3DDkJMsFCSKs3NYRVqcIlPG
	Ki3Ah8JFXoKoGDZeSCeJM9gUlk1nFf8ph+J554OZ1uYFvW9L+47fgSFeczNW/8j60Hh62t/a
	df0d45x0OS2D5KUDFw5xda7T4epcXq7pgQpP2u2zmDHAlkYdXYzhg2cjHoyi8qBNVerl3Lgb
	GTQU7GjDNdHKyAZeaO1Vtd7Zm+KqMr9fOSHf379PNW84Eu3MP++IGwtLWB1+LsKVEnFoIKZQ
	iv8CDdj8V88CAAA=
X-CFilter-Loop: Reflected

On Wed, 12 Aug 2026 07:49:55 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

Hello Joshua,

Thank you for coming back to this so quickly.

> > Hello Joshua,
> > 
> > I am doing well, thank you, and I hope you are too. Thank you for
> > taking the time to review this series and for following up on the
> > questions from the RFC discussion.
> > 
> > > My first question is whether we want cross-socket allocations at all.
> > > The examples you gave seem to line up with node-restricted interleave,
> > > as opposed to cross-socket interleave. I think the wording that you
> > > use to describe the feature in 4/4 (which I will copy below)
> > > 
> > > > The resolved mask is by construction a subset of the policy nodemask, which
> > > > mempolicy already restricts to the task's cpuset; package mode can only
> > > > narrow that set, never widen it, so cpusets and the task nodemask remain
> > > > authoritative.
> > > 
> > > is 100% the right way to treat these package-aware (socket-aware)
> > > interleaving allocations, but the example below
> > > 
> > > [...snip...]
> > > 
> > > > Applied the same way to every source, these weights give the map:
> > > > 
> > > >               node0  node1  node2  node3
> > > > global:         2      2      1      1
> > > 
> > > [...snip...]
> > > 
> > > >               node0  node1  node2  node3
> > > > from CPU 0:     2      0      1      0
> > > > from CPU 1:     0      2      0      1
> > > 
> > > Is essentially the existing weighted interleave mechanism with a
> > > nodemask/cpuset applied.
> > 
> > The example I gave was not explained well enough, and I can see how
> > it reads as a manually applied nodemask.
> > 
> > A nodemask or a cpuset names a fixed set of nodes, while package mode
> > expresses a rule: use the nodes of the package the allocation is
> > requested from. The mask is resolved per allocation from the
> > requesting CPU, so a single policy gives {0,2} to a thread on package
> > 0 and {1,3} to a thread on package 1 at the same time. One nodemask
> > cannot do that, since it is the same set for everyone who uses the
> > policy.
> 
> Ah! I'm sorry. It seems I totally misunderstood the intent of the
> series. I think that my brain short-circuted to the discussion at
> LSFMMBPF from 2025, where I think we discussed having a real 2-D
> grid with weights per-node, per-CPU. I think my confusion is responsible
> for the examples below, which as I understand it now, are not the intent
> of the series.
>

My explanation was not enough and that is what caused the confusion.
The 2-D grid is close enough to this work that the two are easy to
place together, and thanks to your questions I could fill in a good
deal of what the cover letter was missing.


> > There is also the question of how a user would build such a nodemask.
> > The package a CXL node belongs to is not visible today: on the
> > systems I tested, the firmware reports node1 as the initiator for
> > both CXL nodes. The topology layer in this series is what makes that
> > association available, and the read-only view under
> > /sys/devices/system/package/ lets the user check it.
> 
> That makes sense. Now I really see the goal of the series and it makes
> a lot more sense. Thank you for the clarification.
>

Thank you.


> > > With that said, I think a more interesting and
> > > illustrative example would be if the user truly would want to allow some
> > > allocations to go through cross-socket, but be able to control the
> > > ratio at which these slip through.
> > >
> > >               node0  node1  node2  node3
> > > from CPU 0:     3      1      2      0
> > > from CPU 1:     0      3      1      2
> > >
> > > Maybe even more illustrative of the true capabilities of this series
> > > would be if you have an asymmetric system where you bind some
> > > host-level monitoring / logging workloads to one node (say, node0) and
> > > want that to be able to cross through to the other socket, but not the
> > > other way around:
> > > 
> > >               node0  node1  node2  node3
> > > from CPU 0:     3      1      2      0
> > > from CPU 1:     0      2      0      1
> > > 
> > > Anyways, these are just super hypothetical scenarios and I don't even
> > > know if the configuration that I'm listing would really be beneficial
> > > for the system. I think that coming up with some illustrative usecases
> > > which are now made possible by this series could help motivate why we
> > > would want to interleave across sockets.
> > >
> > 
> > These maps are an interesting idea, and I would like to look at them
> > with you.
> > 
> > This series only narrows the candidate nodes; the weights themselves
> > stay global, so every source that reaches a node uses the same weight
> > for it. Both of your maps give a node a different weight depending on
> > which package the allocation comes from, so the weight table would
> > have to become per source rather than a single global one.
> > 
> > Encoding the weights that way came up in an earlier stage of this
> > work, and it was mentioned again briefly in the RFC thread. As I
> > recall, the difficulty then was less the placement logic than how a
> > user would drive it: weights would have to be configured for every
> > source, so both the interface and the structure behind it grow
> > considerably.
> 
> Yeah, I can imagine it is quite a lot of tuning that users have to do.
> So I'm 100% on board for the goal of this series to make the existing
> weighted interleave mechanism respect the initiator's POV. Sorry for
> making you explain all of this, this confusion is just due to my
> misunderstanding.
>

Thank you. "Respect the initiator's point of view" describes the goal
better than what I wrote, so I would like to use that framing in the
next cover letter.


> > That does not make your suggestion less interesting to me. I think it
> > could work well once there are clear scenarios for it, and the
> > grouping added here is what such a table would be built on, since a
> > per source weight only has meaning when the kernel knows which
> > package each node belongs to. What I am unsure about is folding it
> > into this series, whose aim is the narrower one of raising effective
> > bandwidth by keeping interleave traffic within a package. Allowing a
> > controlled amount of cross-package traffic points the other way, so I
> > think it is a topic we could discuss separately, with the use cases
> > worked out first.
> 
> Thanks! Actually I think we can wait on this until we have real
> usecases where we prefer to make cross-socket allocations.
>

Agreed. I will also keep thinking about what such use cases would
look like.


> > > I was also hoping to see what this interface looks like and maybe
> > > discuss how we should relay the information to the users, since this
> > > seems to be a new addition from the RFC.
> > >
> > 
> > Sure. The toggle lives with the existing weighted interleave knobs.
> > package_mode defaults to false, so nothing changes until the
> > operator explicitly enables it:
> > 
> > /sys/kernel/mm/mempolicy/weighted_interleave
> > |-- auto
> > |-- node0
> > |-- node1
> > |-- node2
> > |-- node3
> > `-- package_mode -> true/false
> > 
> > The package topology view is read-only and lives under
> > /sys/devices/system/package/. This is how it looks on the system I
> > am currently using:
> > 
> > /sys/devices/system/package
> > |-- package0
> > |   |-- package_cpu_nodes -> 0
> > |   |-- package_mem_only_nodes -> 2
> > |   |-- package_nodes -> 0,2
> > |   `-- physical_package_id -> 0
> > `-- package1
> >     |-- package_cpu_nodes -> 1
> >     |-- package_mem_only_nodes -> 3
> >     |-- package_nodes -> 1,3
> >     `-- physical_package_id -> 1
> > 
> > package_nodes shows every node grouped into that package, and the
> > cpu/mem_only files split them by type, so an operator can check how
> > the kernel grouped the topology before turning package_mode on. I
> > will update the documentation in the next version to describe this
> > interface and how to use it.
> 
> Great, I think this would be a great addition to add to the cover
> letter and also add as documentation, since it is user-facing.
>

I will put it in both. Andrew also asked for documentation aimed at
the operator, so the next version will describe this interface and
how to use it there as well.


> > > > Measured results:
> > > > 
> > > > System Configuration:
> > > > - Processor: Dual-Socket Intel Xeon 6980P (Granite Rapids)
> > > 
> > > I think a description of this system's topology would help me understand
> > > the results below a bit better : -)
> > >
> > 
> > That is a fair point. The system used for the measurements is
> > configured as follows:
> > 
> > - Processor:                 Dual-Socket Intel Xeon 6980P
> >                              (Granite Rapids)
> > - Local memory (per socket): 12 channels, DDR5-6400
> > - CXL memory (per socket):   8 channels, DDR5-6400
> > 
> > It boots as two CPU+DRAM nodes and two CXL memory-only nodes, which
> > is the topology shown in the sysfs output above. I will add this
> > description to the measured results in the next version.
> 
> Thanks. Notably I wanted to see if the DDR generation was the same
> across DRAM and CXL.
>

Both sides are DDR5-6400, so the difference in the results comes from
the path rather than from the memory itself. I will make that clear
when I describe the system in the next version.


> > The case I had in mind is demotion and promotion target selection.
> > With the package information, tiering could keep those decisions
> > within a package: choosing the memory-only nodes of the task's
> > package as demotion targets, and symmetrically preferring the
> > package's CPU nodes when promoting, so that both hot and cold pages
> > stay close to the CPUs that use them.
> 
> Yeah, I like this idea a lot.
> 
> For demotion, we would just chnage the fallback zonelist based on the
> sockets.
> 
> I think we actually get promotions for free, since if this series is
> doing a good job of allocating memory close to the consuming CPU, and
> the demotions prevent the memory from moving cross-socket, initiators
> should only promote (NUMAB2 promotion) memory that is socket-local.
>

Thank you for the suggestion. Changing the demotion order by package
sounds like the natural first step, and I will look into it once the
placement side has settled.


> > To support this, the layer already exposes per-node "preferred" node
> > queries: for a CPU node it reports the nearest memory-only nodes in
> > the same package, and for a memory-only node the nearest CPU nodes.
> > Nothing consumes them yet; I kept them out of the placement path so
> > that tiering can adopt them separately when there is a real user.
> > 
> > > I definitely think this series makes a lot of sense and I am
> > > hoping to hear more about it. Thank you, I hope you have a great day!
> > >
> > > Joshua
> > 
> > Thank you again for the careful review and for the questions; they
> > were a great help in seeing what the cover letter needs to explain
> > better. I hope you have a great day too.
> 
> Thank you Rakie. I don't think the cover letter was misleading,
> it was just my fault for short-circuiting and thinking the series was
> about adding per-socket per-node weights, as opposed to the
> restriction that you're adding to the existing weights.
>

Thank you for saying so. Either way, your questions gave me a chance
to look again at what the cover letter was not saying clearly.

> If I may add one more comment, I think 2/4 is a bit hard to review.
> A 1k line patch is not so easy to see the full picture, I think it would
> make it less intimidating to review if it could be split up into
> smaller patches. Just my 2c : -)
>

You are right, it is too much to take in at once. The patch became
large and complex because several features ended up in a single
commit. I will separate them as much as I can in the next version.

> Thanks again. I hope you have a great day!
> Joshua

Thank you again for the review and for the discussion. I hope you
have a great day too.

Rakie Kim
