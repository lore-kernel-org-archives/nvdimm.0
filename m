Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272293FE3
	for <nvdimm@lists.linux.dev>; Mon, 31 Jan 2022 22:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643668487; x=1675204487;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kQ4KxMmJablIpkLr13hEY7eq2UJchis/VYe9JDslcWA=;
  b=eWKSBi6e3ru/FhtL/ORZ8VUe2hNp7c+oKwN9v1rIxCYyWiq/2l+ft4T0
   BJIADs54OCaRUN78VtJIMJIeYxFvZXCixJpIs5mMG8imoZQozRQkonZtx
   5ghsnJyQZOeIRZp6+JFBUDpUKPsVZBGSDRitTZ6u4ZeISVpJxVgaNyLpw
   1l1V80xGusVlpdyVoisnS6l0STe7r+BcBEA7EoF80sdx6KEX9iuhTp45j
   +UUHzg77sjSUFCOK9znZnI7+pCvl15rkwWgB9iq5GzbEWSIMPZ1V+QCq3
   ixB6Ldmrn/rD4u3ZSEevjmc7nemihzsXhv1JVdelrzIP9al+ftEeo+qv0
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10244"; a="310873326"
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="310873326"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 14:34:46 -0800
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="619538129"
Received: from sssheth-mobl1.amr.corp.intel.com (HELO intel.com) ([10.252.130.247])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 14:34:46 -0800
Date: Mon, 31 Jan 2022 14:34:44 -0800
From: Ben Widawsky <ben.widawsky@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-cxl@vger.kernel.org, linux-pci@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [PATCH v3 09/40] cxl/decoder: Hide physical address information
 from non-root
Message-ID: <20220131223444.ffhtruwae5uwx23l@intel.com>
References: <164298411792.3018233.7493009997525360044.stgit@dwillia2-desk3.amr.corp.intel.com>
 <164298416650.3018233.450720006145238709.stgit@dwillia2-desk3.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164298416650.3018233.450720006145238709.stgit@dwillia2-desk3.amr.corp.intel.com>

On 22-01-23 16:29:26, Dan Williams wrote:
> Just like /proc/iomem, CXL physical address information is reserved for
> root only.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Ben Widawsky <ben.widawsky@intel.com>

[snip]
