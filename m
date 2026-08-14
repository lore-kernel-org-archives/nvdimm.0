Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A6146F4A8
	for <nvdimm@lists.linux.dev>; Fri, 14 Aug 2026 13:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786714040; cv=none; b=db1E4OHkq5wUac3vv2XFBsxZNhCk9orl/qysceYlTIYGhzwf2O2Vqd24FDPz+laI+gf47S6EBVb/a9ontRzjqSO/kw+3Wxoih/fpXA3CTk8giqHKfI0xfFYHsoFTzqHLdHZG3sEYtWCGzHci0rhgqVH9zU0h6iUUvyKTTc3P6LU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786714040; c=relaxed/simple;
	bh=CChEzwWKHqvAbDe82pqB+EpRVBOCxUp7FVLoHlKhGNU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SSrO4lXU5pDOJt2946uaFyBE6h5FjYLaO6BHDZbQXoQTlq4x1jQzmnN7mI8a7RpmJ2Iw79c5Zdomz1rWTQBhai+Dk6PUqXq5rQqj6FAv7ocFM8/CoCusR1+MS7k1pyc6WZmlMW0agR4xlk3j4sTP6euNR4qZ4zQEkxTXA9qxaYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=TMgwMIHF; arc=none smtp.client-ip=74.125.224.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="TMgwMIHF"
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-66c71239c48so1366223d50.2
        for <nvdimm@lists.linux.dev>; Fri, 14 Aug 2026 06:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1786714037; x=1787318837; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=n4ArN/eG59F6/a+Z1l3n9inh5iDgTQHyg71JvETU2wM=;
        b=TMgwMIHFZXCEdaJqXJK4jWPfOjZunc2y8gBLbLZBaloKWm3e8EKmgPPd5g/N34z7P8
         njn2fp89mmxYIcPnoIt+H7hNBCIFzO8B03QEwbP+FZH7F6qBm/hTBkNJGqDFfH6TxiFe
         n7ZJgHbFQGLITr0lNKyp1t/uddDQPJTN3X5zDexoWBjD3CzKsI6lO9KyRPyyKUyG+OHA
         DRxdkNti8kws6iandVxfbj0xN2Efug1q8QO8hbySj4kuMLSo6XDJGFmp/PGNuhzbkct5
         leOoGlovEoLBjhWfXG//rGjeQfNtKOLo7Y0a8GyY8krE01/KD48zMxp5zikOTln9Vbc0
         Aqtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786714037; x=1787318837;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n4ArN/eG59F6/a+Z1l3n9inh5iDgTQHyg71JvETU2wM=;
        b=cs3cegqDl7e2oLqpqSD7V6FlNmapVJoXLL9IhNR/VZsRm/usDaXQ2LzY348eKrjubF
         gw5JnzSPzDxJmHNsrje8MFq7jz3oBkacWEoLGkQPXKFGQY5gGocjWt8tPUjI9Q7MQHMe
         Dfa3Xs/i4oxj9fPG8ISMn1d7yTrL7oUwwXcMS3ehVAKYvndbiJpyQnRN4h250gAmWmsS
         EWZDMfOY0UiPn0Seqhp71nyxjskP9tw1fLJFguatJyXuey7vYpjMAVWuwhvl6sK5cBGu
         HJeIsk8cANJ+KQ6u4+IMkyzPBr8VmOBVyGlNmvzUI+VFcvGX6caovZ5htzalvQfTGMdO
         TJxA==
X-Forwarded-Encrypted: i=1; AHgh+RoLBxFwQVLG7SPhagsheTDCa5RX+mmVR/JMFnY7ZgownW3Py2z9ouIsOyXbydDBg1YQiDii4fA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yye3/sVcjEHuIAWCTakZpPE6jRHl8XsTRX1cxvLxXdM8Kin7P8e
	zHeVPta+xtkZi73+bUMh7lZ/f1fnxr8/FA3xyrQis408f70gv7Aa9YXlv+EckPRgBSw=
X-Gm-Gg: AR+sD12h5tQTvnh/5eUVluQoF15VEZorgWd+pShpC6CR8jZ3cijI/T6u21L8WUm/n8L
	XLwdeZ6dbLd+idtIfnIoubSrTdOtinzEy3A8yWtZI2C8I0Xp/XNl+S5G1gZFILgqrIuj0Wru5/L
	kmF7HU792co4CVLJHdAdl3hjw0glE8b7vLhbfQuFB5XIiVv4pknvzog0oEco8u+kuiIAas6WiEW
	tm2n0M3U0GGvcKbqEcMugPt6Onb39F0t5wZL15/MV27ipGaDv9bVX3lKJFYrA1fQNERfoG7CF8O
	VA9xDxTWeTjg5erylzj0rFtPlyVMOjNlAkRucxss1VuEkGa1aFzklANdl61uZehkfryqhMl0lMI
	fa++0m9WtUUoJtN9u6PUNrHU5NOSQpLCQ8fbKjCcRiTtGEx6UJftXm7USSqzLVZMpAnds5LZPWt
	szEMhO4+RbgHyXLn4tlyqxk/4VUYSIHkCNYEg=
X-Received: by 2002:a53:c584:0:b0:66a:3662:409f with SMTP id 956f58d0204a3-66c72ba0d10mr1917799d50.10.1786714036424;
        Fri, 14 Aug 2026 06:27:16 -0700 (PDT)
Received: from fedora ([2601:19e:8500:d3c0::28fe])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66c75c9d90bsm1010793d50.8.2026.08.14.06.27.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 06:27:15 -0700 (PDT)
Date: Fri, 14 Aug 2026 09:27:09 -0400
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
	"Gupta, Pankaj" <pankaj.gupta@amd.com>, vishal.l.verma@intel.com,
	dave.jiang@intel.com, alison.schofield@intel.com,
	osandov@osandov.com, jannh@google.com, pfalcato@suse.de,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	pbonzini@redhat.com, osalvador@suse.de, joshua.hahnjy@gmail.com,
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com,
	kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
	baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
	weixugc@google.com, yury.norov@gmail.com, linux@rasmusvillemoes.dk,
	longman@redhat.com, ridong.chen@linux.dev, tj@kernel.org,
	mkoutny@suse.com, sj@kernel.org, jgg@ziepe.ca, jhubbard@nvidia.com,
	peterx@redhat.com, baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev,
	usama.arif@linux.dev, xu.xin16@zte.com.cn, chengming.zhou@linux.dev,
	roman.gushchin@linux.dev, muchun.song@linux.dev,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org, linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org,
	cgroups@vger.kernel.org, damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v5 00/36] Private Memory NUMA Nodes
Message-ID: <an8Xrb5Phmvs0xE4@fedora>
References: <20260720193431.3841992-1-gourry@gourry.net>
 <CAM9Jb+jpJ-Ui4qDHxsp2WiERiv8gmrQfKQ8Z0BmabefeQ6pg4A@mail.gmail.com>
 <an0cAMh_m8ZhGIm2@fedora>
 <CAM9Jb+jmxPdL-CdWQHYMT5G=qmjB6z2WFg+4K8Fod5n=2N6YCQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM9Jb+jmxPdL-CdWQHYMT5G=qmjB6z2WFg+4K8Fod5n=2N6YCQ@mail.gmail.com>

On Thu, Aug 13, 2026 at 10:55:13AM +0200, Pankaj Gupta wrote:
> >
> > A device driver could very well just call memory-hotplug directly,
> > or its memory could be brought up as a private node via a boot
> > paremeter (which I have sculpted for v7).  The former is preferred,
> > but there's a bit of a chicken/egg scenario for bootstrapping.
> 
> I find this interesting as this appears to be evolving towards a vendor
> agnostic framework for hotplugging memory directly to private nodes.
> 

Agnostic would depend on a common standard for such devices.  Otherwise,
there is still a need for per-device drivers - but hopefully the
interaction itself can be generalized.

> How you see this working? In particular, How would the kernel know which
> memory ranges correspond to HBM or other device memory?
> 

Device marks the region reserved at boot, driver hotplugs.

or

Device marks the region normal, but boot param sets the node private.

> Please also CC me when you post v7: pankaj.gupta@amd.com
>

Sure

~Gregory
