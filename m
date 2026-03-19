Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1051396B82
	for <nvdimm@lists.linux.dev>; Thu, 19 Mar 2026 17:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773941950; cv=none; b=VHR2hgm60FRQElSOcM5OB4Vaee1zvVZMD0IPQMXcauFEIfg2GKVUwr79j5kjeMV6SQdutc++h+dx1iVTpyN7urhOBt3XKnIcNlhHFmTaI+ba+RTkv59aB16iQ9ZK0hXqHoxoKHs43tAQ4NrBGZH1v4aSbgC767TUsVu7gSGu0mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773941950; c=relaxed/simple;
	bh=OBNBopEDwqEITTfGruxSscWktYZMAR7NrsAvengxHqw=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=mMOKPvMvDAw0FpFf2PawZXrCemxzb7t6nQ2O7U7wd7EKWa7NILJWWV3/DEbVxTw/E9E9CL/gQj1ueGFkmVikQgDIR3I/QPtorJeMURGOJ51w1sGaZhSslHEBEgGYAZAgTxR5rrt0oW0Hd0IX3mIlbhsryIgL746JpVrw3kO9M/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ae3dDZ6O; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ae3dDZ6O"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-8cb4136d865so164432285a.1
        for <nvdimm@lists.linux.dev>; Thu, 19 Mar 2026 10:39:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773941943; x=1774546743; darn=lists.linux.dev;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AoYAAUxRmz2MQbYoshelo0W4hUE3gNUYOZq1MaQMI3I=;
        b=ae3dDZ6O1DsZXWN4KXqKSiw170ljKQyqRLdJQdjYptYL0xXU6a/XNCEu8K3KRtGbnP
         gDargaIfOXqzbzgaNKWYyiU2SMhuMNVuuNdu43ux9t8j/cgwkz8OIVE8VXksGyB4P2yn
         Xdo222YWqvjj5avSyRZ6v5HMQBbBcp9q4cqnuBTuHveEZN8IXnhaCI+QmxRzLURJqhBq
         P1FXMK7D3kKrHMPhtucCpHOdDlMC16qc5PFyeopGxWZQ1ZPtUi4eilpQ8bWHSFQqSdfc
         qaNTRHtUXNp1RwRBV4T/HB8cfx8csod35l3nJUvE1qKOW+pNtDXNMmaja687ZRugksVW
         8eXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773941943; x=1774546743;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AoYAAUxRmz2MQbYoshelo0W4hUE3gNUYOZq1MaQMI3I=;
        b=nBz+I/zvqbQZjZHrnzceMMQgLAtImSlx3817U02yM4Y6SJAGB+pcP1TzLLmiQFZ788
         soRFo9IncKOXtpObyrk4znHkIlgnHLGJLuAgGlITVo1Z1BYWoTRt2C6HtmVjc1lfWGtx
         B0nFr1Aeq4VgqZ76f0+lWURx+FazJCOtMpOaAj/F/+o9pqC34N6Ku3MlrdND/r8Wx6Jr
         yIultIcBSLTzOgaYIneYIz2F/UOmbo191o8khJxJSnCn7Gjtkwslq2KOGYbyL2eq4aQw
         zj5W2fAOnzP5P7JYVrOLRI8DqULVcRedFcyUZpo5hivJof/VrqfL2h1Lg/8HLnz6HdIJ
         gMjA==
X-Gm-Message-State: AOJu0YyAfZeRLZQBWH0QXwcKDdF+fqNFMH+cheTOAyFpMM/93mgY/C5s
	JUAUSK8fQiIKh4AOJirqyBVkXIzLnemPOG4Tj6rWtBRStDXEOTLftwBj9wOELp9p
X-Gm-Gg: ATEYQzygRpaiJhfXW9gSiJtG7jSGTKmjKUTF8p6U8/lOlWa8LTAgH185NdKKRCvtcLr
	ukfxSd57l/nHD+Pw37Jf64gnDXVIafNUPJ8Uho7Zrud3sAWqRTgmiCuz4PW9GRIxGYkiWtffK/V
	/QcbYZNLyUgT2RjhPcS7fmULbAmVfT1YGF+XZOVJ9pkUiB9NEHF0foXC2fWxP8uzZvEO6rXuGkL
	hEhYswKLgDTieUd55EuRs0dD4G/ieexIcA0qY0ZwoLxQ769GWUtLjoUhSHeVB0pXEggVYTwLHG3
	1HnPuU5QltL+qHDA5UF8COLTsi0/0suH5AlHiEkMG94vLkhx8w3xrwp/G750Qv1epqu2eIcBVCG
	JF+N+5buMwGTx20XABj727yc5bKZIHowEAdg7voG9NI2s/zjme5Srd2mMKHBgtS9NOkTbDrwwzz
	dulY24jZmJpQmkSes52e1ybSbSUHAD6pM=
X-Received: by 2002:a05:620a:2845:b0:8cd:75d9:f110 with SMTP id af79cd13be357-8cfc7b77a8cmr20251785a.12.1773941942836;
        Thu, 19 Mar 2026 10:39:02 -0700 (PDT)
Received: from [104.39.41.64] ([104.39.41.64])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cfad162839sm472740285a.25.2026.03.19.10.39.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Mar 2026 10:39:02 -0700 (PDT)
Message-ID: <44ac97fc-94b0-4de9-9a4c-ced9df89eeb5@gmail.com>
Date: Thu, 19 Mar 2026 13:39:01 -0400
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, vishal.l.verma@intel.com, dave.jiang@intel.com,
 ira.weiny@intel.com, shuangpeng.kernel@gmail.com
From: Dingisoul <dingiso.kernel@gmail.com>
Subject: [BUG]: KASAN: slab-use-after-free in nfit_handle_mce on commit
 8a30aeb0d1b4e4aaf7f7bae72f20f2ae75385ccb
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Kernel maintainers,
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
(2) Boot Kernel with the following QEMU options:
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
[T9] BUG: KASAN: slab-use-after-free in nfit_handle_mce 
(drivers/acpi/nfit/mce.c:36 (discriminator 512))
[T9] Read of size 8 at addr ffff88810aa99140 by task kworker/0:0/9
[T9]
[T9] CPU: 0 UID: 0 PID: 9 Comm: kworker/0:0 Tainted: G M 
7.0.0-rc4-00091-g8a30aeb0d1b4-dirty #56 PREEMPT(full)
[T9] Tainted: [M]=MACHINE_CHECK
[T9] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 
1.16.3-debian-1.16.3-2 04/01/2014
[T9] Workqueue: events mce_gen_pool_process
[T9] Call Trace:
[T9] <TASK>
[T9] dump_stack_lvl (lib/dump_stack.c:122)
[T9] print_report (mm/kasan/report.c:379 (discriminator 3) 
mm/kasan/report.c:482 (discriminator 3))
[T9] kasan_report (mm/kasan/report.c:597)
[T9] nfit_handle_mce (drivers/acpi/nfit/mce.c:36 (discriminator 512))
[T9] notifier_call_chain (kernel/notifier.c:85 (discriminator 512))
[T9] blocking_notifier_call_chain (kernel/notifier.c:380)
[T9] mce_gen_pool_process (arch/x86/kernel/cpu/mce/genpool.c:88)
[T9] process_scheduled_works (kernel/workqueue.c:? kernel/workqueue.c:3359)
[T9] worker_thread (kernel/workqueue.c:?)
[T9] kthread (kernel/kthread.c:438)
[T9] ret_from_fork (arch/x86/kernel/process.c:164)
[T9] ret_from_fork_asm (arch/x86/entry/entry_64.S:255)
[T9] </TASK>
[T9]
[T9] Freed by task 8283:
[T9] kasan_save_track (mm/kasan/common.c:58 mm/kasan/common.c:78)
[T9] kasan_save_free_info (mm/kasan/generic.c:587)
[T9] __kasan_slab_free (mm/kasan/common.c:287)
[T9] kfree (mm/slub.c:6165 (discriminator 256) mm/slub.c:6483 
(discriminator 256))
[T9] tomoyo_supervisor (security/tomoyo/common.c:?)
[T9] tomoyo_env_perm (security/tomoyo/environ.c:65 (discriminator 1))
[T9] tomoyo_find_next_domain (security/tomoyo/domain.c:673 
security/tomoyo/domain.c:889)
[T9] tomoyo_bprm_check_security (security/tomoyo/tomoyo.c:102)
[T9] security_bprm_check (security/security.c:?)
[T9] bprm_execve (fs/exec.c:1654 fs/exec.c:1696 fs/exec.c:1748)
[T9] do_execveat_common (fs/exec.c:?)
[T9] __x64_sys_execve (fs/exec.c:1930 fs/exec.c:1924 fs/exec.c:1924)
[T9] do_syscall_64 (arch/x86/entry/syscall_64.c:?)
[T9] entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)
[T9]
[T9] The buggy address belongs to the object at ffff88810aa99000
[T9] which belongs to the cache kmalloc-1k of size 1024
[T9] The buggy address is located 320 bytes inside of
[T9] freed 1024-byte region [ffff88810aa99000, ffff88810aa99400)
We provide more detailed analysis in the following link.
Link: https://gist.github.com/dingiso/ff78e4b30d7abe09e2e15235672e06c6

