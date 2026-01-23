Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58772F25F0
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 00:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769128461; cv=none; b=WLdLxW/vBXW9P7pjyBawF98qkSIPOwKKAgexH5g+GaXaejL7j/bO2x1qvZHUCKAk29zjup69iFfnV/uWRwfbjCufI4d+eF2p63L+RnqMldFz0lhXEutkLmiNYTjOeUR5JCdj8S63RpcV0WCGD/plLLPmZlNkDfaD2r6Ldv5G3OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769128461; c=relaxed/simple;
	bh=ksTMqewe9wJeVkWUQ6teggTVZqK1udNl0Tl8ePWbE3E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a0toL6TPDqgbqCCSLZ3St+GgDrlP/WS9txEn7YfUu93d87veazJsOzpfRQieQ7OMYGivz3UtlLGUtPMbN0+8/6cZWKNRQ9EZMxsfRol/r6CRYJEL3SS0cr8F7ZMmUf4UW3FkNAmNkjYyPJ7IaBqh8PTZprG1fnt91Zj3bIz/SMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=GzUmHT3z; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="GzUmHT3z"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-89473f15ed8so19001936d6.2
        for <nvdimm@lists.linux.dev>; Thu, 22 Jan 2026 16:34:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1769128453; x=1769733253; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=asBGl1upDPy9EBtcWnpVXAcR6hW540Iv+SjDFfHMW0w=;
        b=GzUmHT3zhW+SYZYH5QBf10O+epbfrU8tYgJGSDIJ7BhCmewl6GJy7AjXI1t/3ANXzf
         Gc89/+s7KnihF76dSEN1scgb2h2Zdk1dkteqNeC5vgyo+MRsyQZ5O231An1lwVGC7b+f
         OHxbi/q+PGs4erB2QEhEOZ6akwexDiuzZ7tM5U0wseWytULAoRtf7akhUhm6nTgw/xj9
         yKSUmPRXaamW3YOwGynHZlILw/uPBhTiuqngtjI7eyaFiDUmxj8NhkFFiPOJ0nybbA8Y
         BpU8UM0Mtr5YY/Q1NS+khdyU1FIGLeSzLkFBxRNlcLbK109ge58kg5dLppzCX+w6U95i
         h9kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769128453; x=1769733253;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=asBGl1upDPy9EBtcWnpVXAcR6hW540Iv+SjDFfHMW0w=;
        b=HJKrhMj/PBp5svVBBKtA4mItLuGQfsaPO/RmPAxOqs3Apb0oCEZTTEO2u+9U75wXBM
         a+MM30O+K+knIZqqTTswj8D+ztOdhIOVGPrZ2kEgANdimcg4YLghjfYkWAuMYW7v2Zt4
         hf8m0n+t5lUiUfgtyWNAyLsWLA7GXx2trohRpOcZkrsN+Vm17qgvgr9jeXVgzxo2iKEj
         pH8NKlGEYFLiHZn2qbOWVnw75zCFyj0FhiLt5lvq4vIqtwf8mh7eYCetb8voM5mwIOc0
         IpOeDV8I8+Cd8A1b6gURCWsZyQsRyyBP/Lo+OWpIb0vSTLlTvIv3kP+ZHHejnZGmoOCr
         vRDg==
X-Forwarded-Encrypted: i=1; AJvYcCUUlwBav/E6Dh5Y2s3jrigVmV6zPPhQQmSmFlNeWU7IEGZCTah4ijLMFV196ayvZ2CDZC230IQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YwGn3TSsv4d/yBw7v4NhoSlPLnSigB+Qog12O1pR+k6/lmTJvsQ
	FXB6BR6isFEpEFVWP5uLPjBpKPM6jT7uR8NOHskM3Yar4INJyyATsAGjRJKFeqOLNAM=
X-Gm-Gg: AZuq6aJJuqOHFtxw/e71Q4xa9ra1i4QavpQ7GzBIL/0liqGzEUeJSJxW02JV/FlAg3S
	KZ3RrpvtaGSQEoFfvAlH3BR5LwK3xYPimxCVSPoNtxpXjAXuMirCRVqQgttstJeXI3TgmEm5FRd
	UdaxGoVVHvKPGej93ZiU0201PLLTasIBo98OkMVImfowlCHhek3BQUJ0laPHltYWkBYHR2Td6Ty
	ZN8ZHlxLkuutyfIzFKSmP9NuWxJthR5F9ZSzOr6X36LloxatNjbGxGJBC9gQ4arA6JdzaoODIGn
	kAi+B9sBGdZpOSAfC1SN6aEglXSU9AAERb8ULPEo4dgLmCANDuwqtg4+Fqac5eW/PWZBECAyfkh
	V41BDrdqmpp15Pj2O9ulXINc9awvPNRiBWhcAflaWZWrliqvzx5hjx2p2W/UXL4QdL/Kp5aFJQD
	iFIPnf7hRBUkrBUrYTu7FsOAWCSMUM1ygOMyNE0tfsvFk6o47xMKau0QE3YBLzGxrHX57ArQ==
X-Received: by 2002:a05:620a:29c7:b0:8a1:b5ab:bbd6 with SMTP id af79cd13be357-8c6e2e369f0mr170716185a.71.1769128453428;
        Thu, 22 Jan 2026 16:34:13 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c6e37c71f8sm54022985a.5.2026.01.22.16.34.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 16:34:12 -0800 (PST)
Date: Thu, 22 Jan 2026 19:34:10 -0500
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
	kernel-team@meta.com, dan.j.williams@intel.com,
	vishal.l.verma@intel.com, dave.jiang@intel.com, mst@redhat.com,
	jasowang@redhat.com, xuanzhuo@linux.alibaba.com,
	eperezma@redhat.com, osalvador@suse.de, akpm@linux-foundation.org
Subject: Re: [PATCH 3/8] mm/memory_hotplug: add APIs for explicit online type
 control
Message-ID: <aXLCAtwMkSMH3DNj@gourry-fedora-PF4VCD3F>
References: <20260114085201.3222597-1-gourry@gourry.net>
 <20260114085201.3222597-4-gourry@gourry.net>
 <b3d435d2-643f-4dad-9928-bc7fb5080181@kernel.org>
 <aWfR86RIKEvyZsh6@gourry-fedora-PF4VCD3F>
 <4520e7b0-8218-404d-8ede-e62d95c50825@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4520e7b0-8218-404d-8ede-e62d95c50825@kernel.org>

On Thu, Jan 22, 2026 at 11:41:24PM +0100, David Hildenbrand (Red Hat) wrote:
> 
> Right, but I don't want any other OOT kernel module to be able to make use
> of add_memory_driver_managed() to do arbitrary things, because we don't know
> if it's really user space setting the policy for that memory then.
> 

Ah, this was lost on me.

> So either restrict add_memory_driver_managed() to kmem+virtio_mem
> completely, or add another variant that will be kmem-only (or however that
> dax/cxl module is called).

unclear to me how to restrict a function to specific drivers, but i can
add add_and_online_memory_driver_managed() trivially so no big issue.

You'd be ok with with this?

add_and_online_memory_driver_managed(..., online_type) {
   ... existing add_memory_driver_managed() code ...
}

add_memory_driver_managed(...) {
   add_and_online_memory_driver_managed(..., mhp_get_default_policy());
}

~Gregory
