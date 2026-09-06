Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D0E61FCE;
	Sun,  6 Sep 2026 11:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788692646; cv=none; b=Sa7Ql4Frn8aXUOvSkin8zNTD8E+x722wvHc19iPn9fmsuFy1SVkViA+ZyT1ZIfquHtmhU/1NNQGvKeVcbj4Huu7vMDWTvIOai7k3mjky7r+nJqPCUK1LyFg0hoVCf2c+DURZwzeEieE+HPUHoUsUyULHhDNRGZMx+GgDZ0qWS58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788692646; c=relaxed/simple;
	bh=3r1YeAMVMGuHbNglZ/uSkSe/d0j+JSCsq4mI31UGGSw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GFwtC4PsHO1iMu0mbeUKVeEXj1GCqXst0ateI2tIin2w5X3EgfSjYQkRsjmFmjoyETaIAy6gN2ZBnt8XdNIDbR7jLT7BAHYe+by4jx43K9czXj6ZVwUN+J6sX5hN3xQJ9WdxK5LGl6gV2jiREegxNjTgOgLNDD3k6A70vhbLxsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=tk5uvgAZ; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="tk5uvgAZ"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68601bOX1593880;
	Sun, 6 Sep 2026 11:03:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=u4Ur7E
	OpJrkbjOzKwMcE8i5Zrhz3ZlOz2pIygiAhYTQ=; b=tk5uvgAZPO8XPnWo3DG3hV
	PnrHp7OYb8bY6c+PIOXEb9FqtkBmN3zf7wR/I0Cgl7ONjT17TQumvxDD+MB3BCSG
	WM6h3KImckluQsZmWcwbQrNQ+sr/My8leE4tysG2vlVaDmpfOddVHTS3gDn7L1QX
	uzp+8cEHT19wcZYi1SYoRuzDpr6lm6UpnR3Bh5T73GydMsRwlyO9Pf4LxTWcrzrP
	oCtbyvGxiRcpZOtleYQZI/sO6VSuuFyF39JPGPBUpyuq+vThHfQjgtv7liBqm1+t
	inL9Xl8CMDT/wTkMnXUx6xtgM14Nx9E/pxd8hPbQHNRW5BnT4mVcmw1ZEA3P0NmQ
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ggbj7uxah-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 06 Sep 2026 11:03:28 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 686AuQTh004474;
	Sun, 6 Sep 2026 11:03:27 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ggwdq1cae-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 06 Sep 2026 11:03:27 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 686B3Q7m15991378
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 6 Sep 2026 11:03:26 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 844055806E;
	Sun,  6 Sep 2026 11:03:26 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 053E55806C;
	Sun,  6 Sep 2026 11:03:11 +0000 (GMT)
Received: from [9.61.37.159] (unknown [9.61.37.159])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Sun,  6 Sep 2026 11:03:10 +0000 (GMT)
Message-ID: <350d1460-4650-4964-8795-aa67c5517dc3@linux.ibm.com>
Date: Sun, 6 Sep 2026 16:33:09 +0530
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] blk-cgroup: use a request_queue rhashtable for blkg
 lookup
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
 <20260823133045.970199-2-yukuai@kernel.org>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <20260823133045.970199-2-yukuai@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: d95BKotMcawyurNxSY90tErgpQBi82fX
X-Proofpoint-ORIG-GUID: KAqNhEunHYFEyAYPq95mN6bqZVHWW8h2
X-Authority-Analysis: v=2.4 cv=RNCD2Yi+ c=1 sm=1 tr=0 ts=6a9d4881 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8
 a=-_CD9Cme870wYPz7DKUA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA2MDEyMSBTYWx0ZWRfXyQhHoWQugryi
 aEVw8YT65jz7lXeJ6xFhrRRnoV1R089xeUtQKA0lXdjBN1Yfdg9lJ/qPBqqO7uIMMDWSMf2XR2R
 bJ7rjL2Z72rYW8+fjAqG/BU3rOOo0NQ=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA2MDEyMSBTYWx0ZWRfX7bmEr79g7ZP2
 aK8Z8do9uj3bOQC6vh1y+zeZ8hFkHV7hfiaR5vf/2y0bT/c2BTRfCSgA8NfYinjJIzK7WU8soyL
 DF12GL39mOBL1tt/4ss5iQsLen9RkA63xnJlnFUmr00uL8xlV/skklNjmDIP6wWkWUVddPBkAUI
 STZ0h/d0B45Wy9sGheIA9Aqtm0qruNelMJKtlYjZ3lDSu45hC0OUoGx7wnjFq7xqOHU5HmHkN9r
 GNEwuJoqIRMcBCy/6vdO8meow8C94llv4e+T/UqYfJfqUoxffkeLPvahNojanQwrSkN6Z1vdyQz
 oILe7ypVQ72ph+7uiVuWcnlBA2hJMxMx6+/IlhuZp/bOunsrzNoF56xYQksixd1ZwG1Vvu6I8F8
 SXGHg+w07Z5HSdx463FdparSEmlDROiaMUWc5/SqB1I+R5FoVQWnE/s9WPn6edlqeKjr49lBKSg
 5C6KVB6KpTyrSOVL+OA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-05_08,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 clxscore=1015 spamscore=0
 impostorscore=0 adultscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609060121

On 8/23/26 7:00 PM, Yu Kuai wrote:
> From: Yu Kuai<yukuai@fygo.io>
> 
> blkg lookup currently uses a per-blkcg radix tree keyed by request queue
> ID, plus a lookup hint for the common case. This spreads the queue-local
> blkcg association index across every blkcg and requires radix-tree
> preloading before creating a blkg while holding q->queue_lock.
> 
> Replace the radix tree and lookup hint with a request_queue-owned
> rhashtable keyed by the blkcg CSS ID. Cache the ID in each blkg; the blkg
> holds a CSS reference until after it leaves the hash, so the ID cannot be
> reused while it is hash-visible. The integer key also reduces hashing and
> comparison work relative to a pointer-sized key on 64-bit systems.
> 
> Keep entries until blkg_release() and provide blkg_lookup_any() for callers
> which need to find dying entries. blkg_lookup() filters offline entries so
> existing lookup semantics remain unchanged.
> 
> Keep q->blkg_list for ordered policy and scheduler walks. All current
> walkers are cgroupfs or sysfs slow paths, so they can move to rhashtable
> iteration once the q->queue_lock to q->blkcg_mutex conversion lands.
> Initialize and destroy the hash with request_queue, and remove the
> radix-tree preload paths which are no longer needed.
> 
> blkg_release() removes the hash entry only when the blkg was successfully
> inserted into q->blkg_list; the list_empty case covers allocation or
> creation failure before insertion.
> 
> Signed-off-by: Yu Kuai<yukuai@fygo.io>
> Reviewed-by: Christoph Hellwig<hch@lst.de>

Looks good to me.
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>

