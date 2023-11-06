Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com [209.85.219.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE03DDBB
	for <nvdimm@lists.linux.dev>; Mon,  6 Nov 2023 18:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MAfVAcI+"
Received: by mail-yb1-f176.google.com with SMTP id 3f1490d57ef6-da41e70e334so4196294276.3
        for <nvdimm@lists.linux.dev>; Mon, 06 Nov 2023 10:55:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699296905; x=1699901705; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vhLzSo2ZdsS1cNYMQVnH8qp5KlM4qInxdfA0/jF4QCI=;
        b=MAfVAcI+7LGAM9gH9Y+0DVyJKvSQFr/lvCRkVqhhhealG6f2Jq7kK1jGXsnyCt2Ndz
         G1sGg/WnKtSUNEwfoHvy3ZYsePnVVXoXSMRE9l4FUYRS3vodlRgdnx/jHo2Em+9hllzL
         bGrej+45dMSSQ2D6L7Bog9COHYfWT4awkSkLxUL6mlP8yBrFosOeTfdyrY9UZw6XI5mo
         jOVeOJw82c4oD2CuakBZmlfcN/WzF9bUAsgYJX2d6heZeyPcgyjujftncnIgqQ0NXF7D
         SNCpl2wqaK0OapiGrWOCMbJvJiB2haqmrOVTWDOLQYi2SCti3t5esnJLxX+8vkBxTyw5
         /ixA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699296905; x=1699901705;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vhLzSo2ZdsS1cNYMQVnH8qp5KlM4qInxdfA0/jF4QCI=;
        b=VZ1pxECPaHvDrOsXb5zNFu2aGv57/sUA69b1LpHrYg2nTQ5WdreUiive/SotcyFE0p
         1PYHBWrVJLPEHxrgc/OourO4pezN70bbLWvjnvwAXZdr/9h2JYw9JB058xGRKUdPMbyp
         EjTGSmc88V5Fmw5gyW/S0M8c5aO0vKzAddfYvRK3jSISZW2mAIam8UdoMR4DIVaCTDIn
         dZqKb3PmV11ceVIjlcyoDaAsqpEgAKDQZeyRtqzBFzBxS+7PJY0V+gXz5SIesm8Zujpq
         TsNrtMOeupVmRVU7Js9u/vPpaHMwMlMLqEYnNJc6HdUqTVPRhRjCv58hhjx9ZgWC/j4k
         CEYg==
X-Gm-Message-State: AOJu0YxHTxsBHFOkimJjP8tg9YP4d8vOQ3Ab9kKXuHLqBSUEUTgjTPKS
	l12uy8ROadw1B400xT5Qyeo=
X-Google-Smtp-Source: AGHT+IEJ7Z/Zl9Si6wi3vI6C5MCyjuEizvr3x7s3+sIED3gUWfaO8DNl9Kxv0Pys3EFaVusnV304EA==
X-Received: by 2002:a5b:d49:0:b0:d9a:6301:c82b with SMTP id f9-20020a5b0d49000000b00d9a6301c82bmr31039102ybr.13.1699296905021;
        Mon, 06 Nov 2023 10:55:05 -0800 (PST)
Received: from debian ([50.205.20.42])
        by smtp.gmail.com with ESMTPSA id w142-20020a25c794000000b00da0c49a588asm4300672ybe.8.2023.11.06.10.55.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Nov 2023 10:55:04 -0800 (PST)
From: fan <nifan.cxl@gmail.com>
X-Google-Original-From: fan <fan@debian>
Date: Mon, 6 Nov 2023 10:54:38 -0800
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Oscar Salvador <osalvador@suse.de>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org, Huang Ying <ying.huang@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v9 1/3] mm/memory_hotplug: replace an open-coded
 kmemdup() in add_memory_resource()
Message-ID: <ZUk2bqoi6YrgMyyO@debian>
References: <20231102-vv-kmem_memmap-v9-0-973d6b3a8f1a@intel.com>
 <20231102-vv-kmem_memmap-v9-1-973d6b3a8f1a@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231102-vv-kmem_memmap-v9-1-973d6b3a8f1a@intel.com>

On Thu, Nov 02, 2023 at 12:27:13PM -0600, Vishal Verma wrote:
> A review of the memmap_on_memory modifications to add_memory_resource()
> revealed an instance of an open-coded kmemdup(). Replace it with
> kmemdup().
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Reported-by: Dan Williams <dan.j.williams@intel.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---

Reviewed-by: Fan Ni <fan.ni@samsung.com>

>  mm/memory_hotplug.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index f8d3e7427e32..6be7de9efa55 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1439,11 +1439,11 @@ int __ref add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
>  	if (mhp_flags & MHP_MEMMAP_ON_MEMORY) {
>  		if (mhp_supports_memmap_on_memory(size)) {
>  			mhp_altmap.free = memory_block_memmap_on_memory_pages();
> -			params.altmap = kmalloc(sizeof(struct vmem_altmap), GFP_KERNEL);
> +			params.altmap = kmemdup(&mhp_altmap,
> +						sizeof(struct vmem_altmap),
> +						GFP_KERNEL);
>  			if (!params.altmap)
>  				goto error;
> -
> -			memcpy(params.altmap, &mhp_altmap, sizeof(mhp_altmap));
>  		}
>  		/* fallback to not using altmap  */
>  	}
> 
> -- 
> 2.41.0
> 
