Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x231.google.com (mail-ot0-x231.google.com
 [IPv6:2607:f8b0:4003:c0f::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DB87E21A143F5
 for <linux-nvdimm@lists.01.org>; Thu, 15 Jun 2017 14:28:55 -0700 (PDT)
Received: by mail-ot0-x231.google.com with SMTP id u13so4079834otd.2
 for <linux-nvdimm@lists.01.org>; Thu, 15 Jun 2017 14:29:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170615140413.5955.E1E9C6FF@jp.fujitsu.com>
References: <20170614114155.6D1E.E1E9C6FF@jp.fujitsu.com>
 <CAPcyv4imhz5b1znjn1z9ak9aMijYmbJqZ5xcL5YT_b420jhnTQ@mail.gmail.com>
 <20170615140413.5955.E1E9C6FF@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 15 Jun 2017 14:29:34 -0700
Message-ID: <CAPcyv4he6DToaEpugVMfXEf42o=MO7FjP5j6JrkGX--0nLogZw@mail.gmail.com>
Subject: Re: Panic when make check for ndctl
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
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jun 14, 2017 at 10:04 PM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
>>
>> Care to resend this as a formal patch with a "Signed-off-by:"? I'll
>> get it applied.
>
> Ok!
>
> -----
>     Fix the panic when nfit_test.ko is used.
>
>     The root cause of panic is the num_pm of nfit_test1 is wrong.
>     Though 1 is specified for num_pm at nfit_test_init(), it must be 2,
>     because nfit_test1->spa_set[] array has 2 elements.
>
>     Since the array is smaller than expected, the driver breaks other area.
>     (it is often the link list of devres).
>
>     As a result, panic occurs like the following example.
>     ---
>       117.741905] CPU: 4 PID: 2233 Comm: lt-libndctl Tainted: G           O    4.12.0-rc1+ #12
>     [  117.744461] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
>     [  117.746310] task: ffff88041d685500 task.stack: ffffc90002b50000
>     [  117.748198] RIP: 0010:__list_del_entry_valid+0x6c/0xa0
>     [  117.751084] RSP: 0018:ffffc90002b53d60 EFLAGS: 00010046
>     [  117.753142] RAX: 0000000000000054 RBX: ffffc9001700e000 RCX: 0000000000000000
>     [  117.755955] RDX: 0000000000000000 RSI: ffff88043310e0a8 RDI: ffff88043310e0a8
>     [  117.758745] RBP: ffffc90002b53d60 R08: 00000000fffffffe R09: 0000000000000382
>     [  117.760801] R10: 0000000000000005 R11: 0000000000000381 R12: ffffc90002b53d98
>     [  117.762949] R13: ffffc9001700e000 R14: 0000000000000000 R15: ffff88041beefc08
>     [  117.765000] FS:  00007f7d70082c80(0000) GS:ffff880433100000(0000) knlGS:0000000000000000
>     [  117.767300] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>     [  117.768962] CR2: 000055c0db522cc0 CR3: 0000000422156000 CR4: 00000000000006e0
>     [  117.770975] Call Trace:
>     [  117.771716]  release_nodes+0x76/0x260
>     [  117.772797]  devres_release_all+0x3c/0x50
>     [  117.773981]  device_release_driver_internal+0x159/0x200
>     [  117.775494]  device_release_driver+0x12/0x20
>     [  117.776763]  bus_remove_device+0xfd/0x170
>     [  117.777924]  device_del+0x1e8/0x330
>     [  117.778943]  platform_device_del+0x28/0x90
>     [  117.780129]  platform_device_unregister+0x12/0x30
>     [  117.781483]  nfit_test_exit+0x2a/0x93b [nfit_test]
>     [  117.782858]  SyS_delete_module+0x171/0x250
>     [  117.784044]  entry_SYSCALL_64_fastpath+0x1a/0xa5
>     ---
>

Thanks, applied.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
