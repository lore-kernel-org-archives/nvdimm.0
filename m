Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D9E4E298
	for <nvdimm@lists.linux.dev>; Thu, 28 Sep 2023 16:20:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72C70C433C7;
	Thu, 28 Sep 2023 16:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1695918053;
	bh=b8KrCK0soT7X2GAuI5kG6h0cUleOYImq7T8FFAo8dDs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=WQW+wqWouOGXss62UTQNcFimygb7b/vRWrl4U6dEdCCxNus1A48Dq+Y3W4KSrsAWe
	 Zq9kI5k6ugqUhTRV1yUtgoABtZwp0q9Vod9FBt6N4c7oUq740H4u0FIpA1vdutB7GF
	 Gh7/sxrzlEGmokHruiOE0SxnBD2fkOujhNUnvDIE=
Date: Thu, 28 Sep 2023 09:20:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: Chandan Babu R <chandanbabu@kernel.org>, "Darrick J. Wong"
 <djwong@kernel.org>, Dave Chinner <david@fromorbit.com>,
 linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev, dan.j.williams@intel.com
Subject: Re: [PATCH] xfs: drop experimental warning for FSDAX
Message-Id: <20230928092052.9775e59262c102dc382513ef@linux-foundation.org>
In-Reply-To: <9c3cbc0c-7135-4006-ad4a-2abce0a556b0@fujitsu.com>
References: <20230915063854.1784918-1-ruansy.fnst@fujitsu.com>
	<86167409-aa7f-4db4-8335-3f290d507f14@fujitsu.com>
	<20230926145519.GE11439@frogsfrogsfrogs>
	<ZROC8hEabAGS7orb@dread.disaster.area>
	<20230927014632.GE11456@frogsfrogsfrogs>
	<87fs306zs1.fsf@debian-BULLSEYE-live-builder-AMD64>
	<5c064cbd-13a3-4d55-9881-0a079476d865@fujitsu.com>
	<bc29af15-ae63-407d-8ca0-186c976acce7@fujitsu.com>
	<87y1gs83yq.fsf@debian-BULLSEYE-live-builder-AMD64>
	<20230927083034.90bd6336229dd00af601e0ef@linux-foundation.org>
	<9c3cbc0c-7135-4006-ad4a-2abce0a556b0@fujitsu.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 28 Sep 2023 16:44:00 +0800 Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:

> But please pick the following patch[1] as well, which fixes failures of 
> xfs55[0-2] cases.
> 
> [1] 
> https://lore.kernel.org/linux-xfs/20230913102942.601271-1-ruansy.fnst@fujitsu.com

I guess I can take that xfs patch, as it fixes a DAX patch.  I hope the xfs team
are watching.

But

a) I'm not subscribed to linux-xfs and

b) the changelog fails to describe the userspace-visible effects of
   the bug, so I (and others) are unable to determine which kernel
   versions should be patched.

Please update that changelog and resend?
