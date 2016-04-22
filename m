Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22c.google.com (mail-oi0-x22c.google.com
 [IPv6:2607:f8b0:4003:c06::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C15451A214E
 for <linux-nvdimm@lists.01.org>; Fri, 22 Apr 2016 16:10:41 -0700 (PDT)
Received: by mail-oi0-x22c.google.com with SMTP id x201so130411837oif.3
 for <linux-nvdimm@lists.01.org>; Fri, 22 Apr 2016 16:10:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <571AAD01.3080801@hpe.com>
References: <146135442234.4228.904225076597683142.stgit@dwillia2-desk3.amr.corp.intel.com>
 <146135444310.4228.7151000859132505494.stgit@dwillia2-desk3.amr.corp.intel.com>
 <571AAD01.3080801@hpe.com>
Date: Fri, 22 Apr 2016 16:10:40 -0700
Message-ID: <CAPcyv4gctBiUn9_D6bR-hBs1Gof_VxOq56GMp5XnNAx=x44rvQ@mail.gmail.com>
Subject: Re: [ndctl PATCH 4/8] ndctl, create-namespace: report failures due to
 namespace being mounted
From: Dan Williams <dan.j.williams@intel.com>
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

On Fri, Apr 22, 2016 at 4:00 PM, Linda Knippers <linda.knippers@hpe.com> wrote:
> On 4/22/2016 3:47 PM, Dan Williams wrote:
>> In the case when a filesystem is mounted on a namespace targeted for
>> reconfiguration or destruction, emit a message so the user knows to
>> unmount the filesystem.
>>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  builtin-xaction-namespace.c |    2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/builtin-xaction-namespace.c b/builtin-xaction-namespace.c
>> index 53ff82bc2c8d..e2e6d518c64d 100644
>> --- a/builtin-xaction-namespace.c
>> +++ b/builtin-xaction-namespace.c
>> @@ -550,6 +550,8 @@ static int namespace_destroy(struct ndctl_region *region,
>>                        * stopping the !bdev case from racing to mount an fs or
>>                        * re-enabling the namepace.
>>                        */
>> +                     error("%s: %s is mounted, failing operation\n",
>> +                                     devname, bdev);
>
> I'm seeing this error message in cases where the device is not mounted,
> such as when I forget to run ndctl as root/sudo.  That's a more
> likely reason that the open() may fail.  Perhaps you could check the
> errno from the open() failure and display an error based on that?
> You might simply do a perror().
>

Ah, thanks Linda!  Yes, checking for EACESS vs EBUSY should do the trick here.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
