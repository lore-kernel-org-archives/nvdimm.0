Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22903D0934
	for <nvdimm@lists.linux.dev>; Thu,  9 Jul 2026 21:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783634286; cv=none; b=EOpFGbOI4NTsghkzjevscDbRqT4BoU99VedU+LwGvPCWf341JZ/seHanlrqskhxYyw+l7UztQ4/27RYpc5VAPwmKhZrFhc8Qnl/FzJEF8mQWzZa7/8Xv35GhAPyvyV3sTSS18cBo/w2CMAA+s7Br9pUY/JuJDTodM3zp30XA/Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783634286; c=relaxed/simple;
	bh=C6+QVbKbywsT2lvtAVnXRM7Y/Q3xo1OzIYQ065Ab/+Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fstm18OvvMxBWtS3/GhQr4mA14DivCwUJarH2S7WNcs0d4AQ6MLnG7PKhcQ9nEda1NSeiHIWGjdvkRUGEGsq77Hk3OKq4IA+B1eUkQYI4njHwYJK65MZsqvi60wuf0QHdi3IpXWUgFsds3sSsXGHxrtw33towXfU0i1SH3PhCpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=eZsTfoyW; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="eZsTfoyW"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-51bfad59921so1777731cf.0
        for <nvdimm@lists.linux.dev>; Thu, 09 Jul 2026 14:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783634284; x=1784239084; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rIyfo2VEcxlnkeMECDcWCS4lIF+QfUGCzzimsolaQ9k=;
        b=eZsTfoyWvSlIw7RSej2bLoM89qq7YeC4lwxNDCEaXLK4lctTDInVORvQzRD7otQDK4
         IOzBoYzfY44oU4WAQhNOQu7NqeGES3DhxQyilcxu+W+WqaosQSFprg7Bt2m2YFOu7nRM
         I6rSuGvOLZsAceGW4pMupFlPJijPY486bG6CWUoDSJPwhgbH69wMeLxSmMKJg6LtfS+m
         foxXfk7puxlK2SNX3SUA6ma9+KRdNkdbkaTDzV6NIMVqKYWeb848Q1R+f6pTIDiGW3Bc
         AUke2yDNG2jrO4Gy0gLx7Tzubwn9h5dzReMiZ+RARtaPeRbfHaOV+9rFDqdcDmTdJdkt
         5zfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783634284; x=1784239084;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rIyfo2VEcxlnkeMECDcWCS4lIF+QfUGCzzimsolaQ9k=;
        b=C8z4aLCA/p06D2rsix8HfdThbE5LzabeNZfsXaD+rwLEue6PcEiF0DAMenHBwV83tw
         hiIPuP86ntX22A831k4GV5OH9Jxplzj7mpqzzbn9NAJ75toOUkRzsnu5Sn4gT2TQt2z1
         Q/zSXlq61zWN1bVklk4JzMcCVien3C8//XlpE07rZSTA05cTGdhcRS2HBZlKGY2g+th0
         UtA0r1rC9XS6JX+qTgr+qJs2JvUlKVGst9G6Uuc+qxAb/9fzwHqVlXZ84HWXwxpqpw+y
         2sTSaDAozaHFkz/Dhhk74kx2bfPiZnYz42dhIPG/oKQMrDptzKxFVTS+HnX+LBrFIVj3
         rQyw==
X-Forwarded-Encrypted: i=1; AHgh+RoSkonJRmb4vIuChs71ZX0rdBegxb2o5l5RULNTiS+YrxWIUFpmEKkbF5L7cjI/ckzliHAlilU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw+VjcSAUhGrJaF+epKQeYECH9rrfPseYul/FmAx9i9l52MpcHc
	aqFmhhOrn4QcAoWb4Kndih2TWzdki0xYuFvJNc4pXPsEu4ADIhA7w5MLG6mmV5vhFZM=
X-Gm-Gg: AfdE7cnz7CZyFW11M/cAWfUOtx+qPrYK0QjR5lRD2JAwt1JYClou2ZkiZLj4w+bSIxR
	oRTHZ4a3f1mhS09wPr1BVDEvz/gdu0UI8URtY0uul2GJJ7xV+2KCpWR1mUQvFiRnwWzQ8rK+5hG
	1Zut7G+M9hcMUSDXIlDW5IX+93lDbAEnynXpM8PGS4KcvnapKL0S/AEOymE5rouEzakSV0+61eH
	vw/+s0qIC2kEXORw45tQzgbDP5Hd0Gte/y8Bbo0Hp3HMYW/wHUEFffE+QYYA7IaQ4dEh4f8zbAO
	KzdIaAETS4IInVOICQyVrBy2EUqq/qVOfCJcXzdD9YgRbmFV/kq0ufgi/rsNuhG5ioUm9JWc/D2
	ag2SPcP8TORcRsmxSPNc/rnS4bgorH9hUE2bdzX8jr5Mt1BbUTqpjnG1jlGcmoQNUAi6slqhACM
	MrwLJCPBlqU4N3D4N3NfEDu4ZcfyO9V9U+lPow2NwDub55lmMDgG3LqWNm9NqaZL1eQjmeZ7VW9
	9WCtSg=
X-Received: by 2002:a05:622a:11d5:b0:516:dff5:68c4 with SMTP id d75a77b69052e-51c8b403cd3mr96830461cf.7.1783634283862;
        Thu, 09 Jul 2026 14:58:03 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51caaf9a12csm3563591cf.27.2026.07.09.14.58.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 14:58:03 -0700 (PDT)
Date: Thu, 9 Jul 2026 17:57:59 -0400
From: Gregory Price <gourry@gourry.net>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev, linux-kselftest@vger.kernel.org,
	kernel-team@meta.com, david@kernel.org, osalvador@suse.de,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	djbw@kernel.org, vishal.l.verma@intel.com,
	alison.schofield@intel.com, akpm@linux-foundation.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	shuah@kernel.org, iweiny@kernel.org,
	Smita.KoralahalliChannabasappa@amd.com, apopple@nvidia.com
Subject: Re: [PATCH v6 08/10] dax/kmem: extract hotplug/hotremove helper
 functions
Message-ID: <alAZZzO96_ZltrJV@gourry-fedora-PF4VCD3F>
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-9-gourry@gourry.net>
 <151783f1-c0e4-4c2b-a051-1e6e9c546cae@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151783f1-c0e4-4c2b-a051-1e6e9c546cae@intel.com>

On Thu, Jul 09, 2026 at 02:44:25PM -0700, Dave Jiang wrote:
> 
> > +		 * Set flags appropriate for System RAM.  Leave ..._BUSY clear
> > +		 * so that add_memory() can add a child resource.  Do not
> > +		 * inherit flags from the parent since it may set new flags
> > +		 * unknown to us that will break add_memory() below.
> 
> 'later' instead of 'below'? Comment reflects previous function flow that is no longer the case.
> 
> DJ
> 

ack. will pick it up on the respin

~Gregory
