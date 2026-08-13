Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB3D12E1DC
	for <nvdimm@lists.linux.dev>; Thu, 13 Aug 2026 01:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786584074; cv=none; b=ltg26Y48JrdqUVTM3/CkwOmM6U2YicQsjjw2RoaxVOv2oqermi/rWUKonWyOUZ3bu5yAq9cXw6GMrp0s1r39dBsXE2rJLQAgStwhudo7e5OQTvqyaVo2vJ26JtQAXJVHvXQCmI6K66QKJvKuwIhlsDYBg49vmEzxAWbJi4GZEZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786584074; c=relaxed/simple;
	bh=jQAWRVENXd5JGHsxo/hf6vUttuV6ujE/QtYCehIVHRI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AibxK2RFVK0mXyna3T6qLd+U7doSJ99/8NVPAlIe0VOPk+y62kcW+IH1vEaWa5b24WVsBdL/AnCHvweXCs1i0SSpptRcQ9tcu8z/NDaolBBW4mMjNT3bcMV61k1h8BD97IrCTZ4WqSHM+2qcgHm4NexMKPaQ4O1Ajf6BwIXXqpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=UhdYbJXs; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="UhdYbJXs"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-9030f8ea3b3so1893286d6.1
        for <nvdimm@lists.linux.dev>; Wed, 12 Aug 2026 18:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1786584071; x=1787188871; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZGIPGO62vUWJJtnlWOV7HnIzQD6+wbjwlpycp53S1ew=;
        b=UhdYbJXs0QWMtav9IKzsNtYjnjbYfJ3m2nvXjiagbk7FMpPXpPQdLmPFLRBFuB/b1h
         9ejERz5LE1jkHiC4fTsivCIYKoOh/LTmTbIu84cgrrXrMirRDRnqo9SRmycv4qw9gxjx
         zfIh1uBwy0Tnn5czqnIUZfnj0Z5SytnfYC/0eheziy5pO+ZedaQyjVBqg+4yiy1FP2Yh
         No2d0LtS3FNhH/gPksuKlKcoj/1ivANatU9aYz84ZqqocAWtb0R8+VSm0Fa2DDu0MdRu
         jKduyAYyd7IDVKmr+iQNQr+PXehSKMPFq4O70+2UfcDJ9V+12g7SgGw6n6K6m3QT4XLb
         jqbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786584071; x=1787188871;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZGIPGO62vUWJJtnlWOV7HnIzQD6+wbjwlpycp53S1ew=;
        b=eAUrT27rhJp/GpXDhiABkYNy9CdGHd78qjle17R930x7asx2p9kooU7EQ8E+elzzYf
         C71VMS9rJZLfBBiWVAYV1UcmpNkwXEcPutYJEvFIHZeppELJXqPFQXQTR6fkGXl1OTP7
         w9Fv94LYn+fGRzN+W8sKoPeGGFWIwIS8fafOgvpzQ+xSMJtHhdN9hm+DYCsKwtNDnw8A
         TOxYt7/DvpwlF72f5A8c3qEpm0XkrwFKgbyAD07Maqdn2LAwXKQBkfLgyxBjsV8J6ExE
         sIAtP6hR4tBMqkbypi0Y6r9nfCBYbRfeoUQnpGBtRfr1nNzkPHfkyioN0Jgyzy68YFgG
         vADg==
X-Forwarded-Encrypted: i=1; AHgh+RrLjUNivufBv1pH45jDLmxKF7LjT4oG+qCuU6EIRNas5Z2csxsMF3je9amitdGjuSbZ5zF3bps=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz/axdDPp5Nm8P8gNdxI4GF0NYYJYL+U2R52US5BH+CZTIRb1YZ
	ijSUS+snE+x90f+SS49cyAbBX2Y4jSAK9WjaPBYG/Rvb0Dj/1ddPxNRdWprVuWx5I6Y=
X-Gm-Gg: AR+sD13KtpuD/tdS+S8SgGyD7v+ef/etkNz6jSEh/86bJL5vPp184LoXtUWIai/LfgZ
	Ez15lM/SX29o96vMm9tD7gkGlCuQB8lfkQtRBV6DkNCD8QlzACPxzoY1jikk7wPJ0FuX4q/nvtj
	jdYzBkb1/xuPs04VDhJjktanUb3wqkEHf1OLMna4ilEdkE29pksOz9jfFrPGaT/AHGhRNQX+YZG
	ykaRuk4dFbeaTKzC3Kh/UBDngVbkfi01FR3RQfhK6kqu1+/uImo34x2QnNNJmWnEdI0E9PU0zVG
	p/v4IqVD2lUTo/cwPQuq1rNxsv1MjRySCqJRBdxrKgpNalwtQMo8HViq+y8z4RifpTlusnPquEQ
	DuQLWo4ZbBV1ZyX51jf2SeqvS3daSI6t3JueHoP3A2BSyShed66TX3i6sAEE/M/5ZHCGCCBbgWn
	bsoVwX4+hPMxel1FLEj95NWqPavDZAinw3JlkAu6RPHIxYj3U=
X-Received: by 2002:a05:6214:500b:b0:8f0:d710:26ba with SMTP id 6a1803df08f44-90a80bb0b74mr17793966d6.31.1786584071577;
        Wed, 12 Aug 2026 18:21:11 -0700 (PDT)
Received: from fedora ([2601:19e:8500:d3c0::28fe])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90a8179e350sm4119856d6.6.2026.08.12.18.21.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 18:21:10 -0700 (PDT)
Date: Wed, 12 Aug 2026 21:21:04 -0400
From: Gregory Price <gourry@gourry.net>
To: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: linux-mm@kvack.org, Zhigang.Luo@amd.com, arun.george@samsung.com,
	balbirs@nvidia.com, brendan.jackman@linux.dev, yuzenghui@huawei.com,
	apopple@nvidia.com, alucerop@amd.com, matthew.brost@intel.com,
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, corbet@lwn.net,
	skhan@linuxfoundation.org, gregkh@linuxfoundation.org,
	rafael@kernel.org, dakr@kernel.org, djbw@kernel.org,
	vishal.l.verma@intel.com, dave.jiang@intel.com,
	alison.schofield@intel.com, osandov@osandov.com, jannh@google.com,
	pfalcato@suse.de, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com, pbonzini@redhat.com, osalvador@suse.de,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	ying.huang@linux.alibaba.com, kasong@tencent.com,
	qi.zheng@linux.dev, shakeel.butt@linux.dev, baohua@kernel.org,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	yury.norov@gmail.com, linux@rasmusvillemoes.dk, longman@redhat.com,
	ridong.chen@linux.dev, tj@kernel.org, mkoutny@suse.com,
	sj@kernel.org, jgg@ziepe.ca, jhubbard@nvidia.com, peterx@redhat.com,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev,
	usama.arif@linux.dev, xu.xin16@zte.com.cn, chengming.zhou@linux.dev,
	roman.gushchin@linux.dev, muchun.song@linux.dev,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org, linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org,
	cgroups@vger.kernel.org, damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org, kernel-team@meta.com,
	"Gupta, Pankaj" <pankaj.gupta@amd.com>
Subject: Re: [PATCH v5 00/36] Private Memory NUMA Nodes
Message-ID: <an0cAMh_m8ZhGIm2@fedora>
References: <20260720193431.3841992-1-gourry@gourry.net>
 <CAM9Jb+jpJ-Ui4qDHxsp2WiERiv8gmrQfKQ8Z0BmabefeQ6pg4A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM9Jb+jpJ-Ui4qDHxsp2WiERiv8gmrQfKQ8Z0BmabefeQ6pg4A@mail.gmail.com>

On Wed, Aug 12, 2026 at 02:01:12PM +0200, Pankaj Gupta wrote:
> >
> > Bonus Configuration: HBM device memory tiering
> > ==============================================
> > echo 1 > dax0.0/private       # make the node private
> > echo 0 > dax0.0/adistance     # highest tier
> > echo 1 > dax0.0/reclaim       # reclaim active
> > echo 1 > dax0.0/demotion      # may demote from the node
> > echo 1 > dax0.0/user_numa     # mbind()
> > echo online_movable > dax0.0/state
> > echo 1 > numa/demotion_enabled
> 
> I am bit confused by the HBM device example being discovered as a DAX
> device. Is it to
> only to showcase the use-case? Or we see HBM device is actually
> expected to be discovered as
> DAX device with N_MEMORY_PRIVATE?
> 

"actually expected to be" -> no.  there's no requirement HBM be
discovered and boudn to DAX, DAX is simply a convenient intermediary
to memory-hotplug.  This is at best a demonstration.

A device driver could very well just call memory-hotplug directly,
or its memory could be brought up as a private node via a boot
paremeter (which I have sculpted for v7).  The former is preferred,
but there's a bit of a chicken/egg scenario for bootstrapping.

Most of these UAPI extensions are going to be consolidated into a
debugfs interface for testing purposes only in v7.  I've been working
on aggressive Linux Test Project test expansion to ensure there is no
UAPI regressions.

~Gregory
