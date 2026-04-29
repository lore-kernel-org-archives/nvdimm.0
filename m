Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E8C43A8727
	for <nvdimm@lists.linux.dev>; Wed, 29 Apr 2026 23:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777507136; cv=none; b=bsD9stcO2jsXvj0dJAYvtsHjD0mUkx7570t/wlogxrZ7I9j814AJJYBGekFoQCRwYBL+tRPfI/33mZQNbEC5JnnWmsdjtrbDXa0NLmXM1uaqAmhyRGbdU55SJAmL6Me7Fs8UHzfFWnXwpKWBoLLnt8hTy739fBUF5B0j2E6bRJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777507136; c=relaxed/simple;
	bh=UP6u1cRk07fUI+6gBqTN1387eMnk0u9rAqi+TNq+K9o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ievvJVL/2q7IAEP/87fc6Dt5xH9oqhpROB+alL6wyq1ial7s9vuTt3HGSEL/58WFvKa98lOUXcDMAo3h+bY0QovDmcvrOy+CTUnIXj/Nt+HtYv4wE9OXwt4D5RCYoArlad6hS7eCXGPV7l9S1AwfBuJw+Cg1kb2G0n1yNDCgMAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=lO9nAPF2; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="lO9nAPF2"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-48984d29fe3so3578715e9.0
        for <nvdimm@lists.linux.dev>; Wed, 29 Apr 2026 16:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1777507133; x=1778111933; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eJIuZJ281FjkwI23dF39sBMDbu7btsxau6MlBLTWFw8=;
        b=lO9nAPF2ubFzJ6ytG973rNXGCnct8pGYFBejblLGLNNGntz1ehOjNQbXL9MHuTV7SL
         Hh8Jy+qedN+1uEvu0LtMpj4WH28iWhjDYAXS5b5k2o3+gfHvPgn37XYDIf8/XZf1Tibe
         SixYCUnZn4urNwJAif4EUR1BVyIZIPtU6U995gazZfOwmglPQtpRluvk/3eLIZ1MPDHB
         2fWlBYZ9UHK717SFCZLomMZqFxzN/u5M4JBysAdndI038DI8lGAyR5/qpOFZJRilzh6u
         a7sk/xxhMwbf9Bm8N1R6g3P6ZuEZOZfjE2G9Q+pN7DXzSQxfBANZYBjWca53GWkrJD9G
         dC8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777507133; x=1778111933;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eJIuZJ281FjkwI23dF39sBMDbu7btsxau6MlBLTWFw8=;
        b=ZMi9MzKoAmk2RT2KCZCjkhARM2rQLKW/pzy2uGFm33ElcIIlzmyU4ooXxg7nc1sBXG
         0A53cdPwJjeEFXDtIBrImJkkYtv+wluxkhFwRQZKfiDlFPwSkCmCEiR2ydiFpFMO/wr6
         hLTyASjW/AbKomZ3h2nqqyvsA+1iaSLgakWt+GeGc4c0n18nDZbgeJg4cEv/Neaddy8P
         FZF7Tw5Uc9PZABFk3B8usXnoA1XWOP8ms2SMjJrsAeWhQzsBarNZIPEoxhxIPSJmIdqB
         DZCqcmWWTIp1L43YbA3hkTnHVnp37sFOuaG/QzAUjNx6aSx0DnCsS/VkkvSTh1HXpkLx
         KeIw==
X-Forwarded-Encrypted: i=1; AFNElJ83WhTJyeHadKD+eDt1u8gN4H54OrvzFGOqYY7Ngcer8LsMfgeO50xsj7nK/gDRivcbnuF8cNU=@lists.linux.dev
X-Gm-Message-State: AOJu0YylyzF3U603NkAgODvP4Xq717ECPi926i6+GnSKm1XkRUdLh7R8
	KXdFktihsUxVHv5qtnFcr2LR3pCh3R/ZqbmwIFNecaQbSetIMP2jXR6txvAiBV03ukI=
X-Gm-Gg: AeBDietVAaX/YijABpytl/JuLdzyF261Mit88kQQHYnD5AccJWNsWUQc+IdPx4+4cSR
	VY+JR0L5B57kv5XsewdA1+c6Y7KTUDqnXy5GirzA4a3yeZtUaawV7Zy1iIZ8wetNzv4EVbEPMgc
	QbadqWXmcQxI+4TpVTxekHv0X4DphSjwS5hJu8fPsh7zxv1rh+aRUdCdIlN0hT3jljME4f43njs
	u8gYXh5nAWB+InH9KGkKBA58hRjCPgbHI8zK+jUJHMEV1eQ2Fe4lMDerjcnvai3TRvopniU7eQH
	WTm1rUV91frlAv3+vuJu5gcbsOQKJ+FxwiVNy0L/HcJX2/qkL+Jw+cnBb9c6GGDSV7vBCXDPYd/
	3+peIPpQDchhLasw1OBE0bjKWBnazaPep83bIai+mEBUgHss0QUFp4JHSPjflzQHLdWsEZN7iSP
	jcwm4xHNEN8Puz7BMB+2KyOuC48jX1kfzYl0xAaKU=
X-Received: by 2002:a05:600c:4e88:b0:485:7f02:afd5 with SMTP id 5b1f17b1804b1-48a84444083mr10834495e9.13.1777507132995;
        Wed, 29 Apr 2026 16:58:52 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([2a00:23c8:67a7:3101::e3b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a81ed6b89sm23797595e9.1.2026.04.29.16.58.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 16:58:52 -0700 (PDT)
Date: Thu, 30 Apr 2026 00:58:50 +0100
From: Gregory Price <gourry@gourry.net>
To: Ira Weiny <iweiny@fastmail.com>
Cc: Dave Jiang <dave.jiang@intel.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, djbw@kernel.org, iweiny@kernel.org,
	pasha.tatashin@soleen.com, mclapinski@google.com, rppt@kernel.org,
	joao.m.martins@oracle.com, jic23@kernel.org, john@groves.net,
	rick.p.edgecombe@intel.com
Subject: Re: [RFC PATCH 00/12] dax: Add DAX to guest memfd support for KVM
Message-ID: <afKbOs68Ft8awizg@gourry-fedora-PF4VCD3F>
References: <20260423170219.281618-1-dave.jiang@intel.com>
 <aerm4yDVYpOhxXEF@gourry-fedora-PF4VCD3F>
 <69f205bc6402_3a7a81004d@xwing.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69f205bc6402_3a7a81004d@xwing.notmuch>

On Wed, Apr 29, 2026 at 08:21:00AM -0500, Ira Weiny wrote:
> Gregory Price wrote:

I think we're largely in agreement here, so trimming a bunch of this.

> > 
> > The question is ultimately how much flexibility you need to shuffle this
> > capacity from one guest to another.
> 
> Yep.  And how much control one needs over which exact CXL/DAX devices the
> memory comes from.  As you know from our community calls that is one thing
> I'm not sure the private node idea is great at.  But it could be that is
> not really required.  Or is best handled as a carve out.
> 

If you can do Device<->Node mappings, then this is trivial.

If you need more specific handling, then private nodes are not the way.

The intent of private nodes is to make mmap()/malloc() etc functional in
a heterogenous memory world, which is explicitly different than "give me
a specific chunk of physical capacity".

Which, tl;dr:  "There's a real argument for just handing guest_memfd a
chunk of unmapped memory and making it deal with the problem".

(shared gmem is... odd... given the original intent not do this :P)

~Gregory
