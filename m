Received: from esa2.hc1455-7.c3s2.iphmx.com (esa2.hc1455-7.c3s2.iphmx.com [207.54.90.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 923A51864
	for <nvdimm@lists.linux.dev>; Fri, 29 Sep 2023 11:57:51 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6600,9927,10847"; a="134127142"
X-IronPort-AV: E=Sophos;i="6.03,187,1694703600"; 
   d="scan'208";a="134127142"
Received: from unknown (HELO oym-r1.gw.nic.fujitsu.com) ([210.162.30.89])
  by esa2.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2023 20:56:39 +0900
Received: from oym-m3.gw.nic.fujitsu.com (oym-nat-oym-m3.gw.nic.fujitsu.com [192.168.87.60])
	by oym-r1.gw.nic.fujitsu.com (Postfix) with ESMTP id 5B637D29E5
	for <nvdimm@lists.linux.dev>; Fri, 29 Sep 2023 20:56:37 +0900 (JST)
Received: from kws-ab4.gw.nic.fujitsu.com (kws-ab4.gw.nic.fujitsu.com [192.51.206.22])
	by oym-m3.gw.nic.fujitsu.com (Postfix) with ESMTP id 897E3D94B2
	for <nvdimm@lists.linux.dev>; Fri, 29 Sep 2023 20:56:36 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by kws-ab4.gw.nic.fujitsu.com (Postfix) with ESMTP id 1BF48401A7
	for <nvdimm@lists.linux.dev>; Fri, 29 Sep 2023 20:56:36 +0900 (JST)
Received: from [10.193.128.127] (unknown [10.193.128.127])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id 30CC21A0070;
	Fri, 29 Sep 2023 19:56:35 +0800 (CST)
Message-ID: <99279735-2d17-405f-bade-9501a296d817@fujitsu.com>
Date: Fri, 29 Sep 2023 19:56:34 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: drop experimental warning for FSDAX
To: "Darrick J. Wong" <djwong@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Chandan Babu R <chandanbabu@kernel.org>,
 Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
 nvdimm@lists.linux.dev, dan.j.williams@intel.com
References: <20230926145519.GE11439@frogsfrogsfrogs>
 <ZROC8hEabAGS7orb@dread.disaster.area>
 <20230927014632.GE11456@frogsfrogsfrogs>
 <87fs306zs1.fsf@debian-BULLSEYE-live-builder-AMD64>
 <5c064cbd-13a3-4d55-9881-0a079476d865@fujitsu.com>
 <bc29af15-ae63-407d-8ca0-186c976acce7@fujitsu.com>
 <87y1gs83yq.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20230927083034.90bd6336229dd00af601e0ef@linux-foundation.org>
 <9c3cbc0c-7135-4006-ad4a-2abce0a556b0@fujitsu.com>
 <20230928092052.9775e59262c102dc382513ef@linux-foundation.org>
 <20230928171339.GJ11439@frogsfrogsfrogs>
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
In-Reply-To: <20230928171339.GJ11439@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-27904.007
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-27904.007
X-TMASE-Result: 10--17.421700-10.000000
X-TMASE-MatchedRID: x/EPlNU2vY2PvrMjLFD6eHchRkqzj/bEC/ExpXrHizy5kqGQ38oKZiyB
	2QdJzFQxeiSRL6ccGm3mcwRo1T9FBN/K1ikJIsLOqug9vIA2WOASyA2F3XSGIlAoBBK61Bhcvgm
	lXW4uT/zxkhLcCNMvjtYrdGPWjovvJuJYwkshsMH97643XzR7lynQV+sTq2oQJQLqWrKg0L0uJa
	PbC+kbrOEqPm4A28Dgf2U0hnakSY8V97lIy2qxCEEOfoWOrvuOdmWMDQajOiKBAXl9LkPp6eGm/
	D7ygt+qkPI1/ZdqoS0VGyRifsbM+5piU2kgoGALdo0n+JPFcJp9LQinZ4QefGWCfbzydb0gzhYg
	VA8TZw63ApS8cfJcZd0H8LFZNFG7bkV4e2xSge4WrCb08VKGnT+Fto5OAEga8z92JPerioPbPEZ
	EldmKFcWFcyN1Agmm
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0



在 2023/9/29 1:13, Darrick J. Wong 写道:
> On Thu, Sep 28, 2023 at 09:20:52AM -0700, Andrew Morton wrote:
>> On Thu, 28 Sep 2023 16:44:00 +0800 Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
>>
>>> But please pick the following patch[1] as well, which fixes failures of
>>> xfs55[0-2] cases.
>>>
>>> [1]
>>> https://lore.kernel.org/linux-xfs/20230913102942.601271-1-ruansy.fnst@fujitsu.com
>>
>> I guess I can take that xfs patch, as it fixes a DAX patch.  I hope the xfs team
>> are watching.
>>
>> But
>>
>> a) I'm not subscribed to linux-xfs and
>>
>> b) the changelog fails to describe the userspace-visible effects of
>>     the bug, so I (and others) are unable to determine which kernel
>>     versions should be patched.
>>
>> Please update that changelog and resend?
> 
> That's a purely xfs patch anyways.  The correct maintainer is Chandan,
> not Andrew.
> 
> /me notes that post-reorg, patch authors need to ask the release manager
> (Chandan) directly to merge their patches after they've gone through
> review.  Pull requests of signed tags are encouraged strongly.
> 
> Shiyang, could you please send Chandan pull requests with /all/ the
> relevant pmem patches incorporated?  I think that's one PR for the
> "xfs: correct calculation for agend and blockcount" for 6.6; and a
> second PR with all the non-bugfix stuff (PRE_REMOVE and whatnot) for
> 6.7.

OK.  Though I don't know how to send the PR by email, I have sent a list 
of the patches and added description for each one.


--
Thanks,
Ruan.

> 
> --D
