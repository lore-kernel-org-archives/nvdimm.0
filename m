Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39502C82
	for <nvdimm@lists.linux.dev>; Tue,  1 Feb 2022 15:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643728264; x=1675264264;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NdLePjmH/RJmxdRZVM8XpVi1qx4upTKlYfI9sEoHNeA=;
  b=SK74whqe2tA/dNqxocRczY4lNdNLofKpCpqgpvogvx1hYpidHhX0hy0V
   w7Sy9bTzwEqmO4rtfniBS1wg2X4acLPntIvAvL3gfG0QO9idzU3KqFaVM
   Up8wSo5qIxjMWHZaSHem6qCcfVKG4b32/SR+VnnELTqWJawE0Ds50R9xv
   CTH9O0vSBiAD09PJLlTr5CxoT5n20yBbG3vZggc7i9hHvxSc/E2/uCSGO
   X5RvDQ5nfFZeQnsf6C2MXevnNs9NBqPAQNlplIm0exGaXIXOWMADCWoox
   s8RsPXjhdLkT+8YVnqZewTXIVZCgHEPjEWa2d0R4Zn4v14jbzE5GcFHXX
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10244"; a="272187998"
X-IronPort-AV: E=Sophos;i="5.88,334,1635231600"; 
   d="scan'208";a="272187998"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2022 07:11:03 -0800
X-IronPort-AV: E=Sophos;i="5.88,334,1635231600"; 
   d="scan'208";a="537842390"
Received: from rashmigh-mobl.amr.corp.intel.com (HELO intel.com) ([10.252.132.8])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2022 07:11:03 -0800
Date: Tue, 1 Feb 2022 07:11:02 -0800
From: Ben Widawsky <ben.widawsky@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-cxl@vger.kernel.org, linux-pci@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [PATCH v3 23/40] cxl/core: Emit modalias for CXL devices
Message-ID: <20220201151102.czrykjrqdb6vddzk@intel.com>
References: <164298411792.3018233.7493009997525360044.stgit@dwillia2-desk3.amr.corp.intel.com>
 <164298424120.3018233.15611905873808708542.stgit@dwillia2-desk3.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164298424120.3018233.15611905873808708542.stgit@dwillia2-desk3.amr.corp.intel.com>

On 22-01-23 16:30:41, Dan Williams wrote:
> In order to enable libkmod lookups for CXL device objects to their
> corresponding module, add 'modalias' to the base attribute of CXL
> devices.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Ben Widawsky <ben.widawsky@intel.com>

[snip]
