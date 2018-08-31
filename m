Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-f45.google.com (mail-oi0-f45.google.com
 [209.85.218.45])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DF005211093A4
 for <linux-nvdimm@lists.01.org>; Thu, 30 Aug 2018 17:14:24 -0700 (PDT)
Received: by mail-oi0-f45.google.com with SMTP id t68-v6so18674671oie.12
 for <linux-nvdimm@lists.01.org>; Thu, 30 Aug 2018 17:14:24 -0700 (PDT)
Subject: Re: [PATCH v5 12/13] nvmet: Introduce helper functions to allocate
 and free request SGLs
References: <20180830185352.3369-1-logang@deltatee.com>
 <20180830185352.3369-13-logang@deltatee.com>
From: Sagi Grimberg <sagi@grimberg.me>
Message-ID: <ebfd54ca-d3b2-249e-3927-eaa150b5a7c4@grimberg.me>
Date: Thu, 30 Aug 2018 17:14:20 -0700
MIME-Version: 1.0
In-Reply-To: <20180830185352.3369-13-logang@deltatee.com>
Content-Language: en-US
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
To: Logan Gunthorpe <logang@deltatee.com>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org
Cc: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alex Williamson <alex.williamson@redhat.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Acked-by: Sagi Grimberg <sagi@grimberg.me>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
