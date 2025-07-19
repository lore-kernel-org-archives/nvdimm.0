Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F5C4C97
	for <nvdimm@lists.linux.dev>; Sat, 19 Jul 2025 00:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752884568; cv=none; b=FgPWXONx0tBtnSu01lZ1vOCwUVVljPfkQ02DjqDluDLW6Xj73FWxbFQlVsSE2wZrv+bhmhielTsXc3hX1AWDVbNXhtKhCnEB11CZZRNNS9rykU3pS/GgbsNmPGn/ghDpwS3K/flR+wk8eifQKyKghXtWVq9SzH46Y6CjczQieJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752884568; c=relaxed/simple;
	bh=C4yygJk6wzVIzXO6ZFWUXwtlhhu1Hrldk+dDl9nfI9g=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=JWEgug9A5vvsPQXZkzoUGwIhHBLfCIXMghWNLSO9K/3sHRUSfHhlMp3vxtCSCVUTAPveTbaak5Qmx/h3EfEe8/oGiiUNjr1KWOCFoGtDf8i/MP98q1yO3Pinbviz+zS6HWAA+KzFFwjDi7Vx9s0hU+g1dyOjIOQ575a5zm8M2bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MN9xqSDb; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MN9xqSDb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752884567; x=1784420567;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=C4yygJk6wzVIzXO6ZFWUXwtlhhu1Hrldk+dDl9nfI9g=;
  b=MN9xqSDbActmRIcdUaVIsP7fLKdnrMVkubB4yCjEf4DMvvJRhmipoMFM
   TOoFbIfOI1aI/OtrWwkwGCzv1PVNOJIrt09uxJkF/hX/51kyZrbCcEM59
   Gs7DG1DRGhKj46nPXjwt+6ANrxZvgsSJ9K+yPXm4QOzRXyLLOaufJ+NP0
   wO0tQFAlAoCyCTwjmm9g7y3NlPsMv7at+Dj5JUIIQ1G7hb8KSf8CCB/s0
   9f+Hv17Rt42SvaAXP8trbDg2N4ZzWFZfnQZAXdVOP/VhUcxMHUTfTHkhH
   Kcfjkin2402oiZvl3xpa0XhCE/7dMM1O1FPBtrULFZi9MWezahEemi3r8
   g==;
X-CSE-ConnectionGUID: NafE2KACSlyPIrM6H5+KqQ==
X-CSE-MsgGUID: 5gespAKlTfS3B3sVIHUa4w==
X-IronPort-AV: E=McAfee;i="6800,10657,11496"; a="65754229"
X-IronPort-AV: E=Sophos;i="6.16,323,1744095600"; 
   d="scan'208";a="65754229"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2025 17:22:46 -0700
X-CSE-ConnectionGUID: losTUOh2QDKn7T9+EE7A+w==
X-CSE-MsgGUID: 1DfLObWrSFedIvQ6uCLvhQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,323,1744095600"; 
   d="scan'208";a="158018845"
Received: from unknown (HELO [10.98.32.73]) ([10.98.32.73])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2025 17:22:46 -0700
Message-ID: <f48fa892-d8a2-4917-98f7-9481983934aa@linux.intel.com>
Date: Fri, 18 Jul 2025 17:22:36 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH v3 2/2] test: fail on unexpected kernel error &
 warning, not just "Call Trace"
To: dan.j.williams@intel.com, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, alison.schofield@intel.com
References: <20250611235256.3866724-1-marc.herbert@linux.intel.com>
 <20250611235256.3866724-3-marc.herbert@linux.intel.com>
 <6871ad33d0733_1d3d1007e@dwillia2-xfh.jf.intel.com.notmuch>
Content-Language: en-GB
From: Marc Herbert <marc.herbert@linux.intel.com>
In-Reply-To: <6871ad33d0733_1d3d1007e@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Thanks Dan for the thorough review, appreciated and...  unfortunately
rare, especially for shell scripts!

On 2025-07-11 17:32, dan.j.williams@intel.com wrote:
> marc.herbert@ wrote:
>> So, leverage log levels for the PASS/FAIL decision.  This catches all
>> issues and not just the ones printing Call Traces.
>>
>> Add a simple way to exclude expected warnings and errors, either on a
>> per-test basis or globally.
>>
>> Add a way for negative tests to fail when if some expected errors are
>> missing.
>
> Each subsequent "Add" in a changelog is usually an opportunity to split
> the patch into smaller digestable pieces.

As I explained in the cover letter, the problem is: testing. While
logically independent, it's in practice impossible to thoroughly test
these changes independently of each other. That's OK; I'll keep
performing thorough testing in my workspace and I will also make sure no
single, smaller commit introduces any regression in this particular
check_dmesg() area. The current bar is pretty low in this specific
check_dmsg() area so this shouldn't be a problem.

So, in v4 I will submit only the switch from SECONDS to NDTEST_START.
It's 1. logically coming first 2. low risk, low stakes and low
contention. 3. almost half the code: it will be nice to get all that out
of the way.

For that reason, I will for now answer only your comments below that are
related to this first NDTEST_START commit and (preciously) keep your
other comments for a later reply.


>> Stop relying on the magic and convenient but inaccurate $SECONDS bash
>> variable because its precision is (surprise!) about 1 second. In the
>> first version of this patch, $SECONDS was kept and working but it
>> required a 1++ second long "cooldown" between tests to isolate their
>> logs from each other. After dropping $SECONDS from journalctl, no
>> cooldown delay is required.

>>  
>> +time_init()
>> +{
>> +	test "$SECONDS" -le 1 || err 'test/common must be included first!'
>> +	# ... otherwise NDTEST_START is inaccurate
> 
> What is this protecting against... that the test makes sure that
> NDTEST_START happens before any error might have been produced?

Yes - and more generally speaking that no test log will be missing, and
also making sure the test anchors are accurate.


> I think the proposed anchors make this easily debuggable, there are no
> tests that include test/common late, as evidenced by no fixups for this
> in this patch.

There is none now but it's really not that hard to imagine someone
wanting to do random stuff before sourcing test/common. This was not an
issue with $SECONDS and without log anchors; it is one now.

Also, this is just one very simple line; costs practically nothing.

>> +	NDTEST_START=$(LC_TIME=C date '+%F %T.%3N')
>> +
>> +	# Log anchor, especially useful when running tests back to back
>> +	printf "<5>%s@%ds: sourcing test/common: NDTEST_START=%s\n" \
>> +		"$test_basename" "$SECONDS" "$NDTEST_START" > /dev/kmsg
> 
> Why is SECONDS here?

Because test duration is more user-friendly that manually substracting
timestamps; all sorts of people read logs when tests fail and they may
not automatically know that "sourcing common" implies SECONDS is 0 or 1;
it is consistent with other log statements using SECONDS too; it takes
almost no space in the logs; in case the check above gets dropped, this
can become even more useful.

Generally speaking, there is rarely ever "too much" information in
failure logs, only too much "volume" - and SECONDS takes practically
zero space.

> Note that there are some non-shell tests in the suite, not for CXL, but
> might want to make this consistent by following on with wrapping those
> tests in a script.

Good idea!

> Is there a mechanism to opt-out of errors and warnings. Sometimes
> upstream gets overzealous with chatty dmesg and it would be nice to
> quickly check if tests otherwise pass with ignoring messages. Then go
> spend the time to track down new messages tripping up the test.

Good idea (after NDTEST_START).

>> +# notice level to give some information without flooding the (single!)
>> +# testlog.txt file
>> +journalctl_notice()
>> +{
>> +	( set +x;
>> +	  printf ' ------------ More verbose logs at t=%ds ----------\n' "$SECONDS" )
>> +	journalctl -b --no-pager -o short-precise -p notice --since "-$((SECONDS*1000 + 1000)) ms"
> 
> Why is SECONDS here and not NDTEST_START?

Because this is approximative (+1000) to give a bit more background and
it's easier to do math on SECONDS in shell scripts than on timestamps.


>>  # $1: line number where this is called
>>  check_dmesg()
>>  {
>> -	# validate no WARN or lockdep report during the run
>> +	local _e_kmsg_no_fail_on=()
>> +	for re in "${kmsg_no_fail_on[@]}" "${kmsg_fail_if_missing[@]}"; do
>> +		_e_kmsg_no_fail_on+=('-e' "$re")
>> +	done
>> +
>> +	# Give some time for a complete kmsg->journalctl flush + any delayed test effect.
>>  	sleep 1
> 
> Feels magical.

It's a "sleep" so it is magical. That does not automatically make it
bad.

> The sleep was only there to make sure that SECONDS rolls over.

The purpose is a bit different now, funny that git diff matched it.

> If a test has delayed effects there is no hard guarantee that 1
> second is sufficient.

There is no such hard guarantee but testing can only prove the existence
of bugs, not their absence. It's not an exact science. This sleep 1 does
not help with effects delayed more than 1s, but it does help with all
delayed effects shorter 1s and that is useful. So, why 1s specifically?
Because 1s is a short time for humans and for most tests in this suite
while being a very long time for computers - plenty enough time for many
timers to expire and for journalctl to get all kernel messages. I can
make it 0.5s, that should work too and save time when running the whole
suite.


>> +	# Log anchor, especially useful when running tests back to back
> 
> This comment is going to go stale, I do not think it helps with
> understanding the implementation.

Sorry, I don't see what specific part could go stale in this
one... Could you elaborate?


>> +	printf "<5>%s@%ds: test/common: check_dmesg() OK\n" "$test_basename" "$SECONDS" > /dev/kmsg
> 
> I like this, I have long wanted anchors in the log for coordinating
> messages.
> 
>> +
>> +	if "$NDTEST_LOG_DBG"; then
>> +	    log_stress from_check_dmesg
>> +	fi
>> +}
>> +# Many tests don't use check_dmesg() (yet?) so double down here. Also, this
> 
> A comment like this belongs in the changelog, not the code. I don't want
> review later patches fixing up the "(yet?)", a comment should help
> understand the present, not comment on some future state.

I will rephrase.


>> +# runs later which is better. But before using this make sure there is
>> +# still no test defining its own EXIT trap.
> 
>> +if "$NDTEST_LOG_DBG"; then
>> +    trap 'log_stress from_trap' EXIT
>> +fi
>> +
>> +log_stress()
>> +{
>> +	printf '<3>%s@%ds: NDTEST_LOG_DBG; trying to break the next check_dmesg() %s\n' \
>> +		"$test_basename" "$SECONDS" "$1" > /dev/kmsg
>>  }

