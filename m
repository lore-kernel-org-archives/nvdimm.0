Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B07C29D6
	for <nvdimm@lists.linux.dev>; Sat, 26 Jun 2021 01:45:28 +0000 (UTC)
IronPort-SDR: n6ksddgRymTy+wHa02VZaUoXyZpZ3PUa1Ez9ZE9UPEpXNI8dzcHoVqmWIZGTMG+lvurnPW9Qdc
 /4tmLrddcr5w==
X-IronPort-AV: E=McAfee;i="6200,9189,10026"; a="229364350"
X-IronPort-AV: E=Sophos;i="5.83,300,1616482800"; 
   d="scan'208";a="229364350"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2021 18:45:28 -0700
IronPort-SDR: hCKD5S+oPcumuuqRBcYTvaowCF9pFxqjucntnEasGLGhyke1Ztqq/d0bbXb7YScsGWyXjVk4AC
 E7+TDajkpfDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,300,1616482800"; 
   d="scan'208";a="407134588"
Received: from alison-desk.jf.intel.com ([10.54.74.53])
  by orsmga006.jf.intel.com with ESMTP; 25 Jun 2021 18:45:27 -0700
Date: Fri, 25 Jun 2021 18:40:47 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: 13145886936@163.com
Cc: dan.j.williams@intel.com, vishal.l.verma@intel.com,
	dave.jiang@intel.com, ira.weiny@intel.com, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gushengxian <gushengxian@yulong.com>
Subject: Re: [PATCH] tools/testing/nvdimm: Remove NULL test before vfree
Message-ID: <20210626014047.GA15626@alison-desk.jf.intel.com>
References: <20210626012655.515279-1-13145886936@163.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210626012655.515279-1-13145886936@163.com>
User-Agent: Mutt/1.9.4 (2018-02-28)

On Fri, Jun 25, 2021 at 06:26:55PM -0700, 13145886936@163.com wrote:
> From: gushengxian <gushengxian@yulong.com>

Hi,

Thanks for updating the commit message and log.

I think you need to do something about the Signed-off-by or this
will not be accepted.  You can read more about the developer's
certificate of origin in here.
https://www.kernel.org/doc/html/latest/process/submitting-patches.html

Not sure your particular case, but maybe -

If you are submitting this on behalf of Gushengxian, then you need
to add your Signed-off-by after the current one:
ie. Signed-off-by: Your Full Name <13145886936@163.com>

Or, if this is your work, then you may need to update your
.gitconfig file, like this:

[user]
	name = Your Full Name
	email = email@example.com

The From line of the email needs to match a Signed-off-by.

Each time you repost a patch please increment the version number.
The next posting would be [PATCH v3]

Alison

> 
> This NULL test is redundant since vfree() checks for NULL.
> Reported by Coccinelle.
> 
> Signed-off-by: gushengxian <gushengxian@yulong.com>
> ---
>  tools/testing/nvdimm/test/nfit.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
> index 54f367cbadae..cb86f0cbb11c 100644
> --- a/tools/testing/nvdimm/test/nfit.c
> +++ b/tools/testing/nvdimm/test/nfit.c
> @@ -1641,8 +1641,8 @@ static void *__test_alloc(struct nfit_test *t, size_t size, dma_addr_t *dma,
>   err:
>  	if (*dma && size >= DIMM_SIZE)
>  		gen_pool_free(nfit_pool, *dma, size);
> -	if (buf)
> -		vfree(buf);
> +
> +	vfree(buf);
>  	kfree(nfit_res);
>  	return NULL;
>  }
> -- 
> 2.25.1
> 
> 
