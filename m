Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D858F49
	for <nvdimm@lists.linux.dev>; Thu, 14 Aug 2025 01:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755134900; cv=none; b=ezb/gvGNVaRi3MzMXdFeS70skyJrc5/v3LImNDbjUs1V/RbPsazNiyr6EAg4Dfa4fHpMlRaPAhCoBu5QVT/SaWP9Ep+u3ZWTgOPPfhCs14lOmypEN0f/xSiNW8JEhusEFHaBxUSjj49Go4qK6jOa6VlpX244XBX/MV21TnsVqic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755134900; c=relaxed/simple;
	bh=hQoshqUUh8b1MyB8PQ1dRVE9iJ9QBsA88oLBjGGk7mI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=GvOBT85Zkyv6u6mVXwO7FD09JZU1dgHegsl8bAWf+B6TFRGcEANNQkXUvQRZVBb4QoXDYA2Zr4XA4Vjy82nH+uoMi6d4yXSWgpJfIoD9DFxVrZ//Tmw8Q3albhKnTy6wDuRSVPAw+aKYGqrVnymZ15zH1CFe9gCXPi4GXktHooo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Yquw8V3L; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Yquw8V3L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755134899; x=1786670899;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=hQoshqUUh8b1MyB8PQ1dRVE9iJ9QBsA88oLBjGGk7mI=;
  b=Yquw8V3LcTkF8ZpCGkN7mQKzpjY0dwns/zm092rTz3ItsuH1ms4WUWrT
   4SR23rrWz76gkyyYM31MGAY7IXMq7KTiixHjXIodICPwKLr0LBXoPOgKb
   Hu83yNx9uf7O0VpJ052dkQEywOgKyEWxZcHEu//dLyPKri8Pwjd1yQ0kM
   CmZnhHoP/wLNIiEEb7+vbxJGp3qeBfQnQOagbKrTKaNMJjjIpN1kTDV5a
   E8ab4/ANwvfmKJsH7AKMgFditHmBwiUA3huDhm9SLdOUAFAgVACz96rYc
   Ne3CtJmF/R9D0nY+JARQTJB8QaW7V/FdsOuwLXQ1icQjx2PPp9jLIaEOe
   A==;
X-CSE-ConnectionGUID: cImnmMFfRBqJ0aoHYhLNIQ==
X-CSE-MsgGUID: AvchKYFrRDSjHs4BR0Xiuw==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="61248145"
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="61248145"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 18:28:16 -0700
X-CSE-ConnectionGUID: 5UgrA5HQRIapOrLY4OjBcQ==
X-CSE-MsgGUID: +V/5pjC9R9aNU0jGM0N5Iw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="197613646"
Received: from c02x38vbjhd2mac.jf.intel.com (HELO [10.54.75.17]) ([10.54.75.17])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 18:28:17 -0700
Message-ID: <176191f6-3cf6-4d96-819d-28146f4646d1@linux.intel.com>
Date: Wed, 13 Aug 2025 18:28:14 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH] cxl: Add cxl-translate.sh unit test
Content-Language: en-GB
To: alison.schofield@intel.com, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org
References: <20250804090137.2593137-1-alison.schofield@intel.com>
From: Marc Herbert <marc.herbert@linux.intel.com>
In-Reply-To: <20250804090137.2593137-1-alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Reviewing only the shell language part, not the CXL logic.

On 2025-08-04 02:01, alison.schofield@intel.com wrote:

> +# Allow what shellcheck suspects are unused - the arrays
> +# shellcheck disable=SC2034

That's very indiscriminate and shellcheck -x is usually pretty good
there... did you use -x?

Alternatively, could you place this only before the arrays that
shellcheck gets wrong for some reason? (which reason?)


> +
> +check_dmesg_results() {
> +        local nr_entries=$1
> +        local expect_failures=${2:-false}  # Optional param
> +        local log nr_pass nr_fail
> +
> +        log=$(journalctl -r -k --since "$log_start_time")

-r is IMHO not a very common option:

        log=$(journalctl --reverse -k --since "$NDTEST_START")


> +	nr_pass=$(echo "$log" | grep -c "CXL Translate Test.*PASS") || nr_pass=0
> +        nr_fail=$(echo "$log" | grep -c "CXL Translate Test.*FAIL") || nr_fail=0

Not sure about reading the entire log in memory. Also not sure about
size limit with variables... How about something like this instead:


    local jnl_cmd='journalctl --reverse -k --grep="CXL Translate Test" --since '"$NDTEST_START"
    local nr_pass; nr_pass=$($jnl_cmd | grep 'PASS' | wc -l)
    local nr_fail; nr_pass=$($jnl_cmd | grep 'FAIL' | wc -l)


> +        if [ "$expect_failures" = "false" ]; then

       if "$expect_failures"; then

