Received: from esa11.hc1455-7.c3s2.iphmx.com (esa11.hc1455-7.c3s2.iphmx.com [207.54.90.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121007B
	for <nvdimm@lists.linux.dev>; Tue,  4 Oct 2022 04:14:03 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6500,9779,10489"; a="70376327"
X-IronPort-AV: E=Sophos;i="5.93,367,1654527600"; 
   d="scan'208";a="70376327"
Received: from unknown (HELO oym-r1.gw.nic.fujitsu.com) ([210.162.30.89])
  by esa11.hc1455-7.c3s2.iphmx.com with ESMTP; 04 Oct 2022 13:12:52 +0900
Received: from oym-m2.gw.nic.fujitsu.com (oym-nat-oym-m2.gw.nic.fujitsu.com [192.168.87.59])
	by oym-r1.gw.nic.fujitsu.com (Postfix) with ESMTP id 3A44AE8BF5
	for <nvdimm@lists.linux.dev>; Tue,  4 Oct 2022 13:12:51 +0900 (JST)
Received: from m3003.s.css.fujitsu.com (m3003.s.css.fujitsu.com [10.128.233.114])
	by oym-m2.gw.nic.fujitsu.com (Postfix) with ESMTP id 62EECBF3EB
	for <nvdimm@lists.linux.dev>; Tue,  4 Oct 2022 13:12:50 +0900 (JST)
Received: from [10.14.75.87] (unknown [10.14.75.87])
	by m3003.s.css.fujitsu.com (Postfix) with ESMTP id 8CF0F2005AD8;
	Tue,  4 Oct 2022 13:12:47 +0900 (JST)
Message-ID: <f196bcab-6aa2-6313-8a7c-f8ab409621b7@fujitsu.com>
Date: Mon, 3 Oct 2022 21:12:46 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH] xfs: fail dax mount if reflink is enabled on a partition
Content-Language: en-US
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: =?UTF-8?B?WWFuZywgWGlhby/mnagg5pmT?= <yangx.jy@fujitsu.com>,
 Brian Foster <bfoster@redhat.com>, "hch@infradead.org" <hch@infradead.org>,
 =?UTF-8?B?UnVhbiwgU2hpeWFuZy/pmK4g5LiW6Ziz?= <ruansy.fnst@fujitsu.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "david@fromorbit.com" <david@fromorbit.com>, zwisler@kernel.org,
 Jeff Moyer <jmoyer@redhat.com>, dm-devel@redhat.com, toshi.kani@hpe.com
References: <dd363bd8-2dbd-5d9c-0406-380b60c5f510@fujitsu.com>
 <Yxs5Jb7Yt2c6R6eW@bfoster> <7fdc9e88-f255-6edb-7964-a5a82e9b1292@fujitsu.com>
 <76ea04b4-bad7-8cb3-d2c6-4ad49def4e05@fujitsu.com> <YyHKUhOgHdTKPQXL@bfoster>
 <YyIBMJzmbZsUBHpy@magnolia>
 <a6e7f4eb-0664-bbe8-98d2-f8386b226113@fujitsu.com>
 <e3d51a6b-12e9-2a19-1280-5fd9dd64117c@fujitsu.com>
 <deb54a77-90d3-df44-1880-61cce6e3f670@fujitsu.com>
 <1444b9b5-363a-163c-0513-55d1ea951799@fujitsu.com>
 <Yzt6eWLuX/RTjmjj@magnolia>
From: =?UTF-8?B?R290b3UsIFlhc3Vub3JpL+S6lOWztiDlurfmloc=?=
 <y-goto@fujitsu.com>
In-Reply-To: <Yzt6eWLuX/RTjmjj@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00

On 2022/10/03 17:12, Darrick J. Wong wrote:
> On Fri, Sep 30, 2022 at 09:56:41AM +0900, Gotou, Yasunori/五島 康文 wrote:
>> Hello everyone,
>>
>> On 2022/09/20 11:38, Yang, Xiao/杨 晓 wrote:
>>> Hi Darrick, Brian and Christoph
>>>
>>> Ping. I hope to get your feedback.
>>>
>>> 1) I have confirmed that the following patch set did not change the test
>>> result of generic/470 with thin-volume. Besides, I didn't see any
>>> failure when running generic/470 based on normal PMEM device instaed of
>>> thin-volume.
>>> https://lore.kernel.org/linux-xfs/20211129102203.2243509-1-hch@lst.de/
>>>
>>> 2) I can reproduce the failure of generic/482 without thin-volume.
>>>
>>> 3) Is it necessary to make thin-volume support DAX. Is there any use
>>> case for the requirement?
>>
>>
>> Though I asked other place(*), I really want to know the usecase of
>> dm-thin-volume with DAX and reflink.
>>
>>
>> In my understanding, dm-thin-volume seems to provide similar feature like
>> reflink of xfs. Both feature provide COW update to reduce usage of
>> its region, and snapshot feature, right?
>>
>> I found that docker seems to select one of them (or other feature which
>> supports COW). Then user don't need to use thin-volume and reflink at same
>> time.
>>
>> Database which uses FS-DAX may want to use snapshot for its data of FS-DAX,
>> its user seems to be satisfied with reflink or thin-volume.
>>
>> So I could not find on what use-case user would like to use dm-thin-volume
>> and reflink at same time.
>>
>> The only possibility is that the user has mistakenly configured dm-thinpool
>> and reflink to be used at the same time, but if that is the case, it seems
>> to be better for the user to disable one or the other.
>>
>> I really wander why dm-thin-volume must be used with reflik and FS-DAX.
> 
> There isn't a hard requirement between fsdax and dm-thinp.  The /test/
> needs dm-logwrites to check that write page faults on a MAP_SYNC
> mmapping are persisted directly to disk.  dm-logwrites requires a fast
> way to zero an entire device for correct operation of the replay step,
> and thinp is the only way to guarantee that.

Thank you for your answer. But I still feel something is strange.
Though dm-thinp may be good way to execute the test correctly,
I suppose it seems to be likely a kind of workaround to pass the test,
it may not be really required for actual users.

Could you tell me why passing test by workaround is so necessary?

Thanks,


> 
> --D
> 
>> If my understanding is something wrong, please correct me.
>>
>> (*)https://lore.kernel.org/all/TYWPR01MB1008258F474CA2295B4CD3D9B90549@TYWPR01MB10082.jpnprd01.prod.outlook.com/
