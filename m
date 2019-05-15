Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8976621276777
 for <linux-nvdimm@lists.01.org>; Wed, 15 May 2019 01:38:07 -0700 (PDT)
Date: Wed, 15 May 2019 04:38:06 -0400 (EDT)
From: Pankaj Gupta <pagupta@redhat.com>
Message-ID: <34965939.28870107.1557909486195.JavaMail.zimbra@redhat.com>
In-Reply-To: <155789172402.748145.11853718580748830476.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <155789172402.748145.11853718580748830476.stgit@dwillia2-desk3.amr.corp.intel.com>
Subject: Re: [PATCH] dax: Arrange for dax_supported check to span multiple
 devices
MIME-Version: 1.0
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
Cc: Jan Kara <jack@suse.cz>, snitzer@redhat.com, linux-nvdimm@lists.01.org, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, Matthew Wilcox <willy@infradead.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>
List-ID: <linux-nvdimm@lists.01.org>



> 
> Pankaj reports that starting with commit ad428cdb525a "dax: Check the
> end of the block-device capacity with dax_direct_access()" device-mapper
> no longer allows dax operation. This results from the stricter checks in
> __bdev_dax_supported() that validate that the start and end of a
> block-device map to the same 'pagemap' instance.
> 
> Teach the dax-core and device-mapper to validate the 'pagemap' on a
> per-target basis. This is accomplished by refactoring the
> bdev_dax_supported() internals into generic_fsdax_supported() which
> takes a sector range to validate. Consequently generic_fsdax_supported()
> is suitable to be used in a device-mapper ->iterate_devices() callback.
> A new ->dax_supported() operation is added to allow composite devices to
> split and route upper-level bdev_dax_supported() requests.
> 
> Fixes: ad428cdb525a ("dax: Check the end of the block-device...")
> Cc: <stable@vger.kernel.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Ira Weiny <ira.weiny@intel.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Cc: Keith Busch <keith.busch@intel.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Reported-by: Pankaj Gupta <pagupta@redhat.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Thank you for the patch. Looks good to me. 
I also tested the patch and it works well.

Reviewed-and-Tested-by: Pankaj Gupta <pagupta@redhat.com> 

Best regards,
Pankaj


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
