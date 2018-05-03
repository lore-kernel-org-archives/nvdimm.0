Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CBE1B203BEA32
 for <linux-nvdimm@lists.01.org>; Thu,  3 May 2018 15:20:14 -0700 (PDT)
Date: Thu, 3 May 2018 16:20:13 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 1/3] nvdimm: fix typo in label-size definition
Message-ID: <20180503222013.GA23376@linux.intel.com>
References: <20180427215314.23168-1-ross.zwisler@linux.intel.com>
 <20180430113858.GH4002@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180430113858.GH4002@stefanha-x1.localdomain>
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
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Eduardo Habkost <ehabkost@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, "Michael S . Tsirkin" <mst@redhat.com>, qemu-devel@nongnu.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Apr 30, 2018 at 12:38:58PM +0100, Stefan Hajnoczi wrote:
> On Fri, Apr 27, 2018 at 03:53:12PM -0600, Ross Zwisler wrote:
> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > Fixes: commit da6789c27c2e ("nvdimm: add a macro for property "label-size"")
> > Cc: Haozhong Zhang <haozhong.zhang@intel.com>
> > Cc: Michael S. Tsirkin <mst@redhat.com>
> > Cc: Stefan Hajnoczi <stefanha@redhat.com>
> > ---
> >  hw/mem/nvdimm.c         | 2 +-
> >  include/hw/mem/nvdimm.h | 2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

Thank you for the review.

This is my first QEMU submission - do I need to do anything else to get this
merged (create a pull request somewhere), or do I just wait for a maintainer
to pull it in?

Thanks,
- Ross
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
