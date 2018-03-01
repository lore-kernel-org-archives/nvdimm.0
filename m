Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wm0-f67.google.com (mail-wm0-f67.google.com [74.125.82.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 16DBA22451181
 for <linux-nvdimm@lists.01.org>; Thu,  1 Mar 2018 03:02:19 -0800 (PST)
Received: by mail-wm0-f67.google.com with SMTP id w128so10878431wmw.0
 for <linux-nvdimm@lists.01.org>; Thu, 01 Mar 2018 03:08:28 -0800 (PST)
Subject: Re: [PATCH v2 05/10] block: Introduce PCI P2P flags for request and
 request queue
References: <20180228234006.21093-1-logang@deltatee.com>
 <20180228234006.21093-6-logang@deltatee.com>
From: Sagi Grimberg <sagi@grimberg.me>
Message-ID: <2882003d-7689-7825-7651-e68ffadb9d41@grimberg.me>
Date: Thu, 1 Mar 2018 13:08:24 +0200
MIME-Version: 1.0
In-Reply-To: <20180228234006.21093-6-logang@deltatee.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alex Williamson <alex.williamson@redhat.com>, Keith Busch <keith.busch@intel.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Looks fine,

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
