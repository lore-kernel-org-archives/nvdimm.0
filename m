Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22b.google.com (mail-oi0-x22b.google.com
 [IPv6:2607:f8b0:4003:c06::22b])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3E55A21A04817
 for <linux-nvdimm@lists.01.org>; Fri, 28 Apr 2017 17:10:29 -0700 (PDT)
Received: by mail-oi0-x22b.google.com with SMTP id x184so43982908oia.1
 for <linux-nvdimm@lists.01.org>; Fri, 28 Apr 2017 17:10:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170427225706.26791-2-toshi.kani@hpe.com>
References: <20170427225706.26791-1-toshi.kani@hpe.com>
 <20170427225706.26791-2-toshi.kani@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 28 Apr 2017 17:10:28 -0700
Message-ID: <CAPcyv4j9QPSwpqs9YPjFo=O8RA+NmpsAZhARfNcSqA0TqqMhLA@mail.gmail.com>
Subject: Re: [PATCH 2/2] libnvdimm: clear region badblock in
 nvdimm_clear_poison()
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
To: Toshi Kani <toshi.kani@hpe.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Apr 27, 2017 at 3:57 PM, Toshi Kani <toshi.kani@hpe.com> wrote:
> Badblocks are tracked at both region and device levels.
> pmem_clear_poison() and nsio_rw_bytes() call nvdimm_clear_poison()
> and then badblocks_clear() to clear badblocks at the device level.
> However, it does not update badblocks at the region level, which
> makes them inconsistent.
>
> Change nvdimm_clear_poison() to update backblocks at the region
> level to keep them consistent.
>
> Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Vishal Verma <vishal.l.verma@intel.com>

This looks good, and it seems we have a bug in the other location that
does this in __nd_ioctl(). That other one is missing the
"clear_err.cleared / 512" check. Can you respin this and define a
common helper that both locations can call?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
