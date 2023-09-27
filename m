Received: from esa3.hc1455-7.c3s2.iphmx.com (esa3.hc1455-7.c3s2.iphmx.com [207.54.90.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581B42C80
	for <nvdimm@lists.linux.dev>; Wed, 27 Sep 2023 06:40:14 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6600,9927,10845"; a="133785781"
X-IronPort-AV: E=Sophos;i="6.03,179,1694703600"; 
   d="scan'208";a="133785781"
Received: from unknown (HELO yto-r1.gw.nic.fujitsu.com) ([218.44.52.217])
  by esa3.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2023 15:39:03 +0900
Received: from yto-m3.gw.nic.fujitsu.com (yto-nat-yto-m3.gw.nic.fujitsu.com [192.168.83.66])
	by yto-r1.gw.nic.fujitsu.com (Postfix) with ESMTP id 1684DDB3C1
	for <nvdimm@lists.linux.dev>; Wed, 27 Sep 2023 15:39:01 +0900 (JST)
Received: from kws-ab3.gw.nic.fujitsu.com (kws-ab3.gw.nic.fujitsu.com [192.51.206.21])
	by yto-m3.gw.nic.fujitsu.com (Postfix) with ESMTP id 44374F942
	for <nvdimm@lists.linux.dev>; Wed, 27 Sep 2023 15:39:00 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by kws-ab3.gw.nic.fujitsu.com (Postfix) with ESMTP id C7A6820050184
	for <nvdimm@lists.linux.dev>; Wed, 27 Sep 2023 15:38:59 +0900 (JST)
Received: from [192.168.50.5] (unknown [10.167.234.230])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id 025491A0085;
	Wed, 27 Sep 2023 14:38:58 +0800 (CST)
Message-ID: <bc29af15-ae63-407d-8ca0-186c976acce7@fujitsu.com>
Date: Wed, 27 Sep 2023 14:38:58 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: drop experimental warning for FSDAX
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: Chandan Babu R <chandanbabu@kernel.org>,
 "Darrick J. Wong" <djwong@kernel.org>, Dave Chinner <david@fromorbit.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev,
 dan.j.williams@intel.com
References: <20230915063854.1784918-1-ruansy.fnst@fujitsu.com>
 <86167409-aa7f-4db4-8335-3f290d507f14@fujitsu.com>
 <20230926145519.GE11439@frogsfrogsfrogs>
 <ZROC8hEabAGS7orb@dread.disaster.area>
 <20230927014632.GE11456@frogsfrogsfrogs>
 <87fs306zs1.fsf@debian-BULLSEYE-live-builder-AMD64>
 <5c064cbd-13a3-4d55-9881-0a079476d865@fujitsu.com>
In-Reply-To: <5c064cbd-13a3-4d55-9881-0a079476d865@fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-27900.005
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-27900.005
X-TMASE-Result: 10--12.536600-10.000000
X-TMASE-MatchedRID: 6Yvl3or3fgqPvrMjLFD6eHchRkqzj/bEC/ExpXrHizy5kqGQ38oKZjya
	5RyZT3SuGLyzmhOFRR1UdjhO4CbFI3WyP3H7wTYlxvp0tuDMx3kQhNjZQYyI3N9RlPzeVuQQqxc
	e4As9TzooUuy27qkKYsttSogzyLqm38rWKQkiws61PiMh4ZF39coioCrSMgeKtwi3bXRtaAg8uU
	Oyc6CId7ZL+//Kmaih87XizC8jrNGeTALXPNvL0oL5ja7E+OhykLrDv6wzGo8CGfvnVpx+2xhBv
	WgZlX+8585VzGMOFzABi3kqJOK62b+/RSFMoL2cxEHRux+uk8h+ICquNi0WJLWqEa3+mgunhH0y
	J8k7g5ftWK88CUPdX6Ma4kn01jEOftwZ3X11IV0=
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0



在 2023/9/27 13:17, Shiyang Ruan 写道:
> 
> 
> 在 2023/9/27 11:38, Chandan Babu R 写道:
>> On Tue, Sep 26, 2023 at 06:46:32 PM -0700, Darrick J. Wong wrote:
>>> On Wed, Sep 27, 2023 at 11:18:42AM +1000, Dave Chinner wrote:
>>>> On Tue, Sep 26, 2023 at 07:55:19AM -0700, Darrick J. Wong wrote:
>>>>> On Thu, Sep 21, 2023 at 04:33:04PM +0800, Shiyang Ruan wrote:
>>>>>> Hi,
>>>>>>
>>>>>> Any comments?
>>>>>
>>>>> I notice that xfs/55[0-2] still fail on my fakepmem machine:
>>>>>
>>>>> --- /tmp/fstests/tests/xfs/550.out    2023-09-23 09:40:47.839521305 
>>>>> -0700
>>>>> +++ /var/tmp/fstests/xfs/550.out.bad    2023-09-24 
>>>>> 20:00:23.400000000 -0700
>>>>> @@ -3,7 +3,6 @@ Format and mount
>>>>>   Create the original files
>>>>>   Inject memory failure (1 page)
>>>>>   Inject poison...
>>>>> -Process is killed by signal: 7
>>>>>   Inject memory failure (2 pages)
>>>>>   Inject poison...
>>>>> -Process is killed by signal: 7
>>>>> +Memory failure didn't kill the process
>>>>>
>>>>> (yes, rmap is enabled)
>>>>
>>>> Yes, I see the same failures, too. I've just been ignoring them
>>>> because I thought that all the memory failure code was still not
>>>> complete....
>>>
>>> Oh, I bet we were supposed to have merged this
>>>
>>> https://lore.kernel.org/linux-xfs/20230828065744.1446462-1-ruansy.fnst@fujitsu.com/

FYI, this one is in Andrew's mm-unstable tree:

https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/commit/?h=mm-unstable&id=ff048e3e2d167927634a45f4f424338411a1c4e6


--
Thanks,
Ruan.

>>>
>>> to complete the pmem media failure handling code.  Should we (by which I
>>> mostly mean Shiyang) ask Chandan to merge these two patches for 6.7?
>>>
>>
>> I can add this patch into XFS tree for 6.7. But I will need Acks from 
>> Andrew
>> Morton and Dan Williams.
> 
> Thanks!  And this patch[1] fixes these 3 cases (xfs/55[0-2]).  Please 
> add this one as well.
> 
> [1]: 
> https://lore.kernel.org/linux-xfs/20230913102942.601271-1-ruansy.fnst@fujitsu.com
> 
> -- 
> Ruan.
> 
>>
