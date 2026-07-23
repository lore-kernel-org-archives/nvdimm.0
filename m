Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679F338C42B
	for <nvdimm@lists.linux.dev>; Thu, 23 Jul 2026 16:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784825596; cv=none; b=sI7ype/QnEffEXBRV1ZmF629tEP5TwgSxlc08i3QetWKneNODbMkeEAc6xbC84JOQrCdjJ2Ba7RXHu4ml/4NrLj8zM3eRZCW/UDcCMOa87bKPNe0xw5zkXwDNw0AxgxqslltGCMhK1j3gY3RuqRZq/AcHs0YMS04oHbMwGvgDlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784825596; c=relaxed/simple;
	bh=z+HoEvmWYKtMfBygtPBl68CeMD6wWsLW69JzvhhpR/g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nOIoKGDVTa27kxhrWotAS8RfT7YFvqFXPwVAalvL+6jZ7S4rxPW6QqGZUdQK9gNF99s8P8Fdqn/qLmqJ4GE1+OYm8VqqL080FJQKZB6URPzOsX/vqv4+9bTeSf8ONSPyyTg1T43Whjb4mFIiMO95HHNohPOJuyrPWhMD/1GlEMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=kn/Z3F54; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="kn/Z3F54"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-92ed19f4d60so65198585a.0
        for <nvdimm@lists.linux.dev>; Thu, 23 Jul 2026 09:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784825593; x=1785430393; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bqVE/c/eX9E/Cy6wFBhLLV7HBSbIhrEkmRJZ6Osn4Tc=;
        b=kn/Z3F547ylAZcLe7JBWfcmweM6iZTuUyxLPxva4czgaq251v+oIynK8XCMufsHoCt
         mOBLzgByyi1X3mUQYm2PI1TC92JnU8adpYjrDHOxLa6ro1vO0mXSxTlJ+a9C5ZCPqvF4
         HuR25632kPiYUZhj4VCN4qfhyOvYyTzODpWsC+H7+1Fn9DcfkQUnSpr+sOUZkfFVEgsm
         4eyTP3AaSLtc/+nPg9X4ukmjld3pZt9zhHrUZivXo6lcu9MIoLcPRAkw20/NjDXQLfuR
         WMCd16rS7UNGIoAnl154Kfx5h/pubNLUqPkvsGAxs0RuG/odndB53oE6JD9+KXQRzCfB
         j7ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784825593; x=1785430393;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bqVE/c/eX9E/Cy6wFBhLLV7HBSbIhrEkmRJZ6Osn4Tc=;
        b=dD85wrFGxyBE09kNSvfHjhteM1Ez09yd7ZJG6Dp+F90yQB1B1ZKASBdsrIkIi7Ncm7
         8z8A21Lg3VUxDCInB6lbTwj9G8UojQUK8nd8o15/PCi2UAmNHSeBIk4iQXmWuYGQR7re
         WQOwwQKbk0cFKn2EoMJ1322RrFUPMpSyGBVMkq6TE/cQnleWKmv9GomIBAR6dZsT/h9K
         8c8vCPK70ss+CFexa5Gd7pkd0B+isNWhsQp2PO6bvEuYRpeD7BQayu9cuZYFxKqgKdoR
         oGtvDhpearTSJIz8RZ0ENyDdoCMzir2Sxo2JNuD412VyFb/gim/vqB8aDfuEEnzr/Yl5
         QEAA==
X-Forwarded-Encrypted: i=1; AHgh+Rp4RpenALvtXhJptcK4X1QCdK8BssAAIV0N1vcH0dxKul1aH2fugeBr0SkktGJO9nxKCzHMLJA=@lists.linux.dev
X-Gm-Message-State: AOJu0YyL2M4m7ZV8yc2dzWU6VxB0WsXRXREUiwuczeadAjxo5s3bX9hN
	02oMNlC8RyYg9CJLHQi8edRey6Eb3ffNIpQRgb3/uE58OtWEhnsSviTpldxeXF9Xxbg=
X-Gm-Gg: AR+sD12/7LLDBjtj8Bw3fK+zzxjGSPO/cc3KkJfzEOImSjnyAcSgwzho0UtqAP68k+J
	jGGuJAoIbC4wPlnBtcLagXiYYZgeNxiT8+nhf+0ee+5u7EaXW8AdrnZJlKxyP0UkTS3miF5gObQ
	urLeDldO+boxmbSROdhK0h4fHEvFkdUiWGMfMnLbrdQNmDNvkPggaYZuWOuT4Mp+q1VBK7ICDYA
	WxjZSFHX29RE4Q2zQWC6TIvR49VFOcnuXoMxi9IxPGqOlrtN3WLjd6vgGIcXf/ey/sg7G/K7X0b
	EAK/tRNtel0nCASSYbQ0KpfooBHW4elIFI+XU22kCUdhccxMBbr5z3nQneqLf9wa6sV6VS4tnJV
	gyGSzD+liovei/jQjjFWNlaFmds67u83Rgg3g/ENk8Fi1ts20gtBxSwovI8px6F7L/Aur0Xo236
	9UZvnbqijXV5eG9PstWSTOOuPdwt1tQIc3f1g00MXXLGaCn8pnyjvQ9YqOSw==
X-Received: by 2002:a05:620a:1729:b0:930:9533:5e32 with SMTP id af79cd13be357-9310468af9emr366578785a.7.1784825593202;
        Thu, 23 Jul 2026 09:53:13 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907ba9e18d4sm48785446d6.23.2026.07.23.09.53.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 09:53:12 -0700 (PDT)
Date: Thu, 23 Jul 2026 12:53:06 -0400
From: Gregory Price <gourry@gourry.net>
To: Arun George/Arun George <arun.george@samsung.com>
Cc: linux-mm@kvack.org, Zhigang.Luo@amd.com, balbirs@nvidia.com, 
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
	kernel-team@meta.com, cpgs@samsung.com
Subject: Re: [PATCH v5 00/36] Private Memory NUMA Nodes
Message-ID: <amJGUuBZ2857QjDB@gourry-fedora-PF4VCD3F>
References: <CGME20260720193443epcas5p167fa7d8490edfb4d8c0aa6a259db058f@epcas5p1.samsung.com>
 <20260720193431.3841992-1-gourry@gourry.net>
 <963815509.21784796303385.JavaMail.epsvc@epcpadp1new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <963815509.21784796303385.JavaMail.epsvc@epcpadp1new>

On Thu, Jul 23, 2026 at 02:08:31PM +0530, Arun George/Arun George wrote:
> On 21-07-2026 01:03 am, Gregory Price wrote:
> > Changes Since V4
> > ================
> >   - dropped compressed ram example from series
> >       - will submit separately if this moves forward
> 
> We intend to test this series on a compression capable CXL expander 
> hardware. Since compressed ram example (cram) is not part of this 
> series, how do you suggest to do that? Do you have a version of cram 
> module compatible with this series?
> 
> ~Arun

Hi Arun,

I dropped it from the base series because i want to try to move forward
with this without RFC.  The compressed service itself will be a separate
submission after I get decent signal on whether this will be accepted.

I plan to RFC the new setup for compressed ram this a bit later, but I
will share my working branch with you for testing.

~Gregory
