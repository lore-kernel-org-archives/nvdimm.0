Received: from mta1.migadu.com (out-15.mta1.migadu.com [95.215.58.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02CE3D47B3
	for <nvdimm@lists.linux.dev>; Thu, 20 Aug 2026 09:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787219920; cv=none; b=JQHFHqTw0OVB6l2/JMADBRQJ7DPIhs4rRN6FT2n61tOareoOqP3D9fILB3YTIh7Xs7E+aaKU9I0ucVPv73wMCnQt0j7VC6aRnPCQOl84t1CfaLJhVMK2OUGv+AnidB9Grpeky1UK1gAyondgdaAFkfc+6a6VJqzd1VogwA2FB9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787219920; c=relaxed/simple;
	bh=6+e0IVBhQsqNOnef2seSVjbtBoQ3uLTFSRseSeIlRqA=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=AYtRjbBDSSb2h1cSGVZA5j/CPV4DCtqXykKRQ94qTdyZ/jt8zbhqEBX42GH17njEa8irG0v3AA8DjqLwwdWa2nVxxE0fo2YXUcbMa0X9tQjauESmUvLNdaatIKbjziY/bGJ0QvBMCQS+0vY0GDIFVrnuGik8apc0ynapfDnhk6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FdIXlOYN; arc=none smtp.client-ip=95.215.58.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FdIXlOYN"
X-Envelope-To: nvdimm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=6+e0IVBhQsqNOnef2seSVjbtBoQ3uLTFSRseSeIlRqA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787219916; v=1; x=1787824716;
 b=FdIXlOYNJW3tKLZOZLidF9aFp5YCR/c7kD6T9z2R+LihnpSwEbI1Bc6QpvEL8PlKdOB/p+XJ
 7YUuEAXEvm4iIPUVDrmwAfSftpVu5CMG5a8PfEPsn4n4MldOy520m97f0v74LZqsf1FhQdaiwA0
 V5DzhQ0uL7I6Ox28XXzuGA24=
X-Envelope-To: nvdimm@lists.linux.dev
Received: from [192.168.110.173] (223.70.159.239)
	by smtp.migadu.com with ESMTPS id 30b66ec55db78dc2;
	Thu, 20 Aug 2026 09:58:35 +0000
X-Mizu-Trace-ID: 30b66ec55db78dc2
X-Migadu-Flow: FLOW_OUT
Message-ID: <9c699958-c5b6-4aff-adf2-7c27a91cf4c2@linux.dev>
Date: Thu, 20 Aug 2026 17:58:26 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: cui.tao@linux.dev, Yu Kuai <yukuai@fygo.io>,
 Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>,
 Ming Lei <ming.lei@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Coly Li <colyli@fygo.io>,
 Kent Overstreet <kent.overstreet@linux.dev>, Alasdair Kergon
 <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>, Song Liu <song@kernel.org>,
 Li Nan <magiclinan@didiglobal.com>, Xiao Ni <xiao@kernel.org>,
 Pankaj Gupta <pankaj.gupta.linux@gmail.com>, Dan Williams <djbw@kernel.org>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Alison Schofield <alison.schofield@intel.com>, Ira Weiny
 <iweiny@kernel.org>, Andreas Gruenbacher <agruenba@redhat.com>,
 Matthew Wilcox <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-raid@vger.kernel.org, nvdimm@lists.linux.dev,
 virtualization@lists.linux.dev, gfs2@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v3 2/3] blk-cgroup: store blkcg in bio instead of blkg
To: Yu Kuai <yukuai@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>
References: <20260818070641.756747-1-yukuai@kernel.org>
 <20260818070641.756747-3-yukuai@kernel.org>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <20260818070641.756747-3-yukuai@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/8/18 15:06, Yu Kuai 写道:
> A bio currently stores and pins a queue-local blkg. This forces bio
> association and remap paths to look up or create a blkg even when no
> blkcg policy will use the bio, and ties the stored state to the current
> block device.
> 
> Store and reference the queue-independent blkcg in the bio instead. Add
> helpers that lazily look up or create the queue-local blkg when a policy
> needs it, and pin the result until the bio changes devices or releases
> its cgroup state.
> 
> If blkg creation fails while walking down the hierarchy, use the closest
> available ancestor and update the bio's blkcg association before recording
> the blkg reference. This keeps later CSS ID hash lookups matched with the
> pinned blkg.
> 
> Keep lookup-only users from creating missing blkgs. A pinned blkg remains
> in the queue hash until the bio drops its reference, so allow the bio to
> recover it from the hash after the blkg starts dying. Rename the bio
> association helpers to describe the blkcg state they now store.

Reviewed-by: Tao Cui <cuitao@kylinos.cn>

