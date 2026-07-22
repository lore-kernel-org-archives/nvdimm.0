Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB48320CBE
	for <nvdimm@lists.linux.dev>; Wed, 22 Jul 2026 14:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784729100; cv=none; b=X9ZqH4JXWDArU8Pq0EBin2LEcTm3qRpWG5MkUsmupXMGZuzoZYwI2/Jg86C49h/hpOjFpTiM7bxbSCrfPV489fLpaY6B9fZ8JZopLhygv9CQRocYMQNlkVtjikoN9f7ebxaEIBW1HYroO23RXS0oq8V6Xgbjjj5SX8C3SIhNAXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784729100; c=relaxed/simple;
	bh=BiKsszl+35xq/ewMPZzGz30tgw5kvnsmDpEO+3lG0vE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rCori883h7Wo0tgNYqUHXArHw2vHrVMp0V58FYyNIdbVK/EYACEIFpofdg3JMFr6f9UYb56jScOAMK3rL0Kl+wzyaXLYsO5fY4qZ3mwA8T/ll+rFyGm0KAQ6ZFEdbUjDw/MKY7HUFyswpzgEShEzKtYjfJdOjHuB5+8D8m1jzHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=nqQpTSij; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="nqQpTSij"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-92e5d6f35c1so1112499985a.0
        for <nvdimm@lists.linux.dev>; Wed, 22 Jul 2026 07:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784729097; x=1785333897; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wzTopji7Zl+MAyFivVnXiZLO5KABEpd5UV02S/KHUTw=;
        b=nqQpTSijoBpCJxkc2dL1vz2F7XXyOIvVhXnUkAPC8cq4hQAUl8GnbG74SZitsy+txy
         i9sz4jT6W9hRkpMxczVupue8sgzD0aadU+7gPR7JMb3Sz6Yx4JSSo3RcEhpJTtoRypQc
         g+AoANGp/sqE8mLY+u1aXNC1/ngEOGsZ+ZixYffox/8LWzOkDQ0G91SJK9bxdT0hznrf
         yDeBViyPuf4xfLULxvLMHGi/4SEBovsO3XZSAf2MUhx9P28I4UUs3MCbapX+UUA5mFVV
         bya+iFKfGrRm57COm5TqRA+tFsAc84Sd+2U/IA6zkdwdfyVW8c/WqpYgyF/olGxUtwOg
         p/WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784729097; x=1785333897;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wzTopji7Zl+MAyFivVnXiZLO5KABEpd5UV02S/KHUTw=;
        b=L8+zo1l1pCTtT9x/QOwk9SMZnLLZyu5YCk45eCnc1L4ori9+xRgsSNqvusi9QqMavr
         SAuDds5PyQjvQEBI1CHMHSXGx7GgphK6jPM2K+0EEB9TvN6xtetTBYzNq5OYcW2AGI0E
         OneDsEidlvkNoYqB6aA23vAvdUQJj/LKRbAAFPE6szu0/xXsj9askHX/SqFZNPwBsEhm
         BTQCgk6Rq79keZcpgeXSbuF7GHfdxwR6W+VjUtSgbjQk22i8eMWrwn/ESpINJ3Wxue4x
         DtEkz3gVRkr51U2ACntY8FMtHQ24zjbutYC/5eltbOpFE4a4ckGZneD+Ibn8q9oK1pWa
         CVPQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro9+2vIN55gTYaEZNuK8IhmDd91WmYVJzCzdxag2JQXC8Hw7CuTBdGxvC2Hk3tZVVo5w7ShI7Q=@lists.linux.dev
X-Gm-Message-State: AOJu0YwNJsSpe26yvDuZa+7hQUNID0GXVsw7uH4TBC5AhFLp5q13N7m/
	GNjN8Jsd1zC0PWUqsgWbtkP1sbCOibHra27xleZ9qq3Pn0MlMDGprCq9xpYg4kHcSV8=
X-Gm-Gg: AR+sD12JoDFcLO7Pf84ihAVK/g7fBEHsLusJaFl4czv9A4ORCAqIcTVQdLYN1k911Oe
	kjt7hVEM3LbOGa9ONcay5sw9uzIXMxO6LHfc5FklMwDWjvjFhe3N/80FOkhgL3HfSP0JUDxRw3q
	w68ZuNtL25HjdSwhGganMxrI1MHnllKHgts0UEZbZXFfw/tXkm8xy9I6M/Zx6ZekV9hI95+8S64
	LRTXt8LlJFmCl0vIfSkQveaGo0ujjesb+YoLZE4tJoMhHvze31f9hWDTmHlBYzbypiouu5KUVkI
	I6AvRYfYWSuZtUQsmc2ULOBL72BG81w+38Wb0P2eQujvP0RBR8sEFU48FQbw7bsAn5RHdsPtJwM
	SrWSNT5aCwY/IC+qn69UcDdBFMy7oS4Lmu5j0aYApWoxDGzbhgqKyfGypxu7oSd3jmfD0s/Mqcb
	8sh3Mxe/mmKLtcPtlv+Sz4QD5x6dgaLLWOCIV+8A1td/MGijzqxS54eHGaNg==
X-Received: by 2002:a05:620a:1992:b0:930:f7ee:2cf5 with SMTP id af79cd13be357-930f7ee3792mr215753585a.66.1784729095553;
        Wed, 22 Jul 2026 07:04:55 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930f68d5d6dsm171863585a.20.2026.07.22.07.04.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 07:04:55 -0700 (PDT)
Date: Wed, 22 Jul 2026 10:04:49 -0400
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: Zhigang.Luo@amd.com, arun.george@samsung.com, balbirs@nvidia.com, 
	brendan.jackman@linux.dev, yuzenghui@huawei.com, apopple@nvidia.com, alucerop@amd.com, 
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
Subject: Re: [PATCH v5 28/36] mm: add NODE_PRIVATE_CAP_HOTUNPLUG for opted-in
 private nodes
Message-ID: <amDNMmbdE_ZhUgl1@gourry-fedora-PF4VCD3F>
References: <20260720193431.3841992-1-gourry@gourry.net>
 <20260720193431.3841992-29-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720193431.3841992-29-gourry@gourry.net>

On Mon, Jul 20, 2026 at 03:34:22PM -0400, Gregory Price wrote:
> Add CAP_HOTUNPLUG, which allows memory_hotplug to migrate a private
> node's folios for the purpose of hotunplugging memory.
> 
> Without this, hotunplug fails if any folio on the node is allocated.
> 
> Add node_allows_hotunplug() - which returns true for any normal node
> and private nodes with CAP_HOTUNPLUG.
> 
> Signed-off-by: Gregory Price <gourry@gourry.net>

after this question:
https://lore.kernel.org/linux-mm/al-pkvmgIxGu3LzM@gourry-fedora-PF4VCD3F/T/#m5b8166212a276fece2380f2dd03d6864375a576b

and some off-list feedback about limiting initial cap bits to active
use cases, I realized that this CAP bit can be entirely eliminated.

hotplug notifier callbacks already allow a driver to prevent memory
block state transitions - so that control already exists.

v6 will remove both the filtering here and the cap bit.

~Gregory
