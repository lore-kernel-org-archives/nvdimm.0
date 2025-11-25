Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11FFE30DD2E
	for <nvdimm@lists.linux.dev>; Tue, 25 Nov 2025 18:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764097176; cv=none; b=Y5bzxGmk7BMVBPyuxqNm1VV2pM4ryo8/1A6H4xz50rEW6Fb0U9cGe5bLAWHwFgvLEMrTyLfLIa/sr7+TJmwhFnJ8y821x+h5KhXdHZDm5A/hbmVz/9sAinbr4/L6fkuwX1L8FSnzl6644qpLDDNY2e3K18XDtn5l4aTfO8fKCt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764097176; c=relaxed/simple;
	bh=yOFucbp8qhMoIw4wLHpUT/X36VLPm5l//pIaGkCFQlM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aAj6LrxsjkZYWjp3K/HBhpmQaXIWGg3mp8GXwt+ExfA27hQImuahIweOnWFotqdO6WQdTuqLGevpMYIwiypV6/oXjdR8U63lwmTuGgaC/SoEhGZN//OoC49741LeGsozTYvdQcG6Ltggeveyw8LJJ5KAFcmG3bvmDeIN+iIXnl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WMJkn9A7; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WMJkn9A7"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-477a219dbcaso53089095e9.3
        for <nvdimm@lists.linux.dev>; Tue, 25 Nov 2025 10:59:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1764097173; x=1764701973; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jmBPXp4FX8VWv8A/1xzlTIxHcprYvbnP+acWiPY5y1E=;
        b=WMJkn9A79DRjbb3AYYxlJ8k0gI0v8suwA+I9CKo27niH8qRKpi8WZwwOHDQBF08e+v
         HV0PQ/K08nn2R3VKolyo7FXDGqRfuZy30UDq76kxOs+0U7au4iXddi+EMN2QF121mFnX
         8IzAB9f4hcFXAT0c7ZVtE75a0PPyoZ1deIErcHZp74HtcCssmRua3pEkIZzkNQ6QYIVX
         TUY/CKrhYRRjQU64Ze9AgBTxlD+ALkR+0Q7ULl8nUbSDJA8jwd7Hz/aJ+BLKjczJGsCY
         V3sPEJGSfkVBcq3VWXwY3YESR+alCVQtK5XfSmVOUz+sn7BNl11oJWYbVVSMDjmGom10
         oG8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764097173; x=1764701973;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jmBPXp4FX8VWv8A/1xzlTIxHcprYvbnP+acWiPY5y1E=;
        b=bp4oaKRrish7C/Bso5c7Ad+4/zkHWPD5tg8bjh2sAm9/u23fy9B1J9pv+8TPDygSUK
         n+U8DgIQfxdEhd6ZGjiWpQxNXn47siE5QbZLX9h/BjUmIn2NS5WDQArh7KrCI/VlQxdx
         SpmIHWyWcODJY6ryRgxDSyBw6enj7/kRWHOupuE1GiyvnECtLIT7sMbeoyA/OOsqtpaR
         oiTdt+YgnRZxK73Cdr7I7w3J0wy6nkHgcAAKc1Ia8gg8tW43rja/JPFLU+jhQxYSy0kX
         ZUVK/fFhRorhUbTcXhPNMbStJD+OXYhmujGpdgMi6hmXCfg51RY0M6KVgbcvOch+1n5t
         mCTQ==
X-Forwarded-Encrypted: i=1; AJvYcCWgnShHZDv7/q6ZVSSHvSir000Xqzaxg9+RP1gmVaSBbJdpRO+lZlpJouC5k+D/BUcfipiFSRI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy5taNhQDahlGxspBsZEmF/+sNG/HPXapCP7eXXG+GKHX780nSP
	hLM7XhoXqGpccBsfEC9vNjwsCBbvcRNk/PR5lUWRd+s+8KVbRkg58hYKBSeimlp5kaU=
X-Gm-Gg: ASbGncuw3wYnCxtv6Lha1YyoFAb7RDfeRCWbkC9303KAKPPKEVfKjK7pz2HW3rTAq3D
	1GBADdbqCP69w0RvnkHlB61a0Y6ezgBgSVe1rUnZyW37Hp4By2/aLwvAF9DNiaV4cKxKXGKCDD0
	uU+WOjQDBZsx6dCm4dKGt+/N0hcalCWRhUITownEczcNArghEAqXyLnKnqgC7HIxank9+FAHiz9
	NqtU7mCh6dVDUsbdY0gNW7JqJAOx26v//rbglL6ZabuyeEygVEfNrxQX3JUYdrownitXRz5f/uA
	4begIeVEfG1l//HQXZVUqDsdDO7G9dCRBPaalN1Tr1HZGYepAa2fh5FRv9fHcOnB0kKvmK/EMUV
	iz+R+OGWodes7soSoqSx/vQbFjb1l0AAurAfKAZMiox9H0T6MUzCIpE4wD7eyk2KiAyiVvLdm5K
	PYrZyv0IF2t9IfcnrR
X-Google-Smtp-Source: AGHT+IHwbKRr1pvKyNsFNGaFEvgiVnbE4yxn0br2mGaIpqkjm2b1jEyBexkRR5mnkMzoGLfDWc+rGg==
X-Received: by 2002:a05:600c:46cc:b0:477:7b16:5fb1 with SMTP id 5b1f17b1804b1-477c0174856mr167233485e9.7.1764097173292;
        Tue, 25 Nov 2025 10:59:33 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4790add4b46sm4117085e9.4.2025.11.25.10.59.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 10:59:32 -0800 (PST)
Date: Tue, 25 Nov 2025 21:59:29 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Ira Weiny <ira.weiny@intel.com>
Cc: Mike Rapoport <rppt@kernel.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH next] nvdimm: Prevent integer overflow in
 ramdax_get_config_data()
Message-ID: <aSX8kcQT3z-iD94M@stanley.mountain>
References: <aSW0-9cJcTMTynTj@stanley.mountain>
 <6925db85a9343_63977100fd@iweiny-mobl.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6925db85a9343_63977100fd@iweiny-mobl.notmuch>

On Tue, Nov 25, 2025 at 10:38:29AM -0600, Ira Weiny wrote:
> Dan Carpenter wrote:
> > The "cmd->in_offset" variable comes from the user via the __nd_ioctl()
> > function.  The problem is that the "cmd->in_offset + cmd->in_length"
> > addition could have an integer wrapping issue if cmd->in_offset is close
> > to UINT_MAX .  The "cmd->in_length" variable has been capped, but the
> > "cmd->in_offset" variable has not.  Both of these variables are type u32.
> 
> Does ramdax_set_config_data() also need this?

Yes.  It does.  These are from Smatch warnings, right.  They take a few
rebuilds for the taint information to propagate from the ioctl to the
ramdax_get_config_data() function.  When I rebuilt it, then it propagates
to both so I would have seen the ramdax_set_config_data() tomorrow.

But they're called from the same function so the taint data should
have propagated to both at the same time...  WTF?  I don't know what
happened.  Anyway, I will fix that and resend.

Thanks for noticing.

>  I'm not quite following where in_length is capped so I'm inclined to
> add size_add in both set and get.

I meant that the  if (struct_size(cmd, in_buf, cmd->in_length) > buf_len)
line checks that cmd->in_length is okay.

regards,
dan carpenter

