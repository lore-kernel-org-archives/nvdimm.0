Received: from esa10.hc1455-7.c3s2.iphmx.com (esa10.hc1455-7.c3s2.iphmx.com [139.138.36.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B7820E3
	for <nvdimm@lists.linux.dev>; Thu,  5 Oct 2023 08:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
X-IronPort-AV: E=McAfee;i="6600,9927,10853"; a="122684078"
X-IronPort-AV: E=Sophos;i="6.03,202,1694703600"; 
   d="scan'208";a="122684078"
Received: from unknown (HELO yto-r2.gw.nic.fujitsu.com) ([218.44.52.218])
  by esa10.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2023 17:53:18 +0900
Received: from yto-m1.gw.nic.fujitsu.com (yto-nat-yto-m1.gw.nic.fujitsu.com [192.168.83.64])
	by yto-r2.gw.nic.fujitsu.com (Postfix) with ESMTP id CE8A0C68E4
	for <nvdimm@lists.linux.dev>; Thu,  5 Oct 2023 17:53:14 +0900 (JST)
Received: from kws-ab4.gw.nic.fujitsu.com (kws-ab4.gw.nic.fujitsu.com [192.51.206.22])
	by yto-m1.gw.nic.fujitsu.com (Postfix) with ESMTP id 1365FCFF99
	for <nvdimm@lists.linux.dev>; Thu,  5 Oct 2023 17:53:14 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by kws-ab4.gw.nic.fujitsu.com (Postfix) with ESMTP id 95A8F6C9FD
	for <nvdimm@lists.linux.dev>; Thu,  5 Oct 2023 17:53:13 +0900 (JST)
Received: from [10.193.128.127] (unknown [10.193.128.127])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id B4E4C1A0070;
	Thu,  5 Oct 2023 16:53:12 +0800 (CST)
Message-ID: <ce9ef1dc-d62b-466d-882f-d7bf4350582d@fujitsu.com>
Date: Thu, 5 Oct 2023 16:53:12 +0800
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
References: <bc29af15-ae63-407d-8ca0-186c976acce7@fujitsu.com>
 <87y1gs83yq.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20230927083034.90bd6336229dd00af601e0ef@linux-foundation.org>
 <9c3cbc0c-7135-4006-ad4a-2abce0a556b0@fujitsu.com>
 <20230928092052.9775e59262c102dc382513ef@linux-foundation.org>
 <20230928171339.GJ11439@frogsfrogsfrogs>
 <99279735-2d17-405f-bade-9501a296d817@fujitsu.com>
 <651718a6a6e2c_c558e2943e@dwillia2-xfh.jf.intel.com.notmuch>
 <ec2de0b9-c07d-468a-bd15-49e83cba1ad9@fujitsu.com>
 <87y1gltcvg.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20231005000809.GN21298@frogsfrogsfrogs>
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
In-Reply-To: <20231005000809.GN21298@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-27916.006
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-27916.006
X-TMASE-Result: 10--16.958400-10.000000
X-TMASE-MatchedRID: +Gnn4vg1rdyPvrMjLFD6eHchRkqzj/bEC/ExpXrHizwUta+LQgEZMPfl
	GT6FkvTPZxpAP+mD6wCDs24hteATn9/K1ikJIsLOKsurITpSv+PVBDonH99+VuZYcdJgScjxgbP
	PjZPQM/k9QxA+EGg/dOvPanPbI41jNtywwIf5ksW/x8sBfQ/nQPzrlCVXDGYb0y9hkRwHPXGGPn
	eCOFgqRJT6yVaXFFqMyFxL8McBbl5x1XV+/0DNMFK9xlSOuRoWYjDXdM/x2VPWeQtrcncLfYtxj
	ghoBojmAd0cn1fMeA4C/xl8pUGMgZlbG0HPEaFBA9lly13c/gEBmf/gD11vZLcIt210bWgILhd6
	ma7WE8vQ2jWaSvYDWNZZVqi+HeLhBOwoKTOp+iB85pjA/x1xftDEMPvvoocvP4H+2nyK0FOhhi9
	o+RXHs6GvCFqoKSwTX7bicKxRIU352SN33UuAALnUfzScNiR3DWKb6PcVvpiOhzOa6g8KrZzIAI
	ytA760+kpp1tsNgPNe20TL477TKxIwZxusN18Nz8JWjFN4feM=
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0



在 2023/10/5 8:08, Darrick J. Wong 写道:
>>>
>>> Sorry, I sent the list below to Chandan, didn't cc the maillist
>>> because it's just a rough list rather than a PR:
>>>
>>>
>>> 1. subject: [v3]  xfs: correct calculation for agend and blockcount
>>>     url:
>>>     https://lore.kernel.org/linux-xfs/20230913102942.601271-1-ruansy.fnst@fujitsu.com/
>>>     note:    This one is a fix patch for commit: 5cf32f63b0f4 ("xfs:
>>>     fix the calculation for "end" and "length"").
>>>              It can solve the fail of xfs/55[0-2]: the programs
>>>              accessing the DAX file may not be notified as expected,
>>>             because the length always 1 block less than actual.  Then
>>>            this patch fixes this.
>>>
>>>
>>> 2. subject: [v15] mm, pmem, xfs: Introduce MF_MEM_PRE_REMOVE for unbind
>>>     url:
>>>     https://lore.kernel.org/linux-xfs/20230928103227.250550-1-ruansy.fnst@fujitsu.com/T/#u
>>>     note:    This is a feature patch.  It handles the pre-remove event
>>>     of DAX device, by notifying kernel/user space before actually
>>>    removing.
>>>              It has been picked by Andrew in his
>>>              mm-hotfixes-unstable. I am not sure whether you or he will
>>>             merge this one.
>>>
>>>
>>> 3. subject: [v1]  xfs: drop experimental warning for FSDAX
>>>     url:
>>>     https://lore.kernel.org/linux-xfs/20230915063854.1784918-1-ruansy.fnst@fujitsu.com/
>>>     note:    With the patches mentioned above, I did a lot of tests,
>>>     including xfstests and blackbox tests, the FSDAX function looks
>>>    good now.  So I think the experimental warning could be dropped.
>>
>> Darrick/Dave, Could you please review the above patch and let us know if you
>> have any objections?
> 
> The first two patches are ok.  The third one ... well I was about to say
> ok but then this happened with generic/269 on a 6.6-rc4 kernel and those
> two patches applied:

Hi Darrick,

Thanks for testing.  I just tested this case (generic/269) on v6.6-rc4 
with my 3 patches again, but it didn't fail.  Such WARNING message 
didn't show in dmesg too.

My local.config is shown as below:
[nodax_reflink]
export FSTYP=xfs
export TEST_DEV=/dev/pmem0
export TEST_DIR=/mnt/test
export SCRATCH_DEV=/dev/pmem1
export SCRATCH_MNT=/mnt/scratch
export MKFS_OPTIONS="-m reflink=1,rmapbt=1"

[dax_reflink]
export FSTYP=xfs
export TEST_DEV=/dev/pmem0
export TEST_DIR=/mnt/test
export SCRATCH_DEV=/dev/pmem1
export SCRATCH_MNT=/mnt/scratch
export MKFS_OPTIONS="-m reflink=1,rmapbt=1"
export MOUNT_OPTIONS="-o dax"
export TEST_FS_MOUNT_OPTS="-o dax"

And tools version are:
  - xfstests (v2023.09.03)
  - xfsprogs (v6.4.0)


Could you show me more info (such as kernel config, local.config) ?  So 
that I can find out what exactly is going wrong.


--
Thanks,
Ruan.
