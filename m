Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C162FDC55
	for <nvdimm@lists.linux.dev>; Mon,  2 Feb 2026 19:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770059955; cv=none; b=W+FnI5vjsiD0kYg8Yp6bczK7gbjcC3FW2kjltmoAvVDpv431EswHe2hRfjqPTmPg84typl/pQ68dSq7Mc6t1iTnSQJZUrerveTPKO8Gwz4b1NVuKs0RyaAjMKaSIbU+rh3522AGn5uh8+rjo9nEJTvJOPC3V3kjFgOi4vpY6hEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770059955; c=relaxed/simple;
	bh=0x7jvlrx5XFJyx/jKqbZh9Z1RPvxu1cgo/tyO/MM6oY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R15/n+nF7hkcuI9vygesnmCfi4cw4HVE5t6dE6GNhWcOOVA3+XK3IpEJm0Sad1VwxsQwPtfWMl9EYtl/jvr97ee7w3TijO4RbjTbxfG9skwWUIOmLmwSks/9hgSHZ3QkDT1MO4lG6Uq6h1Q/015aLmIi3z2Zv1qqLmDe+iFHKCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=k4LgViV5; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="k4LgViV5"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-88ffcb14e11so66868286d6.0
        for <nvdimm@lists.linux.dev>; Mon, 02 Feb 2026 11:19:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1770059953; x=1770664753; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=asmdN+eKpioswtzM18Womc5lL+dXDrk6p42YTES7X6Y=;
        b=k4LgViV5GsJCqN59HoLqHDEGi2OimGgijZFwx9xFuQa69EVgwvtMCSQWnF7X0PjQ2g
         ZTZVGbHh8K89pRaVY6cg/sdH+mdyVYAqN1LO5P8St4CC/oPzSLiW+wnsdNUlp9sR30bx
         1QQKGCKh8P5Fxdki1er8u7lBIrI4oSpgF+YOqdUFPanaQNemZAh9GnLLm1z90sDUf5gC
         QrONQlQBPbHr4M01zPdkxlOBX5dphMqXfpRqiIEIDOeLuQmK0FD8dWucSY0+gATNDxQK
         54zB23jE5rIo2OSIi6xSgQEOkxmYWkWry2B0tqBPU+thZZK2sOeUP/RC2gsSZ/bqcLeZ
         +/KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770059953; x=1770664753;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=asmdN+eKpioswtzM18Womc5lL+dXDrk6p42YTES7X6Y=;
        b=THpKXA4XWBxjgdF5wUljDDON74NAOwhsbA2iBPiwrMsPL4vUZifupwJtDKcbrp3p8R
         SRAMkc0rjVJYZL5uGYQ7JgwEGlgnN0rM13QxCwZh3PP6XJZaVIHNL5fRZQxAh1vOVcLR
         SruymCSX89guaLdnxIxlklv7x6Qrrmuw5g6m6jVAVEgqLlXO/uNjiFlV4icUZ9JDPPFu
         bU6KMvBjayVsOmqQu+6wrGbBmKKckPZWl4aVh2FrSIFMrSR6L57qLKqbnuFpvLIxgFWQ
         350F/YabtEiBHyAQt1qEFsb7uSOVhplSAluapGHp9vycj8TNcmdFKTujQjoUlMoX+vtk
         KVvQ==
X-Forwarded-Encrypted: i=1; AJvYcCVxyA5gwKgFaEyHu7OANqzjrgItnaTNkfE5h+zcVd+wAkrpkpHSNJi6iZmjUm22WaimsxRTyPM=@lists.linux.dev
X-Gm-Message-State: AOJu0YzNzg9v7UzJA24OXunRzTdijYBAjvQgYqxR1cob8xp7kMoUJr9e
	AKjN//0lBS+ctPV1JkO8DAGeVwT8EXf4Jg8OHJ9rrp5qAwZU0gM9qm6nHYly/kS13Uk=
X-Gm-Gg: AZuq6aKoQuNmTOwqOw8fgCez5pFOgoGXmV8SS81k3HJaqBXW//O/h+FelIY/Nwn/amD
	L99RU91+YV3ao8nAj5g7VqiPuwh/rfGZEq/HhqTCNZu/7DJ8UxlIt83/miMnSfSTTfqlhpiPEcM
	j+tWHArygpl7wfwa7Fzalk/jJFoimeY6x7PfSB/0iH21abdC59EGm0iXYfmFvJeeO3NesTDH1hZ
	1oeFBrhDMVXYk+Iz+XbGFwLp00QeC0Jo8yn5PbDLZq1XB3m4kXuYfz+xjruEWR9QroNx74PrirT
	K8M3mBSGyBcjQ7eDFS7YJL+Wb8BHmyXpO/W9ccxMDvwFeBRtAFegsUnOobpIdXAaEbauB/+L/M4
	8g8+Q+AMqKf5Ja14mI60Ez2S5XvPBRqx1LH4O57NEFkuQ6/fY7LpCCGC/oGcSWjnG8gFoPUNCVR
	FGp3b4P+Cr+4U8y14jUmxbhpqtYC9JE32glG98JFZV9wiLSA8iPL9bpTIGx0ak11HjBblYOQ==
X-Received: by 2002:a05:6214:1311:b0:87d:c7ab:e5d0 with SMTP id 6a1803df08f44-894ea096c06mr178827036d6.55.1770059953093;
        Mon, 02 Feb 2026 11:19:13 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c711d2889asm1253553485a.27.2026.02.02.11.19.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 11:19:12 -0800 (PST)
Date: Mon, 2 Feb 2026 14:19:10 -0500
From: Gregory Price <gourry@gourry.net>
To: "Cheatham, Benjamin" <benjamin.cheatham@amd.com>
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, kernel-team@meta.com, dave@stgolabs.net,
	jonathan.cameron@huawei.com, dave.jiang@intel.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com,
	ira.weiny@intel.com, dan.j.williams@intel.com, willy@infradead.org,
	jack@suse.cz, terry.bowman@amd.com, john@jagalactic.com
Subject: Re: [PATCH 8/9] cxl/core: Add dax_kmem_region and sysram_region
 drivers
Message-ID: <aYD4roMbjyBkK9l5@gourry-fedora-PF4VCD3F>
References: <20260129210442.3951412-1-gourry@gourry.net>
 <20260129210442.3951412-9-gourry@gourry.net>
 <c1d7d137-b7c2-4713-8ca4-33b6bc2bea2b@amd.com>
 <aX0s4i5OqFhHkEUp@gourry-fedora-PF4VCD3F>
 <9652a424-6eb1-462f-8cbd-181af880f98b@amd.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9652a424-6eb1-462f-8cbd-181af880f98b@amd.com>

On Mon, Feb 02, 2026 at 11:02:37AM -0600, Cheatham, Benjamin wrote:
> Sorry if this is a stupid question, but what stops auto regions from binding to the
> sysram/dax region drivers? They all bind to region devices, so I assume there's something
> keeping them from binding before the core region driver gets a chance.
> 

I just grok'd the implications of this question.

I *think* the answer is "probe order" - which is bad.

I need to think about this a bit more and get a more definitive answer.

~Gregory
