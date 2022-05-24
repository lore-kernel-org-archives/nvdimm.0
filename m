Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA06E7C
	for <nvdimm@lists.linux.dev>; Tue, 24 May 2022 11:29:34 +0000 (UTC)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4L6s803mz0z4yTS;
	Tue, 24 May 2022 21:16:00 +1000 (AEST)
From: Michael Ellerman <patch-notifications@ellerman.id.au>
To: nvdimm@lists.linux.dev, Kajol Jain <kjain@linux.ibm.com>, Vaibhav Jain <vaibhav@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org
Cc: Shivaprasad G Bhat <sbhat@linux.ibm.com>, Ira Weiny <ira.weiny@intel.com>, Michael Ellerman <mpe@ellerman.id.au>, "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>, Dan Williams <dan.j.williams@intel.com>
In-Reply-To: <20220511082637.646714-1-vaibhav@linux.ibm.com>
References: <20220511082637.646714-1-vaibhav@linux.ibm.com>
Subject: Re: [PATCH v2] powerpc/papr_scm: Fix leaking nvdimm_events_map elements
Message-Id: <165339058556.1718562.12936352188808932969.b4-ty@ellerman.id.au>
Date: Tue, 24 May 2022 21:09:45 +1000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Wed, 11 May 2022 13:56:36 +0530, Vaibhav Jain wrote:
> Right now 'char *' elements allocated for individual 'stat_id' in
> 'papr_scm_priv.nvdimm_events_map[]' during papr_scm_pmu_check_events(), get
> leaked in papr_scm_remove() and papr_scm_pmu_register(),
> papr_scm_pmu_check_events() error paths.
> 
> Also individual 'stat_id' arent NULL terminated 'char *' instead they are fixed
> 8-byte sized identifiers. However papr_scm_pmu_register() assumes it to be a
> NULL terminated 'char *' and at other places it assumes it to be a
> 'papr_scm_perf_stat.stat_id' sized string which is 8-byes in size.
> 
> [...]

Applied to powerpc/next.

[1/1] powerpc/papr_scm: Fix leaking nvdimm_events_map elements
      https://git.kernel.org/powerpc/c/0e0946e22f3665d27325d389ff45ade6e93f3678

cheers
