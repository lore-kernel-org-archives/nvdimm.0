Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0FF9821EB5290
 for <linux-nvdimm@lists.01.org>; Thu, 31 Aug 2017 02:53:55 -0700 (PDT)
Date: Thu, 31 Aug 2017 11:56:36 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 2/4] xfs: perform dax_device lookup at mount
Message-ID: <20170831095636.GB21443@lst.de>
References: <150412222686.10177.8031279869867070772.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150412223801.10177.4972035211701096310.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <150412223801.10177.4972035211701096310.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

We don't really need the dax_device for the log device (yet), but
acquiring it seems harmless, so:

Reviewed-by: Christoph Hellwig <hch@lst.de>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
