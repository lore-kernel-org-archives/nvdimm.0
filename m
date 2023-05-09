Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646C28BE8
	for <nvdimm@lists.linux.dev>; Tue,  9 May 2023 10:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683627793;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=1Ot4zctPZyM3nXPR3ry6sugvosc8QAhjcGxzaYzcrWc=;
	b=jT4Mgen9B3KXecv/411YVVkPTgPbZTaM9LXNbSnVcEtXfyGoJDXgFOhUkO5whVp7rPx64Q
	DBYVHqL5mYd8Z2F7IAFWJCeCDsLlXDVPNZjQOckay41QZG1ErM2Da/fdCrfvqUrCWK+Zwr
	r4dz8V+hfAqXM2XhobNkuThN6SpYuH0=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-526-7tTh5czlOH6BZMEy6i11IQ-1; Tue, 09 May 2023 06:23:12 -0400
X-MC-Unique: 7tTh5czlOH6BZMEy6i11IQ-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-24e1e19f63fso3249868a91.0
        for <nvdimm@lists.linux.dev>; Tue, 09 May 2023 03:23:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683627790; x=1686219790;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1Ot4zctPZyM3nXPR3ry6sugvosc8QAhjcGxzaYzcrWc=;
        b=ZAC/xFJEs7o4Smdjf4qJr2PTTzCxUENMJTlBn/3eCZvkoSySPuu6yDHvPtyJQL/Oey
         d63euKRX7ZwFtdfnm9BPhU9qfyK9ydBvixpuIs4u6M+UyhLNWNZS0ObNsBTxOP+LKQdp
         tuxB/ROU/66IlvxQZlh19gWE2gH5Ss06dQ0w3vDh9K1T+ydFEt7YPqP9ONWtVbb96dZS
         67m7mZ/u2HWCE7M7oySIS78cIqKHwA//xx8Xj2t+CQ5kS3pjWiI7L2sxn1SYcR+L5iJT
         V71OBHhz8K4A5ceNMk/734M7anThZgVUYurRaA5QJXmOTVnvXrM2yEI1xCBZZALcnAIO
         i+3w==
X-Gm-Message-State: AC+VfDxJmUl6egWUfQf5u4zZ/1XRg4cKccWJcnpbE4iPOVCXvJW5gjZq
	8irWTSRTabAJT0LcowfEgyM8IlKilH4aGRooNIrPEr9kvc9fWWvRrJzFbMgkcww6nu+p8id2azk
	ToXj8/vh8fyFO3bJFnMCBEnFZhEWETdQQSXU2NlD4eI2TRg==
X-Received: by 2002:a17:90a:6089:b0:247:2680:2ad with SMTP id z9-20020a17090a608900b00247268002admr14250047pji.33.1683627790360;
        Tue, 09 May 2023 03:23:10 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ54twVnOJfQAUW6SfQO5ckx228UXXsYCUOXrvQIZ6dkzkFXuJNdbH0z7HVVMQ8zofIu66q2He1hZYr6Go9YwfE=
X-Received: by 2002:a17:90a:6089:b0:247:2680:2ad with SMTP id
 z9-20020a17090a608900b00247268002admr14250032pji.33.1683627789932; Tue, 09
 May 2023 03:23:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Yi Zhang <yi.zhang@redhat.com>
Date: Tue, 9 May 2023 18:22:58 +0800
Message-ID: <CAHj4cs9hzLD+nVpcaDKFBLWPQwXsXpTT_ngY9pFatv_UQg0TXQ@mail.gmail.com>
Subject: [bug report] BUG: KASAN: global-out-of-bounds in nfit_test_ctl+0x3e0e/0x45b0
 [nfit_test]
To: Linux NVDIMM <nvdimm@lists.linux.dev>
Cc: Dan Williams <dan.j.williams@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"

Hello
I found the issue during ndctl test suite on the latest linux tree,
pls help check it and let me know if you need any info/testing about
it, thanks.

[  350.897631] nfit_test nfit_test.0: changing numa node from -1 to 0
for nfit region [0x0000000100000000-0x0000000101ffffff]
[  350.908844] nfit_test nfit_test.0: changing target node from -1 to
0 for nfit region [0x0000000100000000-0x0000000101ffffff]
[  350.921847] nfit_test nfit_test.0: changing numa node from -1 to 0
for nfit region [0x0000000108000000-0x000000010bffffff]
[  350.932897] nfit_test nfit_test.0: changing target node from -1 to
0 for nfit region [0x0000000108000000-0x000000010bffffff]
[  350.945803] nfit_test nfit_test.0: changing numa node from -1 to 0
for nfit region [0xffffc9000f229000-0xffffc9000f22900b]
[  350.956908] nfit_test nfit_test.0: changing target node from -1 to
0 for nfit region [0xffffc9000f229000-0xffffc9000f22900b]
[  350.968253] nfit_test nfit_test.0: changing numa node from -1 to 0
for nfit region [0xffffc9000f259000-0xffffc9000f25900b]
[  350.979310] nfit_test nfit_test.0: changing target node from -1 to
0 for nfit region [0xffffc9000f259000-0xffffc9000f25900b]
[  350.990647] nfit_test nfit_test.0: changing numa node from -1 to 0
for nfit region [0xffffc9000f27a000-0xffffc9000f27a00b]
[  351.001697] nfit_test nfit_test.0: changing target node from -1 to
0 for nfit region [0xffffc9000f27a000-0xffffc9000f27a00b]
[  351.013122] nfit_test nfit_test.0: changing numa node from -1 to 0
for nfit region [0xffffc9000f321000-0xffffc9000f32100b]
[  351.024176] nfit_test nfit_test.0: changing target node from -1 to
0 for nfit region [0xffffc9000f321000-0xffffc9000f32100b]
[  351.035796] nfit_test nfit_test.0: failed to evaluate _FIT
[  351.059301] nfit_test nfit_test.1: Error found in NVDIMM nmem8
flags: save_fail restore_fail flush_fail not_armed
[  351.069672] nfit_test nfit_test.1: Error found in NVDIMM nmem9
flags: map_fail
[  351.076962] nfit_test nfit_test.1: changing numa node from -1 to 0
for nfit region [0x0000000140000000-0x0000000141ffffff]
[  351.088022] nfit_test nfit_test.1: changing target node from -1 to
0 for nfit region [0x0000000140000000-0x0000000141ffffff]
[  351.100833] nfit_test nfit_test.1: changing numa node from -1 to 0
for nfit region [0xffffc90021831000-0xffffc90021c30fff]
[  351.111882] nfit_test nfit_test.1: changing target node from -1 to
0 for nfit region [0xffffc90021831000-0xffffc90021c30fff]
[  351.127729] nd_pmem namespace5.0: unable to guarantee persistence of writes
[  351.130120] nd_pmem namespace4.0: region4 read-only, marking pmem4 read-only
[  357.182596] INFO: NMI handler (ghes_notify_nmi) took too long to
run: 2.806 msecs
[  357.797725] nd_pmem btt2.0: No existing arenas
[  360.198015] nd_pmem btt3.0: No existing arenas
[  362.826746] nd_pmem namespace5.0: unable to guarantee persistence of writes
[  362.944638] nd_pmem namespace4.0: region4 read-only, marking pmem4 read-only
[  363.073820] INFO: NMI handler (perf_event_nmi_handler) took too
long to run: 2.735 msecs
[  363.073997] perf: interrupt took too long (21304 > 2500), lowering
kernel.perf_event_max_sample_rate to 9000
[  363.116824] nd_pmem namespace4.0: region4 read-only, marking pmem4 read-only
[  363.195212] nd_pmem namespace4.0: region4 read-write, marking pmem4
read-write
[  363.214093] nd_pmem namespace4.0: region4 read-only, marking pmem4 read-only
[  363.363045] nd_pmem namespace4.0: region4 read-only, marking pmem4 read-only
[  363.560533] nd_pmem namespace4.0: region4 read-only, marking pmem4 read-only
[  363.649771] nd_pmem namespace4.0: region4 read-write, marking pmem4
read-write
[  363.666616] nd_pmem namespace4.0: region4 read-only, marking pmem4 read-only
[  363.836908] nd_pmem namespace4.0: region4 read-only, marking pmem4 read-only
[  364.794189] nfit_test nfit_test.0: changing numa node from -1 to 0
for nfit region [0x0000000100000000-0x0000000101ffffff]
[  364.805388] nfit_test nfit_test.0: changing target node from -1 to
0 for nfit region [0x0000000100000000-0x0000000101ffffff]
[  364.818350] nfit_test nfit_test.0: changing numa node from -1 to 0
for nfit region [0x0000000108000000-0x000000010bffffff]
[  364.818492] nfit_test nfit_test.0: changing target node from -1 to
0 for nfit region [0x0000000108000000-0x000000010bffffff]
[  364.820061] nfit_test nfit_test.0: changing numa node from -1 to 0
for nfit region [0xffffc90009849000-0xffffc9000984900b]
[  364.852182] nfit_test nfit_test.0: changing target node from -1 to
0 for nfit region [0xffffc90009849000-0xffffc9000984900b]
[  364.863524] nfit_test nfit_test.0: changing numa node from -1 to 0
for nfit region [0xffffc900098b9000-0xffffc900098b900b]
[  364.874581] nfit_test nfit_test.0: changing target node from -1 to
0 for nfit region [0xffffc900098b9000-0xffffc900098b900b]
[  364.885892] nfit_test nfit_test.0: changing numa node from -1 to 0
for nfit region [0xffffc900098f9000-0xffffc900098f900b]
[  364.896948] nfit_test nfit_test.0: changing target node from -1 to
0 for nfit region [0xffffc900098f9000-0xffffc900098f900b]
[  364.908261] nfit_test nfit_test.0: changing numa node from -1 to 0
for nfit region [0xffffc90009959000-0xffffc9000995900b]
[  364.919319] nfit_test nfit_test.0: changing target node from -1 to
0 for nfit region [0xffffc90009959000-0xffffc9000995900b]
[  364.930758] nfit_test nfit_test.0: failed to evaluate _FIT
[  364.953725] nfit_test nfit_test.1: Error found in NVDIMM nmem8
flags: save_fail restore_fail flush_fail not_armed
[  364.967141] nfit_test nfit_test.1: Error found in NVDIMM nmem9
flags: map_fail
[  364.974445] nfit_test nfit_test.1: changing numa node from -1 to 0
for nfit region [0x0000000140000000-0x0000000141ffffff]
[  364.985506] nfit_test nfit_test.1: changing target node from -1 to
0 for nfit region [0x0000000140000000-0x0000000141ffffff]
[  364.998233] nfit_test nfit_test.1: changing numa node from -1 to 0
for nfit region [0xffffc90021831000-0xffffc90021c30fff]
[  365.009423] nfit_test nfit_test.1: changing target node from -1 to
0 for nfit region [0xffffc90021831000-0xffffc90021c30fff]
[  365.022651] nd_pmem namespace4.0: region4 read-only, marking pmem4 read-only
[  365.024693] nd_pmem namespace5.0: unable to guarantee persistence of writes
[  366.118955] nd_pmem: probe of namespace3.1 failed with error -13
[  366.119047] nd_pmem: probe of namespace3.0 failed with error -13
[  366.143945] nd_pmem: probe of namespace2.0 failed with error -13
[  366.267885] nvdimm: probe of nmem4 failed with error -13
[  366.288765] nd_region region3: nmem4: is locked, failing probe
[  366.298333] nd_region region2: nmem4: is locked, failing probe
[  368.755920] nd_pmem btt3.0: No existing arenas
[  371.228343] nd_pmem namespace0.0: unable to guarantee persistence of writes
[  371.506555] nfit_test nfit_test.0: changing numa node from -1 to 0
for nfit region [0x0000000100000000-0x0000000101ffffff]
[  371.517629] nfit_test nfit_test.0: changing target node from -1 to
0 for nfit region [0x0000000100000000-0x0000000101ffffff]
[  371.530640] nfit_test nfit_test.0: changing numa node from -1 to 0
for nfit region [0x0000000108000000-0x000000010bffffff]
[  371.541708] nfit_test nfit_test.0: changing target node from -1 to
0 for nfit region [0x0000000108000000-0x000000010bffffff]
[  371.554485] nfit_test nfit_test.0: changing numa node from -1 to 0
for nfit region [0xffffc9000985c000-0xffffc9000985c00b]
[  371.565769] nfit_test nfit_test.0: changing target node from -1 to
0 for nfit region [0xffffc9000985c000-0xffffc9000985c00b]
[  371.577121] nfit_test nfit_test.0: changing numa node from -1 to 0
for nfit region [0xffffc900098b9000-0xffffc900098b900b]
[  371.588181] nfit_test nfit_test.0: changing target node from -1 to
0 for nfit region [0xffffc900098b9000-0xffffc900098b900b]
[  371.599511] nfit_test nfit_test.0: changing numa node from -1 to 0
for nfit region [0xffffc900098da000-0xffffc900098da00b]
[  371.610594] nfit_test nfit_test.0: changing target node from -1 to
0 for nfit region [0xffffc900098da000-0xffffc900098da00b]
[  371.621963] nfit_test nfit_test.0: changing numa node from -1 to 0
for nfit region [0xffffc900098fb000-0xffffc900098fb00b]
[  371.633036] nfit_test nfit_test.0: changing target node from -1 to
0 for nfit region [0xffffc900098fb000-0xffffc900098fb00b]
[  371.644502] nfit_test nfit_test.0: failed to evaluate _FIT
[  371.669067] nfit_test nfit_test.1: Error found in NVDIMM nmem8
flags: save_fail restore_fail flush_fail not_armed
[  371.679433] nfit_test nfit_test.1: Error found in NVDIMM nmem9
flags: map_fail
[  371.686740] nfit_test nfit_test.1: changing numa node from -1 to 0
for nfit region [0x0000000140000000-0x0000000141ffffff]
[  371.697800] nfit_test nfit_test.1: changing target node from -1 to
0 for nfit region [0x0000000140000000-0x0000000141ffffff]
[  371.710531] nfit_test nfit_test.1: changing numa node from -1 to 0
for nfit region [0xffffc90020f02000-0xffffc90021301fff]
[  371.721593] nfit_test nfit_test.1: changing target node from -1 to
0 for nfit region [0xffffc90020f02000-0xffffc90021301fff]
[  371.735324] nd_pmem namespace4.0: region4 read-only, marking pmem4 read-only
[  371.738060] nd_pmem namespace5.0: unable to guarantee persistence of writes
[  384.032955] ==================================================================
[  384.040182] BUG: KASAN: global-out-of-bounds in
nfit_test_ctl+0x3e0e/0x45b0 [nfit_test]
[  384.048196] Read of size 4 at addr ffffffffc168617c by task ndctl/4637

[  384.056223] CPU: 57 PID: 4637 Comm: ndctl Tainted: G           O
 N 6.4.0-rc1+ #1
[  384.063968] Hardware name: Intel Corporation S2600WFD/S2600WFD,
BIOS SE5C620.86B.0X.02.0001.043020191705 04/30/2019
[  384.074396] Call Trace:
[  384.076850]  <TASK>
[  384.078958]  dump_stack_lvl+0x60/0xb0
[  384.082639]  print_address_description.constprop.0+0x2c/0x3e0
[  384.088392]  print_report+0xb5/0x270
[  384.091972]  ? kasan_addr_to_slab+0x9/0xa0
[  384.096078]  ? nfit_test_ctl+0x3e0e/0x45b0 [nfit_test]
[  384.101230]  kasan_report+0x8c/0xc0
[  384.104728]  ? nfit_test_ctl+0x3e0e/0x45b0 [nfit_test]
[  384.109880]  nfit_test_ctl+0x3e0e/0x45b0 [nfit_test]
[  384.114852]  ? __nd_ioctl+0x7cc/0xe70 [libnvdimm]
[  384.119594]  ? __pfx_nfit_test_ctl+0x10/0x10 [nfit_test]
[  384.124912]  ? __pfx___mutex_lock+0x10/0x10
[  384.129109]  ? __pfx___lock_release+0x10/0x10
[  384.133479]  ? __might_fault+0xc5/0x170
[  384.137327]  __nd_ioctl+0xaa8/0xe70 [libnvdimm]
[  384.141886]  ? __pfx___nd_ioctl+0x10/0x10 [libnvdimm]
[  384.146960]  ? mutex_lock_io_nested+0x1243/0x1300
[  384.151668]  ? __pfx___mutex_unlock_slowpath+0x10/0x10
[  384.156818]  nd_ioctl+0x195/0x2b0 [libnvdimm]
[  384.161201]  __x64_sys_ioctl+0x128/0x1a0
[  384.165136]  do_syscall_64+0x59/0x90
[  384.168720]  ? asm_exc_page_fault+0x22/0x30
[  384.172916]  ? lockdep_hardirqs_on+0x79/0x100
[  384.177286]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
[  384.182343] RIP: 0033:0x7fe63603ec6b
[  384.185924] Code: 73 01 c3 48 8b 0d b5 b1 1b 00 f7 d8 64 89 01 48
83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 10 00 00
00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 85 b1 1b 00 f7 d8 64 89
01 48
[  384.204680] RSP: 002b:00007ffcfbb5d6d8 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[  384.212254] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fe63603ec6b
[  384.219392] RDX: 000000000174d138 RSI: ffffffffc0404e0a RDI: 0000000000000007
[  384.226527] RBP: 00007ffcfbb5d770 R08: 0000000000000000 R09: 00007ffcfbb5d610
[  384.233657] R10: 0000000000001000 R11: 0000000000000246 R12: 00007ffcfbb5dee8
[  384.240790] R13: 000000000040c075 R14: 0000000000447d70 R15: 00007fe636425000
[  384.247929]  </TASK>

[  384.251625] The buggy address belongs to the variable:
[  384.256763]  handle+0x1c/0xccea0 [nfit_test]

[  384.262544] Memory state around the buggy address:
[  384.267336]  ffffffffc1686000: f9 f9 f9 f9 00 07 f9 f9 f9 f9 f9 f9
00 00 00 00
[  384.274558]  ffffffffc1686080: f9 f9 f9 f9 00 00 00 00 00 00 00 00
00 00 00 00
[  384.281784] >ffffffffc1686100: 00 00 00 00 04 f9 f9 f9 f9 f9 f9 f9
00 00 00 04
[  384.289002]                                                                 ^
[  384.296138]  ffffffffc1686180: f9 f9 f9 f9 00 00 00 00 00 00 00 00
00 00 00 00
[  384.303365]  ffffffffc1686200: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00
[  384.310590] ==================================================================
[  384.317840] Disabling lock debugging due to kernel taint
[  388.782954] nd_pmem namespace0.0: unable to guarantee persistence of writes

-- 
Best Regards,
  Yi Zhang

