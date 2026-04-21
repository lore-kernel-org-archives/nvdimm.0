Received: from mailgw2.hygon.cn (unknown [101.204.27.37])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 472DB377566
	for <nvdimm@lists.linux.dev>; Tue, 21 Apr 2026 03:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.204.27.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776740850; cv=none; b=bBMslRj/kNVpfnh2k5A2T0WOvDpTgyQjLpbhbl5lEyJHFIbtGanPebh8MuAaFRvwzYvuexyqFUAujIRcxTRDZ3FVm84ll6+SBz6iAE1/ObIORjlI9yIEOwe+CEJN6pWOTz14CAYYh1gChVFW500v79RlbvpBD3iOIlBDJjnnV2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776740850; c=relaxed/simple;
	bh=vVd/7SelOp7jYayhI2w6h4uvD0LPeSpGH137yQgPMc4=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JpD2H0V+Y+/C5HNTwGLLCCcvLPj1NE2PY5/G9MLx9TBZLxc5LJo7BO7qnL9yrOVlVmhaC+F6WdrbzK0VeTt8uXxYqdSQPnZL+ai4CJ0dmkwVOCLU1v49G1B1C1PJxnnoMHEOx1gjdOrEc+c9HNY+jl0SlRmYS70ZLuv5U3pJTFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hygon.cn; spf=pass smtp.mailfrom=hygon.cn; arc=none smtp.client-ip=101.204.27.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hygon.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hygon.cn
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by mailgw2.hygon.cn (Postfix) with ESMTP id 4g06hl3478z1YQpmD;
	Tue, 21 Apr 2026 11:07:03 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by mailgw2.hygon.cn (Postfix) with ESMTP id 4g06hj31Ffz1YQpmD;
	Tue, 21 Apr 2026 11:07:01 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id A77E933D4F40;
	Tue, 21 Apr 2026 11:07:00 +0800 (CST)
Received: from hsj-2U-Workstation (172.19.20.61) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 21 Apr
 2026 11:06:53 +0800
Date: Tue, 21 Apr 2026 11:06:59 +0800
From: Huang Shijie <huangsj@hygon.cn>
To: Pedro Falcato <pfalcato@suse.de>
CC: Mateusz Guzik <mjguzik@gmail.com>, <akpm@linux-foundation.org>,
	<viro@zeniv.linux.org.uk>, <brauner@kernel.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-fsdevel@vger.kernel.org>, <muchun.song@linux.dev>,
	<osalvador@suse.de>, <linux-trace-kernel@vger.kernel.org>,
	<linux-perf-users@vger.kernel.org>, <linux-parisc@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <zhongyuan@hygon.cn>, <fangbaoshun@hygon.cn>,
	<yingzhiwei@hygon.cn>
Subject: Re: [PATCH 0/3] mm: split the file's i_mmap tree for NUMA
Message-ID: <aebp06qEMBx3yjHg@hsj-2U-Workstation>
References: <20260413062042.804-1-huangsj@hygon.cn>
 <76pfiwabdgsej6q2yxfh3efuqvsyg7mt7rvl5itzzjyhdrto5r@53viaxsackzv>
 <aeWLCxru6cLWsxvQ@SH-HV00110.Hygon.cn>
 <hshxzebq5y4gavo7mbrgn7qitz5j5wyun73wy7ooiiehzzpcui@hlknbp34sgja>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <hshxzebq5y4gavo7mbrgn7qitz5j5wyun73wy7ooiiehzzpcui@hlknbp34sgja>
X-ClientProxiedBy: cncheex05.Hygon.cn (172.23.18.115) To cncheex04.Hygon.cn
 (172.23.18.114)

On Mon, Apr 20, 2026 at 02:48:49PM +0100, Pedro Falcato wrote:
> BTW you're missing _a lot_ of CC's here, including the whole of mm/rmap.c
> maintainership.

Thanks, my fault.

> 
> On Mon, Apr 20, 2026 at 10:10:19AM +0800, Huang Shijie wrote:
> > On Mon, Apr 13, 2026 at 05:33:21PM +0200, Mateusz Guzik wrote:
> > > On Mon, Apr 13, 2026 at 02:20:39PM +0800, Huang Shijie wrote:
> > > >   In NUMA, there are maybe many NUMA nodes and many CPUs.
> > > > For example, a Hygon's server has 12 NUMA nodes, and 384 CPUs.
> > > > In the UnixBench tests, there is a test "execl" which tests
> > > > the execve system call.
> > > > 
> > > >   When we test our server with "./Run -c 384 execl",
> > > > the test result is not good enough. The i_mmap locks contended heavily on
> > > > "libc.so" and "ld.so". For example, the i_mmap tree for "libc.so" can have 
> > > > over 6000 VMAs, all the VMAs can be in different NUMA mode.
> > > > The insert/remove operations do not run quickly enough.
> > > > 
> > > > patch 1 & patch 2 are try to hide the direct access of i_mmap.
> > > > patch 3 splits the i_mmap into sibling trees, and we can get better 
> > > > performance with this patch set:
> > > >     we can get 77% performance improvement(10 times average)
> > > > 
> > > 
> > > To my reading you kept the lock as-is and only distributed the protected
> > > state.
> > > 
> > > While I don't doubt the improvement, I'm confident should you take a
> > > look at the profile you are going to find this still does not scale with
> > > rwsem being one of the problems (there are other global locks, some of
> > > which have experimental patches for).
> > > 
> > > Apart from that this does nothing to help high core systems which are
> > > all one node, which imo puts another question mark on this specific
> > > proposal.
> > > 
> > > Of course one may question whether a RB tree is the right choice here,
> > > it may be the lock-protected cost can go way down with merely a better
> > > data structure.
> > > 
> > > Regardless of that, for actual scalability, there will be no way around
> > > decentralazing locking around this and partitioning per some core count
> > > (not just by numa awareness).
> > > 
> > > Decentralizing locking is definitely possible, but I have not looked
> > > into specifics of how problematic it is. Best case scenario it will
> > > merely with separate locks. Worst case scenario something needs a fully
> > > stabilized state for traversal, in that case another rw lock can be
> > > slapped around this, creating locking order read lock -> per-subset
> > > write lock -- this will suffer scalability due to the read locking, but
> > > it will still scale drastically better as apart from that there will be
> > > no serialization. In this setting the problematic consumer will write
> > > lock the new thing to stabilize the state.
> > > 
> > I thought over again.
> > I can change this patch set to support the non-NUMA case by:
> >   1.) Still use one rw lock.
> 
> No. This doesn't help anything.
> 
> >   2.) For NUMA, keep the patch set as it is.
> 
> Please no. No NUMA vs non-NUMA case.
> 
> >   3.) For non-NUMA case, split the i_mmap tree to several subtrees.
> >       For example, if a machine has 192 CPUs, split the 32 CPUs as a tree.
> 
> If lock contention is the problem, I don't see how splitting the tree helps,
> unless it helps reduce lock hold time in a way that randomly helps your workload.
> But that's entirely random.
We actually face two issues:
   1.) the lock contention
   2.) the lock hold time.

IMHO, if we can reduce the lock hold time, we can ease the lock contention too.
So this patch set is to reduce the lock hold time, which is much helpful in our
NUMA server in UnixBench test.

If we split the lock into small locks, we can also benefit from it. 
If you or Mateusz create the patch in future, I can test it on our server.
I wonder if it can give us better performance then current patch set.

Thanks
Huang Shijie

