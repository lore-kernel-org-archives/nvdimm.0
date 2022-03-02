Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278D32C9D
	for <nvdimm@lists.linux.dev>; Wed,  2 Mar 2022 12:57:52 +0000 (UTC)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4K7v592ptmz4xvc;
	Wed,  2 Mar 2022 23:46:53 +1100 (AEDT)
From: Michael Ellerman <patch-notifications@ellerman.id.au>
To: linuxppc-dev@lists.ozlabs.org, nvdimm@lists.linux.dev, Vaibhav Jain <vaibhav@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>, Dan Williams <dan.j.williams@intel.com>, Ira Weiny <ira.weiny@intel.com>, "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>, Shivaprasad G Bhat <sbhat@linux.ibm.com>
In-Reply-To: <20220124202204.1488346-1-vaibhav@linux.ibm.com>
References: <20220124202204.1488346-1-vaibhav@linux.ibm.com>
Subject: Re: [PATCH v4] powerpc/papr_scm: Implement initial support for injecting smart errors
Message-Id: <164622488229.2052779.17094749231331915996.b4-ty@ellerman.id.au>
Date: Wed, 02 Mar 2022 23:41:22 +1100
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 25 Jan 2022 01:52:04 +0530, Vaibhav Jain wrote:
> Presently PAPR doesn't support injecting smart errors on an
> NVDIMM. This makes testing the NVDIMM health reporting functionality
> difficult as simulating NVDIMM health related events need a hacked up
> qemu version.
> 
> To solve this problem this patch proposes simulating certain set of
> NVDIMM health related events in papr_scm. Specifically 'fatal' health
> state and 'dirty' shutdown state. These error can be injected via the
> user-space 'ndctl-inject-smart(1)' command. With the proposed patch and
> corresponding ndctl patches following command flow is expected:
> 
> [...]

Applied to powerpc/next.

[1/1] powerpc/papr_scm: Implement initial support for injecting smart errors
      https://git.kernel.org/powerpc/c/bbbca72352bb9484bc057c91a408332b35ee8f4c

cheers
