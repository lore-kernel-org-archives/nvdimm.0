Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68AC0A2C
	for <nvdimm@lists.linux.dev>; Mon, 14 Feb 2022 17:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644861546; x=1676397546;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=XU044oh5pka0fxROuzgo8HhltCN2bfo2cOcsKP44lsc=;
  b=UFob9vU5aqHOzv70A8oMeFPtMCJLnc5JtWNm7TB/1o3BY0qhqz/ADW4F
   zThb+8Wtg3O2kng/3C4VgKYMDitaSVylpSvTneRUo9adpS1n8lLIg+PE+
   W60dPw3uLgtYeP5+ssp/BoTdPFQSKv9KUfj3c+RWTUqpLEH9xrwN0o3Nw
   OWVE17shDRRFheTWVmYFzfz5iHkCMnIYl3MRVQhDAL5d+3ucHXAL+v3qK
   YKmFeRE6R3gArkMA9UpZqh7VtCT3g4cXjnPVrBKWxqL1bgQqp0a21J3aB
   zXr5EZq+olDOt3Orx7mrTDkVN6d3fr+6xIyojjFwN/tEvLfPrKaQ+AeGD
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10258"; a="237558574"
X-IronPort-AV: E=Sophos;i="5.88,368,1635231600"; 
   d="scan'208";a="237558574"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2022 09:59:06 -0800
X-IronPort-AV: E=Sophos;i="5.88,368,1635231600"; 
   d="scan'208";a="703210078"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2022 09:59:05 -0800
Date: Mon, 14 Feb 2022 09:59:05 -0800
From: Ira Weiny <ira.weiny@intel.com>
To: Tong Zhang <ztong0001@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dax: make sure inodes are flushed before destroy cache
Message-ID: <20220214175905.GV785175@iweiny-DESK2.sc.intel.com>
Mail-Followup-To: Tong Zhang <ztong0001@gmail.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
References: <20220212071111.148575-1-ztong0001@gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220212071111.148575-1-ztong0001@gmail.com>
User-Agent: Mutt/1.11.1 (2018-12-01)

On Fri, Feb 11, 2022 at 11:11:11PM -0800, Tong Zhang wrote:
> A bug can be triggered by following command
> 
> $ modprobe nd_pmem && modprobe -r nd_pmem
> 
> [   10.060014] BUG dax_cache (Not tainted): Objects remaining in dax_cache on __kmem_cache_shutdown()
> [   10.060938] Slab 0x0000000085b729ac objects=9 used=1 fp=0x000000004f5ae469 flags=0x200000000010200(slab|head|node)
> [   10.062433] Call Trace:
> [   10.062673]  dump_stack_lvl+0x34/0x44
> [   10.062865]  slab_err+0x90/0xd0
> [   10.063619]  __kmem_cache_shutdown+0x13b/0x2f0
> [   10.063848]  kmem_cache_destroy+0x4a/0x110
> [   10.064058]  __x64_sys_delete_module+0x265/0x300
> 
> This is caused by dax_fs_exit() not flushing inodes before destroy cache.
> To fix this issue, call rcu_barrier() before destroy cache.

I don't doubt that this fixes the bug.  However, I can't help but think this is
hiding a bug, or perhaps a missing step, in the kmem_cache layer?  As far as I
can see dax does not call call_rcu() and only uses srcu not rcu?  I was tempted
to suggest srcu_barrier() but dax does not call call_srcu() either.

So I'm not clear about what is really going on and why this fixes it.  I know
that dax is not using srcu is a standard way so perhaps this helps in a way I
don't quite grok?  If so perhaps a comment here would be in order?

Ira

> 
> Signed-off-by: Tong Zhang <ztong0001@gmail.com>
> ---
>  drivers/dax/super.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index e3029389d809..6bd565fe2e63 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -476,6 +476,7 @@ static int dax_fs_init(void)
>  static void dax_fs_exit(void)
>  {
>  	kern_unmount(dax_mnt);
> +	rcu_barrier();
>  	kmem_cache_destroy(dax_cache);
>  }
>  
> -- 
> 2.25.1
> 
> 
