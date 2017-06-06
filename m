Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x22d.google.com (mail-ot0-x22d.google.com
 [IPv6:2607:f8b0:4003:c0f::22d])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 90B1E21959CD6
 for <linux-nvdimm@lists.01.org>; Tue,  6 Jun 2017 09:41:09 -0700 (PDT)
Received: by mail-ot0-x22d.google.com with SMTP id a2so18824865oth.2
 for <linux-nvdimm@lists.01.org>; Tue, 06 Jun 2017 09:42:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170606145109.7B82.E1E9C6FF@jp.fujitsu.com>
References: <CAPcyv4hGL8ZXfsnN4jossEr2VEFSA7iBaAnx94czryBy7cDahQ@mail.gmail.com>
 <c769be43-0c73-8934-06a0-0c5b6f6a975d@gmail.com>
 <20170606145109.7B82.E1E9C6FF@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 6 Jun 2017 09:42:15 -0700
Message-ID: <CAPcyv4gaPFQhkdRYPo3UDQRWqPw4W31P9pazeHqUkHKpBU9WCQ@mail.gmail.com>
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
Cc: Yasunori Goto <ygotopersonal@gmail.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 5, 2017 at 10:51 PM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
> Hi,
>
>> > No, you're not doing anything wrong. This is a known issue that I am
>> > investigating. The reports of this usually come from distributions
>> > with older module loading infrastructure. If you can try with a recent
>> > Fedora that would mimic the environment I normally use to test,
>>
>> Oh, I see. Certainly, I used CentOS7.
>> Ok, I'll use Fedora environment.
>
> Hmmm, though I made Fedora 25 environment, this panic still occurs...
> I'll attach syslog and .config again.
>
>
[..]
> [  117.804948] general protection fault: 0000 [#1] SMP
[..]
> [  117.820866] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[..]
> [  117.843262] Call Trace:
> [  117.843985]  release_nodes+0x76/0x260
> [  117.845062]  devres_release_all+0x3c/0x50
> [  117.846225]  device_release_driver_internal+0x159/0x200
> [  117.847748]  device_release_driver+0x12/0x20
> [  117.849029]  bus_remove_device+0xfd/0x170
> [  117.850192]  device_del+0x1e8/0x330
> [  117.851284]  platform_device_del+0x28/0x90
> [  117.852485]  platform_device_unregister+0x12/0x30
> [  117.853846]  nfit_test_exit+0x2a/0x93b [nfit_test]
> [  117.855219]  SyS_delete_module+0x171/0x250
> [  117.856403]  entry_SYSCALL_64_fastpath+0x1a/0xa5

Can you also attach the qemu-kvm command line you are using?

    ps aux | grep qemu
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
