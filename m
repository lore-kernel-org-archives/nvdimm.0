Received: from va-2-41.ptr.blmpb.com (va-2-41.ptr.blmpb.com [209.127.231.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39AA04279F9
	for <nvdimm@lists.linux.dev>; Sun,  6 Sep 2026 11:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788694822; cv=none; b=KFs5IJc7bIcwu/YVvjERvrGxxe2HsFk3KDUV8BOlaBikH2mEO/Yevd85QAu3sradAobznrVCF/xCTt9mwmMOqQL0G4Q8QiqjXEDXX9f7Qd/wqc/+lpuA5fc13wm1GboGX0zEELPLLR1yERGepzmbKR9+uAmbSY0/y1uHvbw1slk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788694822; c=relaxed/simple;
	bh=eEktsWXso/ZQaq8+Orw8lH87J9Mavxs+DZ2u0i4gb6U=;
	h=In-Reply-To:Cc:Mime-Version:From:Date:To:Message-Id:Content-Type:
	 References:Subject; b=tNNDnRZ6eLz1tp61W9oB+V4vIHUupZcHVVxz7CkgCWx31thsCCPIJWxunl+Su/xzp4VTEFrY+L68SAPn5Awy+AXgsp4/aAThhxDa2zLnpbkWGwBdi5hkNEGmH+yvdJvsF7ffBkHLwP10xB9gCjQyAb1mAH/2d/HsSY/3jsdh2DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=bFgMvn7H; arc=none smtp.client-ip=209.127.231.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="bFgMvn7H"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1788694802;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=eEktsWXso/ZQaq8+Orw8lH87J9Mavxs+DZ2u0i4gb6U=;
 b=bFgMvn7HS/3GeTGxiu9DPfrVkogWI7kPIhbufXYYGS6NBHIrnSJTG4n6eNN4C1yVb0LuT4
 yd5MtxWDrOpyMjGcUJ2lX6vEbuG77nt84WuK1duy/hb1t7+vmZf9XZT1g42DJnmbZ2KT7s
 yKnuBI9p0DEvyRIfrvPTt9FjM0K3ZzpnPU12G/6SP7kdOpt4dTpXLSjKvco8JwCWTEIbIk
 rD5Wk+hCsLA0wJo2yhYjf1Wi6FeRntdtDwQ0skqEqsSCLsbJLygfige3pa8vHyQimz9nat
 XIQTJ+LF0pW75DLAqf+IAEZB3QbC1Vnec6RuIPmNBpoJWx2gCzkVeGGE2nwmgQ==
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <49d724b8-57c6-48fc-8099-69cd1b072351@linux.ibm.com>
Cc: "Christoph Hellwig" <hch@lst.de>, "Tao Cui" <cui.tao@linux.dev>, 
	"Jan Kara" <jack@suse.cz>, "Jonathan Corbet" <corbet@lwn.net>, 
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
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
From: "yu kuai" <yukuai@fygo.io>
Date: Sun, 6 Sep 2026 19:39:52 +0800
X-Original-From: yu kuai <yukuai@fygo.io>
Received: from [192.168.1.104] ([39.182.0.178]) by smtp.larksuite.com with ESMTPS; Sun, 06 Sep 2026 11:40:00 +0000
X-Lms-Return-Path: <lba+26a9d5111+eda6c9+lists.linux.dev+yukuai@fygo.io>
Reply-To: yukuai@fygo.io
To: "Nilay Shroff" <nilay@linux.ibm.com>, "Yu Kuai" <yukuai@kernel.org>, 
	"Jens Axboe" <axboe@kernel.dk>, "Tejun Heo" <tj@kernel.org>, 
	"Josef Bacik" <josef@toxicpanda.com>, 
	"Johannes Weiner" <hannes@cmpxchg.org>, 
	=?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Message-Id: <befbc177-f7f5-4c44-b02e-20a99fc64c0c@fygo.io>
Content-Type: text/plain; charset=UTF-8
References: <20260823133045.970199-1-yukuai@kernel.org> <20260823133045.970199-3-yukuai@kernel.org> <49d724b8-57c6-48fc-8099-69cd1b072351@linux.ibm.com>
Subject: Re: [PATCH 2/3] blk-cgroup: store blkcg in bio instead of blkg
User-Agent: Mozilla Thunderbird

Hi,

=E5=9C=A8 2026/9/6 18:56, Nilay Shroff =E5=86=99=E9=81=93:
> On 8/23/26 7:00 PM, Yu Kuai wrote:
>> @@ -257,20 +262,21 @@ static inline bool=20
>> bio_issue_as_root_blkg(struct bio *bio)
>> =C2=A0=C2=A0 * @blkcg: blkcg of interest
>> =C2=A0=C2=A0 * @q: request_queue of interest
>> =C2=A0=C2=A0 *
>> =C2=A0=C2=A0 * Lookup a blkg for the @blkcg - @q pair, whether it is onl=
ine or=20
>> dying.
>> =C2=A0=C2=A0 *
>> - * Must be called in a RCU critical section.
>> + * Must be called with either RCU read lock or queue_lock held.
>> =C2=A0=C2=A0 *
>> =C2=A0=C2=A0 * This does not acquire a reference.=C2=A0 The caller must =
already hold=20
>> one, or
>> =C2=A0=C2=A0 * have the blkg pinned by I/O.
>> =C2=A0=C2=A0 */
>> =C2=A0 static inline struct blkcg_gq *blkg_lookup_any(struct blkcg *blkc=
g,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 struct request_queue *q)
>> =C2=A0 {
>> -=C2=A0=C2=A0=C2=A0 RCU_LOCKDEP_WARN(!rcu_read_lock_held(),
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 "blkg_lookup_any() requires an RCU read lock");
>> +=C2=A0=C2=A0=C2=A0 RCU_LOCKDEP_WARN(!rcu_read_lock_held() &&
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 !lockdep_is_held(&q->queue_lock),
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 "blkg_lookup_any() requires an RCU read lock or=20
>> queue_lock");
>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return rhashtable_lookup(&q->blkg_=
hash, &blkcg->css.id,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 blkg_hash_params);
>> =C2=A0 }
>
> The changes look good to me. However, rhashtable_lookup() is annotated
> with __must_hold_shared(RCU). Since we now officially support Clang
> context annotations in the block layer, compiling with the latest
> Clang/LLVM generates a number of context warnings, for example:
>
> block/blk-cgroup.h:277:9: warning: calling function 'rhashtable_lookup'
> requires holding __ctx_lock_RCU 'RCU' [-Wthread-safety-analysis]
> =C2=A0 277 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return rhash=
table_lookup(&q->blkg_hash, &blkcg->css.id,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ^
>
> The same warning is reported from several other block layer source
> files that include blk-cgroup.h.
>
> This indicates that rhashtable_lookup() requires the RCU read lock
> from Clang's context-analysis perspective. Looking at the call paths of
> blkg_lookup_any(), it appears that not all callers hold
> rcu_read_lock() when invoking it.

I was not aware of the above clang warning, this should not be a real probl=
em
because queue_lock should have the same protection as rcu, and I was trying
not to make this patch too complex.

I add the rcu_read_lock() in the following patch to covert queue_lock to bl=
kcg_mutex:

[RFC PATCH v3 3/6] blk-cgroup: protect blkgs with blkcg_mutex - Yu Kuai <ht=
tps://lore.kernel.org/all/20260823152926.1043863-4-yukuai@kernel.org/>

Since this is related to compile warning, I'll move the rcu protection to t=
his
patch.

>
> I think we should fix those call paths to acquire rcu reader lock
> before calling blkg_lookup_any(), rather than weakening or bypassing
> the context annotation in blkg_lookup_any().
>
> Thanks,
> --Nilay

--=20
Thanks,
Kuai
