Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971FF2C9C
	for <nvdimm@lists.linux.dev>; Tue, 18 Jan 2022 17:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642528768; x=1674064768;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=CRtIESfBEA71HQ0JS1NDcLZUx6UJPI9YfbeDGWxPrcU=;
  b=Icqm+hdYIkJzO+DEJtWu4p20DBQwVQ2yhAQRevGHBIZj+g2vWt+2wHut
   ioUFqqGlrMnyXsc2wq4FkbBlZs0tVePY3KM0DGElWCgPNRbMYxosxBPsZ
   2spXTWgMShkKzqC9C42/fumqv9NwM9U1PAi+9sLnByfCnU6JPMo+b67fH
   xsdIDwh0QSlX0hpbUlVUi0LueDGhOny9FguDRBRDWKu1VsX3pEYZ+pIA1
   8Rji4bVcJE4UpJQ/TZ3XtOpAPihGqkTuepfbs13he+wmCRORWCssRjMDa
   WW+GtxMfhdAySsIJJK8vPe64V1frQM9+5G5kG4xhoWoDDWug+xWSDkxRz
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10230"; a="225553262"
X-IronPort-AV: E=Sophos;i="5.88,297,1635231600"; 
   d="scan'208";a="225553262"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2022 09:59:27 -0800
X-IronPort-AV: E=Sophos;i="5.88,297,1635231600"; 
   d="scan'208";a="625588407"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2022 09:59:16 -0800
Date: Tue, 18 Jan 2022 09:59:15 -0800
From: Ira Weiny <ira.weiny@intel.com>
To: Vaibhav Jain <vaibhav@linux.ibm.com>
Cc: nvdimm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
	Dan Williams <dan.j.williams@intel.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Shivaprasad G Bhat <sbhat@linux.ibm.com>
Subject: Re: [PATCH v3] powerpc/papr_scm: Implement initial support for
 injecting smart errors
Message-ID: <20220118175915.GB209936@iweiny-DESK2.sc.intel.com>
Mail-Followup-To: Vaibhav Jain <vaibhav@linux.ibm.com>,
	nvdimm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
	Dan Williams <dan.j.williams@intel.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Shivaprasad G Bhat <sbhat@linux.ibm.com>
References: <20220113120252.1145671-1-vaibhav@linux.ibm.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220113120252.1145671-1-vaibhav@linux.ibm.com>
User-Agent: Mutt/1.11.1 (2018-12-01)

On Thu, Jan 13, 2022 at 05:32:52PM +0530, Vaibhav Jain wrote:
[snip]

>  
> +/* Inject a smart error Add the dirty-shutdown-counter value to the pdsm */
> +static int papr_pdsm_smart_inject(struct papr_scm_priv *p,
> +				  union nd_pdsm_payload *payload)
> +{
> +	int rc;
> +	u32 supported_flags = 0;
> +	u64 mask = 0, override = 0;
> +
> +	/* Check for individual smart error flags and update mask and override */
> +	if (payload->smart_inject.flags & PDSM_SMART_INJECT_HEALTH_FATAL) {
> +		supported_flags |= PDSM_SMART_INJECT_HEALTH_FATAL;
> +		mask |= PAPR_PMEM_HEALTH_FATAL;
> +		override |= payload->smart_inject.fatal_enable ?
> +			PAPR_PMEM_HEALTH_FATAL : 0;
> +	}
> +
> +	if (payload->smart_inject.flags & PDSM_SMART_INJECT_BAD_SHUTDOWN) {
> +		supported_flags |= PDSM_SMART_INJECT_BAD_SHUTDOWN;
> +		mask |= PAPR_PMEM_SHUTDOWN_DIRTY;
> +		override |= payload->smart_inject.unsafe_shutdown_enable ?
> +			PAPR_PMEM_SHUTDOWN_DIRTY : 0;
> +	}
> +

I'm struggling to see why there is a need for both a flag and an 8 bit 'enable'
value?

Ira
