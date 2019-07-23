Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
References: <20190722094143.18387-1-hch@lst.de>
In-Reply-To: <20190722094143.18387-1-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 22 Jul 2019 22:32:03 -0700
Message-ID: <CAPcyv4j7wPPBbcPDRGn=L8K-HQCZQbM0+HiXJX_F+1Uway+qXA@mail.gmail.com>
Subject: Re: [PATCH] memremap: move from kernel/ to mm/
Content-Type: text/plain; charset="UTF-8"
Sender: owner-linux-mm@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jul 22, 2019 at 2:42 AM Christoph Hellwig <hch@lst.de> wrote:
>
> memremap.c implements MM functionality for ZONE_DEVICE, so it really
> should be in the mm/ directory, not the kernel/ one.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Dan Williams <dan.j.williams@intel.com>
