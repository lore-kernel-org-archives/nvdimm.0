Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wr0-x235.google.com (mail-wr0-x235.google.com
 [IPv6:2a00:1450:400c:c0c::235])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2F8F421A0480F
 for <linux-nvdimm@lists.01.org>; Sat,  8 Apr 2017 00:02:08 -0700 (PDT)
Received: by mail-wr0-x235.google.com with SMTP id c55so47123347wrc.3
 for <linux-nvdimm@lists.01.org>; Sat, 08 Apr 2017 00:02:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170408040837.GD4111@x1>
References: <x49shlk700k.fsf@segfault.boston.devel.redhat.com>
 <20170408040837.GD4111@x1>
From: Dan Williams <dan.j.williams@gmail.com>
Date: Sat, 8 Apr 2017 00:02:06 -0700
Message-ID: <CAA9_cmcB2Ctxya6yNj6535WashWArsEr2kf1b3bq82=Dsy5fmA@mail.gmail.com>
Subject: Re: KASLR causes intermittent boot failures on some systems
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
Cc: Ingo Molnar <mingo@kernel.org>, thgarnie@google.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Apr 7, 2017 at 9:08 PM, Baoquan He <bhe@redhat.com> wrote:
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
>
> ~~~~~~~~~
> configure: error: Package requirements (libkmod) were not met:
>
> No package 'libkmod' found

kmod-devel provides that dependency. Otherwise ndctl is included in
Fedora or you can find EPEL 7 packages here:

https://copr.fedorainfracloud.org/coprs/djbw/ndctl/
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
