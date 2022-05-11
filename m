Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2D4015B4
	for <nvdimm@lists.linux.dev>; Wed, 11 May 2022 02:43:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90AECC385CB;
	Wed, 11 May 2022 02:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1652236981;
	bh=H+slBZhjJ5EG7moKEOfvPRRGLjpkOTwOOM/Iqo+g4oY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FxyrotPwafWFnECQ6+E1BpXm+/56DaFyJ/XOvXN884cx5Km0J/vV+razdDlMXFYGE
	 JxWHkLwz2P5tCkPvHzepdp/zjD3UYVmnoVeOBblQAJlz5BXr4ZxiYMXzqJpZWC/I5E
	 i9BaywZ949nDVoG6E2cmfJXLikmAOkTU9g+QdqYiLdD42X9dzXIM1n8cP9Ik17gMKE
	 Z/hkeyECRJhqGjdEcze11T7rsAQiF4miwr6XESuE1Rix93PDZ6w921TM9hLtdrRHd6
	 V72lXep5kkgc9R4tGJAvA366FPEe3zzjoeWflOeQ5ngwG3LVbgVWKqV4roBtcsTaz2
	 WRv7inNKqcdfg==
Date: Tue, 10 May 2022 19:43:01 -0700
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
Message-ID: <20220511024301.GD27195@magnolia>
References: <20220508143620.1775214-1-ruansy.fnst@fujitsu.com>
 <20220511000352.GY27195@magnolia>
 <20220511014818.GE1098723@dread.disaster.area>
 <CAPcyv4h0a3aT3XH9qCBW3nbT4K3EwQvBSD_oX5W=55_x24-wFA@mail.gmail.com>
 <20220510192853.410ea7587f04694038cd01de@linux-foundation.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510192853.410ea7587f04694038cd01de@linux-foundation.org>

On Tue, May 10, 2022 at 07:28:53PM -0700, Andrew Morton wrote:
> On Tue, 10 May 2022 18:55:50 -0700 Dan Williams <dan.j.williams@intel.com> wrote:
> 
> > > It'll need to be a stable branch somewhere, but I don't think it
> > > really matters where al long as it's merged into the xfs for-next
> > > tree so it gets filesystem test coverage...
> > 
> > So how about let the notify_failure() bits go through -mm this cycle,
> > if Andrew will have it, and then the reflnk work has a clean v5.19-rc1
> > baseline to build from?
> 
> What are we referring to here?  I think a minimal thing would be the
> memremap.h and memory-failure.c changes from
> https://lkml.kernel.org/r/20220508143620.1775214-4-ruansy.fnst@fujitsu.com ?
> 
> Sure, I can scoot that into 5.19-rc1 if you think that's best.  It
> would probably be straining things to slip it into 5.19.
> 
> The use of EOPNOTSUPP is a bit suspect, btw.  It *sounds* like the
> right thing, but it's a networking errno.  I suppose livable with if it
> never escapes the kernel, but if it can get back to userspace then a
> user would be justified in wondering how the heck a filesystem
> operation generated a networking errno?

<shrug> most filesystems return EOPNOTSUPP rather enthusiastically when
they don't know how to do something...

--D
