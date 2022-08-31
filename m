Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51CA72580
	for <nvdimm@lists.linux.dev>; Wed, 31 Aug 2022 13:18:13 +0000 (UTC)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4MHl2q442yz4x1D;
	Wed, 31 Aug 2022 23:12:35 +1000 (AEST)
From: Michael Ellerman <patch-notifications@ellerman.id.au>
To: mpe@ellerman.id.au, Kajol Jain <kjain@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org, vaibhav@linux.ibm.com
Cc: atrajeev@linux.vnet.ibm.com, nvdimm@lists.linux.dev, dan.j.williams@intel.com, disgoel@linux.vnet.ibm.com, aneesh.kumar@linux.ibm.com, maddy@linux.ibm.com, rnsastry@linux.ibm.com
In-Reply-To: <20220804074852.55157-1-kjain@linux.ibm.com>
References: <20220804074852.55157-1-kjain@linux.ibm.com>
Subject: Re: [PATCH v3] powerpc/papr_scm: Fix nvdimm event mappings
Message-Id: <166195152081.42804.8091615195567843266.b4-ty@ellerman.id.au>
Date: Wed, 31 Aug 2022 23:12:00 +1000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 4 Aug 2022 13:18:52 +0530, Kajol Jain wrote:
> Commit 4c08d4bbc089 ("powerpc/papr_scm: Add perf interface support")
> added performance monitoring support for papr-scm nvdimm devices via
> perf interface. Commit also added an array in papr_scm_priv
> structure called "nvdimm_events_map", which got filled based on the
> result of H_SCM_PERFORMANCE_STATS hcall.
> 
> Currently there is an assumption that the order of events in the
> stats buffer, returned by the hypervisor is same. And order also
> happens to matches with the events specified in nvdimm driver code.
> But this assumption is not documented in Power Architecture
> Platform Requirements (PAPR) document. Although the order
> of events happens to be same on current generation od system, but
> it might not be true in future generation systems. Fix the issue, by
> adding a static mapping for nvdimm events to corresponding stat-id,
> and removing the dynamic map from papr_scm_priv structure. Also
> remove the function papr_scm_pmu_check_events from papr_scm.c file,
> as we no longer need to copy stat-ids dynamically.
> 
> [...]

Applied to powerpc/fixes.

[1/1] powerpc/papr_scm: Fix nvdimm event mappings
      https://git.kernel.org/powerpc/c/9b1ac04698a4bfec146322502cdcd9904c1777fa

cheers
