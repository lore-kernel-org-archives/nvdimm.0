Received: from va-2-60.ptr.blmpb.com (va-2-60.ptr.blmpb.com [209.127.231.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 909BC3358DA
	for <nvdimm@lists.linux.dev>; Sun,  6 Sep 2026 11:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.60
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788694902; cv=none; b=UjrbTSmtejZeaCa8RnRHP3fpy1q6+rTWkqlu2tfB8dlsuGnBg50KuYax1WxfmfKe0BkmVE5jOLPmOBAUH5srsqq3SjFA+1pWibqLgZGYLGySXZltKrW3dUUsYRLy/F5tsiBN/a0aYqscyt/pcYK3gEyznj/KxD1LqgPwYgmZWqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788694902; c=relaxed/simple;
	bh=Txjb4A2ru0WHH8ExTeA1+aRZilQ6U0tRJ24xs4Setuk=;
	h=Subject:Mime-Version:References:From:Date:Message-Id:Content-Type:
	 To:Cc:In-Reply-To; b=NvPJrIz2L36Wjo9Nf8AdwakICk6Bwrh1GIzZsgdiC0ZWEinA2w1pLCUHTICRfHfAnqxO7k70sQ+zTt5BIg4i7N8FdWi4pOqjqvEbiBZ0PZCtrVYLdrz4wvqigicr5oYXt6jKv7KQkSMtH5qVHh7dF/k2H2mhHEwmfmoUqsCWm8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=gsMGNOoB; arc=none smtp.client-ip=209.127.231.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="gsMGNOoB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1788694893;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=Txjb4A2ru0WHH8ExTeA1+aRZilQ6U0tRJ24xs4Setuk=;
 b=gsMGNOoBKWnuzNae+zqKdZqMscRCD1AiEZYEY6htIlRk6+gNoKGaQmKYsKYNBjNXUm1bg6
 xGaAOEqOARkImszoU6UA/pFzyCd7LSfk32qvYJElb/bqw7GJgVgWGZ/PG3teeTMVKxDjz2
 0+sL2e/vQDFiT2KHBN7ctjFgp5CUS+dexxkSZWJwgupilHVZmfc9Qu+tcyc4J2ZBybJEYE
 3O7lCgnI+/VOUxbbNaHQn/Cwet4hIu6rLmTVNizTAhAmTzubMJhfIq3DvQpPSPhj27EBwQ
 19siYfKDSN/tMAK0s7/7xhbUyXGLHqWKoqogA1tdzyeiqm81vko7cmrmvzJ4AQ==
Subject: Re: [PATCH 3/3] blk-cgroup: move async bio punt state to blkcg
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a9d516d+45cdc9+lists.linux.dev+yukuai@fygo.io>
References: <20260823133045.970199-1-yukuai@kernel.org> <20260823133045.970199-4-yukuai@kernel.org> <d88a132d-177b-4d54-9927-3d16065c7b60@linux.ibm.com>
Reply-To: yukuai@fygo.io
From: "yu kuai" <yukuai@fygo.io>
Content-Transfer-Encoding: quoted-printable
Received: from [192.168.1.104] ([39.182.0.178]) by smtp.larksuite.com with ESMTPS; Sun, 06 Sep 2026 11:41:32 +0000
Date: Sun, 6 Sep 2026 19:41:24 +0800
Message-Id: <4706f5fa-3a09-4c48-aa4b-c56521166618@fygo.io>
X-Original-From: yu kuai <yukuai@fygo.io>
Content-Type: text/plain; charset=UTF-8
User-Agent: Mozilla Thunderbird
To: "Nilay Shroff" <nilay@linux.ibm.com>, "Yu Kuai" <yukuai@kernel.org>, 
	"Jens Axboe" <axboe@kernel.dk>, "Tejun Heo" <tj@kernel.org>, 
	"Josef Bacik" <josef@toxicpanda.com>, 
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
In-Reply-To: <d88a132d-177b-4d54-9927-3d16065c7b60@linux.ibm.com>

Hi,

=E5=9C=A8 2026/9/6 19:01, Nilay Shroff =E5=86=99=E9=81=93:
> On 8/23/26 7:00 PM, Yu Kuai wrote:
>> @@ -111,10 +104,15 @@ struct blkcg {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * List of updated percpu blkg_iosta=
t_set's since the last flush.
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct llist_head __percpu=C2=A0=C2=A0=C2=
=A0 *lhead;
>> =C2=A0 +#ifdef CONFIG_BLK_CGROUP_PUNT_BIO
>> +=C2=A0=C2=A0=C2=A0 spinlock_t=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 async_bio_lock; /* protects async_bios */
>> +=C2=A0=C2=A0=C2=A0 struct bio_list=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 async_bios;
>> +=C2=A0=C2=A0=C2=A0 struct work_struct=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 async_bio_work;
>> +#endif
>> =C2=A0 #ifdef CONFIG_BLK_CGROUP_FC_APPID
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 char=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fc_app_id[FC_APPID_LEN]=
;
>> =C2=A0 #endif
>> =C2=A0 #ifdef CONFIG_CGROUP_WRITEBACK
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct list_head=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 cgwb_list;
>
> As I mentioned, Clang context annotations are now officially supported
> in the block layer. Since you're touching this code, I suggest annotating
> async_bios with __guarded_by(&async_bio_lock) as well.
>
> This would allow the Clang thread-safety analyzer to verify that every
> access to async_bios is properly protected by async_bio_lock.
Sounds reasonable, will do this in the next version.
>
> Thanks,
> --Nilay

--=20
Thanks,
Kuai
