Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=128.30.2.78
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795765540;
	b=p+MORCbkMelNH/uhscUcw6S7tqtI/QRll8Fw7IiN0oZZOQLq8QnfqqMPw/D5qTgYmSj2
	 IbQJv3mzZIKzbK+lS7NgUPcUKLHl8mNK+9hPEwLU8l/mxZ5RG4PuUAPVhy9bAdJSOIqiL
	 2H+DUOkyrzEbc4tPIqDvTFi6yK0dMiIpKnjcUm6IaY9+4UpO0sMfeWu57qkm4l57YC7XY
	 OGB69upiI/whMuoQWiR28uFPscPsWpQwFUjuZawcBZMq+P4hza06tSLQCv2VfiHWdO0xI
	 XVZezfOfy33GFw2Elu5049whtPHJVmxpFi9yc4hD9FL6r1ALIwScpcMUPQ2YvpPyhrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795765540;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=kWtt4J80wKcGIrTczzzJ5vqcfxic++6ySZn4Y5POe30=;
	b=wRtoraSJTO9IyJr6wgFW69RB80JsSjIyGMncqRgCDYMZrVxxk5RDJ8OAXY6wenGZFUUO
	 MIs5rglwl7hR1TVoCzasq/hF7XNmodbKgZ7Cw/t4fY8onoGVn8iTGiQKqBlwEDM7ekZDA
	 SVCVUvC/pNC952N96hYkOWoad5P1jMy6vK2ZUpvbMi4P3I9RKcgUO1PrzCoZvnsdizP2D
	 Vfto+ULy8YQ1NXlz/UaeS8JP9GA/1wg8bpdQshYitXseyVphpS70jnvATwkwCGBFdsCbC
	 vcRtOceqHV3zJ6wZWk/yxbgWztEJ5OyjkqnMW8Bs0c+EsDT7yAkOA50rL0fvvvD5Yuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=csail.mit.edu;
	spf=pass smtp.mailfrom=csail.mit.edu;
	dkim=pass header.d=outgoing.csail.mit.edu header.i=@outgoing.csail.mit.edu header.a=rsa-sha256 header.s=test20231205 header.b=rW+coxaA;
	arc=none smtp.remote-ip=128.30.2.78
Received: from outgoing2021.csail.mit.edu (outgoing2021.csail.mit.edu [128.30.2.78])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E7C606A335;
	Fri, 27 Nov 2026 07:45:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B1E7C606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=csail.mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csail.mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outgoing.csail.mit.edu header.i=@outgoing.csail.mit.edu header.a=rsa-sha256 header.s=test20231205 header.b=rW+coxaA
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=outgoing.csail.mit.edu; s=test20231205; h=In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=kWtt4J80wKcGIrTczzzJ5vqcfxic++6ySZn4Y5POe30=; t=1795765539; x=1796629539; 
	b=rW+coxaAqyAgOctwEfKT+T9LoJDJBBzwT95ctxNxdfPoZuG789bvRWwkFYtNGXDX6yUT+vI5REc
	12f3QZ9Ug2InByqRk+1hRm1wpsvZ+uf2jBN4Hh+SGPPubI/mu73u4a0rwPyo4CGlxxHef9sp93LW5
	iZzbtskred1eQN4k0jOabY54r5Qf5W4m0i53BWMzqSzCxmYAzvHPDjjdGgrhmlL+z3vbF6jGKZzAh
	tE1eMtq/wH2Ny40yDv2VsHTbFM3TmKqp4uWxQJxU5QGiqIb3H0K7xEdWR22TsvrtwrS+HLZpCGvCu
	S3u0SdeT2TXPnwt8yPB8UDiV6uwTA3xstdCQ==;
Received: from [167.220.238.14] (helo=csail.mit.edu)
	by outgoing2021.csail.mit.edu with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <srivatsa@csail.mit.edu>)
	id 1xWqdU-006z5N-OT;
	Fri, 27 Nov 2026 02:44:49 -0500
Date: Fri, 27 Nov 2026 13:14:17 +0530
From: "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
To: Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Jens Axboe <axboe@kernel.dk>, Chanwoo Choi <cw00.choi@samsung.com>,
	MyungJoo Ham <myungjoo.ham@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Heiko Stuebner <heiko@sntech.de>, Xu Yilun <yilun.xu@intel.com>,
	Tom Rix <trix@redhat.com>, Moritz Fischer <mdf@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Mike Leach <mike.leach@arm.com>,
	James Clark <james.clark@linaro.org>, Leo Yan <leo.yan@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Sizhe Liu <liusizhe5@huawei.com>,
	Robin Murphy <robin.murphy@arm.com>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>, Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>, Haren Myneni <haren@linux.ibm.com>,
	Rick Lindsley <ricklind@linux.ibm.com>,
	Nick Child <nnac123@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Marcin Wojtas <marcin.s.wojtas@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowangio@gmail.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Jing Zhang <renyu.zj@linux.alibaba.com>,
	Frank Li <Frank.li@nxp.com>, Xu Yang <xu.yang_2@nxp.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>,
	Yushan Wang <wangyushan12@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Gowthami Thiagarajan <gthiagarajan@marvell.com>,
	Geetha sowjanya <gakula@marvell.com>,
	Justin Tee <justin.tee@broadcom.com>,
	Paul Ely <paul.ely@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-pm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org, linux-fpga@vger.kernel.org,
	coresight@lists.linaro.org, iommu@lists.linux.dev,
	linux-raid@vger.kernel.org, netdev@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, virtualization@lists.linux.dev,
	nvdimm@lists.linux.dev, linux-perf-users@vger.kernel.org,
	linux-cxl@vger.kernel.org, imx@lists.linux.dev,
	linux-scsi@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>,
	Saurabh Sengar <ssengar@linux.microsoft.com>
Subject: Re: [PATCH] cpu/hotplug: Rename cpuhp_remove_multi_state to be
 symmetric with setup
Message-ID: <awk00RK93iRx3e3S@csail.mit.edu>
References: <20261127-fix-rename_cpuhp_remove_multi_state-v1-1-097db4564cbd@csail.mit.edu>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261127-fix-rename_cpuhp_remove_multi_state-v1-1-097db4564cbd@csail.mit.edu>

On Fri, Nov 27, 2026 at 01:07:40PM +0530, Srivatsa S. Bhat wrote:
> The multi-instance CPU hotplug state setup API is named as
> cpuhp_setup_state_multi(), whereas the corresponding remove API is
> currently named as cpuhp_remove_multi_state(). Rename the latter as
> cpuhp_remove_state_multi() to fix the asymmetry. This also helps
> maintain consistency in the API names by letting them share a common
> prefix, i.e., cpuhp_setup/remove_state_*() across all the variants
> [none|nocalls|nocalls_cpuslocked].
> 

I think the prefix in the patch title should have been "treewide:" instead of
"cpu/hotplug" given that it does a treewide-sweep to perform the rename.

I can do that in a v2 later if there are other any other comments/suggestions to
address as well.

Thank you!

>  Documentation/core-api/cpu_hotplug.rst       | 6 +++---
>  drivers/block/zram/zram_drv.c                | 6 +++---
>  drivers/devfreq/event/rockchip-dfi.c         | 2 +-
>  drivers/fpga/dfl-fme-perf.c                  | 4 ++--
>  drivers/hwtracing/coresight/coresight-trbe.c | 4 ++--
>  drivers/hwtracing/ptt/hisi_ptt.c             | 4 ++--
>  drivers/iommu/iova.c                         | 2 +-
>  drivers/md/raid5.c                           | 4 ++--
>  drivers/net/ethernet/ibm/ibmvnic.c           | 8 ++++----
>  drivers/net/ethernet/marvell/mvneta.c        | 8 ++++----
>  drivers/net/virtio_net.c                     | 8 ++++----
>  drivers/nvdimm/nd_perf.c                     | 6 +++---
>  drivers/perf/alibaba_uncore_drw_pmu.c        | 4 ++--
>  drivers/perf/arm-ccn.c                       | 4 ++--
>  drivers/perf/arm-cmn.c                       | 4 ++--
>  drivers/perf/arm-ni.c                        | 4 ++--
>  drivers/perf/arm_cspmu/arm_cspmu.c           | 2 +-
>  drivers/perf/arm_dmc620_pmu.c                | 4 ++--
>  drivers/perf/arm_dsu_pmu.c                   | 4 ++--
>  drivers/perf/arm_smmuv3_pmu.c                | 4 ++--
>  drivers/perf/arm_spe_pmu.c                   | 4 ++--
>  drivers/perf/cxl_pmu.c                       | 4 ++--
>  drivers/perf/dwc_pcie_pmu.c                  | 4 ++--
>  drivers/perf/fsl_imx8_ddr_perf.c             | 4 ++--
>  drivers/perf/fsl_imx9_ddr_perf.c             | 4 ++--
>  drivers/perf/fujitsu_uncore_pmu.c            | 4 ++--
>  drivers/perf/hisilicon/hisi_pcie_pmu.c       | 4 ++--
>  drivers/perf/hisilicon/hisi_uncore_l3c_pmu.c | 4 ++--
>  drivers/perf/hisilicon/hisi_uncore_pmu.c     | 2 +-
>  drivers/perf/hisilicon/hns3_pmu.c            | 4 ++--
>  drivers/perf/marvell_cn10k_ddr_pmu.c         | 4 ++--
>  drivers/perf/marvell_cn10k_tad_pmu.c         | 4 ++--
>  drivers/perf/marvell_pem_pmu.c               | 4 ++--
>  drivers/perf/nvidia_t410_c2c_pmu.c           | 2 +-
>  drivers/perf/nvidia_t410_cmem_latency_pmu.c  | 2 +-
>  drivers/perf/thunderx2_pmu.c                 | 4 ++--
>  drivers/scsi/lpfc/lpfc_init.c                | 4 ++--
>  include/linux/cpuhotplug.h                   | 4 ++--
>  kernel/padata.c                              | 2 +-
>  kernel/trace/trace.c                         | 2 +-
>  mm/zswap.c                                   | 2 +-
>  41 files changed, 82 insertions(+), 82 deletions(-)
> 

Regards,
Srivatsa
