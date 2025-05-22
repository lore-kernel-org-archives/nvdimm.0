Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57341F94C
	for <nvdimm@lists.linux.dev>; Thu, 22 May 2025 14:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747925288; cv=none; b=YHF+cielh0pEAQ7XpDlLLQndcn7Djm8vZBOe3JT0A1xuUnqW/ELTzMYatbr3bUr62p3l8jajo8gDvlZM3qWHAna486Q3sJve4/zq4PgwDnYmyo17Yd+UShX9e/cYXo/bIkc6Nk8Ge+iaI+f89frqBWWJNUkaL0ZUqkphkRVL1U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747925288; c=relaxed/simple;
	bh=HG4jexxHxsB32owSL6REekKPlnK9nTSRa6nQpwwOhSY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lqqrsriragug0+9r7RHtxT+9spMmQ8bkcQI7LprzpcaH7eHTqWiUHnB/E8AnVfc0HyEAHkEI9hL2yLmG9o5Lf3Fo2eXIM3u9gz8BTgYdBztuBXlwo+drnUNtBJ9MrEQZ9zWAz2ouCdQ3t7T2Y0BF6YVYNzgFoTplFJR3NPwNp5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A/icHTE8; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A/icHTE8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747925286; x=1779461286;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=HG4jexxHxsB32owSL6REekKPlnK9nTSRa6nQpwwOhSY=;
  b=A/icHTE8s2Rgnh5NNLtDKMPcYAKyGynazq6fhzjOO6hrmWh+yfNsocw7
   efUeriG4MK031YSXZGw7tQLao21VuxXc5d3KZfzYqeNhYOZgvX9SSJBHG
   dvqA15kBFDh+QEBtJ5XzbKap+yXbBG2BP2jemsJl8KcwFrMngZc7taujD
   ZzNQDNIFnFczKJzFmsGmLAVuiGWDXQeeCx6g671zdCT8DCkO73K+5Si9A
   IAMnRRC9Q38xGu69iF3STumNg31GFnLYGggBiX+Ogu9IpfRBohtoRHJmf
   tm2yU9LnE2iP6Jh5I4YrrfcSTFXoS2h1nrIimqtW0K1kjYYdfh1V8F6/F
   w==;
X-CSE-ConnectionGUID: 3ZvUBT1wT1O8bc/em6wAlw==
X-CSE-MsgGUID: osnhq88bQUGOsVC4mgeSEA==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="49874087"
X-IronPort-AV: E=Sophos;i="6.15,306,1739865600"; 
   d="scan'208";a="49874087"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 07:48:05 -0700
X-CSE-ConnectionGUID: xdmwhi2VTCiMRHaU1OWuUQ==
X-CSE-MsgGUID: PEjVkBhzS2uhWNEe2XmU0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,306,1739865600"; 
   d="scan'208";a="171513071"
Received: from adavare-mobl.amr.corp.intel.com (HELO [10.125.186.118]) ([10.125.186.118])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 07:48:05 -0700
Message-ID: <5c712edf-3cc5-4707-8a5d-472ede773b6f@linux.intel.com>
Date: Thu, 22 May 2025 07:47:56 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH 1/2] README.md: add CONFIG_s missing to pass NFIT
 tests
To: Alison Schofield <alison.schofield@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 dan.j.williams@intel.com
References: <20250521002640.1700283-1-marc.herbert@linux.intel.com>
 <aC6sVpma71y4jH7S@aschofie-mobl2.lan>
Content-Language: en-GB
From: Marc Herbert <Marc.Herbert@linux.intel.com>
In-Reply-To: <aC6sVpma71y4jH7S@aschofie-mobl2.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025-05-21 21:47, Alison Schofield wrote:

> Thanks for doing this Marc! 
> 
> I'm wondering about the need to delineate between what is needed to load
> and use the cxl-test or nfit-test modules as opposed to what is required to
> run all the unit tests.
> 
> I believe my environment, and yours, and most other folks using these
> environments are doing so in a VM so it's no big deal to load up all the
> things.
> 
> Maybe just a gentle separator in the list showing required and optional.

I unfortunately don't know and understand these enough to remember that
and it would be very time-consuming to re-test them one by one.

More generally speaking, this sort of list looks deceptively simple but
it almost never is. That's basically why I initially asked in
https://lore.kernel.org/nvdimm/aed71134-1029-4b88-ab20-8dfa527a7438@linux.intel.com/
if someone more knowledgeable could do this (based on the
run_qemu.git/.github/workflows/*.cfg files) Also, this stuff tends to
evolve.

Now that tested versions can be found in run_qemu.bit, it's less
critical to update this README.md file. The current README.md version is
inconveniently non working but at least some functional versions can be
found somewhere else.

Cheers,

Marc
