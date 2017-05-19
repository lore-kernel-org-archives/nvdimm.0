Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1272621A134B9
 for <linux-nvdimm@lists.01.org>; Fri, 19 May 2017 03:58:46 -0700 (PDT)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20170518071352.GA515@lst.de>
References: <20170518071352.GA515@lst.de> <20170518062705.25902-1-hch@lst.de>
 <20170518062705.25902-4-hch@lst.de> <1495091565.31562.28.camel@perches.com>
Subject: Re: [PATCH 03/23] uuid: remove uuid_be defintions from the uapi header
MIME-Version: 1.0
Content-ID: <13040.1495191521.1@warthog.procyon.org.uk>
Date: Fri, 19 May 2017 11:58:41 +0100
Message-ID: <13041.1495191521@warthog.procyon.org.uk>
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
Cc: linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, Mimi Zohar <zohar@linux.vnet.ibm.com>, Amir Goldstein <amir73il@gmail.com>, linux-kernel@vger.kernel.org, dhowells@redhat.com, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, Joe Perches <joe@perches.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Shaohua Li <shli@kernel.org>, Steven Whitehouse <swhiteho@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

Christoph Hellwig <hch@lst.de> wrote:

> It's not a userspace ABI, so by defintion it does not break an
> existing user program.

That's an invalid assumption.  It is a de facto userspace ABI as it has been
exposed in /usr/include/linux/uuid.h for some time.

> If someone was using it they should be using uuid_t from libuuid instead, as
> that gives them the routines to deal with it.

Yes, they should - but that doesn't mean they do.

David
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
