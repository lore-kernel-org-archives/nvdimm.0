Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732F61DA4B
	for <nvdimm@lists.linux.dev>; Mon, 20 Nov 2023 15:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="FBLwWpu0"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-32f7abbb8b4so3024178f8f.0
        for <nvdimm@lists.linux.dev>; Mon, 20 Nov 2023 07:49:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1700495378; x=1701100178; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RAd0IIHuX/2oY04pHCXnq50Epg7Nd+f5sCggYZ6Tygg=;
        b=FBLwWpu0ifRSCw2UJpfil9U67lEEKfarMsKCSsGx9NwT0+FjMGp6mlgzMTwFHzgAhD
         j77y1FIOUZDxlbmP3sFnF8ha5rUqMVYNf6e85H7qMC2Gk9TJJ6i3hu3nk++nrtYbm4bY
         z4ztDZ8EhJY66sp6stBp3V6X5MSJpHJdB7J1Hqxadk48/4c1LIZJfs6Zcmss9DnOWcnQ
         C8CX6tV6kafjW7wU/F/Any6CBYVGOpboeGRMVeOxMMf9luusqbSODbQqDdMzxhEEFD7z
         Bbna/7NHqOz+dKvEpZTRJ82YXneV6IdUzEjEFSd1gBZ6AebOkULFd8Ns/5r2BMZvM5ST
         Y14A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700495378; x=1701100178;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RAd0IIHuX/2oY04pHCXnq50Epg7Nd+f5sCggYZ6Tygg=;
        b=CAGY59p2QbcSj9DLSiocFOQNjc9U6pR6AKopGmjM8IvlKpc8y26w0xw2Ba+T0BDkBh
         oKy6q2/QV5rf6HiHdVIc7gYi24h1c0QQJFfQtEfCWlnKa5J1Olbzg3nITo1CVvHV5Srw
         924S24mjIyVFMU4m7TkIjc68uJTa14Mac0xcqmFIguGtSiJqBMAgc4N3PZPFKQamc2yf
         UkdnHS3NaPwMpqoVl40AWHAo5YyOzxPgL7zTyDKjqXLiailLMfJU+/RT1St0rjmXHErn
         SDQS69KqxpoTvTRh6pZXYPAxiwF3RsNIXF8ERZbjPdt8kVIZLW3hzaGhyO/BJ+yQbkvt
         CqwQ==
X-Gm-Message-State: AOJu0Yx9j5odwWye9pxoFBfjd6PKNz4Lfcl1+ZduXScpBEu8Gxg60H/U
	QM/x3SW/BoncIZVKyfgTmi799Q==
X-Google-Smtp-Source: AGHT+IHlO3QPA9EVMaR+I4w/XoQOoZjMhwzYrFEC54gTJQMZUT+IHnpjrYufkdZU9KSfgUpw3DnpuA==
X-Received: by 2002:a5d:44c4:0:b0:331:834b:61e5 with SMTP id z4-20020a5d44c4000000b00331834b61e5mr3087359wrr.42.1700495378505;
        Mon, 20 Nov 2023 07:49:38 -0800 (PST)
Received: from ?IPV6:2a02:6b6a:b5c7:0:237f:509f:1c65:1d08? ([2a02:6b6a:b5c7:0:237f:509f:1c65:1d08])
        by smtp.gmail.com with ESMTPSA id s5-20020adfdb05000000b0032d8eecf901sm11756403wri.3.2023.11.20.07.49.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Nov 2023 07:49:37 -0800 (PST)
Message-ID: <a0d67f2d-f66b-8873-7c11-31d90aae8e8c@bytedance.com>
Date: Mon, 20 Nov 2023 15:49:36 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: Conditions for FOLL_LONGTERM mapping in fsdax
Content-Language: en-US
From: Usama Arif <usama.arif@bytedance.com>
To: dan.j.williams@intel.com, vishal.l.verma@intel.com, dave.jiang@intel.com,
 nvdimm@lists.linux.dev
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 Fam Zheng <fam.zheng@bytedance.com>,
 "liangma@liangbit.com" <liangma@liangbit.com>
References: <172ab047-0dc7-1704-5f30-ec7cd3632e09@bytedance.com>
 <454dbfa1-2120-1e40-2582-d661203decca@bytedance.com>
In-Reply-To: <454dbfa1-2120-1e40-2582-d661203decca@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 06/11/2023 18:15, Usama Arif wrote:
> Hi,
> 
> We wanted to run a VM with a vfio device assigned to it and with its 
> memory-backend-file residing in a persistent memory using fsdax (mounted 
> as ext4). It doesnt currently work with the kernel as 
> vfio_pin_pages_remote ends up requesting pages with FOLL_LONGTERM which 
> is currently not supported. From reading the mailing list, what I 
> understood was that this is to do with not having DMA supported on fsdax 
> due to issues that come up during truncate/hole-punching. But it was 
> solved with [1] by deferring fallocate(), truncate() on a dax mode file 
> while any page/block in the file is under active DMA.
> 
> If I remove the check which fails the gup opertion with the below diff, 
> the VM boots and the vfio device works without any issues. If I try to 
> truncate the mem file in fsdax, I can see that the truncate command gets 
> deferred (waits in ext4_break_layouts) and the vfio device keeps working 
> and sending packets without any issues. Just wanted to check what is 
> missing to allow FOLL_LONGTERM gup operations with fsdax? Is it just 
> enough to remove the check? Thanks!
> 
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index eb8d7baf9e4d..f77bb428cf9b 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -1055,9 +1055,6 @@ static int check_vma_flags(struct vm_area_struct 
> *vma, unsigned long gup_flags)
>          if (gup_flags & FOLL_ANON && !vma_is_anonymous(vma))
>                  return -EFAULT;
> 
> -       if ((gup_flags & FOLL_LONGTERM) && vma_is_fsdax(vma))
> -               return -EOPNOTSUPP;
> -
>          if (vma_is_secretmem(vma))
>                  return -EFAULT;
> 
> 
> [1] 
> https://lore.kernel.org/all/152669371377.34337.10697370528066177062.stgit@dwillia2-desk3.amr.corp.intel.com/
> 

Hi,

Just wanted to check if there were any comments on this?

Thanks


> Regards,
> Usama
