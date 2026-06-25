Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48AD119ADA4
	for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 09:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782378442; cv=none; b=S8z9VpjjG56mxkfNbmCMv+nGoPDlK6xsXHzW0Gt7QhjLOmmGXXhzvFDwZv9QTeJhtsX0ep6wdPNV6oGzxYTUVoulGeVmIwxp4yRs3JW70X1u1BpsfhhEWo46t+GgEWVYJPfzD+5WMv0kqLfMFwsb+xBVCio7M1wzjIlGolgaj00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782378442; c=relaxed/simple;
	bh=/Bz3//frR7PzFv+V/Is7JQZUdgG0lfqLZcHeUftIcVI=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QAUlQ6wwtZtJmU0EVFI59QrpQYBJtTxzt10s4N/qxFgAFjGLmL7M6G51dezlvvwam9BoqlQHZPWM2qbUKpbSKMzrRJot/PW77/ZlNS19t94ZnrZejtvMdsJBKqXswJ1MF4HJz6e9X+ksgkSWwAG6DLW77ik6KQ4EWhLGV1qlcRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HiI4RV3R; arc=none smtp.client-ip=74.125.82.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HiI4RV3R"
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-1390f75d8bbso4790642c88.0
        for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 02:07:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782378434; x=1782983234; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uh7d155bzMOSDs17477DXsdTjJFjvRv+PsFNr/CxwV0=;
        b=HiI4RV3RHErmlCxov6XP60R39Sh5IXm6KDfmny4MTBfa4tpIP3Fljg7PWZx9y8JKZN
         UXtlD5bCYHg8XcINSdODp3wP7Icq3mQxou3rAK7rzzZoqTLQaprXIESXo+qDRnNcAP/J
         hxxH3HkpQ3+JV03V3DGmp0T4UWm3aXtdIUhskB8UOTfDZadCMocHTrcevc2ykFNkWuNU
         J5tVK0hQQUs2/PwvP++t/ZllyIVWCF3k0ZDleXaydT59AlOdFurk9Gk5QWW/LsGfWLiJ
         NXSQg/1G/0ByvkvTs31sgSuFFEJtKBlg8tGtoVRF2PlQ23NBMyp0r6Y7xZW4v5EqONcb
         wxnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782378434; x=1782983234;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uh7d155bzMOSDs17477DXsdTjJFjvRv+PsFNr/CxwV0=;
        b=K2TnPDJYMT8fJb96cl1PPkncNWBf3hJUFMkH2jVIZ0f+A+qmXrbxF16rxfS4c7hBrt
         gaSvOzSfo4E1pct1kVzoIsH2gFZvbWxy9eQnQeQY7EjKavbYH0JIecpVu2aQ7rjX6z5i
         OORyaPKp3d5/PkoaPA84hcQSzfs+LzwPKDvYnBtZjEnHv67g+3l5YDJTQ+zzE7vuKUaS
         CbM+f8rQD69p5o8NE9TUnuUmP0Rk2Q0c/qn8X6dxed0LbFCFZvgSahHcYEr2OScC2lvX
         fH0lbWyVc+Q3Isf3/SCuT0vmbiSHdG37lFPWUXp3hj1fewTYEnGD9M8c27xDw++7qlzN
         658A==
X-Forwarded-Encrypted: i=1; AFNElJ9ppirxpyKY8GZpcXJ7ofdwD9Ttmf+Bas7HMx6QpN9T+sHWWwAXB2aIolyNyermgxxRr40IjEk=@lists.linux.dev
X-Gm-Message-State: AOJu0YzsFQPlMrH3iBvu8F5KLNT3nroXmjvYr48U0WzKKiZwl8BiRcgV
	tMcxKrXbFUXJTzwsbYTkyKFAEEfL7j4MCB6g7lv9Xo6xTG/XYBBmKpZJ
X-Gm-Gg: AfdE7cmxcz+qDNUZ028OrkjLPiReecojM32SGnhRsllvXe4ey/Zm8WNKhG+StKZOd/R
	WtceQ5daby12BM0lB+xLRyPLRKGchM0aF9+TlIVMcx1ZhgIWLVcP2iQVKkoj43hWQ9vX7lYQDVO
	nhw5C5jAHdPngzTJu79JHtRVQ+oau5b4kdCokyrS7FtyjMElVPkNIJxA2KnVf1OYBiRtQ3nDJ/0
	VkOtTNjvDKDJFhm1z5J0hJgJuK3idqEHj8CLxBdRJo8UzWEW5PoDdA5oexFtG8Z+7bgOVcS5sY0
	UUnjlU9Y4oN1nbRpBqn7GjTrA7U6iCrZ273t9aADWCZj1VxDVUPHhVhtGtey5chGlHALTUq5uop
	XKofLkPwdhaGctzzoxXEYmCt66NBKR6QIbpLQA1g5W3KMg4kqUXoQkOviNvYobMvoqkRGT5GpoG
	VFuXa+pqaWFXY99qQxhvy9YTFX9um/cvPS6atdXI7uCEnjt6tKEvAZPztGDCFxz9hKDyUv
X-Received: by 2002:a05:7022:619:b0:139:8674:e45b with SMTP id a92af1059eb24-139dbaf24a5mr1883935c88.14.1782378434168;
        Thu, 25 Jun 2026 02:07:14 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-139d912197bsm10031291c88.15.2026.06.25.02.07.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 02:07:13 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
Date: Thu, 25 Jun 2026 02:07:12 -0700
To: Dave Jiang <dave.jiang@intel.com>
Cc: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
	Dan Williams <djbw@kernel.org>, Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>, Ira Weiny <iweiny@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <John@groves.net>, Gregory Price <gourry@gourry.net>,
	Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH v6 2/7] libcxl: Add Dynamic RAM A partition mode support
Message-ID: <ajzvwEXGxfMQNhSt@AnisaLaptop.localdomain>
References: <20260523095043.471098-1-anisa.su@samsung.com>
 <20260523095043.471098-3-anisa.su@samsung.com>
 <06747633-ed22-48a2-b8d0-c9b544a682f8@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06747633-ed22-48a2-b8d0-c9b544a682f8@intel.com>

On Mon, Jun 08, 2026 at 04:19:47PM -0700, Dave Jiang wrote:
> 
> 
> On 5/23/26 2:50 AM, Anisa Su wrote:
> > From: Ira Weiny <ira.weiny@intel.com>
> > 
> > Dynamic capacity partitions are exposed as a singular dynamic ram
> > partition.
> > 
> > Add CXL library support to read this partition information.
> > 
> > Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> 
> Missing Anisa sign off.
> 
> Can probably squash this and the next commit so the usage is shown for the reviewer.
> 
Added my signoff. Also squashed next commit. I added your review tag to the
combined commit since it was on the next commit.

Richard's point about moving new exported symbols to LIBCXL_13 is also
applied.

> DJ

Thanks,
Anisa
> 
> > ---
> >  Documentation/cxl/lib/libcxl.txt |  6 +++--
> >  cxl/lib/libcxl.c                 | 43 ++++++++++++++++++++++++++++++++
> >  cxl/lib/libcxl.sym               |  4 +++
> >  cxl/lib/private.h                |  3 +++
> >  cxl/libcxl.h                     | 10 +++++++-
> >  5 files changed, 63 insertions(+), 3 deletions(-)
> > 
> > diff --git a/Documentation/cxl/lib/libcxl.txt b/Documentation/cxl/lib/libcxl.txt
> > index 5c3ebd4..9921ac1 100644
> > --- a/Documentation/cxl/lib/libcxl.txt
> > +++ b/Documentation/cxl/lib/libcxl.txt
> > @@ -74,6 +74,7 @@ int cxl_memdev_get_major(struct cxl_memdev *memdev);
> >  int cxl_memdev_get_minor(struct cxl_memdev *memdev);
> >  unsigned long long cxl_memdev_get_pmem_size(struct cxl_memdev *memdev);
> >  unsigned long long cxl_memdev_get_ram_size(struct cxl_memdev *memdev);
> > +unsigned long long cxl_memdev_get_dynamic_ram_a_size(struct cxl_memdev *memdev);
> >  const char *cxl_memdev_get_firmware_version(struct cxl_memdev *memdev);
> >  size_t cxl_memdev_get_label_size(struct cxl_memdev *memdev);
> >  int cxl_memdev_nvdimm_bridge_active(struct cxl_memdev *memdev);
> > @@ -93,8 +94,8 @@ The character device node for command submission can be found by default
> >  at /dev/cxl/mem%d, or created with a major / minor returned from
> >  cxl_memdev_get_{major,minor}().
> >  
> > -The 'pmem_size' and 'ram_size' attributes return the current
> > -provisioning of DPA (Device Physical Address / local capacity) in the
> > +The 'pmem_size', 'ram_size', and 'dynamic_ram_a_size' attributes return the
> > +current provisioning of DPA (Device Physical Address / local capacity) in the
> >  device.
> >  
> >  cxl_memdev_get_numa_node() returns the affinitized CPU node number if
> > @@ -453,6 +454,7 @@ enum cxl_decoder_mode {
> >  	CXL_DECODER_MODE_MIXED,
> >  	CXL_DECODER_MODE_PMEM,
> >  	CXL_DECODER_MODE_RAM,
> > +	CXL_DECODER_MODE_DYNAMIC_RAM_A,
> >  };
> >  enum cxl_decoder_mode cxl_decoder_get_mode(struct cxl_decoder *decoder);
> >  int cxl_decoder_set_mode(struct cxl_decoder *decoder, enum cxl_decoder_mode mode);
> > diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> > index e55a7b4..be0bc03 100644
> > --- a/cxl/lib/libcxl.c
> > +++ b/cxl/lib/libcxl.c
> > @@ -501,6 +501,9 @@ CXL_EXPORT bool cxl_region_qos_class_mismatch(struct cxl_region *region)
> >  		} else if (region->mode == CXL_DECODER_MODE_PMEM) {
> >  			if (root_decoder->qos_class != memdev->pmem_qos_class)
> >  				return true;
> > +		} else if (region->mode == CXL_DECODER_MODE_DYNAMIC_RAM_A) {
> > +			if (root_decoder->qos_class != memdev->dynamic_ram_a_qos_class)
> > +				return true;
> >  		}
> >  	}
> >  
> > @@ -1426,6 +1429,10 @@ static void *add_cxl_memdev(void *parent, int id, const char *cxlmem_base)
> >  	if (sysfs_read_attr(ctx, path, buf) == 0)
> >  		memdev->ram_size = strtoull(buf, NULL, 0);
> >  
> > +	sprintf(path, "%s/dynamic_ram_a/size", cxlmem_base);
> > +	if (sysfs_read_attr(ctx, path, buf) == 0)
> > +		memdev->dynamic_ram_a_size = strtoull(buf, NULL, 0);
> > +
> >  	sprintf(path, "%s/pmem/qos_class", cxlmem_base);
> >  	if (sysfs_read_attr(ctx, path, buf) < 0)
> >  		memdev->pmem_qos_class = CXL_QOS_CLASS_NONE;
> > @@ -1438,6 +1445,12 @@ static void *add_cxl_memdev(void *parent, int id, const char *cxlmem_base)
> >  	else
> >  		memdev->ram_qos_class = atoi(buf);
> >  
> > +	sprintf(path, "%s/dynamic_ram_a/qos_class", cxlmem_base);
> > +	if (sysfs_read_attr(ctx, path, buf) < 0)
> > +		memdev->dynamic_ram_a_qos_class = CXL_QOS_CLASS_NONE;
> > +	else
> > +		memdev->dynamic_ram_a_qos_class = atoi(buf);
> > +
> >  	sprintf(path, "%s/payload_max", cxlmem_base);
> >  	if (sysfs_read_attr(ctx, path, buf) == 0) {
> >  		memdev->payload_max = strtoull(buf, NULL, 0);
> > @@ -1685,6 +1698,11 @@ CXL_EXPORT unsigned long long cxl_memdev_get_ram_size(struct cxl_memdev *memdev)
> >  	return memdev->ram_size;
> >  }
> >  
> > +CXL_EXPORT unsigned long long cxl_memdev_get_dynamic_ram_a_size(struct cxl_memdev *memdev)
> > +{
> > +	return memdev->dynamic_ram_a_size;
> > +}
> > +
> >  CXL_EXPORT int cxl_memdev_get_pmem_qos_class(struct cxl_memdev *memdev)
> >  {
> >  	return memdev->pmem_qos_class;
> > @@ -1695,6 +1713,11 @@ CXL_EXPORT int cxl_memdev_get_ram_qos_class(struct cxl_memdev *memdev)
> >  	return memdev->ram_qos_class;
> >  }
> >  
> > +CXL_EXPORT int cxl_memdev_get_dynamic_ram_a_qos_class(struct cxl_memdev *memdev)
> > +{
> > +	return memdev->dynamic_ram_a_qos_class;
> > +}
> > +
> >  CXL_EXPORT const char *cxl_memdev_get_firmware_verison(struct cxl_memdev *memdev)
> >  {
> >  	return memdev->firmware_version;
> > @@ -2465,6 +2488,8 @@ static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
> >  			decoder->mode = CXL_DECODER_MODE_MIXED;
> >  		else if (strcmp(buf, "none") == 0)
> >  			decoder->mode = CXL_DECODER_MODE_NONE;
> > +		else if (strcmp(buf, "dynamic_ram_a") == 0)
> > +			decoder->mode = CXL_DECODER_MODE_DYNAMIC_RAM_A;
> >  		else
> >  			decoder->mode = CXL_DECODER_MODE_MIXED;
> >  	} else
> > @@ -2504,6 +2529,7 @@ static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
> >  	case CXL_PORT_SWITCH:
> >  		decoder->pmem_capable = true;
> >  		decoder->volatile_capable = true;
> > +		decoder->dynamic_ram_a_capable = true;
> >  		decoder->mem_capable = true;
> >  		decoder->accelmem_capable = true;
> >  		sprintf(path, "%s/locked", cxldecoder_base);
> > @@ -2528,6 +2554,7 @@ static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
> >  			{ "cap_type3", &decoder->mem_capable },
> >  			{ "cap_ram", &decoder->volatile_capable },
> >  			{ "cap_pmem", &decoder->pmem_capable },
> > +			{ "cap_dynamic_ram_a", &decoder->dynamic_ram_a_capable },
> >  			{ "locked", &decoder->locked },
> >  		};
> >  
> > @@ -2778,6 +2805,9 @@ CXL_EXPORT int cxl_decoder_set_mode(struct cxl_decoder *decoder,
> >  	case CXL_DECODER_MODE_RAM:
> >  		sprintf(buf, "ram");
> >  		break;
> > +	case CXL_DECODER_MODE_DYNAMIC_RAM_A:
> > +		sprintf(buf, "dynamic_ram_a");
> > +		break;
> >  	default:
> >  		err(ctx, "%s: unsupported mode: %d\n",
> >  		    cxl_decoder_get_devname(decoder), mode);
> > @@ -2829,6 +2859,11 @@ CXL_EXPORT bool cxl_decoder_is_volatile_capable(struct cxl_decoder *decoder)
> >  	return decoder->volatile_capable;
> >  }
> >  
> > +CXL_EXPORT bool cxl_decoder_is_dynamic_ram_a_capable(struct cxl_decoder *decoder)
> > +{
> > +	return decoder->dynamic_ram_a_capable;
> > +}
> > +
> >  CXL_EXPORT bool cxl_decoder_is_mem_capable(struct cxl_decoder *decoder)
> >  {
> >  	return decoder->mem_capable;
> > @@ -2903,6 +2938,8 @@ static struct cxl_region *cxl_decoder_create_region(struct cxl_decoder *decoder,
> >  		sprintf(path, "%s/create_pmem_region", decoder->dev_path);
> >  	else if (mode == CXL_DECODER_MODE_RAM)
> >  		sprintf(path, "%s/create_ram_region", decoder->dev_path);
> > +	else if (mode == CXL_DECODER_MODE_DYNAMIC_RAM_A)
> > +		sprintf(path, "%s/create_dynamic_ram_a_region", decoder->dev_path);
> >  
> >  	rc = sysfs_read_attr(ctx, path, buf);
> >  	if (rc < 0) {
> > @@ -2954,6 +2991,12 @@ cxl_decoder_create_ram_region(struct cxl_decoder *decoder)
> >  	return cxl_decoder_create_region(decoder, CXL_DECODER_MODE_RAM);
> >  }
> >  
> > +CXL_EXPORT struct cxl_region *
> > +cxl_decoder_create_dynamic_ram_a_region(struct cxl_decoder *decoder)
> > +{
> > +	return cxl_decoder_create_region(decoder, CXL_DECODER_MODE_DYNAMIC_RAM_A);
> > +}
> > +
> >  CXL_EXPORT int cxl_decoder_get_nr_targets(struct cxl_decoder *decoder)
> >  {
> >  	return decoder->nr_targets;
> > diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
> > index ed4429f..258bdd3 100644
> > --- a/cxl/lib/libcxl.sym
> > +++ b/cxl/lib/libcxl.sym
> > @@ -294,6 +294,10 @@ global:
> >  	cxl_memdev_get_fwctl;
> >  	cxl_fwctl_get_major;
> >  	cxl_fwctl_get_minor;
> > +	cxl_memdev_get_dynamic_ram_a_size;
> > +	cxl_memdev_get_dynamic_ram_a_qos_class;
> > +	cxl_decoder_is_dynamic_ram_a_capable;
> > +	cxl_decoder_create_dynamic_ram_a_region;
> >  } LIBECXL_8;
> >  
> >  LIBCXL_10 {
> > diff --git a/cxl/lib/private.h b/cxl/lib/private.h
> > index d2d71fc..37b7b06 100644
> > --- a/cxl/lib/private.h
> > +++ b/cxl/lib/private.h
> > @@ -52,8 +52,10 @@ struct cxl_memdev {
> >  	struct list_node list;
> >  	unsigned long long pmem_size;
> >  	unsigned long long ram_size;
> > +	unsigned long long dynamic_ram_a_size;
> >  	int ram_qos_class;
> >  	int pmem_qos_class;
> > +	int dynamic_ram_a_qos_class;
> >  	int payload_max;
> >  	size_t lsa_size;
> >  	struct kmod_module *module;
> > @@ -159,6 +161,7 @@ struct cxl_decoder {
> >  	unsigned int interleave_granularity;
> >  	bool pmem_capable;
> >  	bool volatile_capable;
> > +	bool dynamic_ram_a_capable;
> >  	bool mem_capable;
> >  	bool accelmem_capable;
> >  	bool locked;
> > diff --git a/cxl/libcxl.h b/cxl/libcxl.h
> > index e91af90..fd41122 100644
> > --- a/cxl/libcxl.h
> > +++ b/cxl/libcxl.h
> > @@ -75,8 +75,10 @@ struct cxl_fwctl *cxl_memdev_get_fwctl(struct cxl_memdev *memdev);
> >  struct cxl_ctx *cxl_memdev_get_ctx(struct cxl_memdev *memdev);
> >  unsigned long long cxl_memdev_get_pmem_size(struct cxl_memdev *memdev);
> >  unsigned long long cxl_memdev_get_ram_size(struct cxl_memdev *memdev);
> > +unsigned long long cxl_memdev_get_dynamic_ram_a_size(struct cxl_memdev *memdev);
> >  int cxl_memdev_get_pmem_qos_class(struct cxl_memdev *memdev);
> >  int cxl_memdev_get_ram_qos_class(struct cxl_memdev *memdev);
> > +int cxl_memdev_get_dynamic_ram_a_qos_class(struct cxl_memdev *memdev);
> >  const char *cxl_memdev_get_firmware_verison(struct cxl_memdev *memdev);
> >  bool cxl_memdev_fw_update_in_progress(struct cxl_memdev *memdev);
> >  size_t cxl_memdev_fw_update_get_remaining(struct cxl_memdev *memdev);
> > @@ -210,6 +212,7 @@ enum cxl_decoder_mode {
> >  	CXL_DECODER_MODE_MIXED,
> >  	CXL_DECODER_MODE_PMEM,
> >  	CXL_DECODER_MODE_RAM,
> > +	CXL_DECODER_MODE_DYNAMIC_RAM_A,
> >  };
> >  
> >  static inline const char *cxl_decoder_mode_name(enum cxl_decoder_mode mode)
> > @@ -219,9 +222,10 @@ static inline const char *cxl_decoder_mode_name(enum cxl_decoder_mode mode)
> >  		[CXL_DECODER_MODE_MIXED] = "mixed",
> >  		[CXL_DECODER_MODE_PMEM] = "pmem",
> >  		[CXL_DECODER_MODE_RAM] = "ram",
> > +		[CXL_DECODER_MODE_DYNAMIC_RAM_A] = "dynamic_ram_a",
> >  	};
> >  
> > -	if (mode < CXL_DECODER_MODE_NONE || mode > CXL_DECODER_MODE_RAM)
> > +	if (mode < CXL_DECODER_MODE_NONE || mode > CXL_DECODER_MODE_DYNAMIC_RAM_A)
> >  		mode = CXL_DECODER_MODE_NONE;
> >  	return names[mode];
> >  }
> > @@ -235,6 +239,8 @@ cxl_decoder_mode_from_ident(const char *ident)
> >  		return CXL_DECODER_MODE_RAM;
> >  	else if (strcmp(ident, "pmem") == 0)
> >  		return CXL_DECODER_MODE_PMEM;
> > +	else if (strcmp(ident, "dynamic_ram_a") == 0)
> > +		return CXL_DECODER_MODE_DYNAMIC_RAM_A;
> >  	return CXL_DECODER_MODE_NONE;
> >  }
> >  
> > @@ -264,6 +270,7 @@ cxl_decoder_get_target_type(struct cxl_decoder *decoder);
> >  bool cxl_decoder_is_pmem_capable(struct cxl_decoder *decoder);
> >  bool cxl_decoder_is_volatile_capable(struct cxl_decoder *decoder);
> >  bool cxl_decoder_is_mem_capable(struct cxl_decoder *decoder);
> > +bool cxl_decoder_is_dynamic_ram_a_capable(struct cxl_decoder *decoder);
> >  bool cxl_decoder_is_accelmem_capable(struct cxl_decoder *decoder);
> >  bool cxl_decoder_is_locked(struct cxl_decoder *decoder);
> >  unsigned int
> > @@ -272,6 +279,7 @@ unsigned int cxl_decoder_get_interleave_ways(struct cxl_decoder *decoder);
> >  struct cxl_region *cxl_decoder_get_region(struct cxl_decoder *decoder);
> >  struct cxl_region *cxl_decoder_create_pmem_region(struct cxl_decoder *decoder);
> >  struct cxl_region *cxl_decoder_create_ram_region(struct cxl_decoder *decoder);
> > +struct cxl_region *cxl_decoder_create_dynamic_ram_a_region(struct cxl_decoder *decoder);
> >  struct cxl_decoder *cxl_decoder_get_by_name(struct cxl_ctx *ctx,
> >  					    const char *ident);
> >  struct cxl_memdev *cxl_decoder_get_memdev(struct cxl_decoder *decoder);
> 
