Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB681A9FA0
	for <nvdimm@lists.linux.dev>; Mon, 17 Aug 2026 00:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786927771; cv=none; b=dlNdpGs7DGaG/qz0cEqsr4sKrTsl4Q02+IQax3yl8/I87TcVHIVOnWj6kmuaFD2RA3101ZSSgP4BZvpZOpWuEkAVlLRBMapvIKvYmA04t/EvKGcDQ0KT17SRx/1H+PT3dZpsiJezxXkM3t41vWZiPXyu4Sm0YnLSZkYVf0Jvr8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786927771; c=relaxed/simple;
	bh=Q2AJHfOQlhxmo4d6xkSdfftND9W8OwOWU4sIuscydGg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FzylUBLN2TVoXFt6colx0ZfRro7zm7y8vVACSqtXSiprl6JSkrvHwLkEImPKxcxyfp9QZEp5ySRL5l/KvgF1COWYkvUo+IxKyclfAkzsz5jsQhYn6EPyKR5R8cfFK6YcLab81TJod/tXxZngJKge0LOS3eNM79PBeano5Udjb64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=K+25e0Rp; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="K+25e0Rp"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-51c2a76536bso28094621cf.1
        for <nvdimm@lists.linux.dev>; Sun, 16 Aug 2026 17:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1786927768; x=1787532568; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FcQdr0dRPL3xWk5ZJ+WEqnlvhAK6C+Y9UAGkoGf2Ky8=;
        b=K+25e0RpJENzYFwingcae5ISwe+TKSd0MxJ2OfxVFBtlR5h73BlKGHLobbqYf5fAKw
         oHWg4RcsTl6bJhE33ZrmLJjvJ4dKK/0CXNX1gDfQ4EL5/5aoRD13S85GxNq1JFgQw5s8
         3OuaOTcAcd64C7DosZuFX4Iajj+egSDifIwHvz3KstGPbMWWwj71p/3Uk/H9INY0tB06
         FJMVrAX4JAJ3qpstkLm/lKreHDlF1PGAK4oTol7Q4qcnTtma5b2xcqiRFoV+JOFR2xyG
         cMdn6O/nzGxACjL9olXGKpgIcJGRL9qLnFyMLLRLus3G485jTJ601/HC/mWk3YmLRkRW
         XbkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786927768; x=1787532568;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FcQdr0dRPL3xWk5ZJ+WEqnlvhAK6C+Y9UAGkoGf2Ky8=;
        b=JFx2hisDIifBmmK1Ok4EU/T3ULq0LNQdfH+t09D1OdPW4AhbQPicaXyyBPr2rfv6lj
         jZFosagyJ6xtpL6SMIdNAVtDEf7VDBzBSlXyx4RiT3a9sGHq5Xfd3n0qbM+Q4+iXmCCN
         +nS+cxUpI26wDHawi4Mhzzhh/lbNRGRG+bmJYwrtaVP8KZliVUG3x8fneMdlyXnMfENG
         A7jxbuwqKM3FCfhyJL6m4Ocy/CDnedQGg1Jz4uixIX7zYiQUxvOG08dfhKxvye5cQ0u4
         hSIg3b6gYcNkT17NDTUhKQIpDb+XMdiuQ/c+OrJVCc1kNtnhgHdeMuKR8gtvvR1l6rus
         9leA==
X-Forwarded-Encrypted: i=1; AHgh+Rrq4BbDATyqnPwbbDw2AWwEHv+hNS8o67E0q22+ZnizBjCMsEUwI07hv0aw7ZbrUGbSb4cMZfI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxi6r0VYW07QuhWL+6cgy2oR6uEhIAbsJkhsCkC1xcgCisJJAS7
	clUSVJdwZS4RJpNehkqa5tY4i308MOA8/FVHfF1hLgwSgSr49HpFNTwT6dwPy37bcv8=
X-Gm-Gg: AR+sD12+kK1XAfUwDZqR5o+Uj5MgBzjulmbwv1CmR2abBo067zTmcmzYfocahnf2hHA
	aAjh8qU0ZvJZcY9alvyw2Y54pXAUxm9LL42BPULxD4H+s+whWTqFtuOyUhnejULR7IY+7nboi4q
	WpKjVnBO+8JlzjvM6kcdd1kf6SaG1TBR9Z/nVrsxXu7KFEH7N+MYKWc1jdf9HsjcuT9UeonhF85
	AagczqkzjuVIn90x6YV28ABvndzVfURAeZsVNVW12BNU44bEqQDzCa419PjntBJIvoGYG814VHM
	037ZbHSNRs2Jd+GkTreCD3Nj3bvJ/tiReK959F5cCHLhIBDY1KfMWsuR1Eplaiagc0fYAI5/nEt
	Q2g7eZhu8t11pWxoErjRzGFA20OTRCHyB3jD4hVOlYFJe/l/6s0vO28vBNAQN3bIM4B9g5r0J6d
	U8jOVbS7PmwHdPdDa9Hq0HFOTv675Zhk9ONGulukT95mT6dYMTELUrw98mLzwc9Wh7kjcEGGeNG
	nNKDaVRn5nn4GmwA1zMm1PoxyXG7Bwvd7VjFJh/3od9
X-Received: by 2002:a05:622a:2b4b:b0:52d:a151:10f5 with SMTP id d75a77b69052e-52da15111admr97787241cf.22.1786927767788;
        Sun, 16 Aug 2026 17:49:27 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52db62764f2sm1152051cf.30.2026.08.16.17.49.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2026 17:49:27 -0700 (PDT)
Date: Sun, 16 Aug 2026 20:49:24 -0400
From: Gregory Price <gourry@gourry.net>
To: Qiqi Li <liqiqi23@huawei.com>
Cc: linux-mm@kvack.org, Zhigang.Luo@amd.com, arun.george@samsung.com, 
	balbirs@nvidia.com, brendan.jackman@linux.dev, yuzenghui@huawei.com, 
	apopple@nvidia.com, alucerop@amd.com, matthew.brost@intel.com, 
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	corbet@lwn.net, skhan@linuxfoundation.org, gregkh@linuxfoundation.org, 
	rafael@kernel.org, dakr@kernel.org, djbw@kernel.org, vishal.l.verma@intel.com, 
	dave.jiang@intel.com, alison.schofield@intel.com, osandov@osandov.com, 
	jannh@google.com, pfalcato@suse.de, jackmanb@google.com, hannes@cmpxchg.org, 
	ziy@nvidia.com, pbonzini@redhat.com, osalvador@suse.de, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev, baohua@kernel.org, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, yury.norov@gmail.com, 
	linux@rasmusvillemoes.dk, longman@redhat.com, ridong.chen@linux.dev, tj@kernel.org, 
	mkoutny@suse.com, sj@kernel.org, jgg@ziepe.ca, jhubbard@nvidia.com, 
	peterx@redhat.com, baolin.wang@linux.alibaba.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev, usama.arif@linux.dev, 
	xu.xin16@zte.com.cn, chengming.zhou@linux.dev, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	driver-core@lists.linux.dev, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	linux-debuggers@vger.kernel.org, linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev, linux-kselftest@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v5 25/36] mm/memory_hotplug: support N_MEMORY_PRIVATE
 node hotplug
Message-ID: <aoJaaYp30LnKLj1w@gourry-fedora-PF4VCD3F>
References: <20260720193431.3841992-1-gourry@gourry.net>
 <20260720193431.3841992-26-gourry@gourry.net>
 <6840c720-8cb7-46bb-a652-040c130a4427@huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6840c720-8cb7-46bb-a652-040c130a4427@huawei.com>

On Thu, Aug 06, 2026 at 11:30:08AM +0800, Qiqi Li wrote:
> Hi Gregory,
> 
> On 7/21/2026 3:34 AM, Gregory Price wrote:
> 
> > Add add_private_memory_driver_managed() to let modules hotplug
> > memory onto an N_MEMORY_PRIVATE node they control.
> 
> I am trying to understand how the nid passed to
> add_private_memory_driver_managed() is expected to be provisioned.
> 
> From what I can see, both node_private_register() and
> __add_memory_resource() require the nid to already be present in
> node_possible_map. My understanding is therefore that this patch
> supports hotplugging private memory onto an existing possible node,
> rather than creating a new possible node ID at runtime.
> 
> For example, in the use case I am looking at, the device's private
> node is not described by firmware. Would its nid need to be reserved
> during early NUMA initialization, or is there another mechanism that
> I may have missed?
> 

It would need to be reserved, and you could use numa emulation but
that's clunky.  I have an RFC for exactly this issue - though i haven't
pushed it further yet.

https://lore.kernel.org/all/20260610014517.253609-1-gourry@gourry.net/

> Also, could you please Cc me on future revisions of this series?
> I would appreciate it and would be happy to follow the work:)
> 
> Thanks,
> Qiqi
