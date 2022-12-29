Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3853CED1
	for <nvdimm@lists.linux.dev>; Thu, 29 Dec 2022 07:02:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D0DCC433D2;
	Thu, 29 Dec 2022 07:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1672297369;
	bh=ZuXJhWxTiKK7rNV5+l64eAbjpD7WZx3v0R5AYbUoqOY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=msZEjdMQFLp6RpIcuVr6Z/h76NOyUxXFChn2R69b9AQdizE2lkG5d+sozkDgu8Ngo
	 CmuMZ1CP0rWTOxLhijuvMv+mao7wspAlchrjQyCV5JpnJzhw5tZT7RpFKZNmanK39l
	 Ze1vflbh2xldEE1sjXV5mv9+Mn3ljI6ii7W5vNcALSb1x+BBJuS8StH/IK1SSPrlb7
	 cDM9Ak9AWGQwoIucVJsVU/j1IymNIAfXfTnsWy1tl+5j33q2PjtTX/l1wVttrm2Wtg
	 z/76m+thVJWXiKN8riGAHG61W7o4Q9nrtdvi9F+qSb9XoX6EM7SCws3tUiWmXg+Oyv
	 z0n9v0hc5AS9w==
Date: Thu, 29 Dec 2022 09:02:45 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Bob Pearson <rpearsonhpe@gmail.com>
Cc: Daisuke Matsuda <matsuda-daisuke@fujitsu.com>,
	linux-rdma@vger.kernel.org, jgg@nvidia.com, zyjzyj2000@gmail.com,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	yangx.jy@fujitsu.com, lizhijian@fujitsu.com, y-goto@fujitsu.com
Subject: Re: [PATCH for-next v3 1/7] RDMA/rxe: Convert triple tasklets to use
 workqueue
Message-ID: <Y607lVbzs9PTd0m+@unreal>
References: <cover.1671772917.git.matsuda-daisuke@fujitsu.com>
 <d2f6b3aca61fe1858a97cda94691eece6b0e60bd.1671772917.git.matsuda-daisuke@fujitsu.com>
 <53a2fca7-d98a-acef-8b18-d36a5a16d176@gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53a2fca7-d98a-acef-8b18-d36a5a16d176@gmail.com>

On Wed, Dec 28, 2022 at 10:56:11AM -0600, Bob Pearson wrote:
> On 12/23/22 00:51, Daisuke Matsuda wrote:
> > In order to implement On-Demand Paging on the rxe driver, triple tasklets
> > (requester, responder, and completer) must be allowed to sleep so that they
> > can trigger page fault when pages being accessed are not present.
> > 
> > This patch replaces the tasklets with a workqueue, but still allows direct-
> > call of works from softirq context if it is obvious that MRs are not going
> > to be accessed and there is no work being processed in the workqueue.
> 
> There are already at least two patch sets that do this waiting to get upstream

I don't see any unhandled RXE series, except of this one patch [1],
which is one out larger series.

[1] https://patchwork.kernel.org/project/linux-rdma/patch/20221029031331.64518-1-rpearsonhpe@gmail.com/

> Bob
