Received: from mta0.migadu.com (out-29.mta0.migadu.com [91.218.175.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3543DA5A6
	for <nvdimm@lists.linux.dev>; Thu, 20 Aug 2026 09:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787219955; cv=none; b=NDuWpzPyO2xchgK0b4Sg/EgvrWhn7oLF2LIA8ASoBIoLngDli3Vrjriz5slsIXUuZ3DBhakc1GL99MetDry3pEiDhqIRz/wbdVeWfQD2EauFTg2yn+TwE7lvzTSk/MH/32GNLDQeCMPGwaAp2bYuarcPSk5Pxtj+Ek7P4wAwipY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787219955; c=relaxed/simple;
	bh=ibyIE9gKf2iOY1+mVf6oD4UPNPJ9RqEZuDFV5F2gXBk=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=tzCIMjr36u06AM97fs1ufEi+VCC/k0W7EJuIzKg04+mJ/LvD9eAwR4ABONEBqZ5SkHD4dwVvhcp+t+YT3A+9hXPjSSVyghnUG3EqXwC/+nV0ycrblSbIP1Sk2GLYFcaBO7iHmCvj8e4MBR/MzBEQTjOaZHB6w/oYfYhn47Rnrc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vqfL6IYG; arc=none smtp.client-ip=91.218.175.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vqfL6IYG"
X-Envelope-To: nvdimm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=ibyIE9gKf2iOY1+mVf6oD4UPNPJ9RqEZuDFV5F2gXBk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787219950; v=1; x=1787824750;
 b=vqfL6IYG5bmPmIHZ93WmL/Wq/O1RN2hPCoTZ0Zdnyb3zDniktYfWdkZSzBh82ifiQFP19I5v
 zH8xlDuZPucwGWdi/Qd/VZsLQ2F6NZXLZmRhtyOKSNBIIGssxHrH1yYNCUEH1gBrIoNWJuqGyYU
 j/ddxJNgNFD1Mo3If6Orz2xg=
X-Envelope-To: nvdimm@lists.linux.dev
Received: from [192.168.110.173] (223.70.159.239)
	by smtp.migadu.com with ESMTPS id e22ed27fc468e85d;
	Thu, 20 Aug 2026 09:59:10 +0000
X-Mizu-Trace-ID: e22ed27fc468e85d
X-Migadu-Flow: FLOW_OUT
Message-ID: <7b2733a4-71d2-43bb-b319-1ca8defba17e@linux.dev>
Date: Thu, 20 Aug 2026 17:58:58 +0800
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
Subject: Re: [RFC PATCH v3 3/3] blk-cgroup: move async bio punt state to blkcg
To: Yu Kuai <yukuai@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>
References: <20260818070641.756747-1-yukuai@kernel.org>
 <20260818070641.756747-4-yukuai@kernel.org>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <20260818070641.756747-4-yukuai@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/8/18 15:06, Yu Kuai 写道:
> blkcg_punt_bio_submit() currently queues punted bios on blkg->async_bios,
> so it has to call bio_blkg() to find or create a queue-local blkg.  Bios
> now carry and pin the blkcg css, so punted bio lifetime no longer needs to
> be anchored by a blkg.
> 
> Keeping the punt state in blkg can instantiate a blkg even when no blkcg
> policy is enabled, just to bounce submission from a shared kthread.  Move
> async_bio_lock, async_bios and async_bio_work to struct blkcg, and queue
> punted bios on bio_blkcg() for non-root cgroups.  Root or unassociated bios
> are submitted directly.
> 
> This preserves the priority-inversion avoidance while preventing
> blkcg_punt_bio_submit() from creating blkgs that are not needed by any
> policy.

Reviewed-by: Tao Cui <cuitao@kylinos.cn>
