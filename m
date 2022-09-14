Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC0C4403
	for <nvdimm@lists.linux.dev>; Wed, 14 Sep 2022 18:09:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D4A6C433C1;
	Wed, 14 Sep 2022 18:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1663178963;
	bh=2Vax29sc4ZSisv5YCVSdfRKAOSq8E9/1iuj8XUbl3q4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EsHCSiUbI1qgnhHLG1idfk2LDZW2y5wlqq6RPLuRhkUqSCQMq+p4V4JwgDebH8jRr
	 G216o+in0R2PwpYVv0Ahu6rocVSQKRLzRzp8k4P9ID0paeQG6E+kPASeuHviWCcEJl
	 wjeygFcKi5tqn2JxkSALd+OUvmimqXQSiOVyjgM34Mkds0vqv/OIxY+j5DC9h3Prhd
	 qgAQwISbu49tOwm2TM1MvscXv0XeQzeBr0JCOd9BrYQBwM8eacE3NC3k3SDnXXn2s5
	 iaYs/AxvyINJcFiiA4wam7OY/4BjEUyId+EAUgDGwISSBFGZmI5RnF07YdGxtcMxuC
	 p6Znf0+j3vh+w==
Date: Wed, 14 Sep 2022 11:09:23 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: dan.j.williams@intel.com, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, nvdimm@lists.linux.dev,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	hch@infradead.org, david@fromorbit.com, jane.chu@oracle.com
Subject: Re: [PATCH v8 0/3] mm, pmem, xfs: Introduce MF_MEM_REMOVE for unbind
Message-ID: <YyIY0+8AzTIDKMVy@magnolia>
References: <9e9521a4-6e07-e226-2814-b78a2451656b@fujitsu.com>
 <1662114961-66-1-git-send-email-ruansy.fnst@fujitsu.com>
 <bf68da75-5b05-5376-c306-24f9d2b92e80@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bf68da75-5b05-5376-c306-24f9d2b92e80@fujitsu.com>

On Wed, Sep 07, 2022 at 05:46:00PM +0800, Shiyang Ruan wrote:
> ping
> 
> 在 2022/9/2 18:35, Shiyang Ruan 写道:
> > Changes since v7:
> >    1. Add P1 to fix calculation mistake
> >    2. Add P2 to move drop_pagecache_sb() to super.c for xfs to use
> >    3. P3: Add invalidate all mappings after sync.
> >    4. P3: Set offset&len to be start&length of device when it is to be removed.
> >    5. Rebase on 6.0-rc3 + Darrick's patch[1] + Dan's patch[2].
> > 
> > Changes since v6:
> >    1. Rebase on 6.0-rc2 and Darrick's patch[1].
> > 
> > [1]: https://lore.kernel.org/linux-xfs/Yv5wIa2crHioYeRr@magnolia/
> > [2]: https://lore.kernel.org/linux-xfs/166153426798.2758201.15108211981034512993.stgit@dwillia2-xfh.jf.intel.com/

Just out of curiosity, is it your (or djbw's) intent to send all these
as bugfixes for 6.0 via akpm like all the other dax fixen?

--D

> > 
> > Shiyang Ruan (3):
> >    xfs: fix the calculation of length and end
> >    fs: move drop_pagecache_sb() for others to use
> >    mm, pmem, xfs: Introduce MF_MEM_REMOVE for unbind
> > 
> >   drivers/dax/super.c         |  3 ++-
> >   fs/drop_caches.c            | 33 ---------------------------------
> >   fs/super.c                  | 34 ++++++++++++++++++++++++++++++++++
> >   fs/xfs/xfs_notify_failure.c | 31 +++++++++++++++++++++++++++----
> >   include/linux/fs.h          |  1 +
> >   include/linux/mm.h          |  1 +
> >   6 files changed, 65 insertions(+), 38 deletions(-)
> > 
