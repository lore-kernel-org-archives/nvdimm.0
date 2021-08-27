Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE0313FC1
	for <nvdimm@lists.linux.dev>; Fri, 27 Aug 2021 12:10:36 +0000 (UTC)
Received: by mail-qk1-f170.google.com with SMTP id 14so6885845qkc.4
        for <nvdimm@lists.linux.dev>; Fri, 27 Aug 2021 05:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tabyB924yXzKjpImGrZhEjdKF7M150xI6NXPXiRzacQ=;
        b=BXOWR0PoIMXAKeleGwpfna7bI0eKjcWwgsphSW8ThLvagIpDr0ls8T2rwQF4WaCYAP
         Nq8VthgBIjaMUmNkJJE5Hwe0p/+3AElNMwCti8WYko1Ip355vTLK41xamz4sDzkVarCy
         TuTYufAPQjwnsjTbjgE8ZUjjOE4nIIg6xWTi5I0b8whsNLyXTuNpMRqj7m25O1m/kjyi
         tGleiN1YawmdwDRDS6nIrbww73nh546jFUpBOYpQ8ryhiIH/GPQxhlfqdnkbPU9jgudD
         udg/fSkl8CvxxWVRbSd6JBto62jmSLZwL21/ci7CBLE9os8UXBW4oIz1k3angsHEHn8J
         OzjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tabyB924yXzKjpImGrZhEjdKF7M150xI6NXPXiRzacQ=;
        b=eQlUPb6kD200RgP6RE9lyr8MvzzIr+4Mnv/xBzeNDWbbkKEX5OBrbVKkbZKdhDAOL3
         1omOQ8gXk9qhkzqfrLXglpRI1dXPDGzmgrNYevaVehwLJ1InwAN87sGpAO4a/fXuEmYl
         ms26rb7NBPMMjzQStMXTbuA8La5Qj166VkUpCfW2UnA42G6+yoNkZzHgbzQfv048GKE4
         FMT1dAiZOXSeBqn2jk5y0F0MZnyMKCgo5DML6WAJZE2OlLMaP/P4/SoXLgRELjI3y7Wp
         mBEsTD/KFkOotD5GDBmUBVr1y79E7UJv17AXJAP8bifF+mAC/miNMzqJPfYwqOGKdDx8
         a8gA==
X-Gm-Message-State: AOAM531pkADNBiwnQ6Ow7O0lzNXuZ6KBi50KSMimJEuKux8A3+pRQnYx
	w/BR8K4yINWhH1qTeuXYxpt04Q==
X-Google-Smtp-Source: ABdhPJxcPlkQBE/+4Tx66G5euuWsIpG7RqUHiGHzvkWM9wne3DI0N4maWU6ebpmyWqNselqD09P/QQ==
X-Received: by 2002:a05:620a:7d5:: with SMTP id 21mr8703422qkb.339.1630066235609;
        Fri, 27 Aug 2021 05:10:35 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id b1sm3451778qtj.76.2021.08.27.05.10.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 05:10:35 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
	(envelope-from <jgg@ziepe.ca>)
	id 1mJags-005eR4-H7; Fri, 27 Aug 2021 09:10:34 -0300
Date: Fri, 27 Aug 2021 09:10:34 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "lizhijian@fujitsu.com" <lizhijian@fujitsu.com>
Cc: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	Yishai Hadas <yishaih@nvidia.com>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"yangx.jy@fujitsu.com" <yangx.jy@fujitsu.com>
Subject: Re: RDMA/rpma + fsdax(ext4) was broken since 36f30e486d
Message-ID: <20210827121034.GG1200268@ziepe.ca>
References: <8b2514bb-1d4b-48bb-a666-85e6804fbac0@cn.fujitsu.com>
 <68169bc5-075f-8260-eedc-80fdf4b0accd@cn.fujitsu.com>
 <20210806014559.GM543798@ziepe.ca>
 <b5e6c4cd-8842-59ef-c089-2802057f3202@cn.fujitsu.com>
 <10c4bead-c778-8794-f916-80bf7ba3a56b@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10c4bead-c778-8794-f916-80bf7ba3a56b@fujitsu.com>

On Fri, Aug 27, 2021 at 08:15:40AM +0000, lizhijian@fujitsu.com wrote:
> i looked over the change-log of hmm_vma_handle_pte(), and found that before
> 4055062 ("mm/hmm: add missing call to hmm_pte_need_fault in HMM_PFN_SPECIAL handling")
> 
> hmm_vma_handle_pte() will not check pte_special(pte) if pte_devmap(pte) is true.
> 
> when we reached
> "if (pte_special(pte) && !is_zero_pfn(pte_pfn(pte))) {"
> the pte have already presented and its pte's flag already fulfilled the request flags.
> 
> 
> My question is that
> Per https://01.org/blogs/dave/2020/linux-consumption-x86-page-table-bits,
> pte_devmap(pte) and pte_special(pte) could be both true in fsdax user case, right ?

How? what code creates that?

I see:

insert_pfn():
	/* Ok, finally just insert the thing.. */
	if (pfn_t_devmap(pfn))
		entry = pte_mkdevmap(pfn_t_pte(pfn, prot));
	else
		entry = pte_mkspecial(pfn_t_pte(pfn, prot));

So what code path ends up setting both bits?

Jason
