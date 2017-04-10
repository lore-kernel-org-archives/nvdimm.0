Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B2AD621939252
 for <linux-nvdimm@lists.01.org>; Mon, 10 Apr 2017 08:57:17 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: KASLR causes intermittent boot failures on some systems
References: <x49shlk700k.fsf@segfault.boston.devel.redhat.com>
 <20170408040837.GD4111@x1>
Date: Mon, 10 Apr 2017 11:57:15 -0400
In-Reply-To: <20170408040837.GD4111@x1> (Baoquan He's message of "Sat, 8 Apr
 2017 12:08:37 +0800")
Message-ID: <x498tn85k84.fsf@segfault.boston.devel.redhat.com>
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
To: Baoquan He <bhe@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, thgarnie@google.com, mingo@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Baoquan He <bhe@redhat.com> writes:

> On 04/07/17 at 10:41am, Jeff Moyer wrote:
>> Hi,
>> 
>> commit 021182e52fe01 ("x86/mm: Enable KASLR for physical mapping memory
>> regions") causes some of my systems with persistent memory (whether real
>> or emulated) to fail to boot with a couple of different crash
>> signatures.  The first signature is a NMI watchdog lockup of all but 1
>> cpu, which causes much difficulty in extracting useful information from
>> the console.  The second variant is an invalid paging request, listed
>> below.
>> 
>> On some systems, I haven't hit this problem at all.  Other systems
>> experience a failed boot maybe 20-30% of the time.  To reproduce it,
>> configure some emulated pmem on your system.  You can find directions
>> for that here: https://nvdimm.wiki.kernel.org/
>
> I got below problem when configure ndctl, didn't find a package named
> libkmod:

Sorry, you can skip the ndctl step altogether.  This is emulated pmem,
so the setting won't stick anyway.

-Jeff
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
