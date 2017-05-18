Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B2EE621A13499
 for <linux-nvdimm@lists.01.org>; Thu, 18 May 2017 11:32:06 -0700 (PDT)
Date: Thu, 18 May 2017 11:32:04 -0700
From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 13/23] md: namespace private helper names
Message-ID: <20170518183204.adade5y4dcwpeslz@kernel.org>
References: <20170518062705.25902-1-hch@lst.de>
 <20170518062705.25902-14-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170518062705.25902-14-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, Amir Goldstein <amir73il@gmail.com>, linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>, linux-fsdevel@vger.kernel.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Steven Whitehouse <swhiteho@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 18, 2017 at 08:26:55AM +0200, Christoph Hellwig wrote:
> From: Amir Goldstein <amir73il@gmail.com>
> 
> The md private helper uuid_equal() collides with a generic helper
> of the same name.
> 
> Rename the md private helper to md_uuid_equal() and do the same for
> md_sb_equal().
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Shaohua Li <shli@kernel.org>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
