Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF0C1BCA1E;
	Tue,  1 Oct 2024 07:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727768499; cv=none; b=Q3r9txU6MLvvnvOYcXn+kv6RwLbnj344GdHObIg4Y44z4nqtX0YR/s4b49bGCYKmQ3dZH+h0f1JJjq206wNOrv3aPtaF94JOqLI0XnViwSb9DyMrTVyFeMGgUY/w/YUKHvjdOUYX2ZXIN/3tLQbe75fMPYYcuMYzj2OGKNBexOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727768499; c=relaxed/simple;
	bh=b0YzsZhvYXssxBMzqiFoT5LHPrufg6+4tnZIEdL5YLI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WEgzhYv/BVZdwTOZMQKP6CfZwaKVnJMtmRTmUuOwtkaKzYkxNNU4EFJUGG3Na2PVN/dqXyylmg2Hc3DUm/Xxp1SEXlf6hFjzCE/YUSz548AkmpOeTN5qN7RDTieny//Tr507Ka3ChfXWl66xov5Mupb1DMRU9yvXopeWgVrGbiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mpv8SfC8; arc=none smtp.client-ip=209.85.160.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mpv8SfC8"
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-2870bd5e1f7so1947061fac.3;
        Tue, 01 Oct 2024 00:41:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727768497; x=1728373297; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=oHlEJnCwtC4GK/FLR1DihFu50Li6dMLU4mXd60RMGqA=;
        b=mpv8SfC8BpMh6JmLhl6KBWWzte38Eh98CSlKItlEUO5fzIRSXZEOCOTMyJAzwuECEh
         +NlHqzlirKD6IJVnSc412UGzBL6tc8BACty7zw8DtV8eA81loIP4s9IKoPM3ojy/Ub9C
         LFNCAgKdAIFPRaPoNXzFr1SMlmuEqOry2X5wGkj5SrPA9oyghpxgLfSz7n17a0bISEIz
         /GVLVV7nO/e3k/d+ZJcIsANnkQp25vqwWBz15Xp9lgiba9KgPwQBhvQIsb/NwJICyvvV
         ZfSOWD7hXW9whiAycAmU16lBDROAQtkfX9AzYYjpcBuB+6rtbhkTQ6y4YpA/qmxMoBDc
         CDzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727768497; x=1728373297;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oHlEJnCwtC4GK/FLR1DihFu50Li6dMLU4mXd60RMGqA=;
        b=jmYNOboGaMN96KGpG73ApJZDHBs+JFTbSFmfTflvqaopdukKi0v8wqrU3ZiUkIMqbl
         9yvgLv11wRMpGWDrhZ49+yvZDzgCZOSkka9rYPTDW+3k4WeP/ombysePImoJBhsqd538
         yDKqL9vzJw/FmaukjYVAc+eTYwTPndVFgbDjgHfLzebiGZvKkbVMMtrI+ookcmEZje/Q
         yLyZmwu1yUUHB2mkNbeKpbxsuI/D8BQ9smNV1ZV54Vu2YCN7//dTuhP4nHxVUCgsrkS9
         zK+JClAcgJYJR0Ryeb00yE4qaK1qm38QFdIDC9qZv/YsdJ0RWHepLG3zeKDwV69RKZVu
         vJeg==
X-Forwarded-Encrypted: i=1; AJvYcCW4amciyY5RCW/pWT5LAfkfgr022b4kOUJocqsiz8pLntarqWhKd3uJ11z3uFRDuiArxkLHYRk=@lists.linux.dev, AJvYcCWXHrSRVbo0ZXXyMQNGxJiaFgZUrcV2xcdC2diNkx1lgLYxfX24kJNQ2BFQxr84O5KSWhAai7Nnb7F1iWrg1XE=@lists.linux.dev
X-Gm-Message-State: AOJu0YyA1e9ysa8C9GuiNnVxWZcXUtt86OHhblQ0zSHJqVJxY/9L2wya
	4eV9TpoihWnPPoVEKwj570y0m+FNlWSa7caO/SG/4rCpFRL5TfsqybFqTJ/HPI7dsMSefssOQVw
	MYQX0DdTMaa9IW+gQNJXEEkSqtVA=
X-Google-Smtp-Source: AGHT+IHtULieLwI/4SPEpV2EAh51zgTtQVq2eiZn2mnR0oWpvNiQi5cQqFGqhvDuXz6yt1UnDDzC0f1A/6EcRjj9PQQ=
X-Received: by 2002:a05:6870:3044:b0:27b:55e1:71e2 with SMTP id
 586e51a60fabf-28710ab1b40mr8144762fac.23.1727768496894; Tue, 01 Oct 2024
 00:41:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240926075700.10122-1-shenlichuan@vivo.com>
In-Reply-To: <20240926075700.10122-1-shenlichuan@vivo.com>
From: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date: Tue, 1 Oct 2024 09:41:25 +0200
Message-ID: <CAM9Jb+hCVEN_c1gLd8M0FUH+9i3vdmgCC4B-T7Lsy+XFejMsTw@mail.gmail.com>
Subject: Re: [PATCH v1] nvdimm: Correct some typos in comments
To: Shen Lichuan <shenlichuan@vivo.com>
Cc: dan.j.williams@intel.com, vishal.l.verma@intel.com, dave.jiang@intel.com, 
	ira.weiny@intel.com, nvdimm@lists.linux.dev, virtualization@lists.linux.dev, 
	linux-kernel@vger.kernel.org, opensource.kernel@vivo.com
Content-Type: text/plain; charset="UTF-8"

> Fixed some confusing typos that were currently identified with codespell,
> the details are as follows:
>
> -in the code comments:
> drivers/nvdimm/nd_virtio.c:100: repsonse ==> response
> drivers/nvdimm/pfn_devs.c:542: namepace ==> namespace
> drivers/nvdimm/pmem.c:319: reenable ==> re-enable
>
> Signed-off-by: Shen Lichuan <shenlichuan@vivo.com>

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>

> ---
>  drivers/nvdimm/nd_virtio.c | 2 +-
>  drivers/nvdimm/pfn_devs.c  | 2 +-
>  drivers/nvdimm/pmem.c      | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
> index f55d60922b87..c3f07be4aa22 100644
> --- a/drivers/nvdimm/nd_virtio.c
> +++ b/drivers/nvdimm/nd_virtio.c
> @@ -97,7 +97,7 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
>                 dev_info(&vdev->dev, "failed to send command to virtio pmem device\n");
>                 err = -EIO;
>         } else {
> -               /* A host repsonse results in "host_ack" getting called */
> +               /* A host response results in "host_ack" getting called */
>                 wait_event(req_data->host_acked, req_data->done);
>                 err = le32_to_cpu(req_data->resp.ret);
>         }
> diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
> index 586348125b61..cfdfe0eaa512 100644
> --- a/drivers/nvdimm/pfn_devs.c
> +++ b/drivers/nvdimm/pfn_devs.c
> @@ -539,7 +539,7 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
>
>         if (!nd_pfn->uuid) {
>                 /*
> -                * When probing a namepace via nd_pfn_probe() the uuid
> +                * When probing a namespace via nd_pfn_probe() the uuid
>                  * is NULL (see: nd_pfn_devinit()) we init settings from
>                  * pfn_sb
>                  */
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 210fb77f51ba..d81faa9d89c9 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -316,7 +316,7 @@ static long pmem_dax_direct_access(struct dax_device *dax_dev,
>   * range, filesystem turns the normal pwrite to a dax_recovery_write.
>   *
>   * The recovery write consists of clearing media poison, clearing page
> - * HWPoison bit, reenable page-wide read-write permission, flush the
> + * HWPoison bit, re-enable page-wide read-write permission, flush the
>   * caches and finally write.  A competing pread thread will be held
>   * off during the recovery process since data read back might not be
>   * valid, and this is achieved by clearing the badblock records after
> --
> 2.17.1
>
