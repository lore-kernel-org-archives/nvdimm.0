Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw0-x22c.google.com (mail-yw0-x22c.google.com
 [IPv6:2607:f8b0:4002:c05::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 402DA21D1822E
 for <linux-nvdimm@lists.01.org>; Wed, 16 Aug 2017 09:12:37 -0700 (PDT)
Received: by mail-yw0-x22c.google.com with SMTP id l82so25529175ywc.2
 for <linux-nvdimm@lists.01.org>; Wed, 16 Aug 2017 09:15:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <x49y3qjbii5.fsf@segfault.boston.devel.redhat.com>
References: <x49378rh74h.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4h541h1QPrSTf+fvfEoVL8yZ7VzJewjE8fQBT8TKvxmow@mail.gmail.com>
 <x49y3qjbii5.fsf@segfault.boston.devel.redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 16 Aug 2017 09:15:02 -0700
Message-ID: <CAPcyv4hQGVOgsRHQB7dopr05qWrSejz0yFQ3hUrjRd+jtrKP6g@mail.gmail.com>
Subject: Re: ndctl oddity
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Aug 16, 2017 at 9:10 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Dan Williams <dan.j.williams@intel.com> writes:
>
>> On Wed, Aug 16, 2017 at 8:20 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
>>> Hi, Dan,
>>>
>>> If I create multiple namespaces in the same region, ndctl sometimes
>>> outputs the wrong chardev for the newly created namespace.  I can
>>> reproduce this fairly regularly.
>>>
>>> Note how the chardev for the last two namespaces is the same.
>>
>> Are you running ndctl from the -pending branch with this commit?
>>
>> 77f6951b18ed daxctl: fix support for multiple instances per-region id
>>
>> https://github.com/pmem/ndctl/commit/77f6951b18ed
>
> Doh.  No, I'm not.  I'll give that a try.  Sorry.

No worries, I'll either expedite a v57.2 release with that fix, or
just pull the trigger on v58.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
