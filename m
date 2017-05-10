Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3757821A134AE
 for <linux-nvdimm@lists.01.org>; Wed, 10 May 2017 11:21:50 -0700 (PDT)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20170510180214.16852-6-hch@lst.de>
References: <20170510180214.16852-6-hch@lst.de>
 <20170510180214.16852-1-hch@lst.de>
Subject: Re: [PATCH 05/16] uuid: add the v1 layout to uuid_t
MIME-Version: 1.0
Content-ID: <2633.1494440506.1@warthog.procyon.org.uk>
Date: Wed, 10 May 2017 19:21:46 +0100
Message-ID: <2650.1494440506@warthog.procyon.org.uk>
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
Cc: linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, Mimi Zohar <zohar@linux.vnet.ibm.com>, Amir Goldstein <amir73il@gmail.com>, linux-kernel@vger.kernel.org, dhowells@redhat.com, linux-fsdevel@vger.kernel.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Shaohua Li <shli@kernel.org>, Steven Whitehouse <swhiteho@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

Christoph Hellwig <hch@lst.de> wrote:

> Turn the content of uuid_t into a union and add the fields for the v1
> interpretation to it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: David Howells <dhowells@redhat.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
