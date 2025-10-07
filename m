Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50E411CA0;
	Tue,  7 Oct 2025 00:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759795973; cv=none; b=Mj365YmVwkdXvE49JVUo26PmN2G9pnuPJXqzzITrDhoU0RYl7YoX7ZIqWtaW0I31pLJgzEWcMiJ0/Fy08QFuHE4M8uFluMM7FKWtKGDCPyy42KPC0g94AbATYy1T1XYWtblXV2MhXL/c8reOgvQRan7YBgUBUwXw27fKdZKp2hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759795973; c=relaxed/simple;
	bh=wjsqqz9TtZBSnkWeh4JUNTtVwKDcKQs2Uc6LN2K64Bg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KbUq/u/vDmlGLIK6sV8FC2NkBJHCf9yX6nVyuKde1paBJzikjg2h4px830B17PRGVDn+8uv4kpkvkbQ8BALdUlomf76ojK4j0DWxATMBJ4ejYrlJPwnO+Qbqzz5KO26+N+fezA6VYCZqZBNXsUAjzDTcEFcQzvAp/ej7jY791fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A97C4CEF5;
	Tue,  7 Oct 2025 00:12:53 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com
Subject: [PATCH] dax/hmem: Fix lockdep warning for hmem_register_resource()
Date: Mon,  6 Oct 2025 17:12:52 -0700
Message-ID: <20251007001252.2710860-1-dave.jiang@intel.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The following lockdep splat was observed while kernel auto-online a CXL
memory region:

[   51.926183] ======================================================
[   51.933441] WARNING: possible circular locking dependency detected
[   51.940701] 6.17.0djtest+ #53 Tainted: G        W
[   51.947290] ------------------------------------------------------
[   51.954553] systemd-udevd/3334 is trying to acquire lock:
[   51.960938] ffffffff90346188 (hmem_resource_lock){+.+.}-{4:4}, at: hmem_register_resource+0x31/0x50
[   51.971429]
               but task is already holding lock:
[   51.978548] ffffffff90338890 ((node_chain).rwsem){++++}-{4:4}, at: blocking_notifier_call_chain+0x2e/0x70
[   51.989621]
               which lock already depends on the new lock.

[   51.999605]
               the existing dependency chain (in reverse order) is:
[   52.008539]
               -> #6 ((node_chain).rwsem){++++}-{4:4}:
[   52.016195]        down_read+0x45/0x190
[   52.020789]        blocking_notifier_call_chain+0x2e/0x70
[   52.027131]        node_notify+0x1f/0x30
[   52.031809]        online_pages+0xc1/0x330
[   52.036684]        memory_subsys_online+0x22a/0x280
[   52.042431]        device_online+0x50/0x90
[   52.047298]        state_store+0x9b/0xa0
[   52.051956]        dev_attr_store+0x18/0x30
[   52.056907]        sysfs_kf_write+0x4e/0x70
[   52.061854]        kernfs_fop_write_iter+0x187/0x260
[   52.067673]        vfs_write+0x21f/0x590
[   52.072313]        ksys_write+0x73/0xf0
[   52.076854]        __x64_sys_write+0x1d/0x30
[   52.081874]        x64_sys_call+0x7d/0x1d80
[   52.086797]        do_syscall_64+0x6c/0x2f0
[   52.091717]        entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   52.098198]
               -> #5 (mem_hotplug_lock){++++}-{0:0}:
[   52.105512]        percpu_down_write+0x4b/0x260
[   52.110825]        try_online_node+0x21/0x50
[   52.115844]        cpu_up+0x43/0xd0
[   52.119989]        cpuhp_bringup_mask+0x60/0xa0
[   52.125305]        bringup_nonboot_cpus+0x76/0x110
[   52.130912]        smp_init+0x2e/0x90
[   52.135235]        kernel_init_freeable+0x19a/0x300
[   52.140930]        kernel_init+0x1e/0x140
[   52.145635]        ret_from_fork+0x159/0x200
[   52.150633]        ret_from_fork_asm+0x1a/0x30
[   52.155826]
               -> #4 (cpu_hotplug_lock){++++}-{0:0}:
[   52.163081]        __cpuhp_state_add_instance+0x51/0x200
[   52.169238]        iova_domain_init_rcaches+0x1ed/0x200
[   52.175301]        iommu_setup_dma_ops+0x1b4/0x500
[   52.180877]        bus_iommu_probe+0xd2/0x180
[   52.185954]        iommu_device_register+0x9f/0xe0
[   52.191530]        intel_iommu_init+0xd3b/0xf20
[   52.196810]        pci_iommu_init+0x16/0x40
[   52.201695]        do_one_initcall+0x5c/0x2d0
[   52.206767]        kernel_init_freeable+0x281/0x300
[   52.212432]        kernel_init+0x1e/0x140
[   52.217109]        ret_from_fork+0x159/0x200
[   52.222082]        ret_from_fork_asm+0x1a/0x30
[   52.227253]
               -> #3 (&group->mutex){+.+.}-{4:4}:
[   52.234196]        __mutex_lock+0xa9/0x11e0
[   52.239066]        mutex_lock_nested+0x1f/0x30
[   52.244236]        __iommu_probe_device+0x28c/0x5e0
[   52.249893]        probe_iommu_group+0x2f/0x50
[   52.255064]        bus_for_each_dev+0x7e/0xd0
[   52.260126]        bus_iommu_probe+0x3f/0x180
[   52.265190]        iommu_device_register+0x9f/0xe0
[   52.270751]        intel_iommu_init+0xd3b/0xf20
[   52.276016]        pci_iommu_init+0x16/0x40
[   52.280892]        do_one_initcall+0x5c/0x2d0
[   52.285956]        kernel_init_freeable+0x281/0x300
[   52.291613]        kernel_init+0x1e/0x140
[   52.296284]        ret_from_fork+0x159/0x200
[   52.301253]        ret_from_fork_asm+0x1a/0x30
[   52.306421]
               -> #2 (iommu_probe_device_lock){+.+.}-{4:4}:
[   52.314333]        __mutex_lock+0xa9/0x11e0
[   52.319201]        mutex_lock_nested+0x1f/0x30
[   52.324372]        iommu_probe_device+0x21/0x70
[   52.329638]        iommu_bus_notifier+0x2c/0x80
[   52.334903]        notifier_call_chain+0x4b/0x110
[   52.340357]        blocking_notifier_call_chain+0x4a/0x70
[   52.346594]        bus_notify+0x3b/0x50
[   52.351079]        device_add+0x65d/0x8b0
[   52.355750]        platform_device_add+0xf8/0x250
[   52.361205]        platform_device_register_full+0x154/0x1f0
[   52.367739]        platform_device_register_simple.constprop.0.isra.0+0x37/0x50
[   52.376119]        efisubsys_init+0xaf/0x570
[   52.381090]        do_one_initcall+0x5c/0x2d0
[   52.386152]        kernel_init_freeable+0x281/0x300
[   52.391809]        kernel_init+0x1e/0x140
[   52.396481]        ret_from_fork+0x159/0x200
[   52.401450]        ret_from_fork_asm+0x1a/0x30
[   52.406620]
               -> #1 (&(&priv->bus_notifier)->rwsem){++++}-{4:4}:
[   52.415109]        down_read+0x45/0x190
[   52.419593]        blocking_notifier_call_chain+0x2e/0x70
[   52.425828]        bus_notify+0x3b/0x50
[   52.430311]        device_add+0x65d/0x8b0
[   52.434981]        platform_device_add+0xf8/0x250
[   52.440435]        __hmem_register_resource+0x70/0xc0
[   52.446279]        hmem_register_resource+0x3b/0x50
[   52.451923]        hmat_register_target+0x3c/0x190
[   52.457488]        hmat_init+0x13f/0x370
[   52.462067]        do_one_initcall+0x5c/0x2d0
[   52.467132]        kernel_init_freeable+0x281/0x300
[   52.472790]        kernel_init+0x1e/0x140
[   52.477464]        ret_from_fork+0x159/0x200
[   52.482433]        ret_from_fork_asm+0x1a/0x30
[   52.487604]
               -> #0 (hmem_resource_lock){+.+.}-{4:4}:
[   52.495030]        __lock_acquire+0x14a4/0x2290
[   52.500290]        lock_acquire+0xdd/0x2f0
[   52.505070]        __mutex_lock+0xa9/0x11e0
[   52.509944]        mutex_lock_nested+0x1f/0x30
[   52.515115]        hmem_register_resource+0x31/0x50
[   52.520771]        hmat_register_target+0x3c/0x190
[   52.526319]        hmat_callback+0x6b/0x80
[   52.531098]        notifier_call_chain+0x4b/0x110
[   52.536552]        blocking_notifier_call_chain+0x4a/0x70
[   52.542788]        node_notify+0x1f/0x30
[   52.547369]        online_pages+0x288/0x330
[   52.552246]        memory_subsys_online+0x22a/0x280
[   52.557902]        device_online+0x50/0x90
[   52.562669]        state_store+0x9b/0xa0
[   52.567247]        dev_attr_store+0x18/0x30
[   52.572123]        sysfs_kf_write+0x4e/0x70
[   52.576998]        kernfs_fop_write_iter+0x187/0x260
[   52.582750]        vfs_write+0x21f/0x590
[   52.587327]        ksys_write+0x73/0xf0
[   52.591811]        __x64_sys_write+0x1d/0x30
[   52.596779]        x64_sys_call+0x7d/0x1d80
[   52.601653]        do_syscall_64+0x6c/0x2f0
[   52.606528]        entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   52.612968]
               other info that might help us debug this:

[   52.622356] Chain exists of:
                 hmem_resource_lock --> mem_hotplug_lock --> (node_chain).rwsem

[   52.635550]  Possible unsafe locking scenario:

[   52.642495]        CPU0                    CPU1
[   52.647752]        ----                    ----
[   52.653014]   rlock((node_chain).rwsem);
[   52.657589]                                lock(mem_hotplug_lock);
[   52.664701]                                lock((node_chain).rwsem);
[   52.672015]   lock(hmem_resource_lock);
[   52.676497]
                *** DEADLOCK ***

[   52.683541] 8 locks held by systemd-udevd/3334:
[   52.688801]  #0: ff36b6d49fbf0410 (sb_writers#3){.+.+}-{0:0}, at: ksys_write+0x73/0xf0
[   52.697870]  #1: ff36b6d4ece03a88 (&of->mutex#2){+.+.}-{4:4}, at: kernfs_fop_write_iter+0x12c/0x260
[   52.708210]  #2: ff36b6d4ece1cbb8 (kn->active#62){.+.+}-{0:0}, at: kernfs_fop_write_iter+0x141/0x260
[   52.718645]  #3: ffffffff90333cc8 (device_hotplug_lock){+.+.}-{4:4}, at: lock_device_hotplug_sysfs+0x1b/0x50
[   52.729863]  #4: ff36b6d4ece4b108 (&dev->mutex){....}-{4:4}, at: device_online+0x23/0x90
[   52.739130]  #5: ffffffff900664d0 (cpu_hotplug_lock){++++}-{0:0}, at: mem_hotplug_begin+0x12/0x30
[   52.749288]  #6: ffffffff9024c810 (mem_hotplug_lock){++++}-{0:0}, at: mem_hotplug_begin+0x1e/0x30
[   52.759446]  #7: ffffffff90338890 ((node_chain).rwsem){++++}-{4:4}, at: blocking_notifier_call_chain+0x2e/0x70
[   52.770860]
               stack backtrace:
[   52.776068] CPU: 0 UID: 0 PID: 3334 Comm: systemd-udevd Tainted: G        W           6.17.0djtest+ #53 PREEMPT(voluntary)
[   52.776071] Tainted: [W]=WARN
[   52.776072] Hardware name: Intel Corporation AvenueCity/AvenueCity, BIOS BHSDCRB1.IPC.3545.P03.2509232237 09/23/2025
[   52.776073] Call Trace:
[   52.776074]  <TASK>
[   52.776076]  dump_stack_lvl+0x72/0xa0
[   52.776080]  dump_stack+0x14/0x1a
[   52.776082]  print_circular_bug.cold+0x188/0x1c6
[   52.776084]  check_noncircular+0x12f/0x160
[   52.776087]  ? __lock_acquire+0x486/0x2290
[   52.776089]  ? __lock_acquire+0x486/0x2290
[   52.776091]  __lock_acquire+0x14a4/0x2290
[   52.776095]  lock_acquire+0xdd/0x2f0
[   52.776096]  ? hmem_register_resource+0x31/0x50
[   52.776100]  ? hmem_register_resource+0x31/0x50
[   52.776101]  __mutex_lock+0xa9/0x11e0
[   52.776104]  ? hmem_register_resource+0x31/0x50
[   52.776104]  ? __kernfs_create_file+0xb5/0x110
[   52.776110]  mutex_lock_nested+0x1f/0x30
[   52.776112]  ? mutex_lock_nested+0x1f/0x30
[   52.776114]  hmem_register_resource+0x31/0x50
[   52.776115]  hmat_register_target+0x3c/0x190
[   52.776119]  hmat_callback+0x6b/0x80
[   52.776120]  notifier_call_chain+0x4b/0x110
[   52.776123]  blocking_notifier_call_chain+0x4a/0x70
[   52.776125]  node_notify+0x1f/0x30
[   52.776126]  online_pages+0x288/0x330
[   52.776129]  memory_subsys_online+0x22a/0x280
[   52.776132]  device_online+0x50/0x90
[   52.776134]  state_store+0x9b/0xa0
[   52.776136]  dev_attr_store+0x18/0x30
[   52.776137]  sysfs_kf_write+0x4e/0x70
[   52.776139]  kernfs_fop_write_iter+0x187/0x260
[   52.776142]  vfs_write+0x21f/0x590
[   52.776146]  ksys_write+0x73/0xf0
[   52.776148]  __x64_sys_write+0x1d/0x30
[   52.776150]  x64_sys_call+0x7d/0x1d80
[   52.776152]  do_syscall_64+0x6c/0x2f0
[   52.776154]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   52.776156] RIP: 0033:0x7f11142fda57
[   52.776158] Code: 0f 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 48 89 54 24 18 48 89 74 24
[   52.776160] RSP: 002b:00007ffd0bd530f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
[   52.776163] RAX: ffffffffffffffda RBX: 000000000000000e RCX: 00007f11142fda57
[   52.776164] RDX: 000000000000000e RSI: 00007ffd0bd537c0 RDI: 0000000000000006
[   52.776166] RBP: 00007ffd0bd537c0 R08: 00007f11143f70a0 R09: 00007ffd0bd53190
[   52.776167] R10: 0000000000000000 R11: 0000000000000246 R12: 000000000000000e
[   52.776168] R13: 000055814e03e780 R14: 000000000000000e R15: 00007f11143f69e0
[   52.776171]  </TASK>

The lock ordering can cause potential deadlock. There are instances
where hmem_resource_lock is taken after (node_chain).rwsem, and vice
versa. Narrow the scope of hmem_resource_lock in hmem_register_resource()
to avoid the circular locking dependency. The locking is only needed when
hmem_active needs to be protected.

Fixes: 7dab174e2e27 ("dax/hmem: Move hmem device registration to dax_hmem.ko")
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dax/hmem/device.c | 42 +++++++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 17 deletions(-)

diff --git a/drivers/dax/hmem/device.c b/drivers/dax/hmem/device.c
index f9e1a76a04a9..ab5977d75d1f 100644
--- a/drivers/dax/hmem/device.c
+++ b/drivers/dax/hmem/device.c
@@ -33,21 +33,37 @@ int walk_hmem_resources(struct device *host, walk_hmem_fn fn)
 }
 EXPORT_SYMBOL_GPL(walk_hmem_resources);
 
-static void __hmem_register_resource(int target_nid, struct resource *res)
+static struct resource *hmem_request_resource(int target_nid,
+					      struct resource *res)
 {
-	struct platform_device *pdev;
 	struct resource *new;
-	int rc;
 
-	new = __request_region(&hmem_active, res->start, resource_size(res), "",
-			       0);
+	guard(mutex)(&hmem_resource_lock);
+	new = __request_region(&hmem_active, res->start,
+			       resource_size(res), "", 0);
 	if (!new) {
 		pr_debug("hmem range %pr already active\n", res);
-		return;
+		return ERR_PTR(-ENOMEM);
 	}
 
 	new->desc = target_nid;
 
+	return new;
+}
+
+void hmem_register_resource(int target_nid, struct resource *res)
+{
+	struct platform_device *pdev;
+	struct resource *new;
+	int rc;
+
+	if (nohmem)
+		return;
+
+	new = hmem_request_resource(target_nid, res);
+	if (IS_ERR(new))
+		return;
+
 	if (platform_initialized)
 		return;
 
@@ -58,20 +74,12 @@ static void __hmem_register_resource(int target_nid, struct resource *res)
 	}
 
 	rc = platform_device_add(pdev);
-	if (rc)
+	if (rc) {
 		platform_device_put(pdev);
-	else
-		platform_initialized = true;
-}
-
-void hmem_register_resource(int target_nid, struct resource *res)
-{
-	if (nohmem)
 		return;
+	}
 
-	mutex_lock(&hmem_resource_lock);
-	__hmem_register_resource(target_nid, res);
-	mutex_unlock(&hmem_resource_lock);
+	platform_initialized = true;
 }
 
 static __init int hmem_register_one(struct resource *res, void *data)

base-commit: e5f0a698b34ed76002dc5cff3804a61c80233a7a
-- 
2.51.0

