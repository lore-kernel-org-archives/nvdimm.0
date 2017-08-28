Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5011121DF806E
 for <linux-nvdimm@lists.01.org>; Mon, 28 Aug 2017 10:50:20 -0700 (PDT)
Date: Mon, 28 Aug 2017 19:52:57 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/3] xfs: consolidate the various page fault handlers
Message-ID: <20170828175257.GA29190@lst.de>
References: <20170824152207.30729-1-hch@lst.de>
 <20170824152207.30729-3-hch@lst.de> <20170824212942.GB20489@linux.intel.com>
 <20170825071538.GB9191@lst.de> <20170828175014.GA17577@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170828175014.GA17577@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Aug 28, 2017 at 11:50:14AM -0600, Ross Zwisler wrote:
> Yep - I'm doing that in include/trace/events/fs_dax.h if you want to just copy
> & paste.

Oh, nice.  But maybe we need the trace point in the core MM instead
of in XFS and the DAX code? :)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
