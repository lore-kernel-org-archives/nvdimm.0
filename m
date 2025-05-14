Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3CC315533F
	for <nvdimm@lists.linux.dev>; Wed, 14 May 2025 22:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747260852; cv=none; b=Z8eW+CuIRvH8vcyHZVRssLOwCnxKJrVWheFrJ4LQGzWGUwhhzjMY0ujm3isnD5YI4v6/NiS5ueRMQdPWN573uvMvNPY8ZIYG0jug5/+d2YnMxAfunJjM1gn7KxgKDdlG5qGxFSsORNX/Lspibwsx2pMMEmG0rJQQ3krpnTv8XUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747260852; c=relaxed/simple;
	bh=ZYrcq6mvSJvE6H94r6spgVGvIMJNJItVcaUcCy5Azt0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=KZuWuAs6PAT25RubjcGLfd3x/2LiN9SpSGkmaj+3hhpmpSCE9DdpW/XLypEhZjnLWymbjWjQ3oSe4sSBYOGQ0vYNTlep3aHe6qDqwAQq9HGgJX8ygmjLquNmL93vp7O/w1ZYtnAu0uUW4szSp+bvC1I4mfnldTQ7KxVs+8r1SDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JVAIJbOj; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JVAIJbOj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747260850; x=1778796850;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=ZYrcq6mvSJvE6H94r6spgVGvIMJNJItVcaUcCy5Azt0=;
  b=JVAIJbOjJgK1G/Pxn5SwBgLgHuswDXOAm/HHynO0F8Ss+NiWz3ZgIRhS
   0EDYHUQEz8HVZmzFRSMpGjz8aEsuNU0IsuSsmAZGEcCDZeCUbjQXCU3D3
   5ldXVmS2QUJdm0KWGpUT/DidvBQWly8XDl91YjZc8PyenLHoblDn8Rgui
   AJ+nRx9dMCylp6HDj6MYZNhb5uL1Zhvih6/gW0G7QgT+UVuHxIzrJQRNb
   6Jh+ID0HoXLsWyOI6DcN1PlS1yW6vbkw99PkeFfC/IlhiVudl0Vxw941c
   doYb/45CWM83iyACAb69RYNrtXfHwmzdZq8+706ZYuuEHkdwflPigceVx
   Q==;
X-CSE-ConnectionGUID: XBiYAafbTVqiXN4VTuN6Hw==
X-CSE-MsgGUID: s3GqwXH4QUSp4Jl4JM+wcA==
X-IronPort-AV: E=McAfee;i="6700,10204,11433"; a="49343973"
X-IronPort-AV: E=Sophos;i="6.15,289,1739865600"; 
   d="scan'208";a="49343973"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2025 15:14:10 -0700
X-CSE-ConnectionGUID: lIrYOC5uQ7ybjihs2Sm7ig==
X-CSE-MsgGUID: 39r/HRljScKbxf/0rcA66Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,289,1739865600"; 
   d="scan'208";a="138683445"
Received: from brlerfal-mobl.amr.corp.intel.com (HELO [10.125.212.236]) ([10.125.212.236])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2025 15:14:09 -0700
Message-ID: <19c11b39-180d-4f91-8c27-5834f4af17e5@linux.intel.com>
Date: Wed, 14 May 2025 15:14:07 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH] test/monitor.sh: remove useless sleeps
To: alison.schofield@intel.com, nvdimm@lists.linux.dev
References: <20250514014133.1431846-1-alison.schofield@intel.com>
Content-Language: en-US
From: Marc Herbert <Marc.Herbert@linux.intel.com>
In-Reply-To: <20250514014133.1431846-1-alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025-05-13 18:41, alison.schofield@intel.com wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> monitor.sh runs for 50 seconds and spends 48 of those seconds sleeping.
> Removing the sleeps entirely has no effect on the test in this users
> environment. It passes and produces the same test log.
> 
> Experiments replacing sleeps with polling for monitor ready and log file
> updates proved that both are always available following the sync so there
> is no need to replace the sleeps with a more precise or reliable polling
> method. Simply remove the sleeps. Run time is now < 3s.
> 
> I'd especially like to get Tested-by tags on this one to confirm that my
> environment isn't special and that this succeeds elsewhere.

In my configuration, this patch makes the test fail 100% of the time.
It passes 100% of the time without this patch.

Also, it leaves a "ndctl monitor" behind which makes meson hang
forever, believing the test is never done.

Tested on top of current "origin/pending" 1850ddcbcbf9

Marc

nmem6: supported alarms: 0x7
nmem6: set spare threshold: 99
libndctl: do_cmd: bus: 2 dimm: 0x100 cmd: cmd_call:smart_set_thresh status: 0 fw: 0 (success)
nmem6: set mtemp threshold: 11.50
libndctl: do_cmd: bus: 2 dimm: 0x100 cmd: cmd_call:smart_set_thresh status: 0 fw: 0 (success)
nmem6: set ctemp threshold: 12.50
libndctl: do_cmd: bus: 2 dimm: 0x100 cmd: cmd_call:smart_set_thresh status: 0 fw: 0 (success)
nmem6: set thresholds back to defaults
libndctl: do_cmd: bus: 2 dimm: 0x100 cmd: cmd_call:smart_set_thresh status: 0 fw: 0 (success)
libdaxctl: daxctl_unref: context 0x56469566a9d0 released
libndctl: ndctl_unref: context 0x56469566b050 released
+ sync
+ check_result 'nmem4 nmem5 nmem6 nmem7'
++ cat /tmp/tmp.mYY263Hk3f
+ jlog=
++ jq .dimm.dev
++ sort
++ uniq
++ xargs
+ notify_dimms=
+ [[ nmem4 nmem5 nmem6 nmem7 == '' ]]
++ err 65
+++ basename /root/CXL/ndctl/test/monitor.sh
++ echo test/monitor.sh: failed at line 65
test/monitor.sh: failed at line 65
++ '[' -n '' ']'
++ exit 1



> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---
>  test/monitor.sh | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/test/monitor.sh b/test/monitor.sh
> index be8e24d6f3aa..88e253e5df00 100755
> --- a/test/monitor.sh
> +++ b/test/monitor.sh
> @@ -26,7 +26,7 @@ start_monitor()
>  	logfile=$(mktemp)
>  	$NDCTL monitor -c "$monitor_conf" -l "$logfile" $1 &
>  	monitor_pid=$!
> -	sync; sleep 3
> +	sync
>  	truncate --size 0 "$logfile" #remove startup log
>  }
>  
> @@ -49,13 +49,13 @@ get_monitor_dimm()
>  call_notify()
>  {
>  	"$TEST_PATH"/smart-notify "$smart_supported_bus"
> -	sync; sleep 3
> +	sync
>  }
>  
>  inject_smart()
>  {
>  	$NDCTL inject-smart "$monitor_dimms" $1
> -	sync; sleep 3
> +	sync
>  }
>  
>  check_result()

