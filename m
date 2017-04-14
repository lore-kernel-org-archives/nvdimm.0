Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x234.google.com (mail-oi0-x234.google.com
 [IPv6:2607:f8b0:4003:c06::234])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 993FC2194EB64
 for <linux-nvdimm@lists.01.org>; Fri, 14 Apr 2017 15:28:57 -0700 (PDT)
Received: by mail-oi0-x234.google.com with SMTP id x184so14012393oia.1
 for <linux-nvdimm@lists.01.org>; Fri, 14 Apr 2017 15:28:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <58F1494F.2080107@hpe.com>
References: <58E793E8.8070507@hpe.com>
 <CAPcyv4jfCZMpNAC=-vG0a_koAfe-Vrr_+xcHXw1=TD+3DsqN+Q@mail.gmail.com>
 <58E7C875.8050008@hpe.com> <58E7F689.8010709@hpe.com>
 <CAPcyv4gS+z_HiMrgvayDaQr2qNKtZ+6boMdDZj0hQrxJhc+U6g@mail.gmail.com>
 <58E80ABB.3040807@ymail.com>
 <CAPcyv4i7LURhWQvDtxu6Bdtr2sEEHqjPqaE6a7oBYX7raNqyCw@mail.gmail.com>
 <58F1494F.2080107@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 14 Apr 2017 15:28:56 -0700
Message-ID: <CAPcyv4hYa2B8Zg9Tw1RfBFNwXX9+m+DnwytyxwqZwWsVW-o+Ug@mail.gmail.com>
Subject: Re: panics related to nfit_test?
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
To: Linda Knippers <linda.knippers@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Apr 14, 2017 at 3:12 PM, Linda Knippers <linda.knippers@hpe.com> wrote:
> On 04/14/2017 11:50 AM, Dan Williams wrote:
>>
>> I have not been able to reproduce this panic, but does the following
>> make a difference on your systems?
>>
>> diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
>> index bc02f28ed8b8..afb7a7efc12a 100644
>> --- a/tools/testing/nvdimm/test/nfit.c
>> +++ b/tools/testing/nvdimm/test/nfit.c
>> @@ -1983,9 +1983,9 @@ static __exit void nfit_test_exit(void)
>>  {
>>         int i;
>>
>> -       platform_driver_unregister(&nfit_test_driver);
>>         for (i = 0; i < NUM_NFITS; i++)
>>                 platform_device_unregister(&instances[i]->pdev);
>> +       platform_driver_unregister(&nfit_test_driver);
>>         nfit_test_teardown();
>>         class_destroy(nfit_test_dimm);
>>  }
>
> I tried it on both of my systems.  My 72-core server has NVDIMMs and my
> 4-core laptop does not.  Both systems still panic but now
> they panic before trying to rmmod the module, which I had commented
> out of my script.  I tried it several times and got panics in different
> modules (xfs, selinux, etc) but all seem to be related to kmem.  See
> below for an example.
>
> It feels like corruption that has just moved a bit.  If you recall
> from my original mail, I reported two kinds of panics and this looks
> just like the second panic.
>
> Since it never happens for you and always happens for me, it feels
> like a build/procedure problem.  I haven't had a chance to try in
> a VM.  Have you had a chance to try on bare metal?

I have not, but I did send out a new patch that makes sure to shutdown
the nfit_test trickery before freeing the test objects.  Does this
patch cleanup any of the failures you are seeing?

https://patchwork.kernel.org/patch/9681861/
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
