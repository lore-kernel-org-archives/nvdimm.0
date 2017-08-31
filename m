Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22e.google.com (mail-oi0-x22e.google.com
 [IPv6:2607:f8b0:4003:c06::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D2FE620958BF9
 for <linux-nvdimm@lists.01.org>; Thu, 31 Aug 2017 14:38:33 -0700 (PDT)
Received: by mail-oi0-x22e.google.com with SMTP id n18so4383103oig.2
 for <linux-nvdimm@lists.01.org>; Thu, 31 Aug 2017 14:41:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <c92a50f21a01a0c1c809c3910251f596ddbc3acd.1504178199.git.robin.murphy@arm.com>
References: <c92a50f21a01a0c1c809c3910251f596ddbc3acd.1504178199.git.robin.murphy@arm.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 31 Aug 2017 14:41:16 -0700
Message-ID: <CAPcyv4h=1seS9OS4KMk6EFYy1LzX2J7+qX_ocEfp4MVJ88q0qg@mail.gmail.com>
Subject: Re: [PATCH v2] nd_blk: Remove mmio_flush_range()
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
To: Robin Murphy <robin.murphy@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 31, 2017 at 4:27 AM, Robin Murphy <robin.murphy@arm.com> wrote:
> mmio_flush_range() suffers from a lack of clearly-defined semantics,
> and is somewhat ambiguous to port to other architectures where the
> scope of the writeback implied by "flush" and ordering might matter,
> but MMIO would tend to imply non-cacheable anyway. Per the rationale
> in 67a3e8fe9015 ("nd_blk: change aperture mapping from WC to WB"), the
> only existing use is actually to invalidate clean cache lines for
> ARCH_MEMREMAP_PMEM type mappings *without* writeback. Since the recent
> cleanup of the pmem API, that also now happens to be the exact purpose
> of arch_invalidate_pmem(), which would be a far more well-defined tool
> for the job.
>
> Rather than risk potentially inconsistent implementations of
> mmio_flush_range() for the sake of one callsite, streamline things by
> removing it entirely and instead move the ARCH_MEMREMAP_PMEM related
> definitions up to the libnvdimm level, so they can be shared by NFIT
> as well. This allows NFIT to be enabled for arm64.
>

Thanks, applied.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
