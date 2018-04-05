Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-vk0-x243.google.com (mail-vk0-x243.google.com
 [IPv6:2607:f8b0:400c:c05::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E4EEA225264BB
 for <linux-nvdimm@lists.01.org>; Thu,  5 Apr 2018 05:24:09 -0700 (PDT)
Received: by mail-vk0-x243.google.com with SMTP id v205so12862985vkv.13
 for <linux-nvdimm@lists.01.org>; Thu, 05 Apr 2018 05:24:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOSf1CFy0im+H368Krr2QVteAumq58CRF_Kfatyv7wvj1n4AGw@mail.gmail.com>
References: <20180405071500.22320-1-bsingharora@gmail.com>
 <20180405071500.22320-3-bsingharora@gmail.com>
 <CAOSf1CFy0im+H368Krr2QVteAumq58CRF_Kfatyv7wvj1n4AGw@mail.gmail.com>
From: Balbir Singh <bsingharora@gmail.com>
Date: Thu, 5 Apr 2018 22:24:07 +1000
Message-ID: <CAKTCnzngahex_sL2raoHFuXqTxgVV7a57R9YmcT1TN-ROsFXnw@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] powerpc/memcpy: Add memcpy_mcsafe for pmem
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
To: Oliver <oohall@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, Nicholas Piggin <npiggin@gmail.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Apr 5, 2018 at 9:26 PM, Oliver <oohall@gmail.com> wrote:
> On Thu, Apr 5, 2018 at 5:14 PM, Balbir Singh <bsingharora@gmail.com> wrote:
>> The pmem infrastructure uses memcpy_mcsafe in the pmem
>> layer so as to convert machine check excpetions into
>> a return value on failure in case a machine check
>> exception is encoutered during the memcpy.
>>
>
> Would it be possible to move the bulk of the copyuser code into a
> seperate file which can be #included once the these err macros are
> defined? Anton's memcpy is pretty hairy and I don't think anyone wants
> to have multiple copies of it in the tree, even in a cut down form.
>

I've split it out for now, in the future that might be a good thing to do.
The copy_tofrom_user_power7 falls backs on __copy_tofrom_user_base
to track exactly how much is left over. Adding these changes there would
create a larger churn and need way more testing. I've taken this short-cut
for now with a promise to fix that as the semantics of memcpy_mcsafe()
change to do more accurate tracking of how much was copied over.

Balbir Singh.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
