Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705BA36197A
	for <nvdimm@lists.linux.dev>; Thu, 23 Jul 2026 03:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784777126; cv=none; b=JH+MRIXOLzfjEhbzsLpz+p+iOE6B1IVpBQE0T4/x3eDkTj0bqABvP66dbrNHJoi3ESWELkoeIwvzVsDvhkR+/UdXvwquJRFy6GzLAKargCvdGAwP8igAv15mDFkb3bcXsyFbYSaYOoYG5B9aKtkU0TbPZg0Cdhj43X+OpkBIyxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784777126; c=relaxed/simple;
	bh=gfT0G2h32Mgahppc0W5ji5WK8maIODJ9zFl+mqtZVuU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ACT+FeuD4vshmC/muL81p7AxL1g+KKw0GeDIgZUHm2B0WpX+GiM1uoEjvkEKkdO0d7W9E6slwLrWhfmtzOMWE4eP89p8bXE5ohNMuU/xYILaRrprowCK5gzf1Erjqea0x8SAtrud357lKh0QBbcf1duTTKTg1Y5mJMgDnwpLVOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=urddzN90; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="urddzN90"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-51c0a81d286so1281001cf.1
        for <nvdimm@lists.linux.dev>; Wed, 22 Jul 2026 20:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784777122; x=1785381922; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Kd13UizLWaDa1rNXvY/PJ0N43yZ3Vd9IZn7XTlTXtfM=;
        b=urddzN905/IWI1PR54GJNttpdzyt/qVu75GRLHSLu3E6f9ahaWcKntCA/dZ9IFQAvI
         W5l9yLIBtRxshxRsFVUcxP8qiPkycPLerojMjIuypVeAyrxVzE4aR8ipGSbES7/bgcmZ
         NMBpfIbMv/cVvjUGJ+IbVeSIgFDFsNYzDiNkYa0mu6Gr3iah9pkQ3jw8Zc7RKqFdjNl1
         tpikJ5+I07OXxrJBStivc0w4vldXUCYXA6QrDpV84E7yrOmdVbtD5kVPr/86poczAXyX
         gyK8lzMSPUPrBgLvHyXNcu98y38exQqDtt/fGRUWTgiBt5l8nnEa5RoCOpr8OL6cSquL
         Drgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784777122; x=1785381922;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Kd13UizLWaDa1rNXvY/PJ0N43yZ3Vd9IZn7XTlTXtfM=;
        b=otS+pCQRun+3pvnELFw8zqD+q7zqvKZZUCzrtksSF7zlwq5lIG3ZWFL7K27Z86KrHE
         qoJkInt6vBno0dfNvesJ831aCaOwPppr9hsF3w8pFpISFrDlX/e8TQ58b19G9H/iPOmQ
         OnCC7/oPIOB3cPE/Lh83un89CfvRWL0oediGjVzFAaCjX0PGM9MrRr1iKHdggU140rgM
         N8tlsIsst738NmfJd8ZigWEpv034+x05SSFCkXCXknqhqdmOfFUP+2Ydvrbrb1F0w641
         Ko2u8GLx1f0oZppEy2+3YXAjMmfm7lYANp8Un74xD3QMZRfE4B412l6f+bk4FnKMD3J/
         KdgA==
X-Forwarded-Encrypted: i=1; AHgh+Rr5Wyai+o78aE5R7u/cxc4be+AXa5hWtzhUc5Y/SytrLYEnVyVfply5Ifdzk5M+R5/EpL/n5Ok=@lists.linux.dev
X-Gm-Message-State: AOJu0YwTgaJ3Z7SrmVFunPZG2jyBxwIZWOQQwACFctWvsr2d9Xo2Nu5H
	PkkNj9TSggQtgujXKIMbi1p32u3toWDCQzVWE9cNZQME7VQr5GZ/xFY+q5BHqGrYanE=
X-Gm-Gg: AR+sD12GwwRf6xqu9ilH7kkK/w/Ki3Q3Oa2FWZng4/razE7sdZ9n8hYG8238CF+NCCd
	CAkHEEBCB7B04JcIcYGtbbgp7Edu4mMSdVskbfxcMZ9pX76lj/JJwzxX3nx5FBS+gC/brOjGysF
	ut5LTL984g+pi7iPe4uUAeMCeZcI4sHsWUrKhDdsjKgg8aoT4SeRxqcFiNUyQgUEtU0EL2Y4QY7
	yBFmf8V10aPRD8Z49eNKoebb5ePWppTl2dr+l1xVycidTi88Z2uoGllIJglIfrComdnu5jF82xj
	bPLJuI9622KVAGdXejvL9yiM5y/dgMx569+Z8r3u1uuob9ffJQcEsCd16tXGE3CUIj84lURZRD6
	2GEAyBWruofOopKRl4SdISC0F/7iDcSn9J9HWqcMGGju8QsG5NGqwofvVIxfCOx2tEZHNU706r1
	IZNK6+5XvpL4M0uLTypRRbALdFehES4K5llyj1AZruhkK80nstBMiY3gJICeZVAD4q+n+M
X-Received: by 2002:a05:620a:808c:b0:92b:67e6:4b79 with SMTP id af79cd13be357-931048880c8mr90170685a.35.1784777122066;
        Wed, 22 Jul 2026 20:25:22 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-931062c4ea8sm34465885a.28.2026.07.22.20.25.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 20:25:21 -0700 (PDT)
Date: Wed, 22 Jul 2026 23:25:15 -0400
From: Gregory Price <gourry@gourry.net>
To: SJ Park <sj@kernel.org>
Cc: arun.george@samsung.com, balbirs@nvidia.com, brendan.jackman@linux.dev, 
	yuzenghui@huawei.com, apopple@nvidia.com, alucerop@amd.com, matthew.brost@intel.com, 
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
	mkoutny@suse.com, jgg@ziepe.ca, jhubbard@nvidia.com, peterx@redhat.com, 
	baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	lance.yang@linux.dev, usama.arif@linux.dev, xu.xin16@zte.com.cn, 
	chengming.zhou@linux.dev, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, driver-core@lists.linux.dev, 
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, linux-debuggers@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev, linux-kselftest@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v5 14/36] mm/damon: skip private node memory in DAMON
 migration and pageout
Message-ID: <amGHuputMNCFZ9CV@gourry-fedora-PF4VCD3F>
References: <amCzmkdOr6AFv_kQ@gourry-fedora-PF4VCD3F>
 <20260723001943.95854-1-sj@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723001943.95854-1-sj@kernel.org>

On Wed, Jul 22, 2026 at 05:19:42PM -0700, SJ Park wrote:
> On Wed, 22 Jul 2026 08:16:56 -0400 Gregory Price <gourry@gourry.net> wrote:
> 
> > > "by default".  Does that mean it could be reclaimable in some situations?  If
> > > so, could we check if it is reclaimable?
> > > 
> > 
> > See the damon changes in:
> > 
> > https://lore.kernel.org/linux-mm/al-pkvmgIxGu3LzM@gourry-fedora-PF4VCD3F/T/#mfb99303c85dd9d4c3f58832dc28fc55583a7217a
> 
> Summarizing what you want to say, quoting something from the patch, or at least
> calling it "26th patch of this series" would have made reviewing much easier.
> Cc-ing damon@ for only patches that toucing DAMON source files and the cover
> letter of the series could also be helpful.  Please consider doing some of
> these for future replies.
> 

I have been very much discouraged from this kind of trimming because it
removes the context of the series from the individual patches - making it
even more confusing.

But I understand, I will try to remember to do this for you.

> So, I understand later patches will make it optionally reclaimable and update
> this restriction by the 26th patch?  That sounds fair.  But, could we drop "by
> default" from the above comment for reducing the confusion?

Yes, but you bring up a good point - I think this two-step process is
actually poor form and that I need to redo it.

Maybe this can be redone as node states (features?) such as:

   N_MEMORY_RECLAIMABLE
   N_MEMORY_DEMOTABLE
   N_MEMORY_TIERABLE

so these damon changes will forego this confusing intermediate step of:

   if (folio_is_private_node(folio))

and go straight to

   if (node_is_reclaimable(folio_nid(folio)))

In the first patch - without ever having to revisit damon again.

> > 
> > Technically there is nothing in migration core to prevent migration
> > operations, it's done on a service basis - hotunplug, reclaim/demotion,
> > user numa (mbind, migrate/move_pages) etc.
> > 
> > Operations on private nodes/private node folioes are refused if the
> > capability bit is not set.
> 
> I haven't had a chance to read the entire series, sorry about that.  So, do you
> mean the above blocking is not really needed, or that will conditionally be
> allowed by another later patch?
> 

I will reduce this all to a single patch in v6, I see where things can
be improved now based on a few pieces of feedback.

Thanks SJ!
~Gregory
