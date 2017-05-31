Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 10C1D21AF39A2
 for <linux-nvdimm@lists.01.org>; Wed, 31 May 2017 02:41:00 -0700 (PDT)
Date: Wed, 31 May 2017 11:41:57 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 01/22] Revert "afs: Move UUID struct to linux/uuid.h"
Message-ID: <20170531094157.GA10511@lst.de>
References: <20170528102008.30276-2-hch@lst.de>
 <20170528102008.30276-1-hch@lst.de> <9377.1496138404@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <9377.1496138404@warthog.procyon.org.uk>
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
Cc: linux-raid@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, linux-nvdimm@lists.01.org, Mimi Zohar <zohar@linux.vnet.ibm.com>, Amir Goldstein <amir73il@gmail.com>, linux-kernel@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>, linux-xfs@vger.kernel.org, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Shaohua Li <shli@kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, May 30, 2017 at 11:00:04AM +0100, David Howells wrote:
> This isn't going to work.  You've effectively changed the types of the fields
> in the UUID struct from BE to CPU-endian, but you're still calling
> generate_random_uuid(), which produces a BE UUID.  You need to leave the
> struct members as __beXX or stop using the core UUID routines.
> 
> Just move the struct uuid_v1 as-is to the afs headers and rename it to struct
> afs_uuid.  You can then leave the (un)marshalling code alone.

That's one option.  The other option would be to revert

"afs: Use core kernel UUID generation", as that also changed the
v1 UUID to a v4 uuid.  Does the afs protocol require a v1 uuid
or does it just use the formwat on the wire?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
