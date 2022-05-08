Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77A27E
	for <nvdimm@lists.linux.dev>; Sun,  8 May 2022 11:11:43 +0000 (UTC)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4Kx1pG2YxMz4ySy;
	Sun,  8 May 2022 21:11:34 +1000 (AEST)
From: Michael Ellerman <patch-notifications@ellerman.id.au>
To: Kajol Jain <kjain@linux.ibm.com>, mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org, dan.j.williams@intel.com, vaibhav@linux.ibm.com
Cc: nvdimm@lists.linux.dev, disgoel@linux.vnet.ibm.com, rnsastry@linux.ibm.com, maddy@linux.ibm.com, atrajeev@linux.vnet.ibm.com
In-Reply-To: <20220505153451.35503-1-kjain@linux.ibm.com>
References: <20220505153451.35503-1-kjain@linux.ibm.com>
Subject: Re: [PATCH] powerpc/papr_scm: Fix buffer overflow issue with CONFIG_FORTIFY_SOURCE
Message-Id: <165200827583.2672957.6785823772634051694.b4-ty@ellerman.id.au>
Date: Sun, 08 May 2022 21:11:15 +1000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 5 May 2022 21:04:51 +0530, Kajol Jain wrote:
> With CONFIG_FORTIFY_SOURCE enabled, string functions will also perform
> dynamic checks for string size which can panic the kernel,
> like incase of overflow detection.
> 
> In papr_scm, papr_scm_pmu_check_events function uses stat->stat_id
> with string operations, to populate the nvdimm_events_map array.
> Since stat_id variable is not NULL terminated, the kernel panics
> with CONFIG_FORTIFY_SOURCE enabled at boot time.
> 
> [...]

Applied to powerpc/fixes.

[1/1] powerpc/papr_scm: Fix buffer overflow issue with CONFIG_FORTIFY_SOURCE
      https://git.kernel.org/powerpc/c/348c71344111d7a48892e3e52264ff11956fc196

cheers
