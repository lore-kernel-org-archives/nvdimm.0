Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37BF15123C
	for <nvdimm@lists.linux.dev>; Thu, 28 Sep 2023 17:13:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 939ECC433CA;
	Thu, 28 Sep 2023 17:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1695921219;
	bh=xc71nH9PeN+Mpkyd0K3f9ai/3747MbMlx6iYRlknsiQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qZuPYWyW2J+aLKOVzgHAZR2rrYx+C88RDth8g9RK7ubv66N7uN7K1HR+Z5bM/Y+Ps
	 pJVCu33eV+9DnHF5pvXuvJ93WvJHSzK4tIVGw2nmoS/C4CkeM7mjaXCgp4GEsHjqUK
	 ucOmI9MKMm6G+1nGC069rH7PmqE8G9WOZw5cXcMDUWopKTo7K1odcgokdAfb+GSFEd
	 vmnmN4kv5Bo6AFzZpZk1Sv6YNpOJ10fUeyGpZGkHOvt5vBZergH1OxvDuAmaDeRdwj
	 RIvn3DlC+uvXDmGTdiABoLDq/96uTO0tMuI+/ZeNr3jRh5wCHDlFrhsDuxsC+Q4FH0
	 29RStZMXpsW+g==
Date: Thu, 28 Sep 2023 10:13:39 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Shiyang Ruan <ruansy.fnst@fujitsu.com>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, dan.j.williams@intel.com
Subject: Re: [PATCH] xfs: drop experimental warning for FSDAX
Message-ID: <20230928171339.GJ11439@frogsfrogsfrogs>
References: <20230926145519.GE11439@frogsfrogsfrogs>
 <ZROC8hEabAGS7orb@dread.disaster.area>
 <20230927014632.GE11456@frogsfrogsfrogs>
 <87fs306zs1.fsf@debian-BULLSEYE-live-builder-AMD64>
 <5c064cbd-13a3-4d55-9881-0a079476d865@fujitsu.com>
 <bc29af15-ae63-407d-8ca0-186c976acce7@fujitsu.com>
 <87y1gs83yq.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20230927083034.90bd6336229dd00af601e0ef@linux-foundation.org>
 <9c3cbc0c-7135-4006-ad4a-2abce0a556b0@fujitsu.com>
 <20230928092052.9775e59262c102dc382513ef@linux-foundation.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230928092052.9775e59262c102dc382513ef@linux-foundation.org>

On Thu, Sep 28, 2023 at 09:20:52AM -0700, Andrew Morton wrote:
> On Thu, 28 Sep 2023 16:44:00 +0800 Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
> 
> > But please pick the following patch[1] as well, which fixes failures of 
> > xfs55[0-2] cases.
> > 
> > [1] 
> > https://lore.kernel.org/linux-xfs/20230913102942.601271-1-ruansy.fnst@fujitsu.com
> 
> I guess I can take that xfs patch, as it fixes a DAX patch.  I hope the xfs team
> are watching.
> 
> But
> 
> a) I'm not subscribed to linux-xfs and
> 
> b) the changelog fails to describe the userspace-visible effects of
>    the bug, so I (and others) are unable to determine which kernel
>    versions should be patched.
> 
> Please update that changelog and resend?

That's a purely xfs patch anyways.  The correct maintainer is Chandan,
not Andrew.

/me notes that post-reorg, patch authors need to ask the release manager
(Chandan) directly to merge their patches after they've gone through
review.  Pull requests of signed tags are encouraged strongly.

Shiyang, could you please send Chandan pull requests with /all/ the
relevant pmem patches incorporated?  I think that's one PR for the
"xfs: correct calculation for agend and blockcount" for 6.6; and a
second PR with all the non-bugfix stuff (PRE_REMOVE and whatnot) for
6.7.

--D
