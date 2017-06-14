Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x236.google.com (mail-ot0-x236.google.com
 [IPv6:2607:f8b0:4003:c0f::236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D30E721A16EC1
 for <linux-nvdimm@lists.01.org>; Tue, 13 Jun 2017 20:03:57 -0700 (PDT)
Received: by mail-ot0-x236.google.com with SMTP id s7so8434660otb.3
 for <linux-nvdimm@lists.01.org>; Tue, 13 Jun 2017 20:05:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170614114155.6D1E.E1E9C6FF@jp.fujitsu.com>
References: <CAPcyv4gaPFQhkdRYPo3UDQRWqPw4W31P9pazeHqUkHKpBU9WCQ@mail.gmail.com>
 <20170607093328.BE75.E1E9C6FF@jp.fujitsu.com>
 <20170614114155.6D1E.E1E9C6FF@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 13 Jun 2017 20:05:11 -0700
Message-ID: <CAPcyv4iuCqWPp2XZ7UVEFpVWJ667zfoS08HBQYHazcP9RVquAQ@mail.gmail.com>
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

On Tue, Jun 13, 2017 at 7:41 PM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
> Hi, Dan-san, Linda-san,
>
> I had chased the root cause of this panic problem, and maybe I found it.
>
>> > > Hmmm, though I made Fedora 25 environment, this panic still occurs...
>> > > I'll attach syslog and .config again.
>> > >
>> > >
>> > [..]
>> > > [  117.804948] general protection fault: 0000 [#1] SMP
>> > [..]
>> > > [  117.820866] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
>> > [..]
>> > > [  117.843262] Call Trace:
>> > > [  117.843985]  release_nodes+0x76/0x260
>> > > [  117.845062]  devres_release_all+0x3c/0x50
>> > > [  117.846225]  device_release_driver_internal+0x159/0x200
>> > > [  117.847748]  device_release_driver+0x12/0x20
>> > > [  117.849029]  bus_remove_device+0xfd/0x170
>> > > [  117.850192]  device_del+0x1e8/0x330
>> > > [  117.851284]  platform_device_del+0x28/0x90
>> > > [  117.852485]  platform_device_unregister+0x12/0x30
>> > > [  117.853846]  nfit_test_exit+0x2a/0x93b [nfit_test]
>> > > [  117.855219]  SyS_delete_module+0x171/0x250
>> > > [  117.856403]  entry_SYSCALL_64_fastpath+0x1a/0xa5
>> >
>> > Can you also attach the qemu-kvm command line you are using?
>> >
>> >     ps aux | grep qemu
>
>
> The cause of this problem is the num_pm of nfit_test1 is wrong.
> Though 1 is specified for num_pm at nfit_test_init(), it must be 2.
>
> ----
> static __init int nfit_test_init(void)
> {
>         int rc, i;
>         :
>         :
>                 case 1:
>                         nfit_test->num_pm = 1;            <---- !!!
>                         nfit_test->dcr_idx = NUM_DCR;
> -----
>
> The num_pm affects size of devm_kcalloc() at nfit_test_probe().
>
> ----
> static int nfit_test_probe(struct platform_device *pdev)
> {
>         if (nfit_test->num_pm) {
>                 int num = nfit_test->num_pm;   <----!!!
>
>                 nfit_test->spa_set = devm_kcalloc(dev, num, sizeof(void *),
>                                 GFP_KERNEL);   <---!!!!
>                 nfit_test->spa_set_dma = devm_kcalloc(dev, num,
>                                 sizeof(dma_addr_t), GFP_KERNEL);
> -----
>
> However,  spa_set[] array needs 2 elements at nfit_test1_alloc().
>
> ---
> static int nfit_test1_alloc(struct nfit_test *t)
> {
>                :
>         t->spa_set[0] = test_alloc(t, SPA2_SIZE, &t->spa_set_dma[0]);  <--- first element
>         if (!t->spa_set[0])
>                 return -ENOMEM;
>                :
>
>        t->spa_set[1] = test_alloc(t, SPA_VCD_SIZE, &t->spa_set_dma[1]);  <---- The second element!!!!
> -----
>
> This breaks other area, and the area is often the link list of devres.
> As a result, the panic occured on release_nodes().
>
> I confirmed that this panic never occurred with the following patch.

Wow!

>
> ---
> diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
> index c218717..548b6d4 100644
> --- a/tools/testing/nvdimm/test/nfit.c
> +++ b/tools/testing/nvdimm/test/nfit.c
> @@ -1943,7 +1943,7 @@ static __init int nfit_test_init(void)
>                         nfit_test->setup = nfit_test0_setup;
>                         break;
>                 case 1:
> -                       nfit_test->num_pm = 1;
> +                       nfit_test->num_pm = 2;
>                         nfit_test->dcr_idx = NUM_DCR;
>                         nfit_test->num_dcr = 2;
>                         nfit_test->alloc = nfit_test1_alloc;

This change looks correct to me. I'm going to try it out.

...but, "Wow!" again and a big "Thank You!".
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
