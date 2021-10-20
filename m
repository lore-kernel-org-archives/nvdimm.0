Received: from tartarus.angband.pl (tartarus.angband.pl [51.83.246.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABDDC2C81
	for <nvdimm@lists.linux.dev>; Wed, 20 Oct 2021 13:55:39 +0000 (UTC)
Received: from kilobyte by tartarus.angband.pl with local (Exim 4.94.2)
	(envelope-from <kilobyte@angband.pl>)
	id 1mdBYi-00521Z-88; Wed, 20 Oct 2021 15:23:08 +0200
Date: Wed, 20 Oct 2021 15:23:08 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: nvdimm@lists.linux.dev, Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: ndctl hangs with big memmap=! fakepmem
Message-ID: <YXAYPK/oZNAXBs0R@angband.pl>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Junkbait: aaron@angband.pl, zzyx@angband.pl
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: kilobyte@angband.pl
X-SA-Exim-Scanned: No (on tartarus.angband.pl); SAEximRunCond expanded to false

Hi!
After bumping fakepmem sizes from 4G!20G 4G!36G to 32G!20G 32G!192G,
ndctl hangs.  Eg, at boot:

[  725.642546] INFO: task ndctl:2486 blocked for more than 604 seconds.
[  725.649586]       Not tainted 5.15.0-rc6-vanilla-00020-gd9abdee5fd5a #1
[  725.656877] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  725.665378] task:ndctl           state:D stack:    0 pid: 2486 ppid:  2433 flags:0x00004000
[  725.674404] Call Trace:
[  725.677539]  ? __schedule+0x30b/0x14e0
[  725.681975]  ? kernfs_put.part.0+0xd4/0x1a0
[  725.686841]  ? kmem_cache_free+0x28b/0x2b0
[  725.691622]  ? schedule+0x44/0xb0
[  725.695622]  ? blk_mq_freeze_queue_wait+0x62/0x90
[  725.701009]  ? do_wait_intr_irq+0xc0/0xc0
[  725.705703]  ? del_gendisk+0xcf/0x220
[  725.710050]  ? release_nodes+0x38/0xa0
[  725.714485]  ? devres_release_all+0x9f/0xe0
[  725.719352]  ? __device_release_driver+0x18a/0x240
[  725.724823]  ? device_driver_detach+0x4a/0xc0
[  725.729862]  ? unbind_store+0x117/0x130
[  725.734379]  ? kernfs_fop_write_iter+0x15a/0x1e0
[  725.739677]  ? new_sync_write+0x11f/0x1b0
[  725.744368]  ? vfs_write+0x1f5/0x2a0
[  725.748627]  ? do_sys_openat2+0x95/0x170
[  725.753233]  ? ksys_write+0x6d/0xf0
[  725.757405]  ? do_syscall_64+0x3b/0xc0
[  725.761838]  ? entry_SYSCALL_64_after_hwframe+0x44/0xae
[  725.767746] INFO: task ndctl:2520 blocked for more than 604 seconds.
[  725.774779]       Not tainted 5.15.0-rc6-vanilla-00020-gd9abdee5fd5a #1
[  725.782069] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  725.790570] task:ndctl           state:D stack:    0 pid: 2520 ppid:     1 flags:0x00000000
[  725.799594] Call Trace:
[  725.802725]  ? __schedule+0x30b/0x14e0
[  725.807158]  ? __cond_resched+0x16/0x40
[  725.811676]  ? __cond_resched+0x16/0x40
[  725.816193]  ? kmem_cache_alloc_trace+0x10/0x3d0
[  725.821492]  ? schedule+0x44/0xb0
[  725.825492]  ? schedule_preempt_disabled+0xa/0x10
[  725.830876]  ? __mutex_lock.constprop.0+0x288/0x410
[  725.836437]  ? flush_namespaces+0x15/0x30
[  725.841131]  ? nvdimm_bus_unlock+0x20/0x20
[  725.845911]  ? device_for_each_child+0x57/0x90
[  725.851035]  ? flush_regions_dimms+0x3d/0x50
[  725.855987]  ? wait_probe_show+0x60/0x60
[  725.860590]  ? device_for_each_child+0x57/0x90
[  725.865718]  ? wait_probe_show+0x46/0x60
[  725.870324]  ? dev_attr_show+0x23/0x50
[  725.874757]  ? sysfs_kf_seq_show+0x9b/0xf0
[  725.879534]  ? seq_read_iter+0x10e/0x4b0
[  725.884142]  ? new_sync_read+0x118/0x1a0
[  725.888745]  ? vfs_read+0x120/0x1c0
[  725.892921]  ? do_sys_openat2+0x95/0x170
[  725.897527]  ? ksys_read+0x6d/0xf0
[  725.901613]  ? do_syscall_64+0x3b/0xc0
[  725.906053]  ? entry_SYSCALL_64_after_hwframe+0x44/0xae

[~]# ps axl|grep ndctl
0     0  2486  2433  20   0   6484  1896 -      D    ?          0:00 ndctl create-namespace -e namespace0.0 -m devdax -f
1     0  2520     1  20   0   6484   440 -      Ds   ?          0:00 /usr/bin/ndctl monitor --daemon
0  1000  6179  3707  20   0   6520  1912 -      D+   pts/11     0:00 ndctl list

Stuff unrelated to pmem appears to work fine (the box is my personal
desktop), yet after the night I found the box unresponsive even to SysRq
(but able to switch text consoles); alas, I dun goofed and lost logs from
serial -- thus I can't tell the cause.  Everything was stable beforehand
thus I assume it's related.

Full dmesg at https://angband.pl/tmp/logs/dmesg-valinor-20211020.log


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀
⣾⠁⢠⠒⠀⣿⡁ in the beginning was the boot and root floppies and they were good.
⢿⡄⠘⠷⠚⠋⠀                                                       -- <willmore>
⠈⠳⣄⠀⠀⠀⠀
