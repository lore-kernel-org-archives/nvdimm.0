Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 660A5434E4B
	for <nvdimm@lists.linux.dev>; Tue,  7 Jul 2026 16:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783441615; cv=none; b=BodYeeMH/RMyAPMUhb3w/cMJyFOnWcyr7Hms7BVHAlsh74F7IhHkkzljowiEm6y489E4oo28kAJ538O8Z4Si/VUAodAlrulw9xLzvi+eN4JBP9Hm99hyR8N2NcuzVTm0j/eMlQFIZrTURu5yRB+yI6131tY5Sv6q5QK+XDBjvZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783441615; c=relaxed/simple;
	bh=YNUiKnsVmS0YnEoi5UBidfFcsIdy4Lv/4umM1P9hbyY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mtY/FXeGiQhRLjD2snjl+OtTRCoWns/QmeSmRiCBftdxAopOQ+dqlbpPvrUgg6cJFG6ZtwYFOEB2sCsxdvDIsWvUqN8JuXWFFzf6uARbHObyHxyGpfRSpdzYGU349W/V4JlimN2cr5f3duwbaxVKiXxF0NLEvPz3B+D01oH32og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=DgKeiTpC; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="DgKeiTpC"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-922ff615c14so330938885a.3
        for <nvdimm@lists.linux.dev>; Tue, 07 Jul 2026 09:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783441611; x=1784046411; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3pPJvCom7n6xLJkZnxYC/ipfbqNHo6N+N3CeZviAw0k=;
        b=DgKeiTpC1241Cfioz7Dg65LdNkcANIi1laldlaYY/ldXRPsuwvBKFWPK/fhqp0l2OF
         FD/fmwNNIjbhr224B5/yRDL2C47QHrIjuxQQmWziD1Ph3Ia6UOSlkSOlRWIr6Tm9g9jy
         JCw/1DMvDlZyxJ1RpkVKf5HKS/vMbjEiqSF5ps1AHNbxOaGnA2udpL5rhenWJY2+Et9G
         mz5XaPIXJNHdJu13ys+G+kKT3VDXYCEmPOd2/kny3rX77IOKD9rr/j3DHatgJxXnp9PR
         14ZiUY5bhjsSDIqIVspNuwLJnpaxmcG8utD1OOOW3xignrFtlupX4f8y+hXA6Z5L4Fhv
         DFoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783441611; x=1784046411;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3pPJvCom7n6xLJkZnxYC/ipfbqNHo6N+N3CeZviAw0k=;
        b=WaUl4aw6zLEs4FC4Dp8o299/yw2QJj4Q6/QAUI5vmyAXuZlSod+2TjyCxg6/FPe8GE
         vi9ERGrpJ9oiBYGswTbaQDyWFP0Fsm1jceUOoSqkD+oviMT7oqXKH6drd9zQBfBRC0JU
         ED/BDJ8dSDmYte1nXLkqjbjY/4zdCvMgfItfcxlvbw8QQ3UDHKKG15dBGVNTSth8VpOv
         jZApgy06jGUjP+LxEbjii3+UCXWTT/+f8/cTRI0XMiHR01j2pdYrhMbZpi516T2tHXr5
         D/17RAJjqcvrZOimHn+7L5S1n1m1ULDah4irV9b+y4a5bn8mUkcOqriiOl1vBmP+aHA7
         lIpg==
X-Forwarded-Encrypted: i=1; AHgh+RqamL0akEdvMRQ7RTwciKTPX87kfASdb2g+kcfBMd040XstIxKGfL2j79Y3KHLVhLdGaxgOQzU=@lists.linux.dev
X-Gm-Message-State: AOJu0YxYI1J3m4OI+x84DZPBZ44eNrPRhPlkYusGSaMW3D6J+fa5D+9l
	q0AHykwnULqYtNTt+khI5MPe7Qm5T53LpNNrUfCGqNNzhBD/mPKGgYd1oI/1mZSK5h0=
X-Gm-Gg: AfdE7cmdt/NY/Sh24s1NVTisISDOZkAXXWt/uJoXMPAlryWy7V1ocDug1mHHSZhJNDr
	oF61EaVFD75q22HwBnxxOGjvdNFoSbn1hfx1Thi54xZ3bwN/BPTpcg5uq1/9bbQr5BxSTxQuQtU
	qNEsvwcD1Abk9eXzjmNntA/YcISNdFrURWGyISGIYBK1iEemFaYtyH+JqgAYJ/xIdqSHd08gipC
	ypjcumEOh+AtKwFVdiWYZsbh8liy6tkT1342dQ6oCs9S8q4Bf0BcW8BTR3M0y8Qo27zVLxCEGkc
	1UaihrPftxh1WPQfitjH48TEgW3zlppqZP8i3lOUHTWF9Mw8oOkKherDI/mLfOP4lg38m/bFQ9s
	CY6CuPn5kze1kjtTPu6KRB73TpaAURzwggqD2no1jqSSudcoS8duQ75Tq0ypGzIwCIS3GwDqjdd
	HwZHX4You0ou9HU3EgmpB/mfdxmt0NORQkFSl2T2go1NYKOfk47oTYJKEsqk+pUeHR+bcvp5viE
	9xggaw=
X-Received: by 2002:a05:620a:a807:b0:92e:c118:18b9 with SMTP id af79cd13be357-92ec1181fa1mr324497185a.88.1783441610850;
        Tue, 07 Jul 2026 09:26:50 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e90ba41fesm1231337385a.17.2026.07.07.09.26.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 09:26:49 -0700 (PDT)
Date: Tue, 7 Jul 2026 12:26:43 -0400
From: Gregory Price <gourry@gourry.net>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Russell King <linux@armlinux.org.uk>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Simon Schuster <schuster.simon@siemens-energy.com>,
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
	Helge Deller <deller@gmx.de>, Jarkko Sakkinen <jarkko@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Dmitry Baryshkov <lumag@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>, Ankit Agrawal <ankita@nvidia.com>,
	Alex Williamson <alex@shazbot.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Dan Williams <djbw@kernel.org>, Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Matthew Wilcox <willy@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>, SeongJae Park <sj@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>, Hugh Dickins <hughd@google.com>,
	Mike Rapoport <rppt@kernel.org>, Kees Cook <kees@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
	linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
	freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org,
	kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-mm@kvack.org, iommu@lists.linux.dev,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
	damon@lists.linux.dev, Pedro Falcato <pfalcato@suse.de>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: Re: [PATCH 12/30] mm/vma: clean up anon_vma_compatible()
Message-ID: <ak0owyNkHX6mw4pe@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <5a7a07bd2a774989849b0fea84f758059ed914df.1782735110.git.ljs@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a7a07bd2a774989849b0fea84f758059ed914df.1782735110.git.ljs@kernel.org>

On Mon, Jun 29, 2026 at 01:23:23PM +0100, Lorenzo Stoakes wrote:
> Break up the existing very large conditional, add comments and use
> vma_[start/end]_pgoff() to make clearer what we're doing here.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Gregory Price <gourry@gourry.net>
