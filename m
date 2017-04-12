Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3A4A2207E57FA
 for <linux-nvdimm@lists.01.org>; Wed, 12 Apr 2017 01:27:51 -0700 (PDT)
Date: Wed, 12 Apr 2017 16:27:44 +0800
From: Dave Young <dyoung@redhat.com>
Subject: Re: KASLR causes intermittent boot failures on some systems
Message-ID: <20170412082744.GA3766@dhcp-128-65.nay.redhat.com>
References: <x49shlk700k.fsf@segfault.boston.devel.redhat.com>
 <20170412082433.GA3546@dhcp-128-65.nay.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170412082433.GA3546@dhcp-128-65.nay.redhat.com>
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
Cc: bhe@redhat.com, linux-nvdimm@lists.01.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, mingo@kernel.org, thgarnie@google.com
List-ID: <linux-nvdimm@lists.01.org>

On 04/12/17 at 04:24pm, Dave Young wrote:
> On 04/07/17 at 10:41am, Jeff Moyer wrote:
> > Hi,
> > 
> > commit 021182e52fe01 ("x86/mm: Enable KASLR for physical mapping memory
> > regions") causes some of my systems with persistent memory (whether real
> > or emulated) to fail to boot with a couple of different crash
> > signatures.  The first signature is a NMI watchdog lockup of all but 1
> > cpu, which causes much difficulty in extracting useful information from
> > the console.  The second variant is an invalid paging request, listed
> > below.
> > 
> > On some systems, I haven't hit this problem at all.  Other systems
> > experience a failed boot maybe 20-30% of the time.  To reproduce it,
> > configure some emulated pmem on your system.  You can find directions
> > for that here: https://nvdimm.wiki.kernel.org/
> > 
> > Install ndctl (https://github.com/pmem/ndctl).
> > Configure the namespace:
> > # ndctl create-namespace -f -e namespace0.0 -m memory
> > 
> > Then just reboot several times (5 should be enough), and hopefully
> > you'll hit the issue.
> > 
> > I've attached both my .config and the dmesg output from a successful
> > boot at the end of this mail.
> > 
> [snip]
> 
> I did some tests about emulated pmem via memmap=, kdump kernel hangs or
> just reboots early during compressing kernel, no clue how to handle it.

s/compressing/uncompressing

> Since for kdump kernel kaslr is pointless a workaround is use "nokaslr"
> 
> In Fedora or RHEL, just add "nokaslr" in KDUMP_COMMANDLINE_APPEND
> in /etc/sysconfig/kdump 
> 
> Can you try if this works?
> 
> Thanks
> Dave
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
