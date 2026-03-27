Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D5436C0B7
	for <nvdimm@lists.linux.dev>; Fri, 27 Mar 2026 03:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774581869; cv=none; b=YmJf6mEF18I6hFLmi+MP78LeZ3cqa1bZIurzwc4bgm4BnnN6vYP9Mgkx8gkHWqfoowjkser7rPLAX1j1wKRMsV2E3vMV1kX1Z6XGCwcIDlab4R5EJslV2ggWLe3oe9DAmGt8DIH1Bij2XKY2jNfkGL85Yb1GMGgqy505xsEMuOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774581869; c=relaxed/simple;
	bh=3JVEKgA80CFZwIEFguUQuwoInivzH5amCkY3ZpVRG9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qSTF86nNqoD+Id3lPFkTwGhsY7Dm8307QZVtJ5IJRXgW87x5tVqbxxFg+SqMSorgL8zCklxGPUuJQrsnY8RHnLseVEbzG2KKXGtIp1l/0RSDqHuafzYsiD+mDR9iq/WexUdjVnlk/6aZUGNAS0cWM1B2wtP56KPBh+RZ6UGLpSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oRcG6aqW; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oRcG6aqW"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-899ee87355dso19956846d6.1
        for <nvdimm@lists.linux.dev>; Thu, 26 Mar 2026 20:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774581866; x=1775186666; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=APNcWBF1zdjoXXcBFoi+jI8GnhV8yQY/AZvyCyTERJs=;
        b=oRcG6aqWWXOgROQRxCBTCtRD6AIuvD+qxMzcKLVED+2LDt2O1I2iOKXZqI8YXl1YBQ
         BvgPG+6SX61YefwefQG9KgD+fclWKhyuAEiKiGsVj5GfKC3PlGTSbmbmfH9ft7CDmAWs
         2BhhUcmiLaxAqxlu1iWPqKANYppSm3Zi/jMg9D8g5Y/qNE791uECL2mft4T819zWK99L
         oiTNXYjnzW+N71PpIx1WYqDVWEjma8otE22gB7n01cRC1osG3ivYbxQD8ebnvCZcdU06
         rvzjJUws+AbhO67KinKktoftzX/jJqbdVW1c4LrdoQah4xE2deH1yrgeP5MO4Z1NE83l
         sWbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774581866; x=1775186666;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=APNcWBF1zdjoXXcBFoi+jI8GnhV8yQY/AZvyCyTERJs=;
        b=VLVNk5pquOrm90TAEj0gUFiSxnO5100Aebgu1f38Gh7Jqfk1iASWc5VM47h+GaM8Y3
         GSEUKxcnGVgdXFiSaRTB3YbmRMCKX8X/O8a8dEUM7Oc5a0R5tptU+gb0PXw2GThJua++
         4u9aDLp5AtMzCpsJKQWk47VwlFub6NZPU0ojwbr9XXwasC+X34UADk+vRAZLbHAsrR6H
         PcRvD6qO+UVHj7Kn2jweHqOrP6vfRF6HduqCWfo3RfhC1ZevJ0gVrGZNi8Q2Y4dNsYkN
         9GAGh54pdHfkJDpukDAthkHnTcuSCRLtAmUlONbzJnUClef8qhVlq5WtEuVBE2SDNuWj
         ygxw==
X-Forwarded-Encrypted: i=1; AJvYcCVfOy47QkrRHKP2qh4bNg1eT658e8LZ7mn+Y4nxb/oeBoP6zI76UuGedtc+5fDTtja5m8pBEMk=@lists.linux.dev
X-Gm-Message-State: AOJu0YxWH1JCDpSMUDaQqcEkvER3/phP4RIja/cBQMIrxdsTDTLW3WEb
	1sVhE2EDdtIbl+gbAml2Ev1g54P2S58QnFyFpLrroG1+vkh/qCgnTqR5
X-Gm-Gg: ATEYQzycLSmIaMENMWDukKcHoVRj3TZWZVZd+ZOoVRA3poJ28com3krV86WxHZsvz3w
	V+A/mf8RIQ85gAoqC+XB9ijexjQz9RfG3lnAx/EhQdFaDEFFYEgvReanhme4K/P0Ylkzy58QkMx
	h7hqQMHiyBP/QYqZRaOTTPyQ23Kw2OfAbet82qb+ssRuYfeKnnhSUQCHZsj+kULtdp7xDi6KoKc
	KuJHvQ9Xuow+8C8LJU2p1Z43DoFYOBTNQpHUNmRnSHOr+c1OGu0EB3x+c4k/y9/1gkwCwqqb0WP
	Jj8LHEPo6Y+pnHEVujnm+dJliD3ZngkGroc1FS0SiKngPkJORvFv8TQnf4Kn5ofsnbeAP64IT0m
	rFngT8jfHEwrBclcgLJ6eIIJCivZ9W3dDCtFucA0hrdjyRg6tJeJ7uSHbW5ZVxmhled7ICRarCs
	WwP+ilQNM=
X-Received: by 2002:a05:622a:1145:b0:50b:5130:e35f with SMTP id d75a77b69052e-50ba37d191fmr12559711cf.8.1774581866008;
        Thu, 26 Mar 2026 20:24:26 -0700 (PDT)
Received: from ArchTX ([2601:985:4c81:db00::774c])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89cd5a804absm40335056d6.40.2026.03.26.20.24.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 20:24:25 -0700 (PDT)
From: Dingisoul <dingiso.kernel@gmail.com>
To: dingiso.kernel@gmail.com
Cc: dan.j.williams@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	nvdimm@lists.linux.dev,
	shuangpeng.kernel@gmail.com,
	vishal.l.verma@intel.com
Subject: Re: [BUG]: KASAN: slab-use-after-free in nfit_handle_mce on commit 8a30aeb0d1b4e4aaf7f7bae72f20f2ae75385ccb
Date: Thu, 26 Mar 2026 23:24:11 -0400
Message-ID: <20260327032411.1298365-1-dingiso.kernel@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <44ac97fc-94b0-4de9-9a4c-ced9df89eeb5@gmail.com>
References: <44ac97fc-94b0-4de9-9a4c-ced9df89eeb5@gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Kernel maintainers,

We realized that our previous report was in bad format,
so we provide a good version.

We provide more detailed analysis in the following link.
Link: https://gist.github.com/dingiso/ff78e4b30d7abe09e2e15235672e06c6

Our tool found a new kernel bug KASAN: slab-use-after-free in
nfit_handle_mce on commit 8a30aeb0d1b4e4aaf7f7bae72f20f2ae75385ccb
(Mar 18 2026).

We observe such an error-triggering path.

1.__nvdimm_create fails (e.g., -ENOMEM on nvdimm allocation).

2.A dangling pointer remains in the acpi_descs list
after the error code is passed through the call chain:

   (1) __nvdimm_create
   (2) acpi_nfit_register_dimms
   (3) acpi_nfit_init
      Add acpi_desc into acpi_descs list
   (4) acpi_nfit_probe
      Callback function acpi_nfit_shutdown is not set
   (5) call_driver_probe
   (6) really_probe
      Free acpi_desc but not remove it from list due to
      the missing callback function acpi_nfit_shutdown
      
3.A UAF occurs on acpi_desc in nfit_handle_mce:

   When iterate the acpi_descs list, the freed acpi_desc has
   been accessed, causing use-after-free in our test. The
   operation can be invoked by injecting a machine check error.
   
Reproduction Steps:

1.Environment:
   (1) Build Kernel with:
      CONFIG_X86_MCE_INJECT=y
      CONFIG_MEMORY_FAILURE=y
      CONFIG_ACPI_APEI_MEMORY_FAILURE=y
   (2) Inject allocation failure:
      Set nvdimm=NULL in __nvdimm_create to
      simulate -ENOMEM.
   (3) Boot Kernel with the following QEMU options:
      -machine pc,nvdimm=on \
      -smp 1 \
      -object memory-backend-ram,id=mem1,size=1G \
      -device nvdimm,id=nvdimm1,memdev=mem1 \
      -monitor telnet:127.0.0.1:10710,server,nowait \
      
2.Trigger use-after-free:

   (1) Get nvdimm memory range: dmesg | grep non-volatile
      (Output: ACPI: SRAT: Node 0 PXM 0
      [mem 0x2c0000000-0x2ffffffff] non-volatile)
   (2) Inject machine check error via QEMU monitor to this range:
      mce 0 8 0xbd00000000000090 0x5 0x2c0000000 0x80

After these steps, the bug can be stably triggered in QEMU,
generating the following KASAN report: 

[T9] ==================================================================
[T9] BUG: KASAN: slab-use-after-free in nfit_handle_mce (drivers/acpi/nfit/mce.c:36 (discriminator 512))
[T9] Read of size 8 at addr ffff88810aa99140 by task kworker/0:0/9
[T9]
[T9] CPU: 0 UID: 0 PID: 9 Comm: kworker/0:0 Tainted: G M 7.0.0-rc4-00091-g8a30aeb0d1b4-dirty #56 PREEMPT(full)
[T9] Tainted: [M]=MACHINE_CHECK
[T9] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[T9] Workqueue: events mce_gen_pool_process
[T9] Call Trace:
[T9]  <TASK>
[T9]  dump_stack_lvl (lib/dump_stack.c:122)
[T9]  print_report (mm/kasan/report.c:379 (discriminator 3) mm/kasan/report.c:482 (discriminator 3))
[T9]  kasan_report (mm/kasan/report.c:597)
[T9]  nfit_handle_mce (drivers/acpi/nfit/mce.c:36 (discriminator 512))
[T9]  notifier_call_chain (kernel/notifier.c:85 (discriminator 512))
[T9]  blocking_notifier_call_chain (kernel/notifier.c:380)
[T9]  mce_gen_pool_process (arch/x86/kernel/cpu/mce/genpool.c:88)
[T9]  process_scheduled_works (kernel/workqueue.c:? kernel/workqueue.c:3359)
[T9]  worker_thread (kernel/workqueue.c:?)
[T9]  kthread (kernel/kthread.c:438)
[T9]  ret_from_fork (arch/x86/kernel/process.c:164)
[T9]  ret_from_fork_asm (arch/x86/entry/entry_64.S:255)
[T9]  </TASK>
[T9]
[T9] Freed by task 8283:
[T9]  kasan_save_track (mm/kasan/common.c:58 mm/kasan/common.c:78)
[T9]  kasan_save_free_info (mm/kasan/generic.c:587)
[T9]  __kasan_slab_free (mm/kasan/common.c:287)
[T9]  kfree (mm/slub.c:6165 (discriminator 256) mm/slub.c:6483 (discriminator 256))
[T9]  tomoyo_supervisor (security/tomoyo/common.c:?)
[T9]  tomoyo_env_perm (security/tomoyo/environ.c:65 (discriminator 1))
[T9]  tomoyo_find_next_domain (security/tomoyo/domain.c:673 security/tomoyo/domain.c:889)
[T9]  tomoyo_bprm_check_security (security/tomoyo/tomoyo.c:102)
[T9]  security_bprm_check (security/security.c:?)
[T9]  bprm_execve (fs/exec.c:1654 fs/exec.c:1696 fs/exec.c:1748)
[T9]  do_execveat_common (fs/exec.c:?)
[T9]  __x64_sys_execve (fs/exec.c:1930 fs/exec.c:1924 fs/exec.c:1924)
[T9]  do_syscall_64 (arch/x86/entry/syscall_64.c:?)
[T9]  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)
[T9]
[T9] The buggy address belongs to the object at ffff88810aa99000
[T9]  which belongs to the cache kmalloc-1k of size 1024
[T9] The buggy address is located 320 bytes inside of
[T9]  freed 1024-byte region [ffff88810aa99000, ffff88810aa99400)

