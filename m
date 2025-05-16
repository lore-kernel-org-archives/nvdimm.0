Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61003232379
	for <nvdimm@lists.linux.dev>; Fri, 16 May 2025 22:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747434903; cv=none; b=m8j3YvQMPjyqwTrsW24RnwLzgNel9PJ5a/VM1vVe+WpMBVA1IwZ29tFp3iGDY2IzUDZ2ra6Uo7Yn22TTzIjGMRISOmERis2IeKYfYWL8AixTY2LaEUfyGz7Gjp0Tc4A43C3vztkDqlQk2X7rUnipowuoiExrPZV5xRUSoW1R6YU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747434903; c=relaxed/simple;
	bh=sodnoNWxSebjqwsyt2Torgdv1eT/Kqgp5Dz1D52Uw0M=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:References:
	 In-Reply-To:Content-Type; b=Glz8egik3hbzgKsN/2Irs8htZ9yAhaT7Qn2ThE5jUkhCVKEgOa4487sTdbw1YCwNyB/taMXQQbPXk28qKD0znoEXmSxGzFaq+Kp+8T0Kn6By5+hpgnxu7xeJIVLeqJT50X3HLprvAAWrILN8b88Pqo6a77+kvR1QBEQSh3Q9JdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BuzWrGu2; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BuzWrGu2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747434901; x=1778970901;
  h=message-id:date:mime-version:from:subject:to:references:
   in-reply-to:content-transfer-encoding;
  bh=sodnoNWxSebjqwsyt2Torgdv1eT/Kqgp5Dz1D52Uw0M=;
  b=BuzWrGu2q2OvIQsJNq+OgC+bnq5BWZff3q/U3JP9acBaeCSEZnSD/HHa
   f8K6IbnJNzPcENGnNVY8TpoKV4WdhYvOH8Nq5rJmY71wQffpq775e5kv6
   Bl1LjcihQDyyCqn55J4qyQMQZ4Le/6RuM0RC7sGZg0raD/M+OBkIKkc50
   oNxz2R69VuwLVxYvsjZwhTaeJSZ1xw+E2MyoYEnneLMdExFWOGndQIclI
   B0GeIFFVK+u7cFPN4KpkKcHBuo9RsdRuDlsetrWIMupCccabJRHjCLJAv
   X8XGyonyWiA+jP5k6R19tGMrobgSZm9S3dr8rowgMG23L3sfH6ExLeYu4
   Q==;
X-CSE-ConnectionGUID: 6thK1a26QFG4qzVGC5CQVA==
X-CSE-MsgGUID: HqroR+VaR6a+6F9QM/PIfg==
X-IronPort-AV: E=McAfee;i="6700,10204,11435"; a="60056715"
X-IronPort-AV: E=Sophos;i="6.15,295,1739865600"; 
   d="scan'208";a="60056715"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 15:35:00 -0700
X-CSE-ConnectionGUID: I/u7kHU8Q+iOR9Y9s1oGPA==
X-CSE-MsgGUID: Yr5Nq4fUQ1CUQ/xx/AeMmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,295,1739865600"; 
   d="scan'208";a="144060980"
Received: from rkbains1-mobl.amr.corp.intel.com (HELO [10.125.225.63]) ([10.125.225.63])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 15:35:00 -0700
Message-ID: <15a03474-57f8-43ad-97be-ee986e796df0@linux.intel.com>
Date: Fri, 16 May 2025 15:34:55 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Marc Herbert <marc.herbert@linux.intel.com>
Subject: Re: [ndctl PATCH v2] test/monitor.sh: replace sleep with polling
 after sync
To: Dan Williams <dan.j.williams@intel.com>, alison.schofield@intel.com,
 nvdimm@lists.linux.dev, Li Zhijian <lizhijian@fujitsu.com>
References: <20250516044628.1532939-1-alison.schofield@intel.com>
 <6826d67768427_290329430@dwillia2-xfh.jf.intel.com.notmuch>
Content-Language: en-US
In-Reply-To: <6826d67768427_290329430@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025-05-15 23:08, Dan Williams wrote:
> alison.schofield@ wrote:

>>  
>> +wait_for_logfile_update()
>> +{
>> +	local file="$1"
>> +	local prev_size="$2"
>> +	local timeout=30
>> +	local i=0
>> +
>> +	# prev_size is always zero because start_monitor truncates it.
>> +	# Set and check against it anyway to future proof.
>> +	while [ $i -lt $timeout ]; do
>> +		local new_size=$(stat -c%s "$file" 2>/dev/null || echo 0)
>> +		if [ "$new_size" -gt "$prev_size" ]; then
>> +			return 0
>> +		fi
>> +		sleep 0.1
>> +		i=$((i+1))
>> +	done
>> +
>> +	echo "logfile not updated within 3 seconds"
>> +	err "$LINENO"
> 
> Hmm... not a fan of this open coded "wait for file to change" bash
> function. This feels like something that a tool can do... (searches)
> 
> Does inotifywait fit the bill here?
> 
> https://linux.die.net/man/1/inotifywait

If inotify works, go for it. Blocking is always better than polling.  It
might be tricky because the file does not exist yet. Create an empty
file yourself first, would that work? Probably not if ndctl monitor
creates a brand new file.

If inotify does not work, consider adding to test/common this generic
polling function that lets you poll in bash literally anything:

https://github.com/pmem/run_qemu/pull/177/files

It would require making `prev_size` global which does not look like an
issue to me.

Before adding it run_qemu, that polling function has been used for years
and thousands of runs in
https://github.com/thesofproject/sof-test/blob/main/case-lib/lib.sh
I mean it's been extremely well tested.

Even if you don't need polling here, it's unfortunately fairly common to
have to poll from shell scripts. Why I'm suggesting a test/common
location.

>> +}
>> +
>>  start_monitor()
>>  {
>>  	logfile=$(mktemp)
>>  	$NDCTL monitor -c "$monitor_conf" -l "$logfile" $1 &
>>  	monitor_pid=$!
>> -	sync; sleep 3
>> +	sync
>> +	for i in {1..30}; do
>> +		if ps -p "$monitor_pid" > /dev/null; then
>> +			sleep 0.1
>> +			break
>> +		fi
>> +		sleep 0.1
>> +	done
>> +	if ! ps -p "$monitor_pid" > /dev/null; then
>> +		echo "monitor not ready within 3 seconds"
>> +		err "$LINENO"
>> +	fi
> 
> This does not make sense to. The shell got the pid from the launching
> the executable. This is effectively testing that bash command execution
> works. About the only use I can imagine for this is checking that the
> monitor did not die early, but that should be determined by other parts
> of the test.

Agreed: I'm afraid the only thing this code does is sleeping 0.1s only
once instead of 3s. Because not sleeping at all worked for you, no
surprise a single sleep 0.1 works too.

I suspect the only case where the "for" loop actually iterates is when the
"monitor" process crashes extremely fast, faster than the
"sync". Basically racing with its parent to crash before the latter
notices. That race does not look like a "feature" to me.

I agree this should be replaced by observing side-effects from the
monitor. Dunno what. grep something in the ndctl monitor -v output?


By the way, UNTESTED:

--- a/test/monitor.sh
+++ b/test/monitor.sh
@@ -67,7 +67,19 @@ check_result()
 
 stop_monitor()
 {
-	kill $monitor_pid
+	kill $monitor_pid || die "monitor $monitor_pid was already dead"
+
+	local ret=0
+	timeout 3 wait $monitor_pid || ret=$?
+	case "$ret") in
+	124) # timeout
+		die "monitor $monitor_pid ignored SIGTERM" ;;
+	0|127) # either success or killed fast
+		: ;;
+	*)
+		die "unexpected monitor exit status:$ret" ;;
+	esac
+
 	rm "$logfile"
 }


Something like that...

This is all assuming the monitor does not have any kind of "remote
control"; that would be much better.

I don't know the "monitor", but if it has neither obvious
side-effects nor any kind of "remote control", then it does a "great"
job... getting in the way of tests! :-( Maybe the monitor is what should
be fixed rather than adding shell script "creativity"?
