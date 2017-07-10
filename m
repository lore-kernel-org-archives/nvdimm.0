Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EBC1E20958985
 for <linux-nvdimm@lists.01.org>; Mon, 10 Jul 2017 13:28:27 -0700 (PDT)
Date: Mon, 10 Jul 2017 13:30:12 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] nvdimm: Remove minimum size requirement
Message-ID: <20170710203012.GB22476@bombadil.infradead.org>
References: <20170710183248.2417-1-willy@infradead.org>
 <CAPcyv4ioWUmiHbaGVcpxuK-j0JrcGk-_VcpR6yQtQMUwcRTRcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4ioWUmiHbaGVcpxuK-j0JrcGk-_VcpR6yQtQMUwcRTRcQ@mail.gmail.com>
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
Cc: Cheng-mean Liu <soccerl@microsoft.com>, Matthew Wilcox <mawilcox@microsoft.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jul 10, 2017 at 11:41:08AM -0700, Dan Williams wrote:
> >         size = nvdimm_namespace_capacity(ndns);
> > -       if (size < ND_MIN_NAMESPACE_SIZE) {
> > -               dev_dbg(&ndns->dev, "%pa, too small must be at least %#x\n",
> > -                               &size, ND_MIN_NAMESPACE_SIZE);
> > +       if (size < PAGE_SIZE) {
> 
> If we're going to change the print level away from 'debug' then I
> think this should be "if (size && size < PAGE_SIZE)". The sub-system
> pre-creates 0-sized devices that are later configured into full
> namespaces, in those cases we shouldn't fire the warning.

Should we allow drivers to claim zero-sized devices?  If not, then the
dev_warn() should be predicated on size being non-zero, but the return
-ENODEV should still trigger.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
