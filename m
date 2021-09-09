Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463F93FEE
	for <nvdimm@lists.linux.dev>; Thu,  9 Sep 2021 22:03:56 +0000 (UTC)
Received: by mail-pf1-f179.google.com with SMTP id v123so2976185pfb.11
        for <nvdimm@lists.linux.dev>; Thu, 09 Sep 2021 15:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tUxwV6XCqqMFLWzFgkmAURBDJPUK/ez7E/Hfrb4Mumg=;
        b=evxYXoGg4eg8cWiXuzfXe/L4RVHHKvaWSH0l4/IBgGEeaeS1SGWmzqcM5KM7qEOgci
         gOAF7ndJTA2njgP4/uurVsaxm8HhUAbHfyVJ/YAEjHlJA2tKz2bCt+xUyXk5kHq5vmk2
         IAC3e2/WnSEjckeKLrfCDNPsbenOxtbina4c3SAExPEyJCDMGiZ7QI5ZzMagwRan5DnB
         OK4QKr+u/ofqbNBL9o5eHGdJ8Qd208EYIV11Hh4mFh/0z5dy6DhXGMVjPrKuRa0TMLou
         N0dPiGPcF9gFU/aVHM9k8YsXoWL7o/HJwYEiaIQWtDCEXf/EqDnHaW6gzlQ7D4FKsco9
         e5IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tUxwV6XCqqMFLWzFgkmAURBDJPUK/ez7E/Hfrb4Mumg=;
        b=gu75N9BFYvJB0ZnQJnPwU+QsSLNBCs3vhTtgWZt9uKpr+V6Mq7ceJvIaDxX81N4/K4
         6ZYYkbJezw3WxvBYOoCggNwFkNbqs7T7ShRQ8BFLlXuoPczCpseta1dZpD2kGAIt1Urd
         IN3fE7XQ8RrmuyHFAyW7RYNC+sRNpF6ukxZdonXVH9B79miriHpsOVmOW/iCLdSyi1Su
         O4hmooLbSlgq8tPtIUN9NG2qbcZJZJkG2ZSph7fMYMLge2gN8Vif8TK0g6OexOmkKFR7
         hE1RsKTRGPdFOfPfpteUyswDoUzWuBMAjLTW4O+kE5wpOiKrI3bK1rXjQ/IO/BcxqM/V
         MAKQ==
X-Gm-Message-State: AOAM531mnbBOm48fXxMHopGGvlcBMLKB/s0+lwaGUHLot9hGM4v0WjYV
	M+OTrkLm/+4AFPCmIqiONWDL12t6gzmSVc4xsds/uQ==
X-Google-Smtp-Source: ABdhPJwN4VkDehh5MoaNKQCkMxukEOavBsC4R75tW1GnnbiLuwe6PWvWWw5a5uQ+t10mDLPngeuM4992FD+g/SD/x7g=
X-Received: by 2002:a62:1b92:0:b0:3eb:3f92:724 with SMTP id
 b140-20020a621b92000000b003eb3f920724mr4971964pfb.3.1631225035680; Thu, 09
 Sep 2021 15:03:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <163116429183.2460985.5040982981112374615.stgit@dwillia2-desk3.amr.corp.intel.com>
 <163116437978.2460985.6298243237502084824.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <163116437978.2460985.6298243237502084824.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 9 Sep 2021 15:03:45 -0700
Message-ID: <CAPcyv4ixJZTZF-d0nmsLv2BQ+X9F-Ph_khG4i5pyksNniY_q_A@mail.gmail.com>
Subject: Re: [PATCH v4 16/21] cxl/pmem: Add support for multiple nvdimm-bridge objects
To: linux-cxl@vger.kernel.org
Cc: Ben Widawsky <ben.widawsky@intel.com>, Vishal L Verma <vishal.l.verma@intel.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, "Schofield, Alison" <alison.schofield@intel.com>, 
	"Weiny, Ira" <ira.weiny@intel.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Sep 8, 2021 at 10:13 PM Dan Williams <dan.j.williams@intel.com> wrote:
>
> In preparation for a mocked unit test environment for CXL objects, allow
> for multiple unique nvdimm-bridge objects.
>
> For now, just allow multiple bridges to be registered. Later, when there
> are multiple present, further updates are needed to
> cxl_find_nvdimm_bridge() to identify which bridge is associated with
> which CXL hierarchy for nvdimm registration.
>
> Note that this does change the kernel device-name for the bridge object.
> User space should not have any attachment to the device name at this
> point as it is still early days in the CXL driver development.

Apologies Jonathan, missed your:

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

here...
