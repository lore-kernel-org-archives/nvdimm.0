Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE8F14D2B2
	for <nvdimm@lists.linux.dev>; Thu, 11 Apr 2024 13:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712842661; cv=none; b=Icv5JgU6faTZRMzcmhJA865bCzqPn+OtyuIX5NnG8oOoVumoivnfvi09xxiSja4X6KFwfN83Ze4TBNgNgztJ3vjuqW8HX21nBsABneDboGSCRTcW1ptBlx+pkhpmFvxOoELReATnnMRyexzp2kdSMJmGdmgkn6RONtx1huNFMQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712842661; c=relaxed/simple;
	bh=DIAb7MBg/O79YuapLR2aNqATub3e0SOKNJsfHZ2b5E8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=UhxkGYKVJP6z6Ge3YoZ3TuwgfSWyweHJWlhjahu1WA+b/paO5kayO2P7QmM91lJZoLtBGKDXjob5SJUY6VBocAoUdIH5FfV+x6Q0GlsWd14dznpKL2JYvKMULzQgV2LtHhB/6I4nKu93e4e/xlbxC++/PHKAidyYpjhOpBjgON0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VdZr9owC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VdZr9owC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712842659;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dERZePAMGY5Ogff4MXaSm74/ezvcT6trwfEdO0OfoQE=;
	b=VdZr9owC+8APMHB3glMhT0+GoERpECKD3T8BC9YDTW+BJl57CNFRMO+ue4QDnRUrcWeMuZ
	ogOpAwkR6EDGfNM1AaYWrlhS90kr1hA+0RbvzexO8WZ5a6XXzWvfDiYselGKQlpYveZ3Bg
	Yatf18y1hEBa8VAULB2o0YbXavYuV0k=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-649-LXQx885EOyic0My6Qy-UPg-1; Thu, 11 Apr 2024 09:37:37 -0400
X-MC-Unique: LXQx885EOyic0My6Qy-UPg-1
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-4311d908f3cso34891611cf.1
        for <nvdimm@lists.linux.dev>; Thu, 11 Apr 2024 06:37:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712842657; x=1713447457;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dERZePAMGY5Ogff4MXaSm74/ezvcT6trwfEdO0OfoQE=;
        b=Wmk1tknVwCt3rVgVg2vTHPYwhkpc+JQm1h9p6hlTQ8/QLK1xWnO1VQ6AgOFzzAJdQD
         BeT3SqLfTeioB9jKILqxW+bp5/J/d2HrcGNM4ClcPbhMdcA3NytWBA9q1FhByn95BRzp
         MwYO9sMtW2d7+8F3UBzPRNyk3Ig5kaanfKyzi5otjCNFx+65FpIX1phQh1nwr7AC7HTR
         6cag393wy3SQ0/qqj3wVsTaBWPbkLXTPG3ABm5Sz8jgi8YABMUTVgWt4l2Aon2wzk+Mz
         LES4OwLO1LACEjTnebcTcCepzviWl34Xk952GzgBG2721A+lpgTN4SEaQ098ackrRggz
         wfjg==
X-Forwarded-Encrypted: i=1; AJvYcCWSF37ZnYACm/KeMOjvCg54IkAkvgFTaOnQ4YwsYDwaabvYmUsFkhcIp2Z//nlV8JCjV1pDo3SaDwbwCAY0hAGERz55mVrl
X-Gm-Message-State: AOJu0YxuprCifZepaoVvzyoLyfKYRWIIuu3PUqTUsjlapO4Ilr3B0AO/
	PKRWRwkCHbhtHGPMEtUT/dQCUnKsXeNwdYnvapP4cc5GgKMhtaYnIiAYJY/l6mM7e38XZ2qgKXq
	UeE5jF2ClUqQTV5LCTj3ms/Q4sH0j9xTujjA1iiN/MIYK2tMtw24G3w==
X-Received: by 2002:a05:6214:da1:b0:69b:1833:598e with SMTP id h1-20020a0562140da100b0069b1833598emr6052233qvh.6.1712842656861;
        Thu, 11 Apr 2024 06:37:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEQ6y7GR0pZzFXXvPoL0L/gLuIw2bwjbZR6CEdv4NI7c2F2dzHLnZvnROzJ8bJwU9WvPh/HLg==
X-Received: by 2002:a05:6214:da1:b0:69b:1833:598e with SMTP id h1-20020a0562140da100b0069b1833598emr6052197qvh.6.1712842656337;
        Thu, 11 Apr 2024 06:37:36 -0700 (PDT)
Received: from x1n (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id e7-20020a0cf747000000b0069943d0e5a3sm946973qvo.93.2024.04.11.06.37.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Apr 2024 06:37:35 -0700 (PDT)
Date: Thu, 11 Apr 2024 09:37:33 -0400
From: Peter Xu <peterx@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
	david@fromorbit.com, dan.j.williams@intel.com, jhubbard@nvidia.com,
	rcampbell@nvidia.com, willy@infradead.org,
	linux-fsdevel@vger.kernel.org, jack@suse.cz, djwong@kernel.org,
	hch@lst.de, david@redhat.com, ruansy.fnst@fujitsu.com,
	nvdimm@lists.linux.dev, linux-xfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, jglisse@redhat.com
Subject: Re: [RFC 02/10] mm/hmm: Remove dead check for HugeTLB and FS DAX
Message-ID: <ZhfnnYfqWKZn5Inh@x1n>
References: <cover.fe275e9819458a4bbb9451b888cafb88af8867d4.1712796818.git-series.apopple@nvidia.com>
 <e4a877d1f77d778a2e820b9df66f6b7422bf2276.1712796818.git-series.apopple@nvidia.com>
 <20240411122530.GQ5383@nvidia.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240411122530.GQ5383@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Thu, Apr 11, 2024 at 09:25:30AM -0300, Jason Gunthorpe wrote:
> On Thu, Apr 11, 2024 at 10:57:23AM +1000, Alistair Popple wrote:
> > pud_huge() returns true only for a HugeTLB page. pud_devmap() is only
> > used by FS DAX pages. These two things are mutually exclusive so this
> > code is dead code and can be removed.
> 
> I'm not sure this is true.. pud_huge() is mostly a misspelling of pud_leaf()..
> 
> > -	if (pud_huge(pud) && pud_devmap(pud)) {
> 
> I suspect this should be written as:
> 
>    if (pud_leaf(pud) && pud_devmap(pud)) {
> 
> In line with Peter's work here:
> 
> https://lore.kernel.org/linux-mm/20240321220802.679544-1-peterx@redhat.com/

Just to provide more information for Alistair, this patch already switched
that over to a _leaf():

https://lore.kernel.org/r/20240318200404.448346-12-peterx@redhat.com

That's in mm-unstable now, so should see that in a rebase.

And btw it's great to see that pxx_devmap() can go away.

Thanks,

-- 
Peter Xu

