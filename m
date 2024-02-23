Received: from esa1.hc1455-7.c3s2.iphmx.com (esa1.hc1455-7.c3s2.iphmx.com [207.54.90.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB11E13AED
	for <nvdimm@lists.linux.dev>; Fri, 23 Feb 2024 07:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.54.90.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708673374; cv=none; b=po1CbtXKi7645T4fVYgySnVap0R+9ae/lWXaAdStdiZPk5zPIMDpthEaLm7e22sgh2RA4TqIl2BAtNdn/BVSa7y8rnfs7tL+LkwwWOGYOBYu1n/4Y72SxiHJlKJv5nuht3IRaQmH68/qpFVKe1bDje4WEPiuOsUGUobI9uujy1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708673374; c=relaxed/simple;
	bh=Am7latsxUZsf2ZaVe94u42IlLWXHZ9jFcBzyGL9c47U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n9dapHA7UEjwtS8qQvdKM5V8MQOsLIAGfShvsIBrYgICGlFuMBgemin+xsURBnOCGf70J9PKndLMua+itGUgprDtCN/+qiLpe3y83EbBTH1jjHsSrn/na8Ol4XNzMYUKHmsjz6fqw13O7I7K8589A3J5TN5Bb9VQBJ07kbT6Ymc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=HdlzzP2o; arc=none smtp.client-ip=207.54.90.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="HdlzzP2o"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1708673372; x=1740209372;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Am7latsxUZsf2ZaVe94u42IlLWXHZ9jFcBzyGL9c47U=;
  b=HdlzzP2orKS84KVUMEhnea7q5xvaMUrHWfLiIt1yh2hVOnkPyyUmsn3S
   M2P0/CW+9A+To0ezRR11XM842AIrduOLuqMuHOX7ztR+g+xJbbvPIM3IJ
   eI0crlh4XFF+5nz3Tks2AsM6NJG0qsu9xzh74z0cNz/cECqQWeQL/1OF3
   h5szmVRCy7idN1FpUP46I2tHgm3bJEUm3rwPLMJFgjZmu0sEVagpokVzq
   ioIfbXAU/1n04/pJvOAIkhjHyv53sh5Kvw/iNZpNLVMJ8wa8nBPSIsAHw
   qqyhXMUognG4Wtx/5a5Iye6T3QtfOLADC111ruZvhc+lXXROYm9AMQ3KZ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10992"; a="150067429"
X-IronPort-AV: E=Sophos;i="6.06,179,1705330800"; 
   d="scan'208";a="150067429"
Received: from unknown (HELO yto-r1.gw.nic.fujitsu.com) ([218.44.52.217])
  by esa1.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2024 16:28:19 +0900
Received: from yto-m1.gw.nic.fujitsu.com (yto-nat-yto-m1.gw.nic.fujitsu.com [192.168.83.64])
	by yto-r1.gw.nic.fujitsu.com (Postfix) with ESMTP id EDBAADB5C6
	for <nvdimm@lists.linux.dev>; Fri, 23 Feb 2024 16:28:16 +0900 (JST)
Received: from kws-ab3.gw.nic.fujitsu.com (kws-ab3.gw.nic.fujitsu.com [192.51.206.21])
	by yto-m1.gw.nic.fujitsu.com (Postfix) with ESMTP id 3D57443FC1
	for <nvdimm@lists.linux.dev>; Fri, 23 Feb 2024 16:28:16 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by kws-ab3.gw.nic.fujitsu.com (Postfix) with ESMTP id C9B72200995AA
	for <nvdimm@lists.linux.dev>; Fri, 23 Feb 2024 16:28:15 +0900 (JST)
Received: from [10.193.128.195] (unknown [10.193.128.195])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id EB9F11A006B;
	Fri, 23 Feb 2024 15:28:14 +0800 (CST)
Message-ID: <d205949b-27ed-4bf3-bfc1-31b13eed3b9f@fujitsu.com>
Date: Fri, 23 Feb 2024 15:28:14 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: drop experimental warning for FSDAX
To: "Darrick J. Wong" <djwong@kernel.org>,
 Bill O'Donnell <bodonnel@redhat.com>, chandan.babu@oracle.com
Cc: linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev,
 dan.j.williams@intel.com
References: <20230915063854.1784918-1-ruansy.fnst@fujitsu.com>
 <ZaAeaRJnfERwwaP7@redhat.com> <20240112022110.GP722975@frogsfrogsfrogs>
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
In-Reply-To: <20240112022110.GP722975@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-28208.005
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-28208.005
X-TMASE-Result: 10--13.893700-10.000000
X-TMASE-MatchedRID: qeYWT+AUEkGPvrMjLFD6eHchRkqzj/bEC/ExpXrHizxO5pvXajphX7Bk
	jjdoOP1bIx/OqCk5J10fnhC5GP+KBUvuFx00jSkB/1dEgwtQ6NBF5qVUCGhwT282zvsXichajFK
	/NcS7G4nZyfBL0WvJFyS5HVjZaILduBKKB37nRtovz6alF1rVg1HB9PagRph0twi3bXRtaAi/BR
	68O365bn9eOltIlLtr4yf6Jl3/aOS1n6qzMwyUl54CIKY/Hg3AnCGS1WQEGtB4UhBPLRlvhvsf6
	FkrLr8rC24oEZ6SpSkgbhiVsIMQK2u5XqFPzjITWLAmmsEiLinLOUVTa9BVk4bikWtNUsVHwrIt
	a7cE3NVXm3en/dzILH7cGd19dSFd
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0



在 2024/1/12 10:21, Darrick J. Wong 写道:
> On Thu, Jan 11, 2024 at 10:59:21AM -0600, Bill O'Donnell wrote:
>> On Fri, Sep 15, 2023 at 02:38:54PM +0800, Shiyang Ruan wrote:
>>> FSDAX and reflink can work together now, let's drop this warning.
>>>
>>> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
>>
>> Are there any updates on this?
>   
> Remind us to slip this in for 6.8-rc7 if nobody complains about the new
> dax functionality. :)

Hi,

I have been running tests on weekly -rc release, and so far the fsdax 
functionality looks good.  So, I'd like to send this remind since the 
-rc7 is not far away.  Please let me know if you have any concerns.


--
Thanks,
Ruan.

> 
> --D
> 
>> Thanks-
>> Bill
>>
>>
>>> ---
>>>   fs/xfs/xfs_super.c | 1 -
>>>   1 file changed, 1 deletion(-)
>>>
>>> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
>>> index 1f77014c6e1a..faee773fa026 100644
>>> --- a/fs/xfs/xfs_super.c
>>> +++ b/fs/xfs/xfs_super.c
>>> @@ -371,7 +371,6 @@ xfs_setup_dax_always(
>>>   		return -EINVAL;
>>>   	}
>>>   
>>> -	xfs_warn(mp, "DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
>>>   	return 0;
>>>   
>>>   disable_dax:
>>> -- 
>>> 2.42.0
>>>
>>
>>
> 
