Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A8614386D;
	Thu, 13 Mar 2025 17:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741887183; cv=none; b=BVr8glYBvPIZ2WSNwIusdrqLTnFHuFiD1zXFVB44Msc3mh5PoGba6s54OC5t0905lTL7BaMDcskXPSFI1UymY/eEeS0KtSs8jNY7hcUpIJq3SV7YHUTzzt6n4hwCYM7sCSfF9TEO30PGOFGbAAL+K2S3LCBmFwwKsJ46ykm9QLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741887183; c=relaxed/simple;
	bh=KufBf6SNVV2/+3f+j7cVUdlgE/k57oz+yacfQZgVu0o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D2VyhC+jqrVJ5SXFHLcooViHTooJh+pHm/6ULxDzFVIgehYMptTmp0qeNjKgaRroVf/oeUc6ezyU3+v1U/SebRELj0R2RGYSE+CQQYd8p8h3vOe9HZ5oeDIzV6tb5LaOpCrtyVD0qQIQp1M0DIwBgKeWcA3ifK8DkOi8HXHFTy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=glfl0tST; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="glfl0tST"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8795C4CEDD;
	Thu, 13 Mar 2025 17:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741887182;
	bh=KufBf6SNVV2/+3f+j7cVUdlgE/k57oz+yacfQZgVu0o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=glfl0tSTDarf5KmqF2WaDKQ2aRgXTC2tuZCMgPixsObeC0jAFrgN3rInTUWfn0763
	 IbTUdLElP7hTrnIqxhoBOjbuQXmNvzO62AXUJpkcz7ojHEH0Qq552EN6lP6+5kKVyO
	 21XKi5XV0757FEkmF1hVr4jd6GhrGaVTCaCeieCwv+wcygHRTVyzpNB879d6cmtUqG
	 2XEPCXesdn3A0vr6fnke/W1ltXLgodm8hgyjYbkS5uwwIrVXs0feJbcqowtqo1ahnP
	 H9qaMyKjyptQvO5fkVzqDZuvO7MC82StGOKEqbR7pykgPK9Zy85yxzTBBaKBG4Lvkz
	 6MfRNnXGGfTqw==
Date: Thu, 13 Mar 2025 10:33:00 -0700
From: Minchan Kim <minchan@kernel.org>
To: Barry Song <21cnbao@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Qun-Wei Lin <qun-wei.lin@mediatek.com>,
	Jens Axboe <axboe@kernel.dk>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chris Li <chrisl@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
	"Huang, Ying" <ying.huang@intel.com>,
	Kairui Song <kasong@tencent.com>,
	Dan Schatzberg <schatzberg.dan@gmail.com>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	Casper Li <casper.li@mediatek.com>,
	Chinwen Chang <chinwen.chang@mediatek.com>,
	Andrew Yang <andrew.yang@mediatek.com>,
	James Hsu <james.hsu@mediatek.com>
Subject: Re: [PATCH 0/2] Improve Zram by separating compression context from
 kswapd
Message-ID: <Z9MWzDUxUigJrZXt@google.com>
References: <20250307120141.1566673-1-qun-wei.lin@mediatek.com>
 <Z9HOavSkFf01K9xh@google.com>
 <5gqqbq67th4xiufiw6j3ewih6htdepa4u5lfirdeffrui7hcdn@ly3re3vgez2g>
 <CAGsJ_4xwnVxn1odj=j+z0VXm1DRUmnhugnwCH-coqBLJweDu9Q@mail.gmail.com>
 <Z9MCwXzYDRJoTiIr@google.com>
 <CAGsJ_4yaSx1vEiZdCouBveeH3D-bQDdvrhRpz=Kbvqn30Eh-nA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4yaSx1vEiZdCouBveeH3D-bQDdvrhRpz=Kbvqn30Eh-nA@mail.gmail.com>

On Fri, Mar 14, 2025 at 05:58:00AM +1300, Barry Song wrote:
> On Fri, Mar 14, 2025 at 5:07 AM Minchan Kim <minchan@kernel.org> wrote:
> >
> > On Thu, Mar 13, 2025 at 04:45:54PM +1300, Barry Song wrote:
> > > On Thu, Mar 13, 2025 at 4:09 PM Sergey Senozhatsky
> > > <senozhatsky@chromium.org> wrote:
> > > >
> > > > On (25/03/12 11:11), Minchan Kim wrote:
> > > > > On Fri, Mar 07, 2025 at 08:01:02PM +0800, Qun-Wei Lin wrote:
> > > > > > This patch series introduces a new mechanism called kcompressd to
> > > > > > improve the efficiency of memory reclaiming in the operating system. The
> > > > > > main goal is to separate the tasks of page scanning and page compression
> > > > > > into distinct processes or threads, thereby reducing the load on the
> > > > > > kswapd thread and enhancing overall system performance under high memory
> > > > > > pressure conditions.
> > > > > >
> > > > > > Problem:
> > > > > >  In the current system, the kswapd thread is responsible for both
> > > > > >  scanning the LRU pages and compressing pages into the ZRAM. This
> > > > > >  combined responsibility can lead to significant performance bottlenecks,
> > > > > >  especially under high memory pressure. The kswapd thread becomes a
> > > > > >  single point of contention, causing delays in memory reclaiming and
> > > > > >  overall system performance degradation.
> > > > >
> > > > > Isn't it general problem if backend for swap is slow(but synchronous)?
> > > > > I think zram need to support asynchrnous IO(can do introduce multiple
> > > > > threads to compress batched pages) and doesn't declare it's
> > > > > synchrnous device for the case.
> > > >
> > > > The current conclusion is that kcompressd will sit above zram,
> > > > because zram is not the only compressing swap backend we have.
> >
> > Then, how handles the file IO case?
> 
> I didn't quite catch your question :-)

Sorry for not clear.

What I meant was zram is also used for fs backend storage, not only
for swapbackend. The multiple simultaneous compression can help the case,
too.

> 
> >
> > >
> > > also. it is not good to hack zram to be aware of if it is kswapd
> > > , direct reclaim , proactive reclaim and block device with
> > > mounted filesystem.
> >
> > Why shouldn't zram be aware of that instead of just introducing
> > queues in the zram with multiple compression threads?
> >
> 
> My view is the opposite of yours :-)
> 
> Integrating kswapd, direct reclaim, etc., into the zram driver
> would violate layering principles. zram is purely a block device

That's the my question. What's the reason zram need to know about
kswapd, direct_reclaim and so on? I didn't understand your input.

> driver, and how it is used should be handled separately. Callers have
> greater flexibility to determine its usage, similar to how different
> I/O models exist in user space.
> 
> Currently, Qun-Wei's patch checks whether the current thread is kswapd.
> If it is, compression is performed asynchronously by threads;
> otherwise, it is done in the current thread. In the future, we may

Okay, then, why should we do that without following normal asynchrnous
disk storage? VM justs put the IO request and sometimes congestion
control. Why is other logic needed for the case?

> have additional reclaim threads, such as for damon or
> madv_pageout, etc.
> 
> > >
> > > so i am thinking sth as below
> > >
> > > page_io.c
> > >
> > > if (sync_device or zswap_enabled())
> > >    schedule swap_writepage to a separate per-node thread
> >
> > I am not sure that's a good idea to mix a feature to solve different
> > layers. That wouldn't be only swap problem. Such an parallelism under
> > device  is common technique these days and it would help file IO cases.
> >
> 
> zswap and zram share the same needs, and handling this in page_io
> can benefit both through common code. It is up to the callers to decide
> the I/O model.
> 
> I agree that "parallelism under the device" is a common technique,
> but our case is different—the device achieves parallelism with
> offload hardware, whereas we rely on CPUs, which can be scarce.
> These threads may also preempt CPUs that are critically needed
> by other non-compression tasks, and burst power consumption
> can sometimes be difficult to control.

That's general problem for common resources in the system and always
trace-off domain in the workload areas. Eng folks has tried to tune
them statically/dynamically depending on system behavior considering
what they priorites.

> 
> > Furthermore, it would open the chance for zram to try compress
> > multiple pages at once.
> 
> We are already in this situation when multiple callers use zram simultaneously,
> such as during direct reclaim or with a mounted filesystem.
> 
> Of course, this allows multiple pages to be compressed simultaneously,
> even if the user is single-threaded. However, determining when to enable
> these threads and whether they will be effective is challenging, as it
> depends on system load. For example, Qun-Wei's patch chose not to use
> threads for direct reclaim as, I guess,  it might be harmful.

Direct reclaim is already harmful and that's why VM has the logic 
to throttle writeback or other special logics for kswapd or direct
reclaim path for th IO, which could be applied into the zram, too.
