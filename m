Received: from esa2.hc1455-7.c3s2.iphmx.com (esa2.hc1455-7.c3s2.iphmx.com [207.54.90.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9B4390
	for <nvdimm@lists.linux.dev>; Tue, 10 Oct 2023 03:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-IronPort-AV: E=McAfee;i="6600,9927,10858"; a="135431425"
X-IronPort-AV: E=Sophos;i="6.03,211,1694703600"; 
   d="scan'208";a="135431425"
Received: from unknown (HELO yto-r2.gw.nic.fujitsu.com) ([218.44.52.218])
  by esa2.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2023 12:53:07 +0900
Received: from yto-m2.gw.nic.fujitsu.com (yto-nat-yto-m2.gw.nic.fujitsu.com [192.168.83.65])
	by yto-r2.gw.nic.fujitsu.com (Postfix) with ESMTP id C1F5AC68E2
	for <nvdimm@lists.linux.dev>; Tue, 10 Oct 2023 12:53:04 +0900 (JST)
Received: from kws-ab4.gw.nic.fujitsu.com (kws-ab4.gw.nic.fujitsu.com [192.51.206.22])
	by yto-m2.gw.nic.fujitsu.com (Postfix) with ESMTP id F3D99D5E88
	for <nvdimm@lists.linux.dev>; Tue, 10 Oct 2023 12:53:03 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by kws-ab4.gw.nic.fujitsu.com (Postfix) with ESMTP id 7CDCC40E89
	for <nvdimm@lists.linux.dev>; Tue, 10 Oct 2023 12:53:03 +0900 (JST)
Received: from [192.168.50.5] (unknown [10.167.226.34])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id A54571A0071;
	Tue, 10 Oct 2023 11:53:02 +0800 (CST)
Message-ID: <019bc83b-7f94-476b-95cb-280f1045057d@fujitsu.com>
Date: Tue, 10 Oct 2023 11:53:02 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: drop experimental warning for FSDAX
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Chandan Babu R <chandanbabu@kernel.org>,
 Dave Chinner <david@fromorbit.com>, Dan Williams <dan.j.williams@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-xfs@vger.kernel.org,
 nvdimm@lists.linux.dev
References: <20230928092052.9775e59262c102dc382513ef@linux-foundation.org>
 <20230928171339.GJ11439@frogsfrogsfrogs>
 <99279735-2d17-405f-bade-9501a296d817@fujitsu.com>
 <651718a6a6e2c_c558e2943e@dwillia2-xfh.jf.intel.com.notmuch>
 <ec2de0b9-c07d-468a-bd15-49e83cba1ad9@fujitsu.com>
 <87y1gltcvg.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20231005000809.GN21298@frogsfrogsfrogs>
 <ce9ef1dc-d62b-466d-882f-d7bf4350582d@fujitsu.com>
 <20231005160530.GO21298@frogsfrogsfrogs>
 <28613f6e-2ed2-4c9a-81e3-3dcfdbba867c@fujitsu.com>
 <20231009164721.GC21298@frogsfrogsfrogs>
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
In-Reply-To: <20231009164721.GC21298@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-27926.004
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-27926.004
X-TMASE-Result: 10--18.992100-10.000000
X-TMASE-MatchedRID: VfQSHXvEBuuPvrMjLFD6eHchRkqzj/bEC/ExpXrHizxBqLOmHiM3w0mb
	/vjP+wrh2cyrLyFNhjuc49Bvf+9vIl0ieHN50/kHrMZ+BqQt2NpN8rmPQRlvK1cZNuxCoduS2Z5
	d2c6tpnZa0onndjAYYqcgvYcxG5Wh+BMgIVTipNsSEYfcJF0pRdG3Y6ijqBt3+B3C2Zz0Z1PhDo
	h7wbP2f4psmNGAE/ypCRGaYCZT14bIRZRfI7CCoWzBijri5+RV8FHp8LCpZ7T5V4X/65Dwb7rmv
	hde36c4lxPsRwiY5LxXuQ2wIHEaxLgSigd+50baQQ5+hY6u+45UENBIMyKD0XdjuSlUpauf8Ybk
	9kzPEWih9xN1JciTvfMW54P2B2td1s1AHJ9E8eBdhZyafgPiq1yyC78hAU/OVz8J52OVy+RkG4E
	tozBz384b571oAikeD4bdesxcMzc2sw58eWE/moh/ebSxR/HnltF+xW+zhUgfaBJLrllK9TVkax
	wyOBfMGfvvA62+ODrnhf6+3edYDulLQUIbIAyZCKFDk1kJexKlH6by0GLpklAoBBK61BhcoxY+h
	bwZnrKzIDrAdhrevrCzy7sjl4e3yGOiXr1rOL4XCihJ642djgC0f97LzNGnNv1MHbxRuSKvlldd
	h4J26Pl47fpoE7RR4KlJZ4nJpnvtSAqARMjuvJU7Bltw5qVLCUphWp23XJ0CGfvnVpx+2xfDVTv
	7ELb9oa8IWqgpLBNftuJwrFEhTfnZI3fdS4AAudR/NJw2JHcNYpvo9xW+mI6HM5rqDwqtS7jZG2
	6xJC//jLjb55+gWi7+IuipnJSWmJO6ww6E0K0mGci1lR4w0Q==
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0



在 2023/10/10 0:47, Darrick J. Wong 写道:
> On Mon, Oct 09, 2023 at 10:14:12PM +0800, Shiyang Ruan wrote:
>>
>>
>> 在 2023/10/6 0:05, Darrick J. Wong 写道:
>>> On Thu, Oct 05, 2023 at 04:53:12PM +0800, Shiyang Ruan wrote:
>>>>
>>>>
>>>> 在 2023/10/5 8:08, Darrick J. Wong 写道:
>>>>>>>
>>>>>>> Sorry, I sent the list below to Chandan, didn't cc the maillist
>>>>>>> because it's just a rough list rather than a PR:
>>>>>>>
>>>>>>>
>>>>>>> 1. subject: [v3]  xfs: correct calculation for agend and blockcount
>>>>>>>       url:
>>>>>>>       https://lore.kernel.org/linux-xfs/20230913102942.601271-1-ruansy.fnst@fujitsu.com/
>>>>>>>       note:    This one is a fix patch for commit: 5cf32f63b0f4 ("xfs:
>>>>>>>       fix the calculation for "end" and "length"").
>>>>>>>                It can solve the fail of xfs/55[0-2]: the programs
>>>>>>>                accessing the DAX file may not be notified as expected,
>>>>>>>               because the length always 1 block less than actual.  Then
>>>>>>>              this patch fixes this.
>>>>>>>
>>>>>>>
>>>>>>> 2. subject: [v15] mm, pmem, xfs: Introduce MF_MEM_PRE_REMOVE for unbind
>>>>>>>       url:
>>>>>>>       https://lore.kernel.org/linux-xfs/20230928103227.250550-1-ruansy.fnst@fujitsu.com/T/#u
>>>>>>>       note:    This is a feature patch.  It handles the pre-remove event
>>>>>>>       of DAX device, by notifying kernel/user space before actually
>>>>>>>      removing.
>>>>>>>                It has been picked by Andrew in his
>>>>>>>                mm-hotfixes-unstable. I am not sure whether you or he will
>>>>>>>               merge this one.
>>>>>>>
>>>>>>>
>>>>>>> 3. subject: [v1]  xfs: drop experimental warning for FSDAX
>>>>>>>       url:
>>>>>>>       https://lore.kernel.org/linux-xfs/20230915063854.1784918-1-ruansy.fnst@fujitsu.com/
>>>>>>>       note:    With the patches mentioned above, I did a lot of tests,
>>>>>>>       including xfstests and blackbox tests, the FSDAX function looks
>>>>>>>      good now.  So I think the experimental warning could be dropped.
>>>>>>
>>>>>> Darrick/Dave, Could you please review the above patch and let us know if you
>>>>>> have any objections?
>>>>>
>>>>> The first two patches are ok.  The third one ... well I was about to say
>>>>> ok but then this happened with generic/269 on a 6.6-rc4 kernel and those
>>>>> two patches applied:
>>>>
>>>> Hi Darrick,
>>>>
>>>> Thanks for testing.  I just tested this case (generic/269) on v6.6-rc4 with
>>>> my 3 patches again, but it didn't fail.  Such WARNING message didn't show in
>>>> dmesg too.
>>>>
>>>> My local.config is shown as below:
>>>> [nodax_reflink]
>>>> export FSTYP=xfs
>>>> export TEST_DEV=/dev/pmem0
>>>> export TEST_DIR=/mnt/test
>>>> export SCRATCH_DEV=/dev/pmem1
>>>> export SCRATCH_MNT=/mnt/scratch
>>>> export MKFS_OPTIONS="-m reflink=1,rmapbt=1"
>>>>
>>>> [dax_reflink]
>>>> export FSTYP=xfs
>>>> export TEST_DEV=/dev/pmem0
>>>> export TEST_DIR=/mnt/test
>>>> export SCRATCH_DEV=/dev/pmem1
>>>> export SCRATCH_MNT=/mnt/scratch
>>>> export MKFS_OPTIONS="-m reflink=1,rmapbt=1"
>>>> export MOUNT_OPTIONS="-o dax"
>>>> export TEST_FS_MOUNT_OPTS="-o dax"
>>>>
>>>> And tools version are:
>>>>    - xfstests (v2023.09.03)
>>>
>>> Same here.
>>>
>>>>    - xfsprogs (v6.4.0)
>>>
>>> I have a newer branch, though it only contains resyncs with newer kernel
>>> versions and bugfixes.
>>>
>>>> Could you show me more info (such as kernel config, local.config) ?  So that
>>>> I can find out what exactly is going wrong.
>>>
>>> The full xml output from fstests is here:
>>>
>>> https://djwong.org/fstests/output/.fa9f295c6a2dd4426aa26b4d74e8e0299ad2307507547d5444c157f0e883df92/.2e718425eda716ad848ae05dfab82a670af351f314e26b3cb658a929331bf2eb/result.xml
>>>
>>> I think the key difference between your setup and mine is that
>>> MKFS_OPTIONS includes '-d daxinherit=1' and MOUNT_OPTIONS do not include
>>> -o dax.  That shouldn't make any difference, though.

A little strange thing I found:
According to the result.xml, the MKFS_OPTIONS didn't include -m rmapbt=1:
     <property name="MKFS_OPTIONS" value=" -d daxinherit=1,"/>
mkfs.xfs will turn on reflink by default, but won't turn on rmapbt. 
Then xfs/55[0-2] should be "not run" because they have 
_require_xfs_scratch_rmapbt.


Also, this alert message didn't show in my tests:
[ 6047.876110] XFS (pmem1): xlog_verify_grant_tail: space > 
BBTOB(tail_blocks)
But I don't think it is related.

>>>
>>> Also: In the weeks leading up to me adding the PREREMOVE patches a
>>> couple of days ago, no test (generic/269 or otherwise) hit that ASSERT.

Has it failed again since this time?  If so, please sent me the 
result.xml because it is needed for analyze.  Thank you~

>>> I'm wondering if that means that the preremove code isn't shooting down
>>> a page mapping or something?
>>>
>>> Grepping through the result.xml reveals:
>>>
>>> $ grep -E '(generic.269|xfs.55[012])' /tmp/result.xml
>>> 563:    <testcase classname="xfstests.global" name="xfs/550" time="2">
>>> 910:    <testcase classname="xfstests.global" name="xfs/552" time="2">
>>> 1685:   <testcase classname="xfstests.global" name="generic/269" time="23">
>>> 1686:           <failure message="_check_dmesg: something found in dmesg (see /var/tmp/fstests/generic/269.dmesg)" type="TestFail"/>
>>> 1689:[ 6046.844058] run fstests generic/269 at 2023-10-04 15:26:57
>>> 2977:   <testcase classname="xfstests.global" name="xfs/551" time="2">
>>>
>>> So it's possible that 550 or 552 messed this up for us. :/
>>>
>>> See attached kconfig.
>>
>> Thanks for the info.  I tried to make my environment same as yours, but
>> still couldn't reproduce the fail.  I also let xfs/550 & xfs/552 ran before
>> generic/269.
>>
>> [root@f38 xfst]# ./check -s nodax_reflink -r xfs/550 xfs/552 generic/269
>> SECTION       -- nodax_reflink
>> FSTYP         -- xfs (debug)
>> PLATFORM      -- Linux/x86_64 f38 6.6.0-rc4 #365 SMP PREEMPT_DYNAMIC Sun Oct
>> 8 15:19:36 CST 2023
>> MKFS_OPTIONS  -- -f -m reflink=1,rmapbt=1 -d daxinherit=1 /dev/pmem1
>> MOUNT_OPTIONS -- -o usrquota,grpquota,prjquota, /dev/pmem1 /mnt/scratch
>>
>> xfs/550 2s ...  2s
>> xfs/552 2s ...  1s
>> generic/269 22s ...  23s
>> Ran: xfs/550 xfs/552 generic/269
>> Passed all 3 tests
>>
>> SECTION       -- nodax_reflink
>> =========================
>> Ran: xfs/550 xfs/552 generic/269
>> Passed all 3 tests
>>
>>
>> And xfs/269 is testing fsstress & dd on a scratch device at the same time.
>> It won't reach the PREREMOVE code or xfs' notify failure code.
>>
>> I'd like to know what your git tree looks like, is it *v6.6-rc4 + my patches
>> only* ?  Does it contain other patches?
> 
> No other patches, aside from turning on selected W=123e warnings.

I don't know what does this mean: "selected W=123e warnings".  How could 
I turn on this config?


--
Thanks,
Ruan.

> 
> --D
> 
>>
>> --
>> Thanks,
>> Ruan.
>>
>>>
>>> --D
>>>
>>>>
>>>>
>>>> --
>>>> Thanks,
>>>> Ruan.
