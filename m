Received: from tartarus.angband.pl (tartarus.angband.pl [51.83.246.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4831B2C81
	for <nvdimm@lists.linux.dev>; Thu, 21 Oct 2021 13:42:41 +0000 (UTC)
Received: from kilobyte by tartarus.angband.pl with local (Exim 4.94.2)
	(envelope-from <kilobyte@angband.pl>)
	id 1mdYIr-005EKC-4x; Thu, 21 Oct 2021 15:40:17 +0200
Date: Thu, 21 Oct 2021 15:40:17 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Jens Axboe <axboe@kernel.dk>, Yi Zhang <yi.zhang@redhat.com>,
	linux-block@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH 2/2] memremap: remove support for external pgmap refcounts
Message-ID: <YXFtwcAC0WyxIWIC@angband.pl>
References: <20211019073641.2323410-1-hch@lst.de>
 <20211019073641.2323410-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211019073641.2323410-3-hch@lst.de>
X-Junkbait: aaron@angband.pl, zzyx@angband.pl
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: kilobyte@angband.pl
X-SA-Exim-Scanned: No (on tartarus.angband.pl); SAEximRunCond expanded to false

On Tue, Oct 19, 2021 at 09:36:41AM +0200, Christoph Hellwig wrote:
> No driver is left using the external pgmap refcount, so remove the
> code to support it.

> --- a/include/linux/memremap.h
> +++ b/include/linux/memremap.h
> @@ -109,8 +98,7 @@ struct dev_pagemap_ops {
>   */
>  struct dev_pagemap {
>  	struct vmem_altmap altmap;
> -	struct percpu_ref *ref;
> -	struct percpu_ref internal_ref;
> +	struct percpu_ref ref;
>  	struct completion done;
>  	enum memory_type type;
>  	unsigned int flags;

This breaks at least drivers/pci/p2pdma.c:222


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀
⣾⠁⢠⠒⠀⣿⡁
⢿⡄⠘⠷⠚⠋⠀ Certified airhead; got the CT scan to prove that!
⠈⠳⣄⠀⠀⠀⠀
