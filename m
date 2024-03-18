Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37AAD55C07
	for <nvdimm@lists.linux.dev>; Mon, 18 Mar 2024 17:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710784298; cv=none; b=CdYVk9rz1YqzJYDvVB8ODJcPJGPTFvJnQFco3MamfEyGkDuN7EAoLcQ+DdN8+bQPAbvYsywiZcDgnKQDhsYOOZlWuWP1wLsO+McrfbFfc3Fd8oi3aO7cMrDWJUPquNlux2Xy1sJfgpvppmBboI5Ac5Q8nJ65s8Q5IKiZjpZ9tOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710784298; c=relaxed/simple;
	bh=mz6Hep8+8raXo4mTDv6pPAlc+LtNuOP76p+skgh853M=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jOOg7ONac0qLUe1HMfPDTMEqQ196RXAPsgWjYkjZyytHb5rl1NpIpkMvqGViIkw7yc/5kBH3/fUAmTqFhgRKcM1MXzQFr7zD1MZ2BosChf1eQgzs6d3+uI5uqBbpLsqwBRnr0SIr7xhW11/ch3/7rIzHRfzQIzqkIAU6MDwhMh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DdWCfadO; arc=none smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DdWCfadO"
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-60a0579a968so50139977b3.3
        for <nvdimm@lists.linux.dev>; Mon, 18 Mar 2024 10:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710784296; x=1711389096; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SBHswQV9G02gO2bZl0sGiztK295Y2llrkadXRSbyhFM=;
        b=DdWCfadOqAR0++dCV87OR+vam4VOwMlUFFRDtnHsKCXSLtGBRdpMpnl6HRoyzbITxW
         rM4JUg+TLUA1BKu/DUNee6ZlydEOHIzXccIFr+uYNngGxF4ruPG7mDuT1CpetYUNbdt/
         MYx8KVo+5iPWwzonFjvfFFOQHFu0nuY6UUlJJ4NT12YXsrLU09QbMEt5D85G/zwIBzj+
         6ORZXzAr96tNbGJv4xC94Kw+8NZ56/R6GdZ1HJB6C8/Jm+dW5begqnkUnx4ewbTVbSk4
         RoyMtLa1zfd7pKCw7cKPfhsGej3GxSkMD1PEYeIICXR9z66vxUsTbyPz/SjfLFGdk4j9
         PbHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710784296; x=1711389096;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SBHswQV9G02gO2bZl0sGiztK295Y2llrkadXRSbyhFM=;
        b=tUjgJYHYIeoNI5sREyEnCzU7ALFPlknn0Fq1Jlr0lZviqlHs76qLtnVnhvZJCEPS3h
         pOmGSV0W35Ib2gO/tgRFOj3VgG6zv38T1hPKUF5DbyE83KqZ04UOHUZGCjlLpBpaYiv9
         5bS6Xv+t8gPIL0fAQa3S2QQX4AiIfo9eRvecLsSyxUwKHmAyTCCdGc1B1wNSP1V/JM6r
         zMyW5yl4tUgcTdZHnk93fqn+kJ/0ws9X0kcgWtaOsHIiReO280yAiFC4hDY6hVCCW7w5
         TFKsUea4Uf6wIFUsYfsQjQBWo7b48SqA94Ifsdm9a/fmeSowkmRqmTfTUVGTy+qAUeFt
         bKnA==
X-Forwarded-Encrypted: i=1; AJvYcCX/YOD7PD7YQ3KuZcpmf3CnJ1O98nX9z75+FwS46C/PQOpYDCbqxoQC4YuqVM7ujFx+iDP5DAuLTQZ8GhHNNHqY8KGn5Gwh
X-Gm-Message-State: AOJu0Yzb9sYnq6mKMQVCukKtcbPNMb6TT07kAojaWYen95wm5eJRsinn
	wowOcY+5yg/C1ZG5LFLmw5vF6nLl8Z+gLeGAGtxFTqSn+TDrvnEmv4jolnhs
X-Google-Smtp-Source: AGHT+IGJ+fobtYj0WeLFsICVrm3rv2z20m+ymf6xdVCwH4W2k/7DL4Kfgk7zEHf7N/4bnBOy6+eShg==
X-Received: by 2002:a81:9210:0:b0:609:87d8:4869 with SMTP id j16-20020a819210000000b0060987d84869mr10778350ywg.52.1710784296141;
        Mon, 18 Mar 2024 10:51:36 -0700 (PDT)
Received: from debian ([50.205.20.42])
        by smtp.gmail.com with ESMTPSA id k7-20020a81ac07000000b0060a2afc37bdsm2031311ywh.16.2024.03.18.10.51.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 10:51:35 -0700 (PDT)
From: fan <nifan.cxl@gmail.com>
X-Google-Original-From: fan <fan@debian>
Date: Mon, 18 Mar 2024 10:51:13 -0700
To: alison.schofield@intel.com
Cc: Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>
Subject: Re: [ndctl PATCH v11 1/7] libcxl: add interfaces for GET_POISON_LIST
 mailbox commands
Message-ID: <Zfh_EYPNeRJl8Qio@debian>
References: <cover.1710386468.git.alison.schofield@intel.com>
 <c43e12c5bafca30d3194ebb11d9817b9a05eaad0.1710386468.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c43e12c5bafca30d3194ebb11d9817b9a05eaad0.1710386468.git.alison.schofield@intel.com>

On Wed, Mar 13, 2024 at 09:05:17PM -0700, alison.schofield@intel.com wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> CXL devices maintain a list of locations that are poisoned or result
> in poison if the addresses are accessed by the host.
> 
> Per the spec (CXL 3.1 8.2.9.9.4.1), the device returns the Poison
> List as a set of  Media Error Records that include the source of the
> error, the starting device physical address and length.
> 
> Trigger the retrieval of the poison list by writing to the memory
> device sysfs attribute: trigger_poison_list. The CXL driver only
> offers triggering per memdev, so the trigger by region interface
> offered here is a convenience API that triggers a poison list
> retrieval for each memdev contributing to a region.
> 
> int cxl_memdev_trigger_poison_list(struct cxl_memdev *memdev);
> int cxl_region_trigger_poison_list(struct cxl_region *region);
> 
> The resulting poison records are logged as kernel trace events
> named 'cxl_poison'.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  cxl/lib/libcxl.c   | 47 ++++++++++++++++++++++++++++++++++++++++++++++
>  cxl/lib/libcxl.sym |  2 ++
>  cxl/libcxl.h       |  2 ++
>  3 files changed, 51 insertions(+)
> 
> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> index ff27cdf7c44a..73db8f15c704 100644
> --- a/cxl/lib/libcxl.c
> +++ b/cxl/lib/libcxl.c
> @@ -1761,6 +1761,53 @@ CXL_EXPORT int cxl_memdev_disable_invalidate(struct cxl_memdev *memdev)
>  	return 0;
>  }
>  
> +CXL_EXPORT int cxl_memdev_trigger_poison_list(struct cxl_memdev *memdev)
> +{
> +	struct cxl_ctx *ctx = cxl_memdev_get_ctx(memdev);
> +	char *path = memdev->dev_buf;
> +	int len = memdev->buf_len, rc;
> +
> +	if (snprintf(path, len, "%s/trigger_poison_list",
> +		     memdev->dev_path) >= len) {
> +		err(ctx, "%s: buffer too small\n",
> +		    cxl_memdev_get_devname(memdev));
> +		return -ENXIO;
> +	}
> +	rc = sysfs_write_attr(ctx, path, "1\n");
> +	if (rc < 0) {
> +		fprintf(stderr,
> +			"%s: Failed write sysfs attr trigger_poison_list\n",
> +			cxl_memdev_get_devname(memdev));

Should we use err() instead of fprintf here? 

Fan

> +		return rc;
> +	}
> +	return 0;
> +}
> +
> +CXL_EXPORT int cxl_region_trigger_poison_list(struct cxl_region *region)
> +{
> +	struct cxl_memdev_mapping *mapping;
> +	int rc;
> +
> +	cxl_mapping_foreach(region, mapping) {
> +		struct cxl_decoder *decoder;
> +		struct cxl_memdev *memdev;
> +
> +		decoder = cxl_mapping_get_decoder(mapping);
> +		if (!decoder)
> +			continue;
> +
> +		memdev = cxl_decoder_get_memdev(decoder);
> +		if (!memdev)
> +			continue;
> +
> +		rc = cxl_memdev_trigger_poison_list(memdev);
> +		if (rc)
> +			return rc;
> +	}
> +
> +	return 0;
> +}
> +
>  CXL_EXPORT int cxl_memdev_enable(struct cxl_memdev *memdev)
>  {
>  	struct cxl_ctx *ctx = cxl_memdev_get_ctx(memdev);
> diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
> index de2cd84b2960..3f709c60db3d 100644
> --- a/cxl/lib/libcxl.sym
> +++ b/cxl/lib/libcxl.sym
> @@ -280,4 +280,6 @@ global:
>  	cxl_memdev_get_pmem_qos_class;
>  	cxl_memdev_get_ram_qos_class;
>  	cxl_region_qos_class_mismatch;
> +	cxl_memdev_trigger_poison_list;
> +	cxl_region_trigger_poison_list;
>  } LIBCXL_6;
> diff --git a/cxl/libcxl.h b/cxl/libcxl.h
> index a6af3fb04693..29165043ca3f 100644
> --- a/cxl/libcxl.h
> +++ b/cxl/libcxl.h
> @@ -467,6 +467,8 @@ enum cxl_setpartition_mode {
>  
>  int cxl_cmd_partition_set_mode(struct cxl_cmd *cmd,
>  		enum cxl_setpartition_mode mode);
> +int cxl_memdev_trigger_poison_list(struct cxl_memdev *memdev);
> +int cxl_region_trigger_poison_list(struct cxl_region *region);
>  
>  int cxl_cmd_alert_config_set_life_used_prog_warn_threshold(struct cxl_cmd *cmd,
>  							   int threshold);
> -- 
> 2.37.3
> 
