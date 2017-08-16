Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8B91B21CFA605
 for <linux-nvdimm@lists.01.org>; Wed, 16 Aug 2017 09:08:34 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: ndctl oddity
References: <x49378rh74h.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4h541h1QPrSTf+fvfEoVL8yZ7VzJewjE8fQBT8TKvxmow@mail.gmail.com>
Date: Wed, 16 Aug 2017 12:10:58 -0400
In-Reply-To: <CAPcyv4h541h1QPrSTf+fvfEoVL8yZ7VzJewjE8fQBT8TKvxmow@mail.gmail.com>
 (Dan Williams's message of "Wed, 16 Aug 2017 09:07:22 -0700")
Message-ID: <x49y3qjbii5.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Dan Williams <dan.j.williams@intel.com> writes:

> On Wed, Aug 16, 2017 at 8:20 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
>> Hi, Dan,
>>
>> If I create multiple namespaces in the same region, ndctl sometimes
>> outputs the wrong chardev for the newly created namespace.  I can
>> reproduce this fairly regularly.
>>
>> Note how the chardev for the last two namespaces is the same.
>
> Are you running ndctl from the -pending branch with this commit?
>
> 77f6951b18ed daxctl: fix support for multiple instances per-region id
>
> https://github.com/pmem/ndctl/commit/77f6951b18ed

Doh.  No, I'm not.  I'll give that a try.  Sorry.

-Jeff
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
