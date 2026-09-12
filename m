Received: from va-2-59.ptr.blmpb.com (va-2-59.ptr.blmpb.com [209.127.231.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED22345CCE
	for <nvdimm@lists.linux.dev>; Sat, 12 Sep 2026 14:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.59
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222908; cv=none; b=ARBJ2fpPdVA2LzO3AdV7oFszFZqDpCXaY/ntGYP4ebIFC3QJ2qFXKCA9R5HJF19afUGyk5LDZZhmS8k/HmlLcQi09Bx5WEZON1V//F7gBVchmAq4xgVzQFiqi30T1dJuEyYETePFRRYAy/YoEBoAU+7Wp/xRjTTbcS/ATa6Kn5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222908; c=relaxed/simple;
	bh=0wX6hOxSyzv13NfzbyN+AEPTOtfdE4C+hpqJPodyllQ=;
	h=Subject:Mime-Version:Date:From:Content-Type:In-Reply-To:To:Cc:
	 Message-Id:References; b=kqqkavGRAsj+Qov2dcN64uREx8fkSBlLzTTC0+kEBXTTMK5QHPms918ejBdfs7esRuBfQsSRndUaTqaajGl0OjV7xFy6EaXLrlucpgtfwlSYRCi3oHPav7iV2cMDGI0P4t0Ar4aES2Wwsd/odvsBVZWjhJWpUnCYxnGm56RU3e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=UGldNLs5; arc=none smtp.client-ip=209.127.231.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="UGldNLs5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1789222897;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=m4/pESkF5aOOEVFDthMDfJ73cy1uGXqcU5VDQUIbEYU=;
 b=UGldNLs5R+8hoPWBCmTD+McM5Lu8GHuFFxsmAmDuGrVLgTG7E9C0LBRQSirs7xt/2EJDwa
 MpkQdDwP6+tg/xRfQJz06LqsuuwEGE1G8V1M/vDR/gVJeGWeWyVYUi8CbcSAiYrs8dwL1S
 H5WrG0RhB1nnSdMfCNZEjrEgqOrXZ4rWyP4w8cUygCNxY3Sa97c10ob+L8OOlkylzKKnxQ
 /B0Ky1v9kHB/rknQECUEC8/bx/mXrCnIkoe8x/3T/U9gowiymL3x1DGXVF9dQGIqNWLTBq
 bMThFbPAPYcXsLS9ztGL8N/N5LLnQZsBtnSl3BTxJry0yWA7JeGYzv2Md+2UrQ==
X-Lms-Return-Path: <lba+26aa55ff0+6b59bd+lists.linux.dev+yukuai@fygo.io>
Subject: Re: [PATCH 2/3] blk-cgroup: store blkcg in bio instead of blkg
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Received: from [192.168.1.104] ([39.182.0.161]) by smtp.larksuite.com with ESMTPS; Sat, 12 Sep 2026 14:21:35 +0000
User-Agent: Mozilla Thunderbird
Date: Sat, 12 Sep 2026 22:21:28 +0800
Content-Transfer-Encoding: quoted-printable
X-Original-From: yu kuai <yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <a123f309-6ec7-470f-b5b0-f08cca6d2627@linux.ibm.com>
Reply-To: yukuai@fygo.io
To: "Nilay Shroff" <nilay@linux.ibm.com>, "Jens Axboe" <axboe@kernel.dk>, 
	"Tejun Heo" <tj@kernel.org>, "Josef Bacik" <josef@toxicpanda.com>, 
	"Johannes Weiner" <hannes@cmpxchg.org>, 
	=?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	"yu kuai" <yukuai@fygo.io>
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
Message-Id: <4701cbcb-b877-4902-a5b6-59836c345ae1@fygo.io>
References: <20260823133045.970199-1-yukuai@kernel.org> <20260823133045.970199-3-yukuai@kernel.org> <49d724b8-57c6-48fc-8099-69cd1b072351@linux.ibm.com> <befbc177-f7f5-4c44-b02e-20a99fc64c0c@fygo.io> <a123f309-6ec7-470f-b5b0-f08cca6d2627@linux.ibm.com>

Hi,

=E5=9C=A8 2026/9/7 14:02, Nilay Shroff =E5=86=99=E9=81=93:
> On 9/6/26 5:09 PM, yu kuai wrote:
>> Hi,
>>
>> =E5=9C=A8 2026/9/6 18:56, Nilay Shroff =E5=86=99=E9=81=93:
>>> On 8/23/26 7:00 PM, Yu Kuai wrote:
>>>> @@ -257,20 +262,21 @@ static inline bool
>>>> bio_issue_as_root_blkg(struct bio *bio)
>>>> =C2=A0=C2=A0=C2=A0 * @blkcg: blkcg of interest
>>>> =C2=A0=C2=A0=C2=A0 * @q: request_queue of interest
>>>> =C2=A0=C2=A0=C2=A0 *
>>>> =C2=A0=C2=A0=C2=A0 * Lookup a blkg for the @blkcg - @q pair, whether i=
t is online or
>>>> dying.
>>>> =C2=A0=C2=A0=C2=A0 *
>>>> - * Must be called in a RCU critical section.
>>>> + * Must be called with either RCU read lock or queue_lock held.
>>>> =C2=A0=C2=A0=C2=A0 *
>>>> =C2=A0=C2=A0=C2=A0 * This does not acquire a reference.=C2=A0 The call=
er must already hold
>>>> one, or
>>>> =C2=A0=C2=A0=C2=A0 * have the blkg pinned by I/O.
>>>> =C2=A0=C2=A0=C2=A0 */
>>>> =C2=A0=C2=A0 static inline struct blkcg_gq *blkg_lookup_any(struct blk=
cg *blkcg,
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct request_queue *q)
>>>> =C2=A0=C2=A0 {
>>>> -=C2=A0=C2=A0=C2=A0 RCU_LOCKDEP_WARN(!rcu_read_lock_held(),
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 "blkg_lookup_any() requires an RCU read lock");
>>>> +=C2=A0=C2=A0=C2=A0 RCU_LOCKDEP_WARN(!rcu_read_lock_held() &&
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 !lockdep_is_held(&q->queue_lock),
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 "blkg_lookup_any() requires an RCU read lock or
>>>> queue_lock");
>>>> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return rhashtable_lookup(&=
q->blkg_hash, &blkcg->css.id,
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 blkg_hash_params);
>>>> =C2=A0=C2=A0 }
>>>
>>> The changes look good to me. However, rhashtable_lookup() is annotated
>>> with __must_hold_shared(RCU). Since we now officially support Clang
>>> context annotations in the block layer, compiling with the latest
>>> Clang/LLVM generates a number of context warnings, for example:
>>>
>>> block/blk-cgroup.h:277:9: warning: calling function 'rhashtable_lookup'
>>> requires holding __ctx_lock_RCU 'RCU' [-Wthread-safety-analysis]
>>> =C2=A0=C2=A0 277 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 retu=
rn rhashtable_lookup(&q->blkg_hash,=20
>>> &blkcg->css.id,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ^
>>>
>>> The same warning is reported from several other block layer source
>>> files that include blk-cgroup.h.
>>>
>>> This indicates that rhashtable_lookup() requires the RCU read lock
>>> from Clang's context-analysis perspective. Looking at the call paths of
>>> blkg_lookup_any(), it appears that not all callers hold
>>> rcu_read_lock() when invoking it.
>>
>> I was not aware of the above clang warning, this should not be a real=20
>> problem
>> because queue_lock should have the same protection as rcu, and I was=20
>> trying
>> not to make this patch too complex.
>>
> I agree that this is not a runtime correctness issue when the lookup=20
> is already
> protected by q->queue_lock.
>
>> I add the rcu_read_lock() in the following patch to covert queue_lock=20
>> to blkcg_mutex:
>>
>> [RFC PATCH v3 3/6] blk-cgroup: protect blkgs with blkcg_mutex - Yu=20
>> Kuai=20
>> <https://lore.kernel.org/all/20260823152926.1043863-4-yukuai@kernel.org/=
>
>>
>> Since this is related to compile warning, I'll move the rcu=20
>> protection to this
>> patch.
>>
> Since rhashtable_lookup() is annotated with __must_hold_shared(RCU),=20
> Clang's
> context analysis still reports warnings for these call paths. While this
> doesn't cause a build failure (and only generates warning) when=20
> CONFIG_WERROR
> is not enabled, it could do so for configurations that enable=20
> CONFIG_WERROR=3Dy.
>
> So IMO, moving the rcu_read_lock() protection into this patch makes=20
> sense.
> This would avoid introducing the Clang warnings/errors in this patch,=20
> and then
> you may accordingly adjust your subsequent series where the=20
> q->queue_lock protection
> is removed and the blkg lookup paths are protected by RCU.
>
> I also noticed that some paths already take q->queue_lock followed by=20
> rcu_read_lock(),
> so adding the RCU protection here should be consistent with those=20
> existing paths.

Turns out Clang will still warn after adding rcu_read_lock(). I'm not famil=
iar how this
works, but AI told me this is related to inline helpers, And I'll have to a=
dd the same
__must_hold_shared(RCU) in rhashtable_lookup() for following inline callers=
 to kill the
warning:

   static inline struct blkcg_gq *blkg_lookup_any(...)
         __must_hold_shared(RCU);

   static inline struct blkcg_gq *blkg_lookup(...)
         __must_hold_shared(RCU);

>
> Thanks,
> --Nilay

--=20
Thanks,
Kuai
