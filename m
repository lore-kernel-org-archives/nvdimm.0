Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0BDC021F6A6CB
 for <linux-nvdimm@lists.01.org>; Mon, 19 Mar 2018 14:07:34 -0700 (PDT)
Date: Mon, 19 Mar 2018 22:14:01 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v6 12/15] xfs: require mmap lock for xfs_break_layouts()
Message-ID: <20180319211401.GA5291@lst.de>
References: <152112908134.24669.10222746224538377035.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152112914933.24669.5543317105428477772.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180319173345.GF1757@magnolia>
 <CAPcyv4hsLSR=eG8=yLtOhrOaUjqjV5S8pwwmP3oOLrknWQS6Mg@mail.gmail.com>
 <20180319194513.GA3160@lst.de>
 <CAPcyv4hhM3py_YG-qYcAxsqdCZT1aM+ziKffijVManPngbCg_A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4hhM3py_YG-qYcAxsqdCZT1aM+ziKffijVManPngbCg_A@mail.gmail.com>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Mar 19, 2018 at 01:10:52PM -0700, Dan Williams wrote:
> On Mon, Mar 19, 2018 at 12:45 PM, Christoph Hellwig <hch@lst.de> wrote:
> > On Mon, Mar 19, 2018 at 10:57:55AM -0700, Dan Williams wrote:
> >> I don't see anything to adapt with respect to mmap locks since reflink
> >> and dax are mutually exclusive.
> >
> > For now.  I'll change that pretty soon.
> 
> Right, so which patch set will be staged first? This one or the one
> that causes us to consider reflink vs dax locking?

Given that I haven't even posted the reflink+DAX support (not fixed
all issues with it) I'm pretty sure you'll be faster :)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
