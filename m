Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CAE6721A16EDF
 for <linux-nvdimm@lists.01.org>; Wed, 31 May 2017 11:24:34 -0700 (PDT)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20170531161826.23243-2-hch@lst.de>
References: <20170531161826.23243-2-hch@lst.de>
 <20170531161826.23243-1-hch@lst.de>
Subject: Re: [PATCH 01/24] uuid,afs: move struct uuid_v1 back into afs
MIME-Version: 1.0
Content-ID: <31364.1496255131.1@warthog.procyon.org.uk>
Date: Wed, 31 May 2017 19:25:31 +0100
Message-ID: <31365.1496255131@warthog.procyon.org.uk>
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

> This essentially is a partial revert of commit ff548773
> ("afs: Move UUID struct to linux/uuid.h") and moves struct uuid_v1 back into
> fs/afs as struct afs_uuid.  It however keeps it as big endian structure
> so that we can use the normal uuid generation helpers when casting to/from
> struct afs_uuid.
> 
> The V1 uuid intrepreatation in struct form isn't really useful to the
> rest of the kernel, and not really compatible to it either, so move it
> back to AFS instead of polluting the global uuid.h.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: David Howells <dhowells@redhat.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
