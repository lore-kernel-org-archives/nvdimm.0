Received: from esa2.hc1455-7.c3s2.iphmx.com (esa2.hc1455-7.c3s2.iphmx.com [207.54.90.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1A813698B
	for <nvdimm@lists.linux.dev>; Tue, 27 Feb 2024 09:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.54.90.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709027453; cv=none; b=BvVnG29eoaYGIsij8NkGezvibTnCJPVxcowmeciaC4sZAZqE/UTsRJYIB7GX5cR3UjUP7nYxVTPyKshRxp0PIys8R3dixubK1+VZUFCE/QoZmiSw49gjx1UTUCQRtY7AZlIUuMOnbRPhGRL5UEQ3X07svdrPN3uzycnCDZ47e/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709027453; c=relaxed/simple;
	bh=SMp8UFsNCc3/5RyXDnNJdwhjJJY0E33Z+x2ayDxXCkE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n+dNfCn4qws5hCwfm8pCrxB8+NfRpLZ5jSusRJZpSAbo7cG36W/37+rKDLmpmX59iFYcTN5bDHZVSSk58lkh3v2TEJ5pTwpPEtCXHNEgJEHV8SDY0S2RuWUhqLkBVUo6CVu1Q8x/OJwQzKCLm3ou06YhwTuIBOihCMX8wC1Vg/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=OiZoQcnz; arc=none smtp.client-ip=207.54.90.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="OiZoQcnz"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1709027451; x=1740563451;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=SMp8UFsNCc3/5RyXDnNJdwhjJJY0E33Z+x2ayDxXCkE=;
  b=OiZoQcnzxPV4UeSte7zo2XnAVEMbkkuBBZME9QuWmdoOLG4Z1P040mkg
   DvLJ2AQ0Rohgs9J3QPJr+Bt1fWIHFzh4H7iMw8MLYl+T/BZo7enbZ15g1
   4Z0GXxnhDp86NnjMPHWNStL70krR6d/jmS2uUnadmdNbPmUsyhagA/GU4
   Y9uuddq+2D+96XRjRx/DD31GRqFZvArPhoh9NUtxI/DzS44DSSEtdEyk9
   InGKXuCqWVaxzdr3B3VIyYQt7QnKhZKlPR8Qx5Z1rK5U5z1Q14X0OUcr/
   M/w89HtihMN4pDdgg1mlTKTEE2Px2tvFukR/kFfrulc/U/D0lx8ZDmCiz
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="150564808"
X-IronPort-AV: E=Sophos;i="6.06,187,1705330800"; 
   d="scan'208";a="150564808"
Received: from unknown (HELO yto-r4.gw.nic.fujitsu.com) ([218.44.52.220])
  by esa2.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2024 18:50:47 +0900
Received: from yto-m4.gw.nic.fujitsu.com (yto-nat-yto-m4.gw.nic.fujitsu.com [192.168.83.67])
	by yto-r4.gw.nic.fujitsu.com (Postfix) with ESMTP id 1F8E3D3EAF
	for <nvdimm@lists.linux.dev>; Tue, 27 Feb 2024 18:50:45 +0900 (JST)
Received: from kws-ab3.gw.nic.fujitsu.com (kws-ab3.gw.nic.fujitsu.com [192.51.206.21])
	by yto-m4.gw.nic.fujitsu.com (Postfix) with ESMTP id 627FBD506C
	for <nvdimm@lists.linux.dev>; Tue, 27 Feb 2024 18:50:44 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by kws-ab3.gw.nic.fujitsu.com (Postfix) with ESMTP id E4A8F2008FF89
	for <nvdimm@lists.linux.dev>; Tue, 27 Feb 2024 18:50:43 +0900 (JST)
Received: from [192.168.50.5] (unknown [10.167.226.114])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id D49461A006A;
	Tue, 27 Feb 2024 17:50:42 +0800 (CST)
Message-ID: <cb205046-d0d6-40cc-8359-60685fe37908@fujitsu.com>
Date: Tue, 27 Feb 2024 17:50:42 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: drop experimental warning for FSDAX
To: Dan Williams <dan.j.williams@intel.com>,
 "Darrick J. Wong" <djwong@kernel.org>, Bill O'Donnell <bodonnel@redhat.com>,
 chandan.babu@oracle.com
Cc: linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev
References: <20230915063854.1784918-1-ruansy.fnst@fujitsu.com>
 <ZaAeaRJnfERwwaP7@redhat.com> <20240112022110.GP722975@frogsfrogsfrogs>
 <d205949b-27ed-4bf3-bfc1-31b13eed3b9f@fujitsu.com>
 <65dcc327f2e61_2bce929418@dwillia2-mobl3.amr.corp.intel.com.notmuch>
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
In-Reply-To: <65dcc327f2e61_2bce929418@dwillia2-mobl3.amr.corp.intel.com.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-28216.006
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-28216.006
X-TMASE-Result: 10--16.439700-10.000000
X-TMASE-MatchedRID: 6Yvl3or3fgqPvrMjLFD6eCkMR2LAnMRp2q80vLACqaeqvcIF1TcLYANw
	091XoRE6WJBPIRIrBsgJKoJfwgWhzfN4L4izsa/ksDpn40N9M3nDAPSbMWlGt7iZ9kaBJryyQiO
	PAdln32kxRNoNs3rgHx0WpAOlOOYvKCGE/H289cG8coKUcaOOvSu3H/wZaHmbEDnWZT9yUvONRC
	PAFosOlLfVElO3d2YLOPOr7Hp7We8B90FcL1q4MBF4zyLyne+AfS0Ip2eEHnxlgn288nW9IM4WI
	FQPE2cOtwKUvHHyXGXdB/CxWTRRu/558CedkGIvqcoAhihTwvh9aCDfozCbh5OtLG3s5HGR7nsn
	pCqLAbEXmeYh6Ckt4m47Fejfs51J
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0



在 2024/2/27 0:58, Dan Williams 写道:
> Shiyang Ruan wrote:
>>
>>
>> 在 2024/1/12 10:21, Darrick J. Wong 写道:
>>> On Thu, Jan 11, 2024 at 10:59:21AM -0600, Bill O'Donnell wrote:
>>>> On Fri, Sep 15, 2023 at 02:38:54PM +0800, Shiyang Ruan wrote:
>>>>> FSDAX and reflink can work together now, let's drop this warning.
>>>>>
>>>>> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
>>>>
>>>> Are there any updates on this?
>>>    
>>> Remind us to slip this in for 6.8-rc7 if nobody complains about the new
>>> dax functionality. :)
>>
>> Hi,
>>
>> I have been running tests on weekly -rc release, and so far the fsdax
>> functionality looks good.  So, I'd like to send this remind since the
>> -rc7 is not far away.  Please let me know if you have any concerns.
> 
> Ruan, thanks for all your effort on this!

It's my pleasure.  Thank you all also for your patience and kind 
guidance. You all helped me a lot.  ヽ(^▽^)ノ


--
Ruan.

> 
> [..]
> 
>>>>> ---
>>>>>    fs/xfs/xfs_super.c | 1 -
>>>>>    1 file changed, 1 deletion(-)
>>>>>
>>>>> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
>>>>> index 1f77014c6e1a..faee773fa026 100644
>>>>> --- a/fs/xfs/xfs_super.c
>>>>> +++ b/fs/xfs/xfs_super.c
>>>>> @@ -371,7 +371,6 @@ xfs_setup_dax_always(
>>>>>    		return -EINVAL;
>>>>>    	}
>>>>>    
>>>>> -	xfs_warn(mp, "DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
>>>>>    	return 0;
> 
> Acked-by: Dan Williams <dan.j.williams@intel.com>
