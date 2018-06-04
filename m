Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail03.adl2.internode.on.net (ipmail03.adl2.internode.on.net
 [150.101.137.141])
 by ml01.01.org (Postfix) with ESMTP id 3CB09209603ED
 for <linux-nvdimm@lists.01.org>; Sun,  3 Jun 2018 20:51:57 -0700 (PDT)
Date: Mon, 4 Jun 2018 13:51:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Question about Experimental of Filesystem DAX.
Message-ID: <20180604035118.GN10363@dastard>
References: <20180531112731.0CAC.E1E9C6FF@jp.fujitsu.com>
 <20180531150716.GA19764@linux.intel.com>
 <CAPcyv4jpffaM60tTdLTojhh0CDwcbVUdS8td7R6LKWM3bb15dw@mail.gmail.com>
 <20180531174636.GA7825@magnolia>
 <CAPcyv4gS1GCN9TFjngTmmHu83-uMgRpvvx842ZGnvxB3PbgU+Q@mail.gmail.com>
 <20180531202556.GA28256@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180531202556.GA28256@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, NVDIMM-ML <linux-nvdimm@lists.01.org>, linux-xfs <linux-xfs@vger.kernel.org>, Yasunori Goto <y-goto@jp.fujitsu.com>, linux-ext4 <linux-ext4@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 31, 2018 at 02:25:56PM -0600, Ross Zwisler wrote:
> > Right, not a gating item for declaring DAX ready for prime time.
> 
> Yep, I think that the very loud EXPERIMENTAL message is essentially telling
> users "your data is at risk if you use this".

And that's a call the filesystem maintainers need to make, not the
DAX developers. It's clear from recent "oh fuck, DAX on XFS has
stopped working in 4.17" a long time after after the changes that
broke went into the mainline kernel indicates we have a serious
testing problem here.

i.e. that the filesystem developers who will have to maintain this
stuff and deal with all the "DAX ate my data" bug reports haven't
been testing DAX on their filesysetms at all in recent times. And
that kinda says to me that the EXPERIMENTAL flag is not getting
removed any time soon....

> As far as I know those are basically the 2 items on Dan's
> list from a few mails ago (poison recovery & DMA vs truncate).

FWIW, I have not been testing DAX because I'm waiting for
infrastructure problems like DMA vs truncate to get fixed first....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
