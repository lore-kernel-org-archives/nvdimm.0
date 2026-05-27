Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8804E1A262D
	for <nvdimm@lists.linux.dev>; Wed, 27 May 2026 18:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779907876; cv=none; b=qHV0T3BiBfVFdogTaGhHln8z9amWwOsJWNG7XEgLVH4NYx5kMjXZqHub+qNZzfrph6obTmcKj6oiXi8M4v1Zm+PWHV23mZV6QuoYpzQt0ZqLX2UXNUlWYX8/+P/9RfN2fikvyVLtHQFjamzO3oxT7PYA24pt9yqeRonxygkmk5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779907876; c=relaxed/simple;
	bh=Fp7JCvfOR4okNHQ6mgssZJpR83qnUXn7+A9aV6bedNk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cDaF5b3R87kF25Ypp0qSeZwJLK6cbyYzDqgvuC9R015uSFJQdge1BKjBJXfIU6NrPN6Tsbv00O10LH/VrGTxIPEKBzMj7yUzBcS96dKnZIOWGVsjDCcmXCWeUdQzBakpkNCthZABfJ6rskh/Y75oRwSYH9PEKv/i0v3YgAdPx9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dhp84lBy; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dhp84lBy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779907876; x=1811443876;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Fp7JCvfOR4okNHQ6mgssZJpR83qnUXn7+A9aV6bedNk=;
  b=dhp84lByp6OzTk8BnLn1h60YOXWfcXSUKpaZFqo2bdsbboqyxEVveQTe
   FC405oENNqaif+Do+f9DMajQ4XoDDsoMWeR2iaETPxjARN8j5zdqVJx1O
   0HyQXwaIMfQCD8N60qU8FF4ThfNTKFUyGFLVoBfp90XN4iPLlV5f+iy2H
   9iZ9z1XuMoGzeMsIu31R2l+HHPHnoFKYmXza1eOvu6o4DUU3BkwUCYeol
   ODzmo3wpTMQmljx1wnXOPlx6EOrhi86r8P2H/sz3ViaKfUORRRlabxbIJ
   D4GTWBRdhAxHGXi93F6FwdXo562wrgYYwSMzc9t1v8JF5rfdAC7dPXmo8
   g==;
X-CSE-ConnectionGUID: GLWfOODXRWashyEdcUFmGA==
X-CSE-MsgGUID: 5Nl+MGsgQlWHGc5NSRt7kQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11799"; a="92224144"
X-IronPort-AV: E=Sophos;i="6.24,172,1774335600"; 
   d="scan'208";a="92224144"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 11:51:15 -0700
X-CSE-ConnectionGUID: 6PIoLYNASYa3PymA/c08AQ==
X-CSE-MsgGUID: ordUriqiS6OcnJ2lxzoJuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,172,1774335600"; 
   d="scan'208";a="247272949"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO [10.125.111.23]) ([10.125.111.23])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 11:51:15 -0700
Message-ID: <3b1b2486-d09e-4bfe-8c64-224df8048d44@intel.com>
Date: Wed, 27 May 2026 11:51:13 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 00/31] DCD: Add support for Dynamic Capacity Devices
 (DCD)
To: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Dan Williams <djbw@kernel.org>,
 Jonathan Cameron <jic23@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <iweiny@kernel.org>,
 Alison Schofield <alison.schofield@intel.com>, John Groves
 <John@Groves.net>, Gregory Price <gourry@gourry.net>,
 Anisa Su <anisa.su@samsung.com>
References: <cover.1779528761.git.anisa.su@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <cover.1779528761.git.anisa.su@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/23/26 2:42 AM, Anisa Su wrote:

<-- snip -->

> Series Info
>   =============
>   The series builds on top of cxl-next with the famfs-v9 patchset
>   applied.

Hi Anisa,
Just for future reference, I would prefer that you base off of latest Linus tags for future patch submissions. i.e. for this week it should be v7.1-rc5. I would prefer that it does not base on cxl/next unless instructed otherwise. Thankfully this series applies cleanly to v7.1-rc5 so it's not a concern. Thanks!

DJ


