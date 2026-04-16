Received: from mailgw2.hygon.cn (unknown [101.204.27.37])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F78437F8AF
	for <nvdimm@lists.linux.dev>; Thu, 16 Apr 2026 11:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.204.27.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776340131; cv=none; b=n7vztheC25PJ42u+XM3Vyu3vWQuPeliSPE+teGWXHhC46/4VfWORoeOJ6iP0yXFj5hmiCuqTQ0wck8Yu4cUf03SST5ZXjRBFECK8T6YkKd5LdtBc5Cb97TtIp0M+Mkoct4nD3SC5JOBRlA4lzmdU1A9ai2P/ptEPwTHfW9fTDi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776340131; c=relaxed/simple;
	bh=zyZe1jx0hO5jVoW7hrnjF3AvZ7XWdFK+r/bsC+RDY5w=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hvvqxOxm5zElrMjEgTeVVxYQMnp6Vj8j9jaxj24xlQEq6YVmPjuVNdXhASCrNwvB4FMuLfRZLJG0JfpHDck9hbIJK8zgUa+YkLDWmOT3S7Lrx2G7x3xYo/THOIxod1HKqBEoJb+YsxocKSbIn4kLP3CM9n3Zs+5EWea2wJafU7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hygon.cn; spf=pass smtp.mailfrom=hygon.cn; arc=none smtp.client-ip=101.204.27.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hygon.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hygon.cn
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by mailgw2.hygon.cn (Postfix) with ESMTP id 4fxGVj1kD1z1YQpmX;
	Thu, 16 Apr 2026 19:48:29 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by mailgw2.hygon.cn (Postfix) with ESMTP id 4fxGVh5pwfz1YQpmX;
	Thu, 16 Apr 2026 19:48:28 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id CC695300D1F6;
	Thu, 16 Apr 2026 19:46:31 +0800 (CST)
Received: from SH-HV00110.Hygon.cn (172.19.26.208) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 16 Apr
 2026 19:48:27 +0800
Date: Thu, 16 Apr 2026 19:48:24 +0800
From: Huang Shijie <huangsj@hygon.cn>
To: Mateusz Guzik <mjguzik@gmail.com>
CC: <akpm@linux-foundation.org>, <viro@zeniv.linux.org.uk>,
	<brauner@kernel.org>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
	<muchun.song@linux.dev>, <osalvador@suse.de>,
	<linux-trace-kernel@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
	<linux-parisc@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<zhongyuan@hygon.cn>, <fangbaoshun@hygon.cn>, <yingzhiwei@hygon.cn>
Subject: Re: [PATCH 0/3] mm: split the file's i_mmap tree for NUMA
Message-ID: <aeDMiBqscm-CZA6D@SH-HV00110.Hygon.cn>
References: <20260413062042.804-1-huangsj@hygon.cn>
 <76pfiwabdgsej6q2yxfh3efuqvsyg7mt7rvl5itzzjyhdrto5r@53viaxsackzv>
 <ad4EvoDcAKE2Sl4+@hsj-2U-Workstation>
 <CAGudoHGLaoc+CoBPNCvFRYojnj+6E_Lsdv7NaJWxFMoHezemMQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGudoHGLaoc+CoBPNCvFRYojnj+6E_Lsdv7NaJWxFMoHezemMQ@mail.gmail.com>
X-ClientProxiedBy: cncheex06.Hygon.cn (172.23.18.116) To cncheex04.Hygon.cn
 (172.23.18.114)

On Thu, Apr 16, 2026 at 12:29:50PM +0200, Mateusz Guzik wrote:
> On Tue, Apr 14, 2026 at 11:11 AM Huang Shijie <huangsj@hygon.cn> wrote:
> >
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
> > IMHO, when the number of VMAs in the i_mmap is very large, only optimise the rwsem
> > lock does not help too much for our NUMA case.
> >
> > In our NUMA server, the remote access could be the major issue.
> >
> 
> I'm confused how this is not supposed to help. You moved your data to
> be stored per-domain. With my proposal the lock itself will also get
> that treatment.
> 
> Modulo the issue of what to do with code wanting to iterate the entire
> thing, this is blatantly faster.
> 

I tested an old lock patch yesterday. It really helps a lot.
The lock patch is from this link:
  https://lkml.org/lkml/2024/9/14/280

The test results:
   v7.0-rc5 + (lock patch)                    : improve about %60%
   v7.0-rc5 + (lock patch) + (this patch set) : improve about 130%			   

						
> >
> > >
> > > Apart from that this does nothing to help high core systems which are
> > > all one node, which imo puts another question mark on this specific
> > > proposal.
> > Yes, this patch set only focus on the NUMA case.
> > The one-node case should use the original i_mmap.
> >
> > Maybe I can add a new config, CONFIG_SPILT_I_MMAP. The config is disabled
> > by default, and enabled when the NUMA node is not one.
> >
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
> > Yes.
> >
> > The traversal may need to hold many locks.
> >
> 
> The very paragraph you partially quoted answers what to do in that
> case: wrap everything with a new rwsem taken for reading when
> adding/removing entries and taken for writing when iterating the
> entire thing. Then the iteration sticks to one lock.
> 
> The new rw lock puts an upper ceiling on scalability of the thing, but
> it is way higher than the current state.
Could you tell me the patch about it?
Is this lock patch merged ? or not?

I can test it.

> 
> Given the extra overhead associated with it one could consider
> sticking to one centralized state by default and switching to
> distributed state if there is enough contention.
> 
> > > slapped around this, creating locking order read lock -> per-subset
> > > write lock -- this will suffer scalability due to the read locking, but
> > > it will still scale drastically better as apart from that there will be
> > > no serialization. In this setting the problematic consumer will write
> > > lock the new thing to stabilize the state.
> > >
> > > So my non-maintainer opinion is that the patchset is not worth it as it
> > > fails to address anything for significantly more common and already
> > > affected setups.
> > This patch set is to reduce the remote access latency for insert/remove VMA
> > in NUMA.
> >
> 
> And I am saying the mmap semaphore is a significant problem already on
> high-core no-numa setups. Addressing scalability in that case would
> sort out the problem in your setup and to a significantly higher
> extent.
I am afraid even the lock patch resolves the scalability high-core no-numa setups,
we still need to split the i_mmap for NUMA.

> 
> > >
> > > Have you looked into splitting the lock?
> > >
> > I ever tried.
> >
> > But there are two disadvantages:
> >   1.) The traversal may need to hold many locks which makes the
> >       code very horrible.
> >
> 
> I already above this is avoidable.
> 
> >   2.) Even we split the locks. Each lock protects a tree, when the tree becomes
> >       big enough, the VMA insert/remove will also become slow in NUMA.
> >       The reason is that the tree has VMAs in different NUMA nodes.
> >
> 
> This is orthogonal to my proposal. In fact, if one is to pretend this
> is never a factor with your patch, I would like to point out it will
> remain not a factor if the per-numa struct gets its own lock.
Yes. It is orthogonal to your proposal.

Thanks
Huang Shijie

