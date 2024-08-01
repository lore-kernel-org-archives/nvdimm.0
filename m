Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418831B3F25
	for <nvdimm@lists.linux.dev>; Thu,  1 Aug 2024 17:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722532324; cv=none; b=np+OLpU6seobB2Lr+8o5pLduJGrC2uqo8+eERYTNSmeBuWxYwTjnA4kltiuX/Wg/l+4JG3l17rTLjlrw2gdthbpVxxl3L8FCxhnLqQI6BoM8nOiya8tFzdVGf59xv14OrCXOOEqwgAPrBtxgtHbJTopR9iy/fvq9uR4KBuM47EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722532324; c=relaxed/simple;
	bh=6rUoVb2RJzxf38o25CWIY4Easrm2pTQnCp7Ys04pR84=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UXQYtF/nnur2J7CXcesx7IBy1csDObgi2HB9MFGZfz67LFriryugoy7jeZuh3EosIvAoJ1FO7xQnQFrwq97aqXazTcUnq/xJ94mKEe2y0DslDBrC3jC+965FwFpZSDa18FjXQ1l5NeaswMjZrBuzd5SIYsgJOBVvO1j4fuMVtbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lX0rhwug; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lX0rhwug"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722532322; x=1754068322;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6rUoVb2RJzxf38o25CWIY4Easrm2pTQnCp7Ys04pR84=;
  b=lX0rhwugJJ3meBd3cGi8ZmLQx75S9kQpxBcrMD2izFZCXM5iR2P4+sU7
   5GYodl1eHUp+fl+C93z6+FUuU4XkcdZKzXHO9vr5bWDQ4K6fjde4adPYX
   qKZhGVA5SxjmBrNSQAOEYgOHRREIggBIrBhLo7GYlmzZnrFYxc+dEM84/
   dUC4jX0y1KfzdgUP446rhdTcTk9vu5sCQMg2/ktOUUvGI7ndNAbox5WWr
   WI2EiIKWx14jgcE47SL8S612p8YEei9AzbbvreptoqakPmGFXXrSQAThF
   dJphWkh4TFcAx61JJaCxKJJ6UcpUfFOyKhsHi2dwKKbcrMp74cLW8EbAQ
   A==;
X-CSE-ConnectionGUID: aLNQi3uATnaYoSeVhATqYA==
X-CSE-MsgGUID: EmrvzX8LQjqAyAFK0ENg4Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11151"; a="20094860"
X-IronPort-AV: E=Sophos;i="6.09,255,1716274800"; 
   d="scan'208";a="20094860"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2024 10:05:48 -0700
X-CSE-ConnectionGUID: UeztfSK2R3akqPbyZZ+3jQ==
X-CSE-MsgGUID: vHPilkM2RASZj4f+sdWylw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,255,1716274800"; 
   d="scan'208";a="78384820"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.91.181])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2024 10:05:47 -0700
Date: Thu, 1 Aug 2024 10:05:45 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Yi Zhang <yi.zhang@redhat.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, linux-cxl@vger.kernel.org,
	Dan Williams <dan.j.williams@intel.com>
Subject: Re: [bug report][regression] Oops: general protection fault observed
 after destroy the devdax
Message-ID: <ZqvAacQGB9Oou5mT@aschofie-mobl2>
References: <CAHj4cs9Ax1=CoJkgBGP_+sNu6-6=6v=_L-ZBZY0bVLD3wUWZQg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHj4cs9Ax1=CoJkgBGP_+sNu6-6=6v=_L-ZBZY0bVLD3wUWZQg@mail.gmail.com>

On Tue, Jul 30, 2024 at 11:41:44AM +0800, Yi Zhang wrote:
> Hi
> I reproduced this issue on my two nvdimm servers with 6.11.0-rc1,
> please help check it and let me know if you need any testing for it,
> thanks.

Hi Yi,

Thanks for the report. I haven't been able to reproduce this but it
is similar to another that has appeared in 6.11-rc1 while unloading
the cxl-test module. Both failures RIP in mod_node_page_state().
I found that reverting a vmstat change introduced in 6.11-rc1 is a
temporary work-around for the module unload problem.

Revert commit 15995a35247442aefa0ffe36a6dad51cb46b0918 
"mm: report per-page metadata information"

Would you be able to try that out?

Thanks,
Alison

> 
> # ndctl create-namespace -r region0 -m devdax -a 4k -s 12G
> {
>   "dev":"namespace0.0",
>   "mode":"devdax",
>   "map":"dev",
>   "size":"11.81 GiB (12.68 GB)",
>   "uuid":"0ddf6d2d-54cb-4a2b-ac72-bb9aec891bae",
>   "daxregion":{
>     "id":0,
>     "size":"11.81 GiB (12.68 GB)",
>     "align":4096,
>     "devices":[
>       {
>         "chardev":"dax0.0",
>         "size":"11.81 GiB (12.68 GB)",
>         "target_node":0,
>         "align":4096,
>         "mode":"devdax"
>       }
>     ]
>   },
>   "align":4096
> }
> # ndctl destroy-namespace all -r all -f
> Segmentation fault
> 
> dmesg:
> [ 1408.632268] Oops: general protection fault, probably for
> non-canonical address 0xdffffc0000005650: 0000 [#1] PREEMPT SMP KASAN
> PTI
> [ 1408.644006] KASAN: probably user-memory-access in range
> [0x000000000002b280-0x000000000002b287]
> [ 1408.652699] CPU: 26 UID: 0 PID: 1868 Comm: ndctl Not tainted 6.11.0-rc1 #1
> [ 1408.659571] Hardware name: Dell Inc. PowerEdge R640/08HT8T, BIOS
> 2.20.1 09/13/2023
> [ 1408.667136] RIP: 0010:mod_node_page_state+0x2a/0x110
> [ 1408.672112] Code: 0f 1f 44 00 00 48 b8 00 00 00 00 00 fc ff df 41
> 54 55 48 89 fd 48 81 c7 80 b2 02 00 53 48 89 f9 89 d3 48 c1 e9 03 48
> 83 ec 10 <80> 3c 01 00 0f 85 b8 00 00 00 48 8b bd 80 b2 02 00 41 89 f0
> 83 ee
> [ 1408.690856] RSP: 0018:ffffc900246d7388 EFLAGS: 00010286
> [ 1408.696088] RAX: dffffc0000000000 RBX: 00000000fffffe00 RCX: 0000000000005650
> [ 1408.703222] RDX: fffffffffffffe00 RSI: 000000000000002f RDI: 000000000002b280
> [ 1408.710353] RBP: 0000000000000000 R08: ffff88a06ffcb1c8 R09: 1ffffffff218c681
> [ 1408.717486] R10: ffffffff93d922bf R11: ffff88855e790f10 R12: 00000000000003ff
> [ 1408.724619] R13: 1ffff920048dae7b R14: ffffea0081e00000 R15: ffffffff90c63408
> [ 1408.731750] FS:  00007f753c219200(0000) GS:ffff889bf2a00000(0000)
> knlGS:0000000000000000
> [ 1408.739834] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1408.745581] CR2: 0000559f5902a5a8 CR3: 00000001292f0006 CR4: 00000000007706f0
> [ 1408.752713] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 1408.759843] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [ 1408.766976] PKRU: 55555554
> [ 1408.769690] Call Trace:
> [ 1408.772143]  <TASK>
> [ 1408.774248]  ? die_addr+0x3d/0xa0
> [ 1408.777577]  ? exc_general_protection+0x150/0x230
> [ 1408.782297]  ? asm_exc_general_protection+0x22/0x30
> [ 1408.787182]  ? mod_node_page_state+0x2a/0x110
> [ 1408.791548]  section_deactivate+0x519/0x780
> [ 1408.795740]  ? __pfx_section_deactivate+0x10/0x10
> [ 1408.800449]  __remove_pages+0x6c/0xa0
> [ 1408.804119]  arch_remove_memory+0x1a/0x70
> [ 1408.808141]  pageunmap_range+0x2ad/0x5e0
> [ 1408.812067]  memunmap_pages+0x320/0x5a0
> [ 1408.815909]  release_nodes+0xd6/0x170
> [ 1408.819581]  ? lockdep_hardirqs_on+0x78/0x100
> [ 1408.823941]  devres_release_all+0x106/0x170
> [ 1408.828126]  ? __pfx_devres_release_all+0x10/0x10
> [ 1408.832834]  device_unbind_cleanup+0x16/0x1a0
> [ 1408.837198]  device_release_driver_internal+0x3d5/0x530
> [ 1408.842423]  ? klist_put+0xf7/0x170
> [ 1408.845916]  bus_remove_device+0x1ed/0x3f0
> [ 1408.850017]  device_del+0x33b/0x8c0
> [ 1408.853518]  ? __pfx_device_del+0x10/0x10
> [ 1408.857532]  unregister_dev_dax+0x112/0x210
> [ 1408.861722]  release_nodes+0xd6/0x170
> [ 1408.865387]  ? lockdep_hardirqs_on+0x78/0x100
> [ 1408.869749]  devres_release_all+0x106/0x170
> [ 1408.873933]  ? __pfx_devres_release_all+0x10/0x10
> [ 1408.878643]  device_unbind_cleanup+0x16/0x1a0
> [ 1408.883007]  device_release_driver_internal+0x3d5/0x530
> [ 1408.888235]  ? __pfx_sysfs_kf_write+0x10/0x10
> [ 1408.892598]  unbind_store+0xdc/0xf0
> [ 1408.896093]  kernfs_fop_write_iter+0x358/0x530
> [ 1408.900539]  vfs_write+0x9b2/0xf60
> [ 1408.903954]  ? __pfx_vfs_write+0x10/0x10
> [ 1408.907891]  ? __fget_light+0x53/0x1e0
> [ 1408.911646]  ? __x64_sys_openat+0x11f/0x1e0
> [ 1408.915835]  ksys_write+0xf1/0x1d0
> [ 1408.919249]  ? __pfx_ksys_write+0x10/0x10
> [ 1408.923264]  do_syscall_64+0x8c/0x180
> [ 1408.926934]  ? __debug_check_no_obj_freed+0x253/0x520
> [ 1408.931997]  ? __pfx___debug_check_no_obj_freed+0x10/0x10
> [ 1408.937405]  ? kasan_quarantine_put+0x109/0x220
> [ 1408.941944]  ? lockdep_hardirqs_on+0x78/0x100
> [ 1408.946304]  ? kmem_cache_free+0x1a6/0x4c0
> [ 1408.950408]  ? do_sys_openat2+0x10a/0x160
> [ 1408.954424]  ? do_sys_openat2+0x10a/0x160
> [ 1408.958434]  ? __pfx_do_sys_openat2+0x10/0x10
> [ 1408.962794]  ? lockdep_hardirqs_on+0x78/0x100
> [ 1408.967153]  ? __pfx___debug_check_no_obj_freed+0x10/0x10
> [ 1408.972554]  ? __x64_sys_openat+0x11f/0x1e0
> [ 1408.976737]  ? __pfx___x64_sys_openat+0x10/0x10
> [ 1408.981269]  ? rcu_is_watching+0x11/0xb0
> [ 1408.985204]  ? lockdep_hardirqs_on_prepare+0x179/0x400
> [ 1408.990351]  ? do_syscall_64+0x98/0x180
> [ 1408.994191]  ? lockdep_hardirqs_on+0x78/0x100
> [ 1408.998549]  ? do_syscall_64+0x98/0x180
> [ 1409.002386]  ? do_syscall_64+0x98/0x180
> [ 1409.006227]  ? lockdep_hardirqs_on+0x78/0x100
> [ 1409.010585]  ? do_syscall_64+0x98/0x180
> [ 1409.014425]  ? lockdep_hardirqs_on_prepare+0x179/0x400
> [ 1409.019565]  ? do_syscall_64+0x98/0x180
> [ 1409.023401]  ? lockdep_hardirqs_on+0x78/0x100
> [ 1409.027763]  ? do_syscall_64+0x98/0x180
> [ 1409.031600]  ? do_syscall_64+0x98/0x180
> [ 1409.035439]  ? do_syscall_64+0x98/0x180
> [ 1409.039281]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [ 1409.044331] RIP: 0033:0x7f753c0fda57
> [ 1409.047911] Code: 0f 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7
> 0f 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 01 00 00
> 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 48 89 54 24 18 48 89
> 74 24
> [ 1409.066655] RSP: 002b:00007ffc19323e28 EFLAGS: 00000246 ORIG_RAX:
> 0000000000000001
> [ 1409.074220] RAX: ffffffffffffffda RBX: 0000000000000007 RCX: 00007f753c0fda57
> [ 1409.081352] RDX: 0000000000000007 RSI: 0000559f5901f740 RDI: 0000000000000003
> [ 1409.088483] RBP: 0000000000000003 R08: 0000000000000000 R09: 00007ffc19323d20
> [ 1409.095616] R10: 0000000000000000 R11: 0000000000000246 R12: 0000559f5901f740
> [ 1409.102748] R13: 00007ffc19323e90 R14: 00007f753c219120 R15: 0000559f5901fc30
> [ 1409.109887]  </TASK>
> [ 1409.112082] Modules linked in: kmem device_dax rpcsec_gss_krb5
> auth_rpcgss nfsv4 dns_resolver nfs lockd grace netfs rfkill sunrpc
> dm_multipath intel_rapl_msr intel_rapl_common intel_uncore_frequency
> intel_uncore_frequency_common skx_edac skx_edac_common
> x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm mgag200
> rapl cdc_ether iTCO_wdt dell_pc i2c_algo_bit iTCO_vendor_support
> ipmi_ssif usbnet acpi_power_meter drm_shmem_helper mei_me dell_smbios
> platform_profile intel_cstate dcdbas wmi_bmof dell_wmi_descriptor
> intel_uncore pcspkr mii drm_kms_helper i2c_i801 mei i2c_smbus
> intel_pch_thermal lpc_ich ipmi_si acpi_ipmi dax_pmem ipmi_devintf
> ipmi_msghandler drm fuse xfs libcrc32c sd_mod sg nd_pmem nd_btt
> crct10dif_pclmul crc32_pclmul crc32c_intel ahci ghash_clmulni_intel
> libahci bnxt_en megaraid_sas tg3 libata wmi nfit libnvdimm dm_mirror
> dm_region_hash dm_log dm_mod
> [ 1409.189120] ---[ end trace 0000000000000000 ]---
> [ 1409.245769] RIP: 0010:mod_node_page_state+0x2a/0x110
> [ 1409.250772] Code: 0f 1f 44 00 00 48 b8 00 00 00 00 00 fc ff df 41
> 54 55 48 89 fd 48 81 c7 80 b2 02 00 53 48 89 f9 89 d3 48 c1 e9 03 48
> 83 ec 10 <80> 3c 01 00 0f 85 b8 00 00 00 48 8b bd 80 b2 02 00 41 89 f0
> 83 ee
> [ 1409.269539] RSP: 0018:ffffc900246d7388 EFLAGS: 00010286
> [ 1409.274786] RAX: dffffc0000000000 RBX: 00000000fffffe00 RCX: 0000000000005650
> [ 1409.281944] RDX: fffffffffffffe00 RSI: 000000000000002f RDI: 000000000002b280
> [ 1409.289095] RBP: 0000000000000000 R08: ffff88a06ffcb1c8 R09: 1ffffffff218c681
> [ 1409.296251] R10: ffffffff93d922bf R11: ffff88855e790f10 R12: 00000000000003ff
> [ 1409.303410] R13: 1ffff920048dae7b R14: ffffea0081e00000 R15: ffffffff90c63408
> [ 1409.310567] FS:  00007f753c219200(0000) GS:ffff889bf2a00000(0000)
> knlGS:0000000000000000
> [ 1409.318680] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1409.324450] CR2: 0000559f5902a5a8 CR3: 00000001292f0006 CR4: 00000000007706f0
> [ 1409.331607] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 1409.338771] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [ 1409.345936] PKRU: 55555554
> [ 1851.504826] ==================================================================
> [ 1851.512060] BUG: KASAN: slab-use-after-free in
> mutex_can_spin_on_owner+0x192/0x1c0
> [ 1851.519640] Read of size 4 at addr ffff88855e790034 by task
> kworker/u192:1/1821
> 
> [ 1851.528446] CPU: 41 UID: 0 PID: 1821 Comm: kworker/u192:1 Tainted:
> G      D            6.11.0-rc1 #1
> [ 1851.537580] Tainted: [D]=DIE
> [ 1851.540464] Hardware name: Dell Inc. PowerEdge R640/08HT8T, BIOS
> 2.20.1 09/13/2023
> [ 1851.548031] Workqueue: nfit acpi_nfit_scrub [nfit]
> [ 1851.552840] Call Trace:
> [ 1851.555292]  <TASK>
> [ 1851.557399]  dump_stack_lvl+0x7e/0xc0
> [ 1851.561073]  print_address_description.constprop.0+0x2c/0x3d0
> [ 1851.566829]  ? mutex_can_spin_on_owner+0x192/0x1c0
> [ 1851.571627]  print_report+0xb4/0x270
> [ 1851.575207]  ? mutex_can_spin_on_owner+0x192/0x1c0
> [ 1851.579999]  ? kasan_addr_to_slab+0x9/0xa0
> [ 1851.584098]  kasan_report+0x89/0xc0
> [ 1851.587591]  ? mutex_can_spin_on_owner+0x192/0x1c0
> [ 1851.592388]  mutex_can_spin_on_owner+0x192/0x1c0
> [ 1851.597012]  __mutex_lock+0x256/0x14a0
> [ 1851.600770]  ? try_to_wake_up+0x697/0x1060
> [ 1851.604881]  ? nd_device_notify+0x22/0xa0 [libnvdimm]
> [ 1851.609958]  ? rcu_is_watching+0x11/0xb0
> [ 1851.613892]  ? lock_acquire+0x397/0x640
> [ 1851.617730]  ? __pfx___mutex_lock+0x10/0x10
> [ 1851.621916]  ? __pfx_lock_acquire+0x10/0x10
> [ 1851.626104]  ? do_raw_spin_trylock+0xb5/0x180
> [ 1851.630461]  ? __pfx_do_raw_spin_trylock+0x10/0x10
> [ 1851.635254]  ? rcu_is_watching+0x11/0xb0
> [ 1851.639180]  ? nd_device_notify+0x22/0xa0 [libnvdimm]
> [ 1851.644249]  nd_device_notify+0x22/0xa0 [libnvdimm]
> [ 1851.649146]  child_notify+0x3d/0x60 [libnvdimm]
> [ 1851.653703]  ? __pfx_child_notify+0x10/0x10 [libnvdimm]
> [ 1851.658953]  device_for_each_child+0xd8/0x150
> [ 1851.663314]  ? kernfs_notify+0x113/0x2e0
> [ 1851.667248]  ? __pfx_device_for_each_child+0x10/0x10
> [ 1851.672213]  ? rcu_is_watching+0x11/0xb0
> [ 1851.676139]  ? trace_irq_enable.constprop.0+0x151/0x1c0
> [ 1851.681367]  nd_region_notify+0x80/0x1c0 [libnvdimm]
> [ 1851.686357]  ? __pfx_nd_region_notify+0x10/0x10 [libnvdimm]
> [ 1851.691959]  nvdimm_region_notify+0x82/0xb0 [libnvdimm]
> [ 1851.697206]  ars_complete+0x29e/0x410 [nfit]
> [ 1851.701488]  __acpi_nfit_scrub+0x1e8/0xc30 [nfit]
> [ 1851.706200]  ? acpi_nfit_query_poison+0x2ac/0x780 [nfit]
> [ 1851.711523]  ? __pfx___acpi_nfit_scrub+0x10/0x10 [nfit]
> [ 1851.716756]  ? __pfx_lock_acquire+0x10/0x10
> [ 1851.720944]  ? __pfx_acpi_nfit_query_poison+0x10/0x10 [nfit]
> [ 1851.726615]  acpi_nfit_scrub+0x43/0x1f0 [nfit]
> [ 1851.731064]  process_one_work+0x8d3/0x1920
> [ 1851.735178]  ? __pfx_process_one_work+0x10/0x10
> [ 1851.739716]  ? assign_work+0x16c/0x240
> [ 1851.743476]  worker_thread+0x583/0xce0
> [ 1851.747230]  ? __pfx_worker_thread+0x10/0x10
> [ 1851.751509]  kthread+0x2f3/0x3e0
> [ 1851.754748]  ? _raw_spin_unlock_irq+0x24/0x50
> [ 1851.759107]  ? __pfx_kthread+0x10/0x10
> [ 1851.762860]  ret_from_fork+0x2d/0x70
> [ 1851.766446]  ? __pfx_kthread+0x10/0x10
> [ 1851.770200]  ret_from_fork_asm+0x1a/0x30
> [ 1851.774138]  </TASK>
> 
> [ 1851.777833] Allocated by task 1830:
> [ 1851.781326]  kasan_save_stack+0x20/0x40
> [ 1851.785164]  kasan_save_track+0x10/0x30
> [ 1851.789004]  __kasan_slab_alloc+0x55/0x70
> [ 1851.793016]  kmem_cache_alloc_node_noprof+0x16c/0x340
> [ 1851.798069]  dup_task_struct+0x34/0x680
> [ 1851.801909]  copy_process+0x358/0x5590
> [ 1851.805661]  kernel_clone+0xba/0x770
> [ 1851.809238]  __do_sys_clone+0xa1/0xe0
> [ 1851.812906]  do_syscall_64+0x8c/0x180
> [ 1851.816570]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
> [ 1851.823121] Freed by task 0:
> [ 1851.826007]  kasan_save_stack+0x20/0x40
> [ 1851.829845]  kasan_save_track+0x10/0x30
> [ 1851.833687]  kasan_save_free_info+0x37/0x60
> [ 1851.837872]  __kasan_slab_free+0x109/0x190
> [ 1851.841971]  kmem_cache_free+0x1a6/0x4c0
> [ 1851.845897]  delayed_put_task_struct+0x1f7/0x2a0
> [ 1851.850517]  rcu_do_batch+0x3d6/0xf50
> [ 1851.854179]  rcu_core+0x3dd/0x5a0
> [ 1851.857499]  handle_softirqs+0x200/0x920
> [ 1851.861427]  __irq_exit_rcu+0xbc/0x210
> [ 1851.865177]  irq_exit_rcu+0xa/0x30
> [ 1851.868584]  sysvec_apic_timer_interrupt+0x93/0xc0
> [ 1851.873375]  asm_sysvec_apic_timer_interrupt+0x16/0x20
> 
> [ 1851.880015] Last potentially related work creation:
> [ 1851.884892]  kasan_save_stack+0x20/0x40
> [ 1851.888733]  __kasan_record_aux_stack+0x8e/0xa0
> [ 1851.893264]  __call_rcu_common.constprop.0+0xef/0x940
> [ 1851.898316]  wait_task_zombie+0x5b1/0x2050
> [ 1851.902416]  __do_wait+0x18c/0x710
> [ 1851.905820]  do_wait+0x1d2/0x500
> [ 1851.909053]  kernel_wait4+0xf2/0x1d0
> [ 1851.912633]  __do_sys_wait4+0xf4/0x100
> [ 1851.916383]  do_syscall_64+0x8c/0x180
> [ 1851.920050]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
> [ 1851.926603] Second to last potentially related work creation:
> [ 1851.932346]  kasan_save_stack+0x20/0x40
> [ 1851.936188]  __kasan_record_aux_stack+0x8e/0xa0
> [ 1851.940720]  task_work_add+0x1dd/0x2a0
> [ 1851.944471]  sched_tick+0x2ac/0x950
> [ 1851.947965]  update_process_times+0x12e/0x190
> [ 1851.952322]  tick_nohz_handler+0x2ac/0x4a0
> [ 1851.956423]  __hrtimer_run_queues+0x558/0xb40
> [ 1851.960781]  hrtimer_interrupt+0x2e9/0x7a0
> [ 1851.964879]  __sysvec_apic_timer_interrupt+0x140/0x540
> [ 1851.970019]  sysvec_apic_timer_interrupt+0x8e/0xc0
> [ 1851.974810]  asm_sysvec_apic_timer_interrupt+0x16/0x20
> 
> [ 1851.981448] The buggy address belongs to the object at ffff88855e790000
>                 which belongs to the cache task_struct of size 15752
> [ 1851.994126] The buggy address is located 52 bytes inside of
>                 freed 15752-byte region [ffff88855e790000, ffff88855e793d88)
> 
> [ 1852.007960] The buggy address belongs to the physical page:
> [ 1852.013531] page: refcount:1 mapcount:0 mapping:0000000000000000
> index:0x0 pfn:0x55e790
> [ 1852.021528] head: order:3 mapcount:0 entire_mapcount:0
> nr_pages_mapped:0 pincount:0
> [ 1852.029182] memcg:ffff8885ef0bad41
> [ 1852.032587] flags: 0x17ffffc0000040(head|node=0|zone=2|lastcpupid=0x1fffff)
> [ 1852.039545] page_type: 0xfdffffff(slab)
> [ 1852.043388] raw: 0017ffffc0000040 ffff888100052300 dead000000000122
> 0000000000000000
> [ 1852.051124] raw: 0000000000000000 0000000000020002 00000001fdffffff
> ffff8885ef0bad41
> [ 1852.058863] head: 0017ffffc0000040 ffff888100052300
> dead000000000122 0000000000000000
> [ 1852.066687] head: 0000000000000000 0000000000020002
> 00000001fdffffff ffff8885ef0bad41
> [ 1852.074514] head: 0017ffffc0000003 ffffea001579e401
> ffffffffffffffff 0000000000000000
> [ 1852.082339] head: 0000000000000008 0000000000000000
> 00000000ffffffff 0000000000000000
> [ 1852.090164] page dumped because: kasan: bad access detected
> 
> [ 1852.097236] Memory state around the buggy address:
> [ 1852.102027]  ffff88855e78ff00: fc fc fc fc fc fc fc fc fc fc fc fc
> fc fc fc fc
> [ 1852.109245]  ffff88855e78ff80: fc fc fc fc fc fc fc fc fc fc fc fc
> fc fc fc fc
> [ 1852.116466] >ffff88855e790000: fa fb fb fb fb fb fb fb fb fb fb fb
> fb fb fb fb
> [ 1852.123683]                                      ^
> [ 1852.128476]  ffff88855e790080: fb fb fb fb fb fb fb fb fb fb fb fb
> fb fb fb fb
> [ 1852.135694]  ffff88855e790100: fb fb fb fb fb fb fb fb fb fb fb fb
> fb fb fb fb
> [ 1852.142913] ==================================================================
> 
> -- 
> Best Regards,
>   Yi Zhang
> 
> 
