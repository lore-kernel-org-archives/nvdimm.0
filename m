Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4181A219A94
	for <nvdimm@lists.linux.dev>; Mon, 19 May 2025 22:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747694555; cv=none; b=s86pwHdxfhIgjiaW1o/mR9dd6djhfmUfroZCKy4Xyjy3QSrUByQBOK29z7P6KNoaTe/C/DE2FxvOCPOIbEES9vHO94WbPwHPLzCL018Vj5Mx+nXAM84P+B10axR+O4FCPN2jR91c4UNnd6utK2g5q8gJ0mB2DgYxtM7KeRuoILU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747694555; c=relaxed/simple;
	bh=KobKDhAjOHp9aG4TMhHvLZ+sFDWhMlmN2qV80xY7nqk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=MvM2aBXedhs3pKMWAVjDFNtyrgUSDNoHmn5fG9Ha/FcQuNnjMc9fpsO2KrN5ByXYUqa1HeMN9IT5GeGtTWryK9EPIaLxwZQBVovNttXxtCTrY0Lxi10+vskjPC3F65JQOOeni1m0DcsCymcqts4gSld9LLCRpG9Va+SaoCv0My0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DcNCmuvb; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DcNCmuvb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747694554; x=1779230554;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=KobKDhAjOHp9aG4TMhHvLZ+sFDWhMlmN2qV80xY7nqk=;
  b=DcNCmuvbNWPBIEVHYSptYMJVkLJObaLLWGNiXzUyMe9CA/cRrV2pFnt7
   oQdEjdA9HC3dsXcUaY46oBUF/6T+99UJ3xSyLeUcIaEC1EB/6UGbl+xE4
   55NmrQBVVqdllnb9T980qEMTOOsA03CBepQPg0nW+DBHeLlNXai8BiVGF
   nREKPRItuYw0M1wHIvSclRVMCAiAh1x6/h+ZYFISePFI/Id8otvNIbJbD
   a8e2bLwrV5woXAax0HSi2JQjfEm4xkNhE/RH9Il7ry0soxqARfldaZ7j+
   7yFXyir4eXzuIP85JkjjBhKJ8QTFzuMhMZLpeR+8kZT2PmkTQO5jWeOfN
   Q==;
X-CSE-ConnectionGUID: 3+9yUqOlQSK+IjiQITrEFg==
X-CSE-MsgGUID: Q3ZH5RyUQ92bieOSdDJ4TA==
X-IronPort-AV: E=McAfee;i="6700,10204,11438"; a="53287373"
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="53287373"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 15:42:34 -0700
X-CSE-ConnectionGUID: rnVvA//+RUanVoZL+MBFnA==
X-CSE-MsgGUID: c8OMF7VJTXudz4dmBpdqWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="139917405"
Received: from agrisant-mobl2.amr.corp.intel.com (HELO [10.125.1.252]) ([10.125.1.252])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 15:42:33 -0700
Message-ID: <f15e4a85-cdb0-4243-bd82-28f09710bb7c@linux.intel.com>
Date: Mon, 19 May 2025 15:42:30 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH v3] test/monitor.sh: replace sleep with event driven
 wait
Content-Language: en-GB
To: alison.schofield@intel.com, nvdimm@lists.linux.dev,
 Li Zhijian <lizhijian@fujitsu.com>
References: <20250519192858.1611104-1-alison.schofield@intel.com>
From: Marc Herbert <marc.herbert@linux.intel.com>
In-Reply-To: <20250519192858.1611104-1-alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025-05-19 12:28, alison.schofield@intel.com wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> 
> Again, looking for Tested-by Tags. Thanks!

Wow, it went so fast I genuinely thought something went terribly wrong
and it did not test anything anymore. While reporting "Success!" - that
has happened before.

But I check the test logs and it does a lot of stuff - in less 2
seconds! What a difference.

Tested-by: Marc Herbert <marc.herbert@linux.intel.com>

I have only concern holding back my Reviewed-by + some minor nits after
the code. I think the error message for the timeout pipeline is too
limited, terse and generic; does not say anything about what happened,
does not make the difference between a timeout and some other, unexpected
failure, how many occurences were found etc. I think the error clause
should do at least two things:

- print the timeout $? exit code.
- grep the log file again, either with -c if it's too long, or not.
- Any other useful information that could be up for grabs at that point.


> +wait_for_logfile_update()
> +{
> +	local expect_string="$1"
> +	local expect_count="$2"
> +
> +	# Wait up to 3s for $expect_count occurrences of $expect_string
> +	# tail -n +1 -F: starts watching the logfile from the first line
> +
> +	if ! timeout 3s tail -n +1 -F "$logfile" | grep -m "$expect_count" -q "$expect_string"; then
> +		echo "logfile not updated in 3 secs"
> +		err "$LINENO"
> +	fi
> +}

tail -F really does solve the problem with very little code, well
spotted!
Nit 1: I did not know that -F option: can you try to sneak the word
"retry" somewhere in the comments?

Codestyle Nit 2: to avoid negations I generally prefer:

  timeout 3s tail -n +1 -F "$logfile" |
     grep -q -m "$expect_count" -q "$expect_string" || {
      error ...
    }

This also translates to plain English nicely as "wait or fail", "do or
die", etc.

Super minor nit 3: "$expect_string" looks like an argument of "-q", can
you move -q first?
