Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EAD02E7F07
	for <nvdimm@lists.linux.dev>; Mon,  2 Feb 2026 18:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770056622; cv=none; b=eq6NFHbPSkRLkXPJ0ruax8sJER8a0tG/oQODtTYu0SGZkeu4EEkIEHU+HlapOP6RHRTIANa0RUq91BmzeYTi634otrMUa4F1RZqXH7Qhf70e8n+HGd5qFyEPH9w9pzVcxwJziDFm8Ul0hAe29/LJ3Svw7u03E/5M6JY3HHKeDCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770056622; c=relaxed/simple;
	bh=ADF7ZKoCipxDP6UUmIGW/IPztV2DncS/DM4/x+XvBnQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hNFAhCc5FmRZqFBUgpXAUvhZ61BiOvSPflAO5fSw7BjY8w9AMWSlHJ4LlicY1ty9ODigcqKaZo5Og/6PNk1vEuEmF7/MkIJ+uIGa9+fdAvtSzC7D0sfOBvMbPuVJ5GgKLf7vjrtIs7Xm13JeKgJik1Va/OfcW7nXOOHjI/HiPow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=s9gGLQBP; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="s9gGLQBP"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-8947e17968eso54373286d6.0
        for <nvdimm@lists.linux.dev>; Mon, 02 Feb 2026 10:23:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1770056619; x=1770661419; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MqsmEA1l4K6M349TDpqaFt5arK8yfZiMH/3re7GUwy0=;
        b=s9gGLQBPRK0J5qBeca0uSPdBSyhNh8fygeoc1/+drajIYrrY9yE/PVn4sJSr0sLcVy
         g0vqIwN/NqGq7Sw7QafPceJiP498H6Iy3lFy/pRHwuv00AgoDsdkFmaWGj5ydEDX5jA8
         8b7X02eb0hrjFvSesv1wxDV5vPphrPDKJRtfkXMr8VZvlOaFuvFPGQrDx+0C1qJ9rpxz
         hgju+70H4ivhGlDiYPrILe+/QVeD/lP1IsE35OGB5QSJ6o/uvnbMPV6w/DFuaRf2XHq0
         TdKTi+6XrJ2dBBrm34mZOyuFeIxTxsgGpPDaSfmxeyvfEp/50rNEzcnGdlO7RwcQ4enw
         5+Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770056619; x=1770661419;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MqsmEA1l4K6M349TDpqaFt5arK8yfZiMH/3re7GUwy0=;
        b=srYw5xEIhPGM8UqxsvqhbUFgzf82FsrO1MGwhWr0mMM6AfK0H5nD+wNPfsgvs9y5Al
         ctxvf+V6NPQf/6yKwUPE2LeHhxtmGR5Uq/VYzq9kgWTCyhlFZfv0jXhRxQ7+GhAUHIP1
         bYU5zIRvHFb9C68sOBaDYv3iOPnLiWMbQr0el3+1TAYy6ZgdoJRRuQlcv5AA9+QutA3g
         ykmXoNN7fJ0quYS1TZf4zEEFlpF70NLaDc7OOI4gJnWBAD4E5sLP/MwmAoJ05iiMp7W/
         EYTZU+N7Sgk9HQXiJqYc/GYh9C0276H/fB1NhtMpB6g//KEEo7/5GCXCrYFAGY2EoZcC
         eAjw==
X-Forwarded-Encrypted: i=1; AJvYcCWNl01sqyYlSHch/mUcbDkrGmNx80gehBC74tiWLDeNtkxflWGEnwVYUMALSYkYnLwh7MdJF1M=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy5djCuy2FqXwSab4RMVWwhh7dac655jj92aYuOOIqgDbIEBfCE
	dJB4EzkRoHrXH77I6PTbDGP4BNMdSXJQCp6wMpEhnRJjVpfIILwn8VNWw8aaeS3TuPc=
X-Gm-Gg: AZuq6aIlRWSIOdODpiaY/VEZSrw6y3r4OkgX+uJl51fSiTqnbIClN+U6+Bevyy5aDZz
	xWqt87bdPhGudZE2KIMYnSMflb+OJrLpii4U5HydWvcw3twzw/XO7RPB9irYGYLd9VCw3zpKkaR
	JUFBqNVCuIrAcVLm1Dxwx3qXzRkOSAKkbyb9JIB1cn0Ijq8Apool9jm3YlZVrQE5vx8NfeaA8eQ
	YWgfZ/Xi4kJnibbQGT+m+rbU8hXRwaIhRcvQxjBvjDvvArHVeRkKVoFhjnFWjsIfYDAs6UQTLGF
	wfwuasrsFy6zdmUyQQMbtMApFoTLWvVMqbq5gfXPI3Qv9X2qxtiyDs0ka8h7UNKNIlsyhNAnuTY
	PP6BeBtg8MERvaXE8X886grxlSeF4nPvxv/ZU5NbsPDxujL6MyhvyepaHPnNAWIK/+DQmZdE+NG
	q/6cOPGNTUV64SULnnoNQhCgMrX0qhdGG6UZYjoYOjCRHErD1gJuuPvshZy+UZNLBIfyVwqw==
X-Received: by 2002:a05:6214:e87:b0:894:6558:58f7 with SMTP id 6a1803df08f44-894ea167cbbmr166333016d6.63.1770056619523;
        Mon, 02 Feb 2026 10:23:39 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c71b859eaesm1089477985a.46.2026.02.02.10.23.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 10:23:39 -0800 (PST)
Date: Mon, 2 Feb 2026 13:23:37 -0500
From: Gregory Price <gourry@gourry.net>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, kernel-team@meta.com, dave@stgolabs.net,
	dave.jiang@intel.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, willy@infradead.org, jack@suse.cz,
	terry.bowman@amd.com, john@jagalactic.com
Subject: Re: [PATCH 8/9] cxl/core: Add dax_kmem_region and sysram_region
 drivers
Message-ID: <aYDrqVEOwkGfv2JG@gourry-fedora-PF4VCD3F>
References: <20260129210442.3951412-1-gourry@gourry.net>
 <20260129210442.3951412-9-gourry@gourry.net>
 <20260202182015.0000325b@huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260202182015.0000325b@huawei.com>

On Mon, Feb 02, 2026 at 06:20:15PM +0000, Jonathan Cameron wrote:
> >  
> > +/**
> > + * struct cxl_sysram_region - CXL RAM region for system memory hotplug
> > + * @dev: device for this sysram_region
> > + * @cxlr: parent cxl_region
> > + * @hpa_range: Host physical address range for the region
> > + * @online_type: Memory online type (MMOP_* 0-3, or -1 if not configured)
> 
> Ah. An there's our reason for an int.   Can we just add a MMOP enum value
> for not configured yet and so let us use it as an enum?
> Or have a separate bool for that and ignore the online_type until it's set.
> 

I think the latter is more reasonably, MMOP_UNCONFIGURED doesn't much
make sense for memory_hotplug.c

ack.

~Gregory
