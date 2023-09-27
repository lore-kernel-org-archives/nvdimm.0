Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDEE9636
	for <nvdimm@lists.linux.dev>; Wed, 27 Sep 2023 01:46:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FA5CC433C8;
	Wed, 27 Sep 2023 01:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1695779193;
	bh=b5QrceYdkL6ZihdQ5KD7hRb1xN3D6/oep/RhSmItCy8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ssZH4PoTtQoyBUXskV9uyDwBkAweq5N1rOHW6QQp3EvQ/XPOw4jdX+77RgVbZqMCY
	 9DY+ZfQTMDbUwdHUw/4HNiCzJIlw7D0K41UBtzoT2mYdO/AzqT9vZaGYZNsqjFi4kl
	 j+fT+GpJVW60N1ve4DTWxl/R0pnXpsQ5ZPKLNwz+n3cC83Uk85sucQLY1VAzbGytmd
	 3uj8ZYbQs2bJaT/Dqz+AVobLfEF/yv7+jzcTPX0uOPBVd61JMIxeovbC+506HmSFQa
	 GXLgRaPydK+sbUqWSTigWskbzvcMEdj6phxIcPnC1o1Zcrc+DV4imELY3tlCgvEo0W
	 asRV9cXwzYQgQ==
Date: Tue, 26 Sep 2023 18:46:32 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, chandan.babu@oracle.com,
	dan.j.williams@intel.com
Subject: Re: [PATCH] xfs: drop experimental warning for FSDAX
Message-ID: <20230927014632.GE11456@frogsfrogsfrogs>
References: <20230915063854.1784918-1-ruansy.fnst@fujitsu.com>
 <86167409-aa7f-4db4-8335-3f290d507f14@fujitsu.com>
 <20230926145519.GE11439@frogsfrogsfrogs>
 <ZROC8hEabAGS7orb@dread.disaster.area>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZROC8hEabAGS7orb@dread.disaster.area>

On Wed, Sep 27, 2023 at 11:18:42AM +1000, Dave Chinner wrote:
> On Tue, Sep 26, 2023 at 07:55:19AM -0700, Darrick J. Wong wrote:
> > On Thu, Sep 21, 2023 at 04:33:04PM +0800, Shiyang Ruan wrote:
> > > Hi,
> > > 
> > > Any comments?
> > 
> > I notice that xfs/55[0-2] still fail on my fakepmem machine:
> > 
> > --- /tmp/fstests/tests/xfs/550.out	2023-09-23 09:40:47.839521305 -0700
> > +++ /var/tmp/fstests/xfs/550.out.bad	2023-09-24 20:00:23.400000000 -0700
> > @@ -3,7 +3,6 @@ Format and mount
> >  Create the original files
> >  Inject memory failure (1 page)
> >  Inject poison...
> > -Process is killed by signal: 7
> >  Inject memory failure (2 pages)
> >  Inject poison...
> > -Process is killed by signal: 7
> > +Memory failure didn't kill the process
> > 
> > (yes, rmap is enabled)
> 
> Yes, I see the same failures, too. I've just been ignoring them
> because I thought that all the memory failure code was still not
> complete....

Oh, I bet we were supposed to have merged this

https://lore.kernel.org/linux-xfs/20230828065744.1446462-1-ruansy.fnst@fujitsu.com/

to complete the pmem media failure handling code.  Should we (by which I
mostly mean Shiyang) ask Chandan to merge these two patches for 6.7?

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
