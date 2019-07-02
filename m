Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 006E12194EB7A
 for <linux-nvdimm@lists.01.org>; Tue,  2 Jul 2019 15:35:36 -0700 (PDT)
Date: Tue, 2 Jul 2019 15:35:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 16/25] device-dax: use the dev_pagemap internal refcount
Message-Id: <20190702153535.228365fea7f0063cceec96cd@linux-foundation.org>
In-Reply-To: <CAPcyv4h90DAVHbZ4bgvJwpfB8wr2K28oEes6HcdQOpf02+NL=g@mail.gmail.com>
References: <20190626122724.13313-17-hch@lst.de>
 <20190628153827.GA5373@mellanox.com>
 <CAPcyv4joSiFMeYq=D08C-QZSkHz0kRpvRfseNQWrN34Rrm+S7g@mail.gmail.com>
 <20190628170219.GA3608@mellanox.com>
 <CAPcyv4ja9DVL2zuxuSup8x3VOT_dKAOS8uBQweE9R81vnYRNWg@mail.gmail.com>
 <CAPcyv4iWTe=vOXUqkr_CguFrFRqgA7hJSt4J0B3RpuP-Okz0Vw@mail.gmail.com>
 <20190628182922.GA15242@mellanox.com>
 <CAPcyv4g+zk9pnLcj6Xvwh-svKM+w4hxfYGikcmuoBAFGCr-HAw@mail.gmail.com>
 <20190628185152.GA9117@lst.de>
 <CAPcyv4i+b6bKhSF2+z7Wcw4OUAvb1=m289u9QF8zPwLk402JVg@mail.gmail.com>
 <20190628190207.GA9317@lst.de>
 <CAPcyv4h90DAVHbZ4bgvJwpfB8wr2K28oEes6HcdQOpf02+NL=g@mail.gmail.com>
Mime-Version: 1.0
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, =?ISO-8859-1?Q?J=E9r=F4me?= Glisse <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Ben Skeggs <bskeggs@redhat.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, 28 Jun 2019 12:14:44 -0700 Dan Williams <dan.j.williams@intel.com> wrote:

> I believe -mm auto drops patches when they appear in the -next
> baseline. So it should "just work" to pull it into the series and send
> it along for -next inclusion.

Yup.  Although it isn't very "auto" - I manually check that the patch
which turned up in -next was identical to the version which I had.  If
not, I go find out why...

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
