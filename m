Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB2651ADC68
	for <nvdimm@lists.linux.dev>; Tue, 11 Feb 2025 03:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739244303; cv=none; b=KUrJ++TpH/oMUBJB727JWNACDo+dcEehV7PahKkDn4i0lzTAMnAIZeELuGb9d8ZxH7rxIx8D9JWOyRG5pm62ZOGoTEl2UOLtaamBbfppPAb5z8mEYiSyeYnqqox71nkwQfMCO3/TD6lP+JRAjTEJQWgkkPzDoq7PCMzIFbRtVNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739244303; c=relaxed/simple;
	bh=qXgWmgX7W7LOdtijCD2PGT4iG+dnxFsv3p8toVNqxi0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rgxB8s6akDxaGKoOn4gIqFAEl9d8bACCtI7cAyClar3sge5IjddwpHdWBJ/4WAwp8Gl2c1UgwKZoeuQc6lNcZ/vH+/kbIeBvvK9j8s2Q3U1HW9/pYDpgJIKtowLJ9vuyVYDhBq7qD2ZLF54SofkjKGcavG/dj+TVfEwIQWHyfWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QH6hM5SU; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QH6hM5SU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739244301; x=1770780301;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qXgWmgX7W7LOdtijCD2PGT4iG+dnxFsv3p8toVNqxi0=;
  b=QH6hM5SUBdDLJOFBmw2KL1fipNgYh6J/bwEMcSGoQgDmVj9meZWYxbQF
   lbg3UIObVd1Ri+JmnG2SNwSnNMwySKEcU01Gbw/Igc4TDHGO4i87lBSvf
   Ul9v8QLzMqVG4lrSk7uiOljJxG4n6fUD/ySgvw0niZB76RSM88fMAMjCq
   Oq7obuhf0vY4yWPYLx7+Y7HM9dzSafPbOIEji4qT3M4+OwZBIwJHRZ7N1
   J8mt8vJZpR6BXZdg8cedpsM2cE6GCc8U2e4AtYRg3Sw9SOZZGAzNBU/Qp
   XWSAf0UhulSrK4fio1UrjRcQ0duGHrW1HWEyjP7vp2JCTKkfEjV8Ef7Xq
   A==;
X-CSE-ConnectionGUID: L34hSl0gT66rU1RAt3QeSw==
X-CSE-MsgGUID: iHCeeMigSSmR+hMs6P1ZNg==
X-IronPort-AV: E=McAfee;i="6700,10204,11341"; a="43777347"
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="43777347"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 19:25:01 -0800
X-CSE-ConnectionGUID: 2mX1oqcWS225kIl4Mh6lMA==
X-CSE-MsgGUID: R8j0qsXzQ3OUZLHkA52LSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="112326727"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2.lan) ([10.125.111.205])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 19:25:01 -0800
Date: Mon, 10 Feb 2025 19:24:59 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Ira Weiny <ira.weiny@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Fan Ni <fan.ni@samsung.com>,
	Sushant1 Kumar <sushant1.kumar@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [ndctl PATCH v4 8/9] cxl/region: Add extent output to region
 query
Message-ID: <Z6rDC2QtGgVh-jrU@aschofie-mobl2.lan>
References: <20241214-dcd-region2-v4-0-36550a97f8e2@intel.com>
 <20241214-dcd-region2-v4-8-36550a97f8e2@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241214-dcd-region2-v4-8-36550a97f8e2@intel.com>

On Sat, Dec 14, 2024 at 08:58:35PM -0600, Ira Weiny wrote:
> DCD regions have 0 or more extents.  The ability to list those and their
> properties is useful to end users.
> 
> Add an option for extent output to region queries.  An example of this
> is:
> 
> 	$ ./build/cxl/cxl list -r 8 -Nu
> 	{
> 	  "region":"region8",
> 	  ...
> 	  "type":"dc",
> 	  ...
> 	  "extents":[
> 	    {
> 	      "offset":"0x10000000",
> 	      "length":"64.00 MiB (67.11 MB)",
> 	      "tag":"00000000-0000-0000-0000-000000000000"

Why do we call these 'tag' and not uid?
We use the uid helpers on them so I know they share the format.


-- snip to end
