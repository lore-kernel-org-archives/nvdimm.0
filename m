Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x233.google.com (mail-oi0-x233.google.com
 [IPv6:2607:f8b0:4003:c06::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0C4CB21F3C181
 for <linux-nvdimm@lists.01.org>; Wed, 11 Oct 2017 06:56:02 -0700 (PDT)
Received: by mail-oi0-x233.google.com with SMTP id m198so3191919oig.5
 for <linux-nvdimm@lists.01.org>; Wed, 11 Oct 2017 06:59:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171011135415.6omvzcdflflqghbo@XZHOUW.usersys.redhat.com>
References: <20170925014006.5tvdkjszrbj6uhgc@XZHOUW.usersys.redhat.com>
 <20170925084903.fsjgrn7rfernou5j@hades.localdomain>
 <20171011135415.6omvzcdflflqghbo@XZHOUW.usersys.redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 11 Oct 2017 06:59:31 -0700
Message-ID: <CAPcyv4gGgFtTQ1f2BxtY_55Msg=qDppW9X_kamnroKDZOJ09BA@mail.gmail.com>
Subject: Re: ffsb job does not exit on xfs 4.14-rc1+
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
To: Xiong Zhou <xzhou@redhat.com>
Cc: linux-xfs@vger.kernel.org, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Oct 11, 2017 at 6:54 AM, Xiong Zhou <xzhou@redhat.com> wrote:
> On Mon, Sep 25, 2017 at 10:49:03AM +0200, Carlos Maiolino wrote:
>> On Mon, Sep 25, 2017 at 01:40:06AM +0000, Xiong Zhou wrote:
>> > Hi,
>> >
>> > ffsb test won't exit like this on Linus tree 4.14-rc1+.
>> > Latest commit cd4175b11685
>>
>> Can you provide more information? Do you have any kernel log from this issue?
>> dmesg, Oopses, traces, etc.
>> Storage configuration might also be required here.
>
> Turns out this only repreduces on nvdimm devices, xfs without dax
> mount option. More logs are attached.
>
>>
>> have you also tried to reproduce it with another filesystem? If so, is the same
>> problem reproducible with another filesystem or only with XFS?
>
> Only xfs. Test on ext4 ends shortly.
>
>>
>> P.S. please avoid sending it to all lists (mainly LKML).
>
> Why?  I thought LKML was better archived.
>
>> Unless it's a more generic kernel problem, keep it in fsdevel and/or the
>> respective filesystem list if it's related to a single filesystem only.
>
> 4.14-rc1+ won't survive this script, while 4.13 can.

Can you try a git bisect?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
