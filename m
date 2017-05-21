Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 07907203BF103
 for <linux-nvdimm@lists.01.org>; Sat, 20 May 2017 23:56:00 -0700 (PDT)
Date: Sun, 21 May 2017 08:55:57 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 03/23] uuid: remove uuid_be defintions from the uapi header
Message-ID: <20170521065557.GC13004@lst.de>
References: <20170518071352.GA515@lst.de> <20170518062705.25902-1-hch@lst.de>
 <20170518062705.25902-4-hch@lst.de> <1495091565.31562.28.camel@perches.com>
 <13041.1495191521@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <13041.1495191521@warthog.procyon.org.uk>
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
To: David Howells <dhowells@redhat.com>
Cc: linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, Mimi Zohar <zohar@linux.vnet.ibm.com>, Amir Goldstein <amir73il@gmail.com>, linux-kernel@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, Joe Perches <joe@perches.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Shaohua Li <shli@kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, May 19, 2017 at 11:58:41AM +0100, David Howells wrote:
> Christoph Hellwig <hch@lst.de> wrote:
> 
> > It's not a userspace ABI, so by defintion it does not break an
> > existing user program.
> 
> That's an invalid assumption.  It is a de facto userspace ABI as it has been
> exposed in /usr/include/linux/uuid.h for some time.

It is never passed through any kernel interface, which by defintion does
not make it an ABI.  And even if it was we are not going to change the
ABI for a uuid_t ever.  We're just changing the internal name, and stop
exposing the old name which was never used in an ABI to userspace.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
