Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1F47721A16EC6
 for <linux-nvdimm@lists.01.org>; Tue, 30 May 2017 02:59:13 -0700 (PDT)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20170528102008.30276-2-hch@lst.de>
References: <20170528102008.30276-2-hch@lst.de>
 <20170528102008.30276-1-hch@lst.de>
Subject: Re: [PATCH 01/22] Revert "afs: Move UUID struct to linux/uuid.h"
MIME-Version: 1.0
Content-ID: <9376.1496138404.1@warthog.procyon.org.uk>
Date: Tue, 30 May 2017 11:00:04 +0100
Message-ID: <9377.1496138404@warthog.procyon.org.uk>
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
Cc: linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, Mimi Zohar <zohar@linux.vnet.ibm.com>, Amir Goldstein <amir73il@gmail.com>, linux-kernel@vger.kernel.org, dhowells@redhat.com, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Shaohua Li <shli@kernel.org>, Steven Whitehouse <swhiteho@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

Christoph Hellwig <hch@lst.de> wrote:

> This reverts commit ff548773106ec7f8031bc6172e0234bd2a02c19c.
> 
> The V1 uuid intrepreatation in struct form isn't really useful to the
> rest of the kernel, and not really compatible to it either, so move it
> back to AFS instead of polluting the global uuid.h.

This isn't going to work.  You've effectively changed the types of the fields
in the UUID struct from BE to CPU-endian, but you're still calling
generate_random_uuid(), which produces a BE UUID.  You need to leave the
struct members as __beXX or stop using the core UUID routines.

Just move the struct uuid_v1 as-is to the afs headers and rename it to struct
afs_uuid.  You can then leave the (un)marshalling code alone.

David
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
