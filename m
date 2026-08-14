Received: from va-2-42.ptr.blmpb.com (va-2-42.ptr.blmpb.com [209.127.231.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9055041D63F
	for <nvdimm@lists.linux.dev>; Fri, 14 Aug 2026 07:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786694041; cv=none; b=aj07g66gYkCyHKHsBlrM0xMKBRPCMBBbK8BIff+VJWLEtTOlNgxewOap3xijr/4cuTJN2BNtkB6aI+IKj+vIpi+hw2AQbk+QA2PeVno4RiCa0rM4Vc+E0RKwKsjNsryxQ6habRZtkn5fWSpkykrgbFWoa3wKAVdpS1bPVNwNJIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786694041; c=relaxed/simple;
	bh=QFfjU+Q2WwZUl8Er+UJiH8Rzzjka7vbj49Vhc47ZS7k=;
	h=Date:Message-Id:In-Reply-To:Content-Type:Cc:References:To:Subject:
	 Mime-Version:From; b=BcIHAsLsdF5DdA00vVDEY+rACdyqXABszeWeKu6zrQFO6UE572pJXttr3zLi/6nSZG/Kw/0hJtePZ6nvRI0dd4OmTpx97n2R/ziYfcctcyjN/I7RbtLoVCdXyl0MBm2sogHkQGKL3P/a+It15TnNHI0ADU0YkUW88/4Q5fS/3Sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=C+kIyFuY; arc=none smtp.client-ip=209.127.231.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="C+kIyFuY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1786694034;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=d5X4CvU+1L3LRx9eYxrJOuZyHPoADtah9tMj/5sRYWk=;
 b=C+kIyFuY5Y/bvPNvTJ+xbcMYIkxz55i1ZKwol98/UpscSvJuvFaVOSKqHv6Bnold2SAj7X
 wEvEvfW0Hs+HAvFSWDsyJXULpaid0K9t7Ln9ef3ZjBshUJGFAVdonZa07Wsx4zqeG0ngSv
 xwJ2FuAdRcwP1MzmFBS/6kIxqx2QTVsZie8qipkEwVP2cy1qFIPjWfcNphITqAX8+2jExW
 FU9IrXGFjOYNQYAu71ij7jqcgFhtWP/vFDy7Izw9T6fEfMLKcg06WmxvfqdLVbw4jNeukq
 lTbMvfW4AQWdp5XD5KwG4wqN1MG7GV8FUb4rUe9QTYJlo4oPqZIZQ219AXkxsg==
Received: from [192.168.1.104] ([39.182.0.156]) by smtp.larksuite.com with ESMTPS; Fri, 14 Aug 2026 07:53:53 +0000
Date: Fri, 14 Aug 2026 15:53:44 +0800
Message-Id: <d1d47b32-b746-42d1-a391-5e37d4e373fb@fygo.io>
X-Original-From: yu kuai <yukuai@fygo.io>
In-Reply-To: <20260814064537.GA9355@lst.de>
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8
Reply-To: yukuai@fygo.io
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
References: <20260811064744.1139446-1-yukuai@kernel.org> <20260814064537.GA9355@lst.de>
To: "Christoph Hellwig" <hch@lst.de>, "yu kuai" <yukuai@fygo.io>
Subject: Re: [RFC PATCH v2 0/4] blk-cgroup: store blkcg in bio before blkcg_mutex conversion
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Lms-Return-Path: <lba+26a7ec991+22c2d5+lists.linux.dev+yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>

Hi,

=E5=9C=A8 2026/8/14 14:45, Christoph Hellwig =E5=86=99=E9=81=93:
> What tree does this apply to?  I get failures both for Jens'
> for-7.3/block and for-next trees in bfq-cgroups.c and bio.c

Oh, just realize this set is cooked based on Jens' initial for-7.3/block
branch. With the other set that is already applied:

30d0c34b72f8 (HEAD -> block-7.3-blkg_list-rhashtable) blk-cgroup: move asyn=
c bio punt state to blkcg
1aa13cdcc027 blk-cgroup: store blkcg in bio instead of blkg
058ff5f9c8ac blk-cgroup: use a request_queue rhashtable for blkg lookup
fefb6604e496 blk-cgroup: wait for old blkgs to leave queue before disk rebi=
nd
f2690679ecf3 (for-7.3/block) blk-cgroup: factor policy pd teardown loop int=
o helper
ed3105cce735 blk-cgroup: skip dying blkg in blkcg_activate_policy()
415bd622f1a3 blk-cgroup: fix race between policy activation and blkg destru=
ction
4cc0299aea5d blk-cgroup: protect q->blkg_list iteration in blkg_destroy_all=
() with blkcg_mutex
f5098b6bae76 (tag: v7.2-rc5, block-7.2) Linux 7.2-rc5

I'll rebase to the latest for-7.3/block branch in the next version.

>
> On Tue, Aug 11, 2026 at 02:47:40PM +0800, Yu Kuai wrote:
>> From: Yu Kuai <yukuai@fygo.io>
>>
>> This RFC remains a preparatory series for the blkcg_mutex conversion
>> proposed in the related blkcg_mutex RFC v2 series [1].  That conversion
>> moves queue-local blkg topology synchronization from q->queue_lock to
>> q->blkcg_mutex, which is awkward while bios directly store queue-local
>> blkg references.
>>
>> v1 made the stored bio association queue-independent by replacing bi_blk=
g
>> with bi_blkcg, but a bio-owned blkg reference still had to be recovered =
by
>> looking up the bio's blkcg and current request_queue.  Tao Cui reported =
that
>> cgroup removal deletes a dying blkg from the per-blkcg radix tree before=
 a
>> throttled bio drops its reference.  A later lookup for that pinned blkg =
then
>> fails, triggers the warning in bio_pinned_blkg(), and leaks the referenc=
e.
>>
>> v2 makes request_queue the authoritative lookup owner before converting =
the
>> bio association.  A queue-owned rhashtable, keyed by the blkcg CSS ID, k=
eeps
>> dying blkgs discoverable until their references drain while q->blkg_list
>> remains available for ordered walks.  The bio conversion then stores and
>> pins the blkcg CSS, lazily creates a blkg only for users which need one,=
 and
>> uses lookup-only access for completion and accounting paths which alread=
y
>> own a blkg reference.  Async bio punt state is finally moved from blkg t=
o
>> blkcg so punting alone does not instantiate a queue-local blkg.
>>
>> Changes since v1:
>>
>>    - Add patch 1 to wait for every old blkg to leave q->blkg_list before=
 a
>>      shared request_queue is rebound, instead of treating root_blkg =3D=
=3D NULL
>>      as completion of asynchronous blkg teardown.
>>    - Add patch 2 to replace the per-blkcg radix tree and lookup hint wit=
h a
>>      request_queue rhashtable keyed by blkcg->css.id, as suggested by
>>      Christoph Hellwig.  Keep dying pinned blkgs in the hash until
>>      blkg_release() so bio-owned references remain discoverable.
>>    - Fold the v1 helper-only patch into patch 3, as suggested by Jan Kar=
a and
>>      Christoph Hellwig, and make bio_blkcg() naturally return NULL for a=
n
>>      unassociated bio.
>>    - Rework patch 3 so blkg_lookup_create() acquires the bio-owned refer=
ence,
>>      falls back to a live parent when creation or tryget fails, and upda=
tes
>>      bi_blkcg when the returned blkg belongs to an ancestor.
>>    - Make bio_blkg_lookup() lookup-only: it returns NULL unless BIO_BLKG=
_REF
>>      is already set.  Use bio_blkg() in the BFQ and IOCOST merge paths w=
hich
>>      may need to create a blkg, while keeping blk_cgroup_bio_start() and
>>      completion paths lookup-only.
>>    - Move CSS online-reference handling into
>>      bio_associate_blkcg_from_css(), including fallback to the root blkc=
g, so
>>      bio_associate_blkcg() does not take a redundant reference.
>>    - Keep the v1 async bio punt conversion as patch 4 and document that
>>      async_bio_lock protects async_bios.
>>
>> Previous versions:
>>    v1: https://lore.kernel.org/r/20260804065313.2092022-1-yukuai@kernel.=
org
>>
>> Related series:
>>    [1] RFC v2 blk-cgroup: protect blkgs with blkcg_mutex
>>        https://lore.kernel.org/r/20260724123037.3004560-1-yukuai@kernel.=
org
>>
>> Yu Kuai (4):
>>    blk-cgroup: wait for old blkgs to leave queue before disk rebind
>>    blk-cgroup: use a request_queue rhashtable for blkg lookup
>>    blk-cgroup: store blkcg in bio instead of blkg
>>    blk-cgroup: move async bio punt state to blkcg
>>
>>   Documentation/admin-guide/cgroup-v2.rst |   2 +-
>>   block/bfq-cgroup.c                      |  16 +-
>>   block/bfq-iosched.c                     |  19 +-
>>   block/bio.c                             |  22 +-
>>   block/blk-cgroup-fc-appid.c             |  10 +-
>>   block/blk-cgroup.c                      | 348 ++++++++++++++----------
>>   block/blk-cgroup.h                      |  82 ++++--
>>   block/blk-core.c                        |   9 +-
>>   block/blk-crypto-fallback.c             |   2 +-
>>   block/blk-iocost.c                      |  12 +-
>>   block/blk-iolatency.c                   |  11 +-
>>   block/blk-ioprio.c                      |   2 +-
>>   block/blk-throttle.c                    |   2 +-
>>   block/blk-throttle.h                    |   2 +-
>>   drivers/md/bcache/request.c             |   2 +-
>>   drivers/md/dm.c                         |   2 +-
>>   drivers/md/md.c                         |   2 +-
>>   drivers/nvdimm/nd_virtio.c              |   2 +-
>>   fs/gfs2/lops.c                          |   3 +-
>>   include/linux/bio.h                     |  26 +-
>>   include/linux/blk_types.h               |   9 +-
>>   include/linux/blkdev.h                  |   2 +
>>   include/linux/writeback.h               |   2 +-
>>   mm/page_io.c                            |  13 +-
>>   24 files changed, 357 insertions(+), 245 deletions(-)
>>
>>
>> base-commit: f2690679ecf3a3151688ebef766dd2512ff95854
>> --=20
>> 2.51.0
> ---end quoted text---
>
--=20
Thanks,
Kuai
