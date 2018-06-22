Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B1E54210D1EF8
 for <linux-nvdimm@lists.01.org>; Fri, 22 Jun 2018 09:19:10 -0700 (PDT)
Date: Fri, 22 Jun 2018 10:19:08 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [fstests PATCH 1/2] src/: fix up mmap() error checking
Message-ID: <20180622161908.GB29492@linux.intel.com>
References: <20180620225147.12151-1-ross.zwisler@linux.intel.com>
 <20180622022838.GM2780@desktop>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180622022838.GM2780@desktop>
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
To: Eryu Guan <guaneryu@gmail.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, fstests@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 22, 2018 at 10:28:38AM +0800, Eryu Guan wrote:
> On Wed, Jun 20, 2018 at 04:51:46PM -0600, Ross Zwisler wrote:
> > I noticed that in some of my C tests in src/ I was incorrectly checking for
> > mmap() failure by looking for NULL instead of MAP_FAILED.  Fix those and
> > clean up some places where we were testing against -1 (the actual value of
> > MAP_FAILED) which was manually being cast to a pointer.
> > 
> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> 
> BTW, I've applied this patch, no need to resend it in v2.

Okay, thanks for letting me know.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
