Received: from va-2-56.ptr.blmpb.com (va-2-56.ptr.blmpb.com [209.127.231.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5AE542BC54
	for <nvdimm@lists.linux.dev>; Fri, 14 Aug 2026 07:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786693827; cv=none; b=kwGiGOEIUfnljJ9eqZRTpklMYDopQfafAGJXRsQlQOQOnVyE7U0Ztu+pHWqsVQbqkGmpCkDjSE/Lrq7rDd1NPvnH40dLqzEJ1YKVBt1BvUy7KcSQEs3I/dOYIElAu2/6PBXvFF+C4Z2pddG91wW2Yf0yhmFOIXQxt75wfE6c9Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786693827; c=relaxed/simple;
	bh=Y2jZkZG5IdEinfxaABKa1bNtQfxrrDOJa1w7kxN9I5Y=;
	h=References:Content-Type:Cc:In-Reply-To:To:Date:Subject:Message-Id:
	 Mime-Version:From; b=Bkv04ClJPBuYyYmM9V9wi01Z4JVlhw89WoBQ6bXvY5wAAD/uaiCeW7GrtYBtzb2YXcEexidJI06Rd/RNCLMxKDPPeHYp98P0DEtz/LcnTc68OUTev4Sb41S8faEywBUoPvTRtxjJL+OLtZIkRSk+/dXhj/NFpGAzxbWJYjDp26E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=L7/Sqr2Y; arc=none smtp.client-ip=209.127.231.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="L7/Sqr2Y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1786693811;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=JbnLgklqOUcOfZtgfE8qoZAa4WQi1t4pHM8VNSJ95PY=;
 b=L7/Sqr2YloWcCd+CLuHsctvb17T7wRA1u8EeyL71rexTLznirImCcRNGShoamsifvNP838
 CY/EyFMwObsNum1JoF8LIjq/RFrSC8vStettKoF6i51yLAW07hcudtN3mivQCrsafYgAl4
 KkT7BYhMbbM5oNRcU+Nh6x34Y1KgWh9in+oxdMjmqF45CRc0eLxrise6z06fzJ7uQc/NuN
 0y1mz0aUe8jnT/KsiQ+e1V3qFagpdJUZGm3swFRJLfIImlS3w1nJI9e2LTDiiVEW9uIaYp
 UatwlhWuY5fbRtuq6gNXTOQ7brg2wieqFZPdJEkCgsBRf04R6+onPRRTelpNfw==
References: <20260811064744.1139446-1-yukuai@kernel.org> <20260811064744.1139446-3-yukuai@kernel.org> <20260814071232.GA9784@lst.de>
Content-Type: text/plain; charset=UTF-8
Received: from [192.168.1.104] ([39.182.0.156]) by smtp.feishu.cn with ESMTPS; Fri, 14 Aug 2026 15:50:07 +0800
Cc: "Jens Axboe" <axboe@kernel.dk>, "Tejun Heo" <tj@kernel.org>, 
	"Josef Bacik" <josef@toxicpanda.com>, 
	"Johannes Weiner" <hannes@cmpxchg.org>, 
	=?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	"Yu Kuai" <yukuai@fygo.io>, "Tao Cui" <cui.tao@linux.dev>, 
	"Jan Kara" <jack@suse.cz>, "Ming Lei" <ming.lei@redhat.com>, 
	"Jonathan Corbet" <corbet@lwn.net>, 
	"Shuah Khan" <skhan@linuxfoundation.org>, "Coly Li" <colyli@fygo.io>, 
	"Kent Overstreet" <kent.overstreet@linux.dev>, 
	"Alasdair Kergon" <agk@redhat.com>, "Mike Snitzer" <snitzer@kernel.org>, 
	"Mikulas Patocka" <mpatocka@redhat.com>, 
	"Benjamin Marzinski" <bmarzins@redhat.com>, "Song Liu" <song@kernel.org>, 
	"Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	"Pankaj Gupta" <pankaj.gupta.linux@gmail.com>, 
	"Dan Williams" <djbw@kernel.org>, 
	"Vishal Verma" <vishal.l.verma@intel.com>, 
	"Dave Jiang" <dave.jiang@intel.com>, 
	"Alison Schofield" <alison.schofield@intel.com>, 
	"Ira Weiny" <iweiny@kernel.org>, 
	"Andreas Gruenbacher" <agruenba@redhat.com>, 
	"Matthew Wilcox" <willy@infradead.org>, 
	"Andrew Morton" <akpm@linux-foundation.org>, 
	"Chris Li" <chrisl@kernel.org>, "Kairui Song" <kasong@tencent.com>, 
	"Kemeng Shi" <shikemeng@huaweicloud.com>, 
	"Nhat Pham" <nphamcs@gmail.com>, "Baoquan He" <baoquan.he@linux.dev>, 
	"Barry Song" <baohua@kernel.org>, 
	"Youngjun Park" <youngjun.park@lge.com>, <cgroups@vger.kernel.org>, 
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-block@vger.kernel.org>, <linux-bcache@vger.kernel.org>, 
	<dm-devel@lists.linux.dev>, <linux-raid@vger.kernel.org>, 
	<nvdimm@lists.linux.dev>, <virtualization@lists.linux.dev>, 
	<gfs2@lists.linux.dev>, <linux-fsdevel@vger.kernel.org>, 
	<linux-mm@kvack.org>
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20260814071232.GA9784@lst.de>
User-Agent: Mozilla Thunderbird
X-Lms-Return-Path: <lba+26a7ec8b1+184449+lists.linux.dev+yukuai@fnnas.com>
X-Original-From: Yu Kuai <yukuai@fnnas.com>
To: "Christoph Hellwig" <hch@lst.de>, "yu kuai" <yukuai@fygo.io>
Date: Fri, 14 Aug 2026 15:50:04 +0800
Subject: Re: [RFC PATCH v2 2/4] blk-cgroup: use a request_queue rhashtable for blkg lookup
Message-Id: <f7350050-062a-4ced-9396-05ac33ac3e60@fnnas.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Reply-To: yukuai@fygo.io
From: "Yu Kuai" <yukuai@fnnas.com>

Hi=EF=BC=8C

=E5=9C=A8 2026/8/14 15:12, Christoph Hellwig =E5=86=99=E9=81=93:
> On Tue, Aug 11, 2026 at 02:47:42PM +0800, Yu Kuai wrote:
>> Keep q->blkg_list for ordered policy and scheduler walks. Initialize and
>> destroy the hash with request_queue, and remove the radix-tree preload
>> paths which are no longer needed.
> Are these fast path operations?  Otherwise we can walk all rhashtable
> entries without an extra list, but it might be slower.

All users are from sysfs/cgroupfs API, I think they can be considered slow =
path,
however currently spinlock is held in these procedures, I think it's better=
 to
convert them to blkg_lookup based iterate after spinlock is converted to th=
e
blkcg_mutex.

>
>> @@ -191,10 +198,15 @@ static void blkg_release(struct percpu_ref *ref)
>>   {
>>   	struct blkcg_gq *blkg =3D container_of(ref, struct blkcg_gq, refcnt);
>>   	struct blkcg *blkcg =3D blkg->blkcg;
>>   	int cpu;
>>  =20
>> +	if (!list_empty(&blkg->q_node))
>> +		WARN_ON_ONCE(rhashtable_remove_fast(&blkg->q->blkg_hash,
>> +						    &blkg->q_hash_node,
>> +						    blkg_hash_params));
>> +
> The list_empty case is for initialization failure?  Or can we end up
> with that by other means?

Yes, this is for initialization failure, blkg_alloc() failure after percpu_=
ref_init(),
or blkg_create() failure before rhashtable_insert succeed.

>
>> + * Lookup a blkg for the @blkcg - @q pair, whether it is online or dyin=
g.
>> + *
>> + * Must be called in a RCU critical section.
>> + */
> Please add must_hold and/or lockdep annotations for this instead of just
> a comment.
>
> Also maybe mention that this does not acquire a reference and the caller
> must already hold one?

Perhaps it's more accurate that the blkg is pinned by IO or caller already
hold one?

>
>
--=20
Thanks,
Kuai
