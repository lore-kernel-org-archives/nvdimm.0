Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E022C82
	for <nvdimm@lists.linux.dev>; Tue,  1 Feb 2022 15:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643728651; x=1675264651;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=tIGpzUyBPxdI3loQTBtXN9Wxy9wBUXW3CNk5G5rWMs0=;
  b=RJZG/BL3SiLx2VIFRRpXK2BD1MlY32lmMJ7ToJHjs07vJb5SnghpqexO
   xQpV4veBW2+ZQK6YcWblxwYRQZvS8CvoV0upJ6yD53sMQIQDgi8hQecRC
   OjvcwfoGLUQHHRcS4DJ2pPEqfGmvukIGvijLsby3OBD/vYVty2qP5a0NN
   dKp/z0YU2hkjiuqg/SasQG6VpLiIvDqK6EIaCWJ9APvqza/FBL+zxaXVb
   kDpsaBE/7MnxTln9tJtoUmFZXk4WsmslUoeokc6d7ISKx6vcqqWKAfOFj
   wwZFAIcYL+gL3jvu2HJcSSj12n0UA69yJShefp0iHmdmHbn8eMlq6PyVi
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10244"; a="247481304"
X-IronPort-AV: E=Sophos;i="5.88,334,1635231600"; 
   d="scan'208";a="247481304"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2022 07:17:30 -0800
X-IronPort-AV: E=Sophos;i="5.88,334,1635231600"; 
   d="scan'208";a="676109537"
Received: from rashmigh-mobl.amr.corp.intel.com (HELO intel.com) ([10.252.132.8])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2022 07:17:30 -0800
Date: Tue, 1 Feb 2022 07:17:28 -0800
From: Ben Widawsky <ben.widawsky@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-cxl@vger.kernel.org, linux-pci@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [PATCH v3 25/40] cxl/core/port: Remove @host argument for dport
 + decoder enumeration
Message-ID: <20220201151728.zgc55ckks672gedz@intel.com>
References: <164298411792.3018233.7493009997525360044.stgit@dwillia2-desk3.amr.corp.intel.com>
 <164298425201.3018233.647136583483232467.stgit@dwillia2-desk3.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164298425201.3018233.647136583483232467.stgit@dwillia2-desk3.amr.corp.intel.com>

On 22-01-23 16:30:52, Dan Williams wrote:
> Now that dport and decoder enumeration is centralized in the port
> driver, the @host argument for these helpers can be made implicit. For
> the root port the host is the port's uport device (ACPI0017 for
> cxl_acpi), and for all other descendant ports the devm context is the
> parent of @port.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

I really like removing @host as much as possible everywhere.
Reviewed-by: Ben Widawsky <ben.widawsky@intel.com>

[snip]

