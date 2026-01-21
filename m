Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42ACD30F52D
	for <nvdimm@lists.linux.dev>; Wed, 21 Jan 2026 15:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769009859; cv=none; b=Cx1sv8rENvFCB/xbHLus451MedgJhXrMhRdEHnXX1zJhrrltPiFmZfNLPjJiTHsw6TC5nc5ZrlN4B5UtBpAu5MGVsvr9XmwZJyrrolUObNgKrvX4CN+WUg8/NMjVeG0oTtpsSP1UjXOCrq9sYWDWwEAWFj21Rgpe096DJf9QLIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769009859; c=relaxed/simple;
	bh=6A2FhFWgjERkQJk0xvh/O3g+Dy3gAyh0vElApgkiQlk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iz6j2HLF1IRtoPk4lzGtloBtO1LzgNy2tBo4cLu4/+aY3d/kcR6aGa1Sc/tODZB7XNcDgfJn91Ywj8RT9OuwOU1J2EilLBRORJvUPFsZDnnOWlHSjTm4NXi3L13sgAEIR8xW5aDuGIWbzrvcpsWO2O3CA54NjwF6Kk81E0zDntg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UdnfjIds; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UdnfjIds"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769009858; x=1800545858;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6A2FhFWgjERkQJk0xvh/O3g+Dy3gAyh0vElApgkiQlk=;
  b=UdnfjIdsZlxpPhnZP+jjMGJfai6OO/cBNJED6fIRVUAkuXQlwfO99tZ5
   ZZA6fIhzA2nRIaSG+f/rgp2vcFx3qEXn7jDzavRRDLUV9VlnHSIqOKGPu
   L90Y+lSyfJqVuAnObX8rRxLmCqWilnNrbCQcIWvGgio+jcL3v6AzofEur
   uwtmUQ5x8JxRHyCS1r2CQhZPJmK85fYdSP9Ry4NVrrMn2OlGCp3U1loYI
   XttOi+TSUKl9N9cCmIIyFl+5LOLD2ZBAgXKApTFXCZC15okRAmCV1eTtN
   OXF/k6+O8KV1EtQLsNjltcgCTlQLhkeSfUh9p4Juhp32pH5wYlT05el5o
   w==;
X-CSE-ConnectionGUID: JKy4Dm69RSO+o3BnKHHUBw==
X-CSE-MsgGUID: KuOb9n5FSh+72oFwWDfMjw==
X-IronPort-AV: E=McAfee;i="6800,10657,11678"; a="80542358"
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="80542358"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2026 07:37:37 -0800
X-CSE-ConnectionGUID: ilSlm5PbQR+D1K2ai66DXw==
X-CSE-MsgGUID: wZtQkgnDS0q4Pp/+DqdNMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="229448331"
Received: from rchatre-mobl4.amr.corp.intel.com (HELO [10.125.108.97]) ([10.125.108.97])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2026 07:37:36 -0800
Message-ID: <522c816a-236f-4f4b-99e9-a90a7855872f@intel.com>
Date: Wed, 21 Jan 2026 08:37:35 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V5 00/17] Add CXL LSA 2.1 format support in nvdimm and cxl
 pmem
To: Neeraj Kumar <s.neeraj@samsung.com>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com
References: <CGME20260109124454epcas5p4513168fdb4253ef1c5ac1656985417fd@epcas5p4.samsung.com>
 <20260109124437.4025893-1-s.neeraj@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260109124437.4025893-1-s.neeraj@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/9/26 5:44 AM, Neeraj Kumar wrote:

<snip> 

> 
> base-commit: fa19611f96fd8573c826d61a1e9410938a581bf3
> prerequisite-patch-id: f6e07504b17ccf39d9486352b6f7305a03897863
> prerequisite-patch-id: cd6bad0c8b993bb59369941905f418f3b799c89d
> prerequisite-patch-id: 08ebdae0888c0a2631c3b26990679a0261f34f14
> prerequisite-patch-id: 344220faa9c156afec0f5d866ad3098880a85e34

For the next rev, please rebase against for-7.0/cxl-init branch (unless 7.0-rc1 has dropped). Thanks!

