Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12DE339399;
	Sun,  6 Sep 2026 11:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788692582; cv=none; b=ivlC42c16SJzMHT+t66fOYqxnN5iPCfa7LUXAG31NGS4hCGdVMDu7hikSYd5d/TB5AVQ6YvTpiH0rL6YrEVXE2ZsTEyiWbr4T8NF2vOgUXI1Bt7DGFVtvIBzWcatMhuAquimd3jmQtkUBFVVSpwLpx4ZQ71fksiya1uDbSZGeZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788692582; c=relaxed/simple;
	bh=skKMiPSGdEwb6uMTgCnA9CvUSLZHcjLz2R+/ND6e7fI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J9nP8w9McJEd6BT8t2hufhtXj3LSoWWR1KtPvVdju1KeQEIKFXemKf80nh64mGkINks1ELXXfYrkOFZwtfLBRlENRjYVgUT0gXrsCTrhzys//2NqmFk9xSHOzxUZdODpFdCCAwwyZpzQgZFjL8XD+rTEsX2q0D3+20YAUqKmihg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=OObkrbZY; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="OObkrbZY"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68602PR3579824;
	Sun, 6 Sep 2026 11:02:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=X1IxLt
	MyLl91TNarA6fdF5T0e/R6TVNbs54mrrqU6HI=; b=OObkrbZYzPkHj8C1IHm1cw
	B2in3kabJ0rpEBPZUMcEI/J3JEfIWf91b/UayzpycbxPgumYL0Wz3NLzbOu0enS+
	sF1OWRQjnW0WRl78zKzIaO0ahULX4Fde40kBqJDcGTpCmcw+NItG0AaykNMbIu4d
	N+eRt5eKZiFzxEwPKztQPCLC8nU3yAlvNrdz12npnfNr5FjiWX9XrwdnYUOwuDub
	fgUNICAKk0eujyxgr6A1bWYBM6eX3cVnNGPEarlAM6+Uoqg1SNNNhqLOmxPmrh5y
	l8ixxo+KuAYphS4/kYrLgthTo7z8nq4NPNHi8VEvR7LXZjFtiRaQNeyi1MCNYzdA
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ggbjrbx43-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 06 Sep 2026 11:02:21 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 686AuNY7025863;
	Sun, 6 Sep 2026 11:02:20 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ggymg11sn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 06 Sep 2026 11:02:20 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 686B2JIk14811848
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 6 Sep 2026 11:02:19 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 54D805806B;
	Sun,  6 Sep 2026 11:02:19 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 903505806D;
	Sun,  6 Sep 2026 11:01:59 +0000 (GMT)
Received: from [9.61.37.159] (unknown [9.61.37.159])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Sun,  6 Sep 2026 11:01:59 +0000 (GMT)
Message-ID: <d88a132d-177b-4d54-9927-3d16065c7b60@linux.ibm.com>
Date: Sun, 6 Sep 2026 16:31:58 +0530
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] blk-cgroup: move async bio punt state to blkcg
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
 <20260823133045.970199-4-yukuai@kernel.org>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <20260823133045.970199-4-yukuai@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=E7T9Y6dl c=1 sm=1 tr=0 ts=6a9d483e cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=dSZZVhdJ-k8saxBcLagA:9
 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA2MDEyMSBTYWx0ZWRfX1o5srX8k5MDO
 Qxb88bQbQQ5VjAC8W0ZmLS/FWvxDhHiuFXpmwA/LQnASHjk2pG3Fc76wsNlyo8Uhf/hUJaPRm6+
 DmBsZZxV0GGw1IhcFahi7eylI9awyx8=
X-Proofpoint-ORIG-GUID: 5uBq-q6HYJD-e2NLAJZ1n9AYoAJq0C2V
X-Proofpoint-GUID: 5KO3rSrRARleln9R8wOwhFqA1IMpf7-d
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA2MDEyMSBTYWx0ZWRfX85mhyvthZZx7
 TzUmMgNCnb7TchmNWsbrRuv3Gorv2/vurZ0nGyihr2AhCtn1gWQKsaD9XGLfVaCnyx+Eb9md+hs
 gP5DV/GbS5KT3KoxbVB2h3PFT7knHTE3xyDEVZduhr8qwiTLbOg52xngThVa3NZWXXafcg6N3lN
 C5EZtWo2/ggCTLV9xFtnQ6qkIGDMYBQ+zVxujXVUfG3mMto5Mde4wjmXatoVPMroxuT6zTRDf1V
 YSbbcAhY7vOBRKSyNhHnuNvrcLsUegAisrdkVX/oBGVdwphlLzf45zZzQMKXAJ8MY9QoROhfmjW
 D+aE4RyM98U8SLR09fYL32ODNR30XoOBgptJuC2elr4hdCRhEzpxcsFJaXfPBtg+McldK0QWsbp
 Ss1RqgBY08Iq+iQvKDj328NPcFZfgeScUIK7Kz3ZLK2PweQ6Uedpjc25K3UzzvZGDbu+x7mM4/O
 5nCRgYBPwPvBRQ2ZIYw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-05_08,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 phishscore=0 spamscore=0 suspectscore=0 priorityscore=1501
 bulkscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609060121

On 8/23/26 7:00 PM, Yu Kuai wrote:
> @@ -111,10 +104,15 @@ struct blkcg {
>   	/*
>   	 * List of updated percpu blkg_iostat_set's since the last flush.
>   	 */
>   	struct llist_head __percpu	*lhead;
>   
> +#ifdef CONFIG_BLK_CGROUP_PUNT_BIO
> +	spinlock_t			async_bio_lock; /* protects async_bios */
> +	struct bio_list			async_bios;
> +	struct work_struct		async_bio_work;
> +#endif
>   #ifdef CONFIG_BLK_CGROUP_FC_APPID
>   	char                            fc_app_id[FC_APPID_LEN];
>   #endif
>   #ifdef CONFIG_CGROUP_WRITEBACK
>   	struct list_head		cgwb_list;

As I mentioned, Clang context annotations are now officially supported
in the block layer. Since you're touching this code, I suggest annotating
async_bios with __guarded_by(&async_bio_lock) as well.

This would allow the Clang thread-safety analyzer to verify that every
access to async_bios is properly protected by async_bio_lock.

Thanks,
--Nilay
