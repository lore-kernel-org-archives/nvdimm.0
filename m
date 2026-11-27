Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=128.30.2.78
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795769464;
	b=3vmcZn7Jpe8VKDy7Ay8xuQmiIfOAl6kZO6UQuc3+Pyo8jGm7v/fRuMDD9Xj/oHJvxrv8
	 cLXJLtNXdAyK6fjz+6gB8eSEiGpNUBlW2Z/6EBFinZ9Cv9UgOO+ooPc66TPrCEOd4HCAc
	 fcz2KGuvH2bc1uqsRa5mNaonMTDmkECgosdmoIvDauL4pha6Lrj1Kb7V4fgihrUjcvdF8
	 h6Lm/v+YvEU6Qspd1dxzgd9S0IQtadoVKQsRQ00LuruHWhvQaWClHmyMDOlWbnjeIsEqB
	 sZ8KJ47GhtgYshTDfyKNDQj9Qimm2MFc7vaUJ1rKpr7BVFRLY98aqw9Zho1BIAlWjzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795769464;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=njh3SQBBAQE61UxliWgOlIeTiJ2q96ejV3+knyCCvnY=;
	b=d1DXSzToQ+NSWw3JPfbbCrAQhkNYUaW9zaQ0Kq36JP/8woKgKUTQgShqaZ81EMafXCG8
	 DiMpPZ97OccqrKo7UFt334tkVjALPM2IZ1xomiHQXsloYBKIPjRZgTPZkfTXEgIuMKm9Q
	 b7sz4NZ/jrYEC4SK/QralyrpABcEM3c4IqS4+t1BQJ4t0IGFt36KPGh/71hEPyzFmrovC
	 nxc+Wj+vndn+a79SArUDt7iPLwuEgjZVc4EU2LwUiuG5EFKMkjzbdHTWlbJk9g5Ghhk3i
	 +gyaUSwMT4DyVt4FMfzdvMPL6rGzFmLXNPqHEwk7ssXWB+RiqyGc5V3rVm/N0hQbEkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=csail.mit.edu;
	spf=pass smtp.mailfrom=csail.mit.edu;
	dkim=pass header.d=outgoing.csail.mit.edu header.i=@outgoing.csail.mit.edu header.a=rsa-sha256 header.s=test20231205 header.b=xCF78GQE;
	arc=none smtp.remote-ip=128.30.2.78
Received: from outgoing2021.csail.mit.edu (outgoing2021.csail.mit.edu [128.30.2.78])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48CD4606A31C;
	Fri, 27 Nov 2026 08:51:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 48CD4606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=csail.mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csail.mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outgoing.csail.mit.edu header.i=@outgoing.csail.mit.edu header.a=rsa-sha256 header.s=test20231205 header.b=xCF78GQE
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=outgoing.csail.mit.edu; s=test20231205; h=In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=njh3SQBBAQE61UxliWgOlIeTiJ2q96ejV3+knyCCvnY=; t=1795769464; x=1796633464; 
	b=xCF78GQEoFuR5VSaFZJwsaQMsUqzxgkhr09s1AQlGBjs9gBHC90OExhT7yjx4EsH4WivLTHbGpI
	p1E/a5+X4T4RCZDkcyYHblwO39qcnCS/jX+2rUBbwS1mQZgFvoM/x2kdWTDEyGuqBWjJm6feGtK2Z
	wFpefSVLt7txJoZA0iIqI5jyU1zgPndu9WsOj6WeNxR3WovhoLSiXmJUNYFRfVro1Za1MGilJ19PW
	Hz4feHPtbiuyFMlqUrY+NSp8E4S+LNWmiuwiqTCvoNSDozbzEFxQ7prI17GmZtzkMkrajaIxy6L5f
	r/0Om6ynlQj5DoUoMwLx+tY8sfilr31FNhtg==;
Received: from [167.220.238.14] (helo=csail.mit.edu)
	by outgoing2021.csail.mit.edu with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <srivatsa@csail.mit.edu>)
	id 1xWreR-007Btx-5B;
	Fri, 27 Nov 2026 03:49:51 -0500
Date: Fri, 27 Nov 2026 14:19:20 +0530
From: "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
To: Richard Cheng <icheng@nvidia.com>
Cc: Jonathan Corbet <corbet@lwn.net>,
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
	Andrew Morton <akpm@linux-foundation.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
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
Message-ID: <awlEEAmT4k7fvQck@csail.mit.edu>
References: <20261127-fix-rename_cpuhp_remove_multi_state-v1-1-097db4564cbd@csail.mit.edu>
 <awk6TGp9riwDD55i@MWDK4CY14F>
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
In-Reply-To: <awk6TGp9riwDD55i@MWDK4CY14F>

Hi Richard,

On Fri, Nov 27, 2026 at 04:09:11PM +0800, Richard Cheng wrote:
> On Fri, Nov 27, 2026 at 01:07:40PM +0800, Srivatsa S. Bhat (Microsoft) wrote:
> > The multi-instance CPU hotplug state setup API is named as
> > cpuhp_setup_state_multi(), whereas the corresponding remove API is
> > currently named as cpuhp_remove_multi_state(). Rename the latter as
> > cpuhp_remove_state_multi() to fix the asymmetry. This also helps
> > maintain consistency in the API names by letting them share a common
> > prefix, i.e., cpuhp_setup/remove_state_*() across all the variants
> > [none|nocalls|nocalls_cpuslocked].
> > 
> > Signed-off-by: Srivatsa S. Bhat (Microsoft) <srivatsa@csail.mit.edu>
> 
> Hi Srivatsa,
> 
> Not sure whether this is really needed, it doesn't harm anything,
> but IMHO it doesn't really brings us benefit.
> 

I agree, this is not intended to be a functional change. The cleanup benefit is
on the side of the CPU hotplug core API to provide better consistency in terms
of the API naming pattern, but the current callsites that consume this API
should see no functional difference as a result of this change. The consistency
will help future callsites though!

Regards,
Srivatsa
