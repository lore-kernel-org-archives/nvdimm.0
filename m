Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E48082917
	for <nvdimm@lists.linux.dev>; Wed, 11 May 2022 15:19:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 831A7C34116;
	Wed, 11 May 2022 15:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1652282396;
	bh=joIzrZGOxLsqbcRc0VMzZQ0L7R/xhNhcMB/bFdMJecY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qSot7MYj00eHckTgvQJT1nELlQjLTCT2Ti43H6u9Ym09lTZRWZ0lhyDvHku9kMw4O
	 /Ytp53/sJZmPYBee9BEaD4BEN2RixhSpGVgY7LkiG8E4fOFitcGy/5QDTpQX7rg2+G
	 JwhKHLV2GfEUYimBu6TtBQgK8CSLEzSXBnHkD6KuaaNiiYn9vrHDG/flbDwve77fdR
	 SyT16NuYUSHEmamagyHKZGDrVuhivSRV+/SB3X4+5fF6etuBMvGH9z/Q31mxJTnthu
	 VZxX37BdCldSE2iFSBX4FiGPQbkO3YZgK8hPgTykZE6XpS5W9LYqeOyBhlZL3qdYTj
	 XGb74FjcKl/aw==
Date: Wed, 11 May 2022 08:19:55 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Dave Chinner <david@fromorbit.com>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-xfs <linux-xfs@vger.kernel.org>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	Linux MM <linux-mm@kvack.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Jane Chu <jane.chu@oracle.com>,
	Goldwyn Rodrigues <rgoldwyn@suse.de>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Matthew Wilcox <willy@infradead.org>,
	Naoya Horiguchi <naoya.horiguchi@nec.com>, linmiaohe@huawei.com
Subject: Re: [PATCHSETS] v14 fsdax-rmap + v11 fsdax-reflink
Message-ID: <20220511151955.GC27212@magnolia>
References: <20220508143620.1775214-1-ruansy.fnst@fujitsu.com>
 <20220511000352.GY27195@magnolia>
 <20220511014818.GE1098723@dread.disaster.area>
 <CAPcyv4h0a3aT3XH9qCBW3nbT4K3EwQvBSD_oX5W=55_x24-wFA@mail.gmail.com>
 <20220510192853.410ea7587f04694038cd01de@linux-foundation.org>
 <20220511024301.GD27195@magnolia>
 <20220510222428.0cc8a50bd007474c97b050b2@linux-foundation.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510222428.0cc8a50bd007474c97b050b2@linux-foundation.org>

Oan Tue, May 10, 2022 at 10:24:28PM -0700, Andrew Morton wrote:
> On Tue, 10 May 2022 19:43:01 -0700 "Darrick J. Wong" <djwong@kernel.org> wrote:
> 
> > On Tue, May 10, 2022 at 07:28:53PM -0700, Andrew Morton wrote:
> > > On Tue, 10 May 2022 18:55:50 -0700 Dan Williams <dan.j.williams@intel.com> wrote:
> > > 
> > > > > It'll need to be a stable branch somewhere, but I don't think it
> > > > > really matters where al long as it's merged into the xfs for-next
> > > > > tree so it gets filesystem test coverage...
> > > > 
> > > > So how about let the notify_failure() bits go through -mm this cycle,
> > > > if Andrew will have it, and then the reflnk work has a clean v5.19-rc1
> > > > baseline to build from?
> > > 
> > > What are we referring to here?  I think a minimal thing would be the
> > > memremap.h and memory-failure.c changes from
> > > https://lkml.kernel.org/r/20220508143620.1775214-4-ruansy.fnst@fujitsu.com ?
> > > 
> > > Sure, I can scoot that into 5.19-rc1 if you think that's best.  It
> > > would probably be straining things to slip it into 5.19.
> > > 
> > > The use of EOPNOTSUPP is a bit suspect, btw.  It *sounds* like the
> > > right thing, but it's a networking errno.  I suppose livable with if it
> > > never escapes the kernel, but if it can get back to userspace then a
> > > user would be justified in wondering how the heck a filesystem
> > > operation generated a networking errno?
> > 
> > <shrug> most filesystems return EOPNOTSUPP rather enthusiastically when
> > they don't know how to do something...
> 
> Can it propagate back to userspace?

AFAICT, the new code falls back to the current (mf_generic_kill_procs)
failure code if the filesystem doesn't provide a ->memory_failure
function or if it returns -EOPNOSUPP.  mf_generic_kill_procs can also
return -EOPNOTSUPP, but all the memory_failure() callers (madvise, etc.)
convert that to 0 before returning it to userspace.

I suppose the weirder question is going to be what happens when madvise
starts returning filesystem errors like EIO or EFSCORRUPTED when pmem
loses half its brains and even the fs can't deal with it.

--D
