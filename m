Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB249D51B
	for <nvdimm@lists.linux.dev>; Wed, 16 Nov 2022 18:05:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22C05C433C1;
	Wed, 16 Nov 2022 18:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1668621932;
	bh=aJc/RNCjdqIzYrdw+eDY3vzELD9uFjLi6tK/L9ffeQw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GAyjSmREjjzX6y2oAi1pJ1KCCOWUJXE74t8/5KG+gFInhMM1xXZSbvuhACZArFuLI
	 P2tI9IbkgKSqoMimhneAx+OMS1vtbJn28ym5MNUL3WvA4gEKaxHcxwwliyQjr0yXPg
	 ZWuBC57V3JOvW5/mAfvtIQSSf/cq0RooAsiU5AlFC/2/X1DEZRNyk4F9025j9ilwe0
	 k+T5QG6xyqZ04S1khkohc9kioI84MXfzaX6X07umC5XRzJ4a6O3/UE+CB3MMzkYiZ+
	 Bq1vvIGdKBnvjIGElfuKkgK0EdNOEDGMalj/sy4aehlLbWm8zSl1oEoGOI6Ghx4xhm
	 3aRkmb6Pm+pPg==
Date: Wed, 16 Nov 2022 20:05:28 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Daisuke Matsuda <matsuda-daisuke@fujitsu.com>
Cc: linux-rdma@vger.kernel.org, jgg@nvidia.com, zyjzyj2000@gmail.com,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	rpearsonhpe@gmail.com, yangx.jy@fujitsu.com, lizhijian@fujitsu.com,
	y-goto@fujitsu.com
Subject: Re: [RFC PATCH v2 0/7] On-Demand Paging on SoftRoCE
Message-ID: <Y3UmaJil5slosqjA@unreal>
References: <cover.1668157436.git.matsuda-daisuke@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1668157436.git.matsuda-daisuke@fujitsu.com>

On Fri, Nov 11, 2022 at 06:22:21PM +0900, Daisuke Matsuda wrote:
> This patch series implements the On-Demand Paging feature on SoftRoCE(rxe)
> driver, which has been available only in mlx5 driver[1] so far.

<...>

> Daisuke Matsuda (7):
>   IB/mlx5: Change ib_umem_odp_map_dma_single_page() to retain umem_mutex
>   RDMA/rxe: Convert the triple tasklets to workqueues
>   RDMA/rxe: Cleanup code for responder Atomic operations
>   RDMA/rxe: Add page invalidation support
>   RDMA/rxe: Allow registering MRs for On-Demand Paging
>   RDMA/rxe: Add support for Send/Recv/Write/Read operations with ODP
>   RDMA/rxe: Add support for the traditional Atomic operations with ODP

It is a shame that such cool feature is not progressing.
RXE folks, can you please review it?

Thanks
