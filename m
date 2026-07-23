Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC67D4DB557;
	Thu, 23 Jul 2026 13:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784813839; cv=none; b=n/7zlLZTHjy/ghz3QIZZH+Ipf93Oh7DLARZwSsPrvm6wK1y2A0B3zECmyTKeXVv20N4DGBO3/I0dCoVIECaJ7FfPHj7mIGgA/DjNVb8joS0vv2NzOuqSHkTPlcN0WIt5eHwq0Yy0fqohTB1F+1SyDM3rfs17FDaQJ4cqC8rs7e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784813839; c=relaxed/simple;
	bh=eO9vT5YPysqOukd+jY+035D0z/zLeO1w4vN1NwNe2Qc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LYuwM562Fx4Cd0dk8jozvP6yRGrmEDu1z8Gpq3bIjg4+FkA+n4htgAwdYENx/B+vI4QJMPm/0QPDQFmjHyXvNJK0lFs4DN2l8gCAP7Nw9iEz+QfB6u86Xvkxv8Zio/0ifppV1+hpi3kVS371/yDWQ92G6ANI9249AJJ334ORHEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eXwPqfU5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eXwPqfU5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A16401F000E9;
	Thu, 23 Jul 2026 13:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784813825;
	bh=tqvVeERBLT6ROkppBN4MEGfSa50o0lpYhxpdXTdGfSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eXwPqfU5+dyGmmARtvY9crMVwvGOsCAZ2Ru0lYpoOfgXEOQb2mMyZcg1q6u92yB0Z
	 eZMN9cLTZ+yubZjVJ3wy4M7XG7fZikCsbl6f1040nSPNfNyH4meZZBsET+2pf6T6qH
	 qq5izJpow7RoIotkR8UYgW6x+l2czIIn3yNVRVjPMN17oPO831Axfy1Rymb/HnXcNb
	 XY24eVkU+jFNiKTi8CRFsGG3DyaUFKembWWsN5r8eTzYpjL4efTFMbO0xnASQRTvpI
	 YnaQfcVtFoK4C7nDN/JU0FZvuMbAzBAbv7MBIkBFZsTw/0q7oFhQitlB8lVT412AvD
	 YKt/asR4pMeRw==
From: SJ Park <sj@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: SJ Park <sj@kernel.org>,
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
Date: Thu, 23 Jul 2026 06:36:53 -0700
Message-ID: <20260723133654.86752-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <amGHuputMNCFZ9CV@gourry-fedora-PF4VCD3F>
References: 
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 22 Jul 2026 23:25:15 -0400 Gregory Price <gourry@gourry.net> wrote:

> On Wed, Jul 22, 2026 at 05:19:42PM -0700, SJ Park wrote:
> > On Wed, 22 Jul 2026 08:16:56 -0400 Gregory Price <gourry@gourry.net> wrote:
> > 
> > > > "by default".  Does that mean it could be reclaimable in some situations?  If
> > > > so, could we check if it is reclaimable?
> > > > 
> > > 
> > > See the damon changes in:
> > > 
> > > https://lore.kernel.org/linux-mm/al-pkvmgIxGu3LzM@gourry-fedora-PF4VCD3F/T/#mfb99303c85dd9d4c3f58832dc28fc55583a7217a
> > 
> > Summarizing what you want to say, quoting something from the patch, or at least
> > calling it "26th patch of this series" would have made reviewing much easier.
> > Cc-ing damon@ for only patches that toucing DAMON source files and the cover
> > letter of the series could also be helpful.  Please consider doing some of
> > these for future replies.
> > 
> 
> I have been very much discouraged from this kind of trimming because it
> removes the context of the series from the individual patches - making it
> even more confusing.

That's fair and making sense.

> 
> But I understand, I will try to remember to do this for you.

Thank you, Gregory.  Nonetheless, I wouldn't insist selective Cc-ing.  I agree
your point, and I expect doing that would be tedious if you don't have a script
or tool (I use a tool).  It is just one of my suggestion to help reviewing in
this context, insted of only lore link.  Just one among the other three
suggestions (summarizing your thought, quoting, or simply calling it "26th
patch of this series") should also suffice.

> 
> > So, I understand later patches will make it optionally reclaimable and update
> > this restriction by the 26th patch?  That sounds fair.  But, could we drop "by
> > default" from the above comment for reducing the confusion?
> 
> Yes, but you bring up a good point - I think this two-step process is
> actually poor form and that I need to redo it.
> 
> Maybe this can be redone as node states (features?) such as:
> 
>    N_MEMORY_RECLAIMABLE
>    N_MEMORY_DEMOTABLE
>    N_MEMORY_TIERABLE
> 
> so these damon changes will forego this confusing intermediate step of:
> 
>    if (folio_is_private_node(folio))
> 
> and go straight to
> 
>    if (node_is_reclaimable(folio_nid(folio)))
> 
> In the first patch - without ever having to revisit damon again.

Indeed that sounds better than my suggestion.

> 
> > > 
> > > Technically there is nothing in migration core to prevent migration
> > > operations, it's done on a service basis - hotunplug, reclaim/demotion,
> > > user numa (mbind, migrate/move_pages) etc.
> > > 
> > > Operations on private nodes/private node folioes are refused if the
> > > capability bit is not set.
> > 
> > I haven't had a chance to read the entire series, sorry about that.  So, do you
> > mean the above blocking is not really needed, or that will conditionally be
> > allowed by another later patch?
> > 
> 
> I will reduce this all to a single patch in v6, I see where things can
> be improved now based on a few pieces of feedback.

Sounds good, thank you Gregory.  Looking forward to the next version!


Thanks,
SJ

[...]
