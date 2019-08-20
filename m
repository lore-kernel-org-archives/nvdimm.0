Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com
 [IPv6:2607:f8b0:4864:20::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7693D2020D31E
 for <linux-nvdimm@lists.01.org>; Mon, 19 Aug 2019 21:40:01 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id b25so3115861oib.4
 for <linux-nvdimm@lists.01.org>; Mon, 19 Aug 2019 21:38:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190818090557.17853-1-hch@lst.de>
 <20190818090557.17853-2-hch@lst.de>
 <CAPcyv4iaNtmvU5e8_8SV9XsmVCfnv8e7_YfMi46LfOF4W155zg@mail.gmail.com>
 <20190820022619.GA23225@lst.de>
In-Reply-To: <20190820022619.GA23225@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 19 Aug 2019 21:38:25 -0700
Message-ID: <CAPcyv4hUC5ReY9v=Lt0M=jPtg3V05suOgt4fVdT4niO_k4hN8Q@mail.gmail.com>
Subject: Re: [PATCH 1/4] resource: add a not device managed
 request_free_mem_region variant
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
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Bharata B Rao <bharata@linux.ibm.com>, Linux MM <linux-mm@kvack.org>, Jason Gunthorpe <jgg@mellanox.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Aug 19, 2019 at 7:26 PM Christoph Hellwig <hch@lst.de> wrote:
>
> On Mon, Aug 19, 2019 at 06:28:30PM -0700, Dan Williams wrote:
> >
> > Previously we would loudly crash if someone passed NULL to
> > devm_request_free_mem_region(), but now it will silently work and the
> > result will leak. Perhaps this wants a:
>
> We'd still instantly crash due to the dev_name dereference, right?

Whoops, yes.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
