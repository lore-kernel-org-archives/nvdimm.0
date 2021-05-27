Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BAE62FB1
	for <nvdimm@lists.linux.dev>; Thu, 27 May 2021 05:26:00 +0000 (UTC)
Received: by mail-pl1-f178.google.com with SMTP id d20so1751359pls.13
        for <nvdimm@lists.linux.dev>; Wed, 26 May 2021 22:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fossix-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=h1bnschrsOMczPEZLNoLiji8A8+gJ/BheAClc6Aa/2E=;
        b=zmzZ/I2NzsAhjQKQsBa9IaJGNOZRIyK9mJNJvWZuqC7YX7woyjaYm69xDyAV9bQ88t
         CB7mS2jcQ1kY8i8AIDQwsMjldlJolJY5bhsdWXDREYmAkJ0HWTbKsajJN+vHlS4TUe1R
         yew0sVs8VAhJ/XrJzZh6QxxUa7YT3PPbK+VqM5YLmHXxrAIAcz0Znwv3rMn9c/mSVkfx
         mO0WiYtCeFWxYkUKsix6h+AWOFAvX7HR2cswcXhZ9hYs0hrxxZXVUloPbsAMCN25pqFl
         pK1qGvAcXW5+uJEhFiYs5xDPk6yFVEAH8pYcV4VrTlSzfXXdRHj9Sf1NXO/zPf8PgwXn
         XGHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=h1bnschrsOMczPEZLNoLiji8A8+gJ/BheAClc6Aa/2E=;
        b=LAY6mL0UYoPsUWptsveBQRnQzGftINDTOZLvPk9acSL4tuSSvXWwIT586tHDiIPbxi
         jri1jZh+qkz+P/7swAx85ckMp0Ei+xgV1CFEaxJAaVRHAJN4WXWW5iVwL+chG234FoXc
         YEwTmuas997wnGnzpklSoNMHts320n4DA0DL/wJT0aX7yb678iY5aC6DmP06x6zUzlos
         oBfbaoBcMse+wce4TToulnk5QL55TBv3NqP2ffPz3Tg0yujaRIWvGTpuLzk/3RpMJw3C
         HFClpMimxA6AlsFoQhcvNHCOcYa4ye7B1rKqN4BLJw9S6/75hJknBDvs8AWnqNBuKJ1z
         Dp4A==
X-Gm-Message-State: AOAM532JCpra4XJqXlkDCT2Mah0hBWkcT+xppVSgBKCWh2Zt0QB97nY/
	AmTSrZY1eHh+FpkPIzFrhNxgwg==
X-Google-Smtp-Source: ABdhPJyypRKzSzRDtGSJP25gItufSU6hNc20UmMMxRApHmdn7kT8DY8/vyYWbjsbrqdNmzGWEIFWeA==
X-Received: by 2002:a17:902:b412:b029:ef:1737:ed with SMTP id x18-20020a170902b412b02900ef173700edmr1804911plr.43.1622093159885;
        Wed, 26 May 2021 22:25:59 -0700 (PDT)
Received: from localhost ([103.21.79.4])
        by smtp.gmail.com with ESMTPSA id v9sm787947pfn.22.2021.05.26.22.25.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 22:25:59 -0700 (PDT)
From: Santosh Sivaraj <santosh@fossix.org>
To: Vaibhav Jain <vaibhav@linux.ibm.com>, nvdimm@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>, Dan Williams
 <dan.j.williams@intel.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Ira
 Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH] powerpc/papr_scm: Add support for reporting
 dirty-shutdown-count
In-Reply-To: <20210521111023.413732-1-vaibhav@linux.ibm.com>
References: <20210521111023.413732-1-vaibhav@linux.ibm.com>
Date: Thu, 27 May 2021 10:55:54 +0530
Message-ID: <87im34hhnh.fsf@fossix.org>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain


Hi Vaibhav,

Vaibhav Jain <vaibhav@linux.ibm.com> writes:

> Persistent memory devices like NVDIMMs can loose cached writes in case
> something prevents flush on power-fail. Such situations are termed as
> dirty shutdown and are exposed to applications as
> last-shutdown-state (LSS) flag and a dirty-shutdown-counter(DSC) as
> described at [1]. The latter being useful in conditions where multiple
> applications want to detect a dirty shutdown event without racing with
> one another.
>
> PAPR-NVDIMMs have so far only exposed LSS style flags to indicate a
> dirty-shutdown-state. This patch further adds support for DSC via the
> "ibm,persistence-failed-count" device tree property of an NVDIMM. This
> property is a monotonic increasing 64-bit counter thats an indication
> of number of times an NVDIMM has encountered a dirty-shutdown event
> causing persistence loss.
>
> Since this value is not expected to change after system-boot hence
> papr_scm reads & caches its value during NVDIMM probe and exposes it
> as a PAPR sysfs attributed named 'dirty_shutdown' to match the name of
> similarly named NFIT sysfs attribute. Also this value is available to
> libnvdimm via PAPR_PDSM_HEALTH payload. 'struct nd_papr_pdsm_health'
> has been extended to add a new member called 'dimm_dsc' presence of
> which is indicated by the newly introduced PDSM_DIMM_DSC_VALID flag.
>
> References:
> [1] https://pmem.io/documents/Dirty_Shutdown_Handling-V1.0.pdf
>
> Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
> ---
>  arch/powerpc/include/uapi/asm/papr_pdsm.h |  6 +++++
>  arch/powerpc/platforms/pseries/papr_scm.c | 30 +++++++++++++++++++++++
>  2 files changed, 36 insertions(+)
>
> diff --git a/arch/powerpc/include/uapi/asm/papr_pdsm.h b/arch/powerpc/include/uapi/asm/papr_pdsm.h
> index 50ef95e2f5b1..82488b1e7276 100644
> --- a/arch/powerpc/include/uapi/asm/papr_pdsm.h
> +++ b/arch/powerpc/include/uapi/asm/papr_pdsm.h
> @@ -77,6 +77,9 @@
>  /* Indicate that the 'dimm_fuel_gauge' field is valid */
>  #define PDSM_DIMM_HEALTH_RUN_GAUGE_VALID 1
>  
> +/* Indicate that the 'dimm_dsc' field is valid */
> +#define PDSM_DIMM_DSC_VALID 2
> +
>  /*
>   * Struct exchanged between kernel & ndctl in for PAPR_PDSM_HEALTH
>   * Various flags indicate the health status of the dimm.
> @@ -105,6 +108,9 @@ struct nd_papr_pdsm_health {
>  
>  			/* Extension flag PDSM_DIMM_HEALTH_RUN_GAUGE_VALID */
>  			__u16 dimm_fuel_gauge;
> +
> +			/* Extension flag PDSM_DIMM_DSC_VALID */
> +			__u64 dimm_dsc;
>  		};
>  		__u8 buf[ND_PDSM_PAYLOAD_MAX_SIZE];
>  	};
> diff --git a/arch/powerpc/platforms/pseries/papr_scm.c b/arch/powerpc/platforms/pseries/papr_scm.c
> index 11e7b90a3360..68f0d3d5e899 100644
> --- a/arch/powerpc/platforms/pseries/papr_scm.c
> +++ b/arch/powerpc/platforms/pseries/papr_scm.c
> @@ -114,6 +114,9 @@ struct papr_scm_priv {
>  	/* Health information for the dimm */
>  	u64 health_bitmap;
>  
> +	/* Holds the last known dirty shutdown counter value */
> +	u64 dirty_shutdown_counter;
> +
>  	/* length of the stat buffer as expected by phyp */
>  	size_t stat_buffer_len;
>  };
> @@ -603,6 +606,16 @@ static int papr_pdsm_fuel_gauge(struct papr_scm_priv *p,
>  	return rc;
>  }
>  
> +/* Add the dirty-shutdown-counter value to the pdsm */
> +static int papr_psdm_dsc(struct papr_scm_priv *p,
                   ^^^^ should be pdsm
> +			 union nd_pdsm_payload *payload)
> +{
> +	payload->health.extension_flags |= PDSM_DIMM_DSC_VALID;
> +	payload->health.dimm_dsc = p->dirty_shutdown_counter;
> +
> +	return sizeof(struct nd_papr_pdsm_health);
> +}
> +
>  /* Fetch the DIMM health info and populate it in provided package. */
>  static int papr_pdsm_health(struct papr_scm_priv *p,
>  			    union nd_pdsm_payload *payload)
> @@ -646,6 +659,8 @@ static int papr_pdsm_health(struct papr_scm_priv *p,
>  
>  	/* Populate the fuel gauge meter in the payload */
>  	papr_pdsm_fuel_gauge(p, payload);
> +	/* Populate the dirty-shutdown-counter field */
> +	papr_psdm_dsc(p, payload);
             ^^^^ same typo

Thanks,
Santosh

>  
>  	rc = sizeof(struct nd_papr_pdsm_health);
>  
> @@ -907,6 +922,16 @@ static ssize_t flags_show(struct device *dev,
>  }
>  DEVICE_ATTR_RO(flags);
>  
> +static ssize_t dirty_shutdown_show(struct device *dev,
> +			  struct device_attribute *attr, char *buf)
> +{
> +	struct nvdimm *dimm = to_nvdimm(dev);
> +	struct papr_scm_priv *p = nvdimm_provider_data(dimm);
> +
> +	return sysfs_emit(buf, "%llu\n", p->dirty_shutdown_counter);
> +}
> +DEVICE_ATTR_RO(dirty_shutdown);
> +
>  static umode_t papr_nd_attribute_visible(struct kobject *kobj,
>  					 struct attribute *attr, int n)
>  {
> @@ -925,6 +950,7 @@ static umode_t papr_nd_attribute_visible(struct kobject *kobj,
>  static struct attribute *papr_nd_attributes[] = {
>  	&dev_attr_flags.attr,
>  	&dev_attr_perf_stats.attr,
> +	&dev_attr_dirty_shutdown.attr,
>  	NULL,
>  };
>  
> @@ -1149,6 +1175,10 @@ static int papr_scm_probe(struct platform_device *pdev)
>  	p->is_volatile = !of_property_read_bool(dn, "ibm,cache-flush-required");
>  	p->hcall_flush_required = of_property_read_bool(dn, "ibm,hcall-flush-required");
>  
> +	if (of_property_read_u64(dn, "ibm,persistence-failed-count",
> +				 &p->dirty_shutdown_counter))
> +		p->dirty_shutdown_counter = 0;
> +
>  	/* We just need to ensure that set cookies are unique across */
>  	uuid_parse(uuid_str, (uuid_t *) uuid);
>  	/*
> -- 
> 2.31.1
