Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EDD3E221EA0B9
 for <linux-nvdimm@lists.01.org>; Thu,  7 Dec 2017 10:52:57 -0800 (PST)
References: <20171207150840.28409-1-hch@lst.de>
 <20171207150840.28409-7-hch@lst.de>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <702c44d1-eb40-42b2-f25c-2aca40c9f85f@deltatee.com>
Date: Thu, 7 Dec 2017 11:57:30 -0700
MIME-Version: 1.0
In-Reply-To: <20171207150840.28409-7-hch@lst.de>
Content-Language: en-US
Subject: Re: [PATCH 06/14] mm: better abstract out dev_pagemap start_pfn
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>
Cc: linux-mm@kvack.org, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>


Someone usually would yell at me if I sent a patch with no commit message ;)

But the changes look good and it's pretty clear even without the message.

On 07/12/17 08:08 AM, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
