Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F1B435203C
	for <nvdimm@lists.linux.dev>; Wed, 22 Jul 2026 13:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784727810; cv=none; b=VsCgBIHixKw2E0BIvuSXjEYYbl/pBAE45W94TStpKGlYKLEY833wVar9aRuSjDsHVk/h8B7a29jdP404JtchzlbIi85T52vfPi14+J/XNKOb1/A76Ds2QcQeV2iE/NAoeBx/Co/CR9xeTS9YCJxZJCIjtkEmuXUHdtaDJ/Vl64s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784727810; c=relaxed/simple;
	bh=PYGMpBdbfrddSWhi8wSkhjZKYMi0cam4nIYPZarnXJw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i/mt91xJ6RKKcn2jcHSbzD8D4uszSWI7/4jDFK5V/mvpSJKbIYXd/fimCJbgPq1yXRdxcaLy7gRPzurmldBjQS+PyyiMT9JBlqjma2DkOW+bsrcLaH5L86nq8O1eLZTLH/KMtvB1oSaPHKg0uszu2GC6dXakF+sSp57RRLQ/W7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=H/Lvk6t4; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="H/Lvk6t4"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-51bfbe05683so114951241cf.2
        for <nvdimm@lists.linux.dev>; Wed, 22 Jul 2026 06:43:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784727807; x=1785332607; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wqGzltcyJPxwfdEhPSjMSETzXly+gOy2t1lReGVE8tY=;
        b=H/Lvk6t4lw8KpunkV//mmpzqtWvnwsfcMiR9sdvpjOxGa3Z0A7F5VXT4QaN1bNobZl
         YYVMnX7bkD989RhWG2O2qlohZDDsycVNat6cJkCRUAdUfod/fTQx5uNUQuPa4gkD6v+D
         SzUuQbHwi+vKogycXLQLKaNQR+c+PdJiaReJMl9537XDZZsrlAM6y4l4A50CGnRuYY71
         IWIqI47OYPDdSmZhFxAbukXpAkaum1xIQc5Gvnd5U8tnD/2V3iyUdLaQA0EpG2G8n07F
         ftPrQ4GRC79/BXG9vFViT00iLqX26VJnIW1mrCxsTvlSz7oFHy6GQghCi+Ssp+lkRoBX
         AsEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784727807; x=1785332607;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wqGzltcyJPxwfdEhPSjMSETzXly+gOy2t1lReGVE8tY=;
        b=PAUA+2J6imG18XAeW0hyro3yyLEYuevVSyW8yL/2kOPytl8wGr/Ewd0pNaSa3B42rk
         qLuZp0uRC3Vt2JT6+kgsR/PjbMvVKcbLJXP1X7BwEil3PSIy0EMI/Qfu+KFtBwmiwU28
         5BAn/t+CQI6x+RdiyZV2ET5uq+pgd0aaJE1uUZyW6nS2H713TeBtvu3HmI1MQRSK4vQ+
         B2lM7nlHoTszGFTLtzVhv9TTSo2hILT+NPhgEBdaAHSMSvii2tWRffQGjadK4DY5Mlpb
         Ffnssb9hqdNDaFCFkf64V4SpOFMHi0yA36QlTRcjG9ViT7YOtXPwukKxAj2uOFYiCuzC
         rR/g==
X-Forwarded-Encrypted: i=1; AHgh+RqOhaUpSowuXMrIlHMWKulsbCCnRJJV7OBMeDCmJ5Sf/rtyhoPIZyPaUKT/WloVHv6ALacHyws=@lists.linux.dev
X-Gm-Message-State: AOJu0YxqrTsmq22IQkJZIvUUQnZqFaiZIGsS7uyTQfcsAZOrmpqYS3nZ
	+fwPTdFY2s809NzlPgCilA07kNPsUjG346mwpmVn0FTOwUUy4K5mWd87LX6vxLdHkpI=
X-Gm-Gg: AR+sD10Sp+OUm1O2o4fx87AjZaxVdRLdkRMDI4gCmS+2oH3EzOVWCtOp4BzNAP6NsEQ
	oEFH0vJ2OYaCezp2L9FeNwbkmyqkDSmPfamFMjVgjoHMJzNcP91bXnuWxV3mtsEjv2n5qmLqmos
	cTpfji/5qg0b6dZ4u1CU5SP6eDK/bX+l7qe1pDOPfgrO5wRH4ehFiabRkBYt1hkg7xyCmvdjBCM
	cJy+YMavSVkHtOENL7gz6xdL7/xWf2zZm/ciNJNClRdJ+vBv0iD6UlqHW3o+kZzY8afxWfFARzy
	s8Zvcx2Bzg/ikY5AtwHsfD/3SQK9U6PDJ9lJT2aAFfHFIghyxsJYFNPJY6lGqupNoEjw9YhtLXR
	YzdVJrAlHo1NR2ojTH5wvC4YhiMzOHQ5vLP1mbFNb7z2V8gHrkUHh4ZTAjG/mLOeI8D5fUrTNTV
	1/YIMVQJdby7bFVp+ocZtkyUDw8qKEibcDHvaqJN7MG/hjqs0l61/yFe9JnGDjtBeoG3Mw
X-Received: by 2002:a05:622a:1f91:b0:516:e152:7a59 with SMTP id d75a77b69052e-5213e08256bmr218014961cf.42.1784727806950;
        Wed, 22 Jul 2026 06:43:26 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-527d3b3f66dsm15332181cf.27.2026.07.22.06.43.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 06:43:26 -0700 (PDT)
Date: Wed, 22 Jul 2026 09:43:21 -0400
From: Gregory Price <gourry@gourry.net>
To: Richard Cheng <icheng@nvidia.com>
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
Subject: Re: [PATCH v5 32/36] mm/khugepaged: base private node collapse
 eligiblity on actor/cap bits
Message-ID: <amDIuZSsOPjRkywY@gourry-fedora-PF4VCD3F>
References: <20260720193431.3841992-1-gourry@gourry.net>
 <20260720193431.3841992-33-gourry@gourry.net>
 <amDEEnTv0QumcDJn@MWDK4CY14F>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amDEEnTv0QumcDJn@MWDK4CY14F>

On Wed, Jul 22, 2026 at 09:24:37PM +0800, Richard Cheng wrote:
> On Mon, Jul 20, 2026 at 03:34:26PM +0800, Gregory Price wrote:
> >  
> >  		page = vm_normal_page(vma, addr, pteval);
> > -		if (unlikely(!page) || unlikely(page_is_private_managed(page))) {
> > +		if (unlikely(!page) ||
> > +		    unlikely(!page_allows_collapse(page, cc->is_khugepaged))) {
> 
> I think collapse_scan_file() need something like folio_allows_collapse() check as well.
> 

I believe you are correct, sashiko up some stuff here too.

Thanks!
~Gregory
