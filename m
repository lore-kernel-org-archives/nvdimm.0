Received: from esa2.hc1455-7.c3s2.iphmx.com (esa2.hc1455-7.c3s2.iphmx.com [207.54.90.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6800A238152
	for <nvdimm@lists.linux.dev>; Tue, 20 May 2025 03:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.54.90.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747713255; cv=none; b=OnBS3Z3nEE0BEQgqp07IzHNtq4GjZHwnQiSt/UvJUhHJYAmMFsqy3ygOE107jYu62Vv9Bc2gfJWhf5Kh4r+9WluR29Lr55wgFy0nfAMVH8D2JhJs3RNxzyLNfFTvwDTQZqFCdOWwlhkSZ2baCqOXyPsWHm07eJIG45qNSnWgAMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747713255; c=relaxed/simple;
	bh=8Mvcim+aFINZSgDmb2fCLSlpZ3cnd8Yzlx+bS5idMsQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gc1KLYymz+Lf1nJN08xk3+zJDWfXClgsOra+soTkaH13obJ4N8kM/mQoBRbb7LbrU6nrT+5Xia3KDPrWdwPsSY5ZElyN+oKghIj8KyNAGSEtFXIKF9IY2B3doj9dYXOy+1QE5AvEat5PemVoD+5pNn7m7Zf2mMtbDzzoPKkGQoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=Cbz4VEOL; arc=none smtp.client-ip=207.54.90.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="Cbz4VEOL"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1747713253; x=1779249253;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=8Mvcim+aFINZSgDmb2fCLSlpZ3cnd8Yzlx+bS5idMsQ=;
  b=Cbz4VEOLfKSV35l59ExWkqAHkaggDLNgYL7DQcfbyn/aIB4KoQ4WrqGP
   P2uTsGqIxu5AzLItNUTU0P//c7rqx9QzbTT9EM13XZN6hBmruCGnz0cSF
   u3BjQLZIWLTJDd5W3noVIruw1LkLMJdm5asKgViwiXfm1ulSqFZ6k10P2
   j58FZ4sbpKJegQB1UE0VsPQUtiIPzpHV3K09Gsz2lVvcMlhnE6eRmq48w
   l5HU53ms7cHSX+Ah+U1TBatu8DC0Qoy6r0TArjDqxwVle2miQBQm5cDvg
   Lr/5opF3QF0AoMCataPi9qXox5xtRDlqvPAt9JI8rQx1iyWE9cXjdFPpi
   w==;
X-CSE-ConnectionGUID: /08mkNbDTcyQ9EwGOoKTIw==
X-CSE-MsgGUID: k7rswkOqQjyB552ofoN4cg==
X-IronPort-AV: E=McAfee;i="6700,10204,11438"; a="199982299"
X-IronPort-AV: E=Sophos;i="6.15,302,1739804400"; 
   d="scan'208";a="199982299"
Received: from unknown (HELO yto-r4.gw.nic.fujitsu.com) ([218.44.52.220])
  by esa2.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 12:54:10 +0900
Received: from yto-m1.gw.nic.fujitsu.com (yto-nat-yto-m1.gw.nic.fujitsu.com [192.168.83.64])
	by yto-r4.gw.nic.fujitsu.com (Postfix) with ESMTP id 95A0ED5010
	for <nvdimm@lists.linux.dev>; Tue, 20 May 2025 12:54:08 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by yto-m1.gw.nic.fujitsu.com (Postfix) with ESMTP id 51D41CFBDF
	for <nvdimm@lists.linux.dev>; Tue, 20 May 2025 12:54:08 +0900 (JST)
Received: from [192.168.22.105] (unknown [10.167.135.81])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id 54DBF1A0071;
	Tue, 20 May 2025 11:54:07 +0800 (CST)
Message-ID: <741d99d9-4a42-4ce1-aca5-1112f7f39229@fujitsu.com>
Date: Tue, 20 May 2025 11:54:07 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] test/cxl-xor-region.sh: remove redundant waitting
To: Alison Schofield <alison.schofield@intel.com>
Cc: linux-cxl@vger.kernel.org, dan.j.williams@intel.com,
 vishal.l.verma@intel.com, sunfishho12@gmail.com, nvdimm@lists.linux.dev
References: <20250514112003.2150272-1-ruansy.fnst@fujitsu.com>
 <aCev83lpHZlsYV1d@aschofie-mobl2.lan>
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
In-Reply-To: <aCev83lpHZlsYV1d@aschofie-mobl2.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2025/5/17 5:36, Alison Schofield 写道:
> On Wed, May 14, 2025 at 07:20:03PM +0800, ruansy.fnst wrote:
>> From: Ruan Shiyang <ruansy.fnst@fujitsu.com>
>>
>> Now that cxl_wait_probe() has been added[1] to wait for udev queue
>> empty, the `udevadm settle` here is no longer necessary.
>>
>> [1] b231603 cxl/lib: Add cxl_wait_probe()
>>
>> Signed-off-by: Ruan Shiyang <ruansy.fnst@fujitsu.com>
> 
> Reviewed-by: Alison Schofield <alison.schofield@intel.com>
> 
> Hi Ruan, It looks like I snuck this one in right before Dan introduced
> udevadm settle and cleaned up all the usages. I'll take this patch as
> is. The next time you patch ndctl, do these:
> 
> [PATCH] --> [ndctl PATCH]
> Send to nvdimm@lists.linux.dev and 'cc linux-cxl@vger.kernel.org
> if it's CXL related like this one.

OK, got it.  I'll add 'ndctl' tag and cc nvdimm&cxl ml next time. 
Thanks for pointing out.

> 
> I suggest you resend this udev question in a new email to linux-cxl
> list to draw attention.

OK.  The lucky thing is that they have noticed this and started discussion.

> 
> Thanks for the patch!

--
Thanks,
Ruan.

> 
>>
>> ===
>> Question to Dan:
>>
>> I understand how cxl_wait_probe() work, but I have some questions about
>> the motivation of adding this function:  Firstly, is it function added
>> for simply waiting for new added CXL device been ready before cxl
>> command does the actual work?  Just for replacing `udevadm settle`'s
>> work?
>>
>> Now I am facing a problem that cxl command takes a long time to complete
>> when I run it in a udev rule(do some configuration when CXL memdev is
>> added).  I found it is caused by this function: waitting for udev
>> queue's endding but itself is in the queue.  The cxl_wait_probe()
>> function does not seem to allow me to do that.  So, the 2nd question is:
>> is it against the spec to run cxl command in a udev rule?
>> ====
>> ---
>>   test/cxl-xor-region.sh | 1 -
>>   1 file changed, 1 deletion(-)
>>
>> diff --git a/test/cxl-xor-region.sh b/test/cxl-xor-region.sh
>> index b9e1d79..fb4f9a0 100644
>> --- a/test/cxl-xor-region.sh
>> +++ b/test/cxl-xor-region.sh
>> @@ -14,7 +14,6 @@ check_prereq "jq"
>>   
>>   modprobe -r cxl_test
>>   modprobe cxl_test interleave_arithmetic=1
>> -udevadm settle
>>   rc=1
>>   
>>   # THEORY OF OPERATION: Create x1,2,3,4 regions to exercise the XOR math
>> -- 
>> 2.43.0
>>
>>
