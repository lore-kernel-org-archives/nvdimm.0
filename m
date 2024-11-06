Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51AE18FC90
	for <nvdimm@lists.linux.dev>; Wed,  6 Nov 2024 03:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730863171; cv=none; b=R1EWNaY29xd6XKwmUYmZ2LQkSCg6EDMdqL/+LEBtWir/1TzmqqHhSfKQ3C4lKJuS/ovnD5WtHyCHx9O7upm6i531+EStP//1JJexrp4cQ2iq9EY2RcXoWndrKWBlOPGPdY8/sYZnqfl5ShyinsFu5EnqsrypXmxMSjlzlcEcveA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730863171; c=relaxed/simple;
	bh=+avY5x23Z9VD+kZlNOSdfVN2VRlzRLvpozxOPyx4O1w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bzHmfMDo+BE11oNV1gat2BGK+dI3XTiaKRJxeQq8cB450DrY3RBOxfzZzz+faKOJSVobycX1DiJqcQaqwCYuTtTypWQA4b1CutjgDqNanEDQ9cQZ/d0OSZUjeQUlowx3LVsc4F9ixaLnf2CDlp3za+VgXgmTMll0QGqXYU+63Q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n9Iv1bw3; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n9Iv1bw3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730863169; x=1762399169;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+avY5x23Z9VD+kZlNOSdfVN2VRlzRLvpozxOPyx4O1w=;
  b=n9Iv1bw3pjxen71hyQxeJ8jJgU6M2XoX7mnOvQMnwjnyuXBiw3rpeYxc
   gIPWwN6V0lt63VM/Nq1MwuuYGM9fyeJhJt3CmMh8YX6e7GXzpAr22HrLq
   xn/sh/z4LGQrIdQ43f/S2RuroJfXuenKIqRtg+IPmEExjPs75Ejfi/yNR
   PTQbSamVMsOKTtklSGeqtdFKOMhQ7z7YUhmUsv0FzfkqBvssVmPwlf3j5
   B+bJ+vhhLCthY1swC0P22lI8ulPbON3u/HwusqN7uChpssFUTxBdHypCF
   h/UGtjqfSWw92+MCAy33qYTE4DlHvMsSUUtjzDp7/KfjK5o4Dt+3PFWau
   A==;
X-CSE-ConnectionGUID: EUhMYgm3QnGpiyl2h7n3nA==
X-CSE-MsgGUID: LtthS9jBROquBsIvQLFf2w==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30494310"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30494310"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 19:19:29 -0800
X-CSE-ConnectionGUID: zzqpfywrTNSSTC7beNeMPg==
X-CSE-MsgGUID: o4AUzGqPQBmXiDM8Nc84+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,261,1725346800"; 
   d="scan'208";a="84208401"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2.lan) ([10.125.110.3])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 19:16:34 -0800
Date: Tue, 5 Nov 2024 19:16:32 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: ira.weiny@intel.com
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Fan Ni <fan.ni@samsung.com>,
	Navneet Singh <navneet.singh@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, Sushant1 Kumar <sushant1.kumar@intel.com>
Subject: Re: [ndctl PATCH v2 4/6] cxl/region: Add creation of Dynamic
 capacity regions
Message-ID: <ZyrfkAZQfAEtkck0@aschofie-mobl2.lan>
References: <20241104-dcd-region2-v2-0-be057b479eeb@intel.com>
 <20241104-dcd-region2-v2-4-be057b479eeb@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241104-dcd-region2-v2-4-be057b479eeb@intel.com>

On Mon, Nov 04, 2024 at 08:10:48PM -0600, Ira Weiny wrote:
> From: Navneet Singh <navneet.singh@intel.com>
> 
> CXL Dynamic Capacity Devices (DCDs) optionally support dynamic capacity
> with up to eight partitions (Regions) (dc0-dc7).  CXL regions can now be
> spare and defined as dynamic capacity (dc).
> 
> Add support for DCD devices.  Query for DCD capabilities.  Add the
> ability to add DC partitions to a CXL DC region.
> 
> Signed-off-by: Navneet Singh <navneet.singh@intel.com>
> Co-authored-by: Sushant1 Kumar <sushant1.kumar@intel.com>
> Signed-off-by: Sushant1 Kumar <sushant1.kumar@intel.com>
> Co-authored-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> 
> ---
> Changes:
> [Fan: Properly initialize index]
> ---
>  cxl/json.c         | 26 +++++++++++++++
>  cxl/lib/libcxl.c   | 95 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  cxl/lib/libcxl.sym |  3 ++
>  cxl/lib/private.h  |  6 +++-
>  cxl/libcxl.h       | 55 +++++++++++++++++++++++++++++--

Hi Ira,

This is 'do as I say, not as I do' feedback, because I realize while
reviewing this, that I've been remiss in keeping the libcxl man page
updated.

Please document the new libcxl helpers here:
Documentation/cxl/lib/libcxl.txt  (it emits in 'man libcxl'

Sometimes it's just a quick add of the new helper. You can see what is
there and decide if additional verbage about DCD regions is needed.

Thanks and I'll do some catchup in that file after you ;)

-- Alison

snip

