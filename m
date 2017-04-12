Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 179F621A0483A
 for <linux-nvdimm@lists.01.org>; Wed, 12 Apr 2017 05:52:40 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: KASLR causes intermittent boot failures on some systems
References: <x49shlk700k.fsf@segfault.boston.devel.redhat.com>
 <20170412082433.GA3546@dhcp-128-65.nay.redhat.com>
 <20170412084037.GA3894@dhcp-128-65.nay.redhat.com>
Date: Wed, 12 Apr 2017 08:52:36 -0400
In-Reply-To: <20170412084037.GA3894@dhcp-128-65.nay.redhat.com> (Dave Young's
 message of "Wed, 12 Apr 2017 16:40:37 +0800")
Message-ID: <x49tw5t6b57.fsf@segfault.boston.devel.redhat.com>
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
To: Dave Young <dyoung@redhat.com>
Cc: bhe@redhat.com, linux-nvdimm@lists.01.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, mingo@kernel.org, thgarnie@google.com
List-ID: <linux-nvdimm@lists.01.org>

Dave Young <dyoung@redhat.com> writes:

> On 04/12/17 at 04:24pm, Dave Young wrote:
>> I did some tests about emulated pmem via memmap=, kdump kernel hangs or
>> just reboots early during compressing kernel, no clue how to handle it.
>> Since for kdump kernel kaslr is pointless a workaround is use "nokaslr"
>> 
>> In Fedora or RHEL, just add "nokaslr" in KDUMP_COMMANDLINE_APPEND
>> in /etc/sysconfig/kdump 
>> 
>> Can you try if this works?
>
> Oops, your problem is normal boot instead of kdump so this is two
> different problems. Seems we have not met your bug yet..

Correct.

-Jeff
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
