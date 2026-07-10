Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FAA33F8BE
	for <nvdimm@lists.linux.dev>; Fri, 10 Jul 2026 01:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783647022; cv=none; b=gSY5KTLi2S/cQUWV7ZHxfiWUEERhe1qQd2wWwZBULjb+4VHAeswvVN2u5kLyKLrp8kwpQlMdsU3LHExBpW3A1UJnmIPOjmmtWlBGIlTqW7IQnWVbv9IKsoys6iSivM85jdOLAMrMsvVQHdYBli6DYwd9xzJc21lAzdKtmBfGL94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783647022; c=relaxed/simple;
	bh=3rYTe8e2Wt412qzExNzuhcRev2Wp33ZA51eAifLPzps=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jagF005FIYXMgr1WHyVOJNUtQ1Grt3d0sOixbQ35gEUM1gvBZrRGjh0ucJcowU6PmW2BX5H4FEMqDaS2U79KMT1AegUe3HvQwQmD7MsOw6lD0EKMxZ5BF58GvSdAuaREdpzL9i84YGV1zH/8gZ/cpcC5qTQR8Hk5DHAb6jGJHLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=KNJuWVXI; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="KNJuWVXI"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-8efef6533aaso3092846d6.0
        for <nvdimm@lists.linux.dev>; Thu, 09 Jul 2026 18:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783647020; x=1784251820; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VaPhGtocKLbFXsyQXoR9g3DKOWhugqrS27IBZSVVhcw=;
        b=KNJuWVXISttBo9KiJyi51pBsRPkS/eZ+wEhArKYCtDSiyAydEA1NoDKLtemPQmgw4y
         pVveA/0zRrKIpM3pPLWKRVO4hvlviAPj3tFK10ze0LDh9nlBw/7ZZ4MeBT3TRAp0ayhY
         yeV2Ld3gV+RkZXA4Ixgu+ghxV++simCPg/oCLfzj2r544M3XkcTw34quZl9aVqUtiv3q
         Wkze7BI5K0FRZ2EUcwhVONW6m2pRNxj7iUO5CYDc7+8S7C6ssJCZ2EyRmHh67Q1/42zy
         MUeZy5hUxn1H44kh5WBtRhuY4BxguqkhSg89gdolSKY/rprmicAItY1NxmSUHdAcMggW
         NKLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783647020; x=1784251820;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VaPhGtocKLbFXsyQXoR9g3DKOWhugqrS27IBZSVVhcw=;
        b=KAPF/BJut5dC99Yl84/+yR0PsR5eAJOoa1KdRG39gYdBUxtha6F6Y7OBGS5fFR6J+e
         lp8k60Qhn5tj0kTfru+IurybS6RnTVR7WfmCdOtqyv0usmajPCRDLQHbEuVISklVyWcC
         +VLOMWrKx9w+dbatbOTCc7kYO2zOP76D1BcwNHxnlThGmIhhJ2BfdATCay/r48am6Pbc
         qyxhePwaPcf2ajJiFEYn6Ffxx1OYvRR43wj31IdxflvGxYHwqUqYhcbN/NArrc286RZ+
         YNlZXqkBLljNfkMClFqTbyDIiS8ZoCEzceVxAgOkxNLzj3jxIhHNiHhSTU+DsHYXilYz
         5laQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq6Ua7POZ9S8VEC2cjB/tAXHvwDEbUHgk3W+fDPTLmsV9QsVxZVQ472CsZ0EJRHhfQ1x3c+5Xc=@lists.linux.dev
X-Gm-Message-State: AOJu0YwGE/HT8MFN4DZvI9YwWdfR09/n5iwLISRTS+AKj4852VQqC790
	r3YO7qwXCkfQ4oex0qNs83oI25iTyRUOnmb/V8suULxrjpL5pTAbM9FRT8zIBKmzbSvgIqLl8d5
	1TIGq
X-Gm-Gg: AfdE7ckEZ225Z18HVVw1wI75g1gSlW2l2HV5GVdBfRjqn2SNeza9YGix9NgyjngGZ2W
	MPPb031q17an7pXBaC/tQ6nbixnTQK0WZ3Yma37EhiaNoDN+wiNefnLkA4r51JsDNVApNb97FkA
	lkseJ+QoPOJotorHfKNXDAyUaqWoDBUM44L1ePo0DUGyHFpuDtA/Kw8wsTGBaVdLAeHo3RWhrfu
	aR760RYXCXEdYnyyPfAhoHgif2GLKl2sZgB1hCGedLKHk8Hv2CZvhVkQTnwTs85SjgYtjkdBQnF
	VcyP7emZAhA6FuSt/qW9kcHUCv8Qb0VkY5RTIBBwcBjEuBEqHrPb65NNSnuLpV7luzhjuAgakxe
	SUNPeThiCHi1IQzN+y4QV5yRLq/eqxziqernbRxonYK0n9RUhUv7Hv8uJbOfCVRypg8rQA6TtQF
	0GB0OuYc5dttHsl6Ht9uzowpdsOwtHXo/18elxSkmm7RkdpFfKNul4/kLI+YBw7a+Fee5/
X-Received: by 2002:ad4:5c8a:0:b0:8cc:2a92:48e4 with SMTP id 6a1803df08f44-8fec217b8bfmr110693186d6.32.1783647019857;
        Thu, 09 Jul 2026 18:30:19 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd7c1e8aesm29789146d6.28.2026.07.09.18.30.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 18:30:19 -0700 (PDT)
Date: Thu, 9 Jul 2026 21:30:14 -0400
From: Gregory Price <gourry@gourry.net>
To: "Dan Williams (nvidia)" <djbw@kernel.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev, linux-kselftest@vger.kernel.org,
	kernel-team@meta.com, david@kernel.org, osalvador@suse.de,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	vishal.l.verma@intel.com, dave.jiang@intel.com,
	alison.schofield@intel.com, akpm@linux-foundation.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	shuah@kernel.org, iweiny@kernel.org,
	Smita.KoralahalliChannabasappa@amd.com, apopple@nvidia.com
Subject: Re: [PATCH v6 07/10] dax: plumb hotplug online_type through dax
Message-ID: <alBLJoM86ujz5Fg1@gourry-fedora-PF4VCD3F>
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-8-gourry@gourry.net>
 <6a5016bf71df4_3b7ee5100b3@djbw-dev.notmuch>
 <alAb7Q_Ku5dVRKZ7@gourry-fedora-PF4VCD3F>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alAb7Q_Ku5dVRKZ7@gourry-fedora-PF4VCD3F>

On Thu, Jul 09, 2026 at 06:08:45PM -0400, Gregory Price wrote:
> On Thu, Jul 09, 2026 at 02:46:39PM -0700, Dan Williams (nvidia) wrote:
> 
> This was more a matter of having the DEFAULT set consistently across
> the dax driver variant probe() functions to make the behavior explicit.
> I didn't want an un-set value bug to creep in here somehow.
> 
> Happy to drop them if you think that's unneeded.
> 

Ah

Not setting the value in each of those places is equivalent to setting
MMOP_OFFLINE (0), so better to just set DEFAULT regardless.

So unless you have strong feelings i will keep them as-is.

~Gregory
