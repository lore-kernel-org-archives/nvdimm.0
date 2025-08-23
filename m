Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4DD6135A53
	for <nvdimm@lists.linux.dev>; Sat, 23 Aug 2025 03:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755918442; cv=none; b=FmLDBTmBy18u9aquT298LYAOHWfEt07ZXuSDLWr8qT/IedMwAOvjvFPIqns4DowaRR9XS9Iu45OIof3lzM2FM0KhA007O7AItcFSTcMAv7f+r2ZthMPd+O6zopwjc0GS3QK59guu9GTy9wcJB60EXKn1fjWRPo4NefVmwqn/kuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755918442; c=relaxed/simple;
	bh=26oixU0XpizrHcZw3OTRfogJM0wMJr16OihPB41g8to=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TWSOpzgA4Pd0lnHvuNtNlitEY8pZ0StIB5QOhmheWV6YsdQSbCrcTI1YjFaS5pw19LD5+pD8trcPXQA1U2GNjliaSJn1pnjRFLTksXWTO+/50KbpnlIxgXPmeDua1Vh2JBqCVPIeueoVMPaP0fyV+7OHxLDtxUV+J8P4zahfilQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aiuMJZ4M; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aiuMJZ4M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755918440; x=1787454440;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=26oixU0XpizrHcZw3OTRfogJM0wMJr16OihPB41g8to=;
  b=aiuMJZ4Mkha5Za3F6aG6d7keVU1yyXTGhobsb80UPljct0DLAZt5Emat
   2psHb/aYrntyqKWuIAKYz/P274QOsff+wi5qYH5K7tghto7Qd6Rw0pGls
   6/6DLSoQLAJtnlFdjRJAsiyPu24fpFxNIRL4fOAhPNzM67P0AgH6aa/DA
   NS1FDZVSgNP9nwG1PC2mWrYlpRgaNfq9mGh9HDLZh7UD04ZfJbd5rK706
   n9VVaM8O0myHzDDvEuxavCz0gZdc68Wp1rjvJOlp0N2573AE/eiaNW/Tw
   yceHM8NsnEFPqE73HjZENuRoaJpVyMs99K+AHrKaYl7CxXUx1nKzqnWLk
   w==;
X-CSE-ConnectionGUID: nSBIhwT5RGSj0kTkNM5IIw==
X-CSE-MsgGUID: VWwrZh/PR4ekpZwLmn6BDw==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="75679904"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="75679904"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2025 20:07:20 -0700
X-CSE-ConnectionGUID: VlSSSqyjT3W9FALSKhZBsw==
X-CSE-MsgGUID: CwlglXYzTea4NYGWSRkeMg==
X-ExtLoop1: 1
Received: from c02x38vbjhd2mac.jf.intel.com (HELO [10.54.75.17]) ([10.54.75.17])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2025 20:07:19 -0700
Message-ID: <19885c2f-59d8-45d2-9d2a-456d9f4b8304@linux.intel.com>
Date: Fri, 22 Aug 2025 20:07:12 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH] test/common: document magic number
 CXL_TEST_QOS_CLASS=42
To: Alison Schofield <alison.schofield@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, dave.jiang@intel.com
References: <20250822025533.1159539-2-marc.herbert@linux.intel.com>
 <aKizZaxYjEJ3g_Rc@aschofie-mobl2.lan>
Content-Language: en-GB
From: Marc Herbert <marc.herbert@linux.intel.com>
In-Reply-To: <aKizZaxYjEJ3g_Rc@aschofie-mobl2.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025-08-22 11:13, Alison Schofield wrote:
> On Fri, Aug 22, 2025 at 02:55:34AM +0000, marc.herbert@linux.intel.com wrote:
>> From: Marc Herbert <marc.herbert@linux.intel.com>
>>
>> This magic number must match kernel code. Make that corresponding kernel
>> code much less time-consuming to find.
> 
> The 'must match' is the important part. Include that in the comment.

Good point, will do!

> Why expect the user to parse a git describe string and go fishing.
> Just tell them it is defined in the cxl-test module.
> 

git knows how to parse back the git describe string; readers don't need
to parse anything. As explained in the commit message, it's convenient
because it holds in a single string both the immutable commit ID _and_
an indication of the minimum kernel version required.

Why tell users to "go fishing" for the cxl-test module when they can
find the location directly with a single git command.  This is real: I
actually wasted a fair amount of time searching for that constant in
drivers/cxl/ because I assumed the cxl-test driver was there. This
comment is not meant for experts; if they needed it then it would not
have been missing for so long.

Last but not least, code and files move around and get renamed. This
commit will never change, so it provides an immutable starting point in
case things change.

I'll add both, it should still fit on one line.
