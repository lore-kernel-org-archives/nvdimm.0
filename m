Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30CE2D052
	for <nvdimm@lists.linux.dev>; Thu, 13 Mar 2025 02:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741834031; cv=none; b=EjQV9bL8i9pTpT7A30tCiUFiDEYEbNAzzUzzjJGoKjv1AhwyNDvxvjHcf3WpzxEEsuLZ9cpZgjEGHXAKSkf8wmZTojt5/1PYgyzS0VC2AdYhksFUnxcda0+1qZsQ3XdDQ1BxJTf6zTxGPx1fY5JTQ3sB0Z9xH9SOBAHg8ahDCfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741834031; c=relaxed/simple;
	bh=ELFZe7lhaCxRbpqEpAU0zbghCa5/WRiGSpa2Yd8fVWI=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=u0okf7d0IEw03HqIkGFkgywfESUC0j3GLvxAvGWBGwmQHmOG/WmBfLx7HPo86g9OH4bw7fJjS5TyP/qHVxiPJ1tCsZ+POcENZuhNLZYvKM/nNf03pHhJ03hAShV+hYoxCZYVJ/8HRZ1nXe/R2XHTq5hHdeqFPdRzAAmTxVOIqoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b0RP/56S; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b0RP/56S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741834028;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=KniLTzFjzd4ddWnC+dd/vsIrKHeWNIk8LATVGcIXR4Y=;
	b=b0RP/56SmLwc3/7VYz4nuy7HUCQE+npC+djC/X3MRc99aifj60uvmnCQILbxF3zqogh5md
	lSJnYqwzD8yT8I2oADVGwe3aciw5MxlUyoYG/1wvEXyDZzc4orVuSFVvMMsQF5zEq7W7uN
	WTnRfMn4LRlpj/Ae8kKJF50NWFOHZdk=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-651-nRWRsyyLNkmkY5Yl1FLvNA-1; Wed, 12 Mar 2025 22:47:07 -0400
X-MC-Unique: nRWRsyyLNkmkY5Yl1FLvNA-1
X-Mimecast-MFC-AGG-ID: nRWRsyyLNkmkY5Yl1FLvNA_1741834026
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-30bfee3663dso2689851fa.0
        for <nvdimm@lists.linux.dev>; Wed, 12 Mar 2025 19:47:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741834025; x=1742438825;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KniLTzFjzd4ddWnC+dd/vsIrKHeWNIk8LATVGcIXR4Y=;
        b=v08630VGSmTx6Fkzw2dHtvqIYwd1Kzy4v59DV5h1ASddEU9J7ZVtp6RcSdcwgO4P7f
         C/OTPF34U0CKIhFUdjWnGTn4//YJkAxacAPT12Ykx7lSVYF335BJUm8OsE5s+sToS+Hb
         sY2x6LUiVH3Wmtaq8WmamkVyYtAXQ+bNSKMxDNqC9gPAlDwCXskobFMM0OR6lLi3it6V
         OADIxKx275dJNvv4uW/RzISFSXZhZzlO3CovrBkQfdDzvgus9E/+bASIAF6rghPcflV+
         mTLbNF/NPNsmuKpDNIujYJQJRe+qaa4plDf+l+iuy+io6iOkYvB7PQ5RbY6fmSW+Muz1
         /iAQ==
X-Forwarded-Encrypted: i=1; AJvYcCU7W663hLRZFXnDn9JpRR55PimjQJj6q19yC+ZmEdNoAH2Ybnrjdl4mOMSTZqsJz/Z2gMwOw+s=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz6nxcejGhj6yWRftlyRw+lmTQ5rk7ZyAPghsVfelyjELVbilS6
	/0xV8VXBTmOtyXR8fsxpwyro40NTKk/QZyT71Olf50661YwnmJ0Z8GqGWlZoA+qcAXVyRDHUYPY
	wjRQcYEbBrTxmkXyM5kzJ/bNqVmuINXScj8VDJo7NPev6nCEnifQYxhlRqsTNh0divzB3tPla6w
	JinGN7cOQbiTkKHBXnAHLbrNXmtTZu
X-Gm-Gg: ASbGnctLHTeNEy7OEW/h1SuEDdIzTjV2Q//FOMd6lP7T/ZLhBhPC1JS35Xgz+j3Chpc
	b8HAAFq1m3R/sxvM2YYCiVDEfM8v3zZcVkINL8LvNobNyrgOcLCjCNZGDgkl8H1Euh9z7ZSalbg
	==
X-Received: by 2002:a2e:a589:0:b0:30c:12b8:fb97 with SMTP id 38308e7fff4ca-30c3dda5b05mr2727301fa.11.1741834025211;
        Wed, 12 Mar 2025 19:47:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEOZx2IYnuA3hxCyR1GCVzDMYxqgPBQkh2I/RIsm8eY80u8MXOI40FfQVXmSQSBBzgqTFzvxz0sllnLhZ/Qp9s=
X-Received: by 2002:a2e:a589:0:b0:30c:12b8:fb97 with SMTP id
 38308e7fff4ca-30c3dda5b05mr2727191fa.11.1741834024731; Wed, 12 Mar 2025
 19:47:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Yi Zhang <yi.zhang@redhat.com>
Date: Thu, 13 Mar 2025 10:46:53 +0800
X-Gm-Features: AQ5f1JpDuJh7u9w-1G2EvkcH5NuUtg7s0kuBLSyGXjLH_mbV4vQbkqkR_ttui0Y
Message-ID: <CAHj4cs_=H8CcFGaup0ufDQtqh3cX+CCdyGUAGbyhmGBpdaz6PQ@mail.gmail.com>
Subject: [bug report] ndctl test suite daxctl-create.sh triggered RIP: 0010:memset_orig+0x33/0xb0
To: linux-cxl@vger.kernel.org, Linux NVDIMM <nvdimm@lists.linux.dev>
Cc: Alison Schofield <alison.schofield@intel.com>, Dan Williams <dan.j.williams@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9O-4TnjuZ6fVSjBUsO8vR2ObcxcsFiimul86fVVQkh8_1741834026
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"

Hello

I found this issue during ndctl test suite with the latest linux tree,
please help check it and let me know if you need any test/info for it,
thanks.

[10965.316927] platform cxl_host_bridge.0: Unsupported platform
config, mixed Virtual Host and Restricted CXL Host hierarchy.
[10965.329017] platform cxl_host_bridge.1: Unsupported platform
config, mixed Virtual Host and Restricted CXL Host hierarchy.
[10965.340303] platform cxl_host_bridge.2: Unsupported platform
config, mixed Virtual Host and Restricted CXL Host hierarchy.
[10965.351526] platform cxl_host_bridge.3: Unsupported platform
config, mixed Virtual Host and Restricted CXL Host hierarchy.
[10965.369323] platform cxl_host_bridge.0: Unsupported platform
config, mixed Virtual Host and Restricted CXL Host hierarchy.
[10965.386839] platform cxl_host_bridge.0: host supports CXL
[10965.392520] platform cxl_host_bridge.1: Unsupported platform
config, mixed Virtual Host and Restricted CXL Host hierarchy.
[10965.410048] platform cxl_host_bridge.1: host supports CXL
[10965.415885] platform cxl_host_bridge.2: Unsupported platform
config, mixed Virtual Host and Restricted CXL Host hierarchy.
[10965.434115] platform cxl_host_bridge.2: host supports CXL
[10965.439528] platform cxl_host_bridge.3: host supports CXL (restricted)
[10965.520762] kmem dax3.0: mapping0: 0x3ff010000000-0x3ff02fffffff
too small after alignment
[10965.529291] kmem dax3.0: rejecting DAX region without any memory
after alignment
[10965.536704] kmem dax3.0: probe with driver kmem failed with error -22
[10966.419131] BUG: unable to handle page fault for address: ffffeaffc0400000
[10966.426011] #PF: supervisor write access in kernel mode
[10966.431234] #PF: error_code(0x0002) - not-present page
[10966.436374] PGD 0 P4D 0
[10966.438913] Oops: Oops: 0002 [#1] PREEMPT SMP KASAN NOPTI
[10966.444315] CPU: 1 UID: 0 PID: 21254 Comm: daxctl Tainted: G
   O       6.14.0-rc6+ #2
[10966.452832] Tainted: [O]=OOT_MODULE
[10966.456323] Hardware name: Dell Inc. PowerEdge R640/06NR82, BIOS
2.22.2 09/12/2024
[10966.463891] RIP: 0010:memset_orig+0x33/0xb0
[10966.468084] Code: b6 ce 48 b8 01 01 01 01 01 01 01 01 48 0f af c1
41 89 f9 41 83 e1 07 75 70 48 89 d1 48 c1 e9 06 74 35 0f 1f 44 00 00
48 ff c9 <48> 89 07 48 89 47 08 48 89 47 10 48 89 47 18 48 89 47 20 48
89 47
[10966.486831] RSP: 0018:ffffc90005ddf3a8 EFLAGS: 00010216
[10966.492055] RAX: ffffffffffffffff RBX: 0000000000200000 RCX: 0000000000007fff
[10966.499189] RDX: 0000000000200000 RSI: 00000000ffffffff RDI: ffffeaffc0400000
[10966.506320] RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
[10966.513453] R10: ffffeaffc0400000 R11: 0000000000000000 R12: 000000000007fe02
[10966.520584] R13: 0000000000000ffc R14: 0000000000007fe0 R15: 00000003ff010000
[10966.527717] FS:  00007f59922b97c0(0000) GS:ffff88901f400000(0000)
knlGS:0000000000000000
[10966.535802] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[10966.541551] CR2: ffffeaffc0400000 CR3: 000000032ed88006 CR4: 00000000007726f0
[10966.548680] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[10966.555813] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[10966.562947] PKRU: 55555554
[10966.565658] Call Trace:
[10966.568112]  <TASK>
[10966.570217]  ? show_trace_log_lvl+0x1b0/0x2f0
[10966.574577]  ? show_trace_log_lvl+0x1b0/0x2f0
[10966.578938]  ? sparse_add_section+0x2e6/0x740
[10966.583297]  ? __die_body.cold+0x8/0x12
[10966.587136]  ? page_fault_oops+0x15e/0x1e0
[10966.591235]  ? __pfx_page_fault_oops+0x10/0x10
[10966.595678]  ? search_bpf_extables+0x168/0x260
[10966.600128]  ? exc_page_fault+0x10c/0x120
[10966.604138]  ? asm_exc_page_fault+0x26/0x30
[10966.608327]  ? memset_orig+0x33/0xb0
[10966.611903]  sparse_add_section+0x2e6/0x740
[10966.616091]  ? __pfx_sparse_add_section+0x10/0x10
[10966.620797]  __add_pages+0x1ca/0x290
[10966.624374]  add_pages+0x52/0x1c0
[10966.627693]  pagemap_range+0x4ec/0x1070
[10966.631534]  ? __pfx_dev_pagemap_percpu_release+0x10/0x10
[10966.636932]  ? percpu_ref_init+0x12c/0x330
[10966.641031]  memremap_pages+0x2eb/0x700
[10966.644870]  ? __pfx_memremap_pages+0x10/0x10
[10966.649232]  ? __pfx_get_nfit_res+0x10/0x10 [nfit_test_iomap]
[10966.654984]  ? trace_irq_enable.constprop.0+0x151/0x1c0
[10966.660210]  devm_memremap_pages+0x45/0x90
[10966.664309]  dev_dax_probe+0x296/0xa90 [device_dax]
[10966.669188]  ? __pfx___up_read+0x10/0x10
[10966.673117]  dax_bus_probe+0x106/0x1e0
[10966.676874]  ? driver_sysfs_add+0xfc/0x290
[10966.680976]  really_probe+0x1e0/0x8a0
[10966.684641]  __driver_probe_device+0x18c/0x370
[10966.689086]  driver_probe_device+0x4a/0x120
[10966.693273]  __driver_attach+0x194/0x4a0
[10966.697199]  ? __pfx___driver_attach+0x10/0x10
[10966.701642]  bus_for_each_dev+0x106/0x190
[10966.705657]  ? __pfx_bus_for_each_dev+0x10/0x10
[10966.710191]  do_id_store+0x14c/0x4c0
[10966.713769]  ? __pfx_do_id_store+0x10/0x10
[10966.717870]  ? __pfx_sysfs_kf_write+0x10/0x10
[10966.722235]  kernfs_fop_write_iter+0x39f/0x5a0
[10966.726683]  vfs_write+0x5fa/0xe90
[10966.730087]  ? __pfx_vfs_write+0x10/0x10
[10966.734016]  ? rcu_is_watching+0x15/0xb0
[10966.737947]  ksys_write+0xfa/0x1d0
[10966.741352]  ? __pfx_ksys_write+0x10/0x10
[10966.745368]  do_syscall_64+0x92/0x180
[10966.749032]  ? __x64_sys_openat+0x109/0x1d0
[10966.753216]  ? __pfx___x64_sys_openat+0x10/0x10
[10966.757749]  ? rcu_is_watching+0x15/0xb0
[10966.761675]  ? trace_irq_enable.constprop.0+0x151/0x1c0
[10966.766902]  ? syscall_exit_to_user_mode+0x82/0x250
[10966.771781]  ? do_syscall_64+0x9e/0x180
[10966.775619]  ? __x64_sys_getdents64+0x157/0x240
[10966.780151]  ? __pfx___x64_sys_getdents64+0x10/0x10
[10966.785030]  ? rcu_is_watching+0x15/0xb0
[10966.788958]  ? __pfx_filldir64+0x10/0x10
[10966.792884]  ? rcu_is_watching+0x15/0xb0
[10966.796808]  ? trace_irq_enable.constprop.0+0x151/0x1c0
[10966.802035]  ? syscall_exit_to_user_mode+0x82/0x250
[10966.806913]  ? do_syscall_64+0x9e/0x180
[10966.810752]  ? syscall_exit_to_user_mode+0x82/0x250
[10966.815633]  ? do_syscall_64+0x9e/0x180
[10966.819472]  ? __pfx___call_rcu_common.constprop.0+0x10/0x10
[10966.825133]  ? rcu_is_watching+0x15/0xb0
[10966.829055]  ? trace_irq_enable.constprop.0+0x151/0x1c0
[10966.834282]  ? syscall_exit_to_user_mode+0x82/0x250
[10966.839163]  ? clear_bhb_loop+0x25/0x80
[10966.842999]  ? clear_bhb_loop+0x25/0x80
[10966.846840]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[10966.851893] RIP: 0033:0x7f5992562e14
[10966.855489] Code: c7 00 16 00 00 00 b8 ff ff ff ff c3 66 2e 0f 1f
84 00 00 00 00 00 f3 0f 1e fa 80 3d 95 d2 0d 00 00 74 13 b8 01 00 00
00 0f 05 <48> 3d 00 f0 ff ff 77 54 c3 0f 1f 00 48 83 ec 28 48 89 54 24
18 48
[10966.874233] RSP: 002b:00007ffee3bc0118 EFLAGS: 00000202 ORIG_RAX:
0000000000000001
[10966.881800] RAX: ffffffffffffffda RBX: 00007ffee3bc06a8 RCX: 00007f5992562e14
[10966.888931] RDX: 0000000000000007 RSI: 00000000042fcd86 RDI: 0000000000000004
[10966.896064] RBP: 00007ffee3bc0150 R08: 0000000000000073 R09: 00000000ffffffff
[10966.903198] R10: 00007f59926b4370 R11: 0000000000000202 R12: 0000000000000000
[10966.910330] R13: 00007ffee3bc06e0 R14: 00007f59926ef000 R15: 0000000000414d78
[10966.917467]  </TASK>
[10966.919653] Modules linked in: cxl_test(O) cxl_mem(O) cxl_pmem(O)
cxl_acpi(O) cxl_port(O) dax_pmem(O) nd_pmem(O) device_dax(O) dax_cxl
cxl_mock_mem(O) cxl_mock(O) cxl_core(O) einj ext4 mbcache jbd2 kmem
rfkill sunrpc intel_rapl_msr intel_rapl_common intel_uncore_frequency
intel_uncore_frequency_common skx_edac skx_edac_common
x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm iTCO_wdt
dell_pc iTCO_vendor_support rapl ipmi_ssif dell_smbios
platform_profile vfat intel_cstate fat dcdbas intel_uncore
dell_wmi_descriptor wmi_bmof pcspkr mgag200 tg3 mei_me i2c_i801
i2c_algo_bit mei i2c_smbus lpc_ich intel_pch_thermal acpi_power_meter
ipmi_si acpi_ipmi ipmi_devintf ipmi_msghandler sg loop fuse nfnetlink
xfs sd_mod nd_btt(O) ghash_clmulni_intel nd_e820(O) megaraid_sas ahci
libahci libata wmi nfit(O) libnvdimm(O) nfit_test_iomap(O) dm_mirror
dm_region_hash dm_log dm_mod
[10966.919776] Unloaded tainted modules: cxl_port(O):23 cxl_mem(O):23
cxl_pmem(O):23 cxl_acpi(O):23 cxl_test(O):23 dax_pmem(O):37
device_dax(O):37 nd_pmem(O):37 nfit_test(O):39 [last unloaded:
cxl_port(O)]
[10967.014742] CR2: ffffeaffc0400000
[10967.018062] ---[ end trace 0000000000000000 ]---
[10967.080660] RIP: 0010:memset_orig+0x33/0xb0
[10967.084863] Code: b6 ce 48 b8 01 01 01 01 01 01 01 01 48 0f af c1
41 89 f9 41 83 e1 07 75 70 48 89 d1 48 c1 e9 06 74 35 0f 1f 44 00 00
48 ff c9 <48> 89 07 48 89 47 08 48 89 47 10 48 89 47 18 48 89 47 20 48
89 47
[10967.103608] RSP: 0018:ffffc90005ddf3a8 EFLAGS: 00010216
[10967.108832] RAX: ffffffffffffffff RBX: 0000000000200000 RCX: 0000000000007fff
[10967.115965] RDX: 0000000000200000 RSI: 00000000ffffffff RDI: ffffeaffc0400000
[10967.123098] RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
[10967.130230] R10: ffffeaffc0400000 R11: 0000000000000000 R12: 000000000007fe02
[10967.137362] R13: 0000000000000ffc R14: 0000000000007fe0 R15: 00000003ff010000
[10967.144494] FS:  00007f59922b97c0(0000) GS:ffff88901f400000(0000)
knlGS:0000000000000000
[10967.152579] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[10967.158327] CR2: ffffeaffc0400000 CR3: 000000032ed88006 CR4: 00000000007726f0
[10967.165460] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[10967.172593] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[10967.179724] PKRU: 55555554
[10967.182439] Kernel panic - not syncing: Fatal exception
[10967.187682] Kernel Offset: 0x20800000 from 0xffffffff81000000
(relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[10967.236024] pstore: backend (erst) writing error (-28)
[10967.241171] ---[ end Kernel panic - not syncing: Fatal exception ]---

-- 
Best Regards,
  Yi Zhang

