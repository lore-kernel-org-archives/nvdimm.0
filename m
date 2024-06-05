Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D72A2405F8;
	Thu,  6 Jun 2024 05:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717650107; cv=none; b=k6SHiyLmkFF7PyUJ9qQdjw9luZToeFqEL6iM39LJGh50HUR1TOLTZBplrnsiYlHH5TDRgUZizQokdKtjZ11eLf2nE/tKEGwX8kw4Geh3036kfEElmhhf5odkGZvoNa8zjhhCbptbZMwYnhXneRCJvxsAd8KTVvrHRw5yqGVNcMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717650107; c=relaxed/simple;
	bh=MPy2dmqKlCsrw5okIZFwkiGzwVi0bWXg1j0NfWvMFRQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CMZTkv4QYznZrpOeFn66RO6matHFvu1hp0xSHV1JB0SrIQk9fk2xEC3JUd4I1FN+fn5Qu0Mv8S8e9DMoUaEm5eMeQIkVEbU5hOQ0XTblcqcX4QDFsf3/7brO/zczfNbVACAswAIkqgCEzBWTqIL4B8ndCZW/rtaNUnXECA2ULPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Pc3LCuYS; arc=none smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pc3LCuYS"
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-250671a1bc7so217085fac.3;
        Wed, 05 Jun 2024 22:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717650105; x=1718254905; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MPy2dmqKlCsrw5okIZFwkiGzwVi0bWXg1j0NfWvMFRQ=;
        b=Pc3LCuYS6LXMILMcZTdgUXgwzCj/wnYELNTcdElfI8MnzdxMVnu+29zqd8X71y5UGf
         b1dwVPe90t+ZpyeIBu+5PrwpjS70eDVg9+DHexrYEuGYhwqLivPe1EeoOCdxMJn/dnjS
         yXDHFDJufFEOQxlx5m3Nz3X0DK5pYcune/5m1C+wg3qttc+8R5MSsNl8mt5VxD1Eheqm
         6aQ18Mmu/gw9My+HUFAWJxunlpVmIdNaU3d+tMfbW3ZU3glRsCpLCwDXkXEjMzjw+MLR
         pErYXH60MMmFlagrx7sn6tNQA/fa74c3Vv4LBWtG3+kosDZCSU+Czt7cKbW6uUlYcwHX
         DISQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717650105; x=1718254905;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MPy2dmqKlCsrw5okIZFwkiGzwVi0bWXg1j0NfWvMFRQ=;
        b=mt+4Tdb1oIAESA4KXexMF/iYkFXHxkynr4m7134ao6eDbBhPvuuVwnJ05eXHRboaTU
         yFiKsv6MIFf56f7500wRDDVIDtzCUCvM0IHtbfoxq+vJncY9vcW4zW6JN4MRqDHROvlD
         hF/aikEOTxNx3SL6zqhj72s5Lptf2iLiYbDzfR2azRvq+j0djeb8HHOOlJJ0uhxJUhVa
         pD4g6VjQcSWDRxu5+TY8cGh1f/k+/5zKnDpTdDjNeRpw9NfI03uWlQoLAMUJtg4FSea8
         B4DidMV1PE4QTfV+Z1qbHFAbf4Nr3KJ8AV1gnwVYIgn1Z4IbqrPc6agUBWLfSl7QkXgi
         ENqQ==
X-Forwarded-Encrypted: i=1; AJvYcCWB4Ad7ZQq6YEl5gWpm6TQqZfvAonyujehhans2w/CHodV2ycOnJ2z55DcvXndfeeweLBZrSDFaAkaVI6ndyoHSfsJ9V+yjChCbg9NewWqgoUC0VP5Zj5IthnQKuxvxUi0=
X-Gm-Message-State: AOJu0YwYw/olKuSIX94BezQffDEcj4gkt/mkyh629eVFkpZOiTYDjoKU
	dGNzqp6QdfY5mEJ6YJY/ahnQ80yJgCw8HROwfZudxrIKalxkqHBifmftw1VPWunHK+FLq2L4WHM
	JRvKelnSL+DSOSplHk+ZlfvkzdxI=
X-Google-Smtp-Source: AGHT+IG959oSX54MQq8GKfVWKo3o05hRklNZiBoCzbvR+OQgV8iL3zKUSZnj1CdwY90/HxmBqEYVn80Ozx7+RJmP7Ig=
X-Received: by 2002:a05:6870:970d:b0:24e:896f:6a25 with SMTP id
 586e51a60fabf-251220b9deemr5280914fac.58.1717650104968; Wed, 05 Jun 2024
 22:01:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240605063031.3286655-1-hch@lst.de> <20240605063031.3286655-3-hch@lst.de>
In-Reply-To: <20240605063031.3286655-3-hch@lst.de>
From: Kanchan Joshi <joshiiitr@gmail.com>
Date: Thu, 6 Jun 2024 05:01:18 +0530
Message-ID: <CA+1E3rLUA_hnGsXF7p14Hap9jKk1hHDTicYuHMque10QV3GEDQ@mail.gmail.com>
Subject: Re: [PATCH 02/12] block: remove the unused BIP_{CTRL,DISK}_NOCHECK flags
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>, 
	Yu Kuai <yukuai3@huawei.com>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Keith Busch <kbusch@kernel.org>, 
	Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>, linux-block@vger.kernel.org, 
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
