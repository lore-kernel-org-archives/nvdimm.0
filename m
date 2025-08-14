Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3A02264B1
	for <nvdimm@lists.linux.dev>; Thu, 14 Aug 2025 22:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755209844; cv=none; b=L5gDPp7bPGpgwBi9C2hyM/IONp0TDpa8wUp3F7Jv4stE1DqgtY8W7vMnxCE5oXSdX7Jd7KDfqULtIJxeocCs9L2HmRi1N/ryxLoV3sPWdXvF3cPnqwmjHTpRRVOF+p4KywUikxWODYaVf9evIQb532DkTgg2Pmy90h7BsjRopfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755209844; c=relaxed/simple;
	bh=Rn2CNl4anxJEhXA0v17a4B954MRkjhmLZ69TQYC3OcA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=vDTjKRMv08CcgX7v3rymlxEiE1RzUaoy/ZV3zN++ARPPFySP1GIu0s80r6g2uAONfNC4jC/ra4nz7ILgE9dbirKiCld9N5VKRG77Bpi4NUHVUkhQitjjT78MR9ZUDEhQ8Um0E19HroeMKq3R0j0OntOreVn0lMeTzVezExwFdvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=juFrF6GP; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="juFrF6GP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755209842; x=1786745842;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Rn2CNl4anxJEhXA0v17a4B954MRkjhmLZ69TQYC3OcA=;
  b=juFrF6GPiE0dxv7k6+mZgZwVncqWZL7o1CB+j11auAHR3g8SnWvCByxa
   gBLyuUE8mb1BiTL684FrNDQXCDfJ99E49ujzelnByvoCx//SVEg7eU/zl
   29NUJP+PVSoNlZzVzYIhUd+ssedYu+WIz14+rQGhgjSdlnPQx366vRjOZ
   7SDSpp6MeRZYpOWj2T5J9rLeynMcVfVBxxY58b7ZqyP6w21OPnT01LD+D
   nWA7WCHaglpVBxT8XPIDUF661jbNvVh2P1IbhPozmgFhJmdmNvvaV5Oa0
   cHtuHWLvpMqxYAzmr5nb+lL+odS7VgaAk73jg1VLO0LdlMXmHn/TQClMi
   w==;
X-CSE-ConnectionGUID: p3OWRh0CTqqnPz3Es3Zt3Q==
X-CSE-MsgGUID: PHfAV7CkRcWnxyGrotQBSw==
X-IronPort-AV: E=McAfee;i="6800,10657,11522"; a="57616072"
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="57616072"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 15:17:21 -0700
X-CSE-ConnectionGUID: d5oDcQldQXGBR0rWyy1jwg==
X-CSE-MsgGUID: 7g++HRfqRbSQK1tOtmGKRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="166084787"
Received: from c02x38vbjhd2mac.jf.intel.com (HELO [10.54.75.17]) ([10.54.75.17])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 15:17:21 -0700
Message-ID: <b64b9227-2406-440a-8cd8-95519f987b0e@linux.intel.com>
Date: Thu, 14 Aug 2025 15:17:15 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH] cxl: Add cxl-translate.sh unit test
To: Alison Schofield <alison.schofield@intel.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
References: <20250804090137.2593137-1-alison.schofield@intel.com>
 <176191f6-3cf6-4d96-819d-28146f4646d1@linux.intel.com>
 <aJ1gidnZblX8EQTK@aschofie-mobl2.lan>
Content-Language: en-GB
From: Marc Herbert <marc.herbert@linux.intel.com>
In-Reply-To: <aJ1gidnZblX8EQTK@aschofie-mobl2.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025-08-13 21:05, Alison Schofield wrote:
> On Wed, Aug 13, 2025 at 06:28:14PM -0700, Marc Herbert wrote:
>> Reviewing only the shell language part, not the CXL logic.
>>
>> On 2025-08-04 02:01, alison.schofield@intel.com wrote:
>>
>>> +# Allow what shellcheck suspects are unused - the arrays
>>> +# shellcheck disable=SC2034
>>
>> That's very indiscriminate and shellcheck -x is usually pretty good
>> there... did you use -x?
> 
> Yes. Shellcheck -x doesn't ignore SC2034.

It does not, but -x is required to fix SC2034 when declaration and usage
are split across files. It's indeed off-topic for these arrays, sorry
about that. On the other hand, it does apply to the `rc` variable
in this file. See complete patch at the bottom.


>> Alternatively, could you place this only before the arrays that
>> shellcheck gets wrong for some reason? (which reason?)
> 
> I considered and chose the global disable for the arrays and commented
> same. The syntax is valid bash syntax that shellcheck has not caught up
> to understanding yet.

So I got curious and just learned that shellcheck has made the
deliberate choice to ignore references / indirections. Interesting!
https://www.shellcheck.net/wiki/SC2034

If nothing else, the comment should be a bit more specific and mention
the relevant "nameref" or "indirection" keyword.

I haven't seen name references used much, most people seem to
"brute-force" this with an 'eval' instead (which makes SC2034 obvious),
but the former are much more elegant! Yet not elegant enough for
shellcheck :-)


> There is always this option to see what may be masked by shellcheck
> disables:
> 
> grep -v -E '^\s*#\s*shellcheck\s+disable=' cxl-translate.sh | shellcheck -x -

Mmm... that's not very convenient. I found a selective and concise fix,
see below. This is a useful warning.


>>
>>> +	nr_pass=$(echo "$log" | grep -c "CXL Translate Test.*PASS") || nr_pass=0
>>> +        nr_fail=$(echo "$log" | grep -c "CXL Translate Test.*FAIL") || nr_fail=0
>>
>> Not sure about reading the entire log in memory. Also not sure about
>> size limit with variables... How about something like this instead:
>>
>>     local jnl_cmd='journalctl --reverse -k --grep="CXL Translate Test" --since '"$NDTEST_START"
>>     local nr_pass; nr_pass=$($jnl_cmd | grep 'PASS' | wc -l)
>>     local nr_fail; nr_pass=$($jnl_cmd | grep 'FAIL' | wc -l)

> This is reading the dmesg log per test_table or test_sample_set.
> There are currently 6 data sets that are run thru the test and results
> checked per data set. Each set has an expected number of PASS or FAIL.
> I'm pretty sure any one log is much smaller than any log we typically
> generate just by loading the cxl-test module in other cxl-tests.

Thanks! It still looks inefficient to me not to use the --grep feature
built-in journalctl but if it's that small then I agree it does not
matter.


> I don't expect to use the general check_dmesg() here because anything
> this test wants to evaluate is in the logs it reads after each data
> set.

I had understood at least that :-)

>>
>>
>>> +        if [ "$expect_failures" = "false" ]; then
>>
>>        if "$expect_failures"; then
> 
> Is the existing pattern wrong or is that an ask for brevity?

Yes, just for brevity and clarity. I mean you would not write "if
(some_bool == false)" in another language. Not important.


--- a/test/cxl-translate.sh
+++ b/test/cxl-translate.sh
@@ -2,10 +2,8 @@
 # SPDX-License-Identifier: GPL-2.0
 # Copyright (C) 2025 Intel Corporation. All rights reserved.
 
-# Allow what shellcheck suspects are unused - the arrays
-# shellcheck disable=SC2034
-
 # source common to get the err()
+# shellcheck source=test/common
 . "$(dirname "$0")"/common
 
 trap 'err $LINENO' ERR
@@ -140,6 +138,7 @@ generate_sample_tests() {
 
 test_sample_sets() {
         local sample_name=$1
+        # shellcheck disable=SC2034
         local -n sample_set=$1
         local generated_tests=()
 
@@ -283,6 +282,12 @@ test_tables() {
         check_dmesg_results "${#table_ref[@]}" "$expect_failures"
 }
 
+# Used only as "nameref"
+# shellcheck disable=SC2034
+declare -a  Expect_Fail_Table XOR_Table_4R_4H XOR_Table_8R_4H XOR_Table_12R_12H
+# shellcheck disable=SC2034
+declare -A  Sample_4R_4H Sample_12R_12H
+
 test_tables Expect_Fail_Table true
 test_sample_sets Sample_4R_4H
 test_sample_sets Sample_12R_12H
