Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB5E3EE1E5
	for <nvdimm@lists.linux.dev>; Tue, 30 Jun 2026 09:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782812844; cv=pass; b=XAS2WC/DY6WXwz/woSyJGah1ojONIKjYxduYwlxAO9jeC0V1jtmx9rkNyx5GMPJ9qBHqIIbiuUFXDsftO6E9ovqhTQi3w7v9xl/ZkqIh6Jj7tBhJd/tHRb3IezAyodZl/k0iq9s1hvlLOiGP2I07JOlc5hTbOMrZZfdw5KoGPq0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782812844; c=relaxed/simple;
	bh=mbKVpQPDeDDFht6FcdGf+b590T3tEEZuvC93vpYd4Sc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K4HmqVXxo99tXGcRL2iX+RENtDK1hIEhrl+D/CkUYksr/DZKcpumfo5OfkwzfH8NoaSl1mI2/oJ5IxklJftlUMdUmJywpLFvusNQ7vxMN15BN1T/J+vGRVHIXI8Sc/X3z2MJvByMl97Fr9ZWNjbXvY1N6y8EZDXpf2VGpoZD8vE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WQb6c7eV; arc=pass smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WQb6c7eV"
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-495c63c4141so1530564b6e.2
        for <nvdimm@lists.linux.dev>; Tue, 30 Jun 2026 02:47:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782812842; cv=none;
        d=google.com; s=arc-20260327;
        b=QlD6tGOW/K3bsdvYczttVi2Vz9YKMPQKIEYUO8KUvGD1EBBfFZwmfOHsoIkJTDDsf7
         7HEc9VaEEPPQVu69R/x1DLXF70oilTsJrx3OQrmcmiQubbXAk/Od8L8h2r98zZvPpxjI
         V5H+NTRd22whdG3D0VMxPEb1nlVuZYDqglpdk0x0x8s59uCUVBli/oOz0/rh9Z935eFs
         unI+q8UhzqN36sI+yrpVX97C8u5Bg7tOcvLiunrMdT1vA/KBzHmmW7ML4RyXoBdxcL1B
         ctcsOH7FDcM4DEVwH6sMyrUjM7GCLNodBermigJTQ8olFaU8Bd/5rRxZhUhXA26fHn0Q
         av3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=KBIcT5HxVe2+MOLGkActp5e844bC5vrv0teTaWEFK6Y=;
        fh=u0/kg3Xa6A3PEKxjWdYtza1SkfkiFu2YuBEboLwjX2o=;
        b=lRU05YuQPFqy1COoKMjaLhJR05kshLP09tqvgTx013In1fpfEbRVp8tH/ZBEvdkeBS
         LruTZ0Xcx8/6GnTfXbGUav2EBPwp4OidEIK6VlPmk8KXHqAJZxdDxWba0u7ji1jwCeVU
         sJpYt8T2xUtJZZJrPxJTECGwR9wnfGLgqyvyrNH9D5meGpkN7+WYvGlLhRpiV88y1tGy
         U1VPfU/HrBW3h0jIs7IqIavia0SU5cgYFNzDtaBV7ywsCF4V5VM0TPZa7wP1jAIUTpY5
         WINvj2VVAMfcmN62OVJkv2+t4xzQgIU6Taly7NKP6Xu2P5SQUFHdoRNQQ5jFfk3Ilr0I
         +GKw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782812842; x=1783417642; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KBIcT5HxVe2+MOLGkActp5e844bC5vrv0teTaWEFK6Y=;
        b=WQb6c7eVveYFiksY/oLSjxVE7rjXHRO2L65gZzalczXNT/7YSHB2+kbu1E2hnorBTk
         ZV1SXM0Gl2PMu1jtZQJqhTNkmbSD+A1QVlLCGg30ITVNZWlbU+So9RIXiVVMbWjIyrI8
         jYq10KJLXTM8jYcS/B8i0U7Bsjgmp4f2Jc36+lQATDlQ8RVRzmYLPhocva+KFmdEVi+G
         XuseRD4CDcCglhW2Im3rVNKHXPFxad+rXMhSQSV3ntIOPoK+zmukudyG/6kkrs7DZ2vw
         7xqnJ7e9618staRZp3hTWadvWvJfkI1IiwRueN4bRXnoYsW4e84AAkpg2MUo7MKL0iqQ
         Mleg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782812842; x=1783417642;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KBIcT5HxVe2+MOLGkActp5e844bC5vrv0teTaWEFK6Y=;
        b=j/a2nlxjJ/VJJdqOTXrqhDKhzvek121TZU36kew363UntOrFQrVkW1NbhcsDYtVcv8
         tAeCEt5zlCXhk29B0OwyTcIvo9zXZ09QJfX0jHlLA+XNhp2z+UNrmOuU6xs+CUlddcS9
         Bl/P01AScbzYqcfLJE+Ec42ZeRzqVIkbBHCon9eBI5hvTzDoIDBUDsO+xSCKIrH2p9PZ
         FUZz83SV2O28y395cqa8Zpg4WMzv37y7zCU8nYZroVxeqluOXU7Ncixjzeskx/ZGr4Yu
         4Mq+eT5e42zC3rtP0khQ+JPvGGUX5JdZMX7RGXcFGJ+VUWthdDYVzT3FR3yIuViTIJ6B
         4EUg==
X-Forwarded-Encrypted: i=1; AFNElJ+OXPL4Dbicno0JRsMRX3hFNE9crT36eJocZHX7YfGBuRvnH5hmcH73F09CuOkSAry1HdzYILM=@lists.linux.dev
X-Gm-Message-State: AOJu0YzdaMjOa368WQkdzWB8zh19HaK09T1WFcXJdYVgvILP9tNDuIZm
	pce/P+MVJctmSC5T58TcTNLroGSQ+Azl81+yOVRmHSjoUSt5KjI1Gt2R4i8NIApAB1k57invYr/
	4Xoc+DHCblCgt41hvzCvBDSWQBwug29o=
X-Gm-Gg: AfdE7cmQ7H4tvsEVtvIo5ezh3hACzMbZCWc/Cj4UTj8VOb4n7xbFlMGNaPfBVxsfR0g
	wRwLuxhAFn/tiA/GthLupuRkmL4BnfDiGQa8EoQjz4ueGuGFk3vo9jumbT9WsFlCQt7sB2mG8tk
	PZ0FlPgEwCZx2dvysjV5B3ODJUIHBgnj7qLtxCRqE+ISFh/5BUog5fcJcSTPEA8J7lXVu7MMivQ
	4JJYO4Rv3ipnEVUpaTi0HQ9QEz6mdZLak+NzuVcq1MAba6BgMwM3iv/V77O5LC4IBrX+a3Xj+U=
X-Received: by 2002:a05:6808:e86:b0:491:177:c22d with SMTP id
 5614622812f47-495eb113c92mr2503729b6e.36.1782812841661; Tue, 30 Jun 2026
 02:47:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260630092338.2094628-1-me@linux.beauty>
In-Reply-To: <20260630092338.2094628-1-me@linux.beauty>
From: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date: Tue, 30 Jun 2026 11:47:09 +0200
X-Gm-Features: AVVi8CcDtRS43Sq7ele27Lz7sTO6pgEllQzoWJX7MfY6faDfvLddPHeZ0ZfhVIY
Message-ID: <CAM9Jb+gvNYvnqE65WWpXig-VE53KnMZpLf1CF6vxk51cBySKgA@mail.gmail.com>
Subject: Re: [PATCH v7 00/12] nvdimm: virtio_pmem: fix flush/request failure paths
To: Li Chen <me@linux.beauty>
Cc: Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Alison Schofield <alison.schofield@intel.com>, virtualization@lists.linux.dev, 
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	"Michael S . Tsirkin" <mst@redhat.com>, Dan Williams <djbw@kernel.org>
Content-Type: text/plain; charset="UTF-8"

+CC Dan's correct email address and MST's email.

> Hi,
>
> This series started as a virtio-pmem request lifetime and broken virtqueue
> fix, but the rerolls have picked up several related flush-path fixes found
> during local testing and review. Since the series is now broader than the
> original lifetime bug, this cover letter calls out where the patches came
> from.
>
> The nvdimm flush helper maps provider flush failures to -EIO. That should
> remain the default for provider/backend failures because host-side errors are
> still best reported as generic I/O errors to the guest. However, virtio-pmem
> may also fail a guest-local flush request allocation with -ENOMEM before any
> request is submitted to the host. Reporting that resource failure as -EIO
> makes memory pressure look like media failure.
>
> The raw failure seen in the local mkfs sanity test was:
>
>   wipefs: /dev/pmem0: cannot flush modified buffers: Input/output error
>   mkfs.ext4: Input/output error while writing out and closing file system
>   nd_region region0: dbg: nvdimm_flush rc=-5
>
> Patch 1 comes from that local failure, with the error policy narrowed after
> Pankaj pointed out that host/backend provider errors should not all be exposed
> directly to the guest. It now preserves only -ENOMEM and keeps other provider
> flush failures mapped to -EIO.
>
> Patches 2 and 3 come from review of the pmem flush path. Patch 2 keeps a
> failed REQ_PREFLUSH from being overwritten after data copy, and patch 3 is the
> dataless-bio guard added after the Sashiko review. Patch 4 comes from the
> local child flush bio allocation failure, but v7 reworks the v6 synchronous
> FUA approach after Pankaj noted that the old child flush bio path completed
> asynchronously. This version removes the child bio while keeping parent bio
> completion asynchronous: the provider returns NVDIMM_FLUSH_ASYNC, queues
> ordered WQ_MEM_RECLAIM work, and completes the parent bio after
> virtio_pmem_flush() finishes. Patch 5 is the remaining allocation-policy
> follow-up for the actual virtio-pmem flush request object, not for a child
> bio.
>
> Patches 6 and 7 are the older waiter fixes. Patch 6 wakes one -ENOSPC waiter
> for each reclaimed used buffer, and patch 7 makes the wait flags explicit
> READ_ONCE()/WRITE_ONCE() accesses. Pankaj asked for those changes to be split
> across patches, and patch 7 carries his Acked-by.
>
> Patch 8 is the original KASAN use-after-free fix for the request token
> lifetime. Patches 9 and 10 are follow-up hardening in the same completion
> path: order response publication before the submitter reads resp.ret, and keep
> the DMA_FROM_DEVICE response buffer away from CPU-owned request fields. Patch
> 11 addresses the broken virtqueue / notify failure path reported by LKP and
> reproduced locally with fault injection. It also serializes async parent-bio
> flush work against broken-state publication, so remove/freeze cannot drain the
> workqueue before a racing FUA bio queues new completion work. Patch 12 handles
> teardown: it drains requests across freeze/remove and also addresses the
> Sashiko-reported req_vq-after-free/NULL-deref class by clearing req_vq after
> del_vqs() and making the drain helper tolerate a NULL queue. It also stops the
> submit path from checking req_vq after the broken state is visible.
>
> The original repros were on QEMU x86_64 with a virtio-pmem device exported
> as /dev/pmem0. For this v7 reroll, the series applies to v7.1-rc7.
>
> Thanks,
> Li Chen
>
> Changelog:
> v6->v7:
> - Address Pankaj's feedback on nvdimm_flush() error policy.
> - Preserve only -ENOMEM from provider flush callbacks and continue to map
>   other provider/backend failures to -EIO.
> - Address Pankaj's feedback on the FUA flush behavior: replace the v6
>   synchronous FUA path with provider-owned asynchronous parent bio completion.
> - Add NVDIMM_FLUSH_ASYNC and use ordered WQ_MEM_RECLAIM work to run
>   virtio_pmem_flush() and complete the parent bio after the host flush.
> - Keep GFP_NOIO for the virtio-pmem request allocation, but no longer describe
>   it as a child bio allocation fix.
> - Add Pankaj's Acked-by on the READ_ONCE()/WRITE_ONCE() patch.
> - Serialize async parent-bio flush work against broken-state publication in
>   the broken-virtqueue patch, so remove/freeze cannot drain the workqueue
>   before a racing FUA bio queues new completion work.
> - Fold the Sashiko-reported req_vq NULL-deref fix into the freeze/remove
>   drain patch.
> - Update commit messages and this cover letter to describe patch origins.
> v5->v6:
> - Address Sashiko review feedback:
>   - Add a data-loop guard for dataless bios in pmem_submit_bio().
>   - Replace the child flush bio allocation with synchronous FUA flushing.
>   - Keep GFP_NOIO only for the virtio-pmem request allocation.
>   - Publish request completion with release/acquire ordering.
>   - Isolate the DMA_FROM_DEVICE response buffer from CPU-owned fields.
>   - Wake the in-flight host-completion waiter when marking the queue broken.
> - Clear req_vq after del_vqs() and make drain tolerate a NULL queue.
> v4->v5:
> - Address review feedback about REQ_PREFLUSH ordering and active virtqueue
>   detach.
> - Add 2/8 so a failed REQ_PREFLUSH fails the bio before any data copy, and
>   make REQ_PREFLUSH use a synchronous provider flush instead of a deferred
>   child bio.
> - Rework broken-queue handling so runtime failure marking only stops new
>   submissions and wakes local -ENOSPC waiters; used/unused token draining is
>   done after device reset in remove() and freeze().
> - Remove the broken-state shortcut from the host-completion wait so the
>   submitter never reads an uninitialized response field.
> - Keep the raw broken-virtqueue dmesg in 7/8 while updating the teardown
>   rationale.
> - Renumber the old virtio-pmem fixes after the new pmem PREFLUSH patch.
> v3->v4:
> - Rebased the series onto v7.1-rc7 so it applies cleanly to Linux 7.1-rc7.
> - Update the allocation site in 6/7 from kmalloc(sizeof(*req_data),
>   GFP_KERNEL) to kmalloc_obj(*req_data) to match current nvdimm code.
> - Add 1/7 to preserve provider flush callback errors in nvdimm_flush().
> - Include the GFP_NOIO child flush bio allocation fix as 2/7.
> - Renumber the old request lifetime and broken virtqueue fixes after the two
>   new flush error patches.
> v2->v3:
> - Split patch 1 as suggested by Pankaj Gupta: keep the waiter wakeup
>   ordering change in 1/5 and move READ_ONCE()/WRITE_ONCE() updates to
>   2/5 (no functional change intended).
> - Add log report to commit msg.
> - Fold the export fix into 4/5 to keep the series bisectable when
>   CONFIG_VIRTIO_PMEM=m.
> v1->v2:
> - Add the export patch to fix compile issue.
>
> Links:
> v6: https://lore.kernel.org/all/20260621130246.2973254-1-me@linux.beauty/
> v5: https://lore.kernel.org/all/20260617122442.2118957-1-me@linux.beauty/
> v4: https://lore.kernel.org/all/20260609120726.1714780-1-me@linux.beauty/
> v3: https://lore.kernel.org/all/20260226025712.2236279-1-me@linux.beauty/#t
> v2: https://lore.kernel.org/all/20251225042915.334117-1-me@linux.beauty/
> v1: https://www.spinics.net/lists/kernel/msg5974818.html
>
> Li Chen (12):
>   nvdimm: preserve flush callback -ENOMEM
>   nvdimm: pmem: keep PREFLUSH before data writes
>   nvdimm: pmem: guard data loop for dataless bios
>   nvdimm: virtio_pmem: stop allocating child flush bio
>   nvdimm: virtio_pmem: use GFP_NOIO for flush requests
>   nvdimm: virtio_pmem: always wake -ENOSPC waiters
>   nvdimm: virtio_pmem: use READ_ONCE()/WRITE_ONCE() for wait flags
>   nvdimm: virtio_pmem: refcount requests for token lifetime
>   nvdimm: virtio_pmem: publish done with release/acquire
>   nvdimm: virtio_pmem: isolate DMA request buffers
>   nvdimm: virtio_pmem: converge broken virtqueue to -EIO
>   nvdimm: virtio_pmem: drain requests in freeze
>
>  drivers/nvdimm/nd_virtio.c   | 265 +++++++++++++++++++++++++++++------
>  drivers/nvdimm/pmem.c        |  51 ++++---
>  drivers/nvdimm/region_devs.c |   5 +-
>  drivers/nvdimm/virtio_pmem.c |  65 ++++++++-
>  drivers/nvdimm/virtio_pmem.h |  22 ++-
>  include/linux/libnvdimm.h    |   9 ++
>  6 files changed, 343 insertions(+), 74 deletions(-)
>
> --
> 2.52.0
