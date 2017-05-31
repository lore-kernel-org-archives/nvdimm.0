Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 67BEB21A6F107
 for <linux-nvdimm@lists.01.org>; Wed, 31 May 2017 03:32:19 -0700 (PDT)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20170531094157.GA10511@lst.de>
References: <20170531094157.GA10511@lst.de>
 <20170528102008.30276-2-hch@lst.de> <20170528102008.30276-1-hch@lst.de>
 <9377.1496138404@warthog.procyon.org.uk>
Subject: Re: [PATCH 01/22] Revert "afs: Move UUID struct to linux/uuid.h"
MIME-Version: 1.0
Content-ID: <22156.1496226795.1@warthog.procyon.org.uk>
Date: Wed, 31 May 2017 11:33:15 +0100
Message-ID: <22157.1496226795@warthog.procyon.org.uk>
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
Cc: linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, linux-nvdimm@lists.01.org, Mimi Zohar <zohar@linux.vnet.ibm.com>, Amir Goldstein <amir73il@gmail.com>, linux-kernel@vger.kernel.org, dhowells@redhat.com, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Shaohua Li <shli@kernel.org>, Steven Whitehouse <swhiteho@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

Christoph Hellwig <hch@lst.de> wrote:

> Does the afs protocol require a v1 uuid or does it just use the formwat on
> the wire?

The format it uses on the wire is separate XDR encoding of each of the fields
in the uuid_v1 struct, counting the elements of the node[] array separately.

I'm not sure that the servers actually parse the contents of the UUID, but I
can't be sure as I don't have access to the source for all of them.

OpenAFS and AuriStor will at least accept the version field being 4, however.

David
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
