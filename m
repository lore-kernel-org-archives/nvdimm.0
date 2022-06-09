Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D53B2599
	for <nvdimm@lists.linux.dev>; Thu,  9 Jun 2022 14:45:36 +0000 (UTC)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4LJn2H6n0Jz4xZB;
	Fri, 10 Jun 2022 00:45:27 +1000 (AEST)
From: Michael Ellerman <patch-notifications@ellerman.id.au>
To: linuxppc-dev@lists.ozlabs.org, Vaibhav Jain <vaibhav@linux.ibm.com>, nvdimm@lists.linux.dev
Cc: Michael Ellerman <mpe@ellerman.id.au>, Dan Williams <dan.j.williams@intel.com>, "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>, Sachin Sant <sachinp@linux.ibm.com>, Shivaprasad G Bhat <sbhat@linux.ibm.com>
In-Reply-To: <20220524112353.1718454-1-vaibhav@linux.ibm.com>
References: <20220524112353.1718454-1-vaibhav@linux.ibm.com>
Subject: Re: [PATCH] powerpc/papr_scm: don't requests stats with '0' sized stats buffer
Message-Id: <165478587347.589231.8636928755378535882.b4-ty@ellerman.id.au>
Date: Fri, 10 Jun 2022 00:44:33 +1000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 24 May 2022 16:53:53 +0530, Vaibhav Jain wrote:
> Sachin reported [1] that on a POWER-10 lpar he is seeing a kernel panic being
> reported with vPMEM when papr_scm probe is being called. The panic is of the
> form below and is observed only with following option disabled(profile) for the
> said LPAR 'Enable Performance Information Collection' in the HMC:
> 
>  Kernel attempted to write user page (1c) - exploit attempt? (uid: 0)
>  BUG: Kernel NULL pointer dereference on write at 0x0000001c
>  Faulting instruction address: 0xc008000001b90844
>  Oops: Kernel access of bad area, sig: 11 [#1]
> <snip>
>  NIP [c008000001b90844] drc_pmem_query_stats+0x5c/0x270 [papr_scm]
>  LR [c008000001b92794] papr_scm_probe+0x2ac/0x6ec [papr_scm]
>  Call Trace:
>        0xc00000000941bca0 (unreliable)
>        papr_scm_probe+0x2ac/0x6ec [papr_scm]
>        platform_probe+0x98/0x150
>        really_probe+0xfc/0x510
>        __driver_probe_device+0x17c/0x230
> <snip>
>  ---[ end trace 0000000000000000 ]---
>  Kernel panic - not syncing: Fatal exception
> 
> [...]

Applied to powerpc/fixes.

[1/1] powerpc/papr_scm: don't requests stats with '0' sized stats buffer
      https://git.kernel.org/powerpc/c/07bf9431b1590d1cd7a8d62075d0b50b073f0495

cheers
