Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A50B421A16EF9
 for <linux-nvdimm@lists.01.org>; Tue, 23 May 2017 01:41:20 -0700 (PDT)
Date: Tue, 23 May 2017 10:41:18 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 13/23] md: namespace private helper names
Message-ID: <20170523084118.GA20121@lst.de>
References: <20170518062705.25902-1-hch@lst.de>
 <20170518062705.25902-14-hch@lst.de>
 <1495479147.6967.70.camel@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1495479147.6967.70.camel@linux.intel.com>
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
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, Mimi Zohar <zohar@linux.vnet.ibm.com>, Amir Goldstein <amir73il@gmail.com>, linux-kernel@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>, David Howells <dhowells@redhat.com>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, May 22, 2017 at 09:52:27PM +0300, Andy Shevchenko wrote:
> On Thu, 2017-05-18 at 08:26 +0200, Christoph Hellwig wrote:
> > From: Amir Goldstein <amir73il@gmail.com>
> > 
> > The md private helper uuid_equal() collides with a generic helper
> > of the same name.
> > 
> > Rename the md private helper to md_uuid_equal() and do the same for
> > md_sb_equal().
> > 
> 
> While patch is good, shouldn't it go before we introduce those helpers?

Yes, I'll move it to the beginning of the series.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
