Received: from va-2-46.ptr.blmpb.com (va-2-46.ptr.blmpb.com [209.127.231.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712DE3F1672
	for <nvdimm@lists.linux.dev>; Tue,  4 Aug 2026 15:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785856044; cv=none; b=fBFmQL+AWGElwdi5044nqTU5VB9Zb0Ttj9Yz33YqICKLafnLOK+hGMQ4L1mPA6YgvfebGOSgWLwWS9inndm+hnGVfvp+mxoH0RNz33AWCAYxVIV5aPLd0GWmSbTAbS77WFXSbKMQP8XYmx6NvfCG7HcqTNwhhD6SFoIiUWVWPe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785856044; c=relaxed/simple;
	bh=3vCX73HTin8OMhCLrL4mg1udeBnAS0Z1tTY+9wzBoW4=;
	h=To:Subject:Mime-Version:Cc:Date:Content-Type:References:From:
	 Message-Id:In-Reply-To; b=VOg6+CoHh9cgcE4zUEXm3kuaYEnqI1vQKk0oO406932FuAHrKDwWAFgY5oN9vyi2+NLEnfv+1c1swDYgksnDwO3d8k5Pp4cP468Af1mBVUxhXrS/8TJeuBLvX9u1jJWm1sLhmTxTLqComXTpuRN2ic3lvy++GvPfSZrn43DJc5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=V1STQS/d; arc=none smtp.client-ip=209.127.231.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="V1STQS/d"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1785856032;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=aTkMnMJBZbmBk8aXgbvQ0jabgPpSOlUfMkXtPY+IHFY=;
 b=V1STQS/dXR/HSPdjfm3Z1JQVZ9XApb10C3EpWxb/YHFtZgCWgot2COjPgsuahxvGehWhgr
 2jq6BOpr2EYgx0tkND9n460gcNbrVty7i3UF7stSYVlVCrTs1/rW3sb2um4NO3Oe2P4RGk
 ZxnEJ/5IVY3VboGAluJxadgFM2cZpuVHeGahtB2wxHDzUpbguPxouapWFWxw9Kza71wEYb
 mZ4yuTbYv+Za8FsD0A7TPmKGdIP6anMykJ/Q8SiOqfHEWQ8zBDn00pl40h7T9nOFdY9NAF
 65lp+fHrKCZSWuhCuqwoidZbx8ATlYLgABCj85lPyKYABL7Yx2DhO0nI3GE9jQ==
Reply-To: yukuai@fygo.io
To: "Christoph Hellwig" <hch@lst.de>, "Jan Kara" <jack@suse.cz>, 
	"yu kuai" <yukuai@fygo.io>
Subject: Re: [RFC PATCH v1 1/3] blk-cgroup: add helpers for bio cgroup state
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Received: from [192.168.1.104] ([39.182.0.181]) by smtp.larksuite.com with ESMTPS; Tue, 04 Aug 2026 15:07:11 +0000
Cc: "Yu Kuai" <yukuai@kernel.org>, "Jens Axboe" <axboe@kernel.dk>, 
	"Tejun Heo" <tj@kernel.org>, "Johannes Weiner" <hannes@cmpxchg.org>, 
	=?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	"Jonathan Corbet" <corbet@lwn.net>, "Josef Bacik" <josef@toxicpanda.com>, 
	"Coly Li" <colyli@fygo.io>, 
	"Kent Overstreet" <kent.overstreet@linux.dev>, 
	"Alasdair Kergon" <agk@redhat.com>, "Mike Snitzer" <snitzer@kernel.org>, 
	"Mikulas Patocka" <mpatocka@redhat.com>, 
	"Benjamin Marzinski" <bmarzins@redhat.com>, "Song Liu" <song@kernel.org>, 
	"Dan Williams" <djbw@kernel.org>, 
	"Vishal Verma" <vishal.l.verma@intel.com>, 
	"Dave Jiang" <dave.jiang@intel.com>, 
	"Alison Schofield" <alison.schofield@intel.com>, 
	"Pankaj Gupta" <pankaj.gupta.linux@gmail.com>, 
	"Andreas Gruenbacher" <agruenba@redhat.com>, 
	"Matthew Wilcox" <willy@infradead.org>, 
	"Andrew Morton" <akpm@linux-foundation.org>, 
	"Chris Li" <chrisl@kernel.org>, "Kairui Song" <kasong@tencent.com>, 
	"Nilay Shroff" <nilay@linux.ibm.com>, "Tao Cui" <cui.tao@linux.dev>, 
	<cgroups@vger.kernel.org>, <linux-doc@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-block@vger.kernel.org>, 
	<linux-bcache@vger.kernel.org>, <dm-devel@lists.linux.dev>, 
	<linux-raid@vger.kernel.org>, <nvdimm@lists.linux.dev>, 
	<virtualization@lists.linux.dev>, <gfs2@lists.linux.dev>, 
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>
Date: Tue, 4 Aug 2026 23:07:03 +0800
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26a720020+e59529+lists.linux.dev+yukuai@fygo.io>
References: <20260804065313.2092022-1-yukuai@kernel.org> <20260804065313.2092022-2-yukuai@kernel.org> <prx5s4rwbgoeh7wtgyo7vwydh5iwqn6qc2utamowirsplspfmp@e3eteq5xwuyf> <20260804132527.GA8078@lst.de>
From: "yu kuai" <yukuai@fygo.io>
Message-Id: <a780016f-8f94-4337-b700-786f5487ca3f@fygo.io>
User-Agent: Mozilla Thunderbird
In-Reply-To: <20260804132527.GA8078@lst.de>
X-Original-From: yu kuai <yukuai@fygo.io>

Hi,

=E5=9C=A8 2026/8/4 21:25, Christoph Hellwig =E5=86=99=E9=81=93:
> On Tue, Aug 04, 2026 at 12:52:16PM +0200, Jan Kara wrote:
>> Mostly looks good. Just I think bio_blkcg() should gracefully handle the
>> case where bio->bi_blkg is NULL (and return NULL in that case). That way
>> you can also get rid of somewhat odd pattern:
>>
>> 	if (!bio_blkg(bio))
>> 		return ...;
>> 	do something with bio_blkcg(bio)
>>
>> You can then just check bio_blkcg(bio) directly which is much more obvio=
us.
> Yes.  Looking at the whole series I'm also not sure that this makes too
> much sense as a split out patch as the next one touches more than half
> of the callsite anyway.

Yes, this make sense, I'm trying not to cook a huge patch, but patch 2 is g=
row
much bigger than I was expected. Unless I figure out a nicer way to split p=
atch 2,
I'll merge them in the next version.

>
--=20
Thanks,
Kuai
