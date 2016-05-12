Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 by ml01.01.org (Postfix) with ESMTP id DDC1F1A1E61
 for <linux-nvdimm@lists.01.org>; Thu, 12 May 2016 10:06:42 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH v7 4/6] dax: export a low-level __dax_zero_page_range
 helper
Date: Thu, 12 May 2016 17:06:39 +0000
Message-ID: <1463072787.29294.38.camel@intel.com>
References: <1463000932-31680-1-git-send-email-vishal.l.verma@intel.com>
 <1463000932-31680-5-git-send-email-vishal.l.verma@intel.com>
 <20160512084138.GC10306@quack2.suse.cz>
In-Reply-To: <20160512084138.GC10306@quack2.suse.cz>
Content-Language: en-US
Content-ID: <9CB344B4DD27584EAD3C45DE3E6E0947@intel.com>
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
To: "jack@suse.cz" <jack@suse.cz>
Cc: "hch@infradead.org" <hch@infradead.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "axboe@fb.com" <axboe@fb.com>, "david@fromorbit.com" <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "hch@lst.de" <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 2016-05-12 at 10:41 +0200, Jan Kara wrote:
> On Wed 11-05-16 15:08:50, Vishal Verma wrote:
> > 
> > From: Christoph Hellwig <hch@lst.de>
> > 
> > This allows XFS to perform zeroing using the iomap infrastructure
> > and
> > avoid buffer heads.
> > 
> > [vishal: fix conflicts with dax-error-handling]
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> Looks good. You can add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> 
> BTW: You are supposed to add your Signed-off-by when forwarding
> patches
> like this...

Ah I didn't know. I'll add it when making the stable topic branch for
this. Thanks!

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
