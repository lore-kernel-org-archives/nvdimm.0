Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B08C93EA979;
	Sun, 13 Sep 2026 13:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789304639; cv=none; b=YhCMlEnKVmJp8+JhYEEfm4mw6oEExmj6FW/FOs6wPgkS7SbAjf42rD/0D/ZB+paUt+nqCwrIwfSqHKfXssWmh+rXwxVgtc6fGA7/wHLM3H1kE6bBPfeuCyfmEauyCU3DWFa34MTHoHxgm/eJTbHEDOKMy5ZqWauEF9pmnW+CmU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789304639; c=relaxed/simple;
	bh=vzknxVFcrvnBravnnWXz7CdIMEkb2I+nFilCLAukFq8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i+/q6wuikEubuntXKwjL5u36Oc57+7NW/Ht3Y77p4ztvMMn8486PNnpJIfLGWrGfNOwB3dFZh7y5NJn1XmoiSzxFNYVx4cQsxMAQ09YbxI3vMK1mhHgpx5bHl6uY9boMFQowbARN2FxpBjpfgZn/vc8YCXC23DucP4vw4ncwgiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=s7cH6nwq; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="s7cH6nwq"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68DAW0mw3165374;
	Sun, 13 Sep 2026 13:02:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Tw5ph9
	TRn3iEi47uD/g6aGQm4s72n2paY6zzwlF58/o=; b=s7cH6nwqcyvhp4OvdUWNyd
	4ygy35F5w9rHDOY9/8vTUzMIXqvfGRSRwu1EGjltzmPASuF8ids8GFmziTkDyork
	QfHPNwMo2PjOshxl3iqi8/Dd6j95HphP5klAg8SOf8jM+OrJY8UHFJIHVZpis/cP
	I+Ncoj09ZsZU5IjHz9ars8csebcoQWkYclZBrdwc4AXMzr77D12CfnqQXIwecdWE
	bGemrxD0JnRmrG4UssSZo3gL+yoVAcCGjzqwmrUhMoSTy2WTwaBmWRcTQFsqqPzZ
	LSV1Yr4qWP0vdRYvTHzMF3C2z1flckgI+Y76uGG8MQe/wDpyNPdWAN8oy+90pNxA
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmxcumgqr-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sun, 13 Sep 2026 13:02:56 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68DAZ5xi544511;
	Sun, 13 Sep 2026 13:02:55 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gnh2psp2h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 13 Sep 2026 13:02:55 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68DD2sWL2163296
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 13 Sep 2026 13:02:54 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8BEF158043;
	Sun, 13 Sep 2026 13:02:54 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 11B2E58060;
	Sun, 13 Sep 2026 13:02:42 +0000 (GMT)
Received: from [9.61.162.129] (unknown [9.61.162.129])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Sun, 13 Sep 2026 13:02:41 +0000 (GMT)
Message-ID: <1f229884-fd03-41a4-992f-8a98c108ee77@linux.ibm.com>
Date: Sun, 13 Sep 2026 18:32:40 +0530
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] blk-cgroup: store blkcg in bio instead of blkg
To: yukuai@fygo.io, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Christoph Hellwig <hch@lst.de>, Tao Cui <cui.tao@linux.dev>,
        Jan Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <skhan@linuxfoundation.org>, Coly Li <colyli@fygo.io>,
        Kent Overstreet <kent.overstreet@linux.dev>,
        Alasdair Kergon
 <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Benjamin Marzinski <bmarzins@redhat.com>, Song Liu <song@kernel.org>,
        Li Nan <magiclinan@didiglobal.com>, Xiao Ni <xiao@kernel.org>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
        Dan Williams <djbw@kernel.org>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Alison Schofield <alison.schofield@intel.com>,
        Ira Weiny
 <iweiny@kernel.org>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>, cgroups@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
        dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
        nvdimm@lists.linux.dev, virtualization@lists.linux.dev,
        gfs2@lists.linux.dev, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
References: <20260823133045.970199-1-yukuai@kernel.org>
 <20260823133045.970199-3-yukuai@kernel.org>
 <49d724b8-57c6-48fc-8099-69cd1b072351@linux.ibm.com>
 <befbc177-f7f5-4c44-b02e-20a99fc64c0c@fygo.io>
 <a123f309-6ec7-470f-b5b0-f08cca6d2627@linux.ibm.com>
 <4701cbcb-b877-4902-a5b6-59836c345ae1@fygo.io>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <4701cbcb-b877-4902-a5b6-59836c345ae1@fygo.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEzMDE4NiBTYWx0ZWRfX4bdtmyi6TbLm
 PnmDAd3K2Pznh8wKoHonQGBp0ysClcBa1OrztITcVcSLlgrYE8VP5c+wmKBSMI/Ab+s5CEAzUN9
 Ea8RX3OwXCxPBzrqczT1uoKyWJz8Gd8=
X-Proofpoint-ORIG-GUID: 4e-ag4htDeTMNqeo8EQTo29EVzjiZK2X
X-Proofpoint-GUID: 8nZCV6p6P95_uuj9tctUmrn0T5r3AWs2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEzMDE4NiBTYWx0ZWRfX+y0ctK5+xq+a
 /6vRvkZSZ9kg/PRUPUeLCGN03W3jPvQAMS6+jzOCs+1AkALnrqqa7cWBgjUJrz2tbNfuYpfkPSL
 PrpENPFKOh1zgy5s+IbHnaindMy9q5WpfnQQSFp1AQL7EDR3wzuMd2+angeKYcFptQeG84j5MmI
 kabMIcR/1Tlm6+B6eHGJ4jPSNJCnCQ8yiO/bzcNP4J4722NX91KHSo4tr/1jUlNXi9IzOR4aktQ
 PNlsV9N1f1DNgs1085Zy8B/VV5S2OoRShsuqNTwLGF8BVVlzGX+bVF2oC3VDMgg9Uz73fr4ialD
 sixKyB0QiUL7rpFtOUvpBRNyhS3Twogc9nUo132awmaYmfbOzhmXQ8mL9rZ6dMStjx1Q61vbFnA
 uMgB0RrOtgNGJrUNgP/wLPKUF0dIAtOt9VJngXCh/nk7vkWx1XqmFRsX/zMfWLS1KIuH+hV3Jek
 IeP+olEV9FhAvpQv9Mw==
X-Authority-Analysis: v=2.4 cv=F+7C5ahN c=1 sm=1 tr=0 ts=6aa69f01 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8
 a=G2-K4aFLVDk7lefjgnMA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-13_04,2026-09-11_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 phishscore=0 clxscore=1015 malwarescore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609130186

On 9/12/26 7:51 PM, yu kuai wrote:
> Hi,
> 
> 在 2026/9/7 14:02, Nilay Shroff 写道:
>> On 9/6/26 5:09 PM, yu kuai wrote:
>>> Hi,
>>>
>>> 在 2026/9/6 18:56, Nilay Shroff 写道:
>>>> On 8/23/26 7:00 PM, Yu Kuai wrote:
>>>>> @@ -257,20 +262,21 @@ static inline bool
>>>>> bio_issue_as_root_blkg(struct bio *bio)
>>>>>      * @blkcg: blkcg of interest
>>>>>      * @q: request_queue of interest
>>>>>      *
>>>>>      * Lookup a blkg for the @blkcg - @q pair, whether it is online or
>>>>> dying.
>>>>>      *
>>>>> - * Must be called in a RCU critical section.
>>>>> + * Must be called with either RCU read lock or queue_lock held.
>>>>>      *
>>>>>      * This does not acquire a reference.  The caller must already hold
>>>>> one, or
>>>>>      * have the blkg pinned by I/O.
>>>>>      */
>>>>>     static inline struct blkcg_gq *blkg_lookup_any(struct blkcg *blkcg,
>>>>>                                struct request_queue *q)
>>>>>     {
>>>>> -    RCU_LOCKDEP_WARN(!rcu_read_lock_held(),
>>>>> -             "blkg_lookup_any() requires an RCU read lock");
>>>>> +    RCU_LOCKDEP_WARN(!rcu_read_lock_held() &&
>>>>> +             !lockdep_is_held(&q->queue_lock),
>>>>> +             "blkg_lookup_any() requires an RCU read lock or
>>>>> queue_lock");
>>>>>           return rhashtable_lookup(&q->blkg_hash, &blkcg->css.id,
>>>>>                      blkg_hash_params);
>>>>>     }
>>>>
>>>> The changes look good to me. However, rhashtable_lookup() is annotated
>>>> with __must_hold_shared(RCU). Since we now officially support Clang
>>>> context annotations in the block layer, compiling with the latest
>>>> Clang/LLVM generates a number of context warnings, for example:
>>>>
>>>> block/blk-cgroup.h:277:9: warning: calling function 'rhashtable_lookup'
>>>> requires holding __ctx_lock_RCU 'RCU' [-Wthread-safety-analysis]
>>>>     277 |         return rhashtable_lookup(&q->blkg_hash,
>>>> &blkcg->css.id,
>>>>         |                ^
>>>>
>>>> The same warning is reported from several other block layer source
>>>> files that include blk-cgroup.h.
>>>>
>>>> This indicates that rhashtable_lookup() requires the RCU read lock
>>>> from Clang's context-analysis perspective. Looking at the call paths of
>>>> blkg_lookup_any(), it appears that not all callers hold
>>>> rcu_read_lock() when invoking it.
>>>
>>> I was not aware of the above clang warning, this should not be a real
>>> problem
>>> because queue_lock should have the same protection as rcu, and I was
>>> trying
>>> not to make this patch too complex.
>>>
>> I agree that this is not a runtime correctness issue when the lookup
>> is already
>> protected by q->queue_lock.
>>
>>> I add the rcu_read_lock() in the following patch to covert queue_lock
>>> to blkcg_mutex:
>>>
>>> [RFC PATCH v3 3/6] blk-cgroup: protect blkgs with blkcg_mutex - Yu
>>> Kuai
>>> <https://lore.kernel.org/all/20260823152926.1043863-4-yukuai@kernel.org/>
>>>
>>> Since this is related to compile warning, I'll move the rcu
>>> protection to this
>>> patch.
>>>
>> Since rhashtable_lookup() is annotated with __must_hold_shared(RCU),
>> Clang's
>> context analysis still reports warnings for these call paths. While this
>> doesn't cause a build failure (and only generates warning) when
>> CONFIG_WERROR
>> is not enabled, it could do so for configurations that enable
>> CONFIG_WERROR=y.
>>
>> So IMO, moving the rcu_read_lock() protection into this patch makes
>> sense.
>> This would avoid introducing the Clang warnings/errors in this patch,
>> and then
>> you may accordingly adjust your subsequent series where the
>> q->queue_lock protection
>> is removed and the blkg lookup paths are protected by RCU.
>>
>> I also noticed that some paths already take q->queue_lock followed by
>> rcu_read_lock(),
>> so adding the RCU protection here should be consistent with those
>> existing paths.
> 
> Turns out Clang will still warn after adding rcu_read_lock(). I'm not familiar how this
> works, but AI told me this is related to inline helpers, And I'll have to add the same
> __must_hold_shared(RCU) in rhashtable_lookup() for following inline callers to kill the
> warning:
> 
>     static inline struct blkcg_gq *blkg_lookup_any(...)
>           __must_hold_shared(RCU);
> 
>     static inline struct blkcg_gq *blkg_lookup(...)
>           __must_hold_shared(RCU);
> 
Yes, that's correct. In this case the context requirement needs to be propagated through
the inline helper call chain.

Thanks,
--Nilay



