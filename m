Received: from esa11.hc1455-7.c3s2.iphmx.com (esa11.hc1455-7.c3s2.iphmx.com [207.54.90.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CEAC1548A
	for <nvdimm@lists.linux.dev>; Mon,  2 Oct 2023 12:17:13 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6600,9927,10850"; a="113857339"
X-IronPort-AV: E=Sophos;i="6.03,194,1694703600"; 
   d="scan'208";a="113857339"
Received: from unknown (HELO oym-r4.gw.nic.fujitsu.com) ([210.162.30.92])
  by esa11.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2023 21:16:02 +0900
Received: from oym-m4.gw.nic.fujitsu.com (oym-nat-oym-m4.gw.nic.fujitsu.com [192.168.87.61])
	by oym-r4.gw.nic.fujitsu.com (Postfix) with ESMTP id 7C305DDC68
	for <nvdimm@lists.linux.dev>; Mon,  2 Oct 2023 21:15:59 +0900 (JST)
Received: from kws-ab3.gw.nic.fujitsu.com (kws-ab3.gw.nic.fujitsu.com [192.51.206.21])
	by oym-m4.gw.nic.fujitsu.com (Postfix) with ESMTP id AFCEED6308
	for <nvdimm@lists.linux.dev>; Mon,  2 Oct 2023 21:15:58 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by kws-ab3.gw.nic.fujitsu.com (Postfix) with ESMTP id 4E57E2007471D
	for <nvdimm@lists.linux.dev>; Mon,  2 Oct 2023 21:15:58 +0900 (JST)
Received: from [10.193.128.127] (unknown [10.193.128.127])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id 9CDC31A0006;
	Mon,  2 Oct 2023 20:15:57 +0800 (CST)
Message-ID: <ec2de0b9-c07d-468a-bd15-49e83cba1ad9@fujitsu.com>
Date: Mon, 2 Oct 2023 20:15:57 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: drop experimental warning for FSDAX
To: Dan Williams <dan.j.williams@intel.com>,
 Chandan Babu R <chandanbabu@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Dave Chinner
 <david@fromorbit.com>, linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev
References: <20230927014632.GE11456@frogsfrogsfrogs>
 <87fs306zs1.fsf@debian-BULLSEYE-live-builder-AMD64>
 <5c064cbd-13a3-4d55-9881-0a079476d865@fujitsu.com>
 <bc29af15-ae63-407d-8ca0-186c976acce7@fujitsu.com>
 <87y1gs83yq.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20230927083034.90bd6336229dd00af601e0ef@linux-foundation.org>
 <9c3cbc0c-7135-4006-ad4a-2abce0a556b0@fujitsu.com>
 <20230928092052.9775e59262c102dc382513ef@linux-foundation.org>
 <20230928171339.GJ11439@frogsfrogsfrogs>
 <99279735-2d17-405f-bade-9501a296d817@fujitsu.com>
 <651718a6a6e2c_c558e2943e@dwillia2-xfh.jf.intel.com.notmuch>
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
In-Reply-To: <651718a6a6e2c_c558e2943e@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-27910.006
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-27910.006
X-TMASE-Result: 10--21.262000-10.000000
X-TMASE-MatchedRID: gJMUAIY29lmPvrMjLFD6eCkMR2LAnMRp2q80vLACqaeqvcIF1TcLYPQk
	JPC+p/jdAYsmNBEx4IrUw09eu4b0WF0ieHN50/kHrMZ+BqQt2Np0bXWCb2qGLplPg3vfYMxrAMJ
	cHOzzDuO+8e7hYIm6IkOR8gDRpJrLHlH0AvHWpb0LuM9syeC5MEWGJun24Wb1y8ftIFhtAGTDfK
	dkuIjTgo98knPshr36LufzK+NHpVJNCWJ8tjWueb0M+sraRHyc3AJrtcannrbW2YYHslT0IyNMv
	5a0AeBD0pAKXvyiClld/cyqXfP9LhELe2nKwTwA9k5nZzZVBSBOGffsUU/kDWDqvWq9NNyFzv0+
	UmYCZcOd0PCdDanA+oqCCvv09QBUe4rShPdcdTZOG5AmSMA4vpfau+Sc1iUTbkvAJoOQ99k/xU1
	AZY+Qo5Bze/7xX8D++Dq5+AB/HWILv9prS13Llsaw71DJbaIElDt5PQMgj035V4X/65Dwb7rmvh
	de36c4lxPsRwiY5LwoBEe6aSUEd3AA9eFj9SfYngIgpj8eDcBZDL1gLmoa/OYq7Exe0AIo+x/oW
	SsuvysLbigRnpKlKT4yqD4LKu3A
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0



在 2023/9/30 2:34, Dan Williams 写道:
> Shiyang Ruan wrote:
>>
>>
>> 在 2023/9/29 1:13, Darrick J. Wong 写道:
>>> On Thu, Sep 28, 2023 at 09:20:52AM -0700, Andrew Morton wrote:
>>>> On Thu, 28 Sep 2023 16:44:00 +0800 Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
>>>>
>>>>> But please pick the following patch[1] as well, which fixes failures of
>>>>> xfs55[0-2] cases.
>>>>>
>>>>> [1]
>>>>> https://lore.kernel.org/linux-xfs/20230913102942.601271-1-ruansy.fnst@fujitsu.com
>>>>
>>>> I guess I can take that xfs patch, as it fixes a DAX patch.  I hope the xfs team
>>>> are watching.
>>>>
>>>> But
>>>>
>>>> a) I'm not subscribed to linux-xfs and
>>>>
>>>> b) the changelog fails to describe the userspace-visible effects of
>>>>      the bug, so I (and others) are unable to determine which kernel
>>>>      versions should be patched.
>>>>
>>>> Please update that changelog and resend?
>>>
>>> That's a purely xfs patch anyways.  The correct maintainer is Chandan,
>>> not Andrew.
>>>
>>> /me notes that post-reorg, patch authors need to ask the release manager
>>> (Chandan) directly to merge their patches after they've gone through
>>> review.  Pull requests of signed tags are encouraged strongly.
>>>
>>> Shiyang, could you please send Chandan pull requests with /all/ the
>>> relevant pmem patches incorporated?  I think that's one PR for the
>>> "xfs: correct calculation for agend and blockcount" for 6.6; and a
>>> second PR with all the non-bugfix stuff (PRE_REMOVE and whatnot) for
>>> 6.7.
>>
>> OK.  Though I don't know how to send the PR by email, I have sent a list
>> of the patches and added description for each one.
> 
> If you want I can create a signed pull request from a git.kernel.org
> tree.
> 
> Where is that list of patches? I see v15 of preremove.

Sorry, I sent the list below to Chandan, didn't cc the maillist because 
it's just a rough list rather than a PR:


1. subject: [v3]  xfs: correct calculation for agend and blockcount
    url: 
https://lore.kernel.org/linux-xfs/20230913102942.601271-1-ruansy.fnst@fujitsu.com/
    note:    This one is a fix patch for commit: 5cf32f63b0f4 ("xfs: fix 
the calculation for "end" and "length"").
             It can solve the fail of xfs/55[0-2]: the programs 
accessing the DAX file may not be notified as expected, because the 
length always 1 block less than actual.  Then this patch fixes this.


2. subject: [v15] mm, pmem, xfs: Introduce MF_MEM_PRE_REMOVE for unbind
    url: 
https://lore.kernel.org/linux-xfs/20230928103227.250550-1-ruansy.fnst@fujitsu.com/T/#u
    note:    This is a feature patch.  It handles the pre-remove event 
of DAX device, by notifying kernel/user space before actually removing.
             It has been picked by Andrew in his mm-hotfixes-unstable. I 
am not sure whether you or he will merge this one.


3. subject: [v1]  xfs: drop experimental warning for FSDAX
    url: 
https://lore.kernel.org/linux-xfs/20230915063854.1784918-1-ruansy.fnst@fujitsu.com/
    note:    With the patches mentioned above, I did a lot of tests, 
including xfstests and blackbox tests, the FSDAX function looks good 
now.  So I think the experimental warning could be dropped.


--
Thanks,
Ruan.
