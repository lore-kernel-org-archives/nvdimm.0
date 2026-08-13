Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40B54432FF
	for <nvdimm@lists.linux.dev>; Thu, 13 Aug 2026 08:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786611327; cv=pass; b=TNpQgnZvRk4+7ymYvn2RZmD+uRRcT4yKli1/LE9m6xCTa1XVswy8DvOH6H0hkUR/W0KcqdhfTstVB/EP2h+2iAlMbnuuth1pFEfZ3QDIOuSwkY63NXAu/xB1AYYe/X7mfSn0nnvJNrnGxj9MH1QYvYuaekUBikRXPFzYb3awhRU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786611327; c=relaxed/simple;
	bh=Jzc8k1yrWfBTMmPd/uTV9o0ew6ZOvHlbY2BVlHKCDmQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BgFGSQQepINFJld7384NJQ76jMHPBgu/97Az13bme7w5wTReIPc80ofwrv26Hxt1+zYuA3DJSszJpIClUZfkNmK5jlSBvaqrQNrHlK0p9kwZCxNRuH2pojd2aeGoDkJMMT5Ulc23aD9R3RhXogQbbcwAoX3M7vnD2rMv4uhesps=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F+5UcjpV; arc=pass smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F+5UcjpV"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-c9b373d5af0so424200a12.2
        for <nvdimm@lists.linux.dev>; Thu, 13 Aug 2026 01:55:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786611325; cv=none;
        d=google.com; s=arc-20260327;
        b=oCSnK4YwdPXtMV9ryZLuk1KP5o84Adg7s4X+SBVBPmV0l6qrROJTHuR57rXMijFVsn
         +y/aBuxXazh9k0OEiDRFKlH+5D6jbtitd+hmcZehsX9tLihKdfrELX1NcxVHgVYey57W
         EhG/ir7q0F4zfKhX0kMk3TvqdyislmoR9E7j2EaZfh3HQLSxjlEVLMZdIuyC6N/TPnCR
         BQW9GDnr8ZvWQoH6pWRgEoBdUDZwTST2Uv4T3eaVplthA4StYtr4GH+7xiAQSDmE+Ozi
         1ymVjeivCOEogXBHeO1Z02n985BGVmZ4IlAbsYHsXk4GYBMAgf2+pbjPeS6crYaIXxqU
         jxkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=iQkBGHUJCah+5IraL6W1VGnCKmw1qeB0IxjLs3arhcU=;
        fh=JSSsvZv32692Nla4lZQCmrvxpncgby2gtRU8W3z3DHE=;
        b=PNcJZPj/Bwp2TxD9fUgxvbm3+RYLsrg+mXs6YiGSG9HkQLFOu28UX+w3zWqtKO8cTB
         rzu7bX6S0oX8OW0IneLY6BoKCnQS76YiWSTR9ROrXYPG+O84OsnTQJw86PNxGVyAySHO
         bQfDRCdxYGfQLynQJ4HE5xUtZCmde6NZ5TJ8Da3uQUaP2kexnkJL5EvwEwqJvb6pT6EY
         2i6W4Y+0EiLcq6EJhEwgRFcoMdxP6lBNkMbeTsK6kWYWouAvyN+s07vQtRy68kA1hHzz
         elN7lEAR5EFL7ho0MvWt5fEMeE3JFmUA+Q1RydsjGpHxN8N8mDCF7CxfxXShwlLuVWoW
         z3Zw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786611325; x=1787216125; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iQkBGHUJCah+5IraL6W1VGnCKmw1qeB0IxjLs3arhcU=;
        b=F+5UcjpVBRplijmxQSvRBTO82+o5SwKCfhOA3TjPyujTw2xWiWZnZ8zLpKMJuA4NZ5
         EkmffUQYA+Wc8in6nba6ZRH4CTpBkWJq/HUrDR/BNQKsLQQzqmlle4csYzfvjP9dax1K
         48l9z52J2KplaIJ+lYs7mu9YxAkQG44Ic7KAbSv4SaaPHX2hHGJlG47XSdk1tKg1nTzm
         AbDcJ6ZABdCm1bxsyQOK/w7c8ceO3xSHCe/SgmkjFEQuSveLV5mPT5I41bxbL9sSru6c
         enDqYvmfrLegpM5eTAhIuPBHP/ZwLQP2a4S0Nbb3HwAfsz56+Y2HSg0/dl/WO2lzOh/x
         9e3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786611325; x=1787216125;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=iQkBGHUJCah+5IraL6W1VGnCKmw1qeB0IxjLs3arhcU=;
        b=VE0CdbsIKljNgOUUad+OBU94E5HnNhpDxYgbmNOR+ueaJW4RkJOtorsNYP5Bz+pV2P
         X/A026xLu1qjAV4lVxHgC5xS5qQwkulMjietGUbpCO/crPPV/Wfu0A8ELlZ8ayco+3aK
         k4WAXsJCAq9Ku4Njq7jQbT8Lzegen4KUxRGAt1rUMRINa7RAKr4ZTkQKwB/EJ18Lb1NM
         RWYEusPUfcBrm5WCk7fV5N+hw08u2ByjbGD91/xHT/KSp6UMDBnzXEoJwT8+3wu4xTVW
         kuoXP3RKi0JYtp4woA60vuiAZs5DsRCcdJsp1I2Y/BFJ0v77kiyN+6RQfoGmtZIFKaL1
         hV5g==
X-Forwarded-Encrypted: i=1; AHgh+Ro11NAhwa3vjZMVcyXHTXVjA3z2O6pRS8ehJlylw8Y/6Z2egGAiFqJaNv976GXwlT1v05oUss4=@lists.linux.dev
X-Gm-Message-State: AOJu0YwR9ffvQ9jGDj5R/DGgSPmkb3B7EKHkURV0k4B7PpXRi6fUhOcP
	m+Z4NYhStemgwsX6YXjUDrXmu0ktcR9OgnIehOJANS0Rs+Jbq1Si8k8fUp3bqh3CbITrJU/BEK4
	SlsVb69rQgSO15vsJQASn0q8rzmb1nwE=
X-Gm-Gg: AR+sD10bA0kddz+a/O+oifbMNzAvsD6R41/J1WGsXA/QBsv+vsh2eixeXx1Df5v7L9g
	8YQQsTT1cBQJnm71HPwpV1+9qos01KTG+IZ86MNpT6KQ4DwNRZZaa95DYMcUvxA+i4Sdpb8y5xB
	kO1WRJnohntImpmqWY48yxAOu6xi+wuagkJdZrAJuvtqq90JI170rey+0xltzc4QmchgxhdPRv5
	hmViTtSzyAt33E5o3siiZsfYDTM2AXxqojrf+nWuv1u6gRauT4uGiyYZqKV4OhrVyN8e5KSr3RV
	CwMgFzzSEPIHe9NxtZczmYfhekSXKIlDvFKR+dkcntfUmFc=
X-Received: by 2002:a05:6a21:150b:b0:3bf:8604:9a3c with SMTP id
 adf61e73a8af0-3cc553f513emr5787899637.28.1786611324791; Thu, 13 Aug 2026
 01:55:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260720193431.3841992-1-gourry@gourry.net> <CAM9Jb+jpJ-Ui4qDHxsp2WiERiv8gmrQfKQ8Z0BmabefeQ6pg4A@mail.gmail.com>
 <an0cAMh_m8ZhGIm2@fedora>
In-Reply-To: <an0cAMh_m8ZhGIm2@fedora>
From: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date: Thu, 13 Aug 2026 10:55:13 +0200
X-Gm-Features: AUfX_mx5aRT_GeBsew982Oll4m1v2zeTSERp4DtDb2YI-VK1slYjLWUFWPkF2ZE
Message-ID: <CAM9Jb+jmxPdL-CdWQHYMT5G=qmjB6z2WFg+4K8Fod5n=2N6YCQ@mail.gmail.com>
Subject: Re: [PATCH v5 00/36] Private Memory NUMA Nodes
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, Zhigang.Luo@amd.com, arun.george@samsung.com, 
	balbirs@nvidia.com, brendan.jackman@linux.dev, yuzenghui@huawei.com, 
	apopple@nvidia.com, alucerop@amd.com, matthew.brost@intel.com, 
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, corbet@lwn.net, skhan@linuxfoundation.org, 
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org, 
	djbw@kernel.org, "Gupta, Pankaj" <pankaj.gupta@amd.com>, vishal.l.verma@intel.com, 
	dave.jiang@intel.com, alison.schofield@intel.com, osandov@osandov.com, 
	jannh@google.com, pfalcato@suse.de, jackmanb@google.com, hannes@cmpxchg.org, 
	ziy@nvidia.com, pbonzini@redhat.com, osalvador@suse.de, 
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, 
	ying.huang@linux.alibaba.com, kasong@tencent.com, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, yury.norov@gmail.com, 
	linux@rasmusvillemoes.dk, longman@redhat.com, ridong.chen@linux.dev, 
	tj@kernel.org, mkoutny@suse.com, sj@kernel.org, jgg@ziepe.ca, 
	jhubbard@nvidia.com, peterx@redhat.com, baolin.wang@linux.alibaba.com, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	lance.yang@linux.dev, usama.arif@linux.dev, xu.xin16@zte.com.cn, 
	chengming.zhou@linux.dev, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	driver-core@lists.linux.dev, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-debuggers@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev, linux-kselftest@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"

> > > Bonus Configuration: HBM device memory tiering
> > > ==============================================
> > > echo 1 > dax0.0/private       # make the node private
> > > echo 0 > dax0.0/adistance     # highest tier
> > > echo 1 > dax0.0/reclaim       # reclaim active
> > > echo 1 > dax0.0/demotion      # may demote from the node
> > > echo 1 > dax0.0/user_numa     # mbind()
> > > echo online_movable > dax0.0/state
> > > echo 1 > numa/demotion_enabled
> >
> > I am bit confused by the HBM device example being discovered as a DAX
> > device. Is it to
> > only to showcase the use-case? Or we see HBM device is actually
> > expected to be discovered as
> > DAX device with N_MEMORY_PRIVATE?
> >
>
> "actually expected to be" -> no.  there's no requirement HBM be
> discovered and boudn to DAX, DAX is simply a convenient intermediary
> to memory-hotplug.  This is at best a demonstration.
>
> A device driver could very well just call memory-hotplug directly,
> or its memory could be brought up as a private node via a boot
> paremeter (which I have sculpted for v7).  The former is preferred,
> but there's a bit of a chicken/egg scenario for bootstrapping.

I find this interesting as this appears to be evolving towards a vendor
agnostic framework for hotplugging memory directly to private nodes.

How you see this working? In particular, How would the kernel know which
memory ranges correspond to HBM or other device memory?

Please also CC me when you post v7: pankaj.gupta@amd.com

Thanks,
Pankaj
>
> Most of these UAPI extensions are going to be consolidated into a
> debugfs interface for testing purposes only in v7.  I've been working
> on aggressive Linux Test Project test expansion to ensure there is no
> UAPI regressions.
>
> ~Gregory
