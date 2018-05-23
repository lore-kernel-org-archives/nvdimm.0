Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7172E207E4DF6
 for <linux-nvdimm@lists.01.org>; Wed, 23 May 2018 09:13:20 -0700 (PDT)
Date: Wed, 23 May 2018 10:13:19 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v3 6/9] dax: introduce a ->copy_to_iter dax operation
Message-ID: <20180523161319.GA29519@linux.intel.com>
References: <152539236455.31796.7516599166555186700.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152539239729.31796.4765429575408958580.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <152539239729.31796.4765429575408958580.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: tony.luck@intel.com, Mike Snitzer <snitzer@redhat.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 03, 2018 at 05:06:37PM -0700, Dan Williams wrote:
> Similar to the ->copy_from_iter() operation, a platform may want to
> deploy an architecture or device specific routine for handling reads
> from a dax_device like /dev/pmemX. On x86 this routine will point to a
> machine check safe version of copy_to_iter(). For now, add the plumbing
> to device-mapper and the dax core.
> 
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Looks good to me.

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
