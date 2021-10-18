Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24332C87
	for <nvdimm@lists.linux.dev>; Mon, 18 Oct 2021 11:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1634555804;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=R6h7/3FNjDfW/aKcBxh4pRXGx+3VwDT0FJcpENMpRN8=;
	b=DK8JbShXbsslOnok8hoZSYiEfU6iQ+q2+OutQb4V7hlHWPwt1HR8Yo9rqN6tnbFaU3EOdB
	7C/vo1V0sL165JkYyPZI+yyfrqsi1ls98JKsCF/XEy7p0Jpnltm/uVxRzo8ULVGU59u2Re
	aQKWtx4HxG9LN5cn9lX735SFH6KQGbI=
Received: from mail-yb1-f200.google.com (mail-yb1-f200.google.com
 [209.85.219.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-MEde9ARGPqWIyDkFzwlYFg-1; Mon, 18 Oct 2021 07:16:43 -0400
X-MC-Unique: MEde9ARGPqWIyDkFzwlYFg-1
Received: by mail-yb1-f200.google.com with SMTP id b197-20020a2534ce000000b005b71a4e189eso19904720yba.5
        for <nvdimm@lists.linux.dev>; Mon, 18 Oct 2021 04:16:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R6h7/3FNjDfW/aKcBxh4pRXGx+3VwDT0FJcpENMpRN8=;
        b=I6saBIA32lKTKRBwpjshZJgrDeTrrhHvGgIhwMcILS6wKXICRpmAgkc9jwy5FZlrh+
         XCa/LZa8C01ziidG05ayFSQfDi+QnnQKJuQcucXtJS+qZ900VqJk8qkQmIprN6oS0xMA
         t+bgx0vQ2NZ7CQkRA9pkA4tT2vbSzXerWOmQYVOlWfzL5ieQWdnUN4xNMTt58bcHlv31
         qiM0Oq+YezlbIqB+KREPUjfAbI4qqfZzA69Jv4VVRwIHwNqaP8nFcwVU8djlcz5s9qAk
         +xoBC1yuwAQ/iiR5bvL+CAKwbrvwwb7ky9AD3gS+9bzyt0ZQRplISrq2Jtt/512nP65j
         WKbw==
X-Gm-Message-State: AOAM533wvTdbOMr4Kiq+ORoLefGYdSCMiAt6zL+NEmfSvsiyygGVYHnm
	92DW9MNcjfQG81rFZ1eHXtbBs2yU9tPygEIh2HzoekeA0dyVbsrroDZVuF4kBOii7RCWWuywS0f
	Uhk04Y61L47XBGb0fR7Anl0rWPQZkbrE4
X-Received: by 2002:a25:ab61:: with SMTP id u88mr26783600ybi.241.1634555803061;
        Mon, 18 Oct 2021 04:16:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy7WTOdSKB7LlvZkTpwlJxiajoe0o0gnrnQwozz2NUxnacq8lDOE+Iq7CMj7WnbifWc0WhlJlgAh1LOrFTEqOY=
X-Received: by 2002:a25:ab61:: with SMTP id u88mr26783578ybi.241.1634555802803;
 Mon, 18 Oct 2021 04:16:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAHj4cs87BapQJcV0a=M6=dc9PrsGH6qzqJEt9fbjLK1aShnMPg@mail.gmail.com>
In-Reply-To: <CAHj4cs87BapQJcV0a=M6=dc9PrsGH6qzqJEt9fbjLK1aShnMPg@mail.gmail.com>
From: Yi Zhang <yi.zhang@redhat.com>
Date: Mon, 18 Oct 2021 19:16:07 +0800
Message-ID: <CAHj4cs-dw7voqLumMHCSdxMAArFs=v=mvtyFLLU6tQP91U2eLg@mail.gmail.com>
Subject: Fwd: [regression] ndctl destroy-namespace operation hang from 5.15.0-rc6
To: Linux NVDIMM <nvdimm@lists.linux.dev>, linux-block <linux-block@vger.kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=yizhan@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"

Forward to the right nvdimm mailist

---------- Forwarded message ---------
From: Yi Zhang <yi.zhang@redhat.com>
Date: Mon, Oct 18, 2021 at 7:10 PM
Subject: [regression] ndctl destroy-namespace operation hang from 5.15.0-rc6
To: linux-nvdimm <linux-nvdimm@lists.01.org>, linux-block
<linux-block@vger.kernel.org>


Hello

This regression was introduced from 5.15.0-rc6, pls help check it, thanks.

# ndctl list -N
[
  {
    "dev":"namespace1.0",
    "mode":"fsdax",
    "map":"dev",
    "size":16909336576,
    "uuid":"979a045b-6fac-4755-904d-3283a561c74d",
    "sector_size":512,
    "align":2097152,
    "blockdev":"pmem1"
  }
]

# ndctl destroy-namespace all -r all -f         ---> hang

[  246.608610] INFO: task ndctl:1934 blocked for more than 122 seconds.
[  246.614973]       Tainted: G S        I       5.15.0-rc6 #1
[  246.620546] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  246.628373] task:ndctl           state:D stack:    0 pid: 1934
ppid:  1896 flags:0x00004000
[  246.628377] Call Trace:
[  246.628379]  __schedule+0x382/0x8c0
[  246.628385]  schedule+0x3a/0xa0
[  246.628386]  blk_mq_freeze_queue_wait+0x62/0x90
[  246.628391]  ? finish_wait+0x80/0x80
[  246.628396]  del_gendisk+0xbb/0x210
[  246.628399]  release_nodes+0x39/0xa0
[  246.628403]  devres_release_all+0x88/0xc0
[  246.628406]  device_release_driver_internal+0x107/0x1e0
[  246.628410]  unbind_store+0xf0/0x120
[  246.628412]  kernfs_fop_write_iter+0x12d/0x1c0
[  246.628416]  new_sync_write+0x11f/0x1b0
[  246.628420]  vfs_write+0x184/0x260
[  246.628422]  ksys_write+0x59/0xd0
[  246.628423]  do_syscall_64+0x37/0x80
[  246.628426]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  246.628430] RIP: 0033:0x7f1b0c7db648
[  246.628432] RSP: 002b:00007ffd68b47088 EFLAGS: 00000246 ORIG_RAX:
0000000000000001
[  246.628433] RAX: ffffffffffffffda RBX: 000000000074cb60 RCX: 00007f1b0c7db648
[  246.628435] RDX: 0000000000000007 RSI: 000000000074cb60 RDI: 0000000000000006
[  246.628436] RBP: 0000000000000007 R08: 000000000074cb20 R09: 00007f1b0c86e620
[  246.628436] R10: 0000000000000016 R11: 0000000000000246 R12: 0000000000000006
[  246.628437] R13: 00007f1b0d92c7e8 R14: 0000000000000000 R15: 000000000074c820
[  369.483990] INFO: task ndctl:1934 blocked for more than 245 seconds.
[  369.490348]       Tainted: G S        I       5.15.0-rc6 #1
[  369.495922] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  369.503747] task:ndctl           state:D stack:    0 pid: 1934
ppid:  1896 flags:0x00004000
[  369.503750] Call Trace:
[  369.503752]  __schedule+0x382/0x8c0
[  369.503757]  schedule+0x3a/0xa0
[  369.503759]  blk_mq_freeze_queue_wait+0x62/0x90
[  369.503763]  ? finish_wait+0x80/0x80
[  369.503768]  del_gendisk+0xbb/0x210
[  369.503771]  release_nodes+0x39/0xa0
[  369.503774]  devres_release_all+0x88/0xc0
[  369.503778]  device_release_driver_internal+0x107/0x1e0
[  369.503782]  unbind_store+0xf0/0x120
[  369.503784]  kernfs_fop_write_iter+0x12d/0x1c0
[  369.503788]  new_sync_write+0x11f/0x1b0
[  369.503792]  vfs_write+0x184/0x260
[  369.503793]  ksys_write+0x59/0xd0
[  369.503795]  do_syscall_64+0x37/0x80
[  369.503797]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  369.503801] RIP: 0033:0x7f1b0c7db648
[  369.503803] RSP: 002b:00007ffd68b47088 EFLAGS: 00000246 ORIG_RAX:
0000000000000001
[  369.503805] RAX: ffffffffffffffda RBX: 000000000074cb60 RCX: 00007f1b0c7db648
[  369.503806] RDX: 0000000000000007 RSI: 000000000074cb60 RDI: 0000000000000006
[  369.503807] RBP: 0000000000000007 R08: 000000000074cb20 R09: 00007f1b0c86e620
[  369.503808] R10: 0000000000000016 R11: 0000000000000246 R12: 0000000000000006
[  369.503809] R13: 00007f1b0d92c7e8 R14: 0000000000000000 R15: 000000000074c820
[  492.359355] INFO: task kworker/u64:17:188 blocked for more than 122 seconds.
[  492.366399]       Tainted: G S        I       5.15.0-rc6 #1
[  492.371973] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  492.379796] task:kworker/u64:17  state:D stack:    0 pid:  188
ppid:     2 flags:0x00004000
[  492.379800] Workqueue: nfit acpi_nfit_scrub [nfit]
[  492.379806] Call Trace:
[  492.379807]  __schedule+0x382/0x8c0
[  492.379811]  schedule+0x3a/0xa0
[  492.379813]  schedule_preempt_disabled+0xa/0x10
[  492.379815]  __mutex_lock.isra.11+0x329/0x440
[  492.379818]  nd_device_notify+0x1e/0x50 [libnvdimm]
[  492.379827]  ? nd_region_conflict+0x70/0x70 [libnvdimm]
[  492.379837]  child_notify+0xc/0x10 [libnvdimm]
[  492.379847]  device_for_each_child+0x54/0x90
[  492.379850]  nd_region_notify+0x3a/0xd0 [libnvdimm]
[  492.379860]  nd_device_notify+0x3b/0x50 [libnvdimm]
[  492.379867]  ars_complete+0x68/0xa0 [nfit]
[  492.379871]  acpi_nfit_scrub+0xa1/0x3a0 [nfit]
[  492.379875]  ? __switch_to_asm+0x42/0x70
[  492.379878]  ? finish_task_switch+0xaf/0x2c0
[  492.379881]  process_one_work+0x1cb/0x370
[  492.379883]  worker_thread+0x30/0x380
[  492.379885]  ? process_one_work+0x370/0x370
[  492.379887]  kthread+0x118/0x140
[  492.379889]  ? set_kthread_struct+0x40/0x40
[  492.379891]  ret_from_fork+0x1f/0x30
[  492.379912] INFO: task ndctl:1934 blocked for more than 368 seconds.
[  492.386262]       Tainted: G S        I       5.15.0-rc6 #1
[  492.391834] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  492.399659] task:ndctl           state:D stack:    0 pid: 1934
ppid:  1896 flags:0x00004000
[  492.399661] Call Trace:
[  492.399662]  __schedule+0x382/0x8c0
[  492.399664]  schedule+0x3a/0xa0
[  492.399665]  blk_mq_freeze_queue_wait+0x62/0x90
[  492.399670]  ? finish_wait+0x80/0x80
[  492.399673]  del_gendisk+0xbb/0x210
[  492.399676]  release_nodes+0x39/0xa0
[  492.399678]  devres_release_all+0x88/0xc0
[  492.399681]  device_release_driver_internal+0x107/0x1e0
[  492.399684]  unbind_store+0xf0/0x120
[  492.399687]  kernfs_fop_write_iter+0x12d/0x1c0
[  492.399690]  new_sync_write+0x11f/0x1b0
[  492.399694]  vfs_write+0x184/0x260
[  492.399695]  ksys_write+0x59/0xd0
[  492.399697]  do_syscall_64+0x37/0x80
[  492.399699]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  492.399702] RIP: 0033:0x7f1b0c7db648
[  492.399703] RSP: 002b:00007ffd68b47088 EFLAGS: 00000246 ORIG_RAX:
0000000000000001
[  492.399706] RAX: ffffffffffffffda RBX: 000000000074cb60 RCX: 00007f1b0c7db648
[  492.399707] RDX: 0000000000000007 RSI: 000000000074cb60 RDI: 0000000000000006
[  492.399708] RBP: 0000000000000007 R08: 000000000074cb20 R09: 00007f1b0c86e620
[  492.399709] R10: 0000000000000016 R11: 0000000000000246 R12: 0000000000000006
[  492.399709] R13: 00007f1b0d92c7e8 R14: 0000000000000000 R15: 000000000074c820



--
Best Regards,
  Yi Zhang


-- 
Best Regards,
  Yi Zhang

