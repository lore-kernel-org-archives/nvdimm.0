Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 332272798F8;
	Sun,  6 Sep 2026 10:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788692279; cv=none; b=Yl5NwzUqbGKp9XOeXbrI+Eh5ELhsN/qGeORBMs6zEHZiIRnCOGRRQk1TSZQ0sCjnFfKymc5B7pRFMQPdjo4/gx8YqRScq/JCjm9M494K0UiWHhygnm0P2yIENWYXT5mvQvcBl8+BuTVm5BURs+a2dgdDAFCvsjaoVGrIyndHb3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788692279; c=relaxed/simple;
	bh=0sPJ2ft3SlDeiaCh+SHknVtFAqPO3k/VezhFQIhCmRw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E9ZfFZcaFZ7yGG79Dreb8hi/NDANOdNsZ3Ked/67A4syb0CD97GWA9MFCD2dyEpaoEAkybcmDIRIfIyCCnqkUzUF7vPWitpqhZU/LkHu/xq6KaZqmK6usDMHsxTmitZSLqqpXWkq9uECwXTOCdzpLyIGiyZvQGJe8GjK9Ia8pUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=S7rYxxY6; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="S7rYxxY6"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 686020Vg1726960;
	Sun, 6 Sep 2026 10:57:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=CJO3x7
	/ku4GwOfAHK1yvS6a4nMjaD6JvRAuX0wDLQ8c=; b=S7rYxxY6zcM8nbVMOWgdTF
	L8STcgd3CrahGJAaNzeN85LFgAx4i+cFmGpuaY7VPvKvSk+8oLkN8xQrsStdoDxW
	3ttpzWz2tsVceDcm7JmiDxrKl5LpUwfU0glVgegZgPxS2sMeXR4lPsFpLClYYmIf
	Yltjiq+LJlsxp2vEMwMIjrZQ85C3b3kuvQf+aIhc42I9OxlEdecc7/hQJpUCDBCh
	D0mpYXHMjP0JbIUSS2AwbH1NqiMOjjgzGn4pj2TBNFKp3Erh+AcsCk/PSCjyeyPL
	VYqtG34u7zhxUJL36MRb+OU7UeYYdJNm+wkQ5sFqOUXY+fsFwWmlVmcFbLQ++INA
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ggbhkc16y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 06 Sep 2026 10:57:15 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 686AubWd003155;
	Sun, 6 Sep 2026 10:57:14 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ggxwgs4m4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 06 Sep 2026 10:57:14 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 686AvDaR63242526
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 6 Sep 2026 10:57:14 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AA76C58052;
	Sun,  6 Sep 2026 10:57:13 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CC6575805D;
	Sun,  6 Sep 2026 10:56:51 +0000 (GMT)
Received: from [9.61.37.159] (unknown [9.61.37.159])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Sun,  6 Sep 2026 10:56:51 +0000 (GMT)
Message-ID: <49d724b8-57c6-48fc-8099-69cd1b072351@linux.ibm.com>
Date: Sun, 6 Sep 2026 16:26:49 +0530
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] blk-cgroup: store blkcg in bio instead of blkg
To: Yu Kuai <yukuai@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>
Cc: Yu Kuai <yukuai@fygo.io>, Christoph Hellwig <hch@lst.de>,
        Tao Cui <cui.tao@linux.dev>, Jan Kara <jack@suse.cz>,
        Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <skhan@linuxfoundation.org>, Coly Li <colyli@fygo.io>,
        Kent Overstreet <kent.overstreet@linux.dev>,
        Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
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
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <20260823133045.970199-3-yukuai@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA2MDExNSBTYWx0ZWRfX8nPzv8kos0rY
 gaRnUKKcGNALxzB3/vHAzbEqdW0xDiZOYAx4ILGILucwdKgIFk887ytDoFJHjdLNIIoU0U28wkg
 99kGWRVx/84hhz99DvHnFHlPkgq8t4g=
X-Proofpoint-ORIG-GUID: QO9cXpi63Ac-WgxFKSeRW1G3065a91Z0
X-Authority-Analysis: v=2.4 cv=NMDlPU6g c=1 sm=1 tr=0 ts=6a9d470c cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VFI7-riRab948bACfH8A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA2MDExNSBTYWx0ZWRfX5kApbW8gd3Qz
 DMpvom0X+zhm7irsaQJ6mAVaI4c7fFZb6OCUL4FN1VsE8gIKoml2VgwWSS3Ht89m4Kx903rFHzm
 +w8Ln4HvNUOX8KbjCmz7cWCUEoP5shl5WP1KULzpnJ6bhD+uNxh5FpCYTK63tI8/lnkZlAV1XYR
 dOdi2asLwGkdvxgVpbTW1/4TlQJy3DAkd7C77yuCK+gyFTK8uV6i7LGBTHBM/f/to9s60Mrpf3T
 5g1JIEWFPtKNi+fT7YYNNyR0xx0UffonzsL4DAJLRuH2FVubnlofbGit1v+6LN0JH69tf9rZtiC
 4GaqdYZlLu0dcpN2b4oXW0lr2G0Sl6qaCz1W8ovkl7z9izgXVNPEoOKIijRQ4AKbnW2OsSXnfLY
 EVf0FPSp1XJfKu+lkUJhQ29RGLuLbqT0l6tYVJvTIABWcBejSLG1RWLoxLvxHhHdEZrbvp2nA67
 eT0+svYbY1yfB0y+dTA==
X-Proofpoint-GUID: 4Azach-Fc91njV1xry32_utpY9oMYi9C
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-05_08,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 spamscore=0 lowpriorityscore=0 clxscore=1011 adultscore=0
 impostorscore=0 bulkscore=0 malwarescore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609060115

On 8/23/26 7:00 PM, Yu Kuai wrote:
> @@ -257,20 +262,21 @@ static inline bool bio_issue_as_root_blkg(struct bio *bio)
>    * @blkcg: blkcg of interest
>    * @q: request_queue of interest
>    *
>    * Lookup a blkg for the @blkcg - @q pair, whether it is online or dying.
>    *
> - * Must be called in a RCU critical section.
> + * Must be called with either RCU read lock or queue_lock held.
>    *
>    * This does not acquire a reference.  The caller must already hold one, or
>    * have the blkg pinned by I/O.
>    */
>   static inline struct blkcg_gq *blkg_lookup_any(struct blkcg *blkcg,
>   					       struct request_queue *q)
>   {
> -	RCU_LOCKDEP_WARN(!rcu_read_lock_held(),
> -			 "blkg_lookup_any() requires an RCU read lock");
> +	RCU_LOCKDEP_WARN(!rcu_read_lock_held() &&
> +			 !lockdep_is_held(&q->queue_lock),
> +			 "blkg_lookup_any() requires an RCU read lock or queue_lock");
>   
>   	return rhashtable_lookup(&q->blkg_hash, &blkcg->css.id,
>   				 blkg_hash_params);
>   }

The changes look good to me. However, rhashtable_lookup() is annotated
with __must_hold_shared(RCU). Since we now officially support Clang
context annotations in the block layer, compiling with the latest
Clang/LLVM generates a number of context warnings, for example:

block/blk-cgroup.h:277:9: warning: calling function 'rhashtable_lookup'
requires holding __ctx_lock_RCU 'RCU' [-Wthread-safety-analysis]
   277 |         return rhashtable_lookup(&q->blkg_hash, &blkcg->css.id,
       |                ^

The same warning is reported from several other block layer source
files that include blk-cgroup.h.

This indicates that rhashtable_lookup() requires the RCU read lock
from Clang's context-analysis perspective. Looking at the call paths of
blkg_lookup_any(), it appears that not all callers hold
rcu_read_lock() when invoking it.

I think we should fix those call paths to acquire rcu reader lock
before calling blkg_lookup_any(), rather than weakening or bypassing
the context annotation in blkg_lookup_any().

Thanks,
--Nilay

