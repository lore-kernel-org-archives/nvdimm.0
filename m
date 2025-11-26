Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F83F2D29C7
	for <nvdimm@lists.linux.dev>; Wed, 26 Nov 2025 08:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764145762; cv=none; b=a3OeKXMTLURussvW8H5UHS3mTjxf5aDSkaHPpctzcYHduFwmxULmkx4QrWUoG4U9PLNDl18Dse6Sh+JVYEWAOpEkBiea+ZKmQ05zcxRsGWCrAPcUkZD26hvfad+7EciEzVyrKwtPbuTREBTejKIHZYWU0nrT0R64MSWmMQUHkSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764145762; c=relaxed/simple;
	bh=KmE6Igx4ArlklYpCUhW2nfSXXQpiVHQ/XePwfChAx2I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pQc7OfA2PbaKp5saB5s7g6r4I/eWk4TLQ+zLcOC1xkw/2UOw59GPXqIZxQfeqStdfBqvUEIgBVGT+dNsdPNDvI7maE0Nk0R4XJ1anith6rHZJPXS9kiyw0drw+DF7OA8PyL6zXeSqmqH6DJzTWs20ePHD0Sk7HliM0gD/OEE/U4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=E41Y524J; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="E41Y524J"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4ee13dc0c52so52216391cf.2
        for <nvdimm@lists.linux.dev>; Wed, 26 Nov 2025 00:29:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1764145759; x=1764750559; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LpTPqSNb5/1LIA5hUrs72gqy0nx3RKk/281zC2fbaaY=;
        b=E41Y524Jc6uTh4Lr3f9OOpsrviE9fje7mwSBTbpCKMNY0izLd4lE+GYToLdj8JpUN0
         UNqjdHYtwfGv2XRoU+1b/rpuhAFii+yIjfdTIlxUV9foXYWW/4zKSMIsQYl+i/ccfMTs
         rgCNWJoM/obJhiLdrBQYEosIzQ5nr3OdN3QBfQ0ikSh9So0bUVgx/EOBbVw9SkPGjYt9
         xQHE4Te9qEwSj2FLfPxqd9nYDqHYlh0m8vgJB7jUw/0kQyHRilokcF6C4lEgIYlIIFS8
         KScQfxBu80mMWtrHN4Xkan6FZVc/YdgYVC9nL3/ygP4D5LvbQumteBDl8jCeXJ+b75Pv
         ya6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764145759; x=1764750559;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LpTPqSNb5/1LIA5hUrs72gqy0nx3RKk/281zC2fbaaY=;
        b=nlGZeZRqEA3u5mJquhH2/2xlfaVi6+5nnmnFZzqRwuYgPH/z0ZN6+SRD7kQcM+Q/Om
         ab9QGqKNab1Hb+/mGQsU5vPs+Z+cPyywpNpQm5TU+tkzgDaQHZRmCJjzW1ozzjfUN3eg
         UJYFV7rRMW86JqeHdtrQUmb0srUg3EhAVwfTJUpM1lJ8NtbzhOV0vSd9XBMxmFj+zSPi
         jc7/yNAAld/y79Bi1sNUeKpYaEunwDjI8Ll5+5RhfTsc3+Hur9uMliGAHDnq4W1UKfFh
         8phG+1W0c5tZa6GmEb+D7mlGoCjIGaZ7JBEo8FyKz5/Sz0lcwhn/dQ1thmM//p8/k7or
         S+iw==
X-Forwarded-Encrypted: i=1; AJvYcCUyPnjT4/bG3mYUlxUUg++fO3O+k+X7gExL+ZHKLBeEbvGG9nKcIQkYwVSOwKMZspcfTlO5lgQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxEEjpWKZR2A6beHqtQbugZGjITAvmOjwRZ+pl3QIENfyAUd7/L
	Yq2npIWDUouvdhrs9ngTIfzAA2pFq1P/WuK5l/L+/Fwb9qfEOpo0ekhxJ8lvbrd0gK0=
X-Gm-Gg: ASbGncvwABFlnPoh3NN3XB7XIbXlnUusSMhBrOxdeGEB97omzB+XCaHHzt2OU90DUGC
	FL6AwrGCstxbUM5adrj3CFZwYPu0WlnMU/9j66Z/O8tf978Xsa++wklXEC6iB4jkydtcZWS8T6y
	FEITISsXR5fw2tDdbg53M5M2NuuDy1uz9uAlrxNOYiFhG83kcM071mYCVe4qTvaGEHB9ASA/2VQ
	dkfRWPMoYp57Dt4JkgG8eUtvdFr36MFOBqSeA8roeCoM0g4ha8G3hoOS2FtIa0NCYN3Iah6ZGxL
	FeequMIomtjI0Lio0WDBCEvW76gmy55m74asf/AJK817Kn3/l/Q8+P8E8vLyS60lCSuKg6TQk0T
	tU5EM7/OPC7ljVI6EjssHM2n2tieHof5PXh6B0AWiZxC5az5CjmAN7xaHQ9WtzMIDOsAZXd25AO
	aEnG2hTs/QE6Xnud2SJtFrhyBQssQQlIaQjUZvk/gkSHNFzOfXJQjh0gdgFv0/OI/J7HW/gA==
X-Google-Smtp-Source: AGHT+IHuUv0EzqPvaVNL3leGpr9lqb8F9vUc6VmdQSLEZ6njqgrsaluCQ4pnfGmE+DrmYi9rZ0TzBg==
X-Received: by 2002:ac8:7c4c:0:b0:4ed:e40c:872d with SMTP id d75a77b69052e-4ee58b12a27mr235496851cf.59.1764145758923;
        Wed, 26 Nov 2025 00:29:18 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ee4cbc3c81sm113574331cf.16.2025.11.26.00.29.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Nov 2025 00:29:17 -0800 (PST)
Date: Wed, 26 Nov 2025 03:29:14 -0500
From: Gregory Price <gourry@gourry.net>
To: Balbir Singh <balbirs@nvidia.com>
Cc: linux-mm@kvack.org, kernel-team@meta.com, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org,
	dave@stgolabs.net, jonathan.cameron@huawei.com,
	dave.jiang@intel.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, longman@redhat.com,
	akpm@linux-foundation.org, david@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	osalvador@suse.de, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	ying.huang@linux.alibaba.com, apopple@nvidia.com, mingo@redhat.com,
	peterz@infradead.org, juri.lelli@redhat.com,
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
	rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
	vschneid@redhat.com, tj@kernel.org, hannes@cmpxchg.org,
	mkoutny@suse.com, kees@kernel.org, muchun.song@linux.dev,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	rientjes@google.com, jackmanb@google.com, cl@gentwo.org,
	harry.yoo@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
	weixugc@google.com, zhengqi.arch@bytedance.com,
	yosry.ahmed@linux.dev, nphamcs@gmail.com, chengming.zhou@linux.dev,
	fabio.m.de.francesco@linux.intel.com, rrichter@amd.com,
	ming.li@zohomail.com, usamaarif642@gmail.com, brauner@kernel.org,
	oleg@redhat.com, namcao@linutronix.de, escape@linux.alibaba.com,
	dongjoo.seo1@samsung.com
Subject: Re: [RFC LPC2026 PATCH v2 00/11] Specific Purpose Memory NUMA Nodes
Message-ID: <aSa6Wik2lZiULBsg@gourry-fedora-PF4VCD3F>
References: <20251112192936.2574429-1-gourry@gourry.net>
 <48078454-f441-4699-9c50-db93783f00fd@nvidia.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48078454-f441-4699-9c50-db93783f00fd@nvidia.com>

On Wed, Nov 26, 2025 at 02:23:23PM +1100, Balbir Singh wrote:
> On 11/13/25 06:29, Gregory Price wrote:
> > This is a code RFC for discussion related to
> > 
> > "Mempolicy is dead, long live memory policy!"
> > https://lpc.events/event/19/contributions/2143/
> > 
> 
> :)
> 
> I am trying to read through your series, but in the past I tried
> https://lwn.net/Articles/720380/
> 

This is very interesting, I gave the whole RFC a read and it seems you
were working from the same conclusion ~8 years ago - that NUMA just
plainly "Feels like the correct abstraction".

First, thank you, the read-through here filled in some holes regarding
HMM-CDM for me.  If you have developed any other recent opinions on the
use of HMM-CDM vs NUMA-CDM, your experience is most welcome.


Some observations:

1) You implemented what amounts to N_SPM_NODES 

   - I find it funny we separately came to the same conclusion. I had
     not seen your series while researching this, that should be an
     instructive history lesson for readers.

   - N_SPM_NODES probably dictates some kind of input from ACPI table
     extension, drivers input (like my MHP flag), or kernel configs
     (build/init) to make sense.

   - I discussed in my note to David that this is probably the right
     way to go about doing it. I think N_MEMORY can still be set, if
     a new global-default-node policy is created.

   - cpuset/global sysram_nodes masks in this set are that policy.


2) You bring up the concept of NUMA node attributes

   - I have privately discussed this concept with MM folks, but had
     not come around to formalize this.  It seems a natural extension.

   - I wasn't sure whether such a thing would end up in memory-tiers.c
     or somehow abstracted otherwise.  We definitely do not want node
     attributes to imply infinite N_XXXXX masks.


3) You attacked the problem from the zone iteration mechanism as the
   primary allocation filter - while I used cpusets and basically
   implemented a new in-kernel policy (sysram_nodes)

   - I chose not to take that route (omitting these nodes from N_MEMORY)
     precisely because it would require making changes all over the
     kernel for components that may want to use the memory which
     leverage N_MEMORY for zone iteration.

   - Instead, I can see either per-component policies (reclaim->nodes)
     or a global policy that covers all of those components (similar to
     my sysram_nodes).  Drivers would then be responsible to register
     their hotplugged memory nodes with those components accordingly.

   - My mechanism requires a GFP flag to punch a hole in the isolation,
     while yours depends on the fact that page_alloc uses N_MEMORY if
     nodemask is not provided.  I can see an argument for going that
     route instead of the sysram_nodes policy, but I also understand
     why removing them from N_MEMORY causes issues (how do you opt these
     nodes into core services like kswapd and such).

     Interesting discussions to be had.


4)   Many commenters tried pushing mempolicy as the place to do this.
     We both independently came to the conclusion that 

   - mempolicy is at best an insufficient mechanism for isolation due
     to the way the rest of the system is designed (cpusets, zones)

   - at worst, actually harmful because it leads kernel developers to
     believe users view mempolicy APIs as reasonable. They don't.
     In my experience it's viewed as:
         - too complicated (SW doesn't want to know about HW)
         - useless (it's not even respected by reclaim)
         - actively harmful (it makes your code less portable)
	 - "The only thing we have"

Your RFC has the same concerns expressed that I have seen over past
few years in Device-Memory development groups... except that the general
consensus was (in 2017) that these devices were not commodity hardware
the kernel needs a general abstraction (NUMA) to support.

"Push the complexity to userland" (mempolicy), and
"Make the driver manage it." (hmm/zone_device)

Have been the prevailing opinions as a result.

From where I sit, this depends on the assumption that anyone using such
systems is presumed to be sophisticated and empowered enough to accept
that complexity.  This is just quite bluntly no longer the case.

GPUs, unified memory, and coherent interconnects have all become
commodity hardware in the data center, and the "users" here are
infrastructure-as-a-service folks that want these systems to be
some definition of fungible.

~Gregory
