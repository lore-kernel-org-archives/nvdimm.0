Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9AC5E210DA795
 for <linux-nvdimm@lists.01.org>; Thu,  7 Jun 2018 08:50:05 -0700 (PDT)
Date: Thu, 7 Jun 2018 17:50:03 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3 04/12] device-dax: Set page->index
Message-ID: <20180607155003.dwndud2xsnpqpcxl@quack2.suse.cz>
References: <152815389835.39010.13253559944508110923.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152815392126.39010.6403368422475215562.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <152815392126.39010.6403368422475215562.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, jack@suse.cz, hch@lst.de, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon 04-06-18 16:12:01, Dan Williams wrote:
> In support of enabling memory_failure() handling for device-dax
> mappings, set ->index to the pgoff of the page. The rmap implementation
> requires ->index to bound the search through the vma interval tree.
> 
> The ->index value is never cleared. There is no possibility for the
> page to become associated with another pgoff while the device is
> enabled. When the device is disabled the 'struct page' array for the
> device is destroyed and ->index is reinitialized to zero.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
