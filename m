Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6068521A16EFD
 for <linux-nvdimm@lists.01.org>; Thu, 18 May 2017 00:13:55 -0700 (PDT)
Date: Thu, 18 May 2017 09:13:52 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 03/23] uuid: remove uuid_be defintions from the uapi header
Message-ID: <20170518071352.GA515@lst.de>
References: <20170518062705.25902-1-hch@lst.de>
 <20170518062705.25902-4-hch@lst.de> <1495091565.31562.28.camel@perches.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1495091565.31562.28.camel@perches.com>
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
To: Joe Perches <joe@perches.com>
Cc: linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, Mimi Zohar <zohar@linux.vnet.ibm.com>, Amir Goldstein <amir73il@gmail.com>, linux-kernel@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>, David Howells <dhowells@redhat.com>, linux-fsdevel@vger.kernel.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Shaohua Li <shli@kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 18, 2017 at 12:12:45AM -0700, Joe Perches wrote:
> On Thu, 2017-05-18 at 08:26 +0200, Christoph Hellwig wrote:
> > We don't use uuid_be and the UUID_BE constants in any uapi headers, so make
> > them private to the kernel.
> 
> On the assumption that no user program uses them?
> Is that a safe assumption?

It's not a userspace ABI, so by defintion it does not break an
existing user program.  If someone was using it they should be using
uuid_t from libuuid instead, as that gives them the routines to deal
with it.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
