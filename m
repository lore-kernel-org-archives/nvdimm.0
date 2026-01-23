Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E2E2620DE
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 19:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769195548; cv=none; b=Rw/hgKcub0DTM6fh/jtzSiuHGJct25xJpr5bOjoyP5lDKKzC0rdpDpdJmXo7MqSsKxZ/Cg76tT8GFf1PlyXoc+k+uqgamt2/h3fQe/VREwojtO3ssqSw++2pHbwKQgCS+74sZiPh5diLeKfFnNnJpJFsTtSHAz6Wk/+DTHl3c7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769195548; c=relaxed/simple;
	bh=dwNTImMJO2gHVlejeQ8Ezs9GSst86dOsrCCdrs8fh6Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bj/fW8liVi7AEE0hjhlhVikZ2WsXDzDKk/PceSG/Qvq6OqI5NmCGg2OdOCur6rqyjruD2kGxL89nKuf6JKMsXPkcjQE9V4D2iWm8FVKzmDxkyq8GnWt1hWyUX3txccv4HOPVckfj8hSrzXWBQRPWtWPGKpegVyGLGsKPwOyE0eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=nNDmdg4W; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="nNDmdg4W"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-888bd3bd639so37130976d6.1
        for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 11:12:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1769195546; x=1769800346; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iAb3V8FwAoFt+i7QIjKEQtHflVF/O2of2sgUimojvUA=;
        b=nNDmdg4W7MfPeieSfkdNfZ0zgX+KDBvF7gwY5/FSn+YTYVXkOx2GUx6GwI+zF2PCWI
         HXbSyYoFqCXkOJsstVJCIAI+nzij0UzbhltVICNGZTtSyjNLH3kC+Ysv4nh3RW98jMRv
         15mRAKWvRDT3IoTHGMvirJgY7V/PgVotqJnsfEDDkmt8jH7/Lm/8IS9nLEhqokSqhJtH
         xn0aHQctOU4dVuQfPpn7Cprjj30EKAisof6LcA+7Ylu83ux0+AlTcZXqnJxRZSK4K42j
         ECyjW7ogU+dQJwAtM8DqIE4nXeOXVzznQdbuLJHIc7V5upBe/fdKsYohILbYW2w8fLjG
         Ax9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769195546; x=1769800346;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iAb3V8FwAoFt+i7QIjKEQtHflVF/O2of2sgUimojvUA=;
        b=MQ0ZnpCtwMNgQof8PFwmEn1B9+rTkztN7ruVTNY8NBn6g3iXZETuXPpyrBzqjLTHbB
         H1tabKazkgZiFl/zYMBjv7C0u1JOHpOA18I39Bc5wNs/CdwI5OCEaf+8ceRTH3pWpmV9
         GFcYdmHimLz/ImHLcCkjwYojo8jL4IPahkRUZKLMjh5MIcnHUd56UQQalz+pDCgzUYck
         zATW6S34jttUqDdL/6+6gfIMdNU2yYy8B6wiRrJ6BEYAOP9OqD6kUWbwi1qHF7vS/gaY
         syzPysJmT/zq3sU74RRXQY4Loqf5NxJ0apeFFVzmNIkm7bQvq1mvl+R5Kcd/m4QQGlJx
         8p3Q==
X-Forwarded-Encrypted: i=1; AJvYcCXxcObkh+akg4GEdM3WsU1Ft5iqf7Fj26Xt+ODqp2ztYdP1CwNATG7ks4LwxxcsdAo0lfubM8Q=@lists.linux.dev
X-Gm-Message-State: AOJu0YzfCqMsw2V1caqkR6Y8KB4nDDSE6+INov/VR5CVq7PDLMybTPDa
	VapWd2h/4Rck9wmnLH9B7bES4Zt5ZK3Psr2+/0q6zxyfx8E6vEgCvZFgF/Ls+mgv/AU=
X-Gm-Gg: AZuq6aL4ctIJJSGJqt035NjvLvcRvg8MWjB9qbgWEIDrwV0tdsheZvQ5ETD8RWfYI8e
	+htXYh2C7rfyzBcw2fgk416c1H1sohjCoectjIWQqMSvKCzOuuf0IzSwVGmh3oZQ1J0pDxdYnp/
	sJPp9SHG0M38cIv35z5Slzji/f0B1Hvrn5BjG/003ZKlM3d1mQsLxVMqZpPln6bMZ4lafvJ+OAK
	RP6ySzz5+ewrANpByC9HSc5j+q6aoB60tSbxC3p3lAsrQV2UQTylB3Bj+Pjc0wiOpoSXmbIuhDg
	KleN36yWxvjKMOV7uJZPKrO0SdUfMtvyp7+D95FGQOBwWW8xsidIVUoIoccKqM1Gn0QRfmCbcO2
	zitzPRxwZGrKLf1aY9XOBDo2eu+fekVFA5MRtrLcLCvi3kmhzfzVv7Gp50MgkhNhSJOTsl2vfRw
	+9vKl9LSgwqjBoAgZEGjTix3cy1rIHKDlN3SMI2EsET0FadwoA9Kp1/8ebOZB4Ir15nENXUXhEs
	aJrqXOz
X-Received: by 2002:a05:6214:3008:b0:88a:2ac8:9b3 with SMTP id 6a1803df08f44-8947df771admr103884956d6.9.1769195546348;
        Fri, 23 Jan 2026 11:12:26 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89491823cf0sm23001816d6.8.2026.01.23.11.12.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jan 2026 11:12:25 -0800 (PST)
Date: Fri, 23 Jan 2026 14:12:24 -0500
From: Gregory Price <gourry@gourry.net>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>, linux-mm@kvack.org,
	linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
	kernel-team@meta.com, dan.j.williams@intel.com,
	vishal.l.verma@intel.com, dave.jiang@intel.com, mst@redhat.com,
	jasowang@redhat.com, xuanzhuo@linux.alibaba.com,
	eperezma@redhat.com, osalvador@suse.de, akpm@linux-foundation.org
Subject: Re: [PATCH 3/8] mm/memory_hotplug: add APIs for explicit online type
 control
Message-ID: <aXPIGMVAvVEBgFhJ@gourry-fedora-PF4VCD3F>
References: <20260114085201.3222597-1-gourry@gourry.net>
 <20260114085201.3222597-4-gourry@gourry.net>
 <b3d435d2-643f-4dad-9928-bc7fb5080181@kernel.org>
 <aWfR86RIKEvyZsh6@gourry-fedora-PF4VCD3F>
 <4520e7b0-8218-404d-8ede-e62d95c50825@kernel.org>
 <aXLCAtwMkSMH3DNj@gourry-fedora-PF4VCD3F>
 <20260123182526.00005ee8@huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123182526.00005ee8@huawei.com>

On Fri, Jan 23, 2026 at 06:25:26PM +0000, Jonathan Cameron wrote:
> On Thu, 22 Jan 2026 19:34:10 -0500
> Gregory Price <gourry@gourry.net> wrote:
> 
> > On Thu, Jan 22, 2026 at 11:41:24PM +0100, David Hildenbrand (Red Hat) wrote:
> > > 
> > > Right, but I don't want any other OOT kernel module to be able to make use
> > > of add_memory_driver_managed() to do arbitrary things, because we don't know
> > > if it's really user space setting the policy for that memory then.
> > >   
> > 
> > Ah, this was lost on me.
> > 
> > > So either restrict add_memory_driver_managed() to kmem+virtio_mem
> > > completely, or add another variant that will be kmem-only (or however that
> > > dax/cxl module is called).  
> > 
> > unclear to me how to restrict a function to specific drivers, but i can
> > add add_and_online_memory_driver_managed() trivially so no big issue.
> 
> Is EXPORT_SYMBOL_GPL_FOR_MODULE() enough?
> 

Is the issue just that add_memory_driver_manage is `extern`?  If so
yeah, i can just do the EXPORT_*_GPL path.

If you prefer FOR_MODULE, then yes I can do this.

~Gregory
