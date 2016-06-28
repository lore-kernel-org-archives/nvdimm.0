Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x235.google.com (mail-oi0-x235.google.com
 [IPv6:2607:f8b0:4003:c06::235])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5FDC61A1E03
 for <linux-nvdimm@lists.01.org>; Tue, 28 Jun 2016 09:33:46 -0700 (PDT)
Received: by mail-oi0-x235.google.com with SMTP id r2so30540625oih.2
 for <linux-nvdimm@lists.01.org>; Tue, 28 Jun 2016 09:33:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1467102671-593138-1-git-send-email-yigal@plexistor.com>
References: <1467102671-593138-1-git-send-email-yigal@plexistor.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 28 Jun 2016 09:33:10 -0700
Message-ID: <CAPcyv4jQA29oY2e6mVjQ=mEyBRXev3fAn1=2BH_GjzvQN6N4Rg@mail.gmail.com>
Subject: Re: [RESEND PATCH] x86/mm: only allow memmap=XX!YY over existing RAM
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
To: Yigal Korman <yigal@plexistor.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jun 28, 2016 at 1:31 AM, Yigal Korman <yigal@plexistor.com> wrote:
> Before this patch, passing a range that is beyond the physical memory
> range will succeed, the user will see a /dev/pmem0 and will be able to
> access it. Reads will always return 0 and writes will be silently
> ignored.
>
> I've gotten more than one bug report about mkfs.{xfs,ext4} or nvml
> failing that were eventually tracked down to be wrong values passed to
> memmap.
>
> This patch prevents the above issue by instead of adding a new memory
> range, only update a RAM memory range with the PRAM type. This way,
> passing the wrong memmap will either not give you a pmem at all or give
> you a smaller one that actually has RAM behind it.
>
> And if someone still needs to fake a pmem that doesn't have RAM behind
> it, they can simply do memmap=XX@YY,XX!YY.
>
> Signed-off-by: Yigal Korman <yigal@plexistor.com>
> Acked-by: Dan Williams <dan.j.williams@intel.com>
> Acked-by: Johannes Thumshirn <jthumshirn@suse.de>
> Tested-by: Boaz Harrosh <boaz@plexistor.com>
> ---

I have some other libnvdimm fixes heading upstream shortly if x86
folks just want to ack this one...
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
