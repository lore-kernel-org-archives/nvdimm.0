Received: from ozlabs.org (ozlabs.org [203.11.71.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18EEA177
	for <nvdimm@lists.linux.dev>; Sat, 26 Jun 2021 10:39:15 +0000 (UTC)
Received: by ozlabs.org (Postfix, from userid 1034)
	id 4GBr2g376Rz9srZ; Sat, 26 Jun 2021 20:39:07 +1000 (AEST)
From: Michael Ellerman <patch-notifications@ellerman.id.au>
To: Vaibhav Jain <vaibhav@linux.ibm.com>, linux-nvdimm@lists.01.org, linuxppc-dev@lists.ozlabs.org, nvdimm@lists.linux.dev
Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Santosh Sivaraj <santosh@fossix.org>, Ira Weiny <ira.weiny@intel.com>, Dan Williams <dan.j.williams@intel.com>
In-Reply-To: <20210624080621.252038-1-vaibhav@linux.ibm.com>
References: <20210624080621.252038-1-vaibhav@linux.ibm.com>
Subject: Re: [RESEND-PATCH v2] powerpc/papr_scm: Add support for reporting dirty-shutdown-count
Message-Id: <162470384292.3589875.8300920085497091770.b4-ty@ellerman.id.au>
Date: Sat, 26 Jun 2021 20:37:22 +1000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 24 Jun 2021 13:36:21 +0530, Vaibhav Jain wrote:
> Persistent memory devices like NVDIMMs can loose cached writes in case
> something prevents flush on power-fail. Such situations are termed as
> dirty shutdown and are exposed to applications as
> last-shutdown-state (LSS) flag and a dirty-shutdown-counter(DSC) as
> described at [1]. The latter being useful in conditions where multiple
> applications want to detect a dirty shutdown event without racing with
> one another.
> 
> [...]

Applied to powerpc/next.

[1/1] powerpc/papr_scm: Add support for reporting dirty-shutdown-count
      https://git.kernel.org/powerpc/c/de21e1377c4fe65bfd8d31e446482c1bc2232997

cheers
