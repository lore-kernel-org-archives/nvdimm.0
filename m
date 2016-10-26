Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x231.google.com (mail-oi0-x231.google.com
 [IPv6:2607:f8b0:4003:c06::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 46E3F1A1E29
 for <linux-nvdimm@lists.01.org>; Wed, 26 Oct 2016 06:39:07 -0700 (PDT)
Received: by mail-oi0-x231.google.com with SMTP id n202so17068337oig.3
 for <linux-nvdimm@lists.01.org>; Wed, 26 Oct 2016 06:39:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <a5418089-2615-8c04-aca8-50ceb43978f1@mellanox.com>
References: <1476826937-20665-1-git-send-email-sbates@raithlin.com>
 <CAPcyv4gJ_c-6s2BUjsu6okR1EF53R+KNuXnOc5jv0fuwJaa3cQ@mail.gmail.com>
 <a5418089-2615-8c04-aca8-50ceb43978f1@mellanox.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 26 Oct 2016 06:39:05 -0700
Message-ID: <CAPcyv4h9Ubgiv1B8FPqes-zUXMckzfEi6uqtfc4GrLc_8BeSLg@mail.gmail.com>
Subject: Re: [PATCH 0/3] iopmem : A block device for PCIe memory
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
To: Haggai Eran <haggaie@mellanox.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, sbates@raithin.com, "Raj, Ashok  <ashok.raj@intel.com>, linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, linux-rdma@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>, Jonathan Corbet <corbet@lwn.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, jim.macdonald@everspin.com, Stephen Bates <sbates@raithlin.com>, linux-block@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@infradead.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Oct 26, 2016 at 1:24 AM, Haggai Eran <haggaie@mellanox.com> wrote:
[..]
>> I wonder if we could (ab)use a
>> software-defined 'pasid' as the requester id for a peer-to-peer
>> mapping that needs address translation.
> Why would you need that? Isn't it enough to map the peer-to-peer
> addresses correctly in the iommu driver?
>

You're right, we might already have enough...

We would just need to audit iommu drivers to undo any assumptions that
the page being mapped is always in host memory and apply any bus
address translations between source device and target device.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
