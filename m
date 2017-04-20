Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
 [148.163.156.1])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 607C121954077
 for <linux-nvdimm@lists.01.org>; Thu, 20 Apr 2017 10:05:59 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id
 v3KH3cIg078591
 for <linux-nvdimm@lists.01.org>; Thu, 20 Apr 2017 13:05:58 -0400
Received: from e06smtp10.uk.ibm.com (e06smtp10.uk.ibm.com [195.75.94.106])
 by mx0a-001b2d01.pphosted.com with ESMTP id 29y0hd9rb1-1
 (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Thu, 20 Apr 2017 13:05:58 -0400
Received: from localhost
 by e06smtp10.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <gerald.schaefer@de.ibm.com>;
 Thu, 20 Apr 2017 18:05:55 +0100
Date: Thu, 20 Apr 2017 19:05:50 +0200
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: Re: [PATCH v3] dcssblk: add dax_operations support
In-Reply-To: <149264113824.36586.1220609927071019352.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149264113824.36586.1220609927071019352.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Message-Id: <20170420190550.6a31fa6c@thinkpad>
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
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

On Wed, 19 Apr 2017 15:32:38 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> Setup a dax_dev to have the same lifetime as the dcssblk block device
> and add a ->direct_access() method that is equivalent to
> dcssblk_direct_access(). Once fs/dax.c has been converted to use
> dax_operations the old dcssblk_direct_access() will be removed.
> 
> Reported-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> Changes since v2:
> * fix return code in the alloc_dax() failure case (Gerald)
> * assign dax_dev to dev_info and kill local variable (Gerald)
> 
>  drivers/s390/block/Kconfig   |    1 +
>  drivers/s390/block/dcssblk.c |   55 +++++++++++++++++++++++++++++++++++-------
>  2 files changed, 47 insertions(+), 9 deletions(-)

Acked-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
