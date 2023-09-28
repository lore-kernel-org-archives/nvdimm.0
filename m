Received: from esa5.hc1455-7.c3s2.iphmx.com (esa5.hc1455-7.c3s2.iphmx.com [68.232.139.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A261D6D18
	for <nvdimm@lists.linux.dev>; Thu, 28 Sep 2023 08:45:18 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6600,9927,10846"; a="133449162"
X-IronPort-AV: E=Sophos;i="6.03,183,1694703600"; 
   d="scan'208";a="133449162"
Received: from unknown (HELO oym-r1.gw.nic.fujitsu.com) ([210.162.30.89])
  by esa5.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2023 17:44:06 +0900
Received: from oym-m3.gw.nic.fujitsu.com (oym-nat-oym-m3.gw.nic.fujitsu.com [192.168.87.60])
	by oym-r1.gw.nic.fujitsu.com (Postfix) with ESMTP id 8B498D29E6
	for <nvdimm@lists.linux.dev>; Thu, 28 Sep 2023 17:44:03 +0900 (JST)
Received: from kws-ab3.gw.nic.fujitsu.com (kws-ab3.gw.nic.fujitsu.com [192.51.206.21])
	by oym-m3.gw.nic.fujitsu.com (Postfix) with ESMTP id B51ADD94AB
	for <nvdimm@lists.linux.dev>; Thu, 28 Sep 2023 17:44:02 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by kws-ab3.gw.nic.fujitsu.com (Postfix) with ESMTP id 5640620074716
	for <nvdimm@lists.linux.dev>; Thu, 28 Sep 2023 17:44:02 +0900 (JST)
Received: from [192.168.50.5] (unknown [10.167.234.230])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id 7751C1A0006;
	Thu, 28 Sep 2023 16:44:01 +0800 (CST)
Message-ID: <9c3cbc0c-7135-4006-ad4a-2abce0a556b0@fujitsu.com>
Date: Thu, 28 Sep 2023 16:44:00 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: drop experimental warning for FSDAX
To: Andrew Morton <akpm@linux-foundation.org>,
 Chandan Babu R <chandanbabu@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Dave Chinner
 <david@fromorbit.com>, linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev,
 dan.j.williams@intel.com
References: <20230915063854.1784918-1-ruansy.fnst@fujitsu.com>
 <86167409-aa7f-4db4-8335-3f290d507f14@fujitsu.com>
 <20230926145519.GE11439@frogsfrogsfrogs>
 <ZROC8hEabAGS7orb@dread.disaster.area>
 <20230927014632.GE11456@frogsfrogsfrogs>
 <87fs306zs1.fsf@debian-BULLSEYE-live-builder-AMD64>
 <5c064cbd-13a3-4d55-9881-0a079476d865@fujitsu.com>
 <bc29af15-ae63-407d-8ca0-186c976acce7@fujitsu.com>
 <87y1gs83yq.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20230927083034.90bd6336229dd00af601e0ef@linux-foundation.org>
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
In-Reply-To: <20230927083034.90bd6336229dd00af601e0ef@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-27902.006
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-27902.006
X-TMASE-Result: 10--16.440600-10.000000
X-TMASE-MatchedRID: AyN7oo9wR5uPvrMjLFD6eHchRkqzj/bEC/ExpXrHizxgPgeggVwCFqE/
	TgV/LFqtPXugpBSOS/tBjv8UmknoE9wVQZbwM2zKPKN38CLPK0HjLrHqvAiSy5oM2VEm6bO52d8
	mtRIRsUPQUPfACUPin/IkQ2eSUhawyNkakgF4d97GL//8mlodA6HUCV2g3senYV73FYxzvXKNRC
	PAFosOlAP6HuDcBX9qXLe3NxV6yxRVr+pififhloL5ja7E+OhydmWMDQajOiJXGTbsQqHbkpkQ0
	od6QhJD0Ondu5vpzD5RS7xjEb+dxEX9O+Mf2vo5Ur3GVI65GhYXivwflisSrM1Du0gmimMoeaWW
	afw3eaehrwhaqCksE1+24nCsUSFN+dkjd91LgAC51H80nDYkdw1im+j3Fb6YjoczmuoPCq1xcAm
	TPncMW/s4OuNnUXoJB5c5fmjbPBA8YOxBr9MuoMHNCgc07BBx
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0



在 2023/9/27 23:30, Andrew Morton 写道:
> On Wed, 27 Sep 2023 13:01:25 +0530 Chandan Babu R <chandanbabu@kernel.org> wrote:
> 
>>
>>
>> 在 2023/9/27 13:17, Shiyang Ruan 写道:
>>>
>>> 在 2023/9/27 11:38, Chandan Babu R 写道:
>>>> On Tue, Sep 26, 2023 at 06:46:32 PM -0700, Darrick J. Wong wrote:
>>>>> On Wed, Sep 27, 2023 at 11:18:42AM +1000, Dave Chinner wrote:
>>>>>> On Tue, Sep 26, 2023 at 07:55:19AM -0700, Darrick J. Wong wrote:
>>>>>>> On Thu, Sep 21, 2023 at 04:33:04PM +0800, Shiyang Ruan wrote:
>>>>>>>> Hi,
>>>>>>>>
>>>>>>>> Any comments?
>>>>>>>
>>>>>>> I notice that xfs/55[0-2] still fail on my fakepmem machine:
>>>>>>>
>>>>>>> --- /tmp/fstests/tests/xfs/550.out    2023-09-23
>>>>>>> 09:40:47.839521305 -0700
>>>>>>> +++ /var/tmp/fstests/xfs/550.out.bad    2023-09-24
>>>>>>> 20:00:23.400000000 -0700
>>>>>>> @@ -3,7 +3,6 @@ Format and mount
>>>>>>>    Create the original files
>>>>>>>    Inject memory failure (1 page)
>>>>>>>    Inject poison...
>>>>>>> -Process is killed by signal: 7
>>>>>>>    Inject memory failure (2 pages)
>>>>>>>    Inject poison...
>>>>>>> -Process is killed by signal: 7
>>>>>>> +Memory failure didn't kill the process
>>>>>>>
>>>>>>> (yes, rmap is enabled)
>>>>>>
>>>>>> Yes, I see the same failures, too. I've just been ignoring them
>>>>>> because I thought that all the memory failure code was still not
>>>>>> complete....
>>>>>
>>>>> Oh, I bet we were supposed to have merged this
>>>>>
>>>>> https://lore.kernel.org/linux-xfs/20230828065744.1446462-1-ruansy.fnst@fujitsu.com/
>>
>> FYI, this one is in Andrew's mm-unstable tree:
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/commit/?h=mm-unstable&id=ff048e3e2d167927634a45f4f424338411a1c4e6
> 
> I'll move this into mm-hotfixes so it gets merged into mainline during
> this -rc cycle.

Thanks.  I'll send a new version per Dan's comment.

> 
> Should it be backported into earlier kernels, via a cc:stable?  If so,
> are we able to identify a Fixes: target?

I think this patch is a feature implementation, so it doesn't need to be 
packported.

But please pick the following patch[1] as well, which fixes failures of 
xfs55[0-2] cases.

[1] 
https://lore.kernel.org/linux-xfs/20230913102942.601271-1-ruansy.fnst@fujitsu.com


--
Thanks,
Ruan.

> 
>>
>>>>>
>>>>> to complete the pmem media failure handling code.  Should we (by which I
>>>>> mostly mean Shiyang) ask Chandan to merge these two patches for 6.7?
>>>>>
>>>>
>>>> I can add this patch into XFS tree for 6.7. But I will need Acks
>>>> from Andrew
>>>> Morton and Dan Williams.
>>
>> To clarify further, I will need Acked-By for the patch at
>> https://lore.kernel.org/linux-xfs/20230828065744.1446462-1-ruansy.fnst@fujitsu.com/
> 
> That would be nice.
