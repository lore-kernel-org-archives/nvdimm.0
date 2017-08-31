Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4CC3C21EB528F
 for <linux-nvdimm@lists.01.org>; Thu, 31 Aug 2017 03:01:18 -0700 (PDT)
Date: Thu, 31 Aug 2017 12:03:59 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/2] mm: introduce MAP_VALIDATE, a mechanism for for
 safely defining new mmap flags
Message-ID: <20170831100359.GD21443@lst.de>
References: <150413449482.5923.1348069619036923853.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150413450616.5923.7069852068237042023.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <150413450616.5923.7069852068237042023.stgit@dwillia2-desk3.amr.corp.intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: jack@suse.cz, Arnd Bergmann <arnd@arndb.de>, linux-nvdimm@lists.01.org, linux-api@vger.kernel.org, linux-mm@kvack.org, luto@kernel.org, akpm@linux-foundation.org, torvalds@linux-foundation.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

> +/*
> + * The historical set of flags that all mmap implementations implicitly
> + * support when file_operations.mmap_supported_mask is zero. With the
> + * mmap3 syscall the deprecated MAP_DENYWRITE and MAP_EXECUTABLE bit
> + * values are explicitly rejected with EOPNOTSUPP rather than being
> + * silently accepted.
> + */

no mmap3 syscall here :)

Do you also need to update the nommu mmap implementation?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
