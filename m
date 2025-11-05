Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2582D2080C8
	for <nvdimm@lists.linux.dev>; Wed,  5 Nov 2025 02:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762310571; cv=none; b=EIQeh06aisf2p0uEnJjdwwYsv+1lLOp2vaA69Wv7YUp+nL4LJmJgkGNtdDG8Zs98GGdHvGUULm9BAUwMFPfB8gfSYnYtVNAWDRJes4tiVoFuWtEsVxa677fenCyrXkGuzLua8BlXWHZ8HuUqgZAITdg6fikJ1q//74ZA7nLV1hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762310571; c=relaxed/simple;
	bh=a0mHHpA3kqbqeKN0ClJTM/QISZsWFMMWv9Rj6gRIVVA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=PdZEt5dEc86rvo7vHnfRcriQljTWwMIxSfdXk2FW2s+o0ugXFgMq8YC8oI8oOI3eJ+aT7FB2v54G5sZOtk3YWzVqhiYCCjMNofNg7JS+XMD939ykNNGeRMlE2v4d5TGlhXEhPdsFeXHtsZm/1Zd5nOBqR3nVvhRCHIhGhlShaLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PcbTT2zy; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PcbTT2zy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762310568; x=1793846568;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=a0mHHpA3kqbqeKN0ClJTM/QISZsWFMMWv9Rj6gRIVVA=;
  b=PcbTT2zyDR9y85iVQGjCUj2aIwga3sZ7I2M3TorfAMIVfaRJg0+kiUuK
   xDREd5EBqhXZGIT/g6KU2tkxs01Rir7pF2xnskYqCj1eyywGOVsLCL3yq
   lYvhWgYIIx2OtaSQGrj1iLItWfAl06wdjwrG9Vq7fFFF0HePkSsKZ3X9s
   fApBwNx0hHqDtGOmp0Px4RRoWFmkqVWPFqqDPdO2wQNYSZ9lFPh5wNbdJ
   paYIrO3NZTQ0nmhrG2uQc5gSq9NdgTmrda/JmB/jIuTdcjF+alVHtzeLh
   bzT9jNwYmg/EZxzs8s0tblbaLF7Kio8RMSNbk6E85RyohMlhmGkf71F/s
   w==;
X-CSE-ConnectionGUID: Csey7MprSAWqT9UQPDf0yA==
X-CSE-MsgGUID: aJ1uwrkmTde5CsXmswq8Og==
X-IronPort-AV: E=McAfee;i="6800,10657,11603"; a="74711569"
X-IronPort-AV: E=Sophos;i="6.19,280,1754982000"; 
   d="scan'208";a="74711569"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 18:42:47 -0800
X-CSE-ConnectionGUID: XOuMYo0TSjmowV39XEwHKg==
X-CSE-MsgGUID: oRSwK4KjQU66of/39CG9xA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,280,1754982000"; 
   d="scan'208";a="191681061"
Received: from c02x38vbjhd2mac.jf.intel.com ([10.88.27.157])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 18:42:47 -0800
From: Marc Herbert <marc.herbert@linux.intel.com>
To: Alison Schofield <alison.schofield@intel.com>
Cc: nvdimm@lists.linux.dev,  linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH v3] cxl: Add cxl-translate.sh unit test
In-Reply-To: <20250918003457.4111254-1-alison.schofield@intel.com> (Alison
	Schofield's message of "Wed, 17 Sep 2025 17:34:55 -0700")
References: <20250918003457.4111254-1-alison.schofield@intel.com>
Date: Tue, 04 Nov 2025 18:42:40 -0800
Message-ID: <m2bjlhtd27.fsf@C02X38VBJHD2mac.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain


"Usual" disclaimer: only sharing my shell experience. Unfortunately
still cannot review the actual test logic.

Alison Schofield <alison.schofield@intel.com> writes:
> --- /dev/null
> +++ b/test/cxl-translate.sh
> @@ -0,0 +1,320 @@

> +# shellcheck disable=SC2034
> +#
> +# Arrays in this script are passed by name into helper functions using Bash's
> +# nameref feature `declare -n`. This pattern supports writing generic test
> +# harnesses that can iterate over many different test vector arrays simply by
> +# passing the array name. ShellCheck doesn't track nameref indirection, so it
> +# incorrectly reports these arrays as unused (SC2034). At runtime they are
> +# fully used through the nameref, so these warnings are safe to ignore.

As mentioned before in Message-ID
<b64b9227-2406-440a-8cd8-95519f987b0e@linux.intel.com>, I still think
disabling this for the entire file is harmful and not necessary. I
tested the 4 lines below and they still work. "X is unused" is a useful
warning that has caught real bugs in other scripts before. For instance:
changing a variable name but not everywhere. Or just a typo. Due to the
nature of the language, such bugs can end up consuming significant
time. You do you.

# At the bottom of the script:
# shellcheck disable=SC2034
declare -a  Expect_Fail_Table XOR_Table_4R_4H XOR_Table_8R_4H XOR_Table_12R_12H
# shellcheck disable=SC2034
declare -A  Sample_4R_4H Sample_12R_12H

You would also need this one:

test_sample_sets() {
        local sample_name=$1
        # shellcheck disable=SC2034
        local -n sample_set=$1


> +check_dmesg_results() {
> +        local nr_entries=$1
> +        local expect_failures=${2:-false}  # Optional param, builtin true|false
> +        local log nr_pass nr_fail
> +
> +        log=$(journalctl --reverse --dmesg --since "$log_start_time")

In cxl-translate.sh line 297:
	local log=$(journalctl --reverse --dmesg --since "$log_start_time")
              ^-^ SC2155 (warning): Declare and assign separately to avoid masking return values.

Easily fixed with:
    local log; log=$(journalctl --reverse --dmesg --since "$log_start_time")

This matters for "set -e", see the SC2155 doc.


> +	nr_pass=$(echo "$log" | grep -c "CXL Translate Test.*PASS") || nr_pass=0
> +        nr_fail=$(echo "$log" | grep -c "CXL Translate Test.*FAIL") || nr_fail=0

Mix of tabs and spaces, here and elsewhere (I configured my editor to
show them in a different shade).

> +
> +        if ! $expect_failures; then
> +                # Expect all PASS and no FAIL
> +                [ "$nr_pass" -eq "$nr_entries" ] || err "$LINENO"
> +                [ "$nr_fail" -eq 0 ] || err "$LINENO"
> +        else
> +                # Expect no PASS and all FAIL
> +		[ "$nr_pass" -eq 0 ] || err "$LINENO"
> +                [ "$nr_fail" -eq "$nr_entries" ] || err "$LINENO"
> +        fi

Nit: I would flip the order to avoid the "double" negation (a failure is
generally considered "negative")


No other shell issue spotted.


>    [ 'cxl-qos-class.sh',       cxl_qos_class,      'cxl'   ],
>    [ 'cxl-poison.sh',          cxl_poison,         'cxl'   ],
> +  [ 'cxl-translate.sh',       cxl_translate,      'cxl'   ],
>  ]

Just FYI: this now conflicts with b26e9ae3b1dc. I got very confused
because I was missing a commit and kept looking for the correct
"pending" branch when in fact it's v3 missing a commit, not me.
Also, I forgot how clueless "git am" is. Even "patch" is better.

These lists are a regular source of conflicts when all the activity
always happens at the end. Defining some sort of order (alphabetical or
whatever) reduces the frequency of conflicts considerably.
