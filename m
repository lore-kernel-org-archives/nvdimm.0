Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC072918
	for <nvdimm@lists.linux.dev>; Fri, 14 Apr 2023 15:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681485758; x=1713021758;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=B0jHdxZzYwrgZFCx/7w9FS8F32WExkZ7+uG6frX+Lvc=;
  b=XVy80j2m1BwhFXcAU8pTTZY1UrWD1LJMOLFzmgmz+YBE8eOtoj1VHQRZ
   zHIJ3i+fWqM1r9OSS4VMah7c3vLacilTsoUOntdTzPNc38fa1sUznHtRn
   WWQBDljI9BzLlfOonCFKF3zudbkAuxbhHgnrYPvWsq5nVQsUetswnjKcR
   P+/gi47w9W4Ew59FF/31Hsd+W5D9WCGy6q/pDg2Lribpna7e3e9t28B/y
   f19UDBZwHWFn9Un+dTL8aBAo74IR1dya/oLZYIvuOMkodGcmMhueWj1KF
   moGqsksQzEToSyPfLRJKvlCCHAQeQYJ2d/hirtED8TgzpdSMkaars8a4R
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="324116535"
X-IronPort-AV: E=Sophos;i="5.99,197,1677571200"; 
   d="scan'208";a="324116535"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2023 08:22:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="667220419"
X-IronPort-AV: E=Sophos;i="5.99,197,1677571200"; 
   d="scan'208";a="667220419"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.212.243.67])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2023 08:22:36 -0700
Date: Fri, 14 Apr 2023 08:22:34 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Markus Elfring <Markus.Elfring@web.de>
Cc: kernel-janitors@vger.kernel.org, nvdimm@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Vishal Verma <vishal.l.verma@intel.com>, cocci@inria.fr,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] nvdimm: Replace the usage of a variable by a direct
 function call in nd_pfn_validate()
Message-ID: <ZDlvunCNe9yWykIE@aschofie-mobl2>
References: <40c60719-4bfe-b1a4-ead7-724b84637f55@web.de>
 <1a11455f-ab57-dce0-1677-6beb8492a257@web.de>
 <d2403b7a-c6cd-4ee9-2a35-86ea57554eec@web.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d2403b7a-c6cd-4ee9-2a35-86ea57554eec@web.de>

On Fri, Apr 14, 2023 at 12:12:37PM +0200, Markus Elfring wrote:
> Date: Fri, 14 Apr 2023 12:01:15 +0200
> 
> The address of a data structure member was determined before
> a corresponding null pointer check in the implementation of
> the function “nd_pfn_validate”.
> 
> Thus avoid the risk for undefined behaviour by replacing the usage of
> the local variable “parent_uuid” by a direct function call within
> a later condition check.

Hi Markus,

I think I understand what you are saying above, but I don't follow
how that applies here. This change seems to be a nice simplification,
parent_uuid, is used once, just grab it when needed.

What is the risk of undefined behavior?

> 
> This issue was detected by using the Coccinelle software.
Which cocci script?

> 
> Fixes: d1c6e08e7503649e4a4f3f9e700e2c05300b6379 ("libnvdimm/labels: Add uuid helpers")

This fixes tag seems to be the wrong tag. It is a tag from when the
uuid helpers were introduce, not where parent_uuid was first introduced
and used. I'm not clear this warrants a Fixes tag anyway. Is there
really a bug here? Perhaps I'm missing something in the previous
explanation of risk.

checkpatch is WARNING on the tag format:
WARNING: Please use correct Fixes: style 'Fixes: <12 chars of sha1> ("<title line>")' - ie: 'Fixes: d1c6e08e7503 ("libnvdimm/labels: Add uuid helpers")'
#17:
    Fixes: d1c6e08e7503649e4a4f3f9e700e2c05300b6379 ("libnvdimm/labels: Add uuid helpers")

checkpatch is also WARNING on the commit msg:
WARNING: Possible unwrapped commit description (prefer a maximum 75 chars per line)
#5:
    nvdimm: Replace the usage of a variable by a direct function call in nd_pfn_validate()

Also, possible only my pet peeve, the long commit message spoils my
pretty 80 column view. Please trim it to not wrap here:

$git log --oneline pfn_devs.c
52b639e56a46 nvdimm: Replace the usage of a variable by a direct function call in nd_pfn_validate()
c91d71363084 nvdimm: Support sizeof(struct page) > MAX_STRUCT_PAGE_SIZE
6e9f05dc66f9 libnvdimm/pfn_dev: increase MAX_STRUCT_PAGE_SIZE
81beea55cb74 nvdimm: Drop nd_device_lock()
4a0079bc7aae nvdimm: Replace lockdep_mutex with local lock classes
322cbb50de71 block: remove genhd.h

Alison


> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/nvdimm/pfn_devs.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
> index af7d9301520c..f14cbfa500ed 100644
> --- a/drivers/nvdimm/pfn_devs.c
> +++ b/drivers/nvdimm/pfn_devs.c
> @@ -456,7 +456,6 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
>  	unsigned long align, start_pad;
>  	struct nd_pfn_sb *pfn_sb = nd_pfn->pfn_sb;
>  	struct nd_namespace_common *ndns = nd_pfn->ndns;
> -	const uuid_t *parent_uuid = nd_dev_to_uuid(&ndns->dev);
> 
>  	if (!pfn_sb || !ndns)
>  		return -ENODEV;
> @@ -476,7 +475,7 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
>  		return -ENODEV;
>  	pfn_sb->checksum = cpu_to_le64(checksum);
> 
> -	if (memcmp(pfn_sb->parent_uuid, parent_uuid, 16) != 0)
> +	if (memcmp(pfn_sb->parent_uuid, nd_dev_to_uuid(&ndns->dev), 16) != 0)
>  		return -ENODEV;
> 
>  	if (__le16_to_cpu(pfn_sb->version_minor) < 1) {
> --
> 2.40.0
> 
