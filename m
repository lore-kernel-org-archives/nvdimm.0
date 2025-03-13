Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CAF26A084;
	Thu, 13 Mar 2025 16:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741882052; cv=none; b=F8W67FZwYyiN3Re1ahpTrGOeTfZVd8kPleHJbJY6g/JJiIExMvJh9A0p/jE8rrGKezrufg76ui/iaH4+FDE7hekGiQv8CVOPBAB6XGXiM4JhtBl98LJZyoZho4/cSAZOR/UykarO/lemcQFjhLYMpiYS2mf979X66oK6ujAF41k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741882052; c=relaxed/simple;
	bh=BQXFOxNso8FIR8jzDbLHKPtOvTBzr+ixEF9OdVlcvsU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V2VVbz7wmdjqBhqaD/jN8RTVoY1bij1bHIn5h0rjxhYtTpMY5b3HhsABOJQ8De9ZmGgbM4Jk/6yOWXRqhxWceQ3llnsNe4zzWqBXSjH3rYHtKDv5iD0a1eITcEcHOwBSF6pd0d9daCFofv3+hgQksPRXAEwvPEnIhVcJih4mxns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UjKy5Mzq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UjKy5Mzq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A13F2C4CEDD;
	Thu, 13 Mar 2025 16:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741882051;
	bh=BQXFOxNso8FIR8jzDbLHKPtOvTBzr+ixEF9OdVlcvsU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UjKy5MzqzIf+Yh8yvIA5cYhQvCRvJOMZGRgCouhY4XQbqEPhgnpvqfobojD4k3n12
	 wPZl/IJFvxCMgknbhUHC+PUev3Ir7M5Nui+VNqJaWgxmhq8wH6oM576OYZdo8TCy3r
	 8jyrewO1JtE5lPWCVMoJCbFdZPhfzDPFlU5DxzBUq2kVXaupL89bbPA/R7b7owqkcP
	 9Xo/T9lSdTEOGxVaomzVn47eKegUTlGozpbyswaqQH7fTy1maVjz7LnbGNj+lF3JE9
	 A3L76Vy6ZidOs89C/z2g+3iPgSIemcEcrtz7AsPycCV8qmThcg/FZuqazBQ7P5ckJO
	 TOm/z9TRq2JZQ==
Date: Thu, 13 Mar 2025 09:07:29 -0700
From: Minchan Kim <minchan@kernel.org>
To: Barry Song <baohua@kernel.org>
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
Message-ID: <Z9MCwXzYDRJoTiIr@google.com>
References: <20250307120141.1566673-1-qun-wei.lin@mediatek.com>
 <Z9HOavSkFf01K9xh@google.com>
 <5gqqbq67th4xiufiw6j3ewih6htdepa4u5lfirdeffrui7hcdn@ly3re3vgez2g>
 <CAGsJ_4xwnVxn1odj=j+z0VXm1DRUmnhugnwCH-coqBLJweDu9Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4xwnVxn1odj=j+z0VXm1DRUmnhugnwCH-coqBLJweDu9Q@mail.gmail.com>

On Thu, Mar 13, 2025 at 04:45:54PM +1300, Barry Song wrote:
> On Thu, Mar 13, 2025 at 4:09 PM Sergey Senozhatsky
> <senozhatsky@chromium.org> wrote:
> >
> > On (25/03/12 11:11), Minchan Kim wrote:
> > > On Fri, Mar 07, 2025 at 08:01:02PM +0800, Qun-Wei Lin wrote:
> > > > This patch series introduces a new mechanism called kcompressd to
> > > > improve the efficiency of memory reclaiming in the operating system. The
> > > > main goal is to separate the tasks of page scanning and page compression
> > > > into distinct processes or threads, thereby reducing the load on the
> > > > kswapd thread and enhancing overall system performance under high memory
> > > > pressure conditions.
> > > >
> > > > Problem:
> > > >  In the current system, the kswapd thread is responsible for both
> > > >  scanning the LRU pages and compressing pages into the ZRAM. This
> > > >  combined responsibility can lead to significant performance bottlenecks,
> > > >  especially under high memory pressure. The kswapd thread becomes a
> > > >  single point of contention, causing delays in memory reclaiming and
> > > >  overall system performance degradation.
> > >
> > > Isn't it general problem if backend for swap is slow(but synchronous)?
> > > I think zram need to support asynchrnous IO(can do introduce multiple
> > > threads to compress batched pages) and doesn't declare it's
> > > synchrnous device for the case.
> >
> > The current conclusion is that kcompressd will sit above zram,
> > because zram is not the only compressing swap backend we have.

Then, how handles the file IO case?

> 
> also. it is not good to hack zram to be aware of if it is kswapd
> , direct reclaim , proactive reclaim and block device with
> mounted filesystem.

Why shouldn't zram be aware of that instead of just introducing
queues in the zram with multiple compression threads?

> 
> so i am thinking sth as below
> 
> page_io.c
> 
> if (sync_device or zswap_enabled())
>    schedule swap_writepage to a separate per-node thread

I am not sure that's a good idea to mix a feature to solve different
layers. That wouldn't be only swap problem. Such an parallelism under
device  is common technique these days and it would help file IO cases.

Furthermore, it would open the chance for zram to try compress
multiple pages at once.
