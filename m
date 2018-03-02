Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7CC9121E256AF
 for <linux-nvdimm@lists.01.org>; Fri,  2 Mar 2018 14:46:02 -0800 (PST)
Date: Fri, 2 Mar 2018 23:52:10 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5 01/12] dax: fix vma_is_fsdax() helper
Message-ID: <20180302225210.GB31240@lst.de>
References: <151996281307.28483.12343847096989509127.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151996281881.28483.2616406435517031167.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <151996281881.28483.2616406435517031167.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jane Chu <jane.chu@oracle.com>, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, Gerd Rausch <gerd.rausch@oracle.com>, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
