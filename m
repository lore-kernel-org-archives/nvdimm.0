Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x236.google.com (mail-oi0-x236.google.com
 [IPv6:2607:f8b0:4003:c06::236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CB98520954BA5
 for <linux-nvdimm@lists.01.org>; Mon, 19 Mar 2018 13:04:24 -0700 (PDT)
Received: by mail-oi0-x236.google.com with SMTP id q71so5144711oic.6
 for <linux-nvdimm@lists.01.org>; Mon, 19 Mar 2018 13:10:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180319194513.GA3160@lst.de>
References: <152112908134.24669.10222746224538377035.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152112914933.24669.5543317105428477772.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180319173345.GF1757@magnolia>
 <CAPcyv4hsLSR=eG8=yLtOhrOaUjqjV5S8pwwmP3oOLrknWQS6Mg@mail.gmail.com>
 <20180319194513.GA3160@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 19 Mar 2018 13:10:52 -0700
Message-ID: <CAPcyv4hhM3py_YG-qYcAxsqdCZT1aM+ziKffijVManPngbCg_A@mail.gmail.com>
Subject: Re: [PATCH v6 12/15] xfs: require mmap lock for xfs_break_layouts()
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Mar 19, 2018 at 12:45 PM, Christoph Hellwig <hch@lst.de> wrote:
> On Mon, Mar 19, 2018 at 10:57:55AM -0700, Dan Williams wrote:
>> I don't see anything to adapt with respect to mmap locks since reflink
>> and dax are mutually exclusive.
>
> For now.  I'll change that pretty soon.

Right, so which patch set will be staged first? This one or the one
that causes us to consider reflink vs dax locking?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
