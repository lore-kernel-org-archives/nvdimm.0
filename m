Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB574DF4B4
	for <nvdimm@lists.linux.dev>; Fri, 16 Oct 2026 15:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792164516; cv=none; b=o+a1nI8BwFHy23pDOXPHyrhlyLpLmwy0hCxHhgG5DWZK1bbLOCLQxiOJVahPJt41YxCdW7a3HLv+uThBZqViTIYRjFUT8ge9kgbBolnLdBDTV5B36ssKZ1ZNQR1YEiiuFQocDJFZAWJJG1nqLmYY01ivd+2hU1nCmWcOm8zk4qE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792164516; c=relaxed/simple;
	bh=45LS1UdziFdH9/L28pE18LpNfUOLryxMUFQxNA+kup4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TyfRQxkaooM513WMxmgx5kQBZd8yk/6a4fsm/eW5xB+pCOhTwW0GcwseUE4Q2JdXfEzo2YQ63UlOte/hQINW0ngFgiru/bOJDl9CbwiP9LqaCN+B1I946pQx8eUtSEBzTdcPx8cPm18mEzaHl2hcinUZ4SCyCXXxGiKd5Is85zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=m4II8lO2; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="m4II8lO2"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-5352a876d5aso171921cf.1
        for <nvdimm@lists.linux.dev>; Fri, 16 Oct 2026 08:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792164514; x=1792769314; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=P2YR4vuawodUu/XM3aGdAaeSVvyprcEIWQFxlPCqAas=;
        b=m4II8lO2G9o2ufniDyOFkhVJLvpCbN3URn7QxKrV4HTnI+o5jWK3OuA75GNOlz9iQ4
         F6LcgVwAVMjwyBLvAn8o1zhHyPHQJl7ls88YUcmijBRY2xGFsBlpP8ssXIyLwk4ocoDt
         y5LAcWJBot7XEAqfHaed02TfBgshSQ6Jy/M+r6LCs0wzQD88DYsRnpLgIWXMFlxZ6MFh
         hl4pCnbkkaHgkhoS+6iK+CKFF4knFnJPQwaeSiQMUGfLlFfxSlVgagD1Ge/6fkyjkKlj
         orw76TLpIJ4iVP8DTS1044479R3AJv+Gao+wvqpb+Yqy3VMf/2K3f/J4x/XgptGcf/tp
         T8Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792164514; x=1792769314;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=P2YR4vuawodUu/XM3aGdAaeSVvyprcEIWQFxlPCqAas=;
        b=V05gDmR4aFyevnGzLNktPq6oWkTAMXl0fd9TBOaNOIt3LtFKb6Vnmld4U2Vz11c5Oq
         IdM5T07ZM2v10/ROkg1Tybu04cjM93RIw7blTRd/HQsjqijy51zCOt/zydgHt6ZJzuA1
         4WNMEbk9yCsMKCN6cL62J8z3M6hE3yUPHnoAsfcWmoKR7uczNWTCn71cbvRrc35VfHCj
         eNcXyIxMrVzcXYKJHM69YYTimJ5Pqx1abhL+4hvUsXmS2N4qFqM9zGo/q7UeoFvKhOIT
         ffppEnDyMP1PHnaOtzUVA1PMPCkE+jA6jMM1dK83Gf4P1OgC7H0LjGDDhxPiSW/5J12B
         tZsw==
X-Forwarded-Encrypted: i=1; AKwUvBxLP0LXDrbLGijG4V5Q1sNPdsQkYBF7z/f9/caDIz8dwh7k+rH65xdXg0PMupUPbB0uH5CA1i4=@lists.linux.dev
X-Gm-Message-State: AFq9FYLHzUZr4NRWX+bVf7fb7ECmYTWnGqyWV09XaR0CzYkug69gSclb
	m7x7/F2gSlj61kgH3J9MdYLMimX+YWAhcbEJpWh97xguosioFmO+nWeXcNhOVUV2p6s=
X-Gm-Gg: AYBFou3lhgOJYdg7byeYR2owep1pce4oOl7hw7D5w5DAkZ6drIqwlZ7wLkMpd6fWPOs
	iLYMI00Z2jZrDfkQ8Y8qYfYB9kletj97TKsJyhqTEi9BNl4R2k31ARyCEdPlbKZOVadFufoXrIl
	jdivUFYRyVkeQHVaRolo44QVk8GSwgqPh0a8WOLfDT8HynGAEXuRCw8KbN3zuz1tU4ZdtaCLIey
	GWZPz6U5YeCEdmoE+1wPSZcTLupImV0Ehh4JFB+KcUmsik/mA4QBujPpj4VJoG2Nvi88hNq/jc/
	5Ks04C+0cbwy5WrCt0UCh9DqFjd1mYvgmH5xA6AIQyt7tXUbe4YMTm5tfDuEPnUSmf6Q7TWIUWH
	Xu602FPHYzi3+V4nDTyW72TcYv6q+IYmKsvHthTDVeLifLR5FTiCyVIc8lX76QyoZ5MKjj2dyGL
	FTqONEx6lhj8GzYUQckeFPrfFlHv9cYnjW2YTu6ugOyzNRjXwLtOzMHpDSdLZzJWPlvXcfI5qql
	ILdd1f4CJLYWbCJNu+aLMBq0FcmTDbFRk4mxJx2UvG8jWnnOZcaWrU=
X-Received: by 2002:ac8:5ad4:0:b0:534:b7b2:6353 with SMTP id d75a77b69052e-53629a699c9mr49329901cf.56.1792164514309;
        Fri, 16 Oct 2026 08:28:34 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5362aa19fefsm25018821cf.23.2026.10.16.08.28.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 08:28:31 -0700 (PDT)
Date: Fri, 16 Oct 2026 11:28:29 -0400
From: Gregory Price <gourry@gourry.net>
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: fuse-devel@lists.linux.dev, John Groves <John@groves.net>, 
	Amir Goldstein <amir73il@gmail.com>, "Darrick J . Wong" <djwong@kernel.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Subject: Re: [PATCH v5 01/10] dax: add fsdev_dax_from_file()
Message-ID: <atJCherUxpYkRFa7@gourry-fedora-PF4VCD3F>
References: <20261016151638.2962413-1-mszeredi@redhat.com>
 <20261016151638.2962413-2-mszeredi@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016151638.2962413-2-mszeredi@redhat.com>

On Fri, Oct 16, 2026 at 05:16:28PM +0200, Miklos Szeredi wrote:
> From: John Groves <John@Groves.net>
> 
> If the file is a fsdev_dax open, take the dax_dev from the device inode's
> i_cdev.  Return with a reference grabbed on the private dax inode.
> 
> Make dax_dev_get() static again (internal to super.c for alloc_dax), export
> fsdev_dax_from_file() instead.
> 
> This fix is in response to a Sashiko review, and some subsequent analysis.
> 
> About the 'fixes' tag: this removes the export of dax_dev_get(), which was
> flawed, and replaces it with fsdev_dax_from_file(). It feels like the fixes
> tag makes sense for correcting an ABI error.
> 
> Fixes: 2ae624d5a555d ("dax: export dax_dev_get()")
> Originally-by: John Groves <john@groves.net>
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

