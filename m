Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it0-x234.google.com (mail-it0-x234.google.com
 [IPv6:2607:f8b0:4001:c0b::234])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BDC9521A1348F
 for <linux-nvdimm@lists.01.org>; Wed,  3 May 2017 08:52:18 -0700 (PDT)
Received: by mail-it0-x234.google.com with SMTP id c15so70997446ith.0
 for <linux-nvdimm@lists.01.org>; Wed, 03 May 2017 08:52:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170503153103.30756-1-toshi.kani@hpe.com>
References: <20170503153103.30756-1-toshi.kani@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 3 May 2017 08:52:17 -0700
Message-ID: <CAPcyv4hu9iW-EEaggOj4ax_P6=Y28adi5Hb7Rp1Q1xBTWenJuQ@mail.gmail.com>
Subject: Re: [RFC PATCH] dax: add badblocks check to Device DAX
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

On Wed, May 3, 2017 at 8:31 AM, Toshi Kani <toshi.kani@hpe.com> wrote:
> This is a RFC patch for seeking suggestions.  It adds support of
> badblocks check in Device DAX by using region-level badblocks list.
> This patch is only briefly tested.
>
> device_dax is a well-isolated self-contained module as it calls
> alloc_dax() with dev_dax, which is private to device_dax.  For
> checking badblocks, it needs to call dax_pmem to check with
> region-level badblocks.
>
> This patch attempts to keep device_dax self-contained.  It adds
> check_error() to dax_operations, and dax_check_error() as a stub
> with *dev_dax and *dev pointers to convey it to dax_pmem.  I am
> wondering if this is the right direction, or we should change the
> modularity to let dax_pmem call alloc_dax() with its dax_pmem (or
> I completely missed something).

The problem is that device-dax guarantees a given fault granularity.
To make that guarantee we can't fallback from 1G or 2M mappings due to
an error. We also can't reasonably go the other way and fail mappings
that contain a badblock because that would change the blast radius of
a media error to the fault size.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
