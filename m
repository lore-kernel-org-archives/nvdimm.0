Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1DA5D21A07AB6
 for <linux-nvdimm@lists.01.org>; Mon, 19 Jun 2017 09:33:31 -0700 (PDT)
Date: Mon, 19 Jun 2017 10:34:52 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH] dax: Fix inefficiency in dax_writeback_mapping_range()
Message-ID: <20170619163452.GA27087@linux.intel.com>
References: <20170619124531.21491-1-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170619124531.21491-1-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-nvdimm@lists.01.org, stable@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 19, 2017 at 02:45:31PM +0200, Jan Kara wrote:
> dax_writeback_mapping_range() fails to update iteration index when
> searching radix tree for entries needing cache flushing. Thus each
> pagevec worth of entries is searched starting from the start which is
> inefficient and prone to livelocks. Update index properly.
> 
> CC: stable@vger.kernel.org
> Fixes: 9973c98ecfda3a1dfcab981665b5f1e39bcde64a
> Signed-off-by: Jan Kara <jack@suse.cz>

Yep, this seems good, thanks.

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
