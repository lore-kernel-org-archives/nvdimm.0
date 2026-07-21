Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5724E401A13
	for <nvdimm@lists.linux.dev>; Tue, 21 Jul 2026 17:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654307; cv=none; b=ZdCHiOhz8zYsk37K/+DAA4MlMYh+iF70gtH/fq2TfNFqLjVrH794AgUUVTPnHvmroJ7PbelMTqDVsmoAGEozCpaYKHUJegXXrZTSpFUQZY4hPzcpBR6wJfcGT7JT7i5rxrJTpXvBOVvXTSzVsAdO/+XULawVXxd5IzkLZ0cUJ48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654307; c=relaxed/simple;
	bh=SjqvhxrsnJlMovW4pU2RS91mvs9nZ/kSb5bsQ/v8cRk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ART2ZqK4fB2tzODk3/DHt83b+dY5Zp86SqgtEKAReGkBS12gDWJTnSOCeiFXwqy1g+23/6g0UB/Bs0OiE917k1P8LD+U9j/QV0quw6iyQJaprx7iYSZuhGgdnllnF2xzOXdMUa9hdscjSrBchMq/OTsbF8MKzoTPZg3X8XR+bcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=tOpF5oAz; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="tOpF5oAz"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-51c0006ea8eso89837701cf.1
        for <nvdimm@lists.linux.dev>; Tue, 21 Jul 2026 10:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784654304; x=1785259104; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SiPzgqRnSOFoo7wTJovboHrNHjQGCGe0NFhohlpad+8=;
        b=tOpF5oAzrDxkIpIS3frh1oqHfLuXYIYKjzzw/FubMvTemddzURP6zTyeeCT1IDsGNg
         Ge2F1ada9q4jf1MTSrwYJlXOW5zJ5BaLsFEDQfguhi2RG12TYcdzPlIfC1YboyEp5H9T
         DxPgpnnLznhSOLqPa9w4t5MiwYNrqacYNHfCRbyb8dstRLZymv0MtVWDtXjg0W42wQxH
         AmA0M2rZCFO+TIRrpLMCIy25akz5PSTyKrj8DgK/SjsMF8hhCXyPl/H3MPBBld6PhrH5
         xou/30lyabBImXEOk4dxdc7QilLM8SfE5gAeHqGisBJiMSPDEeMoP4HCJhiP2RpG/I3S
         n41g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784654304; x=1785259104;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SiPzgqRnSOFoo7wTJovboHrNHjQGCGe0NFhohlpad+8=;
        b=GuJoGp8/2TmL0uVHKp6o+ky4DJU5kj1CnYMcZ65PBowSeqywcNffymAPLK9JrZU6dc
         cQkADsEjN1kT3doursohdd3qLn8QQauKME4emDpTICGduFd2dKqVVZACegpYpHSnQ0pO
         /owzk/S/82/2/dn9eRlKCvVaQgAxlOvfeBdG/q7R6CSka6rPoOT1XOuDrgutLUSzWbO9
         806s9/Y+crCDGw7R3bVhwKIIGdNfcUygrgZZ07xcdCpmZ4BWivI91ZgCywyYqux6lm7Z
         GeBhtA7/DyEZfnw8BUvvdBhm/HZJPXVwMkYjT56OGoSdshJIBC16Z1j7cJQKlipA5yDD
         RSbw==
X-Forwarded-Encrypted: i=1; AHgh+RpI13Q1aPzDaSBuqYEls0HEE62Gzd7kSrJ6VGeGirE1iM+zv4UtQADTPLgO8dKnmAFp9fXcKoo=@lists.linux.dev
X-Gm-Message-State: AOJu0YxyIrGvu+1yL143XocVhifxQyhE3W+WmCsRy1UAedzcGwB33MbE
	QCII+HGz/VxIAeK4horGHnnZVCsfbBWr1876sLzSvenayx7PwcLs4oSFykf+avbKhuU=
X-Gm-Gg: AfdE7cnj3W2epUIybUyKaZ5sGs7kSjTOwFSKCaFZ8Qh70XBHeW0F15Vt+xBptXQLU0w
	9pBYcnELlRqfVDA/e8Zec2/N5FmiPeF+Vb3wvICou4ew+CrqHepTu8lh+OSkg9WPkzwDZP01AEY
	42lF04o4H+sQoeHmPQGQ7iKigDV+etjUZTQ+t9Du8P3eG/Jy3vrQAU2NsYIgdIVl/CCuT/3rZX3
	Mj+61tR/yev1+Qr0kLvLNhc4KeQ+AUX0OcK228ln0WdXQvjXLyU0gyAN9IOUXpwYajrHtC2nJjl
	KVSDkde7iEamG9ThooUm2faAcUuUU7ITZE3wBtDe1vhvaDz+c/VYkOdCsWnw6BJVx8IjOj8pFX7
	9ED9PxsoQCqZ8CHSsE168mV3Svu7fsug/cUxc4tNXlTocGJBQ+8PhaDTluXxhNkjtulvo13ciJy
	EECw8Zu7NWIrljoWwOpwZxl2fcPWAwSG8XLBNPOM8w5LhJFvhjOJo667Ap7A==
X-Received: by 2002:a05:622a:5789:b0:527:7521:3f8 with SMTP id d75a77b69052e-52775210a4dmr13363251cf.44.1784654304162;
        Tue, 21 Jul 2026 10:18:24 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5214f504892sm98076131cf.20.2026.07.21.10.18.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 10:18:23 -0700 (PDT)
Date: Tue, 21 Jul 2026 13:18:17 -0400
From: Gregory Price <gourry@gourry.net>
To: Zenghui Yu <yuzenghui@huawei.com>
Cc: linux-mm@kvack.org, Zhigang.Luo@amd.com, arun.george@samsung.com, 
	balbirs@nvidia.com, brendan.jackman@linux.dev, apopple@nvidia.com, alucerop@amd.com, 
	matthew.brost@intel.com, akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, corbet@lwn.net, skhan@linuxfoundation.org, 
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org, djbw@kernel.org, 
	vishal.l.verma@intel.com, dave.jiang@intel.com, alison.schofield@intel.com, 
	osandov@osandov.com, jannh@google.com, pfalcato@suse.de, jackmanb@google.com, 
	hannes@cmpxchg.org, ziy@nvidia.com, pbonzini@redhat.com, osalvador@suse.de, 
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
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
Subject: Re: [PATCH v5 00/36] Private Memory NUMA Nodes
Message-ID: <al-pkvmgIxGu3LzM@gourry-fedora-PF4VCD3F>
References: <20260720193431.3841992-1-gourry@gourry.net>
 <a9c52bb6-5e04-1d41-913a-685a7be3fad4@huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9c52bb6-5e04-1d41-913a-685a7be3fad4@huawei.com>

On Tue, Jul 21, 2026 at 09:26:09PM +0800, Zenghui Yu wrote:
> On 2026/7/21 3:33, Gregory Price wrote:
> >   KVM: guest_memfd: bind backing memory to a NUMA node at creation
> >   KVM: selftests: add a guest_memfd FLAG_BIND_NODE test
> 
> I can't find the last patch in my inbox or on the lore. Not sure what went
> wrong.
> 
> Thanks,
> Zenghui

Apologies, my email account got rate-limited to the number of recipients.

It should be in everyone's box shortly.

~Gregory
